extends Node3D

const BLOCK_SIZE := 1.0

var block_colors := {
    1: Color(0.25, 0.75, 0.25),
    2: Color(0.45, 0.30, 0.15),
    3: Color(0.45, 0.45, 0.45),
    4: Color(0.55, 0.32, 0.12),
    5: Color(0.20, 0.60, 0.20),
    6: Color(0.08, 0.08, 0.08),
    7: Color(0.70, 0.65, 0.60)
}

func render_chunk(chunk):
    clear_chunk()

    for position in chunk.blocks:
        var block_id: int = chunk.blocks[position]

        if block_id == BlockRegistry.AIR:
            continue

        create_block(position, block_id)

func create_block(position: Vector3i, block_id: int):
    var body := StaticBody3D.new()
    body.position = Vector3(position) + Vector3.ONE * 0.5

    var mesh_instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3.ONE * BLOCK_SIZE

    mesh_instance.mesh = mesh

    var material := StandardMaterial3D.new()
    material.albedo_color = block_colors.get(
        block_id,
        Color(1, 1, 1)
    )
    mesh_instance.material_override = material

    body.add_child(mesh_instance)

    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3.ONE * BLOCK_SIZE

    collision.shape = shape
    body.add_child(collision)

    add_child(body)

func clear_chunk():
    for child in get_children():
        child.free()

func refresh(chunk):
    render_chunk(chunk)
