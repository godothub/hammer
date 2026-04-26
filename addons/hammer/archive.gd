extends Node
## 这是一个存档管理脚本，通过自动加载实现全局可访问。
## 对本脚本会对注册的节点的导出参数进行存储。

var archive:ConfigFile ## 成员数据库。

var registry:Dictionary ## 成员注册表信息。

var path:String ## 存档文件路径。

class PropertyData extends Resource:
	@export var node:NodePath
	@export var data:Dictionary[String, Variant]

## 保存所有数据。
func save(_path:String) -> void:
	if _path: path = _path
	capture()
	archive.save(_path)
## 读取所有内容并应用。
func read(_path:String) -> void:
	if _path: path = _path
	archive.load(_path)
	archive.to_string()
	#apply()

## 应用所有成员数据库数据到注册成员。
func apply() -> void:
	for node:Node in registry:
		var bind:Dictionary = registry[node]
		var data:Variant = archive.get_value(bind["section"], bind["key"])
		for property:StringName in bind["property_list"]:
			node.set(property, data[property])
## 截取所有注册成员数据到成员数据库。
func capture() -> void:
	for node:Node in registry:
		var bind:Dictionary = registry[node]
		var data:Dictionary
		for property:StringName in bind["property_list"]:
			var value:Variant = node.get(property)
			#if value is Node:
				#data[property] = value.get_path()
			#elif value is Array:
				#pass
			
			data[property] = node.get(value)
		archive.set_value(bind["section"], bind["key"], data)

## 对节点进行注册，若节点已经注册则覆盖注册信息。
func register(_node:Node, _property_list:PackedStringArray, _section:String, _key:String) -> void:
	registry[_node] = {"section":_section, "key":_key, "property_list": _property_list}
## 注销节点的存档注册。
func deregister(_node:Node) -> void:
	registry.erase(_node)
