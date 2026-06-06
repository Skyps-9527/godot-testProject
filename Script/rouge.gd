extends CanvasLayer

signal upgrade_selected(event: EventResource)

var card_nodes: Array[NinePatchRect] = []
var current_events: Array[EventResource] = []

func _ready() -> void:
	card_nodes = [
		$UpgradeUI/CenterContainer/HBoxContainer/UpgradeCard/NinePatchRect,
		$UpgradeUI/CenterContainer/HBoxContainer/UpgradeCard/NinePatchRect2,
		$UpgradeUI/CenterContainer/HBoxContainer/UpgradeCard/NinePatchRect3,
	]
	for i in card_nodes.size():
		card_nodes[i].mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		for child in card_nodes[i].get_children():
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	# 暂停时也接收 input
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_panel(events: Array[EventResource]) -> void:
	current_events = events
	for i in events.size():
		card_nodes[i].get_node("Label").text = events[i].event_name + "\n" + events[i].description
		if events[i].event_icon and card_nodes[i].has_node("TextureRect"):
			var tex_rect: TextureRect = card_nodes[i].get_node("TextureRect")
			tex_rect.texture = events[i].event_icon
			tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		card_nodes[i].visible = true
	for i in range(events.size(), card_nodes.size()):
		card_nodes[i].visible = false
	visible = true
	get_tree().paused = true
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for i in current_events.size():
			if card_nodes[i].get_global_rect().has_point(event.position):
				upgrade_selected.emit(current_events[i])
				visible = false
				get_tree().paused = false
				set_process_input(false)
				break
