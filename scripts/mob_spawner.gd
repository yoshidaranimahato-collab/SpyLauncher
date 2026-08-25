extends Node3D

@export var mob_scene: PackedScene
@export var max_mobs := 10
@export var spawn_radius := 20.0
@export var spawn_interval := 5.0

var spawn_timer := 0.0

func _ready():
    spawn_timer = spawn_interval

func _process(delta):
    spawn_timer -= delta

    if spawn_timer <= 0:
        spawn_timer = spawn_interval
        try_spawn()

func try_spawn():
    if mob_scene == null:
        return

    var current_mobs := get_tree().get_nodes_in_group("mobs").size()

    if current_mobs >= max_mobs:
        return

    var player = get_tree().get_first_node_in_group("players")

    if player == null:
        return

    var angle := randf() * TAU
    var distance := randf_range(8.0, spawn_radius)

    var spawn_position := player.global_position + Vector3(
        cos(angle) * distance,
        1.0,
        sin(angle) * distance
    )

    var mob = mob_scene.instantiate()

    add_child(mob)
    mob.global_position = spawn_position

    mob.add_to_group("mobs")
