extends Driver
class_name DriverInteract
## 交互驱动器

@export var key:StringName = "Interact"

@export_node_path("RayCast3D") var ray_path:NodePath:
	set(_ray_path):
		ray_path = _ray_path

		ray_update()
var ray_node:RayCast3D
## 更新射线
func ray_update() -> void:
	if character and ray_path:
		ray_node = character.get_node(ray_path)
		ray_node.target_position = capture_distance * Vector3.FORWARD
	else:
		ray_node = null


@export_group("capture")
@export var capture:bool = true ## 启用抓取
@export var capture_offset:Vector3 = Vector3(0, -0.2, -2) ## 目标抓取位置
@export var capture_distance:float = 5 ## 距离
@export var capture_speed: float = 20 ## 物体速度
@export_storage var capture_object: Node3D ## 交互实体


func _ready() -> void:
	ray_update()

func _physics_process(_delta: float) -> void:
	if capture and capture_object:
		var vector:Vector3 = (ray_node.global_position + ray_node.global_basis * capture_offset) - capture_object.global_position
		capture_object.linear_velocity = vector * capture_speed
	if Input.is_action_just_pressed(key):
		var node:Node = ray_node.get_collider()
		if capture and capture_object: capture_object = null
		elif node:
			if node is RigidBody3D:
				capture_object = node
			else:
				var parent = node.get_parent()
				if parent is FacilityInteract:
					parent.interact()
		
		
		#if object:
			#var vector:Vector3 = (ray.global_position + ray.global_basis * offset) - object.global_position
			#object.linear_velocity = vector * speed
			#
		#if Input.is_action_just_pressed(key):
			#if object:
				#object = null
			#else:
				#var target:Object = driver_tool.ray_node.get_collider()
				#if target is RigidBody3D: object = target
