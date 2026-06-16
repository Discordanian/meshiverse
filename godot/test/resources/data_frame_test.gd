# GdUnit generated TestSuite
extends GdUnitTestSuite


func test_new_creates_dataframe_with_rows_and_columns() -> void:
	var rows: Array[Array] = [[1, "Alpha", 2000], [2, "Beta", 2001]]
	var columns: PackedStringArray = ["Id", "Name", "Year"]
	var df: DataFrame = DataFrame.New(rows, columns)

	assert_int(df.Size()).is_equal(2)
	assert_str(df.columns[0]).is_equal("Id")
	assert_int(df.GetRow(1)[0]).is_equal(2)


func test_sort_by_column_ascending() -> void:
	var rows: Array[Array] = [[3, "C"], [1, "A"], [2, "B"]]
	var df: DataFrame = DataFrame.New(rows, ["Id", "Name"])

	df.SortBy("Id", false)

	assert_int(df.GetRow(0)[0]).is_equal(1)
	assert_int(df.GetRow(2)[0]).is_equal(3)


func test_sort_by_column_descending() -> void:
	var rows: Array[Array] = [[3, "C"], [1, "A"], [2, "B"]]
	var df: DataFrame = DataFrame.New(rows, ["Id", "Name"])

	df.SortBy("Name", true)

	assert_str(df.GetRow(0)[1]).is_equal("C")
	assert_str(df.GetRow(2)[1]).is_equal("A")
