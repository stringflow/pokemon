package tests_framework

import "core:testing"
import p "../../src/framework"

@(test)
crystal_ffff_ffef_totodile :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_toto_4_4.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay61_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DA+RRA+RUS_B"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 24)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 7)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 4)
    p.gameboy_press(gb, {.A}, {.B})
    p.gameboy_clear_text(gb, {.B})
    p.gameboy_press(gb, {.A})
    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wPartyMon1Species"), 158)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wPartyMon1Level"), 5)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xffff)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay62_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DA+RRA+RU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 24)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 7)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 4)
    p.gameboy_press(gb, {.A}, {.B})
    p.gameboy_clear_text(gb, {.B})
    p.gameboy_press(gb, {.A})
    p.gameboy_clear_text(gb, {.B})
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wPartyMon1Species"), 158)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wPartyMon1Level"), 5)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xffef)
}

@(test)
crystal_r29_pass1 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_r29_pass1.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLA+LLLULLLLLLLLLULLDLLA+LDLA+DLA+LLLLLLLLLLLLLLLLLLLLLLLUUULLLLLLLLLLLLLUUUUUUUUURRRRRUUUUURUUUUUUURRUUUUUUUUUUUUUUUUURUURRUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay3_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLLLLULA+LLLLLLLLULLDLLA+LDA+LDA+LLLLLLLLLLLLLLLLLLLLLLLLLLA+UUULLLLLLLLLLLUUUUUUUUURRRRRUUUUURUUUUUUUUUUURUURUUUUUUUUUUURUURRUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay4_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLUULLUUUURRRRRUUULLLULLLULLLLLLLLLULLLLA+LDDLLLA+LLLLA+LLLLLLLLLLLLLLLDLA+LLLLUUULLLLLLLLLLLUUUUUUUUURRRRRUUUUURUUUUUUUUUURURUUUUUUUUUUUUURRUURUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)
}

@(test)
crystal_r29_pass2 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_r29_pass2.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)
    
    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLA+LLLULLLLLLLLLULLDLLA+LDLA+DLA+LLLLLLLLLLLLLLLLLLLLLLLUA+UULLLLLLLLLLLLLUUUUUUUUURURRRRUUUUUUUUUUUUUUULLUULLLLUUUULUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay3_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLLLLULA+LLLLLLLLULLDLLA+LDA+LDA+LLLLLLLLLLLLLLLLLLLLLLA+LLLLLA+LUA+UULLLLLLLLLUUUUUUUUUURRRRRUUUUUUUUUUUUUA+UUUUULLLUULLULLUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay4_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLUULLUUUURRRRRUUULLLULLLULLLLLLLLLULLLLA+LDDLLLA+LLLLLLLLLLLLLLLLLLLDLLLLUULA+ULLLA+LLA+LLLLLA+LUUUUUUUUUURRRRRUUUUUUUUUUUUUUA+LUUUULLA+LUULULLUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)
}

