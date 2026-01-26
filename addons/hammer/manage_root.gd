@tool
extends Node
class_name ManageRoot
## 所有子根节点的信息交换中心

## 菜单节点
@export var menu_root: MenuRoot:
	set(_menu_root):
		menu_root = _menu_root
		update_configuration_warnings()

## GUI节点
@export var gui_root: GUIRoot:
	set(_gui_root):
		gui_root = _gui_root
		update_configuration_warnings()

## 游戏节点
@export var game_root: GameRoot:
	set(_game_root):
		game_root = _game_root
		update_configuration_warnings()


## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	if not menu_root:
		warning.append("menu_root 不应为空")
	if not gui_root:
		warning.append("gui_root 不应为空")
	if not game_root:
		warning.append("game_root 不应为空")
	return warning
