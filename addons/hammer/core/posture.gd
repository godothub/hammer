extends Resource
class_name Posture
## 角色姿势信息
## 在后续的版本中可能会被移除

## 速度
@export var Speed: float:
	set(_speed):
		Speed = abs(_speed)

## 加速度
@export var Accel: float:
	set(_accel):
		Accel = abs(_accel)

## 高度
@export var Height: float:
	set(_height):
		Height = abs(_height)

## 宽度
@export var Radius: float:
	set(_radius):
		Radius = abs(_radius)
