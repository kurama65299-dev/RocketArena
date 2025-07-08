extends Button

@onready var main_menu: CanvasLayer = get_node("/root/MainMenu")

func _on_button_down() -> void:
	main_menu.current_panel = "LOBBY"
	main_menu.update_panel_visibility()
