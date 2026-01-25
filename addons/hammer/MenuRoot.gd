@tool
extends Control
class_name MenuRoot
## 所有菜单的根节点


## 获取管理根节点
func get_manage_root() -> ManageRoot:
	return get_parent()


## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray

	if get_parent() is not ManageRoot:
		warning.append("父节点必须是 ManageRoot 类型")

	for _node in get_children():
		if _node is not Menu:
			warning.append(_node.get_name() + " 作为 MenuRoot 类型的子节点必须是 Menu 类型")

	return warning


## 配置文件目录
@export_dir var ConfigDirectory: String = "res://Config"
## 配置更新信号
signal ConfigUpdateSignal(_file: StringName, _config_file: ConfigFile)


## 加载配置文件
func config_load(_file: StringName) -> ConfigFile:
	var config_file: ConfigFile = ConfigFile.new()
	config_file.load(ConfigDirectory.path_join(_file) + ".cfg")
	return config_file


func config_save(_file: StringName, _config_file: ConfigFile) -> void:
	_config_file.save(ConfigDirectory.path_join(_file) + ".cfg")
	ConfigUpdateSignal.emit(_file, _config_file)


## 显示指定 _title 的菜单
func menu_show_by_title(_title: String, _argument: String = "") -> void:
	var menu: Menu = get_node(_title)
	menu_show(menu, _argument)


## 显示指定 _menu 菜单
func menu_show(_menu: Menu, _argument: String = "") -> void:
	_menu.command(_argument)
	_menu.show()


## 显示指定 _title 的菜单
func menu_hide_by_title(_title: String) -> void:
	var menu: Menu = get_node(_title)
	menu_hide(menu)


## 隐藏指定 _menu 菜单
func menu_hide(_menu: Menu) -> void:
	if not _menu.always_on:
		_menu.hide()


## 隐藏所有菜单
func menu_all_hide() -> void:
	for _menu: Menu in get_children():
		menu_hide(_menu)


func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)


func _ready() -> void:
	menu_all_hide()
