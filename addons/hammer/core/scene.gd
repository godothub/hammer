@tool
extends Node3D
class_name Scene
## 处理所有场景事件

## 交界设备列表
@export var edge_facility_table: Dictionary[StringName, Facility]:
	set(_edge_facility_table):
		if not Engine.is_editor_hint():
			for _facility: Facility in edge_facility_table.values():
				if _facility:
					_facility.active_signal.disconnect(edge_facility_active)
					_facility.inactive_signal.disconnect(edge_facility_inactive)
			for _facility: Facility in _edge_facility_table.values():
				if _facility:
					_facility.active_signal.connect(edge_facility_active)
					_facility.inactive_signal.connect(edge_facility_inactive)
		edge_facility_table = _edge_facility_table
		update_configuration_warnings()

## 自动保存设备
@export var archive_facility_list:Array[Facility]:
	set(_archive_facility_list):
		if not Engine.is_editor_hint():
			for _facility: Facility in archive_facility_list:
				if _facility:
					_facility.active_signal.disconnect(archive_facility_active)
			for _facility: Facility in _archive_facility_list:
				if _facility:
					_facility.active_signal.connect(archive_facility_active)
		archive_facility_list = _archive_facility_list
		update_configuration_warnings()

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray

	var game_root:GameRoot = get_game_root()
	if get_game_root() is not GameRoot:
		warning.append("Scene 类型的父节点必须是 GameRoot 类型")

	for _facility: Facility in edge_facility_table.values():
		if not _facility:
			warning.append(
				"EdgeFacilityList 属性的 " + edge_facility_table.find_key(_facility) + " 键的值不能为空"
			)

	return warning


## 场景根节点
func get_game_root() -> GameRoot:
	return get_parent()


## 边界被启用更新
func edge_facility_active(_facility: Facility) -> void:
	var game_root:GameRoot = get_game_root()
	var file: StringName = edge_facility_table.find_key(_facility)
	game_root.scene_append(file)
	game_root.scene_delay_remove_cancel(file)

	var scene:Scene = game_root.scene_node(file)
	var facility:Facility = scene.edge_facility_table[name]

	facility.enable = _facility.enable

	scene.global_rotation_degrees -= facility.global_rotation_degrees - _facility.global_rotation_degrees
	scene.global_position -= facility.global_position - _facility.global_position


## 边界失效更新
func edge_facility_inactive(_facility: Facility) -> void:
	var game_root: GameRoot = get_game_root()
	var file: StringName = edge_facility_table.find_key(_facility)
	# 对接的场景
	var scene: Scene = game_root.scene_node(file)
	if not scene:
		return

	# 与当前场景对接的facility
	var facility: Facility = scene.edge_facility_table[name]
	if facility.depend_facility_status():
		# 玩家处于对方场景 主动同步对方状态
		_facility.enable = facility.enable
	else:
		# 玩家处于当前场景 移除对方场景
		game_root.scene_delay_remove(file)
		#facility.enable = _facility.enable


func archive_facility_active(_facility: Facility) -> void:
	if _facility.depend_facility_status():
		archive_facility_list.erase(_facility)
		_facility.active_signal.disconnect(archive_facility_active)
		get_game_root().archive_save()
	

func _init() -> void:
	if Engine.is_editor_hint():
		tree_entered.connect(update_configuration_warnings)
	else:
		tree_entered.connect(func(): owner = get_parent())
