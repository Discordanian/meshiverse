extends HBoxContainer
class_name MeshMenuBar

signal menu_button_pressed(menu_name: String)

@onready var settings_button: Button = $SettingsButton

func _ready() -> void:
	settings_button.pressed.connect(_on_settings_pressed)
	
func _on_settings_pressed() -> void:
	emit_signal("menu_button_pressed", "settings")
