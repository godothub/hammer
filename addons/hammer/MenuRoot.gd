@tool
extends Control
class_name MenuRoot
## 所有菜单的根节点

## 获取管理根节点
func GetManageRoot() -> ManageRoot:
	return get_parent()


## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	if get_parent() is not ManageRoot:
		warning.append("MenuRoot 类型的父节点必须是 ManageRoot 类型")
	for _node in get_children():
		if _node is not Menu:
			warning.append(_node.get_name() + " 作为 MenuRoot 类型的子节点必须是 Menu 类型")
	return warning

## 显示指定 _title 的菜单
func ShowMenuTitle(_title:String, _argument:String = "") -> void:
	var menu:Menu = get_node(_title)
	ShowMenu(menu, _argument)
	

func ShowMenu(_menu:Menu, _argument:String = "") -> void:
	_menu.Command(_argument)
	_menu.Show()

## 显示指定 _title 的菜单
func HideMenuTitle(_title:String) -> void:
	var menu:Menu = get_node(_title)
	HideMenu(menu)
	

func HideMenu(_menu:Menu) -> void:
	if not _menu.AlwaysOn:
		_menu.Hide()

## 隐藏所有菜单
func HideAllMenu() -> void:
	for _menu:Menu in get_children():
		HideMenu(_menu)

func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)

func _ready() -> void:
	HideAllMenu()
