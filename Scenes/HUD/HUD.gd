extends CanvasLayer
onready var player_vars := get_node("/root/PlayerVariables") as PlayerVariables


func _ready():
	$TextureProgress.max_value = player_vars.player_health
	$TextureProgress.value = player_vars.player_health
	player_vars.connect("health_changed", self, "on_health_changed")
	pass

func on_health_changed():
	$TextureProgress.value = player_vars.player_health	
