extends Control
class_name MeshSettings

var verse_dir: String = "Select Directory"
@onready var open_dialog: FileDialog = $MarginContainer/OpenSelector
@onready var new_dialog: FileDialog = $MarginContainer/NewSelector
@onready var library_location_label: LineEdit = $MarginContainer/VBoxContainer/DisplayDirectory
@onready var return_button: Button = $MarginContainer/VBoxContainer/MarginContainer2/Main

signal return_to_main()
signal open_directory()
signal new_directory()


# Read Global Config
func _ready() -> void:
    library_location_label.text = verse_dir
    $MarginContainer/OpenSelector.add_filter("meshiverse.cfg","Meshiverse settings file")
    return_button.pressed.connect(_on_return_pressed)

func _on_return_pressed() -> void:
    emit_signal("return_to_main")


func _on_select_directory_button_down() -> void:
    new_dialog.popup()


func _on_directory_selector_dir_selected(dir: String) -> void:
    set_vault_directory(dir)


func _on_open_button_down() -> void:
    open_dialog.popup()


func _on_open_selector_file_selected(path: String) -> void:
    set_vault_directory(path.get_base_dir())
    
func set_vault_directory(dir: String) -> void:
    verse_dir = dir
    library_location_label.text = dir
