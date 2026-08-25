extends Control

var player: Node = null
var look_touch_id := -1
var last_look_position := Vector2.ZERO
var block_actions: Node = null

@export var look_sensitivity := 0.18

@onready var joystick = $Joystick
@onready var jump_button = $Actions/Jump
@onready var sprint_button = $Actions/Sprint
@onready var pov_button = $POV
@onready var break_button = $Break
@onready var place_button = $Place

func _ready():
    block_actions = load("res://scripts/world/block_action_controller.gd").new()
    add_child(block_actions)
    player = get_tree().get_first_node_in_group("players")

    if player == null:
        call_deferred("_find_player")

    if joystick.has_signal("joystick_changed"):
        joystick.joystick_changed.connect(_on_joystick_changed)

    jump_button.pressed.connect(_jump)
    sprint_button.button_down.connect(_sprint_start)
    sprint_button.button_up.connect(_sprint_stop)
    pov_button.pressed.connect(_change_pov)
    break_button.pressed.connect(_break_block)
    place_button.pressed.connect(_place_block)

func _find_player():
    player = get_tree().get_first_node_in_group("players")

func _on_joystick_changed(direction: Vector2):
    if player and player.has_method("set_move_input"):
        player.set_move_input(direction)

func _jump():
    if player and player.has_method("jump"):
        player.jump()

func _sprint_start():
    if player and player.has_method("set_sprinting"):
        player.set_sprinting(true)

func _sprint_stop():
    if player and player.has_method("set_sprinting"):
        player.set_sprinting(false)

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x > get_viewport_rect().size.x * 0.45:
                look_touch_id = event.index
                last_look_position = event.position
        elif event.index == look_touch_id:
            look_touch_id = -1

    elif event is InputEventScreenDrag:
        if event.index == look_touch_id:
            var delta := event.position - last_look_position
            last_look_position = event.position

            if player and player.has_method("look_mobile"):
                player.look_mobile(delta * look_sensitivity)


func _change_pov():
    if player and player.has_method("cycle_pov"):
        player.cycle_pov()


func _break_block():
    if player and player.has_node("Camera3D"):
        block_actions.setup(player.get_node("Camera3D"))
        block_actions.break_target()

func _place_block():
    if player and player.has_node("Camera3D"):
        block_actions.setup(player.get_node("Camera3D"))
        block_actions.place_target(1)
