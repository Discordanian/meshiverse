extends Control

@onready var TableRow: PackedScene = preload("res://scenes/table_row.tscn")
@onready var TableCell: PackedScene = preload("res://scenes/table_cell.tscn")
@onready var TableHeader: PackedScene = preload("res://scenes/table_header_cell.tscn")

@export var data: DataFrame
@export var max_column_width: float = 400.0  # Maximum width for a column in pixels (base, will be scaled)
@export var column_padding: float = 16.0  # Additional padding for column width (base, will be scaled)

# Store calculated column widths to enforce them
var _enforced_column_widths: Array[float] = []
var _all_table_cells: Array[Array] = []  # [column_index][row_index] = cell

# Row selection
signal row_selected(row_index: int, row_data: Array)
var selected_row_indices: Array[int] = []  # Array of selected row indices
var _row_nodes: Array[Node] = []  # Store references to row nodes for selection management
var _header_checkbox: CheckBox = null  # Reference to header checkbox

# Sorting
var _sorted_column: String = ""
var _sort_descending: bool = false
var _header_cells: Array[Control] = []  # Store references to header cells for sort indicators

# Called when the node enters the scene tree for the first time.
func Render() -> void:
	if not data:
		return

	# Clear existing rows
	_clear_table()

	var row_count: int = data.Size()
	var num_columns: int = data.columns.size()

	# Store all cells for width calculation
	# Create header row manually (not using TableRow which has a checkbox)
	var header_row: HBoxContainer = HBoxContainer.new()
	header_row.size_flags_horizontal = 0
	var data_rows: Array[Node] = []
	var all_cells: Array[Array] = []  # [column_index][row_index] = cell

	# Initialize column arrays
	for col_idx: int in range(num_columns):
		all_cells.append([])

	# Build header row
	$VBoxContainer.add_child(header_row)
	$VBoxContainer.move_child(header_row, 0)

	_header_cells.clear()
	# Add checkbox to header row first
	var header_checkbox: CheckBox = CheckBox.new()
	header_checkbox.custom_minimum_size = Vector2(20, 0)
	header_checkbox.size_flags_horizontal = 0
	header_checkbox.toggled.connect(_on_header_checkbox_toggled)
	header_row.add_child(header_checkbox)
	_header_checkbox = header_checkbox

	for col_idx: int in range(num_columns):
		var cell: Control = TableHeader.instantiate() as Control
		var column_name: String = data.columns[col_idx]
		cell.text = _get_header_text_with_sort_indicator(column_name)
		header_row.add_child(cell)
		_header_cells.append(cell)
		all_cells[col_idx].append(cell)

		# Connect button press signal for sorting
		if cell is Button:
			(cell as Button).pressed.connect(_on_header_clicked.bind(column_name))

	# Build data rows
	_row_nodes.clear()
	for r: int in range(row_count):
		var row: Node = TableRow.instantiate()
		# Ensure data rows don't expand to fill space
		if row is HBoxContainer:
			(row as HBoxContainer).size_flags_horizontal = 0
		$VBoxContainer/ScrollContainer/Rows.add_child(row)
		data_rows.append(row)
		_row_nodes.append(row)

		# Set row index and connect to selection signal if it's a TableRow script
		if row.has_method("set_row_index"):
			row.set_row_index(r)
		if row.has_signal("row_selected"):
			# Connect directly - the row will emit its own index
			row.row_selected.connect(_on_row_selected)

		var row_data: Array = data.GetRow(r)
		for col_idx: int in range(num_columns):
			var cell: Control = TableCell.instantiate() as Control
			if col_idx < row_data.size():
				cell.text = str(row_data[col_idx])
			row.add_child(cell)
			all_cells[col_idx].append(cell)

	# Wait for layout to process
	await get_tree().process_frame

	# Calculate optimal column widths
	var column_widths: Array[float] = _calculate_column_widths(all_cells)

	# Store for potential future enforcement
	_enforced_column_widths = column_widths
	_all_table_cells = all_cells

	# Apply widths to all cells
	_apply_column_widths(all_cells, column_widths)

	# Update header sort indicators
	_update_header_sort_indicators()

	# Update header checkbox state
	_update_header_checkbox()

