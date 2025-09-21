extends Control

func _mock_data(n: int) -> Array[Array]:
    var data: Array[Array] = []
    for i in range(n):
        var name: String = "Model %d / %d" % [i,n]
        data.append([i, name, 1950+i])
    return data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("main _ready()")
    ConfigFileHandler.print_config(ConfigFileHandler.global_config)
    
    var columns = ["Id","Name","Year"]
    var data: Array[Array] = _mock_data(200)
    var df = DataFrame.New(data, columns)
    $PanelContainer/Table.data = df
    $PanelContainer/Table.Render()
