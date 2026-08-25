extends Node

const AIR := 0
const GRASS := 1
const DIRT := 2
const STONE := 3
const WOOD := 4
const LEAVES := 5
const COAL_ORE := 6
const IRON_ORE := 7

var blocks := {
    AIR: {"name": "Air", "solid": false},
    GRASS: {"name": "Grass", "solid": true},
    DIRT: {"name": "Dirt", "solid": true},
    STONE: {"name": "Stone", "solid": true},
    WOOD: {"name": "Wood", "solid": true},
    LEAVES: {"name": "Leaves", "solid": true},
    COAL_ORE: {"name": "Coal Ore", "solid": true},
    IRON_ORE: {"name": "Iron Ore", "solid": true}
}

func is_solid(block_id: int) -> bool:
    return blocks.get(block_id, {}).get("solid", false)

func get_block_name(block_id: int) -> String:
    return blocks.get(block_id, {}).get("name", "Unknown")
