extends Character

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	self.hide()

func get_input():
	if (isAttacking or isTakingDamage):
		return
		
	if (Input.is_action_just_pressed("attack_1") and is_on_floor()):
		animationPlayer.play("Attack1")
		isAttacking  = true;
		current_action = action.ATTACK
		velocity.x = 0
	elif Input.is_action_pressed("move_left"):
		current_action = action.MOVE_LEFT
	elif Input.is_action_pressed("move_right"):
		current_action = action.MOVE_RIGHT
	else:
		current_action = action.IDLE

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
		isJumping = true
		animationPlayer.play("Jump")

func _physics_process(delta):
	# HANDLE INPUTS
	get_input()
		
	if (isTakingDamage):
		stop_knockback_velocity(delta)
	else:		
		handle_jump()
		
		if (check_falling()):
			animationPlayer.play("Falling")
	
	# EXECUTE AND CALCUALTE NEW VELOCITY
	._physics_process(delta)

func handle_jump():
	if (isJumping):
		snap = Vector2()
	else:
		snap = Vector2(0,32)

func anim_walk():
	if (animationPlayer.current_animation != "Walk" and is_on_floor()):
		animationPlayer.play("Walk")

func _start():
	self.show()
	self.set_physics_process(true)

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Attack1"):
		isAttacking = false
