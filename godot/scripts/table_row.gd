extends HBoxContainer

signal row_selected(row_index: int)

var row_index: int = -1
var is_selected: bool = false
var background_rect: ColorRect = null

func _ready() -> void:
	# Create a ColorRect background for selection highlighting
	background_rect = ColorRect.new()
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let clicks pass through
	background_rect.color = Color(0, 0, 0, 0)  # Transparent by default
	background_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_rect.z_index = -1  # Behind other children
	add_child(background_rect)
	move_child(background_rect, 0)  # Move to back
	
	# Apply initial style
	_update_selection_style()
	
	# Make row clickable
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			select()

func select() -> void:
	if not is_selected:
		is_selected = true
		_update_selection_style()
		if row_index >= 0:
			row_selected.emit(row_index)

func deselect() -> void:
	if is_selected:
		is_selected = false
		_update_selection_style()

func set_row_index(index: int) -> void:
	row_index = index

func _update_selection_style() -> void:
	if background_rect:
		if is_selected:
			background_rect.color = Color(0.2, 0.4, 0.8, 0.3)  # Light blue background when selected
		else:
			background_rect.color = Color(0, 0, 0, 0)  # Transparent when not selected

