@tool
extends EditorPlugin

const DEFAULT_AUTOLOAD_TABLE:Dictionary[String, String] = {
	"UserInterface" : "res://addons/hammer/service/ui.gd",
	"GameSettings" : "res://addons/hammer/service/setting.gd",
	"ArchiveManager" : "res://addons/hammer/service/archive.gd"
}

func _enable_plugin() -> void:
	for autoload:String in DEFAULT_AUTOLOAD_TABLE:
		add_autoload_singleton(autoload, DEFAULT_AUTOLOAD_TABLE[autoload])

func _disable_plugin() -> void:
	for autoload:String in DEFAULT_AUTOLOAD_TABLE:
		remove_autoload_singleton(autoload)
