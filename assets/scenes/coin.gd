extends Node2D
func _ready():# PANTA ME KATW PAULA TO FUNC _READY 
	$Area2D.connect("area_entered",self,"on_area_entered")
	
func on_area_entered(area2d):
	$AnimationPlayer.play("pickUp")
	call_deferred("disablePickUp")
	
func disablePickUp():
	$Area2D/CollisionShape2D.disabled = true;
	


