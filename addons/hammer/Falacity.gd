@tool
extends Node3D
class_name Facility
## 活动设施

## 启用更新信号
signal EnableUpdateSignal
## 启用信号
signal EnableSignal(_facility:Facility)
## 停用信号
signal DisableSignal(_facility:Facility)
## 节点启动状态
@export var Enable:bool = true:
	set(_enable):
		if DependFacilityList.size() == 0:
			_enable = true
		if Enable != _enable:
			Enable = _enable
			EnableUpdateSignal.emit()
			if Enable:
				EnableSignal.emit(self)
			else:
				DisableSignal.emit(self)

## 依赖设备列表
@export var DependFacilityList:Array[Facility]:
	set(_depend_facility_list):
		for _facility:Facility in DependFacilityList:
			_facility.ActiveUpdatedSignal.disconnect(DependFalicityFreshed)
		for _facility:Facility in _depend_facility_list:
			_facility.ActiveUpdatedSignal.connect(DependFalicityFreshed)
		DependFacilityList = _depend_facility_list
		DependFalicityFreshed()
		update_configuration_warnings()

## 激活更新信号
signal ActiveUpdatedSignal
## 激活信号
signal ActiveSignal(_facility:Facility)
## 未激活信号
signal InactiveSignal(_facility:Facility)
## 活跃状态
var Active:bool = false:
	set(_active):
		if Active != _active:
			Active = _active
			ActiveUpdatedSignal.emit()
			if Active:
				ActiveSignal.emit(self)
			else:
				InactiveSignal.emit(self)

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	
	for _facility:Facility in DependFacilityList:
		if not _facility:
			warning.append("DependFacilityList 不能存在空物体")
	
	return warning

## 更新状态
func DependFalicityFreshed() -> void:
	var enable:bool = true
	for _facility:Facility in DependFacilityList:
		if not _facility.Active:
			enable = false
			break
	Enable = enable
