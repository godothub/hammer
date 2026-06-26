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
	match get_item_text(_index):
		"NewGame":
			pass
		"Continue":
			UserInterface.set_status(true)
		"SaveGame":
			ArchiveManager.save()
			%Secondary.page = %Secondary.PageEnum.ARCHIVES
		"Archives":
			%Secondary.page = %Secondary.PageEnum.ARCHIVES
		"Settings":
			%Secondary.page = %Secondary.PageEnum.SETTINGS
		"Exit":
			get_tree().quit()
	
	deselect(_index)

func _init() -> void:
	if Engine.is_editor_hint():return
	visibility_changed.connect(_visibility_changed)
	item_selected.connect(_item_selected)
