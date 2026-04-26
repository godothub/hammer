@tool
extends Control

### 信息标签
#@export var info_label:RichTextLabel:
	#set(_info_label):
		#info_label = _info_label
		#update_configuration_warnings()
### 角色节点
#var character:Character
#@export var character_name:StringName ## 角色名称
### 角色信息
#@export_multiline var character_info:String = """character_info:
	#position:{position},
	#rotation:{rotation},
	#velocity:{velocity}
#"""
### 状态显示
#@export_group("basic")
#@export var basic:bool = true
#@export_multiline var basic_info:String = """basic_info:
	#move:
		#move_direction:{move_direction}
		#move_speed: {move_speed}
		#move_accel: {move_accel}
	#head:
		#head_rotation: {head_rotation}
#"""
### 基本驱动器信息
#var basic_driver:DriverBasic
#
#@export_group("tool")
#@export var tool:bool = true:
	#set(_tool):
		#tool = _tool
		#update_configuration_warnings()
#@export var tool_item_list:ItemList:
	#set(_item_list):
		#tool_item_list = _item_list
		#update_configuration_warnings()
#var tool_driver:DriverTool
#
### 角色更新
#func update_character() -> void:
	#character = gui_root.manage_root.game_root.character_get(character_name)
	#update_depend_driver()
### 依赖驱动更新
#func update_depend_driver() -> void:
	#for driver:Driver in character.driver_list:
		#if driver is DriverBasic:
			#basic_driver = driver
		#if driver is DriverTool:
			#tool_driver = driver
#
#func _ready() -> void:
	#if Engine.is_editor_hint():return
	#
	#character = gui_root.manage_root.game_root.character_get(character_name)
	#character.driver_list_updated_signal.connect(update_depend_driver)
	#
	#update_character()
#
#
#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint(): return
	#if not character:return
	#
	### 初始化
	#var data:Dictionary
	#info_label.text = ""
	#
	### 角色信息
	#data = {
		#"velocity": character.velocity,
		#"position": character.global_position,
		#"rotation": character.global_rotation
	#}
	#info_label.text += character_info.format(data)
	#
	### 基础驱动信息
	#if basic:
		#data = {
			#"move_direction": basic_driver.move_direction,
			#"move_speed": basic_driver.move_speed,
			#"move_accel": basic_driver.move_accel,
			#"head_rotation": basic_driver.head.global_rotation
		#}
		#info_label.text += basic_info.format(data)
	#
	### 工具驱动信息
	#if tool:
		#tool_item_list.clear()
		#for tool:Tool in tool_driver.list:
			#if tool:
				#var index = tool_item_list.add_item(tool.name)
		#if tool_driver.current != -1:
			#tool_item_list.select(tool_driver.current)
#
#
#func _get_configuration_warnings() -> PackedStringArray:
	#var warning: PackedStringArray
	#
	#if not info_label: warning.append("info_label 不应为空")
	#if tool and not tool_item_list: warning.append("tool_item_list 不应为空")
	#
	#return warning
