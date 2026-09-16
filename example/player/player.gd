extends Character
class_name Player

var move_speed: float # 移动速度
var move_accel: float # 移动加速度

var mouse_sensitivity:float # 鼠标灵敏度

var jump_speed:float = 5 # 跳跃速度

@export var tool_marker:Marker3D ## 工具位置标记。

@export var target_ray_cast:RayCast3D ## 目标检测射线。

@export var hold_marker:Marker3D ## 抓取物体位置标记。

@export var hold_object:RigidBody3D ## 抓取物体。
@export var hold_accel:float = 10 ## 抓取加速度


@export_group("input_action", "input_action")
@export var input_action_jump:StringName = "player_jump"
@export var input_action_attack:StringName = "player_attack"
@export var input_action_interact:StringName = "player_interact"

@export_subgroup("input_action_move", "input_action_move_")
@export var input_action_move_forward:StringName = "player_move_forward"
@export var input_action_move_back:StringName = "player_move_back"
@export var input_action_move_left:StringName = "player_move_left"
@export var input_action_move_right:StringName = "player_move_right"

@export_subgroup("input_action_tool", "input_action_tool_")
@export var input_action_tool_next:StringName = "player_tool_next"
@export var input_action_tool_previous:StringName = "player_tool_previous"

## 视角旋转控制。
func _input_rotation(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		rotate_object_local(Vector3.UP, deg_to_rad(-_event.relative.x * mouse_sensitivity))
		head_node.rotate_x(deg_to_rad(-_event.relative.y * mouse_sensitivity))
		head_node.rotation.x = clamp(head_node.rotation.x, deg_to_rad(-90), deg_to_rad(90))

## 工具处理。
func _process_tool(_delta: float) -> void:
	# 切换工具
	if Input.is_action_just_pressed(input_action_tool_next):
		tool_current += 1
	if Input.is_action_just_pressed(input_action_tool_previous):
		tool_current -= 1
	
	# 工具控制
	var tool:Tool = get_tool()
	if Input.is_action_just_pressed(input_action_attack):
		if tool is ToolGun:
			tool.pulled_trigger()
	if Input.is_action_pressed(input_action_attack):
		if tool is ToolGun:
			tool.pulling_trigger(_delta)
	if Input.is_action_just_released(input_action_attack):
		if tool is ToolGun:
			tool.released_trigger()

	if tool_current != -1:
		tool_list[tool_current].global_transform = tool_marker.global_transform

## 抓取处理。
func _process_interact(_delta: float) -> void:
	# 交互控制
	if Input.is_action_just_pressed(input_action_interact):
		if hold_object:
			hold_object = null
		elif target_ray_cast.is_colliding():
			var target:Node3D = target_ray_cast.get_collider()
			if target is FacilityButton:
				target.pressed()
			if target is RigidBody3D:
				hold_object = target

	if hold_object:
		hold_object.linear_velocity = (hold_marker.global_position - hold_object.global_position) * hold_accel

## 移动控制。
func _physics_process_move(_delta: float) -> void:
	# 输入运动
	var input_vector:Vector3 = Vector3.ZERO
	if Input.is_action_pressed(input_action_move_forward):
		input_vector -= transform.basis.z 
	if Input.is_action_pressed(input_action_move_back):
		input_vector += transform.basis.z 
	if Input.is_action_pressed(input_action_move_left):
		input_vector -= transform.basis.x
	if Input.is_action_pressed(input_action_move_right):
		input_vector += transform.basis.x
	input_vector = input_vector.normalized()

	velocity -= (velocity.slide(global_basis.y) - input_vector * move_speed ) * _delta * move_accel

	# 重力
	velocity += get_gravity() * _delta

	if is_on_floor():
		if Input.is_action_just_pressed(input_action_jump):
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

func _input(_event: InputEvent) -> void:
	_input_rotation(_event)

func _process(_delta: float) -> void:
	_process_tool(_delta)
	_process_interact(_delta)

func _physics_process(_delta: float) -> void:
	_physics_process_move(_delta)
