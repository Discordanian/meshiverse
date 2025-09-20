extends Resource

class_name DataFrame

@export var data: Array
@export var columns: PackedStringArray

static func New(d: Array, cols: PackedStringArray) -> DataFrame:
    var df =  DataFrame.new()
    
    df.data = d
    if cols:
        df.columns = cols
        
    return df


func GetRow(i: int):
    assert(i < len(data))
    
    return data[i]


func _to_string() -> String:
    if len(data) == 0:
        return "<empty>"
    
    var retval: String = " | ".join(columns) + "\n"
    for row in data:
        retval += " | ".join(row) + "\n"
    
    if desc:
        return !retval
    return retval

func _sort_by(row1, row2, ix, desc) -> bool:
    var retval: bool
    
    if row1[ix] < row2[ix]:
        retval = true
    else:
        retval = false
    return retval

func SortBy(col_name: String, desc: bool = false):
    assert(col_name in columns)
    
    var ix = columns.find(col_name)
    data.sort_custom(_sort_by.bind(ix, desc))
