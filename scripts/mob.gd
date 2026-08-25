extends CharacterBody3D

@export var max_health := 20.0
@export var move_speed := 2.5
@export var detection_range := 12.0
@export var attack_range := 1.8
@export var attack_damage := 2.0
@export var attack_cooldown := 1.0

var health := 20.0
var target: Node3D = null
var attack_timer := 0.0

func _ready():
    health = max_health

func _physics_process(delta):
    attack_timer -= delta

    find_target()

    if target == null:
        velocity.x = 0
        velocity.z = 0
        move_and_slide()
        return

    var distance := global_position.distance_to(target.global_position)

    if distance <= attack_range:
        velocity.x = 0
        velocity.z = 0
        attack_target()
    elif distance <= detection_range:
        chase_target()
    else:
        velocity.x = 0
        velocity.z = 0

    move_and_slide()

func find_target():
    if target != null and is_instance_valid(target):
        if global_position.distance_to(target.global_position) <= detection_range:
            return

    target = null

    var players := get_tree().get_nodes_in_group("players")

    var closest_distance := detection_range

    for player in players:
        if not player is Node3D:
            continue

        var distance := global_position.distance_to(player.global_position)

        if distance < closest_distance:
            closest_distance = distance
            target = player

func chase_target():
    var direction := target.global_position - global_position
    direction.y = 0

    if direction.length() > 0.1:
        direction = direction.normalized()

        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed

        look_at(
            global_position + direction,
            Vector3.UP
        )

func attack_target():
    if attack_timer > 0:
        return

    attack_timer = attack_cooldown

    if target.has_method("take_damage"):
        target.take_damage(attack_damage)

func take_damage(amount: float):
    health -= amount

    if health <= 0:
        die()

func die():
    queue_free()
