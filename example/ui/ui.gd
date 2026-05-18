extends UI

@export var pause_key:StringName = "Pause"

func _run() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _stop() -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if UserInterface != self:queue_free()
	
	set_status(true)

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint():return
	if _event is InputEventKey:
		if Input.is_action_just_pressed(pause_key):
			set_status(get_tree().paused)
