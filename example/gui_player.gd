@tool
extends GUI
class_name GUIPlayer

## 健康值显示
@export var health_node: ProgressBar:
	set(_health_node):
		health_node = _health_node
		update_configuration_warnings()

@export var player_name:StringName

func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray

	if not health_node:
		warning.append("HealthNode 不应为空")

	return warning


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var player:Character = get_gui_root().get_manage_root().game_root.get_node("Player")
	if player:
		health_node.value = player.health_value
