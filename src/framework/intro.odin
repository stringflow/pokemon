package framework

import "core:strings"
import "core:reflect"
import "core:fmt"

BIOS_JOYPAD :: 0x021d

IntroStrat :: enum {
    red,
    blue,
    yellow,
    gold,
    silver,
    crystal,

    nopal,
    nopal_ab,
    pal,
    pal_hold,
    pal_ab,
    pal_rel,

    gfskip,
    gfwait,

    hop,
    intro,
    introwait,
    intro_lcd,
    
    title,
    title_scroll,

    delay,
    mmback,
    fsback,
    wait,
    wait_opt,
    wait_setopt,
    backout,

    cont,
    newgame,
}

IntroAction :: struct {
    strat: IntroStrat,
    repetitions: int,
}

intro_action_iterator :: proc(s: ^string, b: ^strings.Builder) -> (action: IntroAction, ok: bool) {
    ok = s^ != ""

    if ok {
        strings.builder_reset(b)

        read := 0
        for c in s^ {
            read += 1
            if c == '_' {
                break
            } else if c >= '0' && c <= '9' {
                action.repetitions *= 10
                action.repetitions += int(c - '0')
            } else if c == '(' {
                strings.write_rune(b, '_')
            } else if c != ')' && c != '+' {
                strings.write_rune(b, c)
            }
        }

        s^ = s[read:]

        strat_enum_name := strings.to_string(b^)
        action.strat, ok = reflect.enum_from_name(IntroStrat, strat_enum_name)
        fmt.assertf(ok, "Unrecognized IntroAction encountered: '%v'", strat_enum_name)
    }

    return
}

gameboy_execute_intro :: proc(gb: ^GameBoy, action: IntroAction) {
    if is_gen1(gb.rom.game) {
        rby_execute_intro(gb, action)
    } else {
        gsc_execute_intro(gb, action)
    }
}

gameboy_execute_intro_sequence :: proc(gb: ^GameBoy, sequence: string) {
    b := strings.builder_make()
    defer strings.builder_destroy(&b)

    it := sequence
    for action in intro_action_iterator(&it, &b) {
        gameboy_execute_intro(gb, action)
    }
}

@(private)
rby_execute_intro :: proc(gb: ^GameBoy, action: IntroAction) {
    #partial switch action.strat {
        case .red, .blue, .yellow:
        case .nopal:
            gameboy_run_until(gb, "Start")
        case .nopal_ab:
            gameboy_run_until(gb, "Start", {.A})
        case .pal:
            gameboy_run_until(gb, BIOS_JOYPAD)
            gameboy_advance_frame(gb, {.A, .Left})
            gameboy_run_until(gb, "Start")
        case .pal_hold:
            gameboy_run_until(gb, "Start", {.B, .Left})
        case .pal_ab:
            gameboy_run_until(gb, BIOS_JOYPAD)
            gameboy_advance_frames(gb, 70, {.Left})
            gameboy_run_until(gb, BIOS_JOYPAD)
            gameboy_run_until(gb, "Start", {.B, .Left})
        case .pal_rel:
            gameboy_run_until(gb, BIOS_JOYPAD)
            gameboy_advance_frame(gb, {.Left})
            gameboy_advance_frames(gb, 70)
            gameboy_run_until(gb, "Start", {.B, .Left})
        case .gfskip:
            gameboy_press(gb, {.Up, .Select, .B})
        case .gfwait:
            gameboy_run_until(gb, "PlayShootingStar.next")
        case .hop:
            fmt.assertf(gb.rom.game != .Yellow, "IntroAction 'hop' is only available for Red/Blue")

            if action.repetitions > 5 {
                gameboy_run_until(gb, "DisplayTitleScreen")
            } else {
                for _ in 0..<action.repetitions {
                    gameboy_run_until(gb, "AnimateIntroNidorino")
                    gameboy_run_until(gb, "CheckForUserInterruption")
                }
                gameboy_press(gb, {.Up, .Select, .B})
            }
        case .intro:
            fmt.assertf(gb.rom.game == .Yellow, "IntroAction 'yellow' is only available for Red/Blue")

            switch action.repetitions {
                case 1: gameboy_run_until(gb, "YellowIntroScene2")
                case 2: gameboy_run_until(gb, "YellowIntroScene4")
                case 3: gameboy_run_until(gb, "YellowIntroScene6")
                case 4: gameboy_run_until(gb, "YellowIntroScene8")
                case 5: gameboy_run_until(gb, "YellowIntroScene10")
                case 6: gameboy_run_until(gb, "YellowIntroScene12")
            }
            gameboy_press(gb, {.A})
        case .introwait:
            gameboy_run_until(gb, "DisplayTitleScreen")
        case .title:
            for _ in 0..<action.repetitions {
                gameboy_run_until(gb, "TitleScreenPickNewMon")
                gameboy_run_until(gb, "CheckForUserInterruption")
            }
            gameboy_press(gb, {.Start})
        case .title_scroll:
            for _ in 0..=action.repetitions {
                gameboy_run_until(gb, "TitleScreenScrollInMon")
                gameboy_run_until(gb, "CheckForUserInterruption")
            }
            gameboy_press(gb, {.Start})
        case .cont, .newgame:
            gameboy_press(gb, {.A})
        case:
            fmt.panicf("Invalid IntroAction '%v' for game '%v'", action.strat, gb.rom.game)
    }
}

