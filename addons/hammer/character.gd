@tool
extends CharacterBody3D
class_name Character
## 专门用于游戏内角色的节点。
## Character 使用 Driver 控制，使 Character 的控制组件模块化。

## 驱动器列表更新信号，在驱动器列表更新时触发。
signal driver_list_updated_signal()

## 驱动器列表，不应当添加多个同类型的驱动器。更改时请使用 driver_add 和 ariver_del 操作，不要使用 Array 函数。 
@export var driver_list: Array[Driver]:
	set(_driver_list):
		if not Engine.is_editor_hint():
			for _driver:Driver in driver_list:
				_driver.character = null
			for _driver: Driver in _driver_list:
				_driver.character = self
		driver_list = _driver_list
		driver_list_updated_signal.emit()

## 根据类型查找驱动列表中的驱动器。
func driver_find(_type:StringName) -> Driver:
	var array:Array[Driver]
	for _driver:Driver in driver_list:
		if _type == _driver.get_script().get_global_name():
			return _driver
	return null

## 添加驱动器，会调用 _driver 的 _ready 函数并触发 driver_list_updated_signal 信号、
func driver_add(_driver:Driver) -> void:
	_driver.character = self
	driver_list_updated_signal.connect(_driver._depend_updated)
	driver_list.append(_driver)
	_driver._ready()
	driver_list_updated_signal.emit()

## 移除驱动器并触发 driver_list_updated_signal 信号、
func driver_del(_driver:Driver) -> void:
	_driver.character = null
	driver_list_updated_signal.disconnect(_driver._depend_updated)
	driver_list.erase(_driver)
	driver_list_updated_signal.emit()

## 驱动器准备，会触发所有 driver_list 中的 _ready 函数。
func driver_ready() -> void:
	for _driver:Driver in driver_list:
		_driver._ready()



func _ready() -> void:
	if Engine.is_editor_hint():return
	driver_ready()

func _input(_event: InputEvent) -> void:
	if Engine.is_editor_hint():return
	for _driver: Driver in driver_list:
		if _driver.enable:_driver._input(_event)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():return
	for _driver: Driver in driver_list:
		if _driver.enable:_driver._process(_delta)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():return
	for _driver: Driver in driver_list:
		if _driver.enable:_driver._physics_process(_delta)

func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray
	return warning
