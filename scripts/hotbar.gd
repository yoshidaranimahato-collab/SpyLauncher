extends Node

signal block_selected(block_id)

var selected_slot := 0

var slots := [
    BlockRegistry.GRASS,
    BlockRegistry.DIRT,
    BlockRegistry.STONE,
    BlockRegistry.WOOD,
    BlockRegistry.LEAVES,
    BlockRegistry.COAL_ORE,
    BlockRegistry.IRON_ORE,
    BlockRegistry.STONE,
    BlockRegistry.DIRT
]

func select_slot(index: int):
    if index < 0 or index >= slots.size():
        return

    selected_slot = index
    block_selected.emit(slots[index])

    print(
        "Selected slot: ",
        index + 1,
        " Block: ",
        BlockRegistry.get_block_name(slots[index])
    )

func get_selected_block() -> int:
    return slots[selected_slot]
