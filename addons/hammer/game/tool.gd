@abstract
extends Node3D
class_name Tool
## 工具节点

## 启用状态
@export_storage var enable:bool = false:
	set(_enable):
		if enable != _enable:
			enable = _enable
			if enable:
				_enable()
			else:
				_disable()
## 通过重写此函数扩展启用时的行为。
func _enable() -> void: pass
## 通过重写此函数扩展停用时的行为。
func _disable() -> void:pass
