extends Node

@export var tool_list:Array[Tool]:
	set(_tool_list):
		var tmp_list:Array[Tool]
		for tool:Tool in _tool_list:
			if tool != null and not _tool_list.has(tool):
				tmp_list.append(tool)
		if tool_list != tmp_list:
			tool_list = tmp_list

func _ready() -> void:
	var _tool_list:Array[Tool] = [
		$ToolGun
	]
	var tmp_list:Array[Tool]
	for tool:Tool in _tool_list:
		print(tool)
		if tool != null and not _tool_list.has(tool):
			tmp_list.append(tool)
	print(tmp_list)