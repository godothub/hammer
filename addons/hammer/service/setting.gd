@tool
extends Node
class_name Settings
## 游戏设置服务。
## 在初始化之前应当使用 init_setting 传递默认参数，以保证此参数第一次出现时不会出错。

var config:ConfigFile = ConfigFile.new()

## 获取设置文件路径。
func get_file() -> String:
	return ProjectSettings.get_setting("service/game_settings/file")

## 保存设置文件。
func save() -> Error:
	return config.save(get_file())
## 读取设置文件。
func read() -> void:
	return config.load(get_file())

signal settings_updated() ## 当有设置项被更新时触发。

## 是否存在设置项。
func has_setting(_section:String, _setting:String) -> bool:
	return config.has_section_key(_section, _setting)
## 更改设置项。
func set_setting(_section:String, _setting:String, _value:Variant) -> void:
	config.set_value(_section, _setting, _value)
	settings_updated.emit()
## 获取设置项的值。如果项目不存在，则会返回 NULL 并会在调试器中警告，因此应当在获取前保证设置项存在。
func get_setting(_section:String, _setting:String) -> Variant:
	if config.has_section_key(_section, _setting):
		return config.get_value(_section, _setting)
	return null
## 初始化设置项，当设置项不存在时写入默认值，否则不进行操作。
func init_setting(_section:String, _setting:String, _default:Variant) -> void:
	if not config.has_section_key(_section, _setting):
		config.set_value(_section, _setting, _default)


## 更新项目设置。
func _update_project_settings() -> void:
	var project_setting_table:Array[Dictionary] = [
		{
			"property_info":{
				"name": "service/game_settings/file",
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_FILE_PATH
			},
			"initial_value":"user://settings.cfg"
		},
	]
	for setting:Dictionary in project_setting_table:
		var property_info:Dictionary = setting["property_info"]
		var initial_value:Variant = setting["initial_value"]
		if not ProjectSettings.has_setting(property_info["name"]):
			ProjectSettings.set_setting(property_info["name"], initial_value)
		ProjectSettings.add_property_info(setting["property_info"])
		ProjectSettings.set_initial_value(property_info["name"], initial_value)

func _init() -> void:
	_update_project_settings()
	ProjectSettings.settings_changed.connect(_update_project_settings)
	tree_entered.connect(read)
	tree_exiting.connect(save)
