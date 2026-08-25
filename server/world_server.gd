extends Node

var blocks: Dictionary = {}

func _ready():
    generate_world()

func generate_world():
    for x in range(-16, 16):
        for z in range(-16, 16):
            set_block(Vector3i(x, 0, z), "grass")
            set_block(Vector3i(x, -1, z), "dirt")
            set_block(Vector3i(x, -2, z), "stone")

func set_block(position: Vector3i, block_type: String):
    blocks[str(position)] = block_type

func break_block(position: Vector3i):
    blocks.erase(str(position))
    block_changed.rpc(position, "")

func place_block(position: Vector3i, block_type: String):
    blocks[str(position)] = block_type
    block_changed.rpc(position, block_type)

@rpc("authority", "call_local", "reliable")
func block_changed(position: Vector3i, block_type: String):
    print("Block changed: ", position, " -> ", block_type)
