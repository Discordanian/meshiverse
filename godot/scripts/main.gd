extends Control

func _mock_data(n: int) -> Array[Array]:
    var data: Array[Array] = []
    for i in range(n):
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
    $MainMargin/VBoxContainer/PanelContainer/Table.data = df
    $MainMargin/VBoxContainer/PanelContainer/Table.Render()
