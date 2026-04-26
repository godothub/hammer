@abstract
extends Node3D
class_name Tool
## 工具节点

var driver_tool:DriverTool ## 驱动来源

signal enabled_signal() ## 工具启用信号
signal disabled_signal() ## 工具禁用信号
## 启用状态
@export_storage var enable:bool = false:
	set(_enable):
		if enable != _enable:
			enable = _enable
			if enable:
				enabled_signal.emit()
			else:
				disabled_signal.emit()

@export var distance:float = 10 ## 工具可用距离