@(test)
crystal_r29_pass2_crit :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_r29_pass2.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay1_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLDDLDDDDLLLLLLLDLLLLLLLLLUUUUUURRRRRUUUULLLLLLULLLLLLLLLULLDLA+LDA+DLLA+LLA+LLLLLLLLLLLLLLLLLLLLLLLLA+LLUUULLLLLLLLLUUUUUUUUUURRRRRUUUUUUUUUUUUUA+UUUUULLLUULLLUULUU"), p.OverworldResult.Textbox)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 24)
    p.gameboy_clear_text(gb, {.B})
    turn := p.gsc_do_move(gb)
    testing.expect_value(t, turn.first, p.WhoseTurn.Player)
    testing.expect_value(t, turn.enemy.hp, 0)
    testing.expect_value(t, turn.enemy.fainted, true)  
    testing.expect_value(t, turn.player.move_used, 10)
    testing.expect_value(t, turn.player.max_hp - turn.player.hp, 0)
    testing.expect_value(t, turn.player.critical, true)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLA+LLLULLLLLLLLLULLDLLA+LDLA+DLA+LLLLLLLLLLLLLLLLLLLLLLLLLLLULLLLLLUULLLUUUUUUUUUURRRRRUUUUUUUUUUUUULLUUUUULLULUULLUUU"), p.OverworldResult.Textbox)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 24)
    p.gameboy_clear_text(gb, {.B})
    turn = p.gsc_do_move(gb)
    testing.expect_value(t, turn.first, p.WhoseTurn.Player)
    testing.expect_value(t, turn.enemy.hp, 0)
    testing.expect_value(t, turn.enemy.fainted, true)  
    testing.expect_value(t, turn.player.move_used, 10)
    testing.expect_value(t, turn.player.max_hp - turn.player.hp, 0)
    testing.expect_value(t, turn.player.critical, true)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay3_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLLUULUUUURRRRRUUULULLLLLULA+LLLLLLLLULLDLLA+LDA+LDA+LLLLLLLLLLLLLLLLLLLLLLLLLLUUULLLLLLLLLLLUUUUUUUUUURRRRRUUUUUUUUUUUUULLLUUUUUULLUULLUUU"), p.OverworldResult.Textbox)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 24)
    p.gameboy_clear_text(gb, {.B})
    turn = p.gsc_do_move(gb)
    testing.expect_value(t, turn.first, p.WhoseTurn.Player)
    testing.expect_value(t, turn.enemy.hp, 0)
    testing.expect_value(t, turn.enemy.fainted, true)  
    testing.expect_value(t, turn.player.move_used, 10)
    testing.expect_value(t, turn.player.max_hp - turn.player.hp, 0)
    testing.expect_value(t, turn.player.critical, true)

    // NOTE(stringflow): frame 4
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay4_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLLLLLLDDDLDDLLDDLLLLLLLLLUULLUUUURRRRRUUULLLULLLULLLLLLLLLULLLLA+LDDLLLA+LLLLLLLLLLLLLLLLLLLDLLLLULLLLLLLLLULLLUUUUUUUUUURRRRRUUUUUUUUUUUUUUULLLLUUULLUUUULUUU"), p.OverworldResult.Textbox)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 24)
    p.gameboy_clear_text(gb, {.B})
    turn = p.gsc_do_move(gb)
    testing.expect_value(t, turn.first, p.WhoseTurn.Player)
    testing.expect_value(t, turn.enemy.hp, 0)
    testing.expect_value(t, turn.enemy.fainted, true)  
    testing.expect_value(t, turn.player.move_used, 10)
    testing.expect_value(t, turn.player.max_hp - turn.player.hp, 0)
    testing.expect_value(t, turn.player.critical, true)
}

@(test)
crystal_r30_75 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_r30_75.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay0_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUUUUULULUUUUUUURRRRRRUUUUUUUUURRRRRRUUUUUULLLLLLLLLLLDDLLLA+LLLLLUA+LLLUA+LU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay1_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUUUUULULUUUUUUURRRRRRUUUUUUUUURRRRRRUUUUUULLLLLLLLLLLDDLLLA+LLLLLUA+LLLUA+LU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "UUUUUUUULULUUUUUUURRRRRRUUUUUUUUURRRRRRUUUUUULLLLLLLLLLLDDLLLA+LLLLLUA+LLLUA+LU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)
}

@(test)
crystal_r32 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_r32.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay0_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDDDDDDLLDDDLLLLLLDDDLLDLLLDLDDLD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 29)
    p.gameboy_pickup_item(gb)
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDLDDDDDDDDLDDDDDDDA+DDDDDDDDDDRDDRRA+RDDDDDD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 67)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay1_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDDDDDDLLDDDLLLLLLDDDLLDLLLDLDDLD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 29)
    p.gameboy_pickup_item(gb)
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDLDDDDDDDDLDDDDDDDA+DDDDDDDDDDRDDRRA+RDDDDDD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 67)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDDDDDDLLDDDLLLLLLDDDLLDLLLDLDDLD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 29)
    p.gameboy_pickup_item(gb)
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDDDDLDDDDDDDDLDDDDDDDA+DDDDDDDDDDRDDRRA+RDDDDDD"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 67)
}

@(test)
crystal_raikou :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc", "saves/crystal_raikou.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 2400)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay11_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRSELRDDDDDDUA+DRLRDDDDDLS_BURRUUDUUDA+D"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 4)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 2)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 243)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 40)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xfd9e)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 2400)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay12_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRSELRDDDDDDUA+DRLRDDA+DDLUS_BRS_BRUD"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 4)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 2)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 243)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 40)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xfdbf)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 2400)
    p.gameboy_execute_intro_sequence(gb, "crystal_gfskip_cont_delay13_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RRRSELRDDDDDDUA+DRLRDDDDS_BDUULLLSELR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 10)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 4)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 6)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 2)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 243)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 40)
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wEnemyMonDVs"), 0xfdbf)
}