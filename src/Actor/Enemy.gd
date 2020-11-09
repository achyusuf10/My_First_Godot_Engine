extends "res://src/Actor/Actor.gd"

## Inisialisasi
onready var Player = get_parent().get_node("Player")
onready var animation_tree= $enemy/AnimationTree
onready var esprite = $enemy
onready var playBack =  animation_tree.get("parameters/playback");
var dead = false


func _physics_process(delta):
	#Mendapatkan Current Stat
	var current_state = playBack.get_current_node()
	if dead == false:
		var is_attacking = false
		var is_near = false
		# Jika player mendekat dari kiri, dan jaraknya 85<x<800
		#Enemy bakalan Chase
		if position.x - Player.position.x < 800 and position.x - Player.position.x > 85:
			_velocity.x = -150
			get_node("CollisionShape2D").set_position(Vector2(24.0,-65.0))
			get_node("Area2D").set_position(Vector2(24.0,-65.0))
			esprite.scale.x=-1
			is_near=true
		# Jika player mendekat dari kanan, dan jaraknya -800<x<-85
		#Enemy bakalan Chase
		elif position.x - Player.position.x > -800 and position.x - Player.position.x < -85:
			_velocity.x = 150
			get_node("CollisionShape2D").set_position(Vector2(10.0,-65.0))
			get_node("Area2D").set_position(Vector2(10.0,-65.0))
			esprite.scale.x = 1
			is_near=true
		# Saat jarak player dan enemy <=85
		#Enemy bakalan attack
		elif position.x - Player.position.x >= -85 and position.x - Player.position.x <= 85:
			is_attacking = true
			_velocity.x = 0
		else:
			_velocity.x = 0
		#Transisi FSA
		animation_tree["parameters/conditions/IsNear"]= is_near
		animation_tree["parameters/conditions/NotIsNear"]= !is_near
		animation_tree["parameters/conditions/IsAttacking"]= is_attacking
		animation_tree["parameters/conditions/NotIsAttacking"]= !is_attacking
		#print(Player.position.x)
		#print(position.x - Player.position.x)
		_velocity.y +=gravity * delta
		_velocity.y = move_and_slide(_velocity,
		FLOOR_NORMAL).y
	else:
		#Transisi FSA ke death
		animation_tree["parameters/conditions/IsDead"]= dead
		
	# Print Kondisi Enemy
	print("Kondisi Enemy  : "+ current_state)
		


#Deteksi Collision, kalau collision attack dari player kena collision enemy
# Enemy bakalan Dead :#
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword"):
		dead=true





