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
			var file_format: String = "{year}-{month}-{day}-{hour}-{minute}-{second}"
			var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
			datetime_dict["month"] = "%02d" % datetime_dict["month"]
			datetime_dict["day"] = "%02d" % datetime_dict["day"]
			datetime_dict["hour"] = "%02d" % datetime_dict["hour"]
			datetime_dict["minute"] = "%02d" % datetime_dict["minute"]
			datetime_dict["second"] = "%02d" % datetime_dict["second"]
	
			ArchiveManager.save(file_format.format(datetime_dict))
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
