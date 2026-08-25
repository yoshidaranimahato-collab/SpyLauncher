extends Node

var blocks: Dictionary = {}

func receive_block(position: Vector3i, block_type: String):
    var key = str(position)

    if block_type == "":
        blocks.erase(key)
        remove_block(position)
    else:
        blocks[key] = block_type
        create_or_update_block(position, block_type)

func remove_block(position: Vector3i):
    print("Remove block: ", position)

func create_or_update_block(position: Vector3i, block_type: String):
    print("Update block: ", position, " = ", block_type)
