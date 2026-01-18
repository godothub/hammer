@abstract
extends Node3D
class_name Tool
## 工具节点

## 工具作用距离
@export var Distance:float = 10

## 工具运行前自检
func SelfCheck() -> bool:return true

## 工具功能主循环
func ToolLoop(_delta:float, _parent:Node3D ,_ray:RayCast3D) -> void:pass
