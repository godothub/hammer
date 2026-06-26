@tool
extends Node
class_name Archive
## 这是一个存档管理脚本，通过自动加载实现全局可访问。
## 对本脚本会对注册的节点的导出参数进行存储。

var DIRECTORY:String
## 存档文件目录，在任何情况下都不应当直接修改此项。
## 若需修改请设置 ProjectSettings 的 “service/archive_manager/directory” 项。

var archive:ConfigFile = ConfigFile.new() ## 数据存储。
var file:String ## 存档文件文件名

## 获取存档文件列表。
func get_archive_files() -> PackedStringArray:
	DirAccess.make_dir_recursive_absolute(DIRECTORY)
	var files:PackedStringArray = DirAccess.open(DIRECTORY).get_files()
	return files

signal saving_signal ## 在保存操作执行前触发，用于告知所有即将存储的数据。
signal applying_signal ## 在读取完成后触发，用于恢复所有数据。

## 存储所有数据。
func save(_file:String = file) -> Error:
	file = _file
	saving_signal.emit()
	return archive.save(DIRECTORY.path_join(file))

## 读取所有内容并应用。
func apply(_file:String = file) -> Error:
	file = _file
	var error:Error = archive.load(DIRECTORY.path_join(file))
	if error == OK:
		applying_signal.emit()
	return error

func delete(_file:String) -> Error:
	return DirAccess.remove_absolute(DIRECTORY.path_join(_file))
## 存储项是否存在。
func has_value(_section:String, _key:String) -> bool:
	return archive.has_section_key(_section, _key)
## 设置项参数。
func set_value(_section:String, _key:String, _value:Variant) -> void:
	archive.set_value(_section, _key, _value)
## 获取项参数。
func get_value(_section:String, _key:String) -> Variant:
	return archive.get_value(_section, _key)

## 项目设置表。
var PROJECT_SETTING_TABLE:Array[Dictionary] = [
	{
		"property_info":{
			"name": "service/archive_manager/directory",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR
		},
		"initial_value":"user://archives/"
	},
]
## 更新项目设置。
func _update_project_settings() -> void:
	for setting:Dictionary in PROJECT_SETTING_TABLE:
		var property_info:Dictionary = setting["property_info"]
		var initial_value:Variant = setting["initial_value"]
		if not ProjectSettings.has_setting(property_info["name"]):
			ProjectSettings.set_setting(property_info["name"], initial_value)
		if Engine.is_editor_hint():
			ProjectSettings.add_property_info(setting["property_info"])
			ProjectSettings.set_initial_value(property_info["name"], initial_value)
	
	DIRECTORY = ProjectSettings.get_setting("service/archive_manager/directory")
func _init() -> void:
	_update_project_settings()
	ProjectSettings.settings_changed.connect(_update_project_settings)
