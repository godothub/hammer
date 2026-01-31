extends FacilityArea
class_name FacilityAreaGravity
## 引力场区域

@export var gravity_direction:Vector3 = Vector3.UP ## 引力方向

@export var gravity_accl:float = 9.8 ## 引力加速度

func _physics_process(_delta: float) -> void:
	var speed = gravity_direction * gravity_accl * _delta
	for _body in body_list:
		if _body is Character:
			_body.velocity += speed
		elif _body is RigidBody3D:
			_body.linear_velocity += speed
