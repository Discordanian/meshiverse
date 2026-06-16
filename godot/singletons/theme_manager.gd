extends Node

class_name MeshiverseThemeManager

func get_ui_scale_factor() -> float:
	var screen_size: Vector2 = DisplayServer.screen_get_size()
	var screen_index: int = DisplayServer.window_get_current_screen()

	# Get the scale factor directly from DisplayServer (works on macOS Retina displays, etc.)
	# screen_get_scale returns 2.0 for Retina displays, 1.0 for standard displays
	var scale_factor: float = DisplayServer.screen_get_scale(screen_index)

	print("Screen size: ", screen_size)
	print("Screen Scale Factor: ", scale_factor)
	# Use scale factor if it's greater than 1.0, otherwise use resolution-based scaling
	if scale_factor > 1.0:
		print("Using DisplayServer scale factor: ", scale_factor)
		return scale_factor

	# Fallback to resolution-based scaling if no scale factor detected
	return resolution_based_scale_for_width(screen_size.x)

static func resolution_based_scale_for_width(screen_width: float) -> float:
	if screen_width >= 3840:
		return 3.0
	if screen_width >= 2560:
		return 2.5
	return 1.0

# Apply UI scaling using Window's content_scale_factor (scales everything uniformly)
func apply_ui_scale(control: Control) -> void:
	var scale_factor: float = get_ui_scale_factor()
	var window: Window = control.get_window()
	if window:
		window.content_scale_factor = scale_factor
		print("Applied content_scale_factor: ", scale_factor, " to window")
	else:
		print("Warning: Could not get window for UI scaling")
