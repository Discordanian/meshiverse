extends Control


# Read Global Config
func _ready() -> void:
	pass # Replace with function body.


func _on_select_directory_button_down() -> void:
	$MarginContainer/DirectorySelector.popup()
