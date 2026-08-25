extends Node3D

func _ready():
    add_to_group("voxel_world")

func _find_chunk(position: Vector3i):
    var cx := floori(float(position.x) / 16.0)
    var cz := floori(float(position.z) / 16.0)

    for child in get_children():
        if child.has_method("get_block"):
            if child.chunk_x == cx and child.chunk_z == cz:
                return child

    return null

func break_block_at(position: Vector3i):
    var chunk = _find_chunk(position)

    if chunk == null:
        return

    var local := Vector3i(
        posmod(position.x, 16),
        position.y,
        posmod(position.z, 16)
    )

    if chunk.get_block(local) == BlockRegistry.AIR:
        return

    chunk.set_block(local, BlockRegistry.AIR)
    print("⛏️ Broken block: ", position)

    _refresh_chunk(chunk)

func place_block_at(position: Vector3i, block_id: int):
    var chunk = _find_chunk(position)

    if chunk == null:
        return

    var local := Vector3i(
        posmod(position.x, 16),
        position.y,
        posmod(position.z, 16)
    )

    if chunk.get_block(local) != BlockRegistry.AIR:
        return

    chunk.set_block(local, block_id)
    print("🧱 Placed block: ", position)

    _refresh_chunk(chunk)

func _refresh_chunk(chunk):
    var renderer = chunk.get_node_or_null("ChunkRenderer")

    if renderer and renderer.has_method("refresh"):
        renderer.refresh(chunk)
