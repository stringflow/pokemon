package tests_framework

import "core:testing"
import p "../../src/framework"

execute_tid :: proc(gb: ^p.GameBoy, intro_sequence: string) -> (tid: u16) {
    p.gameboy_hard_reset(gb)
    p.gameboy_execute_intro_sequence(gb, intro_sequence)
    p.gameboy_advance_frames(gb, 35, {.A})

    return p.gameboy_cpu_read_16be(gb, "wPlayerID")
}

@(test)
red_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokered.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title0_newgame"), 0xa7cb)
    testing.expect_value(t, execute_tid(gb, "red_pal_gfskip_hop0_title0_newgame"), 0xb5b8)
    testing.expect_value(t, execute_tid(gb, "red_nopal(ab)_gfskip_hop0_title0_newgame"), 0x88e9)
    testing.expect_value(t, execute_tid(gb, "red_pal(hold)_gfskip_hop0_title0_newgame"), 0x9bd5)
    testing.expect_value(t, execute_tid(gb, "red_pal(ab)_gfskip_hop0_title0_newgame"), 0x91e1)
    testing.expect_value(t, execute_tid(gb, "red_pal(rel)_gfskip_hop0_title0_newgame"), 0xabc0)

    testing.expect_value(t, execute_tid(gb, "red_nopal_gfwait_hop0_title0_newgame"), 0x25b3)
    
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop1_title0_newgame"), 0x4b9c)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop2_title0_newgame"), 0xec47)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop3_title0_newgame"), 0x56b1)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop4_title0_newgame"), 0x687a)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop5_title0_newgame"), 0x7656)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop6_title0_newgame"), 0x97c7)

    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title0(scroll)_newgame"), 0xf93e)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title1(scroll)_newgame"), 0x32f9)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title10(scroll)_newgame"), 0xf0c0)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title1_newgame"), 0xbc9b)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title2_newgame"), 0xddac)
    testing.expect_value(t, execute_tid(gb, "red_nopal_gfskip_hop0_title10_newgame"), 0x2cb6)
}

@(test)
blue_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeblue.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)
    
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title0_newgame"), 0xac3f)
    testing.expect_value(t, execute_tid(gb, "blue_pal_gfskip_hop0_title0_newgame"), 0xc12a)
    testing.expect_value(t, execute_tid(gb, "blue_nopal(ab)_gfskip_hop0_title0_newgame"), 0x945e)
    testing.expect_value(t, execute_tid(gb, "blue_pal(hold)_gfskip_hop0_title0_newgame"), 0xa348)
    testing.expect_value(t, execute_tid(gb, "blue_pal(ab)_gfskip_hop0_title0_newgame"), 0x9d52)
    testing.expect_value(t, execute_tid(gb, "blue_pal(rel)_gfskip_hop0_title0_newgame"), 0xb736)

    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfwait_hop0_title0_newgame"), 0x0567)
    
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop1_title0_newgame"), 0x97d0)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop2_title0_newgame"), 0x6743)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop3_title0_newgame"), 0xabdb)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop4_title0_newgame"), 0x7ef0)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop5_title0_newgame"), 0x1038)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop6_title0_newgame"), 0xbb29)

    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title0(scroll)_newgame"), 0xcaf4)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title1(scroll)_newgame"), 0x321d)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title10(scroll)_newgame"), 0xb0c8)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title1_newgame"), 0xb7d1)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title2_newgame"), 0xa062)
    testing.expect_value(t, execute_tid(gb, "blue_nopal_gfskip_hop0_title10_newgame"), 0xa0ff)
}

@(test)
yellow_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokeyellow.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)
    
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro0_title_newgame"), 0x046e)
    testing.expect_value(t, execute_tid(gb, "yellow_gfwait_intro0_title_newgame"), 0xb535)

    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro1_title_newgame"), 0x4261)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro2_title_newgame"), 0x1fcc)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro3_title_newgame"), 0xd3c3)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro4_title_newgame"), 0x6b98)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro5_title_newgame"), 0xe5f1)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_intro6_title_newgame"), 0xd82a)
    testing.expect_value(t, execute_tid(gb, "yellow_gfskip_introwait_title_newgame"), 0xe24e)
}

