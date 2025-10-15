extends Control

enum VisibleScreen { SETTINGS, LIBRARY, DETAILS }

@onready var table: Node = $MainMargin/MainVbox/HBoxContainer/Table
@onready var menu_bar: MeshMenuBar = $MainMargin/MainVbox/MenuBar

@onready var primary_node: Node = $MainMargin/MainVbox
@onready var settings_node: MeshSettings = $MainMargin/Settings

var visible_screen: VisibleScreen = VisibleScreen.LIBRARY

func setup_theme() -> void:
	var tm: MeshiverseThemeManager = MeshiverseThemeManager.new()
	var local_theme: Theme = $".".theme
	$".".theme = tm.update_theme(local_theme)
 
func _handle_menu_bar_signals(button_name: String) -> void:
	print("handle_menu_bar_signals(%s)" % button_name)
	match button_name:
		"SETTINGS":
			visible_screen = VisibleScreen.SETTINGS
		"LIBRARY":
			visible_screen = VisibleScreen.LIBRARY
		_ :
			pass
	_visibility()       

func _show_main() -> void:
	_handle_menu_bar_signals("LIBRARY")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("main _ready()")
	ConfigFileHandler.print_config(ConfigFileHandler.global_config)
	
	if menu_bar:
		menu_bar.menu_button_pressed.connect(_handle_menu_bar_signals)
	
	if settings_node:
		settings_node.return_to_main.connect(_show_main)
	
	# Mock table
	table.mock(123)
	table.Render()

	setup_theme()
	_visibility()

func _visibility() -> void:
	match visible_screen:
		VisibleScreen.SETTINGS:
			primary_node.visible = false
			settings_node.visible = true
		VisibleScreen.LIBRARY:
			primary_node.visible = true
			settings_node.visible = false           
		VisibleScreen.DETAILS:
			print("Not currently able to handle DETAILS screen")
		_:
			push_error("Unspecified VisibleScreen state in visibility() function %s" % VisibleScreen.keys()[visible_screen]) 
