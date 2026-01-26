extends Driver
class_name DriverNavigation
## 导航驱动器

@export var target_point: Vector3  ## 导航目标位置 使用全局坐标系

@export_node_path("NavigationAgent3D") var navigation_agent: NodePath  ## 导航节点路径

func _input(_event: InputEvent, _owner: Character) -> void:
	pass


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	var nav_agent: NavigationAgent3D = _owner.get_node(navigation_agent)
	if nav_agent:
		nav_agent.target_position = target_point
		if nav_agent.is_navigation_finished():
			_owner.move_direction = Vector3.ZERO
		else:
			_owner.move_direction = (
				(nav_agent.get_next_path_position() - _owner.global_position).normalized()
			)
