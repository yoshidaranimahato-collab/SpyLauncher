extends Node3D

const CHUNK_SCRIPT = preload("res://scripts/world/chunk.gd")
const RENDERER_SCRIPT = preload("res://scripts/world/chunk_renderer.gd")

var chunks: Dictionary = {}

func _ready():
    generate_starting_world()

func generate_starting_world():
    for cx in range(-1, 2):
        for cz in range(-1, 2):
            create_chunk(cx, cz)

func create_chunk(cx: int, cz: int):
    var chunk := CHUNK_SCRIPT.new()
    add_child(chunk)

    chunk.generate(cx, cz)

    var renderer := RENDERER_SCRIPT.new()
    add_child(renderer)

    renderer.position = Vector3(
        cx * 16.0,
        0.0,
        cz * 16.0
    )

    renderer.render_chunk(chunk)

    chunks[Vector2i(cx, cz)] = {
        "data": chunk,
        "renderer": renderer
    }

func break_block_at(position: Vector3i):
    var chunk = _find_chunk_for_block(position)
    if chunk == null:
        return

    var local := Vector3i(
        posmod(position.x, chunk.CHUNK_SIZE),
        position.y,
        posmod(position.z, chunk.CHUNK_SIZE)
    )

    if chunk.get_block(local) != BlockRegistry.AIR:
        chunk.set_block(local, BlockRegistry.AIR)
        print("⛏️ Broken: ", position)

func place_block_at(position: Vector3i, block_id: int):
    var chunk = _find_chunk_for_block(position)
    if chunk == null:
        return

    var local := Vector3i(
        posmod(position.x, chunk.CHUNK_SIZE),
        position.y,
        posmod(position.z, chunk.CHUNK_SIZE)
    )

    if chunk.get_block(local) == BlockRegistry.AIR:
        chunk.set_block(local, block_id)
        print("🧱 Placed: ", position)

func _find_chunk_for_block(position: Vector3i):
    for child in get_children():
        if child.has_method("get_block"):
            var origin = child.get("chunk_position")

            if origin != null:
                var min_x = origin.x * child.CHUNK_SIZE
                var min_z = origin.y * child.CHUNK_SIZE

                if position.x >= min_x and position.x < min_x + child.CHUNK_SIZE:
                    if position.z >= min_z and position.z < min_z + child.CHUNK_SIZE:
                        return child

    return null
