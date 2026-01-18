@tool
extends Menu

@export var TreeNode:Tree:
	set(_tree_node):
		_tree_node.item_activated.connect(Selected)
		_tree_node.item_edited.connect(Edit)
		TreeNode = _tree_node

enum MenuPageEnum {ArchiveMenu, OptionMenu}
var MenuPage:MenuPageEnum

@export var OptionItem:Dictionary = {
	"WindowMode" : {
		"Mode" : TreeItem.CELL_MODE_RANGE,
		"Text" : "FullScreen,Windowed",
	},
	"EnableShadow" : {
		"Mode" : TreeItem.CELL_MODE_CHECK,
	},
	"GameVolume" : {
		"Mode" : TreeItem.CELL_MODE_RANGE,
		"Range" : {
			"Min" : 0,
			"Max" : 100,
			"Step" : 1
		},
	}
}

func Command(_argument:String) -> void:
	match _argument:
		"Archive":
			MenuPage = MenuPageEnum.ArchiveMenu
			DrawOptionPage()
		"Option":
			MenuPage = MenuPageEnum.OptionMenu
			DrawOptionPage()

func Selected() -> void:
	pass

func Edit() -> void:
	var item:TreeItem = TreeNode.get_edited()
	match MenuPage:
		MenuPageEnum.OptionMenu:
			SaveOptionValue(item)
		MenuPageEnum.ArchiveMenu:
			pass

## 绘制存档页面
func DrawArchivePage() -> void:
	TreeNode.set_hide_root(true)
	#var root:TreeItem = TreeNode.create_item()


## 绘制选项页面
func DrawOptionPage() -> void:
	var resource:OptionResource = ResourceLoad("Option")
	# 初始化TreeNode
	TreeNode.clear()
	TreeNode.set_hide_root(true)
	TreeNode.set_columns(2)
	
	# 绘制
	var root:TreeItem = TreeNode.create_item()
	for _title in OptionItem:
		var item:TreeItem = TreeNode.create_item(root)
		var argument:Dictionary = OptionItem[_title]
		var value = resource.get(_title)
		
		# 基本参数传递
		item.set_text(0, _title)
		item.set_cell_mode(1, argument["Mode"])
		item.set_editable(1, true)
		
		if argument.has("Text"):
			item.set_text(1, argument["Text"])
		if argument.has("Range"):
			var value_range:Dictionary = argument["Range"]
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
					var value_range:Dictionary = argument["Range"]
					item.set_range_config(1, value_range["Min"], value_range["Max"], value_range["Step"])
					item.set_range(1, value)

## 存储参数
func SaveOptionValue(_item:TreeItem):
	var resource:OptionResource = OptionResource.new()
	var title:StringName = _item.get_text(0)
	match OptionItem[title]["Mode"]:
		TreeItem.CELL_MODE_STRING:
			resource.set(title, _item.get_text(1))
		TreeItem.CELL_MODE_CHECK:
			resource.set(title, _item.is_checked(1))
		TreeItem.CELL_MODE_RANGE:
			resource.set(title, _item.get_range(1))
	ResourceSave("Option", resource)
