extends Driver
class_name GravityDriver
## 重力驱动器

@export var Gravity: float = 9.8

@export var GravityVector: Vector3 = Vector3.DOWN

func _input(_event: InputEvent, _owner: Character) -> void:
	pass


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	_owner.velocity += Gravity * GravityVector * _delta
