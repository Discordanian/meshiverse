extends HBoxContainer
class_name MeshMenuBar

signal menu_button_pressed(menu_name: String)

@onready var settings_button: Button = $SettingsButton
@onready var edit_button: Button = $EditButton
@onready var add_button: Button = $AddButton
@onready var delete_button: Button = $DeleteButton

func _ready() -> void:
    settings_button.pressed.connect(_on_settings_pressed)
    edit_button.pressed.connect(_on_edit_pressed)
    add_button.pressed.connect(_on_add_pressed)
    delete_button.pressed.connect(_on_delete_pressed)
    
func _on_settings_pressed() -> void:
    emit_signal("menu_button_pressed", "SETTINGS")

func _on_edit_pressed() -> void:
    emit_signal("menu_button_pressed", "EDIT")
    
func _on_add_pressed() -> void:
    emit_signal("menu_button_pressed", "ADD")
    
func _on_delete_pressed() -> void:
    emit_signal("menu_button_pressed", "DELETE")
