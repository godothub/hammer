@tool
extends Node3D
class_name Scene
## 处理所有场景事件

## 交界设备列表
@export var EdgeFacilityList:Dictionary[StringName, Facility]:
	set(_edge_facility_list):
		if not Engine.is_editor_hint():
			for _facility:Facility in EdgeFacilityList.values():
				if _facility:
					_facility.ActiveSignal.disconnect(EdgeFacilityActive)
					_facility.InactiveSignal.disconnect(EdgeFacilityInactive)
			for _facility:Facility in _edge_facility_list.values():
				if _facility: 
					_facility.ActiveSignal.connect(EdgeFacilityActive)
					_facility.InactiveSignal.connect(EdgeFacilityInactive)
		EdgeFacilityList = _edge_facility_list
		update_configuration_warnings()

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	
	var game_root:GameRoot = GetGameRoot()
	if GetGameRoot() is not GameRoot:
		warning.append("Scene 类型的父节点必须是 GameRoot 类型")
	
	for _facility:Facility in EdgeFacilityList.values():
		if not _facility:
			warning.append("EdgeFacilityList 属性的 " + EdgeFacilityList.find_key(_facility) + " 键的值不能为空" )
	
	return warning

## 场景根节点
func GetGameRoot() -> GameRoot:
	return get_parent()

## 边界被启用更新
func EdgeFacilityActive(_facility:Facility) -> void:
	var game_root:GameRoot = GetGameRoot()
	var file:StringName = EdgeFacilityList.find_key(_facility)
	game_root.SceneAppend(file)
	
	var scene:Scene = game_root.SceneNode(file)
	var facility:Facility = scene.EdgeFacilityList[name]
	
	facility.Enable = _facility.Enable
	
	scene.global_position -= facility.global_position - _facility.global_position
	scene.global_rotation_degrees -= facility.global_rotation_degrees - _facility.global_rotation_degrees

## 边界失效更新
func EdgeFacilityInactive(_facility:Facility) -> void:
	var game_root:GameRoot = GetGameRoot()
	var file:StringName = EdgeFacilityList.find_key(_facility)
	# 对接的场景
	var scene:Scene = game_root.SceneNode(file)
	if not scene:
		return
	
	# 与当前场景对接的facility
	var facility:Facility = scene.EdgeFacilityList[name]
	if facility.Active:
		_facility.Enable = facility.Enable
	else:
		# 玩家不在对方场景中
		game_root.SceneRemove(file)

func _init() -> void:
	pass
