# Card Resource Demo

Godot 4 的 **Custom Resource (.tres)** 與 **Autoload (singleton)** 練習，
作為 6 個月「前端轉 Godot」學習計畫 W3 的純資料 / 邏輯地基。

> 學習路徑紀錄：[godot-learning-path](https://github.com/asd23353934/godot-learning-path)

**沒有遊戲畫面**，純粹示範資料驅動 + 全域狀態管理。
這套 pattern 是 deckbuilder 商業遊戲（Slay the Spire / Hades / DFS）的核心地基。

## 為什麼有這個專案

W2 dodge-the-creeps 雖然好玩但所有資料寫死在 scene 裡，
**無法擴展到 80 張卡 / 30 種敵人** 的規模。W3 練的就是兩件事：

1. **把資料抽離 code**：80 張卡 = 80 個 `.tres` 檔，設計師（自己）改數值不用碰程式
2. **跨場景溝通**：玩家狀態 + 事件中心放 autoload，scene 互相不認識也能協作

## Tech

- **Engine**：Godot 4.6.3 (Standard)
- **語言**：GDScript

## 涵蓋的概念

### 1. Custom Resource

```gdscript
# cards/card_data.gd
class_name CardData
extends Resource

@export var card_name: String = ""
@export var cost: int = 1
@export var damage: int = 0
@export_multiline var description: String = ""
```

每張卡 = 一個 `.tres` 檔，Inspector 直接編輯：

| 卡名 | cost | damage |
|---|---|---|
| STRIKE | 1 | 6 |
| DEFEND | 1 | 0 |
| FOCUS | 2 | 0 |

### 2. Autoload Singleton（GameState）

```gdscript
# autoload/game_state.gd → 註冊為 Autoload 後全域可用
var player_hp: int = 80
var energy: int = 3
var run_count: int = 0

func take_damage(amount: int) -> void:
    player_hp = max(0, player_hp - amount)
    EventBus.player_hp_changed.emit(player_hp, max_hp)   # 廣播給全世界
    if player_hp == 0:
        EventBus.player_died.emit()
```

任何 scene 寫 `GameState.player_hp` 即可訪問，不用 import / get_node。

### 3. EventBus Pattern

11 個 signal 集中在 `EventBus` autoload：

- 戰鬥：`card_played` / `damage_dealt` / `turn_started` ...
- 玩家：`player_died` / `player_hp_changed` / `energy_changed`
- 流程：`run_started` / `run_ended` / `floor_changed`

**Sender 不認識 Receiver，靠中央 EventBus 中轉**，
解決多場景間鬆耦合通訊（≈ Redux dispatch / RxJS Subject / EventEmitter）。

## 專案結構

```
card-resource-demo/
├── cards/
│   ├── card_data.gd      # CardData class
│   ├── strike.tres
│   ├── defend.tres
│   └── focus.tres
├── autoload/
│   ├── game_state.gd     # 全域狀態 + API
│   └── event_bus.gd      # 全域 signal hub
├── main.tscn / main.gd   # 驗證場景
└── project.godot
```

## 執行方式

1. 安裝 [Godot 4.x Standard](https://godotengine.org/download)
2. clone 此 repo
3. 開 Godot Project Manager → 匯入 → 選此資料夾的 `project.godot`
4. F6 跑 `main.tscn`，看 Output 面板

預期輸出：
```
[GameState] autoload ready，HP=80/80 energy=3/3
[EventBus] autoload ready，11 個 signal 待命
=== Cards loaded ===
STRIKE (cost: 1, dmg: 6) — ...
[GameState] 玩家受 30 點傷害 → [Listener] HP 條更新：50/80
[GameState] 玩家死亡 → [Listener] !!! 玩家死亡 → 該切 game over scene
```

## License

MIT
