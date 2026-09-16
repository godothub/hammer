extends Facility
class_name FacilityButton

enum ModeEnum{SWITCH, DELAY} ## 按钮模式枚举

@export var mode:ModeEnum = ModeEnum.SWITCH ## 按钮模式

@export var delay:float = 3

## 按钮按下。
func pressed() -> void:
	match mode:
		ModeEnum.SWITCH:
			active = not active
		ModeEnum.DELAY:
			active = true
			await get_tree().create_timer(delay).timeout
			active = false

