extends Node


@export var test_cards: Array[CardData] = []


func _ready() -> void:
	# === 訂閱 EventBus（任何 node 都能做） ===
	EventBus.damage_dealt.connect(_on_damage_dealt)
	EventBus.player_hp_changed.connect(_on_player_hp_changed)
	EventBus.player_died.connect(_on_player_died)
	EventBus.run_started.connect(_on_run_started)

	# === Cards 試讀 ===
	print("=== Cards loaded ===")
	for card in test_cards:
		print(card.describe())

	# === GameState 操作（會自動觸發 EventBus signals） ===
	print("\n=== 開始操作 GameState ===")
	GameState.take_damage(30)
	GameState.heal(10)
	GameState.take_damage(60) # 應該會觸發 player_died


# === EventBus listeners（純訂閱者，不管 GameState 內部）===

func _on_damage_dealt(amount: int, target_name: String) -> void:
	print("    [Listener] %s 被打 %d 點 → 該播飄字 / 抖畫面 / 音效" % [target_name, amount])


func _on_player_hp_changed(current: int, max_hp: int) -> void:
	print("    [Listener] HP 條更新：%d / %d" % [current, max_hp])


func _on_player_died() -> void:
	print("    [Listener] !!! 玩家死亡 → 該切 game over scene")


func _on_run_started(run_number: int) -> void:
	print("    [Listener] Run #%d 開始 → 該重置 UI" % run_number)