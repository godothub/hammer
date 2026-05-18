extends ItemList

func _visibility_changed() -> void:
	if visible:
		if UserInterface.is_background():
			set_item_text(0, "NewGame")
			set_item_disabled(1, true)
		else:
			set_item_text(0, "Continue")
			set_item_disabled(1, false)

func _item_selected(_index:int) -> void:
	var archive:Control = UserInterface.get_node("Archive")
	match get_item_text(_index):
		"NewGame":
			pass
		"SaveGame":
			ArchiveManager.save()
			archive.flash()
		"Continue":
			UserInterface.set_status(true)
		"Archive":
			archive.visible = not archive.visible
		"Option":
			pass
		"Exit":
			get_tree().quit()
	
	deselect(_index)

func _init() -> void:
	visibility_changed.connect(_visibility_changed)
	item_selected.connect(_item_selected)
