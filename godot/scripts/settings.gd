extends Control

var verse_dir: String = "Select Directory"

# Read Global Config
func _ready() -> void:
	$MarginContainer/VBoxContainer/DisplayDirectory.text = verse_dir
	$MarginContainer/OpenSelector.add_filter("meshiverse.ini","Meshiverse settings file")


func _on_select_directory_button_down() -> void:
	$MarginContainer/NewSelector.popup()


func _on_directory_selector_dir_selected(dir: String) -> void:
	set_vault_directory(dir)


func _on_open_button_down() -> void:
	$MarginContainer/OpenSelector.popup()


func _on_open_selector_file_selected(path: String) -> void:
	set_vault_directory(path.get_base_dir())
	
func set_vault_directory(dir: String) -> void:
	verse_dir = dir
	$MarginContainer/VBoxContainer/DisplayDirectory.text = dir
