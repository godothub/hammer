@tool
extends Control
class_name MenuRoot
## 所有菜单的根节点

## 菜单根节点显示时，默认显示的菜单
@export var default_menu_list:Array[Menu]:
	set(_default_menu_list):
		default_menu_list.clear()

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
@export_dir var config_directory: String = "res://config"
## 配置更新信号
signal config_update_signal(_file: StringName, _config_file: ConfigFile)


## 读取存储在 config_directory 目录下的配置文件
func config_load(_file: StringName) -> ConfigFile:
	var config_file: ConfigFile = ConfigFile.new()
	config_file.load(config_directory.path_join(_file) + ".cfg")
	return config_file

## 将配置文件储在 config_directory 目录下
func config_save(_file: StringName, _config_file: ConfigFile) -> void:
	_config_file.save(config_directory.path_join(_file) + ".cfg")
	config_update_signal.emit(_file, _config_file)


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
	_menu.hide()

func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)
