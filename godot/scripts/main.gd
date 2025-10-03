extends Control

@onready var table: Node = $MainMargin/VBoxContainer/HBoxContainer/Table
@onready var menu_bar: MeshMenuBar = $MainMargin/VBoxContainer/MenuBar

func get_scaled_font_size(base_size: int) -> int:
    return int(base_size * get_ui_scale_factor())
    
func get_ui_scale_factor() -> float:
    var screen_size: Vector2 = DisplayServer.screen_get_size()
    var scale_factor: float = DisplayServer.screen_get_max_scale()
    
    print("Screen size: ", screen_size)
    print("Scale Factor: ", scale_factor)
    
    if scale_factor > 1.0:
        return scale_factor
    
    if screen_size.x >= 3840: #4k display
        return 2.0
        
    if screen_size.x >= 2560:
        return 1.5
        
    return 1.0
                

func _mock_data(n: int) -> Array[Array]:
    var data: Array[Array] = []
    for i: int in range(n):
        var model_name: String = "Model %d / %d" % [i,n]
        data.append([i, model_name, 1950+i])
    return data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("main _ready()")
    ConfigFileHandler.print_config(ConfigFileHandler.global_config)
    
    var columns : PackedStringArray = ["Id","Name","Year"]
    var data: Array[Array] = _mock_data(200)
    var df : DataFrame = DataFrame.New(data, columns)
    table.data = df
    table.Render()
    
    var dpi: int = DisplayServer.screen_get_dpi()
    print("DPI returned is : ", dpi)
    var font_size: int = get_scaled_font_size(12)
    print("Returned font size:", font_size)
    
