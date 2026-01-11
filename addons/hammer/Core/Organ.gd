extends Node3D
class_name Organ
## 响应部件，用于响应Trigger的触发

## 触发状态
var Status:bool = false
## 反转触发状态
var Reversal:bool = false

## 触发器列表
@export var TriggerList:Array[Trigger]


func _physics_process(_delta: float) -> void:
	OrganLoop(_delta)
	
## 机关主循环
func OrganLoop(_delta:float):
	OrganStatus()
	if Status:
		OnLoop(_delta)
	else:
		OffLoop(_delta)

## 机关状态切换
func OrganStatus() -> void:
	for t in TriggerList:
		if !t.Status:
			Status = false
			return
	Status = true

## 开启状态主循环
func OnLoop(_delta:float) -> void:
	pass

## 关闭状态主时循环
func OffLoop(_delta:float) -> void:
	pass
