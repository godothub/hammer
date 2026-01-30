extends Driver
class_name DriverAutoRecovery

@export var health_regen_rate:float = 10 ## 每秒恢复量

func _input(_event: InputEvent, _owner: Character) -> void:
	pass


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	_owner.health_value += health_regen_rate * _delta
