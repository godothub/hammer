extends Window
class_name Console
## 控制台

@export var lable:RichTextLabel

func _input(_event: InputEvent) -> void:
	if _event is InputEventKey:
		if _event.pressed:
			var text = _event.as_text_key_label()
			print(text)
