extends Node

signal connection_started
signal connection_succeeded
signal connection_failed(message)

var peer: ENetMultiplayerPeer
var server_address: String = ""
var server_port: int = 19132

func connect_to_server(address: String, port: int = 19132):
    server_address = address
    server_port = port

    print("Connecting to: ", server_address, ":", server_port)

    peer = ENetMultiplayerPeer.new()

    var error = peer.create_client(server_address, server_port)

    if error != OK:
        connection_failed.emit("Could not start connection: " + str(error))
        return

    multiplayer.multiplayer_peer = peer
    connection_started.emit()

func disconnect_from_server():
    if peer:
        peer.close()
        multiplayer.multiplayer_peer = null

func is_connected_to_server() -> bool:
    return multiplayer.multiplayer_peer != null
