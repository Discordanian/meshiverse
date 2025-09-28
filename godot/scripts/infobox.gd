extends Control

@onready var tree: Tree = $MarginContainer/VBoxContainer/ScrollContainer/Tree
@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var dict2: Dictionary



func _ready() -> void:
    
    title.text = "A Title you can believe in."
    
    # "fix" from Claude
    tree.columns = 2
    tree.set_column_title(0, "key")
    tree.set_column_title(1, "value")
    tree.set_column_titles_visible(true)
    
    # Example usage with sample data
    var sample_data: Dictionary = {
        "Player": {
            "name": "John Doe",
            "level": 25,
            "stats": {
                "health": 100,
                "mana": 75,
                "strength": 18,
                "agility": 12
            },
            "inventory": {
                "weapons": ["Sword", "Bow"],
                "potions": ["Health Potion", "Mana Potion"],
                "gold": 1250
            }
        },
        "Settings": {
            "graphics": {
                "resolution": "1920x1080",
                "fullscreen": true,
                "vsync": false
            },
            "audio": {
                "master_volume": 0.8,
                "music_volume": 0.6,
                "sfx_volume": 0.9
            }
        }
    }
    
    populate_tree_from_dictionary(sample_data)

func populate_tree_from_dictionary(dict: Dictionary, parent_item: TreeItem = null) -> void:
    """
    Populates a Tree node with data from a Dictionary.
    Handles nested dictionaries and arrays recursively.

    Parameters:
    - dict: The dictionary to populate from
    - parent_item: The parent TreeItem (null for root level)
    """
    
    # Clear the tree if we're starting fresh (no parent)
    if parent_item == null:
        tree.clear()
        # Create root item if needed
        var root: TreeItem = tree.create_item()
        root.set_text(0, "Root")
        parent_item = root
    
    # Iterate through dictionary items
    for key: Variant in dict.keys():
        var value: Variant = dict[key]
        var item: TreeItem = tree.create_item(parent_item)
        
        # Set the key as the first column
        item.set_text(0, str(key))
        print("key ", key)
        
        # Handle different value types
        match typeof(value):
            TYPE_DICTIONARY:
                # For dictionaries, show type info and recurse
                item.set_text(1, "[Dictionary]")
                item.set_icon(0, get_folder_icon())
                populate_tree_from_dictionary(value, item)
                
            TYPE_ARRAY:
                # For arrays, show type and create child items
                item.set_text(1, "[Array] (" + str(value.size()) + " items)")
                item.set_icon(0, get_array_icon())
                populate_tree_from_array(value, item)
                
            TYPE_STRING:
                item.set_text(1, '"' + str(value) + '"')
                item.set_icon(0, get_string_icon())
                
            TYPE_INT, TYPE_FLOAT:
                item.set_text(1, str(value))
                item.set_icon(0, get_number_icon())
                
            TYPE_BOOL:
                item.set_text(1, str(value))
                item.set_icon(0, get_bool_icon())
                # Optional: Color-code boolean values
                if value:
                    item.set_custom_color(1, Color.GREEN)
                else:
                    item.set_custom_color(1, Color.RED)
                    
            _:
                # Handle any other types
                item.set_text(1, str(value))
                item.set_icon(0, get_default_icon())

func populate_tree_from_array(array: Array, parent_item: TreeItem) -> void:
    """
    Helper function to populate tree items from an array.
    """
    for i: int in range(array.size()):
        var value: Variant = array[i]
        var item: TreeItem = tree.create_item(parent_item)
        
        # Use array index as the key
        item.set_text(0, "[" + str(i) + "]")
        
        # Handle nested structures
        match typeof(value):
            TYPE_DICTIONARY:
                item.set_text(1, "[Dictionary]")
                item.set_icon(0, get_folder_icon())
                populate_tree_from_dictionary(value, item)
                
            TYPE_ARRAY:
                item.set_text(1, "[Array] (" + str(value.size()) + " items)")
                item.set_icon(0, get_array_icon())
                populate_tree_from_array(value, item)
                
            TYPE_STRING:
                item.set_text(1, '"' + str(value) + '"')
                item.set_icon(0, get_string_icon())
                
            TYPE_INT, TYPE_FLOAT:
                item.set_text(1, str(value))
                item.set_icon(0, get_number_icon())
                
            TYPE_BOOL:
                item.set_text(1, str(value))
                item.set_icon(0, get_bool_icon())
                
            _:
                item.set_text(1, str(value))
                item.set_icon(0, get_default_icon())

# Icon helper functions - you can customize these or use actual icon resources
func get_folder_icon() -> Texture2D:
    return get_theme_icon("folder", "FileDialog")

func get_array_icon() -> Texture2D:
    return get_theme_icon("ArrayMesh", "EditorIcons")

func get_string_icon() -> Texture2D:
    return get_theme_icon("String", "EditorIcons")

func get_number_icon() -> Texture2D:
    return get_theme_icon("int", "EditorIcons")

func get_bool_icon() -> Texture2D:
    return get_theme_icon("bool", "EditorIcons")

func get_default_icon() -> Texture2D:
    return get_theme_icon("Variant", "EditorIcons")

# Additional utility functions

func expand_all() -> void:
    """Expand all tree items"""
    var root: TreeItem = tree.get_root()
    if root:
        expand_item_recursive(root)

func collapse_all() -> void:
    """Collapse all tree items except root"""
    var root: TreeItem = tree.get_root()
    if root:
        collapse_item_recursive(root)

func expand_item_recursive(item: TreeItem) -> void:
    """Recursively expand a tree item and all its children"""
    item.set_collapsed(false)
    var child: TreeItem = item.get_first_child()
    while child:
        expand_item_recursive(child)
        child = child.get_next_sibling()

func collapse_item_recursive(item: TreeItem) -> void:
    """Recursively collapse a tree item and all its children"""
    var child: TreeItem = item.get_first_child()
    while child:
        collapse_item_recursive(child)
        child.set_collapsed(true)
        child = child.get_next_sibling()

func clear_tree() -> void:
    """Clear all items from the tree"""
    tree.clear()

func search_tree(search_term: String) -> Array[TreeItem]:
    """
    Search for items containing the search term.
    Returns an array of matching TreeItems.
    """
    var results: Array[TreeItem] = []
    var root: TreeItem = tree.get_root()
    if root:
        search_recursive(root, search_term.to_lower(), results)
    return results

func search_recursive(item: TreeItem, search_term: String, results: Array[TreeItem]) -> void:
    """Helper function for recursive tree searching"""
    # Check current item
    var text0: String = item.get_text(0).to_lower()
    var text1: String = item.get_text(1).to_lower()
    
    if search_term in text0 or search_term in text1:
        results.append(item)
    
    # Check children
    var child: TreeItem = item.get_first_child()
    while child:
        search_recursive(child, search_term, results)
        child = child.get_next_sibling()

# Signal handlers (connect these in the editor or via code)
func _on_tree_item_selected() -> void:
    """Handle tree item selection"""
    var selected: TreeItem = tree.get_selected()
    if selected:
        print("Selected: ", selected.get_text(0), " = ", selected.get_text(1))

func _on_tree_item_collapsed(item: TreeItem) -> void:
    """Handle tree item collapse"""
    print("Collapsed: ", item.get_text(0))

func _on_tree_item_expanded(item: TreeItem) -> void:
    """Handle tree item expansion"""
    print("Expanded: ", item.get_text(0))
