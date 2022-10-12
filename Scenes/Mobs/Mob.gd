extends Character
var detected_body: KinematicBody2D = null
var is_player_detected = false
var default_modulate_color: Color
var detect_modulate_color: Color
export(float) var detector_dead_zone = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	sprite = get_node("Sprite")
	animationPlayer = get_node("AnimationPlayer")
	default_modulate_color = Color($Detector.modulate)
	detect_modulate_color = Color($Detector.modulate)
	detect_modulate_color.r = detect_modulate_color.r - 20
	detect_modulate_color.g = detect_modulate_color.g - 20
	detect_modulate_color.b = detect_modulate_color.b - 20
	pass # Replace with function body.

func _physics_process(delta):
	execute_ia()
	handle_attack()
	._physics_process(delta)

func execute_ia():
	if (isAttacking or isTakingDamage):
		return
	if (is_player_detected):
		if (is_in_dead_zone()):
			current_action = action.ATTACK
		else:
			if(get_relative_direction(detected_body.global_position) == dir_enum.LEFT):
				current_action = action.MOVE_LEFT
			elif (get_relative_direction(detected_body.global_position) == dir_enum.RIGHT):
				current_action = action.MOVE_RIGHT
	else:
		current_action = action.IDLE

func _clean_on_death():
	$Detector.queue_free()
	$Sprite/HitBox.queue_free()
	$HurtBox.queue_free()
	$CollisionShape2D.queue_free()

func handle_attack():
	if (current_action == action.ATTACK):
		isAttacking = true
		velocity.x = 0
		animationPlayer.play("Attack")

func anim_walk():
	if (animationPlayer.current_animation != "Walk" and is_on_floor()):
		animationPlayer.play("Walk")

func is_in_dead_zone() -> bool:
	return abs(self.global_position.x - detected_body.position.x) < detector_dead_zone

func _on_Detector_body_entered(body: KinematicBody2D):
	is_player_detected = true
	detected_body = body
	$Detector.modulate = detect_modulate_color

func _on_Detector_body_exited(area):
	is_player_detected = false
	$Detector.modulate = default_modulate_color

#func take_damage(damage: int, attackerPosition: Vector2) -> void:
#	.take_damage(damage, attackerPosition)
#	$Sprite/HitBox/CollisionShape2D.set_deferred("disabled", true)

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if (anim_name.findn("attack") != -1):
		isAttacking = false
