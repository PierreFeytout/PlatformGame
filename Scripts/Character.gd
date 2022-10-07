class_name Character
extends KinematicBody2D

# EXPORTED PROPERTIES
export(float) var GRAVITY := 600.0
export(float) var WALK_SPEED := 100.0
export(float) var JUMP_FORCE := 300.0

# PRIVATE FIELDS
var velocity:= Vector2(0,0)
var snap:= Vector2(0,32)
var isJumping := false
var isAttacking = false

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

func handle_jump():
	if (isJumping):
		snap = Vector2()
	else:
		snap = Vector2(0,32)

func check_falling() -> bool:
	if (!is_on_floor() and velocity.y > 0):
		isJumping = false
		return true
	else:
		return false

func flip_sprite(direction : int) -> void:
	sprite.scale.x = -1 if direction == dir_enum.LEFT else 1
