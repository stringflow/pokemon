package framework

rby_throw_ball :: proc(gb: ^GameBoy) -> (captured: bool) {
    if gb.rom.game == .Yellow {
        gameboy_press(gb, {.Down}, {.A}, {.Left, .A})
    } else {
        gameboy_press(gb, {.Down, .A}, {.Left, .A})
    }

    success := gb.rom.sym["ItemUseBall.captured"]
    failure := gb.rom.sym["ItemUseBall.failedToCapture"]

    return gameboy_run_until(gb, []int{success, failure}, {.A}) == success
}

WhoseTurn :: enum u8 {
    Player,
    Enemy,
}

Status :: bit_field u8 {
    sleep_turns: u8 | 3,
    poisoned: bool | 1,
    burned: bool | 1,
    frozen: bool | 1,
    paralysis: bool | 1,
}

RbyBattleMon :: struct {
    move_used: u8,
    fainted: bool,
    critical: bool,
    status: Status,
    hp: u16,
    max_hp: u16,
    attack_mod: u8,
    defense_mod: u8,
    speed_mod: u8,
    special_mod: u8,
    accuracy_mod: u8,
    evasion_mod: u8,
}

RbyTurn :: struct {
    first: WhoseTurn,
    player: RbyBattleMon,
    enemy: RbyBattleMon,
}

rby_do_move :: proc(gb: ^GameBoy) -> (turn: RbyTurn) {
    gameboy_press(gb, {.A}, {.Select}, {.A})

    manual_text_scroll := gb.rom.sym["ManualTextScroll"]
    critical_hit_test := gb.rom.sym["CriticalHitTest.SkipHighCritical"] + 16
    player_mon_fainted := gb.rom.sym["HandlePlayerMonFainted"]
    enemy_mon_fainted := gb.rom.sym["HandleEnemyMonFainted"]
    display_battle_menu := gb.rom.sym["DisplayBattleMenu"]

    addr: int
    for addr != player_mon_fainted && addr != enemy_mon_fainted && addr != display_battle_menu {
        addr = gameboy_run_until(gb, []int{manual_text_scroll, critical_hit_test, player_mon_fainted, enemy_mon_fainted, display_battle_menu}, {.A})
        gameboy_run_for(gb, 1, {.A})

        whose_turn := transmute(WhoseTurn)(gameboy_cpu_read(gb, "hWhoseTurn"))

        if turn.first == nil {
            turn.first = whose_turn
        }

        if addr == manual_text_scroll {
            gameboy_inject_input(gb, {.B})
            gameboy_advance_frame(gb, {.B})
        } else if addr == critical_hit_test {
            statistic := whose_turn == .Player ? &turn.player : &turn.enemy
            statistic.critical = gameboy_cpu_read(gb, "wCriticalHitOrOHKO") == 1
        }
    }

    turn.player.move_used = gameboy_cpu_read(gb, "wPlayerUsedMove")
    turn.player.fainted = addr == player_mon_fainted
    turn.player.status = transmute(Status)(gameboy_cpu_read(gb, "wBattleMonStatus"))
    turn.player.hp = gameboy_cpu_read_16be(gb, "wBattleMonHP")
    turn.player.max_hp = gameboy_cpu_read_16be(gb, "wBattleMonMaxHP")
    turn.player.attack_mod = gameboy_cpu_read(gb, "wPlayerMonAttackMod")
    turn.player.defense_mod = gameboy_cpu_read(gb, "wPlayerMonDefenseMod")
    turn.player.speed_mod = gameboy_cpu_read(gb, "wPlayerMonSpeedMod")
    turn.player.special_mod = gameboy_cpu_read(gb, "wPlayerMonSpecialMod")
    turn.player.accuracy_mod = gameboy_cpu_read(gb, "wPlayerMonAccuracyMod")
    turn.player.evasion_mod = gameboy_cpu_read(gb, "wPlayerMonEvasionMod")

    turn.enemy.move_used = gameboy_cpu_read(gb, "wEnemyUsedMove")
    turn.enemy.fainted = addr == enemy_mon_fainted
    turn.enemy.status = transmute(Status)(gameboy_cpu_read(gb, "wEnemyMonStatus"))
    turn.enemy.hp = gameboy_cpu_read_16be(gb, "wEnemyMonHP")
    turn.enemy.max_hp = gameboy_cpu_read_16be(gb, "wEnemyMonMaxHP")
    turn.enemy.attack_mod = gameboy_cpu_read(gb, "wEnemyMonAttackMod")
    turn.enemy.defense_mod = gameboy_cpu_read(gb, "wEnemyMonDefenseMod")
    turn.enemy.speed_mod = gameboy_cpu_read(gb, "wEnemyMonSpeedMod")
    turn.enemy.special_mod = gameboy_cpu_read(gb, "wEnemyMonSpecialMod")
    turn.enemy.accuracy_mod = gameboy_cpu_read(gb, "wEnemyMonAccuracyMod")
    turn.enemy.evasion_mod = gameboy_cpu_read(gb, "wEnemyMonEvasionMod")

    return
}

