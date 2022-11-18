extends KinematicBody2D

signal died
export (int,LAYERS_2D_PHYSICS) var dashHazardMask
var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 125
var maxVecticalSpeed = 350
var horizontalAcceleration = 12000
var jumpTerminationMultiplier = 3
var hasDoubleJump = false
var maxDashSpeed = 350
var minDashSpeed = 100
var isStateNew = true
enum state {NORMAL,DASH}
var currentState = state.NORMAL
var defaultHazardMask = 0

func _ready():
	$HazardArea.connect("area_entered",self,"on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask


func _process(delta):   #  ekteleite kathe frame	
	
	match currentState:
		state.NORMAL:
			_processNormal(delta)
		state.DASH:
			_processDash(delta)
	isStateNew = false;
func changeState(newState):
	currentState = newState
	isStateNew = true
	
	
func _processNormal(delta):
	if(isStateNew):
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
		
	
	var moveVector = get_Movement_Vector();
	velocity.x += moveVector.x * horizontalAcceleration * delta; # bazw to speed
	velocity.x = clamp(velocity.x,-maxHorizontalSpeed,maxHorizontalSpeed) # bazw ena orio me thn clamp 
	# (min max) poy tha ftasei gia na mhn stackarei sinexws to acceleration
	
	if (moveVector.x == 0):
		velocity.x = lerp(0,velocity.x,pow(2,-50*delta))# gia na "frenarei" se ola ta monitors to idio aneksarthta ti framerate exw
	
	
	if(moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump )): # an tlk exei patihei to space ara isxuei to if 
		velocity.y= moveVector.y * maxVecticalSpeed; # bazw to jump
	
		if(!is_on_floor()):
			hasDoubleJump = false
			$CoyoteTimer.stop();
		
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta;
	else:
		velocity.y += gravity * delta;# edw bazoyme mia timh y ston paikth gia na ton koynisoyme
	var wasOnFloor = is_on_floor();
	velocity = move_and_slide(velocity,Vector2.UP); # edw metakinoyme ton paikth katakoryfa 	
	# kai taytoxronia otan xtipame to ground ginetai reset to velocity gia na mhn stackarei
	# sto apeiro
	if(wasOnFloor && !is_on_floor()): 
		$CoyoteTimer.start();
	if(is_on_floor()):
		hasDoubleJump = true;
	if(Input.is_action_just_pressed("Dash")):
		call_deferred("changeState",state.DASH)
	update_Animation();
	
func _processDash(delta):
	if(isStateNew):
		$AnimatedSprite.play("jump")
		$DashArea/CollisionShape2D.disabled = false
		
		
		var moveVector =  get_Movement_Vector()
		var velocityMode = 1 
		if (moveVector.x !=0 ):
			velocityMode = sign(moveVector.x) #dinei 1 h -1 an h timh einai arnhtikh h thetiki
		else:
			velocityMode = 1 if $AnimatedSprite.flip_h  else -1 
			
			
			
		velocity = Vector2(maxDashSpeed * velocityMode,0)
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(0,velocity.x,pow(2, -8 * delta))
	if(abs(velocity.x) < minDashSpeed):
		call_deferred("changeState",state.NORMAL)
		
	
	
func get_Movement_Vector():
		var moveVector = Vector2.ZERO# ftiaxnw neo vector
		moveVector.x = Input.get_action_strength("movRight") -Input.get_action_strength("movLeft") ; #elegxw poio koympi patithike
		moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0; # elegxw an patithike to koympi
		return moveVector;


func update_Animation():
	var moveVec = get_Movement_Vector();
	if(!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif(moveVec.x!=0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if(moveVec.x != 0):
		$AnimatedSprite.flip_h = true if moveVec.x > 0 else false
	
func on_hazard_area_entered(HazardArea):
	emit_signal("died")# deinw sima oti pethane o player
	

	
	
	

