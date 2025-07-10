package framework

import "gambatte"
import "core:c"
import "core:os"
import "core:slice"
import "core:strings"
import "core:encoding/endian"

VIDEO_WIDTH :: 160
VIDEO_HEIGHT :: 144
VIDEO_SIZE :: VIDEO_WIDTH * VIDEO_HEIGHT * 4

AUDIO_SAMPLE_SIZE :: 4
AUDIO_SAMPLES_PER_FRAME :: 35112
AUDIO_SAMPLES_OVERHEAD :: 2064
AUDIO_SIZE :: (AUDIO_SAMPLES_PER_FRAME + AUDIO_SAMPLES_OVERHEAD) * AUDIO_SAMPLE_SIZE

// NOTE(stringflow): The max number of frames gameboy_run_until can run before recognizing the state as a dead lock and panicing.
// This check is disabled in optimized builds.
DEBUG_RUN_UNTIL_TIMEOUT_FRAMES :: 10000

Button :: enum u8 {
    A,
    B,
    Select,
    Start,
    Right,
    Left,
    Up,
    Down,
}

Buttons :: bit_set[Button; u8]

Load_Error :: union #shared_nil {
    Gambatte_Error,
    ROM_Error,
    SAV_Error,
}

Gambatte_Error :: enum {
    None = 0,
    IO_Error,
    Size_Mismatch,
    Crc_Mismatch,
    Bad_File,
    Unsupported_MBC,
}

SAV_Error :: enum {
    None = 0,
    IO_Error,
    Bad_State,
}

GameBoy :: struct {
    g: rawptr,
    rom: ROM,
    video_buffer: []byte,
    audio_buffer: []byte,
    frame_overflow: u64,
    samples_emulated: u64,
    video_frame_done: bool,
    speedup_flags: gambatte.SpeedupFlags,
    buttons: Buttons,
    breakpoint_buffer: [dynamic]c.int,
    state_size: c.int,
    state_buf: []u8,
    state_field_offsets: map[string]int,
    recorder: Recorder,
}

Registers :: struct {
    pc: int,
    sp: int,
    a: int,
    b: int,
    c: int,
    d: int,
    e: int,
    f: int,
    h: int,
    l: int,
}

@(private)
input_getter :: proc "c" (gb: rawptr) -> (buttons: u8) {
    return transmute(u8)(((^GameBoy)(gb)).buttons)
}

gameboy_init :: proc(biosfile: string, romfile: string, savfile: string = "", load_flags: gambatte.LoadFlags = {.ReadOnly_SAV, .GBA_Flag, .CGB_Mode}) -> (gb: ^GameBoy, err: Load_Error) {
    g := gambatte.create()

    biosfile_cstring := strings.clone_to_cstring(biosfile)
    defer delete(biosfile_cstring)
    bios_res := gambatte.loadbios(g, biosfile_cstring, 0, 0)
    if bios_res != gambatte.BiosLoadRes.Ok {
        gambatte.destroy(g)

        switch bios_res {
            case .IO_Error: return gb, Gambatte_Error.IO_Error
            case .Size_Mismatch: return gb, Gambatte_Error.Size_Mismatch
            case .Crc_Mismatch: return gb, Gambatte_Error.Crc_Mismatch
            case .Ok: unreachable()
        }
    }

    romfile_cstring := strings.clone_to_cstring(romfile)
    defer delete(romfile_cstring)
    rom_res := gambatte.load(g, romfile_cstring, load_flags)
    if rom_res != gambatte.RomLoadRes.Ok {
        gambatte.destroy(g)

        switch rom_res {
            case .IO_Error: return gb, Gambatte_Error.IO_Error
            case .Bad_File_Or_Unknown_MBC: return gb, Gambatte_Error.Bad_File
            case .Unsupported_MBC_HUC3, .Unsupported_MBC_Tama5, .Unsupported_MBC_Pocket_Camera, 
                 .Unsupported_MBC_MBC7, .Unsupported_MBC_MBC6, .Unsupported_MBC_MBC4,
                 .Unsupported_MBC_MMM01: return gb, Gambatte_Error.Unsupported_MBC
            case .Ok: unreachable()
        }
    }

    gb = new(GameBoy)
    gb.g = g
    gb.rom = rom_init(romfile) or_return
    gb.video_buffer = make([]byte, VIDEO_SIZE)
    gb.audio_buffer = make([]byte, AUDIO_SIZE)
    gb.frame_overflow = 0
    gb.samples_emulated = 0
    gb.speedup_flags = {}
    gb.buttons = {}
    gb.breakpoint_buffer = make([dynamic]c.int, 0, 16)
    gb.state_size = gambatte.savestate(gb.g, nil, VIDEO_WIDTH, nil)

    gambatte.setinputgetter(gb.g, input_getter, gb)
    gameboy_find_state_fields(gb)

    if savfile != "" {
        gameboy_overwrite_sram(gb, savfile) or_return
    }
    
    return
}

