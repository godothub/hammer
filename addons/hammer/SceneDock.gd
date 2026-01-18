extends Area3D
class_name SceneDock
## 场景对接实例

func GetScene() -> Scene:
	return get_node("../../")

var PlayerEntered:bool = false

## 对接场景名称
@export var DockSceneName:StringName

func _init() -> void:
	body_entered.connect(BodyEntered)
	body_exited.connect(BodyExited)

func BodyEntered(_node:Node3D) -> void:
	if _node is Player:
		PlayerEntered = true
		
		var game_root:GameRoot = GetScene().GetGameRoot()
		game_root.SceneAppend(str(name))
		

func BodyExited(_node:Node3D) -> void:
	if _node is Player:
		PlayerEntered = false
		var game_root:GameRoot = GetScene().GetGameRoot()
		# 对接的场景
		var dock_scene:Scene = game_root.get_node(str(name))
		# 与当前场景对接的SceneDock
		var scene_dock:SceneDock = dock_scene.DockRootNode.get_node(str(GetScene().get_name()))
		if scene_dock.PlayerEntered:
			# 玩家进入对方区域且离开本区域
			pass
		else:
			# 玩家未进入对方区域
			game_root.SceneRemove(str(name))
		
		
