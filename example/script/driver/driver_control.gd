extends Driver
class_name DriverControl
## 移动控制驱动器

var driver_basic:DriverBasic

@export_group("move")
@export var move:bool = true
@export var move_forward:StringName = "Forward"
@export var move_back:StringName = "Back"
@export var move_left:StringName = "Left"
@export var move_right:StringName = "Right"

@export_group("mouse")
@export var mouse:bool = true
@export var mouse_senes:Vector2 = Vector2(0.1, 0.1)

@export_group("jump")
@export var jump:float = true
@export var jump_speed:float = 5
@export var jump_key:StringName = "Jump"

func _get_depend_list() -> PackedStringArray:
	return ["DriverBasic"]

func _ready() -> void:
	driver_basic = character.driver_find("DriverBasic")


func _input(_event: InputEvent) -> void:
	if not driver_basic: return
	if not driver_basic.head: return
	
	if mouse:
		if _event is InputEventMouseMotion:
			character.rotate_object_local(Vector3.UP, deg_to_rad(-_event.relative.x * mouse_senes.x))
			driver_basic.head.rotate_x(deg_to_rad(-_event.relative.y * mouse_senes.y))
			driver_basic.head.rotation.x = clamp(driver_basic.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(_delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if not driver_basic: return
	
	if move:
		var direction: Vector3 = Vector3.ZERO
		var body: Basis = character.global_basis
		if Input.is_action_pressed(move_forward):
			direction += -body.z
		if Input.is_action_pressed(move_back):
			direction += body.z
		if Input.is_action_pressed(move_left):
			direction += -body.x
		if Input.is_action_pressed(move_right):
			direction += body.x
		driver_basic.move_direction = direction
	
	if character.is_on_floor():
		if jump:
			if Input.is_action_just_pressed(jump_key):
				character.velocity += jump_speed * character.up_direction
	
	
	
