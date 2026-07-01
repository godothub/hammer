@tool
extends Node
class_name Archive
## 这是一个存档管理脚本，通过自动加载实现全局可访问。
## 对本脚本会对注册的节点的导出参数进行存储。

var data:ConfigFile = ConfigFile.new() ## 数据存储。

## 获取存档目录。
func get_directory() -> String:
	return ProjectSettings.get_setting("service/archive_manager/directory")
## 获取存档文件列表。
func get_files() -> PackedStringArray:
	var directory:String = get_directory()
	DirAccess.make_dir_recursive_absolute(directory)
	var files:PackedStringArray = DirAccess.open(directory).get_files()
	return files
## 删除存档文件。
func delete(_file:String) -> Error:
	return DirAccess.remove_absolute(get_directory().path_join(_file))

signal update_data_signal ## 数据更新信号。当需要更新数据时被触发。
## 通过重写此函数扩展数据更新的行为。
func _update_data() -> void:pass
## 更新数据。
func update_data() -> void:
	_update_data()
	update_data_signal.emit()

## 存储所有数据到指定文件。
func save(_file:String) -> Error:
	update_data()
	return data.save(get_directory().path_join(_file))

## 通过扩展此函数扩展运行存档的行为。
func _play() -> void:pass
## 运行指定存档文件。
func play(_file:String) -> Error:
	var error:Error = data.load(get_directory().path_join(_file))
	if error == OK: _play()
	return error


## 节是否存在。
func has_section(_section:String) -> bool:
	return data.has_section(_section)
## 存储项是否存在。
func has_value(_section:String, _key:String) -> bool:
	return data.has_section_key(_section, _key)
## 设置项参数。
func set_value(_section:String, _key:String, _value:Variant) -> void:
	data.set_value(_section, _key, _value)
## 获取项参数。
func get_value(_section:String, _key:String) -> Variant:
	return data.get_value(_section, _key)


## 更新项目设置。
func _update_project_settings() -> void:
	var project_setting_table:Array[Dictionary] = [
		{
			"property_info":{
				"name": "service/archive_manager/directory",
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_DIR
			},
			"initial_value":"user://archives/"
		},
	]
	for setting:Dictionary in project_setting_table:
		var property_info:Dictionary = setting["property_info"]
		var initial_value:Variant = setting["initial_value"]
		if not ProjectSettings.has_setting(property_info["name"]):
			ProjectSettings.set_setting(property_info["name"], initial_value)
		if Engine.is_editor_hint():
			ProjectSettings.add_property_info(setting["property_info"])
			ProjectSettings.set_initial_value(property_info["name"], initial_value)

func _init() -> void:
	_update_project_settings()
	ProjectSettings.settings_changed.connect(_update_project_settings)