# Handle header click for sorting
func _on_header_clicked(column_name: String) -> void:
	# If clicking the same column, toggle sort direction
	if _sorted_column == column_name:
		_sort_descending = !_sort_descending
	else:
		# New column, sort ascending by default
		_sorted_column = column_name
		_sort_descending = false

	# Sort the data
	if data:
		data.SortBy(_sorted_column, _sort_descending)

		# Re-render the table with sorted data
		Render()

# Get header text with sort indicator
func _get_header_text_with_sort_indicator(column_name: String) -> String:
	if _sorted_column == column_name:
		if _sort_descending:
			return column_name + " ▼"  # Down arrow for descending
		else:
			return column_name + " ▲"  # Up arrow for ascending
	return column_name

# Update sort indicators on all headers
func _update_header_sort_indicators() -> void:
	if not data:
		return

	for col_idx: int in range(_header_cells.size()):
		if col_idx < data.columns.size():
			var column_name: String = data.columns[col_idx]
			var header: Control = _header_cells[col_idx]
			if header:
				header.text = _get_header_text_with_sort_indicator(column_name)

# Calculate optimal width for each column based on content
func _calculate_column_widths(all_cells: Array[Array]) -> Array[float]:
	var column_widths: Array[float] = []
	var num_columns: int = all_cells.size()

	# With content_scale_factor, fonts and sizes are already scaled uniformly
	# No need to manually scale padding/max_width - they're in the same coordinate system

	for col_idx: int in range(num_columns):
		var max_width: float = 0.0
		var column_cells: Array = all_cells[col_idx]

		for cell: Variant in column_cells:
			if not cell is Control:
				continue

			var control: Control = cell as Control
			var text: String = ""

			# Get text from Label or Button
			if control is Label:
				text = (control as Label).text
			elif control is Button:
				text = (control as Button).text

			if text.is_empty():
				continue

			# Get font from theme
			var font: Font = _get_font_for_control(control)
			if font:
				# get_string_size() already accounts for the actual font size (which may be scaled)
				# so the measurement is already in the correct pixel coordinate system
				var text_size: Vector2 = font.get_string_size(text)
				max_width = max(max_width, text_size.x)
			else:
				# Fallback: estimate width (rough approximation)
				var cell_font_size: int = control.get_theme_font_size("font")
				if cell_font_size <= 0:
					cell_font_size = 12  # Base font size
				max_width = max(max_width, text.length() * cell_font_size * 0.6)  # Rough estimate

		# Add padding (already in correct coordinate system with content_scale_factor)
		max_width += column_padding

		# Clamp to maximum width
		max_width = min(max_width, max_column_width)

		# Ensure minimum width
		max_width = max(max_width, 50.0)

		column_widths.append(max_width)

	return column_widths

# Get the font used by a control from its theme
func _get_font_for_control(control: Control) -> Font:
	var font: Font = null

	if control is Label:
		var label: Label = control as Label
		font = label.get_theme_font("font")
		if font:
			return font
	elif control is Button:
		var button: Button = control as Button
		font = button.get_theme_font("font")
		if font:
			return font

	# Fallback to theme default font
	font = get_theme_default_font()
	return font

