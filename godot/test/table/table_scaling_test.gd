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


func _assert_columns_aligned(table: Control, row_index: int = 0) -> void:
	var deltas: Array[Vector2] = TableTestHelper.column_position_deltas(table, row_index)
	assert_int(deltas.size()).is_greater(0)

	for delta: Vector2 in deltas:
		assert_float(delta.x).is_equal_approx(0.0, ALIGNMENT_TOLERANCE)

	var width_deltas: Array[float] = TableTestHelper.column_minimum_width_deltas(table, row_index)
	for width_delta: float in width_deltas:
		assert_float(width_delta).is_equal_approx(0.0, ALIGNMENT_TOLERANCE)


func _render_table_at_scale(table: Control, row_count: int, scale_factor: float) -> void:
	var window: Window = table.get_window()
	window.content_scale_factor = scale_factor
	table.mock(row_count)
	await table.Render()
	await await_signal_on(table, "render_completed")
	await await_idle_frame()


func test_columns_align_at_unit_scale() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table_at_scale(table, 5, 1.0)

	_assert_columns_aligned(table, 0)


func test_columns_align_at_double_scale() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table_at_scale(table, 5, 2.0)

	_assert_columns_aligned(table, 0)


func test_column_widths_respect_minimum_at_scaled_ui() -> void:
	var runner := scene_runner(TABLE_SCENE)
	var table: Control = _prepare_table(runner)

	await _render_table_at_scale(table, 5, 2.0)

	var widths: Array[float] = table._enforced_column_widths
	assert_int(widths.size()).is_equal(3)
	for width: float in widths:
		assert_float(width).is_greater_equal(50.0)
