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

## 背景场景名称
@export var background_scene_list:Array[String]

## 移除背景场景
func background_scene_remove() -> void:
	for _name:StringName in background_scene_list:
		game_root.scene_remove(_name)	

func game_status_switch() -> void:
	var game_process:ProcessMode = game_root.get_process_mode()
	if game_process == Node.PROCESS_MODE_DISABLED:
		game_status_running()
	else:
		game_status_stopping()

## 更变游戏状态为运行
func game_status_running() -> void:
	gui_root.show()
	menu_root.hide()
	game_root.set_process_mode(Node.PROCESS_MODE_INHERIT)

## 更变游戏姿态为暂停
func game_status_stopping() -> void:
	gui_root.hide()
	menu_root.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_root.set_process_mode(Node.PROCESS_MODE_DISABLED)


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
			for _name:StringName in background_scene_list:
				if not game_root.scene_node(_name):
					game_status_switch()
					break
	else:
		game_status_stopping()

func _ready() -> void:
	game_status_stopping()
	