gameboy_destroy :: proc(gb: ^GameBoy) {
    gambatte.destroy(gb.g)
    rom_destroy(gb.rom)
    delete(gb.video_buffer)
    delete(gb.audio_buffer)
    delete(gb.breakpoint_buffer)
    delete(gb.state_buf)
    delete(gb.state_field_offsets)
    free(gb)
}

gameboy_run_for :: proc(gb: ^GameBoy, samples: u64, buttons: Buttons = {}) {
    gb.buttons = buttons
    run_samples := samples
    offset := gambatte.runfor(gb.g, raw_data(gb.video_buffer), VIDEO_WIDTH, raw_data(gb.audio_buffer), &run_samples)
    gb.buttons = transmute(Buttons)(u8(0))

    gb.video_frame_done = offset >= 0
    gb.frame_overflow += run_samples
    gb.samples_emulated += run_samples
    
    if gb.video_frame_done || gb.frame_overflow >= AUDIO_SAMPLES_PER_FRAME {
        gb.frame_overflow = 0
    }

    if gb.recorder.is_recording {
        recorder_submit(&gb.recorder, gb.video_frame_done ? gb.video_buffer : nil, gb.audio_buffer[:run_samples*4], gb.samples_emulated)
    }
}

gameboy_step :: proc(gb: ^GameBoy, buttons: Buttons = {}) {
    gameboy_run_for(gb, 1, buttons)
}

gameboy_advance_frame :: proc(gb: ^GameBoy, buttons: Buttons = {}) {
    gameboy_run_for(gb, AUDIO_SAMPLES_PER_FRAME - gb.frame_overflow, buttons)
}

gameboy_advance_frames :: proc(gb: ^GameBoy, amount: int, buttons: Buttons = {}) {
    for _ in 0..<amount do gameboy_advance_frame(gb, buttons)
}

gameboy_run_until :: proc {
    gameboy_run_until_symbol,
    gameboy_run_until_symbols,
    gameboy_run_until_address,
    gameboy_run_until_addresses,
}

gameboy_run_until_symbol :: proc (gb: ^GameBoy, symbol: string, buttons: Buttons = {}) -> (hit_address: int) {
    return gameboy_run_until_symbols(gb, {symbol}, buttons)
}

gameboy_run_until_symbols :: proc(gb: ^GameBoy, symbols: []string, buttons: Buttons = {}) -> (hit_address: int) {
    clear(&gb.breakpoint_buffer)
    for symbol in symbols {
        append(&gb.breakpoint_buffer, c.int(gb.rom.sym[symbol]))
    }

    return gameboy_run_until_breakpoints(gb, buttons)
}

gameboy_run_until_address :: proc (gb: ^GameBoy, address: int, buttons: Buttons = {}) -> (hit_address: int) {
    return gameboy_run_until_addresses(gb, {address}, buttons)
}

gameboy_run_until_addresses :: proc(gb: ^GameBoy, addresses: []int, buttons: Buttons = {}) -> (hit_address: int) {
    clear(&gb.breakpoint_buffer)
    for address in addresses {
        append(&gb.breakpoint_buffer, c.int(address))
    }

    return gameboy_run_until_breakpoints(gb, buttons)
}

@(private)
gameboy_run_until_breakpoints :: proc(gb: ^GameBoy, buttons: Buttons = {}) -> (hit_address: int) {
    gambatte.setinterruptaddresses(gb.g, raw_data(gb.breakpoint_buffer[:]), c.int(len(gb.breakpoint_buffer)))

    frames_ran := 0

    addr: c.int
    for {
        gameboy_advance_frame(gb, buttons)
        addr = gambatte.gethitinterruptaddress(gb.g)

        when ODIN_OPTIMIZATION_MODE <= .Minimal {
            frames_ran += 1
            if frames_ran >= DEBUG_RUN_UNTIL_TIMEOUT_FRAMES {
                panic("gameboy_run_until timeout reached!")
            }
        }

        if slice.contains(gb.breakpoint_buffer[:], addr) do break
    }

    gambatte.setinterruptaddresses(gb.g, nil, 0)
    return int(addr)
}

