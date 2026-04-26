extends Node
class_name Portal
## 场景门户。
## 用于判断

@export_storage var scene_1:Scene:
	set(_scene_1):
		if scene_1:
			scene_1.tree_exited.disconnect(scene_updated)
		if _scene_1:
			_scene_1.tree_exited.connect(scene_updated)
@export_storage var scene_area_1:Area3D:
	set(_scene_area_1):
		if scene_area_1:
			pass
			#scene_area_1.body_entered.connect()

@export_storage var scene_2:Scene
@export_storage var scene_area_2:Node3D

func scene_updated() -> void:
	if not scene_1 and not scene_2:
		queue_free()
