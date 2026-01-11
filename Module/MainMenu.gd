extends Menu

@export var ItemNode:ItemList:
	set(_item_node):
		ItemNode = _item_node
		ItemNode.item_selected.connect(Selected)

var TextList:PackedStringArray
const MainTextList:PackedStringArray = [
	"Start",
	"Option",
	"Exit"
]
const GameTextList:PackedStringArray = [
	"Continue",
	"Option",
	"StartMenu"
]

func Flash() -> void:
	ItemNode.clear()
	for _text in TextList:
		ItemNode.add_item(_text)

func Selected(_index:int) -> void:
	match TextList[_index]:
		"Start":
			MenuRootNode.ShowMenuNode("SecondMenu", "Game")
		"Option":
			MenuRootNode.ShowMenuNode("SecondMenu", "Option")
		"Exit":
			get_tree().quit()
		"StartMenu":
			MenuRootNode.ShowMenuNode("FirstMenu", "Start")

func Command(_argument:String) -> void:
	if not TextList:
		TextList = MainTextList
	else:
		match _argument:
			"Start":
				TextList = MainTextList
			"Game":
				TextList = GameTextList
	Flash()

func _ready() -> void:
	AlwaysOn = true
