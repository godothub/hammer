extends Driver
class_name ImpactDamageDriver
## 冲击伤害驱动器

## 冲击速度记录
var speed_record: float = 0

@export var impact_speed_threshold: float = 10  ## 冲击速度阈值
@export var impact_damage_ratio: float = 5  ## 冲击伤害比率

func _input(_event: InputEvent, _owner: Character) -> void:
	pass


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	var now_speed: float = _owner.velocity.length()
	if _owner.is_on_ceiling() or _owner.is_on_floor() or _owner.is_on_wall():
		var impact_speed: float = abs(now_speed - speed_record)
		if impact_speed_threshold < impact_speed:
			_owner.health_value -= (impact_speed - impact_speed_threshold) * impact_damage_ratio
	speed_record = now_speed
