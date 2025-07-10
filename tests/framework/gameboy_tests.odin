package tests_framework

import "core:testing"
import "core:encoding/endian"
import p "../../src/framework"

@(test)
libgambatte_interface_test :: proc(t: ^testing.T) {
    gb, err := p.gameboy_init("roms/gbc_bios.bin", "roms/pokered.gbc")
    testing.expect_value(t, err, nil)
    defer p.gameboy_destroy(gb)

    testing.expect_value(t, gb.video_buffer[0], 0)
    testing.expect_value(t, p.gameboy_get_registers(gb), p.Registers{0, 0, 0, 0, 0, 0, 0, 0, 0, 0})

    state := p.gameboy_save_state(gb)
    defer delete(state)
    
    testing.expect_value(t, p.gameboy_run_until(gb, []int{0x100}), 0x100)
    testing.expect_value(t, p.gameboy_get_registers(gb), p.Registers{0x100, 0xfffe, 0x11, 0x15, 0, 0, 0x8, 0, 0, 0x7c})
    testing.expect_value(t, p.gameboy_timestamp(gb), gb.samples_emulated)
    testing.expect_value(t, gb.video_buffer[0], 248)

    load_state := p.gameboy_load_state(gb, state)
    testing.expect_value(t, load_state, true)
    testing.expect_value(t, p.gameboy_run_until(gb, []string{"Start"}), 0x100)
    testing.expect_value(t, p.gameboy_timestamp(gb), gb.samples_emulated / 2)

    testing.expect_value(t, p.gameboy_cpu_read(gb, 0x134), 'P')
    testing.expect_value(t, p.gameboy_cpu_read(gb, 0x1234), gb.rom.contents[0x1234])

    p.gameboy_advance_frames(gb, 5)
    testing.expect_value(t, p.gameboy_cpu_read(gb, 0xd000), 0x00)
    p.gameboy_cpu_write(gb, 0xd000, 0xff)
    testing.expect_value(t, p.gameboy_cpu_read(gb, 0xd000), 0xff)

    address_read := p.gameboy_cpu_read(gb, 0xffd5)
    symbol_read := p.gameboy_cpu_read(gb, "hFrameCounter")
    testing.expect(t, address_read == symbol_read)

    p.gameboy_cpu_write(gb, "hFrameCounter", 0x99)
    testing.expect_value(t, p.gameboy_cpu_read(gb, "hFrameCounter"), 0x99)

    p.gameboy_save_state(gb, state)
    timesec := endian.unchecked_get_u32be(state[gb.state_field_offsets["timesec"]:])
    testing.expect_value(t, timesec, 3)

    testing.expect_value(t, p.gameboy_set_rtc(gb, 120), true)
    
    p.gameboy_save_state(gb, state)
    timesec = endian.unchecked_get_u32be(state[gb.state_field_offsets["timesec"]:])
    testing.expect_value(t, timesec, 120)
}