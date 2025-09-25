extends Resource
class_name DataFrame

@export var data: Array[Array]
@export var columns: PackedStringArray

static func New(d: Array[Array], cols: PackedStringArray) -> DataFrame:
    var df: DataFrame = DataFrame.new()
    
    df.data = d
    if cols:
        df.columns = cols
        
    return df

func GetRow(i: int) -> Array:
    assert(i < len(data), "Index out of bounds")
    
    return data[i]

func Size() -> int:
    return len(data)
    
func _to_string() -> String:
    if len(data) == 0:
        return "<empty>"
    
    var retval: String = " | ".join(columns) + "\n"
    for row: Array in data:
        var row_strings: PackedStringArray = []
        for cell: Variant in row:
            row_strings.append(str(cell))
        retval += " | ".join(row_strings) + "\n"
    
    return retval

func _sort_by(row1: Array, row2: Array, ix: int, desc: bool) -> bool:
    var comparison_result: bool
    
    if row1[ix] < row2[ix]:
        comparison_result = true
    else:
        comparison_result = false
    
    # If desc is true, reverse the comparison
    if desc:
        comparison_result = !comparison_result
        
    return comparison_result

func SortBy(col_name: String, desc: bool = false) -> void:
    assert(col_name in columns, "Column not found: " + col_name)
    
    var ix: int = columns.find(col_name)
    data.sort_custom(_sort_by.bind(ix, desc))
