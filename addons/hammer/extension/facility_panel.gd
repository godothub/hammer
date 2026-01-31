extends Facility
class_name FacilityPanel
## 移动平台

## 平台节点
@export var panel_node: StaticBody3D
## 初始目标位置
@export var from_node: Marker3D
## 平台目标位置
@export var to_node:Marker3D
## 平台移动速度
@export var move_speed: float = 3
## 平台旋转速度
@export var rotate_speed: float = 90


## 平台移动
func _move(_delta: float, _to: Vector3):
	panel_node.global_position = panel_node.global_position.move_toward(_to, move_speed * _delta)


## 平台旋转
func _rotate(_delta: float, _to: Vector3):
	panel_node.global_rotation_degrees = panel_node.global_rotation_degrees.move_toward(
		_to, rotate_speed * _delta
	)


func _physics_process(_delta: float) -> void:
	if from_node and to_node:
		if enable:
			_move(_delta, to_node.global_position)
			_rotate(_delta, to_node.global_rotation_degrees)
		else:
			_move(_delta, from_node.global_position)
			_rotate(_delta, from_node.global_rotation_degrees)
	active = enable

func _ready() -> void:
	panel_node.global_transform = from_node.global_transform
