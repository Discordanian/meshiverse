extends Control
class_name ModelRecord

@onready var model_name_label: Label = $PanelContainer/HBoxContainer/ModelName
@onready var added_date_label: Label = $PanelContainer/HBoxContainer/AddedDateLabel
@onready var edit_button: Button = $PanelContainer/HBoxContainer/EditButton

var model_id: int = 0
var model_name: String = "Model Name"
var added_date: int = 12345678

func get_datetime_from_epoch(epoch_timestamp: int) -> Dictionary:
    return Time.get_datetime_dict_from_unix_time(epoch_timestamp)
    

func _ready() -> void:
    pass
    # model_name_label.text = "model_name"
    # var date_string: String = Time.get_date_string_from_unix_time(added_date)
    # added_date_label.text = date_string
    
