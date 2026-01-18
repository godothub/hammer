@tool
extends Facility
class_name FacilityArea
## 区域检测

## 区域节点
@export var Area:Area3D:
	set(_area):
		if not Engine.is_editor_hint():
			if _area:
				_area.body_entered.connect(BodyEnter)
				_area.body_exited.connect(BodyExit)
			if Area:
				Area.body_entered.disconnect(BodyEnter)
				Area.body_exited.disconnect(BodyExit)
		
		BodyList.clear()
		Area = _area

## 检测角色
@export var EnableCharacter:bool = true
## 检测物体
@export var EnableRigid:bool = true

## 物体列表
var BodyList:Array

## 玩家进入
func BodyEnter(_body:Node3D) -> void:
	if EnableCharacter and _body is Character:
		BodyList.append(_body)
	elif EnableRigid and _body is RigidBody3D:
		BodyList.append(_body)
	ActiveUpdate()

func BodyExit(_body:Node3D) -> void:
	if _body in BodyList:
		BodyList.erase(_body)
	ActiveUpdate()

## 更新状态
func ActiveUpdate():
	if BodyList:
		Active = true
	else:
		Active = false
