extends Control
class_name UI

## 背景场景列表。
@export_file("*.tscn") var background_list:PackedStringArray

## 通过重写此函数扩展恢复运行时的行为。
func _run() -> void:pass

## 通过重写此函数扩展暂停前的行为。
func _stop() -> void:pass

func set_status(_status:bool) -> void:
	var tree:SceneTree = get_tree()
	if _status and not is_background():
		tree.paused = false
		_run()
	else:
		_stop()
		tree.paused = true

## 判断是否处于背景模式。
func is_background() -> bool:
	var uid:String = ResourceUID.path_to_uid(get_tree().current_scene.scene_file_path)
	if uid in background_list:
		return true
	else:
		return false
