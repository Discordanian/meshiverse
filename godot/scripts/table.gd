extends Control

@onready var TableRow: PackedScene = preload("res://scenes/table_row.tscn")
@onready var TableCell: PackedScene = preload("res://scenes/table_cell.tscn")
@onready var TableHeader: PackedScene = preload("res://scenes/table_header_cell.tscn")

@export var data: DataFrame
@export var max_column_width: float = 400.0  # Maximum width for a column in pixels
@export var column_padding: float = 16.0  # Additional padding for column width

# Called when the node enters the scene tree for the first time.
func Render() -> void:
    if not data:
        return
    
    # Clear existing rows
    _clear_table()
            
    var row_count: int = data.Size()
    var num_columns: int = data.columns.size()
    
    # Store all cells for width calculation
    var header_row: Node = TableRow.instantiate()
    var header_cells: Array[Control] = []
    var data_rows: Array[Node] = []
    var all_cells: Array[Array] = []  # [column_index][row_index] = cell
    
    # Initialize column arrays
    for col_idx: int in range(num_columns):
        all_cells.append([])
    
    # Build header row
    $VBoxContainer.add_child(header_row)
    $VBoxContainer.move_child(header_row, 0)
    
    for col_idx: int in range(num_columns):
        var cell: Control = TableHeader.instantiate() as Control
        cell.text = data.columns[col_idx]
        header_row.add_child(cell)
        header_cells.append(cell)
        all_cells[col_idx].append(cell)
    
    # Build data rows
    for r: int in range(row_count):
        var row: Node = TableRow.instantiate()
        $VBoxContainer/ScrollContainer/Rows.add_child(row)
        data_rows.append(row)
        
        var row_data: Array = data.GetRow(r)
        for col_idx: int in range(num_columns):
            var cell: Control = TableCell.instantiate() as Control
            if col_idx < row_data.size():
                cell.text = str(row_data[col_idx])
            row.add_child(cell)
            all_cells[col_idx].append(cell)
    
    # Wait for layout to process
    await get_tree().process_frame
    
    # Calculate optimal column widths
    var column_widths: Array[float] = _calculate_column_widths(all_cells)
    
    # Apply widths to all cells
    _apply_column_widths(all_cells, column_widths)

# Calculate optimal width for each column based on content
func _calculate_column_widths(all_cells: Array[Array]) -> Array[float]:
    var column_widths: Array[float] = []
    var num_columns: int = all_cells.size()
    
    for col_idx: int in range(num_columns):
        var max_width: float = 0.0
        var column_cells: Array = all_cells[col_idx]
        
        for cell: Variant in column_cells:
            if not cell is Control:
                continue
                
            var control: Control = cell as Control
            var text: String = ""
            
            # Get text from Label or Button
            if control is Label:
                text = (control as Label).text
            elif control is Button:
                text = (control as Button).text
            
            if text.is_empty():
                continue
            
            # Get font from theme
            var font: Font = _get_font_for_control(control)
            if font:
                var text_size: Vector2 = font.get_string_size(text)
                max_width = max(max_width, text_size.x)
            else:
                # Fallback: estimate width (rough approximation)
                max_width = max(max_width, text.length() * 8.0)
        
        # Add padding and clamp to maximum
        max_width += column_padding
        max_width = min(max_width, max_column_width)
        
        # Ensure minimum width
        max_width = max(max_width, 50.0)
        
        column_widths.append(max_width)
    
    return column_widths

# Get the font used by a control from its theme
func _get_font_for_control(control: Control) -> Font:
    var font: Font = null
    
    if control is Label:
        var label: Label = control as Label
        font = label.get_theme_font("font")
        if font:
            return font
    elif control is Button:
        var button: Button = control as Button
        font = button.get_theme_font("font")
        if font:
            return font
    
    # Fallback to theme default font
    font = get_theme_default_font()
    return font

# Apply calculated widths to all cells in each column
func _apply_column_widths(all_cells: Array[Array], column_widths: Array[float]) -> void:
    var num_columns: int = all_cells.size()
    
    for col_idx: int in range(num_columns):
        var width: float = column_widths[col_idx]
        var column_cells: Array = all_cells[col_idx]
        
        for cell: Variant in column_cells:
            if not cell is Control:
                continue
            
            var control: Control = cell as Control
            # Set minimum width to the calculated width (this becomes the desired width)
            control.custom_minimum_size.x = width
            # Prevent expansion - use 0 to use natural/minimum size (left-aligned by default)
            control.size_flags_horizontal = 0
            
            # Enable text clipping for overflow
            if control is Label:
                (control as Label).clip_contents = true
            elif control is Button:
                (control as Button).clip_contents = true

# Clear existing table rows
func _clear_table() -> void:
    # Clear header row if it exists
    if $VBoxContainer.get_child_count() > 0:
        var first_child: Node = $VBoxContainer.get_child(0)
        if first_child.get_child_count() > 0:
            # Check if it's a header row (has TableHeaderCell children)
            var is_header: bool = false
            for child: Node in first_child.get_children():
                if child.get_class() == "Button" or "Header" in child.name:
                    is_header = true
                    break
            if is_header:
                first_child.queue_free()
    
    # Clear data rows
    var rows_container: Node = $VBoxContainer/ScrollContainer/Rows
    for child: Node in rows_container.get_children():
        child.queue_free()

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
        if i % 17 == 0:
            model_name += " " + model_name + " " + model_name
        mock_data.append([i, model_name, 1950+i])
    return mock_data
