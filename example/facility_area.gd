
extends Facility
class_name FacilityArea
## 区域检测

## 区域节点
@export var area: Area3D:
	set(_area):
		if not Engine.is_editor_hint():
			if _area:
				_area.body_entered.connect(BodyEnter)
				_area.body_exited.connect(BodyExit)
			if area:
				area.body_entered.disconnect(BodyEnter)
				area.body_exited.disconnect(BodyExit)

		body_list.clear()
		area = _area

## 检测角色
@export var enable_character: bool = true
## 检测物体
@export var enable_rigid: bool = true

## 物体列表
var body_list: Array


## 玩家进入
func BodyEnter(_body: Node3D) -> void:
	if enable_character and _body is Character:
		body_list.append(_body)
	elif enable_rigid and _body is RigidBody3D:
		body_list.append(_body)
	ActiveUpdate()


func BodyExit(_body: Node3D) -> void:
	if _body in body_list:
		body_list.erase(_body)
	ActiveUpdate()


## 更新状态
func ActiveUpdate():
	if body_list:
		active = true
	else:
		active = false
