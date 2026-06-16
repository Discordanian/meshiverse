extends HBoxContainer

signal row_selected(row_index: int)

var row_index: int = -1
var is_selected: bool = false
var checkbox: CheckBox = null

const SELECTED_COLOR: Color = Color(0.2, 0.4, 0.8, 0.3)


func _ready() -> void:
	checkbox = $CheckBox
	if checkbox:
		checkbox.toggled.connect(_on_checkbox_toggled)

	mouse_filter = Control.MOUSE_FILTER_STOP


func _draw() -> void:
	if is_selected:
		draw_rect(Rect2(Vector2.ZERO, size), SELECTED_COLOR)


func _on_checkbox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		select()
	else:
		deselect()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if is_selected:
				deselect()
			else:
				select()


func select() -> void:
	if not is_selected:
		is_selected = true
		queue_redraw()
		if checkbox:
			checkbox.set_block_signals(true)
			checkbox.button_pressed = true
			checkbox.set_block_signals(false)
		if row_index >= 0:
			row_selected.emit(row_index)


func deselect() -> void:
	if is_selected:
		is_selected = false
		queue_redraw()
		if checkbox:
			checkbox.set_block_signals(true)
			checkbox.button_pressed = false
			checkbox.set_block_signals(false)


func set_row_index(index: int) -> void:
	row_index = index
