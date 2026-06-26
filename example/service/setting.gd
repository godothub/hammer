@tool
extends Settings

var DEFAULT_SETTING_TABLE:Dictionary[String, Dictionary] = {
	"video" : {
		"window_mode" : 0,
		"max_fps" : 300,
		"vsync_mode": true
	},
	"audio" : {
		"master" : 100
	}
}

## 初始化自身管理的设置
func _settings_init() -> void:
	for section in DEFAULT_SETTING_TABLE:
		for setting in DEFAULT_SETTING_TABLE[section]:
			init_setting(section, setting, DEFAULT_SETTING_TABLE[section][setting])
	_settings_updated()

func _settings_updated() -> void:
	# 窗口模式
	match get_setting("video", "window_mode"):
		0:
			get_window().mode = Window.MODE_WINDOWED
		1:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	# 最大帧率
	Engine.max_fps = int(get_setting("video", "max_fps"))
	# 垂直同步
	if get_setting("video", "vsync_mode"):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	# 主音量
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), get_setting("audio", "master") / 100)

func _enter_tree() -> void:
	if Engine.is_editor_hint():return
	_settings_init()
	settings_updated.connect(_settings_updated)

func _exit_tree() -> void:
	save()
