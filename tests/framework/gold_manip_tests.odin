package tests_framework

import "core:testing"
import p "../../src/framework"

@(test)
gold_fdff_decf_totodile :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_toto_4_3.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay11_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RS_BDA+RRDU"), p.OverworldResult.Overworld_Loop)
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
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xfdff)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay12_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RS_BDA+RRDU"), p.OverworldResult.Overworld_Loop)
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
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xdecf)
}

@(test)
gold_fdff_fdff_totodile :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_toto_4_2.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_fsback_cont_delay22_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDRRRA+DU"), p.OverworldResult.Overworld_Loop)
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
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xfdff)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 60)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_fsback_cont_delay23_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "DDRRRDU"), p.OverworldResult.Overworld_Loop)
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
    testing.expect_value(t, p.gameboy_cpu_read_16be(gb, "wPartyMon1DVs"), 0xfdff)
}

@(test)
gold_r29_pass1 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_r29_pass1.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay14_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDDLLDLLDLLDDLDLLLLLLLLLLULLUUURRUA+RRRUUUULULLLLLLLLLLLLLLUULLDLLA+DDLLLLA+LLLLA+LLLLLLLLLLLLLLLLLUULLLLULLLLLLLA+LLLUUUUA+UUUUUURRRRRRUUUUUUUUUUUUUUUUUURRUUUUUUUUUURRUURUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay15_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDLLLLLLDDDDA+DLDLLLLLLLLLLULLUUUUURRRRRUUUULLLLLLLLLLLLLLLUULLLLLDDA+DLLLLLLLA+LLLLLLLLLLLLLLLLLUULLLLUA+LLLLLLLA+LLLUUUUUUUUURRRRRRUUUUUUUUUUUUUUUUUUURRUUUUUUUUUURRUURUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 240)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay16_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDDLLLDDLDDLA+LLLLLLLDLLLLLUULLUUUURRRRRUUUULLLLLLLLLLLLLLLUULLLDLLA+DDLLLA+LLLLLLLLLLLLA+LLLLLLLLLULLLUULLLLLLLLLLLUUUUUUUUURRRRRRUUUUUUUUUUUURRUUUUUUUUUUUUUUUUURUURRUUUULUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 17)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 11)
}

@(test)
gold_r29_pass2 :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_r29_pass2.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay14_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDDLLDLLDLLDDLDLLLLLLLLLLULLUUURRUA+RRRUUUULULLLLLLLLLLLLLLUULLDLLA+DDLLLLA+LLLLA+LLLLLLLLLLLLLLLLLULA+LULLUA+LLA+LLLLLLLLUUUUUUUUURRRRRUUUUUUUUUUUUUUA+UUULLUULLA+LUUUULLA+U"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay15_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDLLLLLLDDDDA+DLDLLLLLLLLLLULLUUUUURRRRRUUUULLLLLLLLLLLLLLLUULLLLLDDA+DLLLLLLLA+LLLLLLLLLLLLLLLLLLLUUULA+LLLLLLA+LLLLA+LUUUUA+UUUUUURRRA+RRUUUUUUUUUUUUUUULLLLUUULUULLUA+UU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 480)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay16_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LLLLLA+LDDLLLDDLDDLA+LLLLLLLDLLLLLUULLUUUURRRRRUUUULLLLLLLLLLLLLLLUULLLDLLA+DDLLLA+LLLLLLLLLLLA+LLLLLLLLLLUUULLLLA+LLLLLLLLLLUUUUUUUUURURRRRUUUUUUUUUUUUUUUUUULLLLULUUA+LUA+LU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 1)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 25)
}

@(test)
gold_don :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_donnies.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay12_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LUUUUUUULUUUUA+URUUURURA+RRUUA+UURUUUUUUA+RRRRRUA+UUUULLLA+LLLLLLLLDLLLLDA+LLLLULLLLUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay13_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LUUUUUUULUUUUA+URUUURURA+RUURUUURUS_BUUURRRRRUUUUUULLLLLA+LLLLLLDLLLLLDA+LLA+LLUULLLU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay14_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LUUUUUUULUUUUA+URUUURURA+RUURUUUS_BRUUUURURRRRUA+UUUULLLLLLLLLLLDLLLLLDLLA+LLULUA+LLU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)

    // NOTE(stringflow): frame 4
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 600)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay15_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "LUUUUUUULUUUUA+URUUURURA+RRUURUUUS_BUUUUURRRRRUA+UUUULLLLLLLLLLLDLLLLLDLLLLLLLUUU"), p.OverworldResult.Overworld_Loop)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 26)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 2)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 9)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 9)
}

@(test)
gold_sandshrew :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc", "saves/gold_sandshrew.sav")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    // NOTE(stringflow): frame 1
    p.gameboy_set_rtc(gb, 1800)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay0_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RDDDA+DDA+LLDDLLLLDLLDDDDDLDDDDRDRRRRRRR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 29)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 15)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 27)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 27)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)

    // NOTE(stringflow): frame 2
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 1800)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay1_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RDDDA+DDA+LLDDLLLA+DLLLDDDS_BDDLDDDDRDRRRRRR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 29)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 14)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 27)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 27)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)

    // NOTE(stringflow): frame 3
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 1800)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay2_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RDDDA+DDA+LLDDLLLLLDLDDDDDLDDDDRRRRDRRRR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 29)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 15)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 27)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 27)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)

    // NOTE(stringflow): frame 4
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 1800)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay3_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RDDDA+DDA+LLDDLLS_BLLDLLDDDDDLDDDDRRRRRRDRR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 29)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 15)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 27)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 27)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)

    // NOTE(stringflow): frame 5
    p.gameboy_hard_reset(gb)
    p.gameboy_set_rtc(gb, 1800)
    p.gameboy_execute_intro_sequence(gb, "gold_gfskip_cont_delay4_cont")
    testing.expect_value(t, p.gameboy_execute_path(gb, "RDDDA+DDA+LLDDLLLLDLLDDDDDLDDDDDRRRRRS_BRR"), p.OverworldResult.Wild_Encounter)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapGroup"), 3)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wMapNumber"), 29)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wXCoord"), 14)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wYCoord"), 27)
    p.gameboy_run_until(gb, "CalcMonStats")
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonSpecies"), 27)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "wEnemyMonLevel"), 6)
}