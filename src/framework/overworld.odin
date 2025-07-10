package framework

import "core:strings"
import "core:reflect"
import "core:fmt"

OverworldAction :: enum {
    R,
    L,
    U,
    D,
    A_R,
    A_L,
    A_U,
    A_D,
    A,
    S_B,
    SEL,
}

OverworldResult :: enum {
    Overworld_Loop,
    Wild_Encounter,
    Collision,
    Textbox,
}

overworld_action_iterator :: proc(s: ^string) -> (action: OverworldAction, ok: bool) {
    s^ = strings.trim_left_space(s^)
    ok = s^ != ""

    if ok {
        len := strings.starts_with(s^, "A+") || strings.starts_with(s^, "S") ? 3 : 1
        substr := s[:len]
        s^ = s[len:]

        action_str, alloc := strings.replace_all(substr, "+", "_")
        defer if alloc do delete(action_str)

        action, ok = reflect.enum_from_name(OverworldAction, action_str)
        fmt.assertf(ok, "Unrecognized OverworldAction encountered: '%v'", substr)
    }

    return
}

gameboy_execute_overworld :: proc(gb: ^GameBoy, action: OverworldAction) -> (result: OverworldResult) {
    if is_gen1(gb.rom.game) {
        return rby_execute_overworld(gb, action)
    } else {
        return rby_execute_overworld(gb, action)
    }
}

gameboy_execute_path :: proc(gb: ^GameBoy, path: string) -> (result: OverworldResult) {
    result = .Overworld_Loop

    it := path
    for action in overworld_action_iterator(&it) {
        result = is_gen1(gb.rom.game) ? rby_execute_overworld(gb, action) : gsc_execute_overworld(gb, action)

        if result != .Overworld_Loop {
            break
        }
    }

    return
}

@(private)
directional_action_to_buttons :: proc(action: OverworldAction) -> (buttons: Buttons) {
    #partial switch action {
        case .R: return {.Right}
        case .L: return {.Left}
        case .U: return {.Up}
        case .D: return {.Down}
        case .A_R: return {.A, .Right}
        case .A_L: return {.A, .Left}
        case .A_U: return {.A, .Up}
        case .A_D: return {.A, .Down}
    }

    return
}

@(private)
rby_execute_overworld :: proc(gb: ^GameBoy, action: OverworldAction) -> (result: OverworldResult) {
    #partial switch action {
        case .R, .L, .D, .U:
            buttons := directional_action_to_buttons(action)

            ledge_hop := gb.rom.sym["HandleLedges.foundMatch"]
            land_collision := gb.rom.sym["CollisionCheckOnLand.collision"]
            water_collision := gb.rom.sym["CollisionCheckOnWater.collision"]
            wild_encounter := gb.rom.sym["TryDoWildEncounter.CanEncounter"] + 6
            step_completed := gb.rom.sym["OverworldLoopLessDelay.newBattle"] + 3

            for {
                gameboy_run_until(gb, "JoypadOverworld")
                gameboy_inject_input(gb, buttons)
                addr := gameboy_run_until(gb, []int{ledge_hop, land_collision, water_collision, wild_encounter, step_completed}, buttons)

                switch addr {
                    case wild_encounter:
                        gameboy_run_until(gb, "CalcStats")
                        return .Wild_Encounter
                    case land_collision, water_collision:
                        return .Collision
                }

                gameboy_run_until(gb, "JoypadOverworld")

                // TODO(stringflow): put these in proper enums
                jumping_ledge := (gameboy_cpu_read(gb, "wMovementFlags") & 0x40) != 0
                exiting_door := (gameboy_cpu_read(gb, "wMovementFlags") & 0x02) != 0
                simulated_joypad := (gameboy_cpu_read(gb, "wStatusFlags5") & 0x08) != 0
                disabled_joypad := gameboy_cpu_read(gb, "wJoyIgnore") >= 0xfc

                if !jumping_ledge && !exiting_door && !simulated_joypad && !disabled_joypad {
                    break
                }
            }

            return .Overworld_Loop
        case .A:
            joypad_overworld := gb.rom.sym["JoypadOverworld"]
            print_letter_delay := gb.rom.sym["PrintLetterDelay"]

            gameboy_run_until(gb, "JoypadOverworld")
            gameboy_inject_input(gb, {.A})
            gameboy_run_for(gb, 1)
            addr := gameboy_run_until(gb, []int{joypad_overworld, print_letter_delay}, {.A})

            return addr == joypad_overworld ? .Overworld_Loop : .Textbox
        case .S_B:
            gameboy_inject_input(gb, {.Start})
            gameboy_run_until(gb, "DisplayStartMenu", {.Start})
            gameboy_inject_input(gb, {.B})
            gameboy_run_until(gb, "JoypadOverworld", {.B})
            return .Overworld_Loop
        case:
            fmt.panicf("Invalid OverworldAction '%v' for game '%v'", action, gb.rom.game)
    }

    return nil
}

