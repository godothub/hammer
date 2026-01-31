
extends Facility
class_name FacilityArea
## 区域检测

## 区域节点
@export var area: Area3D:
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

## 检测角色
@export var enable_character: bool = true
## 检测物体
@export var enable_rigid: bool = true

## 物体列表
var body_list: Array


## 玩家进入
func body_enter(_body: Node3D) -> void:
	if enable_character and _body is Character:
		body_list.append(_body)
	elif enable_rigid and _body is RigidBody3D:
		body_list.append(_body)
	active_update()


func body_exit(_body: Node3D) -> void:
	if _body in body_list:
		body_list.erase(_body)
	active_update()


## 更新状态
func active_update():
	if body_list:
		active = true
	else:
		active = false
