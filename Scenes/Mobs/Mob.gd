extends Character
var detected_body: KinematicBody2D = null
var is_player_detected = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	pass # Replace with function body.

func _physics_process(delta):
	if (is_player_detected):
		if (detected_body.global_position.x < self.global_position.x and abs(detected_body.global_position.x - self.global_position.x) > 10):
			current_action = action.MOVE_LEFT
		elif (detected_body.global_position.x > self.global_position.x and abs(detected_body.global_position.x - self.global_position.x) > 10):
			current_action = action.MOVE_RIGHT
		else:
			current_action = action.IDLE
	else:
		current_action = action.IDLE

	handle_movement_actions()
	._physics_process(delta)

func anim_walk():
	if (animationPlayer.current_animation != "Walk" and is_on_floor()):
		animationPlayer.play("Walk")

func take_damage(damage: int) -> void:
	animationPlayer.play("Hurt")


func _on_Detector_body_entered(body: KinematicBody2D):
	is_player_detected = true
	detected_body = body


func _on_Detector_body_exited(area):
	is_player_detected = false
	detected_body = null
