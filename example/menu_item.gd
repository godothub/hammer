@tool
extends Menu
class_name MenuItem

@export var a:Array[Item]

@export var item_list_node: ItemList:
	set(_item_list_node):
		if item_list_node:
			_item_list_node.item_selected.disconnect(selected)
		if _item_list_node:
			_item_list_node.item_selected.connect(selected)
		item_list_node = _item_list_node
		flash()

@export var item_table:PackedStringArray:
	set(_item_table):
		if item_list_node:
			flash()
		item_table = _item_table

func flash() -> void:
	item_list_node.clear()
	for _text:String in item_table:
		item_list_node.add_item(_text)

func selected(_index: int) -> void:
	var menu_root:MenuRoot = get_menu_root()
	match item_table[_index]:
		"Archive":
			menu_root.menu_show_by_title("Second", "Achieve")
		"Option":
			menu_root.menu_show_by_title("Second", "Option")
		"Exit":
			get_tree().quit()
	#flash()


func command(_argument: String) -> void:pass
