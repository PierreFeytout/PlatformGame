extends "res://Scenes/Mobs/Mob.gd"
var projectile_resource = preload("res://Scenes/Projectile.tscn")

func _ready():
	pass

func custom_attack():
	if (current_action == action.ATTACK):
		isAttacking = true
		velocity.x = 0
		animationPlayer.play("Attack")

func create_projectiles(count: int):
	var dir_mult = 1 if current_dir == dir_enum.RIGHT else -1
	var projectile_instance = projectile_resource.instance()
	get_parent().add_child(projectile_instance)
	projectile_instance.global_position.y = self.global_position.y
	projectile_instance.global_position.x = self.global_position.x + (80 * self.scale.x * dir_mult)
	projectile_instance.launch_diag(16, dir_mult, (detected_body.position - self.position).normalized().y)