@(private)
gsc_is_trying_to_take_directional_warp :: proc(gb: ^GameBoy, buttons: Buttons) -> bool {
    current_tile := gameboy_cpu_read(gb, "wPlayerStandingTile")

    return (current_tile == 0x70 && .Down in buttons) ||
        (current_tile == 0x76 && .Left in buttons) ||
        (current_tile == 0x78 && .Up in buttons) ||
        (current_tile == 0x7e && .Right in buttons)
}

@(private)
gsc_is_on_door_tile :: proc(gb: ^GameBoy) -> bool {
    current_tile := gameboy_cpu_read(gb, "wPlayerStandingTile")
    return current_tile == 0x71 || current_tile == 0x79 || current_tile == 0x7a || current_tile == 0x7b
}

@(private)
gsc_execute_overworld :: proc(gb: ^GameBoy, action: OverworldAction) -> (result: OverworldResult) {
    buttons: Buttons
    #partial switch action {
        case .R, .L, .D, .U, .A_R, .A_L, .A_D, .A_U:
            buttons := directional_action_to_buttons(action)

            count_step := gb.rom.sym["CountStep"]
            print_letter_delay := gb.rom.sym["PrintLetterDelay.checkjoypad"]
            bump_sound := gb.rom.sym["DoPlayerMovement.BumpSound"]
            enter_map := gb.rom.sym["EnterMap"] + 16
            random_encounter := gb.rom.sym["RandomEncounter.ok"]
            ow_player_input := gb.rom.sym["OWPlayerInput"]

            gsc_inject_input(gb, buttons)
            addr := gameboy_run_until(gb, []int{count_step, print_letter_delay, bump_sound, random_encounter}, buttons)

            if addr == count_step {
                addr = gameboy_run_until(gb, []int{random_encounter, ow_player_input}, buttons)
                if addr == ow_player_input && gsc_is_trying_to_take_directional_warp(gb, buttons) {
                    addr = gameboy_run_until(gb, enter_map, buttons)
                }
            }

            if addr == enter_map && gsc_is_on_door_tile(gb) {
                addr = gameboy_run_until(gb, count_step, buttons)
                addr = gameboy_run_until(gb, ow_player_input, buttons)
            }

            gsc_inject_input(gb, Buttons{})

            switch addr {
                case print_letter_delay: return .Textbox
                case bump_sound: return .Collision
                case random_encounter: return .Wild_Encounter
                case: return .Overworld_Loop
            }
        case .S_B:
            gameboy_press(gb, {.Start}, {.B})
            gameboy_run_until(gb, "OWPlayerInput", {.B})
            return .Overworld_Loop
        case .SEL:
            gameboy_press(gb, {.Select})
            gameboy_run_until(gb, "OWPlayerInput", {.Select})
            return .Overworld_Loop
        case:
            fmt.panicf("Invalid OverworldAction '%v' for game '%v'", action, gb.rom.game)
    }

    return nil
}

gameboy_pickup_item :: proc(gb: ^GameBoy) {
    if is_gen1(gb.rom.game) {
        rby_pickup_item(gb)
    } else {
        gsc_pickup_item(gb)
    }
}

@(private)
rby_pickup_item :: proc(gb: ^GameBoy) {
    gameboy_press(gb, {.A});
    gameboy_run_until(gb, "PlaySound", {.A});
}

@(private)
gsc_pickup_item :: proc(gb: ^GameBoy) {
    gameboy_press(gb, {.A});
    gsc_clear_text(gb, {.A});
}