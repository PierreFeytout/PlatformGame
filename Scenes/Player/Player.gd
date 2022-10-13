class_name Player
extends Character

export(AudioStream) var walk_sound : AudioStream
export(AudioStream) var jump_sound : AudioStream
export(AudioStream) var hurt_sound : AudioStream
export(AudioStream) var death_sound : AudioStream
export(AudioStream) var attack_sound : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_physics_process(false)
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")

func get_input():
	if (isAttacking or isTakingDamage):
		return
		
	if (Input.is_action_just_pressed("attack_1")):
		isAttacking  = true;
		if (isJumping):
			current_action = action.JUMP_ATTACK
			animationPlayer	.play("JumpAttack")
		else:
			current_action = action.ATTACK
			animationPlayer.play("Attack1")
			velocity.x = 0
	elif Input.is_action_pressed("move_left"):
		current_action = action.MOVE_LEFT
	elif Input.is_action_pressed("move_right"):
		current_action = action.MOVE_RIGHT
	else:
		current_action = action.IDLE

	if Input.is_action_just_pressed("jump") and is_on_floor():
		isJumping = true
		snap = Vector2()
		velocity.y = jump_velocity
		animationPlayer.play("Jump")

func _physics_process(delta):
	if (isJumping and is_on_floor()):
		isJumping = false
		velocity.x = 0
	
	# HANDLE INPUTS
	get_input()
		
	if (isTakingDamage):
		stop_knockback_velocity(delta)
	else:
		if (check_falling() and !isAttacking):
			animationPlayer.play("Falling")
	
	# EXECUTE AND CALCUALTE NEW VELOCITY
	._physics_process(delta)

func anim_walk():
	if (animationPlayer.current_animation != "Walk" and is_on_floor()):
		animationPlayer.play("Walk")

func _start():
	show()
	set_physics_process(true)
	$Camera2D.current = true
	pass

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if (anim_name.findn("attack") != -1):
		isAttacking = false
