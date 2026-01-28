@tool
extends Menu
class_name MenuOption

@export var a:Array[Option]

## 树节点
@export var tree_node:Tree:
	set(_tree_node):
		_tree_node.item_edited.connect(Edit)
		tree_node = _tree_node

var config:ConfigFile

enum MenuPageEnum { ArchiveMenu, OptionMenu }
var menu_page:MenuPageEnum  ## 菜单页面

## 选项
@export var option_item:Dictionary = {
	"WindowMode":
	{
		"Mode": TreeItem.CELL_MODE_RANGE,
		"Text": "FullScreen,Windowed",
	},
	"EnableShadow":
	{
		"Mode": TreeItem.CELL_MODE_CHECK,
	},
	"GameVolume":
	{
		"Mode": TreeItem.CELL_MODE_RANGE,
		"Range": {"Min": 0, "Max": 100, "Step": 1},
	}
}


func command(_argument: String) -> void:
	match _argument:
		"Archive":
			menu_page = MenuPageEnum.ArchiveMenu
			DrawOptionPage()
		"Option":
			menu_page = MenuPageEnum.OptionMenu
			DrawOptionPage()


func Edit() -> void:
	var item:TreeItem = tree_node.get_edited()
	match menu_page:
		MenuPageEnum.OptionMenu:
			SaveOptionValue(item)
		MenuPageEnum.ArchiveMenu:
			pass


## 绘制存档页面
func DrawArchivePage() -> void:
	tree_node.set_hide_root(true)
	#var root:TreeItem = TreeNode.create_item()


## 绘制选项页面
func DrawOptionPage() -> void:
	config = get_menu_root().config_load("Option")
	# 初始化TreeNode
	tree_node.clear()
	tree_node.set_hide_root(true)
	tree_node.set_columns(2)

	# 绘制
	var root: TreeItem = tree_node.create_item()
	for _title in option_item:
		var item: TreeItem = tree_node.create_item(root)
		var argument: Dictionary = option_item[_title]
		var value = config.get_value("Option", _title)

		# 基本参数传递
		item.set_text(0, _title)
		item.set_cell_mode(1, argument["Mode"])
		item.set_editable(1, true)

		if argument.has("Text"):
			item.set_text(1, argument["Text"])
		if argument.has("Range"):
			var value_range: Dictionary = argument["Range"]
			item.set_range_config(1, value_range["Min"], value_range["Max"], value_range["Step"])
			item.set_range(1, value)

		# 参数配置
		match argument["Mode"]:
			TreeItem.CELL_MODE_STRING:
				item.set_text(1, value)
			TreeItem.CELL_MODE_CHECK:
				item.set_checked(1, value)
			TreeItem.CELL_MODE_RANGE:
				item.set_range(1, value)
				if argument.has("Text"):
					item.set_text(1, argument["Text"])
				if argument.has("Range"):
					var value_range: Dictionary = argument["Range"]
					item.set_range_config(
						1, value_range["Min"], value_range["Max"], value_range["Step"]
					)
					item.set_range(1, value)


## 存储参数
func SaveOptionValue(_item: TreeItem):
	var title: StringName = _item.get_text(0)
	var section: StringName = "Option"
	match option_item[title]["Mode"]:
		TreeItem.CELL_MODE_STRING:
			config.set_value(section, title, _item.get_text(1))
		TreeItem.CELL_MODE_CHECK:
			config.set_value(section, title, _item.is_checked(1))
		TreeItem.CELL_MODE_RANGE:
			config.set_value(section, title, _item.get_range(1))
	get_menu_root().config_save("Option", config)
