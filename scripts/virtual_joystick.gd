extends Control

signal joystick_changed(direction: Vector2)
signal joystick_released

@export var radius := 75.0
@export var deadzone := 0.12

var touch_active := false
var touch_id := -1
var direction := Vector2.ZERO

@onready var knob: Control = $Knob

func _ready():
    custom_minimum_size = Vector2(radius * 2.0, radius * 2.0)

func _gui_input(event):
    if event is InputEventScreenTouch:
        if event.pressed and not touch_active:
            touch_active = true
            touch_id = event.index
            update_joystick(event.position)
            accept_event()

        elif not event.pressed and event.index == touch_id:
            touch_active = false
            touch_id = -1
            direction = Vector2.ZERO
            center_knob()
            joystick_changed.emit(direction)
            joystick_released.emit()
            accept_event()

    elif event is InputEventScreenDrag:
        if touch_active and event.index == touch_id:
            update_joystick(event.position)
            accept_event()

func update_joystick(local_position: Vector2):
    var center := size / 2.0
    var offset := local_position - center

    if offset.length() > radius:
        offset = offset.normalized() * radius

    direction = offset / radius

    if direction.length() < deadzone:
        direction = Vector2.ZERO

    knob.position = center + offset - knob.size / 2.0
    joystick_changed.emit(direction)

func center_knob():
    var center := size / 2.0
    knob.position = center - knob.size / 2.0
