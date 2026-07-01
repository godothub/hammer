@tool
extends Archive

func _update_data() -> void:
	ArchiveManager.set_value("scene", "file_path", get_tree().current_scene.scene_file_path)

func _play() -> void:
	get_tree().change_scene_to_file(ArchiveManager.get_value("scene", "file_path"))
