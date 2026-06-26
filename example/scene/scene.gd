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

@export var property_archive_table:Dictionary[Node, PackedStringArray]

func _saving() -> void:
	ArchiveManager.set_value("", "scene_path", scene_file_path)

func _applying() -> void:
	var scene_path:String = ArchiveManager.get_value("", "scene_path")
	if scene_path != scene_file_path:
		get_tree().change_scene_to_file(scene_path)


func _change_scene(_facility:Facility) -> void:
	get_tree().change_scene_to_file(change_scene_table[_facility])


func _enter_tree() -> void:
	ArchiveManager.saving_signal.connect(_saving)
	ArchiveManager.applying_signal.connect(_applying)
