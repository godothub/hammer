extends ItemList


func _visibility_changed() -> void:
	if visible:
		if Menu.is_background():
			pass

func _item_selected(_index:int) -> void:
	match get_item_text(_index):
		"Continue":
			if not Menu.is_background():Menu.run()
		"Archive":
			var archive:Control = Menu.get_node("Archive")
			archive.visible = not archive.visible
		"Option":
			pass
		"Exit":
			get_tree().quit()
	
	deselect(_index)
	

func _init() -> void:
	visibility_changed.connect(_visibility_changed)
	item_selected.connect(_item_selected)
