extends Tree

@export_dir var icon_directory:String = "res://example/icon/"

func flash() -> void:
	if visible:
		# 初始化
		clear()
		set_columns(1)
		set_hide_root(true)
		set_hide_folding(true)
		set_column_titles_visible(true)
		set_column_title(0, "Archive")
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

func _button_clicked(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	var file = _item.get_text(0)
	match _id:
		0:
			ArchiveManager.read(file)
			ArchiveManager.apply()
		1:
			ArchiveManager.delete(file)
	flash()
		

func _init() -> void:
	visibility_changed.connect(flash)
	button_clicked.connect(_button_clicked)
