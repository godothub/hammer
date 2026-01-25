@tool
extends Node3D
class_name Facility
## 活动设施

## 启用更新信号
signal enable_update_signal
## 启用信号
signal enable_signal(_facility: Facility)
## 停用信号
signal disable_signal(_facility: Facility)
## 节点启动状态
@export var enable: bool = true:
	set(_enable):
		if depend_facility_list.size() == 0:
			_enable = true
		if enable != _enable:
			enable = _enable
			enable_update_signal.emit()
			if enable:
				enable_signal.emit(self)
			else:
				disable_signal.emit(self)

## 依赖设备列表
@export var depend_facility_list: Array[Facility]:
	set(_depend_facility_list):
		if not Engine.is_editor_hint():
			_depend_facility_list.erase(null)
			
			for _facility: Facility in depend_facility_list:
				_facility.active_updated_signal.disconnect(depend_falicity_freshed)
			for _facility: Facility in _depend_facility_list:
				_facility.active_updated_signal.connect(depend_falicity_freshed)
		
		depend_facility_list = _depend_facility_list
		depend_falicity_freshed()
		update_configuration_warnings()

## 激活更新信号
signal active_updated_signal
## 激活信号
signal active_signal(_facility: Facility)
## 未激活信号
signal inactive_signal(_facility: Facility)
## 活跃状态
var active: bool = false:
	set(_active):
		if active != _active:
			active = _active
			active_updated_signal.emit()
			if active:
				active_signal.emit(self)
			else:
				inactive_signal.emit(self)


## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray

	for _facility: Facility in depend_facility_list:
		if not _facility:
			warning.append("DependFacilityList 不能存在空物体")

	return warning


## 更新状态
func depend_falicity_freshed() -> void:
	enable = depend_facility_status()


## 检查依赖设备状态
func depend_facility_status() -> bool:
	var enable: bool = true
	for _facility: Facility in depend_facility_list:
		if not _facility.active:
			enable = false
			break
	return enable
