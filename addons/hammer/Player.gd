extends Character
class_name Player

@export var MouseSen:float = 0.1

@export var HeadNode:Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(_event: InputEvent) -> void:
	PlayerRotate(_event)

func _physics_process(_delta: float) -> void:
	if EnableNav:
		Navigation(_delta)
	else:
		PlayerMove(_delta)
	Move(_delta)

	ToolLoop(_delta)

## 玩家旋转
func PlayerRotate(_event: InputEvent) -> void:
	if (_event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		rotate_object_local(Vector3.UP, deg_to_rad(- _event.relative.x * MouseSen))
		HeadNode.rotate_x(deg_to_rad(- _event.relative.y * MouseSen))
		HeadNode.rotation.x = clamp(HeadNode.rotation.x, deg_to_rad(-90), deg_to_rad(90))

## 玩家移动
func PlayerMove(_delta:float) -> void:
	var input_vector:Vector3 = Vector3.ZERO
	var body_basis:Basis = global_basis

	if Input.is_action_pressed("Forward"):
		input_vector += -body_basis.z
	if Input.is_action_pressed("Back"):
		input_vector += body_basis.z
	if Input.is_action_pressed("Left"):
		input_vector += -body_basis.x
	if Input.is_action_pressed("Right"):
		input_vector += body_basis.x

	MoveDir = input_vector
	
	# 其他控制
	if is_on_floor():
		UpdateMovement(MovementEnum.Stand)

		if Input.is_action_just_pressed("Jump"):
			velocity -= JUMP_SPEED * GRAVITY_DIR
	else:
		UpdateMovement(MovementEnum.Air)
	
