@tool
extends CharacterBody3D
class_name Character
## 角色节点

## 头部节点
@export var head_node: Node3D:
	set(_head_node):
		head_node = _head_node
		update_configuration_warnings()

## 主碰撞体
@export var collide_node: CollisionShape3D:
	set(_collide_node):
		collide_node = _collide_node
		update_configuration_warnings()

## 驱动器列表
@export var driver_list: Array[Driver]:
	set(_driver_list):
		var type_list: PackedStringArray
		var tmp_dirver_list: Array[Driver]

		for _driver: Driver in _driver_list:
			if _driver:
				var type: StringName = _driver.get_script().get_global_name()

				if not type_list.has(type):
					type_list.append(type)
					tmp_dirver_list.append(_driver)

			elif Engine.is_editor_hint():
				tmp_dirver_list.append(_driver)

		driver_list = tmp_dirver_list

@export_group("Health")
signal health_updated_signal(_delta:float)
## 最大健康值
@export var health_max: float = 100:
	set(_health_max):
		health_value = _health_max
		health_max = _health_max
## 健康值
@export var health_value: float = 100:
	set(_health_value):
		if health_value < 0:
			pass
		else:
			health_value = clampf(_health_value, 0, health_max)

@export_group("Postrue")
## 姿态名称
@export var posture_name: StringName:
	set(_posture_name):
		if Engine.is_editor_hint():
			posture_name = _posture_name
			return
		if posture_table.size() == 0:
			posture_name = ""
		if posture_table.keys().has(_posture_name):
			posture_name = _posture_name
## 姿态列表
@export var posture_table: Dictionary[StringName, Posture]

var move_direction: Vector3 = Vector3.ZERO  ## 移动方向
var move_speed: float = 0  ## 移动速度
var move_accel: float = 0  ## 移动加速度

@export_group("Tool")
## 当前工具
@export var current_tool: Tool:
	set(_current_tool):
		if not Engine.is_editor_hint():
			add_tool(_current_tool)
		current_tool = _current_tool

## 工具射线
@export var tool_ray: RayCast3D
## 工具列表
@export var tool_list: Array[Tool]


func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray

	if collide_node:
		if not get_children().has(collide_node):
			warning.append("CollideNode 必须是该节点的子节点")
	else:
		warning.append("CollideNode 不应为空")

	if not head_node:
		warning.append("HeadNode 不应为空")

	return warning


## 更新移动状态
func update_postrue(_posture_name: StringName = posture_name) -> void:
	if not posture_table.has(_posture_name):
		return
	var posture: Posture = posture_table[_posture_name]

	posture_name = _posture_name
	# 碰撞变更
	collide_node.shape.radius = posture.Radius
	collide_node.shape.height = posture.Height
	collide_node.position.y = posture.Height / 2
	# 移动状态变更
	move_speed = posture.Speed
	move_accel = posture.Accel


## 平滑移动
func _movement(_delta: float) -> void:
	var move_vector: Vector3 = velocity.slide(global_basis.y)
	velocity -= (move_vector - move_direction * move_speed) * _delta * move_accel
	move_and_slide()


## 切换工具
func changed_tool(_current_tool: int):
	if _current_tool >= tool_list.size():
		return
	if current_tool.SelfCheck():
		return
	for i in range(tool_list.size()):
		var tool: Tool = tool_list[i]
		if i != _current_tool:
			tool.hide()
		else:
			tool.show()
			tool_ray.target_position = tool.InteractionDistance * Vector3(0, 0, -1)


## 添加工具
func add_tool(_tool: Tool) -> bool:
	if _tool == null:
		return false
	if tool_list.has(_tool):
		return false
	tool_list.append(_tool)
	return true


## 移除工具
func remove_tool(_tool: Tool) -> bool:
	tool_list.erase(_tool)
	return true

func _init() -> void:
	if Engine.is_editor_hint():
		return
	tree_entered.connect(func(): owner = get_parent())


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	## 驱动器处理
	for _driver: Driver in driver_list:
		if _driver.enable:
			_driver._process(_delta, self)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	## 工具处理
	if current_tool and tool_ray:
		current_tool.ToolLoop(_delta, self, tool_ray)

	## 驱动器处理
	for _driver: Driver in driver_list:
		if _driver.enable:
			_driver._physics_process(_delta, self)

	_movement(_delta)


func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	## 驱动处理
	for _driver: Driver in driver_list:
		if _driver.enable:
			_driver._input(_event, self)