# Apply calculated widths to all cells in each column
func _apply_column_widths(all_cells: Array[Array], column_widths: Array[float]) -> void:
	var num_columns: int = all_cells.size()

	for col_idx: int in range(num_columns):
		var width: float = column_widths[col_idx]
		var column_cells: Array = all_cells[col_idx]

		for cell: Variant in column_cells:
			if not cell is Control:
				continue

			var control: Control = cell as Control
			# Clear anchors that cause expansion - cells should use fixed width, not fill parent
			# In HBoxContainer, anchors don't affect horizontal sizing, but we clear them to be safe
			control.set_anchors_preset(Control.PRESET_TOP_LEFT, false)
			control.anchor_right = 0.0
			control.anchor_bottom = 0.0
			control.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			control.grow_vertical = Control.GROW_DIRECTION_BEGIN

			# Set minimum width - this ensures all cells in the same column have the same minimum
			control.custom_minimum_size.x = width
			# Prevent expansion - SIZE_SHRINK_CENTER uses minimum size and centers, but we want left-aligned
			# Actually, let's use 0 (no flags) which means use natural/minimum size
			control.size_flags_horizontal = 0
			control.size_flags_vertical = Control.SIZE_SHRINK_CENTER

			# Enable text clipping for overflow
			if control is Label:
				(control as Label).clip_contents = true
			elif control is Button:
				(control as Button).clip_contents = true

	# Get separation value from the first row (should be same for all rows)
	var row_separation: float = 3.0  # Default from table_row.tscn
	if $VBoxContainer.get_child_count() > 0:
		var first_row: Node = $VBoxContainer.get_child(0)
		if first_row is HBoxContainer:
			var hbox: HBoxContainer = first_row as HBoxContainer
			# Try theme_override first (what's in the scene), then fallback to theme constant
			if hbox.has_theme_constant_override("separation"):
				row_separation = hbox.get_theme_constant("separation")
			else:
				row_separation = hbox.get_theme_constant("separation", "HBoxContainer")
			if row_separation <= 0:
				row_separation = 3.0

	# Calculate total table width including separations
	# Start with checkbox width (first column)
	var checkbox_width: float = 20.0  # Match the checkbox custom_minimum_size
	var total_width: float = checkbox_width + row_separation
	for col_idx: int in range(num_columns):
		total_width += column_widths[col_idx]
		if col_idx < num_columns - 1:  # Add separation between columns, but not after last
			total_width += row_separation

	# Ensure header row and data rows have consistent layout
	# Get the header row (first child of VBoxContainer)
	if $VBoxContainer.get_child_count() > 0:
		var header_row: Node = $VBoxContainer.get_child(0)
		if header_row is HBoxContainer:
			var hbox: HBoxContainer = header_row as HBoxContainer
			# Prevent the row from expanding - use shrink to use minimum size
			hbox.size_flags_horizontal = 0
			# Set minimum width to ensure consistent width with data rows
			hbox.custom_minimum_size.x = total_width

	# Ensure all data rows have the same layout behavior
	var rows_container: Node = $VBoxContainer/ScrollContainer/Rows
	if rows_container is Control:
		# Set minimum width on the rows container to match header width
		(rows_container as Control).custom_minimum_size.x = total_width
		(rows_container as Control).size_flags_horizontal = 0

	for row: Node in rows_container.get_children():
		if row is HBoxContainer:
			var hbox: HBoxContainer = row as HBoxContainer
			# Prevent rows from expanding - match header row behavior
			hbox.size_flags_horizontal = 0
			# Set same minimum width to ensure alignment with header
			hbox.custom_minimum_size.x = total_width

	# Force layout update to apply all changes
	await get_tree().process_frame

	# Now explicitly set exact sizes on all cells to ensure perfect column alignment
	# This overrides any space distribution by HBoxContainer
	for col_idx: int in range(num_columns):
		var width: float = column_widths[col_idx]
		var column_cells: Array = all_cells[col_idx]

		for cell: Variant in column_cells:
			if not cell is Control:
				continue

			var control: Control = cell as Control
			# Clear anchors again to ensure they don't interfere
			control.set_anchors_preset(Control.PRESET_TOP_LEFT, false)
			control.anchor_right = 0.0
			control.anchor_bottom = 0.0
			control.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			# Force exact width - this ensures all cells in the column are identical
			control.custom_minimum_size.x = width
			# Use set_size instead of direct assignment for better compatibility
			control.set_size(Vector2(width, control.size.y))
			control.size_flags_horizontal = 0

	# Final layout pass to ensure all sizes are applied
	await get_tree().process_frame

	# Use call_deferred to ensure sizes are set after all layout processing is complete
	call_deferred("_enforce_exact_column_widths", all_cells, column_widths)

# Enforce exact column widths - call this to ensure all cells match
func _enforce_exact_column_widths(all_cells: Array[Array], column_widths: Array[float]) -> void:
	var num_columns: int = column_widths.size()

	for col_idx: int in range(num_columns):
		var width: float = column_widths[col_idx]
		var column_cells: Array = all_cells[col_idx]

		for cell: Variant in column_cells:
			if not cell is Control:
				continue

			var control: Control = cell as Control
			# Clear anchors to prevent expansion
			control.set_anchors_preset(Control.PRESET_TOP_LEFT, false)
			control.anchor_right = 0.0
			control.anchor_bottom = 0.0
			control.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			# Force the exact size - ensure it matches the column width
			control.custom_minimum_size.x = width
			control.set_size(Vector2(width, control.size.y))
			control.size_flags_horizontal = 0

			# Force the size again if it doesn't match (layout might have changed it)
			if abs(control.size.x - width) > 0.1:  # Allow small floating point differences
				control.set_size(Vector2(width, control.size.y))


