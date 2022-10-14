class_name Character
extends KinematicBody2D

# EXPORTED PROPERTIES
export(int) var HEALTH = 100
export(float) var WALK_SPEED = 100.0
export(float) var RECOVERY_TIME = 1.0
export(float) var KNOCK_BACK_VELOCITY = 500
var recover_timer

var current_dir = dir_enum.RIGHT

export(float) var jump_height = 100
export(float) var jump_time_to_peak = 2
export(float) var jump_time_to_descent = 0.8

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func is_dead() -> bool:
	return HEALTH <= 0

# PRIVATE FIELDS
var velocity:= Vector2(0,0)
var snap:= Vector2(0,32)
var isJumping := false
var isAttacking = false
var isTakingDamage = false;

# REQUIRED CHILD NODES
var sprite : Sprite;
var main_body : CollisionShape2D;
var animationPlayer : AnimationPlayer
var current_action : int = action.IDLE

# CHILD NODES

# ENUMARATIONS
enum dir_enum { LEFT, RIGHT }
enum action { IDLE, MOVE_LEFT, MOVE_RIGHT, JUMP, ATTACK, JUMP_ATTACK}

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	pass

#func _process(delta):
#	if ()

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	
	if (!is_dead()):
		if (current_action == action.ATTACK):
			pass
		elif (isTakingDamage):
			stop_knockback_velocity(delta);
		else:
			handle_movement_actions()

	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func handle_movement_actions() -> void:
	if (current_action == action.MOVE_LEFT):
		velocity.x = -WALK_SPEED
		_anim_walk()
	elif (current_action == action.MOVE_RIGHT):
		velocity.x = WALK_SPEED
		_anim_walk()
	elif (current_action == action.IDLE):
		velocity.x = 0
		velocity.x = lerp(velocity.x, 0, 0.1)
		if (is_on_floor() and !isJumping):
			animationPlayer.play("Idle")



func _anim_walk():
	if (!is_on_floor() or isJumping):
		return
	if (self.has_method("anim_walk")):
		self.call("anim_walk")
	pass

func check_falling() -> bool:
	if (!is_on_floor() and velocity.y > 0):
		snap = Vector2(0,32)
		return true
	else:
		return false

func take_damage(damage: int, attackerPosition: Vector2) -> void:
	if (is_dead()):
		return
	HEALTH -= damage
	if (HEALTH <= 0):
		current_action = action.IDLE
		die()
	else:
		animationPlayer.stop()
		current_action = action.IDLE
		animationPlayer.play("Hurt")
		isTakingDamage = true
		isAttacking = false
		calculate_knockback_velocity(get_relative_direction(attackerPosition))
		launch_recover_timer()
	disable_hitbox()

func disable_hitbox():
	var hitbox = find_node("HitBox")
	if (hitbox != null):
		hitbox.disable()

func die():
	HEALTH = 0
	velocity.x = 0
	animationPlayer.stop()
	animationPlayer.play("Death")
	_clean_on_death()

func _clean_on_death():
	pass

func launch_recover_timer():
	recover_timer = get_tree().create_timer(RECOVERY_TIME)
	recover_timer.connect("timeout", self, "on_recover_timeout")
	
func on_recover_timeout():
	isTakingDamage = false

func flip_sprite(direction : int) -> void:
	current_dir = direction
	if (direction == dir_enum.LEFT):
		sprite.scale.x = abs(sprite.scale.x) * -1
		main_body.scale.x = abs(main_body.scale.x) * -1
	else:
		sprite.scale.x = abs(sprite.scale.x)
		main_body.scale.x = abs(main_body.scale.x)

func stop_knockback_velocity(delta: float):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	velocity.x = lerp(velocity.x, 0, 0.1)

func get_relative_direction(position: Vector2) -> int:
	return dir_enum.LEFT if position.x < self.global_position.x else dir_enum.RIGHT

func calculate_knockback_velocity(direction: int):
	velocity.x = lerp(velocity.x, KNOCK_BACK_VELOCITY if direction == dir_enum.LEFT else -KNOCK_BACK_VELOCITY, 0.5)
