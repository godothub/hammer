@tool
extends Menu
class_name MenuItem

@export var item_list:Array[Item]

@export var item_list_node: ItemList:
	set(_item_list_node):
		if item_list_node:
			_item_list_node.item_selected.disconnect(selected)
		if _item_list_node:
			_item_list_node.item_selected.connect(selected)
		item_list_node = _item_list_node
		flash()

func flash() -> void:
	item_list_node.clear()
	
	for _item:Item in item_list:
		item_list_node.add_item(_item.text, _item.icon)

func selected(_index: int) -> void:
	var item:Item = item_list[_index]
	
	var callable:Callable = Callable(self, item.callable)
	
	var expression:Expression = Expression.new()
	expression.parse(item.callable)
	expression.execute([], self)
	
	flash()


func command(_argument: String) -> void:
	flash()
