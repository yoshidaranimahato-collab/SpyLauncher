extends Control

const SAVE_PATH := "user://servers.json"

var servers: Array = []
var multiplayer_manager: Node

@onready var server_list: VBoxContainer = $Panel/VBox/ServerList
@onready var name_input: LineEdit = $Panel/VBox/NameInput
@onready var address_input: LineEdit = $Panel/VBox/Address

func _ready():
    $Panel/VBox/AddServer.pressed.connect(_on_add_server_pressed)

    multiplayer_manager = preload("res://scripts/multiplayer_manager.gd").new()
    add_child(multiplayer_manager)

    multiplayer_manager.connection_started.connect(_on_connection_started)
    multiplayer_manager.connection_failed.connect(_on_connection_failed)

    load_servers()
    refresh_list()

func load_servers():
    if not FileAccess.file_exists(SAVE_PATH):
        servers = []
        return

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())

    if data is Array:
        servers = data
    else:
        servers = []

func save_servers():
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(servers))

func _on_add_server_pressed():
    var server_name := name_input.text.strip_edges()
    var address := address_input.text.strip_edges()

    if address.is_empty():
        return

    if server_name.is_empty():
        server_name = address

    servers.append({
        "name": server_name,
        "address": address
    })

    save_servers()

    name_input.clear()
    address_input.clear()

    refresh_list()

func refresh_list():
    for child in server_list.get_children():
        child.queue_free()

    if servers.is_empty():
        var empty_label := Label.new()
        empty_label.text = "No servers added yet."
        server_list.add_child(empty_label)
        return

    for index in range(servers.size()):
        create_server_entry(servers[index], index)

func create_server_entry(server: Dictionary, index: int):
    var panel := PanelContainer.new()
    server_list.add_child(panel)

    var row := HBoxContainer.new()
    panel.add_child(row)

    var info := VBoxContainer.new()
    info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    row.add_child(info)

    var name_label := Label.new()
    name_label.text = server.get("name", "Unknown Server")
    name_label.add_theme_font_size_override("font_size", 20)
    info.add_child(name_label)

    var address_label := Label.new()
    address_label.text = server.get("address", "")
    info.add_child(address_label)

    var play_button := Button.new()
    play_button.text = "PLAY"
    play_button.pressed.connect(
        func():
            connect_to_server(server.get("address", ""))
    )
    row.add_child(play_button)

    var delete_button := Button.new()
    delete_button.text = "DELETE"
    delete_button.pressed.connect(
        func():
            delete_server(index)
    )
    row.add_child(delete_button)

func delete_server(index: int):
    if index >= 0 and index < servers.size():
        servers.remove_at(index)
        save_servers()
        refresh_list()

func connect_to_server(address: String):
    var host := address
    var port := 19132

    if ":" in address:
        var parts := address.split(":")
        host = parts[0]

        if parts.size() > 1:
            port = int(parts[1])

    multiplayer_manager.connect_to_server(host, port)

func _on_connection_started():
    print("Connection started!")

func _on_connection_failed(message: String):
    print("Connection failed: ", message)
