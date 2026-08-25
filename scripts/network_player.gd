extends CharacterBody3D

@export var sync_rate := 0.05

var sync_timer := 0.0

func _physics_process(delta):
    if !is_multiplayer_authority():
        return

    sync_timer += delta

    if sync_timer >= sync_rate:
        sync_timer = 0.0
        send_position.rpc_id(
            1,
            global_position,
            rotation
        )

@rpc("any_peer", "unreliable")
func send_position(position: Vector3, player_rotation: Vector3):
    global_position = position
    rotation = player_rotation
