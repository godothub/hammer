extends Control
class_name Describe
## 对话和环境的文本说明

@export var TextNode:RichTextLabel
@export var KeepTime:float = 5



func ChangeDescribe(_note:String):
	TextNode.text = _note
	
	await get_tree().create_timer(KeepTime).timeout
	
	TextNode.text = ""
