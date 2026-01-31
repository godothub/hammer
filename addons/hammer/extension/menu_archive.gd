@tool
extends Menu
class_name MenuArchive
## 存档菜单

@export var tree_node:Tree:
	set(_tree_node):
		if tree_node:
			tree_node.button_clicked.disconnect(button_clicked)
		if _tree_node:
			_tree_node.button_clicked.connect(button_clicked)
		tree_node = _tree_node


## 测试
func command(_argument: String) -> void:
	flash()

func flash() -> void:
	# 初始化TreeNode
	tree_node.clear()
	tree_node.set_columns(1)
	tree_node.set_hide_root(true)
	tree_node.set_hide_folding(true)
	tree_node.set_column_titles_visible(true)
	
	tree_node.set_column_title(0, "Archive")
	
	# 绘制
	var root: TreeItem = tree_node.create_item()

	## 文件文件
	var files:PackedStringArray = get_menu_root().get_manage_root().game_root.archive_list()
	
	var play_texture:Texture2D = load("res://addons/hammer/icon/play.svg")
	var remove_texture:Texture2D = load("res://addons/hammer/icon/remove.svg")
	
	for _file in files:
		var item:TreeItem = tree_node.create_item(root)
		item.set_text(0, _file)
		item.add_button(0, play_texture)
		item.add_button(0, remove_texture)

func button_clicked(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	var file:StringName = _item.get_text(0)
	var game_root:GameRoot = get_menu_root().get_manage_root().game_root
	if _id == 0:
		# 运行
		game_root.archive_load(file)
		get_menu_root().get_manage_root().game_status_running()
	elif _id == 1:
		# 删除
		game_root.archive_remove(file)
		flash()

func _ready() -> void:
	flash()
