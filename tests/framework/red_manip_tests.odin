package tests_framework

import "core:testing"
import p "../../src/framework"

@(test)
red_triple_extended_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokered.gbc", "saves/red_nido.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "red_nopal_gfskip_hop0_title0_cont_cont")

    // NOTE(stringflow): Nidoran
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLULLUAULALDLDLLDADDADLALLALUUAU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 33)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 33)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 4)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xffef)

    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)
    p.gameboy_clear_text(gb, {.B})
    p.gameboy_press(gb, {.A}, {}, {}, {}, {.A}, {.Start})

    // NOTE(stringflow): Pidgey
    testing.expect_value(t, p.gameboy_execute_path(gb, "DRRUUURRRRRRRRRRRRRRRRRRRRRURUUUUUURUUAUULUUUAUUUUUUUUUUUUUUAUULLLUUUUUUURRRRUAUUU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 13)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 8)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 48)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 36)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 5)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0x02a1)

    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)
    p.gameboy_clear_text(gb, {.A})
    p.gameboy_press(gb, {.B})

    // NOTE(stringflow): Route 2
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUULLLLLU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Guard House
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUURUU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Potion
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUAUURUARRRRRRRUUUUUUUUUUUAUUAUUUUUUUUUUUUUUUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 51)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 25)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 12)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Weedle Trainer
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUULLLLLLLLDDDDDDDLLLLUUUUUUUUUUUUULLLLLLDDDDDDDDDDDDDDDDDDLDLLLLUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 51)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 19)
}

@(test)
red_route3_moon_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokered.gbc", "saves/red_moon_route3.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "red_pal(hold)_gfskip_hop0_title0_cont_cont")

    // NOTE(stringflow): Route 3
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRRRRRRURRUUUUUARRRRRRRRRRRRDDDDDRRRRRRRARUURRUUUUUUUUUURRRRUUUUUUUUUURRRRRU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Water Gun
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUUULLLLLALLLLDD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 31)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Rare Candy
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRRUURRRARRUUUUUUURRRRRRRAUUUUUUURRRDRDDDDDDDADDDDDDDDADRRRRRURRRR"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 34)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 31)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Escape Rope
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUUUUUR"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 35)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 23)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Warp to B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "ULUUUUUAUUUUUULLLUUUUUUUULLLLLLDDLALLLLLLLDDDDDD"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "LALLALLALLALDD"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Mega Punch
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRUUULAUR"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 61)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 28)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 5)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Warp to B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDADLALLAD"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "RARRARRARRARUU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Moonstone
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDLDDDDLLLLLLLULUUUUULUUUUUUUULLLUL"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 59)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 2)
    p.gameboy_pickup_item(gb)

    // NOTE(stringflow): Warp to B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "DADDRAR"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): B1F
    testing.expect_value(t, p.gameboy_execute_path(gb, "DRRDDDDDDDDDDRRRARRRRRRRRRRDR"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): Paras
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRUUURARRRDDRRRRRUARURARRDDDDDDDDALLLLDDDDDDDADDLLLALLLLLLLLLLLLALLLLLLUUUUAUUALUUUUUUUU"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 61)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 109)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 10)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xf6ea)

    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.rby_throw_ball(gb), true)
}

@(test)
red_cans_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokered.gbc", "saves/red_cans.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    p.gameboy_execute_intro_sequence(gb, "red_nopal_gfskip_hop0_title0_cont_cont")
    // NOTE(stringflow): Enter gym
    testing.expect_value(t, p.gameboy_execute_path(gb, "DALLLAU"), p.OverworldResult.Overworld_Loop)
    // NOTE(stringflow): First can
    testing.expect_value(t, p.gameboy_execute_path(gb, "RUUUUU"), p.OverworldResult.Overworld_Loop)
    p.gameboy_press(gb, {.A})
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wCurMap"), 92)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 12)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wFirstLockTrashCanIndex"), 8)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wSecondLockTrashCanIndex"), 5)
}