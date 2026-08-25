extends CharacterBody3D

@export var walk_speed := 4.0
@export var sprint_speed := 7.0
@export var jump_velocity := 5.0
@export var gravity := 14.0

var move_input := Vector2.ZERO
var sprinting := false
var pov_mode := 0
var pov_distance := 4.0

@onready var camera: Camera3D = $Camera3D

func _ready():
    add_to_group("players")

func set_move_input(value: Vector2):
    move_input = value

func set_sprinting(value: bool):
    sprinting = value

func jump():
    if is_on_floor():
        velocity.y = jump_velocity

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if velocity.y < 0:
            velocity.y = 0

    var speed := sprint_speed if sprinting else walk_speed

    var input_3d := Vector3(
        move_input.x,
        0.0,
        move_input.y
    )

    var direction := (
        transform.basis * input_3d
    )

    direction.y = 0

    if direction.length() > 1.0:
        direction = direction.normalized()

    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    move_and_slide()

func take_damage(amount: float):
    print("Player took damage: ", amount)


func look_mobile(delta: Vector2):
    rotate_y(deg_to_rad(-delta.x))

    var camera_rotation := camera.rotation_degrees
    camera_rotation.x = clamp(
        camera_rotation.x - delta.y,
        -89.0,
        89.0
    )
    camera.rotation_degrees = camera_rotation


func cycle_pov():
    pov_mode = (pov_mode + 1) % 3

    if pov_mode == 0:
        camera.position = Vector3(0, 1.6, 0)
        camera.rotation_degrees.x = 0

    elif pov_mode == 1:
        camera.position = Vector3(0, 1.6, pov_distance)
        camera.rotation_degrees.x = 0

    elif pov_mode == 2:
        camera.position = Vector3(0, 1.6, -pov_distance)
        camera.rotation_degrees.x = 0
