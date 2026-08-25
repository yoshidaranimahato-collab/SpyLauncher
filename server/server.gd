extends Node

const PORT := 19132
const MAX_PLAYERS := 50

var peer := ENetMultiplayerPeer.new()
var players: Dictionary = {}

func _ready():
    var error = peer.create_server(PORT, MAX_PLAYERS)

    if error != OK:
        print("Server failed: ", error)
        return

    multiplayer.multiplayer_peer = peer

    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

    print("SpyLauncher Server started on port ", PORT)

func _on_peer_connected(id: int):
    players[id] = {
        "position": Vector3.ZERO,
        "rotation": Vector3.ZERO
    }

    print("Player connected: ", id)

    for existing_id in players:
        if existing_id != id:
            send_existing_player.rpc_id(
                id,
                existing_id,
                players[existing_id]["position"],
                players[existing_id]["rotation"]
            )

    spawn_player.rpc(id)

@rpc("authority", "call_local", "reliable")
func spawn_player(id: int):
    print("Spawn player: ", id)

func _on_peer_disconnected(id: int):
    players.erase(id)
    despawn_player.rpc(id)
    print("Player disconnected: ", id)

@rpc("authority", "call_local", "reliable")
func despawn_player(id: int):
    print("Despawn player: ", id)

@rpc("authority", "call_remote", "reliable")
func send_existing_player(id: int, position: Vector3, rotation: Vector3):
    print("Existing player: ", id)
