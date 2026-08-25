extends Node

const REACH := 5.0

var selected_block := Vector3i.ZERO

func break_block(chunk, position: Vector3i):
    if chunk == null:
        return

    if chunk.get_block(position) == BlockRegistry.AIR:
        return

    chunk.set_block(position, BlockRegistry.AIR)
    print("Broken block: ", position)

func place_block(chunk, position: Vector3i, block_id: int):
    if chunk == null:
        return

    if chunk.get_block(position) != BlockRegistry.AIR:
        return

    chunk.set_block(position, block_id)
    print("Placed block: ", block_id, " at ", position)
