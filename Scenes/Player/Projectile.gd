extends HitBox

export(float) var MAX_DIST = 800
export(float) var SPEED = 100
var direction = 1
var init_position_x
var y_vect = 0

func _init():
	set_physics_process(false)
	hide()

func _ready():
	pass

func launch_diag(c_mask:int, dir: int, y: float):
	y_vect = y
	launch(c_mask, dir)

func launch(c_mask, dir: int):
	init_position_x = global_position.x
	direction = dir
	collision_mask = c_mask
	set_physics_process(true)
	show()

func _physics_process(delta):
	translate(Vector2(SPEED * delta * direction, y_vect))
	if (abs(global_position.x - init_position_x) >= MAX_DIST):
		queue_free()
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
