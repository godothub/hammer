@abstract
extends Node3D
class_name Facility
## 场景中的设施。
## Facility 根据依赖的 Facility 状态决定自身是否被启用。

signal enable_updated_signal ## 启用更新信号。
signal enabled_signal(_facility: Facility) ## 启用信号，当 Facility 被启用时触发。
signal disabled_signal(_facility: Facility) ## 停用信号，当 Facility 被停用时触发。

## 设施启动状态，主要受依赖的 Facility 影响，当 depend_facility_list 为空时，将被设置为 true。
var enable: bool = true:
	set(_enable):
		if depend_facility_list.size() == 0:
			_enable = true
		if enable != _enable:
			enable = _enable
			enable_updated_signal.emit()
			if enable: enabled_signal.emit(self)
			else: disabled_signal.emit(self)
## 依赖设备列表。更改时请使用 depend_facility_add 和 depend_facility_del 操作，不要使用 Array 函数。 
@export var depend_facility_list: Array[Facility]:
	set(_depend_facility_list):
		if not Engine.is_editor_hint():
			_depend_facility_list.erase(null)
			for _facility: Facility in depend_facility_list:
				if _facility: _facility.active_updated_signal.disconnect(update_enable)
			for _facility: Facility in _depend_facility_list:
				if _facility: _facility.active_updated_signal.connect(update_enable)
		depend_facility_list = _depend_facility_list
		update_enable()
## 添加依赖设备。
func depend_facility_add(_facility:Facility) -> void:
	_facility.active_updated_signal.connect(update_enable)
	depend_facility_list.append(_facility)
	update_enable()
## 移除依赖设备。
func depend_facility_del(_facility:Facility) -> void:
	_facility.active_updated_signal.disconnect(update_enable)
	depend_facility_list.erase(_facility)
	update_enable()
## 刷新启用状态。
func update_enable() -> void:
	var record: bool = true
	for _facility: Facility in depend_facility_list:
		if _facility and not _facility.active:
			enable = false
			return
	enable = true

signal active_updated_signal ## 激活更新信号
signal actived_signal(_facility: Facility) ## 激活信号
signal inactived_signal(_facility: Facility) ## 未激活信号
## 活跃状态,用于被依赖时的状态展示。
var active: bool = false:
	set(_active):
		if not enable:
			active = false
		elif active != _active:
			active = _active
			active_updated_signal.emit()
			if active: actived_signal.emit(self)
			else: inactived_signal.emit(self)
