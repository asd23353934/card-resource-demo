extends Node

# === 戰鬥相關 ===
signal card_played(card: CardData, target) # 卡牌打出
signal damage_dealt(amount: int, target_name: String) # 造成傷害
signal healing_applied(amount: int, target_name: String) # 治療
signal turn_started(turn_number: int) # 我方回合開始
signal turn_ended(turn_number: int) # 我方回合結束

# === 玩家狀態 ===
signal player_died # 玩家死亡
signal player_hp_changed(current: int, max_hp: int) # HP 變化（更新血條用）
signal energy_changed(current: int, max_energy: int) # 能量變化

# === 遊戲流程 ===
signal run_started(run_number: int) # 新 run 開始
signal run_ended(victory: bool) # run 結束（贏 / 輸）
signal floor_changed(new_floor: int) # 樓層切換


func _ready() -> void:
	print("[EventBus] autoload ready，", _count_signals(), " 個 signal 待命")


func _count_signals() -> int:
	return get_signal_list().size()