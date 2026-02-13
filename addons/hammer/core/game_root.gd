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


## 场景文件目录
@export_dir var scene_directory: String = "res://scene"

## 场景删除记录器
var scene_remove_table:Dictionary[StringName, float]

## 场景附加信号
signal scene_append_signal(_file: StringName)


## 附加场景
func scene_append(_file: String) -> bool:
	if get_node_or_null(_file):
		return false

	var path: String = scene_directory.path_join(_file + ".tscn")
	var scene: Scene = load(path).instantiate()

	add_child(scene)

	scene.set_name(_file)
	scene_expand(scene, self)

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
	return get_node_or_null(_file)

## 存档位置
@export_dir var archive_directory: String = "res://archive"
## 存档日期格式
@export var archive_file: String = "{year}-{month}-{day}-{hour}-{minute}-{second}"

## 场景保存
func archive_save() -> bool:
	scene_expand(self)
	
	var packed_scene:PackedScene = PackedScene.new()
	packed_scene.pack(self)
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	
	datetime_dict["month"] = "%02d" % datetime_dict["month"]
	datetime_dict["day"] = "%02d" % datetime_dict["day"]
	datetime_dict["hour"] = "%02d" % datetime_dict["hour"]
	datetime_dict["minute"] = "%02d" % datetime_dict["minute"]
	datetime_dict["second"] = "%02d" % datetime_dict["second"]
	
	var file = archive_file.format(datetime_dict) + ".tscn"
	ResourceSaver.save(packed_scene, archive_directory.path_join(file))
	
	return true

## 展开场景并设置根节点
func scene_expand(_node: Node, _root: Node = _node) -> void:
	for child in _node.get_children():
		scene_expand(child, _root)
	_node.owner = _root
	_node.scene_file_path = ""



## 加载存档
func archive_load(_file: StringName) -> void:
	
	var manage_root = get_manage_root()
	var achieve_game = ResourceLoader.load(archive_directory.path_join(_file) + ".tscn").instantiate()
	
	manage_root.remove_child.call_deferred(self)
	manage_root.add_child.call_deferred(achieve_game)
	manage_root.game_root = achieve_game
	queue_free()


## 删除存档
func archive_remove(_file:StringName) -> bool:
	var dir: DirAccess = DirAccess.open(archive_directory)
	dir.remove(_file + ".tscn")
	return true

func archive_list() -> PackedStringArray:
	var files:Array = DirAccess.get_files_at(archive_directory)
	files.reverse()
	return files.map(func (_file:String):return _file.get_basename())

func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)
