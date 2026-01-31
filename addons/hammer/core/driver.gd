@abstract
extends Resource
class_name Driver
## 用于驱动 Character

@export var enable: bool = true  ## 驱动器启用状态

@abstract func _input(_event: InputEvent, _owner: Character) -> void

@abstract func _process(_delta: float, _owner: Character) -> void

@abstract func _physics_process(_delta: float, _owner: Character) -> void
