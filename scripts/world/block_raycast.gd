extends Node

@export var reach := 5.0

var targeted_block := Vector3i.ZERO
var targeted_normal := Vector3i.ZERO
var has_target := false

func check(camera: Camera3D):
    has_target = false

    if camera == null:
        return

    var from := camera.global_position
    var to := from + (-camera.global_transform.basis.z * reach)

    var query := PhysicsRayQueryParameters3D.create(from, to)
    query.collide_with_areas = false

    var space := camera.get_world_3d().direct_space_state
    var result := space.intersect_ray(query)

    if result.is_empty():
        return

    var hit_position: Vector3 = result["position"]
    var normal: Vector3 = result["normal"]

    targeted_block = Vector3i(
        floor(hit_position.x),
        floor(hit_position.y),
        floor(hit_position.z)
    )

    targeted_normal = Vector3i(
        round(normal.x),
        round(normal.y),
        round(normal.z)
    )

    has_target = true
