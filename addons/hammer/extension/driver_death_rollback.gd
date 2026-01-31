extends Driver
class_name DriverDeathRollback
## 死亡回滚

func _input(_event: InputEvent, _owner: Character) -> void:
	pass


func _process(_delta: float, _owner: Character) -> void:
	pass


func _physics_process(_delta: float, _owner: Character) -> void:
	if not _owner.death_signal.is_connected(_death):
		_owner.death_signal.connect(_death)

func _death(_character:Character) -> void:
	var game_root:GameRoot = _character.get_parent()
	var file = game_root.archive_list()[0]
	game_root.archive_load(file)
	