@(private)
main_menu_wait :: proc(gb: ^GameBoy, cycles: int) {
    main_menu_loop := gb.rom.game == .Crystal ? gb.rom.sym["MainMenuJoypadLoop"] + 17 : gb.rom.sym["MainMenuJoypadLoop"] + 9

    for _ in 0..<cycles {
        gameboy_run_until(gb, main_menu_loop)
        gameboy_advance_frame(gb)
    }
}

@(private)
gsc_execute_intro :: proc(gb: ^GameBoy, action: IntroAction) {
    #partial switch action.strat {
        case .gold, .silver, .crystal:
        case .gfskip:
            gameboy_press(gb, {.Start}, {.Start})
        case .gfwait:
            gameboy_run_until(gb, gb.rom.game == .Crystal ? "GameFreakPresentsEnd" : "GameFreakPresentsFrame.finish")
            gameboy_press(gb, {.Start}, {.Start})
        case .intro:
            if gb.rom.game == .Crystal {
                switch action.repetitions {
                    case 0: gameboy_run_until(gb, "IntroScene1")
                    case 1: gameboy_run_until(gb, gb.rom.sym["IntroScene3"])
                    case 2: gameboy_run_until(gb, gb.rom.sym["IntroScene5"])
                    case 3: gameboy_run_until(gb, gb.rom.sym["IntroScene7"])
                    case 4: gameboy_run_until(gb, gb.rom.sym["IntroScene11"])
                    case 5: gameboy_run_until(gb, gb.rom.sym["IntroScene13"])
                    case 6: gameboy_run_until(gb, gb.rom.sym["IntroScene15"])
                    case 7: gameboy_run_until(gb, gb.rom.sym["IntroScene17"])
                    case 8: gameboy_run_until(gb, gb.rom.sym["IntroScene19"])
                    case 9: gameboy_run_until(gb, gb.rom.sym["IntroScene26"])
                    case: gameboy_run_until(gb, "GameFreakPresentsEnd")
                }
            } else {
                switch action.repetitions {
                    case 0: gameboy_run_until(gb, "GoldSilverIntro")
                    case 1: gameboy_run_until(gb, gb.rom.sym["IntroScene6"] + 13)
                    case 2: gameboy_run_until(gb, gb.rom.sym["IntroScene10"] + 13)
                    case: gameboy_run_until(gb, "GameFreakPresentsFrame.finish")
                }
            }

            gameboy_run_until(gb, "TitleScreenMain", {.Start})
            gameboy_press(gb, {.Start})
        case .intro_lcd:
            gameboy_run_until(gb, "GoldSilverIntro")
            gameboy_run_until(gb, "DisableLCD")
            gameboy_run_until(gb, "TitleScreenMain", {.Start})
            gameboy_press(gb, {.Start})
        case .introwait:
            gameboy_run_until(gb, "TitleScreenMain")
            gameboy_press(gb, {.Start})
        case .delay:
            gameboy_run_until(gb, "GetJoypad", {.Select})
            gameboy_advance_frames(gb, 1 + action.repetitions, {.Select})
        case .mmback, .fsback:
            gameboy_press(gb, {.B})
        case .wait:
            main_menu_wait(gb, action.repetitions)
        case .wait_opt:
            gameboy_press(gb, {.Down})
            main_menu_wait(gb, action.repetitions - 1)
            gameboy_press(gb, {.A}, {.Start})
        case .wait_setopt:
            gameboy_press(gb, {.Down})
            main_menu_wait(gb, action.repetitions - 1)
            gameboy_press(gb, {.A, .Left}, {.Start})
        case .backout:
            for _ in 0..<action.repetitions {
                gameboy_press(gb, {.B}, {.Start})
            }
        case .cont, .newgame:
            gameboy_press(gb, {.A})
        case:
            fmt.panicf("Invalid IntroAction '%v' for game '%v'", action.strat, gb.rom.game)
    }
}