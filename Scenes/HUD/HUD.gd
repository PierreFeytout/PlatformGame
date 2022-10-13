extends CanvasLayer

func _ready():
	$TextureProgress.max_value = PlayerVariables.player_health
	$TextureProgress.value = PlayerVariables.player_health
	PlayerVariables.connect("health_changed", self, "on_health_changed")
	pass

func on_health_changed():
	$TextureProgress.value = PlayerVariables.player_health
