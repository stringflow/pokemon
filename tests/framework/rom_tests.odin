package tests_framework

import "core:testing"
import p "../../src/framework"

@(test)
determine_game_from_title_test :: proc(t: ^testing.T) {
    testing.expect_value(t, p.determine_game_from_title("POKEMON RED"), p.Game.Red)
    testing.expect_value(t, p.determine_game_from_title("POKEMON BLUE"), p.Game.Blue)
    testing.expect_value(t, p.determine_game_from_title("POKEMON YELLOW"), p.Game.Yellow)
    testing.expect_value(t, p.determine_game_from_title("POKEMON_GLDAAUE"), p.Game.Gold)
    testing.expect_value(t, p.determine_game_from_title("POKEMON_SLVAAXE"), p.Game.Silver)
    testing.expect_value(t, p.determine_game_from_title("PM_CRYSTALBYTE"), p.Game.Crystal)
    testing.expect_value(t, p.determine_game_from_title("test"), p.Game.None)
}

@(test)
rom_init_and_read_test :: proc(t: ^testing.T) {
    rom, err := p.rom_init("roms/pokered.gbc")
    testing.expect_value(t, err, nil)
    defer p.rom_destroy(rom)

    testing.expect_value(t, rom.sym["Joypad"], 0x19a)
    testing.expect_value(t, rom.sym["Tilesets"], 0x347be)
    testing.expect_value(t, rom.sym["hRandomAdd"], 0xffd3)
    testing.expect_value(t, rom.contents[rom.sym["MewBaseStats"]], 151)
}