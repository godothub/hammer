extends Node
class_name Scene
## 游戏场景。
## 所有游戏场景都应该属于此类型。

## 存档节点表。{节点:属性}
@export var archive_node_table:Dictionary[Node, PackedStringArray]

## 需要打包的节点列表，要求该节点必须原先是打包场景。{"打包名称"：“打包节点”}
@export var pack_node_list:Dictionary[String, Node]

## 基于设施的场景切换。
#@export var scene_change_table:Dictionary[Facility, PackedScene]:
	#set(_scene_change_table):
		#if not Engine.is_editor_hint():
			#for facility:Facility in scene_change_table:
				#if facility:
					#facility.actived_signal.disconnect(_scene_change_actived)
			#for facility:Facility in _scene_change_table:
				#if facility:
					#facility.actived_signal.connect(_scene_change_actived)
		#scene_change_table = _scene_change_table

## 注册所有表中的存档。
func _archive_node_table_register() -> void:
	for node:Node in archive_node_table:
		ArchiveManager.register(
			node,
			archive_node_table[node],
			scene_file_path,
			get_path_to(node)
		)

## 注销所有存档节点表的注册。
func _archive_node_table_deregister() -> void:
	ArchiveManager._capture()
	for node:Node in archive_node_table:
		ArchiveManager.deregister(node)

## 场景切换被激活。
#func _scene_change_actived(_facility:Facility) -> void:
	#var packed_scene:PackedScene = scene_change_table[_facility]
	#if packed_scene.can_instantiate():
		#get_tree().change_scene_to_node(packed_scene.instantiate())·

func _init() -> void:
	if Engine.is_editor_hint():return

func _ready() -> void:
	if Engine.is_editor_hint():return
	
	_archive_node_table_register()
	ArchiveManager.apply()

func _exit_tree() -> void:
	if Engine.is_editor_hint():return
	_archive_node_table_deregister()