# Handle row selection - supports multi-select
func _on_row_selected(row_index: int) -> void:
	# Toggle selection: if already selected, deselect; otherwise, select
	if row_index in selected_row_indices:
		# Deselect this row
		selected_row_indices.erase(row_index)
		if row_index < _row_nodes.size():
			var row: Node = _row_nodes[row_index]
			if row.has_method("deselect"):
				row.deselect()
	else:
		# Select this row (add to selection, don't remove others)
		selected_row_indices.append(row_index)
		if row_index < _row_nodes.size():
			var row: Node = _row_nodes[row_index]
			if row.has_method("select"):
				row.select()

	# Update header checkbox state
	_update_header_checkbox()

	# Emit signal with row data for the most recently selected row
	if data and row_index < data.Size():
		var row_data: Array = data.GetRow(row_index)
		row_selected.emit(row_index, row_data)

# Get the currently selected row indices
func get_selected_row_indices() -> Array[int]:
	return selected_row_indices.duplicate()

# Programmatically select a row by index
func select_row(index: int) -> void:
	if index >= 0 and index < _row_nodes.size():
		if index not in selected_row_indices:
			selected_row_indices.append(index)
		var row: Node = _row_nodes[index]
		if row.has_method("select"):
			row.select()
		_update_header_checkbox()

# Programmatically deselect a row by index
func deselect_row(index: int) -> void:
	if index >= 0 and index < _row_nodes.size():
		selected_row_indices.erase(index)
		var row: Node = _row_nodes[index]
		if row.has_method("deselect"):
			row.deselect()
		_update_header_checkbox()

# Handle header checkbox toggle
func _on_header_checkbox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		# Select all rows
		select_all_rows()
	else:
		# Deselect all rows
		deselect_all_rows()

# Select all rows
func select_all_rows() -> void:
	selected_row_indices.clear()
	for i: int in range(_row_nodes.size()):
		selected_row_indices.append(i)
		var row: Node = _row_nodes[i]
		if row.has_method("select"):
			row.select()
	_update_header_checkbox()

# Deselect all rows
func deselect_all_rows() -> void:
	for index: int in selected_row_indices:
		if index < _row_nodes.size():
			var row: Node = _row_nodes[index]
			if row.has_method("deselect"):
				row.deselect()
	selected_row_indices.clear()
	_update_header_checkbox()

# Update header checkbox state based on current selection
func _update_header_checkbox() -> void:
	if _header_checkbox:
		# Check if any rows are selected
		var has_selection: bool = selected_row_indices.size() > 0
		# Block signals to avoid triggering the handler
		_header_checkbox.set_block_signals(true)
		_header_checkbox.button_pressed = has_selection
		_header_checkbox.set_block_signals(false)

# Clear existing table rows
func _clear_table() -> void:
	# Clear header row if it exists
	if $VBoxContainer.get_child_count() > 0:
		var first_child: Node = $VBoxContainer.get_child(0)
		if first_child.get_child_count() > 0:
			# Check if it's a header row (has TableHeaderCell children)
			var is_header: bool = false
			for child: Node in first_child.get_children():
				if child.get_class() == "Button" or "Header" in child.name:
					is_header = true
					break
			if is_header:
				first_child.queue_free()

	# Clear data rows
	var rows_container: Node = $VBoxContainer/ScrollContainer/Rows
	for child: Node in rows_container.get_children():
		child.queue_free()

	# Reset selection state
	selected_row_indices.clear()
	_row_nodes.clear()
	_header_checkbox = null

# mock and _mock_data are for testing
func mock(rows: int) -> void:
	var columns : PackedStringArray = ["Id","Name","Year"]
	var mock_data: Array[Array] = _mock_data(rows)
	var df : DataFrame = DataFrame.New(mock_data, columns)
	data = df

func _mock_data(n: int) -> Array[Array]:
	var mock_data: Array[Array] = []
	for i: int in range(n):
		var model_name: String = "Model %d / %d" % [i,n]
		if i % 17 == 0:
			model_name += " " + model_name + " " + model_name
		mock_data.append([i, model_name, 1950+i])
	return mock_data
