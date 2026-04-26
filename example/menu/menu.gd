extends Control

@export var pause_key:StringName = "Pause"

## 背景场景列表。
@export_file("*.tscn") var background_list:PackedStringArray

## 运行。
func run() -> void:
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## 停止。
func stop() -> void:
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## 处于背景模式。
func is_background() -> bool:
	var uid:String = ResourceUID.path_to_uid(get_tree().current_scene.scene_file_path)
	if uid in background_list:
		return true
	else:
		return false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	if Menu != self:queue_free()
	if is_background():stop()
	else:run()
	

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint():return
	if _event is InputEventKey:
		if Input.is_action_just_pressed(pause_key):
			if is_background():
				stop()
			else:
				if get_tree().paused:run()
				else:stop()