GscBattleMon :: struct {
    move_used: u8,
    fainted: bool,
    critical: bool,
    status: Status,
    hp: u16,
    max_hp: u16,
    attack_mod: u8,
    defense_mod: u8,
    speed_mod: u8,
    special_att_mod: u8,
    special_def_mod: u8,
    accuracy_mod: u8,
    evasion_mod: u8,
}

GscTurn :: struct {
    first: WhoseTurn,
    player: GscBattleMon,
    enemy: GscBattleMon,
}

gsc_do_move :: proc(gb: ^GameBoy) -> (turn: GscTurn) {
    gameboy_press(gb, {.A}, {.Select}, {.A})

    manual_text_scroll := gb.rom.sym["PromptButton"]
    critical_hit := gb.rom.sym["BattleCommand_Critical.Tally"] + 9
    player_mon_fainted := gb.rom.sym["HandlePlayerMonFaint"]
    enemy_mon_fainted := gb.rom.sym["HandleEnemyMonFaint"]
    display_battle_menu := gb.rom.sym["BattleMenu"]

    addr: int
    for addr != player_mon_fainted && addr != enemy_mon_fainted && addr != display_battle_menu {
        addr = gameboy_run_until(gb, []int{manual_text_scroll, critical_hit, player_mon_fainted, enemy_mon_fainted, display_battle_menu}, {.A})
        gameboy_run_for(gb, 1, {.A})

        if turn.first == nil {
            turn.first = gameboy_cpu_read(gb, "wEnemyGoesFirst") != 0 ? .Enemy : .Player
        }

        whose_turn := transmute(WhoseTurn)(gameboy_cpu_read(gb, "hBattleTurn"))

        if addr == manual_text_scroll {
            gameboy_inject_input(gb, {.B})
            gameboy_advance_frame(gb, {.B})
        } else if addr == critical_hit {
            statistic := whose_turn == .Player ? &turn.player : &turn.enemy
            statistic.critical = true
        }
    }

    turn.player.move_used = gameboy_cpu_read(gb, "wCurPlayerMove")
    turn.player.fainted = addr == player_mon_fainted
    turn.player.status = transmute(Status)(gameboy_cpu_read(gb, "wBattleMonStatus"))
    turn.player.hp = gameboy_cpu_read_16be(gb, "wBattleMonHP")
    turn.player.max_hp = gameboy_cpu_read_16be(gb, "wBattleMonMaxHP")
    turn.player.attack_mod = gameboy_cpu_read(gb, "wPlayerAtkLevel")
    turn.player.defense_mod = gameboy_cpu_read(gb, "wPlayerDefLevel")
    turn.player.speed_mod = gameboy_cpu_read(gb, "wPlayerSpdLevel")
    turn.player.special_att_mod = gameboy_cpu_read(gb, "wPlayerSAtkLevel")
    turn.player.special_def_mod = gameboy_cpu_read(gb, "wPlayerSDefLevel")
    turn.player.accuracy_mod = gameboy_cpu_read(gb, "wPlayerAccLevel")
    turn.player.evasion_mod = gameboy_cpu_read(gb, "wPlayerEvaLevel")

    turn.enemy.move_used = gameboy_cpu_read(gb, "wCurEnemyMove")
    turn.enemy.fainted = addr == enemy_mon_fainted
    turn.enemy.status = transmute(Status)(gameboy_cpu_read(gb, "wEnemyMonStatus"))
    turn.enemy.hp = gameboy_cpu_read_16be(gb, "wEnemyMonHP")
    turn.enemy.max_hp = gameboy_cpu_read_16be(gb, "wEnemyMonMaxHP")
    turn.enemy.attack_mod = gameboy_cpu_read(gb, "wEnemyAtkLevel")
    turn.enemy.defense_mod = gameboy_cpu_read(gb, "wEnemyDefLevel")
    turn.enemy.speed_mod = gameboy_cpu_read(gb, "wEnemySpdLevel")
    turn.enemy.special_att_mod = gameboy_cpu_read(gb, "wEnemySAtkLevel")
    turn.enemy.special_def_mod = gameboy_cpu_read(gb, "wEnemySDefLevel")
    turn.enemy.accuracy_mod = gameboy_cpu_read(gb, "wEnemyAccLevel")
    turn.enemy.evasion_mod = gameboy_cpu_read(gb, "wEnemyEvaLevel")

    return
}