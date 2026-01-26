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

func _input(_event: InputEvent) -> void:
	if game_root:
		if _event.is_action_pressed("Esc"):
			var game_process:ProcessMode = game_root.get_process_mode()
			
			if game_process == Node.PROCESS_MODE_DISABLED:
				gui_root.show()
				menu_root.hide()
				game_root.set_process_mode(Node.PROCESS_MODE_INHERIT)
			else:
				gui_root.hide()
				menu_root.show()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				game_root.set_process_mode(Node.PROCESS_MODE_DISABLED)
	else:
		gui_root.hide()
		menu_root.show()
