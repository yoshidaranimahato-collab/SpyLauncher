extends Node

const CHUNK_SIZE := 16
const WORLD_HEIGHT := 48

var blocks: Dictionary = {}

var chunk_x: int = 0
var chunk_z: int = 0

func generate(chunk_x: int, chunk_z: int):
    self.chunk_x = chunk_x
    self.chunk_z = chunk_z
    blocks.clear()

    for x in range(CHUNK_SIZE):
        for z in range(CHUNK_SIZE):

            var world_x = chunk_x * CHUNK_SIZE + x
            var world_z = chunk_z * CHUNK_SIZE + z

            var height := 8

            # Simple deterministic terrain
            height += int(
                sin(float(world_x) * 0.15) * 2.0 +
                cos(float(world_z) * 0.12) * 2.0
            )

            for y in range(WORLD_HEIGHT):

                var id := BlockRegistry.AIR

                if y == height:
                    id = BlockRegistry.GRASS
                elif y >= height - 3 and y < height:
                    id = BlockRegistry.DIRT
                elif y < height - 3:
                    id = BlockRegistry.STONE

                blocks[Vector3i(x, y, z)] = id

            generate_tree_if_needed(world_x, world_z, height)

func generate_tree_if_needed(world_x: int, world_z: int, ground_y: int):
    if abs(world_x) % 13 != 0:
        return

    if abs(world_z) % 17 != 0:
        return

    var local_x := posmod(world_x, CHUNK_SIZE)
    var local_z := posmod(world_z, CHUNK_SIZE)

    for y in range(1, 5):
        blocks[Vector3i(local_x, ground_y + y, local_z)] = BlockRegistry.WOOD

    for x in range(-2, 3):
        for z in range(-2, 3):
            for y in range(4, 6):
                if abs(x) + abs(z) <= 3:
                    blocks[
                        Vector3i(local_x + x, ground_y + y, local_z + z)
                    ] = BlockRegistry.LEAVES

func get_block(position: Vector3i) -> int:
    return blocks.get(position, BlockRegistry.AIR)

func set_block(position: Vector3i, block_id: int):
    blocks[position] = block_id
