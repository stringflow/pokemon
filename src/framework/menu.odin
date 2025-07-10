package framework

import "core:slice"

gameboy_clear_text :: proc(gb: ^GameBoy, held_button: Buttons) {
    if is_gen1(gb.rom.game) {
        rby_clear_text(gb, held_button)
    } else {
        gsc_clear_text(gb, held_button)
    }
}

// TODO(stringflow): the procs for clearing text are so similar, that i could consider making a generic version...

@(private)
rby_clear_text :: proc(gb: ^GameBoy, held_button: Buttons) {
    print_letter_delay := gb.rom.sym["PrintLetterDelay.checkButtons"] + 3
    prompt := gb.rom.sym["WaitForTextScrollButtonPress.skipAnimation"] + 10
    overworld := gb.rom.sym["JoypadOverworld"] + 13
    low_sens := gb.rom.sym["JoypadLowSensitivity"] + 3
    
    text_addrs := []int {
        print_letter_delay,
        prompt,
        gb.rom.sym["HoldTextDisplayOpen"] + 3,
        (gb.rom.sym["ShowPokedexDataInternal.waitForButtonPress"] & 0xffff) + 3,
        gb.rom.sym["TextCommand_PAUSE"] + 4,
    }

    for {
        gameboy_run_until(gb, "Joypad", held_button)

        sp := gameboy_get_registers(gb).sp
        jump_address := int(gameboy_cpu_read_16le(gb, sp))
        if jump_address == low_sens {
            jump_address = int(gameboy_cpu_read_16le(gb, sp + 2))
        }

        if !slice.contains(text_addrs, jump_address) {
            player_input_disabled := (gameboy_cpu_read(gb, "wJoyIgnore") >= 0xfc || 
                (gameboy_cpu_read(gb, "wStatusFlags5") & 0xa1) != 0 || 
                (gameboy_cpu_read(gb, "wStatusFlags7") & 0x08) != 0 || 
                (gameboy_cpu_read(gb, "wCurOpponent") != 0))

            if jump_address == overworld && player_input_disabled {
                gameboy_inject_input(gb, held_button)
                gameboy_advance_frame(gb, held_button)
            } else {
                gameboy_run_for(gb, 1)
                break
            }
        }

        if jump_address == print_letter_delay {
            gameboy_inject_input(gb, held_button)
            gameboy_advance_frame(gb, held_button)
        } else {
            a_b := transmute(u8)(Buttons{.A, .B})
            previous := gameboy_cpu_read(gb, "hJoyLast") & a_b

            text_clear_button: Buttons
            if previous == 0 {
                text_clear_button = jump_address == prompt ? {.B} : {.A}
            } else {
                text_clear_button = transmute(Buttons)(previous ~ a_b)
            }

            gameboy_inject_input(gb, text_clear_button)
            gameboy_advance_frame(gb, text_clear_button)
        }
    }
}

@(private)
gsc_clear_text :: proc(gb: ^GameBoy, held_button: Buttons) {
    print_letter_delay := gb.rom.sym["PrintLetterDelay.checkjoypad"] + 3
    overworld := gb.rom.sym["HandleMapTimeAndJoypad"] & 0xffff
    low_sens := gb.rom.sym["JoyTextDelay"] + 3

    text_addrs := []int {
        gb.rom.sym["PromptButton.input_wait_loop"] + 6,
        gb.rom.sym["WaitPressAorB_BlinkCursor.loop"] + 11,
        gb.rom.sym["JoyWaitAorB.loop"] + 6,
        gb.rom.sym["TextCommand_PAUSE"] + 5,
    }

    for {
        gameboy_run_until(gb, "GetJoypad", held_button)
 
        sp := gameboy_get_registers(gb).sp
        jump_address := int(gameboy_cpu_read_16le(gb, sp))
        if jump_address == low_sens {
            jump_address = int(gameboy_cpu_read_16le(gb, sp + 2))
        }

        if jump_address == print_letter_delay || (jump_address == overworld && gameboy_cpu_read(gb, "wScriptMode") == 2) {
            gameboy_inject_input(gb, held_button)
            gameboy_advance_frame(gb, held_button)
        } else if slice.contains(text_addrs, jump_address) {
            a_b := transmute(u8)(Buttons{.A, .B})
            previous := gameboy_cpu_read(gb, "hJoyDown") & a_b
            text_clear_button: Buttons = previous == 0 ? {.A} : transmute(Buttons)(previous ~ a_b)

            gameboy_inject_input(gb, text_clear_button)
            gameboy_advance_frame(gb, text_clear_button)
        } else {
            gameboy_run_for(gb, 1)
            break
        }
    }
}