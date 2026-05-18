extends Driver
class_name DriverTool


signal current_updated_signal(_index:int)
## 当前序号
@export var current: int = -1
## 当前工具更新
func use(_index:int) -> void:
	var tool:Tool = get_tool_or_null(_index)
	if tool:
		current = -1
		tool.hide()
		tool.process_mode = Node.PROCESS_MODE_DISABLED
	tool = get_tool_or_null(_index)
	if tool:
		current = _index
		tool.show()
		tool.process_mode = Node.PROCESS_MODE_INHERIT
	current_updated_signal.emit(current)

func nonuse_all():
	for tool:Tool in list:
		tool.hide()
		tool.process_mode = Node.PROCESS_MODE_DISABLED

## 工具列表
@export_node_path("Tool") var driver_path_list: Array[NodePath]:
	set(_driver_path_list):
		driver_path_list = _driver_path_list
		list_update()
var list:Array[Tool]:
	set(_list):
		for _tool:Tool in list:
			if _tool: _tool.driver_tool = null
		for _tool:Tool in _list:
			if _tool: _tool.driver_tool = self
		list = _list
## 更新列表
func list_update() -> void:
	var tool_list:Array[Tool]
	if character and driver_path_list:
		for _path:NodePath in driver_path_list:
			tool_list.append(character.get_node(_path))
	else:
		tool_list = []
	list = tool_list
## 增加工具
func add(_tool:Tool) -> void:
	if list.find(_tool):return
	list.append(_tool)
	_tool.manager = character
## 移除工具
func del(_index:int) -> void:
	var tool:Tool = list.pop_at(_index)
	if tool: tool.manager = null
## 获取工具
func get_tool_or_null(_index:int) -> Tool:
	if _index < -1 and list.size() < _index:
		return list.get(current)
	else:
		return null


@export_group("key")
@export var key_next:StringName = "Next"
@export var key_previous:StringName = "Previous"

func next() -> void:
	use(current + 1)

func previous() -> void:
	use(current - 1)

## 准备阶段
func _ready() -> void:
	#ray_update()
	list_update()
	nonuse_all()
	use(current)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(key_next): next()
	if Input.is_action_just_pressed(key_previous): previous()
	
	
	
