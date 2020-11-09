extends Actor
onready var sprite = $player
onready var animation_tree= $player/AnimationTree
onready var playBack =  animation_tree.get("parameters/playback");

func _physics_process(delta):
	var current_state = playBack.get_current_node()
	var direction:= get_direction()
	# Agar Pas Jump Ada sedikit Interrup/mandeg
	# Action_just_released bernilai true ketika key map tidak lagi ditekan
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	# Menghitung kecepatan velocity untuk jalannya player
	_velocity= calculate_move_velocity(_velocity,direction,speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	var is_attacking = false
	# Biar collision attack area disable, ketika dia nyerang, dia akan enable
	$AttackArea/CollisionShape2D.disabled=true
	# jika ditekan input jalan ke kiri
	if Input.is_action_pressed("move_left"):
		#Biar Collision shape dan Attack area sesuai, 
		#kalau gk diginiian posisi mereka gk sesuai
		#Karna asset player gk pas :3 (pas pindah arah ke -1 dan 1)
		#jadinya collision nya di pas2in :D
		get_node("CollisionShape2D").set_position(Vector2(14.0,-62.0))
		get_node("AttackArea").set_scale(Vector2(-1,1))
		#Player arahe/menghadap ke kiri
		sprite.scale.x =-1
	# jika ditekan input jalan ke kanan
	if Input.is_action_pressed("move_right"):
		#Sama kyk diatas yang masalah collision gk pas
		get_node("CollisionShape2D").set_position(Vector2(-13.0,-62.0))
		get_node("AttackArea").set_scale(Vector2(1,1))
		#Player arah e /menghadap kekanan
		sprite.scale.x =1
	#Jika Input Key Attack ditekan
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
	
	if current_state == "Attack":
		#Mengenable attack collision
		$AttackArea/CollisionShape2D.disabled=false
	#Transisi buat Finite State Machine
	animation_tree['parameters/conditions/IsAttacking'] = is_attacking
	animation_tree["parameters/conditions/IsMoving"] = (_velocity.x !=0)
	animation_tree["parameters/conditions/NotIsMoving"] = (_velocity.x==0)
	animation_tree["parameters/conditions/IsJumping"] = (!is_on_floor())
	#print("Kondisi Player : " + current_state)
	#print(_velocity.y)
	
func get_direction() -> Vector2:
	return Vector2(
		# Input move_right dan move left, ada "-" buat balik arah
		# Action Strength, ketika ditekan mengembalikan nilai 1
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)
func calculate_move_velocity(
	linier_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	#Menghitung kecepatan out.x (kecepatan jalan saat di x)
	var out: = linier_velocity
	out.x = speed.x * direction.x
	#Menghitung kecepatan y nya saat jatuh
	out.y += gravity * get_physics_process_delta_time()
	#Menghitung kecepatan nya saat lompat,
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	# Ketika bernilai true, maka jump akan sedikit ada interupt
	if is_jump_interrupted:
		out.y = 0.0
	return out



