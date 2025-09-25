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
    
    for col in data.columns:
        var cell: Node = TableHeader.instantiate()
        # print("Adding header Cell %s" % col)
        cell.text = col
        header_row.add_child(cell)
         
    for r in range(row_count):
        var row: Node = TableRow.instantiate()
        # print("Adding Row to table")
        $VBoxContainer/ScrollContainer/Rows.add_child(row)
        
        for value: Variant in data.GetRow(r):
            var cell: Node = TableCell.instantiate()
            cell.text = str(value)
            row.add_child(cell)
