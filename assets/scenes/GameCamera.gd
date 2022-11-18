extends Camera2D

var targetPosition = Vector2.ZERO;
export(Color,RGB) var backgroundColour;

func _ready():
	VisualServer.set_default_clear_color(backgroundColour);




func _process(delta):
	_acquire_Position()
	global_position = lerp(targetPosition,global_position,pow(2,-20*delta))#metasbash tis kameras ston paixth KATHE FRAMEs


func _acquire_Position():
	
	var players = get_tree().get_nodes_in_group("player")#exw kanei sto playerscene ena group poy legetai player kai pernw ta nodes apo ayto to scene
	if (players.size() > 0):
		var player = players[0];
		targetPosition = player.global_position;# orizw san ena target position thn thesh poy exei o paikths sto main scene.
