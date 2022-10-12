class_name HitBox
extends Area2D

export var Damage = 10

func _ready():
	pass

func disable():
	$CollisionShape2D.set_deferred("disabled", true)
