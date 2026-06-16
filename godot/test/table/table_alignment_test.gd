# GdUnit generated TestSuite
extends GdUnitTestSuite

const TableTestHelper = preload("res://test/helpers/table_test_helper.gd")
const TABLE_SCENE: String = "res://scenes/table.tscn"
const PRIMARY_THEME: Theme = preload("res://themes/primary.tres")
const ALIGNMENT_TOLERANCE: float = 1.0


func _prepare_table(runner: GdUnitSceneRunner) -> Control:
	var table: Control = runner.scene()
	table.theme = PRIMARY_THEME
	table.set_anchors_preset(Control.PRESET_TOP_LEFT)
	table.set_size(Vector2(900, 400))
	return table


func _render_table(table: Control, row_count: int) -> void:
	table.mock(row_count)
	await table.Render()
	await await_signal_on(table, "render_completed")
	await await_idle_frame()


func _assert_columns_aligned(table: Control, row_index: int = 0) -> void:
	var deltas: Array[Vector2] = TableTestHelper.column_position_deltas(table, row_index)
	assert_int(deltas.size()).is_greater(0)

	for delta: Vector2 in deltas:
		assert_float(delta.x).is_equal_approx(0.0, ALIGNMENT_TOLERANCE)

	var width_deltas: Array[float] = TableTestHelper.column_minimum_width_deltas(table, row_index)
	for width_delta: float in width_deltas:
		assert_float(width_delta).is_equal_approx(0.0, ALIGNMENT_TOLERANCE)


func test_header_columns_align_with_first_data_row() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table(table, 5)
	_assert_columns_aligned(table, 0)


func test_header_columns_align_with_many_rows_and_scrollbar() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)
	table.set_size(Vector2(600, 220))

	await _render_table(table, 40)
	_assert_columns_aligned(table, 0)

	var body_scroll: ScrollContainer = table.get_node(TableTestHelper.BODY_SCROLL_PATH)
	var v_scroll: VScrollBar = body_scroll.get_v_scroll_bar()
	var spacer: Control = table.get_node(TableTestHelper.SCROLL_BAR_SPACER_PATH)

	if v_scroll.visible:
		assert_float(spacer.custom_minimum_size.x).is_equal_approx(v_scroll.size.x, ALIGNMENT_TOLERANCE)


func test_all_visible_rows_share_column_widths() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table(table, 8)

	var reference_cells: Array[Control] = TableTestHelper.get_data_column_cells(table, 0)
	for row_index: int in range(1, 4):
		var row_cells: Array[Control] = TableTestHelper.get_data_column_cells(table, row_index)
		assert_int(row_cells.size()).is_equal(reference_cells.size())
		for col_idx: int in range(reference_cells.size()):
			assert_float(row_cells[col_idx].size.x).is_equal_approx(
				reference_cells[col_idx].size.x,
				ALIGNMENT_TOLERANCE
			)


func test_columns_align_after_sorting() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table(table, 6)
	table._on_header_clicked("Year")
	await await_signal_on(table, "render_completed")
	await await_idle_frame()

	_assert_columns_aligned(table, 0)


func test_header_and_body_horizontal_scroll_stay_synced() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table(table, 5)

	var body_scroll: ScrollContainer = table.get_node(TableTestHelper.BODY_SCROLL_PATH)
	var header_scroll: ScrollContainer = table.get_node("VBoxContainer/HeaderHBox/HeaderScroll")

	body_scroll.scroll_horizontal = 48
	await await_idle_frame()

	assert_int(header_scroll.scroll_horizontal).is_equal(body_scroll.scroll_horizontal)
