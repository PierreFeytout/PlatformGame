class_name Player
extends Character

var count_charge_frame := 0
var charging_attack := false
onready var projectile_resource := preload("res://Scenes/Projectile.tscn")
onready var player_vars := get_node("/root/PlayerVariables") as PlayerVariables

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_physics_process(false)
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	main_body = $Body

func get_input():
	if (isAttacking or isTakingDamage):
		return
		
	if (Input.is_action_pressed("attack_1") and is_on_floor()):
		velocity.x = 0
		if (charging_attack):
			current_action = action.ATTACK
			animationPlayer.play("ChargeAttack")
		elif (count_charge_frame == 15):
			charging_attack = true
		else:
			count_charge_frame +=1
	elif (Input.is_action_just_pressed("attack_1") and isJumping):
		isAttacking  = true;
		current_action = action.JUMP_ATTACK
		animationPlayer	.play("JumpAttack")
		velocity.x /= 2
	elif (Input.is_action_just_released("attack_1")):
		count_charge_frame = 0
		if (animationPlayer.assigned_animation == "JumpAttack"):
			return
		if (charging_attack):
			velocity.x = 0
			$Sprite/Particles2D.emitting = false
			var projectile = projectile_resource.instance()
			get_parent().add_child(projectile)
			projectile.global_position.y = self.global_position.y
			projectile.global_position.x = self.global_position.x
			projectile.launch(32)
			charging_attack = false
			
		isAttacking  = true;
		current_action = action.ATTACK
		animationPlayer.play("Attack1")
		velocity.x = 0
	elif Input.is_action_pressed("move_left"):
		current_action = action.MOVE_LEFT
		flip_sprite(dir_enum.LEFT)
	elif Input.is_action_pressed("move_right"):
		current_action = action.MOVE_RIGHT
		flip_sprite(dir_enum.RIGHT)
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
	
	if (check_falling() and !isAttacking and !isTakingDamage):
		animationPlayer.play("Falling")
	
	# EXECUTE AND CALCUALTE NEW VELOCITY
	._physics_process(delta)

func _clean_on_death():
	$Sprite/HitBox.queue_free()
	$Sprite/HurtBox.queue_free()
	$Body.queue_free()
	
func anim_walk():
	if (animationPlayer.current_animation != "Walk" and is_on_floor()):
		animationPlayer.play("Walk")

func _start():
	show()
	set_physics_process(true)
	$Camera2D.current = true
	pass

func take_damage(damage: int, attackerPosition: Vector2) -> void:
	player_vars.player_take_damage(damage)
	.take_damage(damage, attackerPosition)

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if (anim_name.findn("attack") != -1):
		isAttacking = false
	if (anim_name == "Death"):
		$PlayerSounds.queue_free()
