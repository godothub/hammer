@tool
extends Node3D
class_name GameRoot
## 游戏根节点


## 管理根节点
func get_manage_root() -> ManageRoot:
	return get_parent()


## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	if get_parent() is not ManageRoot:
		warning.append("GameRoot 类型的父节点必须是 ManageRoot 类型")
	return warning


# 无缝场景

## 场景文件目录
@export_dir var scene_directory: String = "res://scene"

## 场景附加信号
signal scene_append_signal(_file: StringName)


## 附加场景
func scene_append(_file: String) -> bool:
	if get_node(_file):
		return false

	var path: String = scene_directory.path_join(_file + ".tscn")
	var scene: Scene = load(path).instantiate()

	add_child(scene)
	scene.owner = self

	scene.set_name(_file)
	scene.set_owner(self)

	scene_append_signal.emit(_file)
	return true


## 场景移除信号
signal scene_remove_signal(_file: StringName)


## 场景移除
func scene_remove(_file: String) -> bool:
	var scene: Scene = get_node(_file)
	if not scene:
		return false
	scene.owner = null
	scene.queue_free()
	scene_remove_signal.emit(_file)
	return true


func scene_node(_file: String) -> Scene:
	return get_node(_file)

## 存档位置
@export_dir var archive_directory: String = "res://archive"
## 存档日期格式
@export var archive_file: String = "{year}-{month}-{day}-{hour}-{minute}-{second}"


## 场景保存
func achieve_save() -> bool:
	for _child in get_children():
		_child.owner = self
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var file = archive_file.format(datetime_dict) + ".tscn"
	ResourceSaver.save(packed_scene, archive_directory.path_join(file))
	return true


## 加载存档
func achieve_load(_file: StringName) -> void:
	var manage_root = get_manage_root()
	var achieve_game = ResourceLoader.load(archive_directory.path_join(_file)).instantiate()
	manage_root.remove_child.call_deferred(self)
	manage_root.add_child.call_deferred(achieve_game)
	manage_root.game_root = achieve_game
	queue_free()


## 清空存档
func achieve_clear() -> bool:
	var dir: DirAccess = DirAccess.open(archive_directory)
	var files: Array[StringName] = dir.get_files()
	files.all(func(_file: StringName): dir.remove(_file))
	return true


func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)
