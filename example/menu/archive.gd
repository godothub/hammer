extends Tree

@export_dir var icon_directory:String = "res://example/icon/"

@export_dir var archive_directory:String = "res://example/archive/"

func get_archive_files() -> PackedStringArray:
	var files:PackedStringArray = DirAccess.open(archive_directory).get_files()
	
	
	
	return files

func _visibility_changed() -> void:
	if visible:
		# 初始化
		clear()
		set_columns(1)
		set_hide_root(true)
		set_hide_folding(true)
		set_column_titles_visible(true)
		# 标题
		set_column_title(0, "Archive")
		# 绘制
		var root:TreeItem = create_item()
		var files:PackedStringArray = get_archive_files()
		var play_texture:Texture2D = load(icon_directory.path_join("play.svg"))
		var remove_texture:Texture2D = load(icon_directory.path_join("remove.svg"))
		for file in files:
			var item:TreeItem = create_item(root)
			item.set_text(0, file)
			item.add_button(0, play_texture)
			item.add_button(0, remove_texture)


func _init() -> void:
	visibility_changed.connect(_visibility_changed)
