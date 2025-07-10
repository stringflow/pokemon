package gambatte

import "core:c"

foreign import libgambatte "libgambatte.so"

InputGetter :: proc "c" (p: rawptr) -> u8

LoadFlag :: enum c.int {
    CGB_Mode,
    GBA_Flag,
    Multi_Compat,
    SGB_Mode,
    ReadOnly_SAV,
    No_BIOS,
    VC_Flag,
}

LoadFlags :: bit_set[LoadFlag; c.int]

RomLoadRes :: enum c.int {
	Bad_File_Or_Unknown_MBC = -0x7FFF,
	IO_Error,
	Unsupported_MBC_HUC3  = -0x1FE,
	Unsupported_MBC_Tama5,
	Unsupported_MBC_Pocket_Camera,
	Unsupported_MBC_MBC7 = -0x122,
	Unsupported_MBC_MBC6 = -0x120,
	Unsupported_MBC_MBC4  = -0x117,
	Unsupported_MBC_MMM01 = -0x10D,
	Ok = 0,
}

BiosLoadRes :: enum c.int {
    Ok = 0,
	IO_Error = -1,
    Size_Mismatch = -2,
    Crc_Mismatch = -3,
}

SpeedupFlag :: enum c.int {
    None = 0,
    No_Sound,
    No_PPU_Call,
    No_Video,
}

SpeedupFlags :: bit_set[SpeedupFlag; c.int]

@(default_calling_convention="c", link_prefix="gambatte_")
foreign libgambatte {
    revision :: proc() -> (revision: int) ---
    create :: proc() -> (g: rawptr) ---
    destroy :: proc(g: rawptr) ---
    load :: proc(g: rawptr, romfile: cstring, flags: LoadFlags) -> (status: RomLoadRes) ---
    loadbios :: proc(g: rawptr, biosfile: cstring, size: c.int, crc: c.int) -> (status: BiosLoadRes) ---
    runfor :: proc(g: rawptr, video_buf: [^]u8, pitch: c.int, audio_buf: [^]u8, samples: ^u64) -> (sample_offset: c.int) ---
    setrtcdivisoroffset :: proc(g: rawptr, rtc_divisor_offset: int) ---
    reset :: proc(g: rawptr, samples_to_stall: c.int) ---
    setinputgetter :: proc(g: rawptr, get_input: InputGetter, p: rawptr) ---
    savestate :: proc(g: rawptr, video_buf: [^]u8, pitch: c.int, stat_buf: [^]u8) -> (size: c.int) ---
    loadstate :: proc(g: rawptr, stat_buf: [^]u8, size: c.int) -> (success: bool) ---
    cpuread :: proc(g: rawptr, addr: u16) -> (val: u8) ---
    cpuwrite :: proc(g: rawptr, addr: u16, val: u8) ---
    getregs :: proc(g: rawptr, dest: [^]c.int) ---
    setregs :: proc(g: rawptr, src: [^]c.int) ---
    setinterruptaddresses :: proc(g: rawptr, addrs: [^]c.int, num_addrs: c.int) ---
    gethitinterruptaddress :: proc(g: rawptr) -> (hit_address: c.int) ---
    timenow :: proc(g: rawptr) -> (timestamp: c.int) ---
    getdivstate :: proc(g: rawptr) -> (div_state: int) ---
    setspeedupflags :: proc(g: rawptr, flags: SpeedupFlags) ---
}