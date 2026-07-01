extends Node
class_name Scene

## 场景切换表。
@export var change_scene_table:Dictionary[Facility, String]:
	set(_change_scene_table):
		if not Engine.is_editor_hint():
			for facility in change_scene_table:
				facility.actived_signal.disconnect(_change_scene)
			for facility in _change_scene_table:
				facility.actived_signal.connect(_change_scene)
		change_scene_table = _change_scene_table
## 场景切换。
func _change_scene(_facility:Facility) -> void:
	get_tree().change_scene_to_file.call_deferred(change_scene_table[_facility])


## 属性存档表。
@export var group_archive_table:Dictionary[StringName, PackedStringArray] = {
	"character": ["global_transform", "velocity"],
	"rigid": ["global_transform", "linear_velocity", "angular_velocity", "constant_force", "constant_torque"],
	"facility": ["enable"]
}
func _update_data_groups() -> void:
	for group:StringName in group_archive_table:
		for node:Node in get_tree().get_nodes_in_group(group):
			var property_table:Dictionary[StringName, Variant]
			for property:String in group_archive_table[group]:
				property_table.set(property, node.get(property))
			ArchiveManager.set_value(scene_file_path, get_path_to(node), property_table)
func _play() -> void:
	if not ArchiveManager.has_section(scene_file_path):return
	for group:StringName in group_archive_table:
		for node:Node in get_tree().get_nodes_in_group(group):
			var property_table:Dictionary[StringName, Variant] = ArchiveManager.get_value(scene_file_path, get_path_to(node))
			for property:String in property_table:
				node.set(property, property_table[property])
			
func _init() -> void:
	ArchiveManager.update_data_signal.connect(_update_data_groups)
	ready.connect(_play)
