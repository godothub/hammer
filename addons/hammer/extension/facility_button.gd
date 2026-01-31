extends Facility
class_name FacilityButton


enum ButtonModeEnum{Switch, Delay} ## 按钮模式枚举

@export var button_mode:ButtonModeEnum = ButtonModeEnum.Switch ## 按钮模式

@export var delay_time:float = 3

@export var action:StringName = "Use" ## 触发事件

@export var area:Area3D:
	set(_area):
		if not Engine.is_editor_hint():
			if _area:
				_area.body_entered.connect(body_enter)
				_area.body_exited.connect(body_exit)
			if area:
				area.body_entered.disconnect(body_enter)
				area.body_exited.disconnect(body_exit)

		body_list.clear()
		area = _area

## 物体列表
var body_list: Array

## 计时器
var timer:Timer

## 玩家进入
func body_enter(_body: Node3D) -> void:
	if _body is Character:
		body_list.append(_body)


func body_exit(_body: Node3D) -> void:
	if _body in body_list:
		body_list.erase(_body)

func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed(action) and body_list:
		match button_mode:
			ButtonModeEnum.Switch:
				active = not active
			ButtonModeEnum.Delay:
				if not timer:
					timer = Timer.new()
					timer.set_one_shot(true)
					add_child(timer)
					timer.timeout.connect(func ():active = false)
				timer.start(delay_time)
				active = true
