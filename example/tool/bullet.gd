extends Area3D

var speed:float # 速度
var damage:float # 伤害
var timeout:float # 超时

var timeout_record:float # 超时记录器


func _body_entered(_body:Node3D) -> void:
	queue_free()

func _init() -> void:
	body_entered.connect(_body_entered)

func _physics_process(_delta: float) -> void:
	timeout_record += _delta
	if  timeout < timeout_record: queue_free()
	global_position -= global_basis.z * speed * _delta