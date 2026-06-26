@tool
extends Archive

## 存档日期格式
var file_format: String = "{year}-{month}-{day}-{hour}-{minute}-{second}"

func _saving() -> void:
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	
	datetime_dict["month"] = "%02d" % datetime_dict["month"]
	datetime_dict["day"] = "%02d" % datetime_dict["day"]
	datetime_dict["hour"] = "%02d" % datetime_dict["hour"]
	datetime_dict["minute"] = "%02d" % datetime_dict["minute"]
	datetime_dict["second"] = "%02d" % datetime_dict["second"]
	
	file = file_format.format(datetime_dict)

func _init() -> void:
	saving_signal.connect(_saving)
