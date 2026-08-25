extends Control

const SAVE_PATH := "user://custom_controls.json"

var selected: Control = null
var dragging := false
var drag_offset := Vector2.ZERO

var controls := {
    "Joystick": {"x": 60.0, "y": 450.0, "size": 150.0, "opacity": 1.0},
    "Attack": {"x": 600.0, "y": 430.0, "size": 90.0, "opacity": 1.0},
    "Jump": {"x": 500.0, "y": 350.0, "size": 80.0, "opacity": 1.0},
    "Sprint": {"x": 400.0, "y": 450.0, "size": 70.0, "opacity": 1.0}
}

func _ready():
    load_layout()
    apply_layout()

    $Save.pressed.connect(save_layout)
    $Reset.pressed.connect(reset_layout)

    $SizeSlider.value_changed.connect(_on_size_changed)
    $OpacitySlider.value_changed.connect(_on_opacity_changed)

    for name in controls:
        var node := get_node_or_null(name)

        if node:
            node.gui_input.connect(
                func(event):
                    control_input(event, node)
            )

func control_input(event: InputEvent, node: Control):
    if event is InputEventScreenTouch:
        if event.pressed:
            selected = node
            dragging = true
            drag_offset = node.position - event.position

            $SizeSlider.value = controls[node.name]["size"]
            $OpacitySlider.value = controls[node.name]["opacity"]
        else:
            dragging = false

    elif event is InputEventScreenDrag:
        if selected == node and dragging:
            node.position = event.position + drag_offset

            controls[node.name]["x"] = node.position.x
            controls[node.name]["y"] = node.position.y

func _on_size_changed(value: float):
    if selected == null:
        return

    selected.size = Vector2(value, value)
    controls[selected.name]["size"] = value

func _on_opacity_changed(value: float):
    if selected == null:
        return

    selected.modulate.a = value
    controls[selected.name]["opacity"] = value

func apply_layout():
    for name in controls:
        var node := get_node_or_null(name)

        if node:
            node.position = Vector2(
                controls[name]["x"],
                controls[name]["y"]
            )

            var size := controls[name]["size"]

            node.size = Vector2(size, size)
            node.modulate.a = controls[name]["opacity"]

func save_layout():
    for name in controls:
        var node := get_node_or_null(name)

        if node:
            controls[name]["x"] = node.position.x
            controls[name]["y"] = node.position.y
            controls[name]["size"] = node.size.x
            controls[name]["opacity"] = node.modulate.a

    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

    if file:
        file.store_string(JSON.stringify(controls))
        print("Custom controls saved.")

func load_layout():
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

    if file == null:
        return

    var data = JSON.parse_string(file.get_as_text())

    if data is Dictionary:
        for name in data:
            if controls.has(name):
                controls[name] = data[name]

func reset_layout():
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(SAVE_PATH)

    get_tree().reload_current_scene()
