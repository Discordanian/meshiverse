# GdUnit generated TestSuite
extends GdUnitTestSuite


func test_resolution_based_scale_for_standard_display() -> void:
	assert_float(MeshiverseThemeManager.resolution_based_scale_for_width(1920.0)).is_equal(1.0)


func test_resolution_based_scale_for_1440p_display() -> void:
	assert_float(MeshiverseThemeManager.resolution_based_scale_for_width(2560.0)).is_equal(2.5)


func test_resolution_based_scale_for_4k_display() -> void:
	assert_float(MeshiverseThemeManager.resolution_based_scale_for_width(3840.0)).is_equal(3.0)


func test_get_ui_scale_factor_returns_positive_value() -> void:
	var theme_manager: MeshiverseThemeManager = auto_free(MeshiverseThemeManager.new())
	assert_float(theme_manager.get_ui_scale_factor()).is_greater(0.0)


func test_apply_ui_scale_sets_window_content_scale_factor() -> void:
	var theme_manager: MeshiverseThemeManager = auto_free(MeshiverseThemeManager.new())
	var window: Window = auto_free(Window.new())
	var control: Control = auto_free(Control.new())

	add_child(window)
	window.add_child(control)
	await await_idle_frame()

	theme_manager.apply_ui_scale(control)
	await await_idle_frame()

	assert_float(window.content_scale_factor).is_equal(theme_manager.get_ui_scale_factor())
