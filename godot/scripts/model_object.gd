extends Resource

class_name ModelObject


@export var model_id: int
@export var model_name: String
@export var added_date_epoch: int
    

func iso_date_added() -> void:
    return Time.get_date_string_from_unix_time(added_date)
    
