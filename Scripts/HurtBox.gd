class_name HurtBox
extends Area2D

func _ready() -> void:
	connect("area_entered", self, "on_area_entered")

func on_area_entered(hitbox: HitBox) -> void:
	if (hitbox == null):
		return
#	if (owner.has_method("is_dead") and owner.is_dead()):
#		return
	if (owner.has_method("take_damage")):
		owner.take_damage(hitbox.Damage, hitbox.owner.global_position);
