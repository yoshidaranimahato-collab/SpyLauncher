extends Node

@export var reach := 5.0

var camera: Camera3D
var world: Node = null

func setup(player_camera: Camera3D):
    camera = player_camera
    world = get_tree().get_first_node_in_group("voxel_world")

func break_target():
    if camera == null or world == null:
        return

    var result := raycast()

    if result.is_empty():
        return

    var hit: Vector3 = result["position"]
    var normal: Vector3 = result["normal"]

    var block_position := Vector3i(
        floor(hit.x - normal.x * 0.01),
        floor(hit.y - normal.y * 0.01),
        floor(hit.z - normal.z * 0.01)
    )

    if world.has_method("break_block_at"):
        world.break_block_at(block_position)

func place_target(block_id: int = 1):
    if camera == null or world == null:
        return

    var result := raycast()

    if result.is_empty():
        return

    var hit: Vector3 = result["position"]
    var normal: Vector3 = result["normal"]

    var block_position := Vector3i(
        floor(hit.x + normal.x * 0.51),
        floor(hit.y + normal.y * 0.51),
        floor(hit.z + normal.z * 0.51)
    )

    if world.has_method("place_block_at"):
        world.place_block_at(block_position, block_id)

func raycast() -> Dictionary:
    var from := camera.global_position
    var to := from + (-camera.global_transform.basis.z * reach)

    var query := PhysicsRayQueryParameters3D.create(from, to)
    query.collide_with_areas = false

    return camera.get_world_3d().direct_space_state.intersect_ray(query)
