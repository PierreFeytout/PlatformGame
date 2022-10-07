class_name Character
extends KinematicBody2D

# EXPORTED PROPERTIES
export(int) var HEALTH := 100
export(float) var GRAVITY := 600.0
export(float) var WALK_SPEED := 100.0
export(float) var JUMP_FORCE := 300.0
export(float) var RECOVERY_TIME := 1.0
export(float) var KNOCK_BACK_VELOCITY := 500
var recover_timer

# PRIVATE FIELDS
var velocity:= Vector2(0,0)
var snap:= Vector2(0,32)
var isJumping := false
var isAttacking = false
var isTakingDamage = false;

# REQUIRED CHILD NODES
var sprite : Sprite;
var animationPlayer : AnimationPlayer
var current_action : int = action.IDLE

# ENUMARATIONS
enum dir_enum { LEFT, RIGHT }
enum action { IDLE, MOVE_LEFT, MOVE_RIGHT, JUMP, ATTACK}

func _ready():
	pass
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)

func handle_movement_actions() -> void:
	if (current_action == action.MOVE_LEFT):
		velocity.x = -WALK_SPEED
		_anim_walk()
		flip_sprite(dir_enum.LEFT)
	elif (current_action == action.MOVE_RIGHT):
		velocity.x = WALK_SPEED
		_anim_walk()
		flip_sprite(dir_enum.RIGHT)
	elif (current_action == action.IDLE):
		velocity.x = 0
		velocity.x = lerp(velocity.x, 0, 0.1)
		if (is_on_floor()):
			animationPlayer.play("Idle")



func _anim_walk():
	if (self.has_method("anim_walk")):
		self.call("anim_walk")
	pass

func check_falling() -> bool:
	if (!is_on_floor() and velocity.y > 0):
		isJumping = false
		return true
	else:
		return false
func take_damage(damage: int, attackerPosition: Vector2) -> void:
	animationPlayer.play("Hurt")
	isTakingDamage = true
	HEALTH -= damage
	if (HEALTH <= 0):
		die()
	else:
		calculate_knockback_velocity(get_relative_direction(attackerPosition))
		launch_recover_timer()

func die():
	animationPlayer.play("Death")
	set_physics_process(false)

func launch_recover_timer():
	recover_timer = get_tree().create_timer(RECOVERY_TIME)
	recover_timer.connect("timeout", self, "on_recover_timeout")
	
func on_recover_timeout():
	print("recover timeout")
	isTakingDamage = false

func flip_sprite(direction : int) -> void:
	sprite.scale.x = -1 if direction == dir_enum.LEFT else 1

func stop_knockback_velocity(delta: float):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	velocity.x = lerp(velocity.x, 0, 0.1)

func get_relative_direction(position: Vector2) -> int:
	return dir_enum.LEFT if position.x < self.global_position.x else dir_enum.RIGHT

func calculate_knockback_velocity(direction: int):
	velocity.x = lerp(velocity.x, KNOCK_BACK_VELOCITY if direction == dir_enum.LEFT else -KNOCK_BACK_VELOCITY, 0.5)
