extends HitBox

export(float) var LIFE_TIME = 4.5
export(float) var SPEED = 100

var life_timer

func _init():
	set_physics_process(false)
	hide()

func _ready():
	pass

func launch(c_mask):
	collision_mask = c_mask
	set_physics_process(true)
	show()
	life_timer = get_tree().create_timer(LIFE_TIME)
	life_timer.connect("timeout", self, "on_lifetime_timeout")

func on_lifetime_timeout():
	queue_free()

func _physics_process(delta):
	translate(Vector2(SPEED * delta, 0))
	pass


func _on_Projectile_area_entered(area):
	queue_free()
	pass # Replace with function body.


func _on_Projectile_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	queue_free()
	pass # Replace with function body.


func _on_Projectile_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()
	pass # Replace with function body.


func _on_Projectile_body_entered(body):
	queue_free()
	pass # Replace with function body.
