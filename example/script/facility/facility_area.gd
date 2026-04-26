@tool
extends Facility
class_name FacilityArea
## 区域检测

## 区域节点
@export var area:Area3D:
	set(_area):
		if Engine.is_editor_hint():
			update_configuration_warnings()
		else:
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
var body_list: Array[Node3D]

## 物体进入
func body_enter(_body: Node3D) -> void:
	if enable_character and _body is Character:
		body_list.append(_body)
	elif enable_rigid and _body is RigidBody3D:
		body_list.append(_body)
	active_update()
## 物体推出
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

func _get_configuration_warnings() -> PackedStringArray:
	var waring:PackedStringArray
	if not area: waring.append("area 不能为空")
	return waring
