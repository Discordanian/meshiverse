extends Node

class_name MeshiverseThemeManager

func get_scaled_font_size(base_size: int) -> int:
    var scaled_factor: float = get_ui_scale_factor()
    print("Scaled Factor is ", scaled_factor)
    return int(base_size * scaled_factor)
    
func get_ui_scale_factor() -> float:
    var screen_size: Vector2 = DisplayServer.screen_get_size()
    var scale_factor: float = DisplayServer.screen_get_max_scale()
    
    print("Screen size: ", screen_size)
    print("Screen Scale Factor: ", scale_factor)
    
    if scale_factor > 1.0:
        return scale_factor
    
    if screen_size.x >= 3840: #4k display
        return 3.0
        
    if screen_size.x >= 2560:
        return 2.5
        
    return 1.0

func update_theme(theme: Theme) -> Theme:
    theme.default_font_size = get_scaled_font_size(12)
    return theme