@(test)
gold_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokegold.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    testing.expect_value(t, execute_tid(gb, "gold_gfskip_newgame"), 0xc9ff)
    testing.expect_value(t, execute_tid(gb, "gold_intro0_newgame"), 0xae77)
    testing.expect_value(t, execute_tid(gb, "gold_intro0(lcd)_newgame"), 0xb472)
    testing.expect_value(t, execute_tid(gb, "gold_intro1_newgame"), 0xd6f4)
    testing.expect_value(t, execute_tid(gb, "gold_intro2_newgame"), 0xdab8)
    testing.expect_value(t, execute_tid(gb, "gold_gfwait_newgame"), 0x2978)

    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait1_newgame"), 0x9976)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait2_newgame"), 0x4211)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait10_newgame"), 0x6923)

    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait1(opt)_newgame"), 0x51a6)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait2(opt)_newgame"), 0x94bc)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait10(opt)_newgame"), 0x4b2b)

    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait1(setopt)_newgame"), 0x8386)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait2(setopt)_newgame"), 0x6bf7)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_wait10(setopt)_newgame"), 0xe99e)

    testing.expect_value(t, execute_tid(gb, "gold_gfskip_backout1_newgame"), 0x7735)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_backout2_newgame"), 0xd4bc)
    testing.expect_value(t, execute_tid(gb, "gold_gfskip_backout10_newgame"), 0xae08)
}

@(test)
silver_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokesilver.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    testing.expect_value(t, execute_tid(gb, "silver_gfskip_newgame"), 0x0fc0)
    testing.expect_value(t, execute_tid(gb, "silver_intro0_newgame"), 0x1618)
    testing.expect_value(t, execute_tid(gb, "silver_intro0(lcd)_newgame"), 0x1a12)
    testing.expect_value(t, execute_tid(gb, "silver_intro1_newgame"), 0x9e36)
    testing.expect_value(t, execute_tid(gb, "silver_intro2_newgame"), 0x2474)
    testing.expect_value(t, execute_tid(gb, "silver_gfwait_newgame"), 0x8c22)

    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait1_newgame"), 0xa76e)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait2_newgame"), 0x1940)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait10_newgame"), 0x8608)

    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait1(opt)_newgame"), 0x8b6a)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait2(opt)_newgame"), 0x8bc4)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait10(opt)_newgame"), 0x96db)

    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait1(setopt)_newgame"), 0xaf57)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait2(setopt)_newgame"), 0x530d)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_wait10(setopt)_newgame"), 0x295c)

    testing.expect_value(t, execute_tid(gb, "silver_gfskip_backout1_newgame"), 0x3f80)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_backout2_newgame"), 0x5d54)
    testing.expect_value(t, execute_tid(gb, "silver_gfskip_backout10_newgame"), 0x7fc5)
}

@(test)
crystal_tid_tests :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokecrystal.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_newgame"), 0xa011)
    testing.expect_value(t, execute_tid(gb, "crystal_intro0_newgame"), 0xdccf)
    testing.expect_value(t, execute_tid(gb, "crystal_intro1_newgame"), 0xa504)
    testing.expect_value(t, execute_tid(gb, "crystal_intro2_newgame"), 0x3bd6)
    testing.expect_value(t, execute_tid(gb, "crystal_intro3_newgame"), 0x46dd)
    testing.expect_value(t, execute_tid(gb, "crystal_intro4_newgame"), 0xf7db)
    testing.expect_value(t, execute_tid(gb, "crystal_intro5_newgame"), 0x01f1)
    testing.expect_value(t, execute_tid(gb, "crystal_intro6_newgame"), 0x780e)
    testing.expect_value(t, execute_tid(gb, "crystal_intro7_newgame"), 0xd469)
    testing.expect_value(t, execute_tid(gb, "crystal_intro8_newgame"), 0x26bf)
    testing.expect_value(t, execute_tid(gb, "crystal_intro9_newgame"), 0x8fc0)
    testing.expect_value(t, execute_tid(gb, "crystal_introwait_newgame"), 0xa1b5)
    testing.expect_value(t, execute_tid(gb, "crystal_gfwait_newgame"), 0x48d9)

    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait1_newgame"), 0x00f7)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait2_newgame"), 0x3c02)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait10_newgame"), 0xe68d)

    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait1(opt)_newgame"), 0x572e)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait2(opt)_newgame"), 0x6269)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait10(opt)_newgame"), 0x9669)

    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait1(setopt)_newgame"), 0xb4e1)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait2(setopt)_newgame"), 0x7664)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_wait10(setopt)_newgame"), 0x62ae)

    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_backout1_newgame"), 0xff16)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_backout2_newgame"), 0xf989)
    testing.expect_value(t, execute_tid(gb, "crystal_gfskip_backout10_newgame"), 0x7557)
}