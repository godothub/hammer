extends Tool
class_name PickTool
## 抓取交互工具

## 抓取或交互实体
var pick_object: RigidBody3D

## 目标抓取位置
@export var object_position: Marker3D

## 物体加速度
@export var object_accel: float = 5000
## 释放时最大速度
@export var release_speed_max: float = 5

## 功能主循环
func ToolLoop(_delta: float, _parent: Node3D, _ray: RayCast3D) -> void:
	if pick_object:
		pick_object.linear_velocity = (
			(object_position.global_position - pick_object.global_position) * _delta * object_accel
		)
	if Input.is_action_just_pressed("Use"):
		if pick_object:
			var velocity_normal: Vector3 = pick_object.linear_velocity.normalized()
			var velocity_length: float = pick_object.linear_velocity.length()
			if velocity_length > release_speed_max:
				pick_object.linear_velocity = velocity_normal * release_speed_max
			pick_object = null
		elif _ray.is_colliding():
			var object = _ray.get_collider()
			if object is RigidBody3D:
				pick_object = _ray.get_collider()
