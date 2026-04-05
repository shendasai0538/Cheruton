extends StaticNPC

func _ready():
	super._ready()
	$AnimationPlayer.play("sweep")
