extends Control

@onready var TableRow = preload("res://scenes/table_row.tscn")
@onready var TableCell = preload("res://scenes/table_cell.tscn")

@export var data: DataFrame

# Called when the node enters the scene tree for the first time.
func Render() -> void:
    if not data:
        pass
        
    var row_count = data.Size()
    for r in range(row_count):
        var row = TableRow.instantiate()
        print("Adding Row to table")
        $Rows.add_child(row)
        
        for value in data.GetRow(r):
            var cell = TableCell.instantiate()
            cell.text = str(value)
            row.add_child(cell)
