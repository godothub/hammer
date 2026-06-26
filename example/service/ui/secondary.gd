extends Tree

enum PageEnum {HIDE, ARCHIVES, SETTINGS}
@export var page:PageEnum = PageEnum.HIDE:
	set(_page):
		page = _page
		_flash()

@export_dir var icon_directory:String = "res://example/icon/"

## 刷新存档页面。
func _flash_archives() -> void:
	# 初始化
	clear()
	set_columns(1)
	set_hide_root(true)
	set_hide_folding(true)
	# 绘制
	var root:TreeItem = create_item()
	var files:PackedStringArray = ArchiveManager.get_archive_files()
	var play_texture:Texture2D = load(icon_directory.path_join("play.svg"))
	var remove_texture:Texture2D = load(icon_directory.path_join("remove.svg"))
	for file in files:
		var item:TreeItem = create_item(root)
		item.set_text(0, file)
		item.add_button(0, play_texture)
		item.add_button(0, remove_texture)

## 设置项目可视化表。
@export var SETTING_VIEW_TABLE:Dictionary = {
	"video" : {
		"window_mode":{
			"mode": TreeItem.CELL_MODE_RANGE,
			"text": "Windowed, FullScreen",
		},
		"max_fps":{
			"mode": TreeItem.CELL_MODE_RANGE,
			"range": {"min": 30, "max": 300, "step": 1},
		},
		"vsync_mode":{
			"mode": TreeItem.CELL_MODE_CHECK
		}
	},
	"audio" : {
		"master":{
			"mode": TreeItem.CELL_MODE_RANGE,
			"range": {"min": 0, "max": 100, "step": 1},
		}
	}
	
}
## 刷新设置页面。
func _flash_settings() -> void:
	# 初始化TreeNode
	clear()
	set_columns(2)
	set_hide_root(true)
	set_hide_folding(false)
	# 绘制
	var root:TreeItem = create_item()
	for section:String in SETTING_VIEW_TABLE:
		# 节
		var section_root:TreeItem = create_item(root)
		section_root.set_text(0, section)
		for setting:String in SETTING_VIEW_TABLE[section]:
			# 设置项
			var item:TreeItem = create_item(section_root)
			var property:Dictionary = SETTING_VIEW_TABLE[section][setting]
			# 数值获取
			var value:Variant = GameSettings.get_setting(section, setting)
			# 基本参数传递
			item.set_text(0, setting)
			item.set_cell_mode(1, property["mode"])
			item.set_editable(1, true)
			# 参数配置
			match property["mode"]:
				TreeItem.CELL_MODE_STRING:
					item.set_text(1, value)
				TreeItem.CELL_MODE_CHECK:
					item.set_checked(1, value)
				TreeItem.CELL_MODE_RANGE:
					if property.has("text"):
						item.set_text(1, property["text"])
					if property.has("range"):
						var property_range:Dictionary = property["range"]
						item.set_range_config(1, property_range["min"], property_range["max"], property_range["step"])
					item.set_range(1, value)
## 刷新页面。
func _flash() -> void:
	show()
	match page:
		PageEnum.HIDE:
			hide()
		PageEnum.ARCHIVES:
			_flash_archives()
		PageEnum.SETTINGS:
			_flash_settings()

## 存档页面按钮点击。
func _button_clicked_archives(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	var file = _item.get_text(0)
	match _id:
		0:
			ArchiveManager.apply(file)
		1:
			ArchiveManager.delete(file)
	_flash()
## 按钮点击。
func _button_clicked(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	match page:
		PageEnum.ARCHIVES:
			_button_clicked_archives(_item, _column, _id, _mouse_button_index)


## 设置页面被编辑。
func _item_edited_settings() -> void:
	var item:TreeItem = get_edited()
	var section:String = item.get_parent().get_text(0)
	var setting:String = item.get_text(0)
	# 获取数值
	var value:Variant
	match SETTING_VIEW_TABLE[section][setting]["mode"]:
		TreeItem.CELL_MODE_STRING:
			value = item.get_text(1)
		TreeItem.CELL_MODE_CHECK:
			value = item.is_checked(1)
		TreeItem.CELL_MODE_RANGE:
			value = item.get_range(1)
			if SETTING_VIEW_TABLE[section][setting].has("text"):
				value = int(value)
	GameSettings.set_setting(section, setting, value)
## 被编辑。
func _item_edited() -> void:
	match page:
		PageEnum.SETTINGS:
			_item_edited_settings()

func _init() -> void:
	if Engine.is_editor_hint():return
	button_clicked.connect(_button_clicked)
	item_edited.connect(_item_edited)
	hidden.connect(func():page = PageEnum.HIDE)
