extends RefCounted

const HEADER_ROW_PATH: String = "VBoxContainer/HeaderHBox/HeaderScroll/HeaderRow"
const ROWS_PATH: String = "VBoxContainer/BodyScroll/Rows"
const SCROLL_BAR_SPACER_PATH: String = "VBoxContainer/HeaderHBox/ScrollBarSpacer"
const BODY_SCROLL_PATH: String = "VBoxContainer/BodyScroll"


static func get_header_column_cells(table: Node) -> Array[Control]:
	var header_row: Node = table.get_node(HEADER_ROW_PATH)
	var cells: Array[Control] = []
	for child: Node in header_row.get_children():
		if child is Button and not child is CheckBox:
			cells.append(child as Control)
	return cells


static func get_data_column_cells(table: Node, row_index: int) -> Array[Control]:
	var rows: Node = table.get_node(ROWS_PATH)
	var row: Node = rows.get_child(row_index)
	var cells: Array[Control] = []
	for child: Node in row.get_children():
		if child is Label:
			cells.append(child as Control)
	return cells


static func column_position_deltas(table: Node, row_index: int = 0) -> Array[Vector2]:
	var header_cells: Array[Control] = get_header_column_cells(table)
	var data_cells: Array[Control] = get_data_column_cells(table, row_index)
	var deltas: Array[Vector2] = []
	var column_count: int = mini(header_cells.size(), data_cells.size())

	for col_idx: int in range(column_count):
		var delta_x: float = header_cells[col_idx].get_screen_position().x - data_cells[col_idx].get_screen_position().x
		deltas.append(Vector2(delta_x, 0.0))

	return deltas


static func column_minimum_width_deltas(table: Node, row_index: int = 0) -> Array[float]:
	var header_cells: Array[Control] = get_header_column_cells(table)
	var data_cells: Array[Control] = get_data_column_cells(table, row_index)
	var deltas: Array[float] = []
	var column_count: int = mini(header_cells.size(), data_cells.size())

	for col_idx: int in range(column_count):
		deltas.append(header_cells[col_idx].custom_minimum_size.x - data_cells[col_idx].custom_minimum_size.x)

	return deltas