gameboy_hard_reset :: proc(gb: ^GameBoy, fade: bool = false) {
    gambatte.reset(gb.g, fade ? 101 * (2 << 14) : 0)
}

gameboy_cpu_read :: proc {
    gameboy_cpu_read_symbol,
    gameboy_cpu_read_address,
}

@(private)
gameboy_cpu_read_symbol :: proc(gb: ^GameBoy, symbol: string) -> (val: u8) {
    return gameboy_cpu_read_address(gb, gb.rom.sym[symbol])
}

@(private)
gameboy_cpu_read_address :: proc(gb: ^GameBoy, addr: int) -> (val: u8) {
    return gambatte.cpuread(gb.g, u16(addr))
}

gameboy_cpu_read_16be :: proc {
    gameboy_cpu_read_16be_symbol,
    gameboy_cpu_read_16be_address,
}

@(private)
gameboy_cpu_read_16be_symbol :: proc(gb: ^GameBoy, symbol: string) -> (val: u16) {
    return gameboy_cpu_read_16be_address(gb, gb.rom.sym[symbol])
}

@(private)
gameboy_cpu_read_16be_address :: proc(gb: ^GameBoy, addr: int) -> (val: u16) {
    return (u16(gambatte.cpuread(gb.g, u16(addr))) << 8) | u16(gambatte.cpuread(gb.g, u16(addr+1)))
}

gameboy_cpu_read_16le :: proc {
    gameboy_cpu_read_16le_symbol,
    gameboy_cpu_read_16le_address,
}

@(private)
gameboy_cpu_read_16le_symbol :: proc(gb: ^GameBoy, symbol: string) -> (val: u16) {
    return gameboy_cpu_read_16le_address(gb, gb.rom.sym[symbol])
}

@(private)
gameboy_cpu_read_16le_address :: proc(gb: ^GameBoy, addr: int) -> (val: u16) {
    return u16(gambatte.cpuread(gb.g, u16(addr))) | (u16(gambatte.cpuread(gb.g, u16(addr+1))) << 8)
}

gameboy_cpu_write :: proc {
    gameboy_cpu_write_symbol,
    gameboy_cpu_write_address,
}

@(private)
gameboy_cpu_write_symbol :: proc(gb: ^GameBoy, symbol: string, val: u8) {
    gameboy_cpu_write_address(gb, gb.rom.sym[symbol], val)
}

@(private)
gameboy_cpu_write_address :: proc(gb: ^GameBoy, addr: int, val: u8) {
    gambatte.cpuwrite(gb.g, u16(addr), val)
}

gameboy_cpu_write_16be :: proc {
    gameboy_cpu_write_16be_symbol,
    gameboy_cpu_write_16be_address,
}

@(private)
gameboy_cpu_write_16be_symbol :: proc(gb: ^GameBoy, symbol: string, val: u16) {
    gameboy_cpu_write_16be_address(gb, gb.rom.sym[symbol], val)
}

@(private)
gameboy_cpu_write_16be_address :: proc(gb: ^GameBoy, addr: int, val: u16) {
    gambatte.cpuwrite(gb.g, u16(addr), u8(val >> 8))
    gambatte.cpuwrite(gb.g, u16(addr + 1), u8(val))
}

gameboy_cpu_write_16le :: proc {
    gameboy_cpu_write_16le_symbol,
    gameboy_cpu_write_16le_address,
}

@(private)
gameboy_cpu_write_16le_symbol :: proc(gb: ^GameBoy, symbol: string, val: u16) {
    gameboy_cpu_write_16le_address(gb, gb.rom.sym[symbol], val)
}

@(private)
gameboy_cpu_write_16le_address :: proc(gb: ^GameBoy, addr: int, val: u16) {
    gambatte.cpuwrite(gb.g, u16(addr), u8(val))
    gambatte.cpuwrite(gb.g, u16(addr + 1), u8(val >> 8))
}

gameboy_get_registers :: proc(gb: ^GameBoy) -> (registers: Registers) {
    regs: [10]c.int
    gambatte.getregs(gb.g, raw_data(regs[:]))
    registers.pc = int(regs[0])
    registers.sp = int(regs[1])
    registers.a = int(regs[2])
    registers.b = int(regs[3])
    registers.c = int(regs[4])
    registers.d = int(regs[5])
    registers.e = int(regs[6])
    registers.f = int(regs[7])
    registers.h = int(regs[8])
    registers.l = int(regs[9])
    return
}

