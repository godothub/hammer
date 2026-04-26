extends Driver
class_name DriverBasic
## 移动行为

@export var gravity:bool = true

@export_node_path("Node3D") var head_path:NodePath: ## 头节点路径
	set(_head_path):
		head_path = _head_path
		head_updated()
var head:Node3D

func head_updated() -> void:
	if character and head_path:
		head = character.get_node(head_path)
	else:
		head = null

@export_group("move")
@export var move:bool = true
@export var move_direction: Vector3 = Vector3.ZERO  ## 移动方向
@export var move_speed: float = 5  ## 移动速度
@export var move_accel: float = 10  ## 移动加速度


func _ready() -> void:
	head_updated()

func _physics_process(_delta: float) -> void:
	if gravity:
		character.velocity += character.get_gravity() * _delta
	if move:
		var vector: Vector3 = character.velocity.slide(character.global_basis.y)
		character.velocity -= (vector - move_direction * move_speed) * _delta * move_accel
		character.move_and_slide()

func get_head() -> Node3D:
	if character and head_path:
		return character.get_node(head_path)
	else:
		return null
