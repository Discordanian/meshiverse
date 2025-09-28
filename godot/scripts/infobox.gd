extends Control

@onready var tree: Tree = $MarginContainer/VBoxContainer/ScrollContainer/Tree
@onready var title: Label = $MarginContainer/VBoxContainer/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    title.text = "A Title to Remember"
    var temp_dict: Dictionary = {
        "Author": "Kurt Schwind",
        "URL": "https://tangentialcold.com",
        "Objective": "Currently, to parse Dictionaries"
    }
    render(temp_dict)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func render(dict: Dictionary) -> void:
    tree = Tree.new()
    
