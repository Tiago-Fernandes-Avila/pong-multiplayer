extends Node

const MAX_CLIENTS : int = 2

@export var player_scene = preload("res://Scenes/jogador.tscn")
@export var ball_scene = preload("res://Scenes/bola.tscn")

@onready var UI = $NETWORK_UI
@onready var username_input = $NETWORK_UI/VBoxContainer/username
@onready var port_input = $NETWORK_UI/VBoxContainer/port
@onready var ip_input = $NETWORK_UI/VBoxContainer/ip
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var game_ui: Control = $Game_UI
@onready var player_2_pont: Label = $Game_UI/player2pont
@onready var player_1_pont: Label = $Game_UI/player1pont
@onready var vencedor: Label = $EndGame_UI/vencedor
@onready var end_game_ui: Control = $EndGame_UI



var username : String = ""
var port : int = 8080
var ip : String = "127.0.0.1"
var peer : ENetMultiplayerPeer


func _ready() -> void:
	game_ui.visible = false

func _physics_process(delta: float) -> void:
		player_1_pont.text = username + str(GameStatus.player_one_pontuation)
		player_2_pont.text =  str(GameStatus.player_two_pontuation) 
		if GameStatus.player_one_pontuation == 10: 
			vencedor.text = "player 1 venceu!"
			end_game_ui.visible = true
		elif GameStatus.player_two_pontuation == 10:
			vencedor.text = "player 2 venceu"
			end_game_ui.visible = true
			
			

func start_server():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, MAX_CLIENTS)
	if error != OK:
		print("Error in server creation")
	multiplayer.multiplayer_peer = peer
	UI.visible = false
	multiplayer.multiplayer_peer.peer_connected.connect(_init_game_logic)
	multiplayer.multiplayer_peer.peer_disconnected.connect(func(id: int): print("O player %d se desconectou!"%id))
	_add_player()

func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer;
	UI.visible = false
	multiplayer.connected_to_server.connect(func(): print("conection success!"))
	multiplayer.connection_failed.connect(func(): print("conection failed!"))
	multiplayer.server_disconnected.connect(func(): print("conection lost!"))


func _init_game_logic(id : int):
	if multiplayer.is_server():
		var ball = ball_scene.instantiate()
		ball.name = "Bola_" + str(Time.get_ticks_msec()) 
		ball.position = Vector2(576, 324) # Centro da tela
		add_child(ball, true)
		_add_player(id)
		game_ui.visible = true
		GameStatus.player_one_pontuation = 0
		GameStatus.player_two_pontuation = 0

	
func _add_player(id : int = 1):
	print("um player %d se conectou!"%id)
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)
	
	
	
func _on_ip_text_changed(new_ip: String) -> void:
	ip = new_ip
	print(ip)
func _on_port_text_changed(new_port: String) -> void:
	port = int(new_port) 
func _on_username_text_changed(new_username: String) -> void:
	username = new_username
	


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
