package framework

gameboy_inject_input :: proc(gb: ^GameBoy, buttons: Buttons) {
    if is_gen1(gb.rom.game) {
        rby_inject_input(gb, buttons)
    } else {
        gsc_inject_input(gb, buttons)
    }
}

@(private)
rby_inject_input :: proc(gb: ^GameBoy, buttons: Buttons) {
    gameboy_cpu_write(gb, "hJoyInput", transmute(u8)(buttons))
}

@(private)
gsc_is_overworld_input :: proc(gb: ^GameBoy) -> bool {
    return gameboy_get_registers(gb).pc == (gb.rom.sym["OWPlayerInput"] & 0xffff)
}

@(private)
gsc_inject_input :: proc(gb: ^GameBoy, buttons: Buttons) {
    buttons_u8 := transmute(u8)(buttons)

    if gsc_is_overworld_input(gb) {
        gameboy_cpu_write(gb, "hJoyDown", buttons_u8)
        gameboy_cpu_write(gb, "hJoyPressed", buttons_u8)
    } else {
        gameboy_cpu_write(gb, "hJoypadDown", buttons_u8)
    }
}

gameboy_press :: proc(gb: ^GameBoy, buttons: ..Buttons) {
    for button in buttons {
        if is_gen1(gb.rom.game) {
            rby_press(gb, button)
        } else {
            gsc_press(gb, button)
        }
    }
}

@(private)
rby_press :: proc(gb: ^GameBoy, buttons: Buttons) {
    gameboy_run_until(gb, "_Joypad")
    rby_inject_input(gb, buttons)
    gameboy_advance_frame(gb)
}

@(private)
gsc_press :: proc(gb: ^GameBoy, buttons: Buttons) {
    if !gsc_is_overworld_input(gb) {
        gameboy_run_until(gb, "GetJoypad", buttons)
    }
    
    gsc_inject_input(gb, buttons)
    gameboy_advance_frame(gb)
}