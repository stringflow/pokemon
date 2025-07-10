package framework

import "core:os"
import "core:bytes"
import "core:strings"
import "core:path/filepath"
import "core:strconv"

BANK_SIZE :: 0x4000
NUM_PADDED_BANKS :: 0x100
PADDED_ROM_SIZE :: BANK_SIZE * 4 * NUM_PADDED_BANKS

ROM :: struct {
    contents: []u8,
    sym: map[string]int,
    sym_contents: []u8,
    game: Game,
}

ROM_Error :: enum {
    None = 0,
    IO_Error,
    Unsupported_Game,
    SYM_Parsing_Error,
}

Game :: enum {
    None = 0,
    Red,
    Blue,
    Yellow,
    Gold,
    Silver,
    Crystal,
}

is_gen1 :: proc(game: Game) -> bool {
    return game == .Red || game == .Blue || game == .Yellow
}

is_rb :: proc(game: Game) -> bool {
    return game == .Red || game == .Blue
}

is_gen2 :: proc(game: Game) -> bool {
    return game == .Gold || game == .Silver || game == .Crystal
}

is_gs :: proc(game: Game) -> bool {
    return game == .Gold || game == .Silver
}

rom_init :: proc(romfile: string) -> (rom: ROM, err: ROM_Error) {
    symfile, _ := strings.replace_all(romfile, filepath.ext(romfile), ".sym")
    defer delete(symfile)

    rom.contents = pad_rom(romfile) or_return
    rom.sym_contents, rom.sym = parse_symbols(symfile) or_return
    rom.game = determine_game_from_title(string(rom.contents[0x134:0x143]))

    if rom.game == .None {
        return rom, .Unsupported_Game
    }

    return
}

rom_destroy :: proc(rom: ROM) {
    delete(rom.contents)
    delete(rom.sym)
    delete(rom.sym_contents)
}

pad_rom :: proc(romfile: string) -> (padded_rom: []byte, err: ROM_Error) {
    contents, success := os.read_entire_file(romfile)
    if !success do return nil, ROM_Error.IO_Error
    defer delete(contents)

    buf: bytes.Buffer
    bytes.buffer_init_allocator(&buf, 0, PADDED_ROM_SIZE)
    defer bytes.buffer_destroy(&buf)
    
    src_banks := len(contents) / BANK_SIZE
    for bank in 0..<NUM_PADDED_BANKS {
        offset := (bank % src_banks) * BANK_SIZE
        bytes.buffer_write(&buf, contents[0:BANK_SIZE])
        bytes.buffer_write(&buf, contents[offset:offset+BANK_SIZE])
        for _ in 0..<BANK_SIZE do bytes.buffer_write_byte(&buf, 0xff)
        for _ in 0..<BANK_SIZE do bytes.buffer_write_byte(&buf, 0x00)
    }

    padded_rom = bytes.clone(buf.buf[:])
    return
}

parse_symbols :: proc(symfile: string) -> (contents: []u8, symbols: map[string]int, err: ROM_Error) {
    success: bool
    contents, success = os.read_entire_file(symfile)
    if !success do return nil, nil, ROM_Error.IO_Error

    symbols = make(map[string]int)

    it := string(contents)
    for line in strings.split_lines_iterator(&it) {
        if strings.starts_with(line, ";") do continue

        bank := strconv.parse_int(line[0:2], 16) or_continue
        addr := strconv.parse_int(line[3:7], 16) or_continue
        label := line[8:]

        symbols[label] = (int(bank) << 16 | int(addr))
    }

    return
}

determine_game_from_title :: proc(title: string) -> (game: Game)  {
    if strings.starts_with(title, "POKEMON RED") do return .Red
    else if strings.starts_with(title, "POKEMON BLUE") do return .Blue
    else if strings.starts_with(title, "POKEMON YELLOW") do return .Yellow
    else if strings.starts_with(title, "POKEMON_GLD") do return .Gold
    else if strings.starts_with(title, "POKEMON_SLV") do return .Silver
    else if strings.starts_with(title, "PM_CRYSTAL") do return .Crystal
    else do return .None
}