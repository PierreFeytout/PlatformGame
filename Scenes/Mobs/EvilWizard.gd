extends "res://Scenes/Mobs/Mob.gd"
var projectile_resource = preload("res://Scenes/Projectile.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	pass

func custom_attack():
	if (current_action == action.ATTACK):
		isAttacking = true
		velocity.x = 0
		animationPlayer.play("Attack")

func create_projectiles(count: int):
	var projectile_array : Array
	for n in count:
		projectile_array.append(projectile_resource.instance())

	for p in projectile_array:
		get_parent().add_child(p)
		p.global_position.y = self.global_position.y + rng.randi_range(-20,20)
		p.global_position.x = self.global_position.x
		p.launch(16)
