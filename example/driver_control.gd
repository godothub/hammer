extends Driver
class_name ControlDriver
## 控制驱动器

@export var mouse_sensitivity: float = 0.1  ## 鼠标灵敏度

@export var jump_speed: float = 4  ## 跳跃速度

func _input(_event: InputEvent, _owner: Character) -> void:
	if _event is InputEventMouseMotion:
		_owner.rotate_object_local(Vector3.UP, deg_to_rad(-_event.relative.x * mouse_sensitivity))
		_owner.head_node.rotate_x(deg_to_rad(-_event.relative.y * mouse_sensitivity))
		_owner.head_node.rotation.x = clamp(
			_owner.head_node.rotation.x, deg_to_rad(-90), deg_to_rad(90)
		)


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	var input_vector: Vector3 = Vector3.ZERO
	var body_basis: Basis = _owner.global_basis

	if Input.is_action_pressed("Forward"):
		input_vector += -body_basis.z
	if Input.is_action_pressed("Back"):
		input_vector += body_basis.z
	if Input.is_action_pressed("Left"):
		input_vector += -body_basis.x
	if Input.is_action_pressed("Right"):
		input_vector += body_basis.x

	_owner.move_direction = input_vector

	# 其他控制
	if _owner.is_on_floor():
		_owner.update_postrue("Stand")

		if Input.is_action_just_pressed("Jump"):
			_owner.velocity += jump_speed * body_basis.y
	else:
		_owner.update_postrue("Midair")
