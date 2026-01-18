@tool
extends Facility
class_name FacilityPanel
## 移动平台

## 平台节点
@export var PanelNode:StaticBody3D
## 平台目标位置
@export var PointNode:Marker3D
## 平台移动速度
@export var MoveSpeed:float = 3
## 平台旋转速度
@export var RotateSpeed:float = 90


## 平台移动
func Move(_delta:float, _to:Vector3):
	PanelNode.global_position = PanelNode.global_position.move_toward(_to, MoveSpeed * _delta)

## 平台旋转
func Rotate(_delta:float, _to:Vector3):
	PanelNode.global_rotation_degrees = PanelNode.global_rotation_degrees.move_toward(_to, RotateSpeed * _delta)

func _physics_process(_delta: float) -> void:
	if Enable:
		Move(_delta, PointNode.global_position)
		Rotate(_delta, PointNode.global_rotation_degrees)
	else:
		Move(_delta, global_position)
		Rotate(_delta, global_rotation_degrees)
	Active = Enable
