@tool
extends Menu

@export var item_node: ItemList:
	set(_item_node):
		item_node = _item_node
		item_node.item_selected.connect(selected)

var text_list:PackedStringArray
@export var main_text_list:PackedStringArray = ["Start", "Option", "Exit"]
@export var game_text_list:PackedStringArray = ["Continue", "Option", "StartMenu"]


func flash() -> void:
	item_node.clear()
	for _text in text_list:
		item_node.add_item(_text)


func selected(_index: int) -> void:
	var menu_root:MenuRoot = get_menu_root()
	match text_list[_index]:
		"Start":
			menu_root.menu_show_by_title("Second", "Achieve")
		"Option":
			menu_root.menu_show_by_title("Second", "Option")
		"Exit":
			get_tree().quit()
		"StartMenu":
			menu_root.menu_show_by_title("First", "Start")


func command(_argument: String) -> void:
	if not text_list:
		text_list = main_text_list
	else:
		match _argument:
			"Start":
				text_list = main_text_list
			"Game":
				text_list = game_text_list
	flash()


func _ready() -> void:
	show()
	command("")
