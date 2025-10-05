extends Control

enum VisibleScreen { SETTINGS, LIBRARY, DETAILS }

@onready var table: Node = $MainMargin/MainVbox/HBoxContainer/Table
@onready var menu_bar: MeshMenuBar = $MainMargin/MainVbox/MenuBar

@onready var primary_node: Node = $MainMargin/MainVbox
@onready var settings_node: Node = $MainMargin/Settings

var visible_screen: VisibleScreen = VisibleScreen.LIBRARY

               

func _mock_data(n: int) -> Array[Array]:
    var data: Array[Array] = []
    for i: int in range(n):
        var model_name: String = "Model %d / %d" % [i,n]
        data.append([i, model_name, 1950+i])
    return data

func setup_theme() -> void:
    var tm: MeshiverseThemeManager = MeshiverseThemeManager.new()
    var local_theme: Theme = $".".theme
    $".".theme = tm.update_theme(local_theme)
    
    
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
    # var font_size: int = get_scaled_font_size(12)
    # print("Returned font size:", font_size)
    # print(visible_screen)
    setup_theme()
    _visibility()

func _visibility() -> void:
    match visible_screen:
        VisibleScreen.SETTINGS:
            primary_node.visible = false
            settings_node.visible = true
        VisibleScreen.LIBRARY:
            primary_node.visible = true
            settings_node.visible = false           
        VisibleScreen.DETAILS:
            print("Not currently able to handle DETAILS screen")
        _:
            assert(1 < 0, "Unspecified VisibleScreen state in visibility() function %s" % VisibleScreen.keys()[visible_screen]) 
