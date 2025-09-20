extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var columns = ["Id","Name","Year"]
    var data: Array[Array] = [
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],        
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],        
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021],
        [1, "Model Number 1", 1970],
        [2, "Model Number 2", 1969],
        [3, "3 Model Number", 2001],
        [4, "Number 4 Model", 2020],
        [5, "Model Number 1", 1978],
        [6, "Model Number 2", 1965],
        [7, "3 Model Number", 2021]    
    ]
    var df = DataFrame.New(data, columns)
    print(df)
    print(df.GetRow(0))
    $PanelContainer/Table.data = df
    $PanelContainer/Table.Render()
