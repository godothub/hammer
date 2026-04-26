@abstract
extends Resource
class_name Driver
## 用于驱动 Character 的驱动器。

## 驱动器启用状态
@export var enable: bool = true

## 驱动角色
var character:Character

func _get_depend_list() -> PackedStringArray: return [] ## 依赖列表

func _ready() -> void: pass
func _input(_event: InputEvent) -> void: pass
func _process(_delta: float) -> void: pass
func _physics_process(_delta: float) -> void: pass
