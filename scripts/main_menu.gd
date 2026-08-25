extends Control

func _ready():
    $Play.pressed.connect(_on_play_pressed)
    $Skins.pressed.connect(_on_skins_pressed)
    $SignIn.pressed.connect(_on_sign_in_pressed)
    $Settings.pressed.connect(_on_settings_pressed)
    $Packs.pressed.connect(_on_packs_pressed)
    $Mods.pressed.connect(_on_mods_pressed)
    $Servers.pressed.connect(_on_servers_pressed)

func _on_play_pressed():
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_skins_pressed():
    print("Skins screen")

func _on_sign_in_pressed():
    print("Microsoft Sign In")

func _on_settings_pressed():
    print("Settings screen")

func _on_packs_pressed():
    print("Resource Packs screen")

func _on_mods_pressed():
    print("Mods screen")

func _on_servers_pressed():
    get_tree().change_scene_to_file("res://scenes/Servers.tscn")
