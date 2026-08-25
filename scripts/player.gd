extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 18.0

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= GRAVITY * delta

    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = Vector3(input_dir.x, 0, input_dir.y)

    if direction.length() > 0:
        direction = direction.normalized()
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()
