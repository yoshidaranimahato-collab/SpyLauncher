extends HBoxContainer

var hotbar: Node
var buttons: Array[Button] = []

func _ready():
    hotbar = load("res://scripts/hotbar.gd").new()
    add_child(hotbar)

    for i in range(9):
        var button := get_child(i) as Button
        if button == null:
            continue

        buttons.append(button)
        button.pressed.connect(
            func(slot = i):
                select_slot(slot)
        )

    update_ui()

func select_slot(index: int):
    hotbar.select_slot(index)
    update_ui()

func update_ui():
    for i in range(buttons.size()):
        buttons[i].text = ">" + str(i + 1) + "<" if i == hotbar.selected_slot else str(i + 1)
