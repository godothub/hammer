extends Node
class_name Archive
## 这是一个存档管理脚本，通过自动加载实现全局可访问。
## 对本脚本会对注册的节点的导出参数进行存储。

var file:String ## 存档文件名称
var directory:String = "user://archive/" ## 存档目录

var archive:ConfigFile = ConfigFile.new() ## 成员数据库。
var registry:Dictionary ## 成员注册表信息。

## 获取存档文件
func get_archive_files() -> PackedStringArray:
	DirAccess.make_dir_recursive_absolute(directory)
	var files:PackedStringArray = DirAccess.open(directory).get_files()
	return files

signal saving_signal ## 在捕获数据之后和保存数据之前触发此信号。用于补充存档信息。
signal reading_signal ## 在读取数据时触发此信号.
## 保存所有数据。
func save() -> Error:
	# 获取数据
	_capture()
	saving_signal.emit()
	return archive.save(directory.path_join(file))
## 存储为指定文件。
func save_to_file(_file:String) -> Error:
	file = _file
	return save()

## 读取所有内容并应用。
func read(_file:String) -> Error:
	file = _file
	if not archive:archive = ConfigFile.new()
	reading_signal.emit()
	return archive.load(directory.path_join(file))

func _capture() -> void:
	for object:Node in registry:
		var bind:Dictionary = registry[object]
		var data:Dictionary
		for property:StringName in bind["property_list"]:
			data[property] = object.get(property)
		set_value(bind["section"], bind["key"], data)

signal applied_signal ## 应用数据时触发，在所有数据应用完成后。
## 应用所有成员数据库数据到注册成员。
func apply() -> void:
	for object:Object in registry:
		var bind:Dictionary = registry[object]
		if not has_section_key(bind["section"], bind["key"]):continue
		var data:Variant = get_value(bind["section"], bind["key"])
		for property:StringName in bind["property_list"]:
			object.set(property, data[property])
	applied_signal.emit()

func delete(_file:String) -> void:
	var dir:DirAccess = DirAccess.open(directory)
	dir.remove(_file)

## 对节点进行注册，若节点已经注册则覆盖注册信息。
func register(_object:Object, _property_list:PackedStringArray, _section:String, _key:String) -> void:
	registry[_object] = {"section":_section, "key":_key, "property_list": _property_list}

## 注销节点的注册。
func deregister(_node:Node) -> void:
	registry.erase(_node)




func set_value(_section:String, _key:String, _value:Variant) -> void:
	archive.set_value(_section, _key, _value)

func get_value(_section:String, _key:String, _default:Variant = null) -> Variant:
	return archive.get_value(_section, _key, _default)

func has_section_key(_section:String, _key:String) -> bool:
	return archive.has_section_key(_section, _key)
