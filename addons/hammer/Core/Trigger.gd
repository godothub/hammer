extends Area3D
class_name Trigger
## 侦测指定的行为

var Status:bool = false



func _physics_process(_delta: float) -> void:
	TriggerLoop(_delta)
	

## 状态检测主循环
## 重载此函数进行配置
func TriggerLoop(_delta:float):
	pass
