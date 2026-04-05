extends StaticNPC

func _ready():
	DataResource.connect("dialog_over", Callable(self, "_on_dialog_processed"))

func interact(body):
	SceneControl.change_and_start_dialog(name) # else his anvil will also rotate

func _on_dialog_processed():
	emit_signal("new_gui", "shop")