gameboy_set_registers :: proc(gb: ^GameBoy, regs: Registers) {
    regs := []c.int{
        c.int(regs.pc), 
        c.int(regs.sp), 
        c.int(regs.a), 
        c.int(regs.b), 
        c.int(regs.c), 
        c.int(regs.d), 
        c.int(regs.e), 
        c.int(regs.f), 
        c.int(regs.h), 
        c.int(regs.l),
    }
    gambatte.setregs(gb.g, raw_data(regs))
}

gameboy_save_state :: proc {
    gameboy_save_state_alloc,
    gameboy_save_state_buf,
}

gameboy_save_state_buf :: proc(gb: ^GameBoy, state: []u8) {
    gambatte.savestate(gb.g, nil, VIDEO_WIDTH, raw_data(state))
}

gameboy_save_state_alloc :: proc(gb: ^GameBoy) -> (state: []u8) {
    state = make([]u8, gb.state_size)
    gameboy_save_state_buf(gb, state)
    return
}

gameboy_save_state_to_disk :: proc(gb: ^GameBoy, path: string) -> (ok: bool) {
    state := gameboy_save_state(gb)
    defer delete(state)

    return os.write_entire_file(path, state)
}

gameboy_save_state_to_buf :: proc(gb: ^GameBoy, path: string) -> (ok: bool) {
    state := gameboy_save_state(gb)
    defer delete(state)

    return os.write_entire_file(path, state)
}

gameboy_load_state :: proc(gb: ^GameBoy, state: []u8) -> (ok: bool) {
    return gambatte.loadstate(gb.g, raw_data(state), c.int(len(state)))
}

gameboy_load_state_from_disk :: proc(gb: ^GameBoy, path: string) -> (ok: bool) {
    state := os.read_entire_file(path) or_return
    defer delete(state)

    return gameboy_load_state(gb, state)
}

gameboy_enable_speedupflag :: proc(gb: ^GameBoy, flags: gambatte.SpeedupFlags) {
    gb.speedup_flags |= flags
    gambatte.setspeedupflags(gb.g, gb.speedup_flags)
}

gameboy_disable_speedupflag :: proc(gb: ^GameBoy, flags: gambatte.SpeedupFlags) {
    gb.speedup_flags &= ~flags
    gambatte.setspeedupflags(gb.g, gb.speedup_flags)
}

gameboy_set_rtc_divisor_offset :: proc(gb: ^GameBoy, offset: int) {
    gambatte.setrtcdivisoroffset(gb.g, offset)
}

gameboy_timestamp :: proc(gb: ^GameBoy) -> (timestamp: u64) {
    return u64(gambatte.timenow(gb.g))
}

gameboy_start_recording :: proc(gb: ^GameBoy) {
    if gb.recorder.is_recording do return
    recorder_start(&gb.recorder, gb.samples_emulated)
}

gameboy_stop_recording :: proc(gb: ^GameBoy, filename: string) {
    if !gb.recorder.is_recording do return
    recorder_stop(&gb.recorder, filename)
}

gameboy_overwrite_sram :: proc(gb: ^GameBoy, savfile: string) -> (err: SAV_Error) {
    sram, ok := os.read_entire_file(savfile)
    if !ok {
        return .IO_Error,
    }
    defer delete(sram)

    gameboy_save_state(gb, gb.state_buf)
    copy(gb.state_buf[gb.state_field_offsets["sram"]:], sram[0:0x8000])
    ok = gameboy_load_state(gb, gb.state_buf)
    
    if !ok {
        err = .Bad_State
    }

    return
}

gameboy_set_rtc :: proc(gb: ^GameBoy, total_seconds: int) -> (ok: bool) {
    gameboy_save_state(gb, gb.state_buf)

    cc := endian.unchecked_get_u32be(gb.state_buf[gb.state_field_offsets["cc"]:])
    endian.unchecked_put_u32be(gb.state_buf[gb.state_field_offsets["timelc"]:], cc)
    endian.unchecked_put_u32be(gb.state_buf[gb.state_field_offsets["timesec"]:], u32(total_seconds))
    
    return gameboy_load_state(gb, gb.state_buf)
}

@(private)
gameboy_find_state_fields :: proc(gb: ^GameBoy) {
    state := gameboy_save_state(gb)
    
    gb.state_buf = state
    gb.state_field_offsets = make(map[string]int)

    pos := 6

    for pos < len(state) {
        name_start := pos
        for state[pos] != 0 {
            pos += 1
        }

        label := string(state[name_start:pos])
        pos += 1

        size := (int(state[pos + 0]) << 16) | (int(state[pos + 1]) << 8) | (int(state[pos + 2]))
        pos += 3

        gb.state_field_offsets[label] = pos
        pos += size
    }
}