extends Control

var verse_dir: String = "Select Directory"

# Read Global Config
func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text = verse_dir


func _on_select_directory_button_down() -> void:
	$MarginContainer/DirectorySelector.popup()


func _on_directory_selector_dir_selected(dir: String) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text = dir
