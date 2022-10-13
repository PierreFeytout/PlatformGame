extends Node

const DEFAULT_PLAYER_HEALTH := 100

signal health_changed
onready var player_health = DEFAULT_PLAYER_HEALTH

func _ready():
	pass

func player_take_damage(damage: int):
	player_health -= damage
	emit_signal("health_changed")

func reset():
	player_health = DEFAULT_PLAYER_HEALTH
	emit_signal("health_changed")
