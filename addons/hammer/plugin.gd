@tool
extends EditorPlugin

## 插件路径
var path:String = "res://addons/hammer/"

var menu_plugin_table:Dictionary[EditorContextMenuPlugin, Array] = {
	FileSystemMenuPlugin.new(): [EditorContextMenuPlugin.ContextMenuSlot.CONTEXT_SLOT_FILESYSTEM]
}

## 文件系统菜单插件
class FileSystemMenuPlugin extends EditorContextMenuPlugin:
	# 文件系统菜单
	func _popup_menu(_paths: PackedStringArray) -> void:
		if _paths.size() == 1:
			var path:String = _paths[0]
			if path.get_extension() == "tscn":
				add_context_menu_item("设置为用户界面", set_userinterface)
			if path.get_extension() == "gd":
				add_context_menu_item("设置为存档管理器", set_archive_manager)
	# 主菜单
	func set_userinterface(_path:PackedStringArray):
		var editor_plugin:EditorPlugin = EditorPlugin.new()
		editor_plugin.add_autoload_singleton("UserInterface", _path[0])
	
	func set_archive_manager(_path:PackedStringArray):
		var editor_plugin:EditorPlugin = EditorPlugin.new()
		var path = _path[0]
		editor_plugin.add_autoload_singleton("ArchiveManager", _path[0])
		
	
func _enable_plugin() -> void:
	add_autoload_singleton("ArchiveManager", "res://addons/hammer/archive.gd")
	add_autoload_singleton("UserInterface", "res://addons/hammer/ui.gd")

func _enter_tree() -> void:
	# 存档管理器
	#add_autoload_singleton("ArchiveManager", "res://addons/hammer/archive.gd")
	# 菜单插件
	for plugin:EditorContextMenuPlugin in menu_plugin_table:
		for slot:EditorContextMenuPlugin.ContextMenuSlot in menu_plugin_table[plugin]:
			add_context_menu_plugin(slot, plugin)

func _disable_plugin() -> void:
	# 移除自动加载
	remove_autoload_singleton("ArchiveManager")
	remove_autoload_singleton("UserInterface")
	# 移除菜单插件
	for plugin:EditorContextMenuPlugin in menu_plugin_table:
		remove_context_menu_plugin(plugin)
