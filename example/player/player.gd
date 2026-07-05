extends Character

@export var move_speed: float
@export var move_accel: float

@export var jump_speed:float = 5 ## 跳跃速度

var mouse_sensitivity:float
func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
			rotate_object_local(Vector3.UP, deg_to_rad(-_event.relative.x * mouse_sensitivity))
			head_node.rotate_x(deg_to_rad(-_event.relative.y * mouse_sensitivity))
			head_node.rotation.x = clamp(head_node.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(_delta: float) -> void:
	# 重力
	velocity += get_gravity() * _delta
	# 输入运动
	var input_vector:Vector3 = Vector3.ZERO
	if Input.is_action_pressed("Forward"):
		input_vector -= transform.basis.z 
	if Input.is_action_pressed("Back"):
		input_vector += transform.basis.z 
	if Input.is_action_pressed("Left"):
		input_vector -= transform.basis.x
	if Input.is_action_pressed("Right"):
		input_vector += transform.basis.x
	input_vector.normalized()
	velocity -= (velocity.slide(global_basis.y) - input_vector * move_speed) * _delta * move_accel

	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity += jump_speed * up_direction
		action_current = "walk"
	else:
		action_current = "midair"

	

	move_and_slide()

## 默认设置表。
var DEFAULT_SETTING_TABLE:Dictionary[String, Dictionary] = {
	"control" : {
		"mouse_sensitivity" : 5,
	},
}
## 初始化设置。
func _settings_init() -> void:
	for section in DEFAULT_SETTING_TABLE:
		for setting in DEFAULT_SETTING_TABLE[section]:
			GameSettings.init_setting(section, setting, DEFAULT_SETTING_TABLE[section][setting])
	_settings_updated()


func _settings_updated() -> void:
	mouse_sensitivity =  GameSettings.get_setting("control", "mouse_sensitivity") / 100

func _ready() -> void:
	_settings_init()
	GameSettings.settings_updated.connect(_settings_updated)