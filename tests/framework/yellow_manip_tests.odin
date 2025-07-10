package tests_framework

import "core:testing"
import p "../../src/framework"

@(test)
yellow_nido_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeyellow.gbc", "saves/yellow_nido.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "yellow_gfskip_intro0_title_cont_cont")

    // NOTE(stringflow): Nidoran
    testing.expect_value(t, p.gameboy_execute_path(gb, "URARU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 13)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 49)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xfaee)

    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)
    p.gameboy_clear_text(gb, {.B})
    p.gameboy_press(gb, {.A}, {}, {}, {}, {.A}, {.Start})

    // NOTE(stringflow): Route 2
    testing.expect_value(t, p.gameboy_execute_path(gb, "UULULLLLLUUU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Guard House
    testing.expect_value(t, p.gameboy_execute_path(gb, "URUUUUUAU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Viridian Forest
    testing.expect_value(t, p.gameboy_execute_path(gb, "URUURAURRRURRRARRUUUUUAUUULUUARRUUUUU"), p.OverworldResult.Overworld_Loop)
}

@(test)
yellow_pidgeotto_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeyellow.gbc", "saves/yellow_pidgeotto.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "yellow_gfskip_intro0_title_cont_cont")

    // NOTE(stringflow): Pidgeotto
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUDALUDLAU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 51)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 25)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 23)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 150)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 9)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0x6a3c)

    // NOTE(stringflow): Battle
    p.gameboy_clear_text(gb, {.B})
    turn := p.rby_do_move(gb)
    testing.expect_value(t, turn.first, p.WhoseTurn.Enemy)

    testing.expect_value(t, turn.enemy.move_used, 28)
    testing.expect_value(t, turn.enemy.max_hp - turn.enemy.hp, 12)
    testing.expect_value(t, turn.enemy.status.paralysis, false)
    
    testing.expect_value(t, turn.player.move_used, 84)
    testing.expect_value(t, turn.player.max_hp - turn.player.hp, 0)
    testing.expect_value(t, turn.player.accuracy_mod, 7)
}

@(test)
yellow_pidgey_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeyellow.gbc", "saves/yellow_pidgey.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "yellow_gfskip_intro0_title_cont_cont")

    // NOTE(stringflow): Start of Pidgey path
    testing.expect_value(t, p.gameboy_execute_path(gb, "UAUUUUULLLLLLS_BS_BALLLLLLLLDADDDADDADLALLALLUUUUUUUUUUUUULLLADDDADDDADDDDDDADDDDDDDLLLLLLALU"), p.OverworldResult.Overworld_Loop)
    
    no_enc_state := p.gameboy_save_state(gb)
    defer delete(no_enc_state)

    // NOTE(stringflow): Pidgey encounter ending
    testing.expect_value(t, p.gameboy_execute_path(gb, "AUU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 51)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 19)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 36)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0x39c2)

    hp_state := p.gameboy_save_state(gb)
    defer delete(hp_state)

    // NOTE(stringflow): Greenbar catch
    p.gameboy_cpu_write_16be(gb, "wPartyMon2HP", 20)
    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)

    // NOTE(stringflow): Redbar catch
    p.gameboy_load_state(gb, hp_state)
    p.gameboy_cpu_write_16be(gb, "wPartyMon2HP", 1)
    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)

    // NOTE(stringflow): No encounter ending
    p.gameboy_load_state(gb, no_enc_state)
    testing.expect_value(t, p.gameboy_execute_path(gb, "UU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 51)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 19)
}

@(test)
yellow_moon_no_mp_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeyellow.gbc", "saves/yellow_moon_no_mp.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)
    
    p.gameboy_execute_intro_sequence(gb, "yellow_gfskip_intro0_title_cont_cont")

    // NOTE(stringflow): Rare Candy
    testing.expect_value(t, p.gameboy_execute_path(gb, "UAUUUUUUUUAUUURRRARRRURUUUUUURARRDDDDDDDDDDDDRDDDDDRRRRRRURRR"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 34)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 31)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Moonstone
    testing.expect_value(t, p.gameboy_execute_path(gb, "RAUUUAUUUUUUULUUAUUUUUUUUAUULLUUUUULULLLLLLLDDDLLLLDLLLDDLDDDADDDDDLLLLLLLALLLUULULLUUUUUUULAUUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 3)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Warp to B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "DRRRD"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDDDDRDDDDRRRARRRARRRARRRRRR"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): B2F
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRUUURRRDDARRRRARRUAURARRARDADDDADDDDADDLLDDADDDADDALLLLLALLLALLLLLLLLLLLLLLLUUUUUAUUUUAUUAUUUURUUAUUAUUU"), p.OverworldResult.Overworld_Loop)
}