extends CharacterBody3D
class_name Character
## 角色节点

enum MovementEnum {Air, Stand, Squat}
## 移动状态
@export var MovementStatus:MovementEnum = MovementEnum.Stand:
	set(_movement_status):
		MovementStatus = _movement_status
		UpdateMovement()
		ChangedTool(-1)


@export_group("Gravity")
## 重力方向
@export var GRAVITY_DIR:Vector3 = Vector3.DOWN
## 重力加速度
@export var GRAVITY_ACC:float = 10
## 跳跃速度
@export var JUMP_SPEED:float = 4

@export_group("Move")
@export_subgroup("Air")
## 空中速度
@export var AIR_SPEED:float = 1
## 空中加速度
@export var AIR_ACC:float = 1
@export_subgroup("Stand")
## 站立速度
@export var STAND_SPEED:float = 3
## 站立加速度
@export var STAND_ACC:float = 10
@export_subgroup("Squat")
## 下蹲速度
@export var SQUAT_SPEED:float = 2
## 下蹲加速度
@export var SQUAT_ACC:float = 5

var MoveDir:Vector3 = Vector3.ZERO ## 移动方向
var MoveSpeed:float = SQUAT_SPEED ## 移动速度
var MoveAcc:float = SQUAT_ACC ## 移动加速度

@export_group("Navigation")
## 启用导航
@export var EnableNav:bool = false
## 导航目标
@export var TargetNode:Marker3D
## 导航载体
@export var NavAgent:NavigationAgent3D

@export_group("Tool")
## 当前工具
@export var ToolLock:bool = false
@export var CurrentTool:Tool:
	set(_current_tool):
		CurrentTool = _current_tool
		AddTool(_current_tool)
## 工具射线
@export var ToolRay:RayCast3D
## 工具列表
@export var ToolList:Array[Tool]


func _physics_process(_delta: float) -> void:
	PhysicsLoop(_delta)

func PhysicsLoop(_delta:float):
	if EnableNav:
		Navigation(_delta)
	Move(_delta)

	ToolLoop(_delta)

## 更新移动状态
func UpdateMovement(_movement_status:MovementEnum = -1):
	if _movement_status != -1:
		MovementStatus = _movement_status
	match MovementStatus:
		MovementEnum.Air:
			MoveAcc = AIR_ACC
			MoveSpeed = AIR_SPEED
		MovementEnum.Stand:
			MoveAcc = STAND_ACC
			MoveSpeed = STAND_SPEED
		MovementEnum.Squat:
			MoveAcc = SQUAT_ACC
			MoveSpeed = SQUAT_SPEED

## 平滑移动
func Move(_delta:float) -> void:
	var move_vector:Vector3 = velocity.slide(global_basis.y)

	velocity -= (move_vector - MoveDir * MoveSpeed) * _delta * MoveAcc
	velocity += GRAVITY_ACC * GRAVITY_DIR * _delta

	move_and_slide()

## 导航
func Navigation(_delta:float) -> void:
	if TargetNode and NavAgent:
		NavAgent.target_position = TargetNode.global_position
		if NavAgent.is_navigation_finished():
			MoveDir = Vector3.ZERO
		else:
			MoveSpeed = STAND_SPEED
			MoveAcc = STAND_ACC
			MoveDir = (NavAgent.get_next_path_position() - global_position).normalized()

## 切换工具
func ChangedTool(_current_tool:int):
	if _current_tool >= ToolList.size():
		return
	if CurrentTool.SelfCheck():
		return
	
	for i in range(ToolList.size()):
		var tool:Tool = ToolList[i]
		if i != _current_tool:
			tool.hide()
		else:
			tool.show()
			ToolRay.target_position = tool.InteractionDistance * Vector3(0, 0, -1)

## 添加工具
func AddTool(_tool:Tool):
	if ToolList.has(_tool):return
	if not _tool.SelfCheck():return
	ToolList.append(_tool)

## 移除工具
func RemoveTool(_tool:Tool):
	ToolList.erase(_tool)


func ToolLoop(_delta:float):
	if CurrentTool and ToolRay:
		CurrentTool.ToolLoop(_delta, self, ToolRay)
