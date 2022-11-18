extends Node
var playerScene = preload("res://assets/scenes/player.tscn")
var currentPlayerNode = null
var spawnPosition = Vector2.ZERO

func _ready():
	spawnPosition = $player.global_position
	registerPlayer($player)

func registerPlayer(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died",self,"on_player_died",[],CONNECT_DEFERRED)

func createPlayer():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode,playerInstance)
	playerInstance.global_position = spawnPosition
	registerPlayer(playerInstance) 

func on_player_died():
	currentPlayerNode.queue_free();
	createPlayer()
