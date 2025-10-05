extends Control

@onready var TableRow: PackedScene = preload("res://scenes/table_row.tscn")
@onready var TableCell: PackedScene = preload("res://scenes/table_cell.tscn")
@onready var TableHeader: PackedScene = preload("res://scenes/table_header_cell.tscn")

@export var data: DataFrame

# Called when the node enters the scene tree for the first time.
func Render() -> void:
    if not data:
        return
            
    var row_count: int = data.Size()
        
    var header_row: Node = TableRow.instantiate()
    # $ScrollContainer/Rows.add_child(header_row) 
    $VBoxContainer.add_child(header_row)
    $VBoxContainer.move_child(header_row, 0) # Make the header the first thing.
    
    for col: Variant in data.columns:
        var cell: Node = TableHeader.instantiate()
        # print("Adding header Cell %s" % col)
        cell.text = col
        header_row.add_child(cell)
         
    for r: int in range(row_count):
        var row: Node = TableRow.instantiate()
        # print("Adding Row to table")
        $VBoxContainer/ScrollContainer/Rows.add_child(row)
        
        for value: Variant in data.GetRow(r):
            var cell: Node = TableCell.instantiate()
            cell.text = str(value)
            row.add_child(cell)

# mock and _mock_data are for testing
func mock(rows: int) -> void:
    var columns : PackedStringArray = ["Id","Name","Year"]
    var mock_data: Array[Array] = _mock_data(rows)
    var df : DataFrame = DataFrame.New(mock_data, columns)
    data = df

func _mock_data(n: int) -> Array[Array]:
    var mock_data: Array[Array] = []
    for i: int in range(n):
        var model_name: String = "Model %d / %d" % [i,n]
        mock_data.append([i, model_name, 1950+i])
    return mock_data
