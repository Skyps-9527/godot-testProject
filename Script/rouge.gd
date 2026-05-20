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
		card_nodes[i].gui_input.connect(_on_card_gui_input.bind(i))
	visible = false


func show_panel(events: Array[EventResource]) -> void:
	current_events = events
	for i in events.size():
		card_nodes[i].get_node("Label").text = events[i].event_name + "\n" + events[i].description
		card_nodes[i].visible = true
	for i in range(events.size(), card_nodes.size()):
		card_nodes[i].visible = false
	visible = true
	get_tree().paused = true


func _on_card_gui_input(event: InputEvent, card_index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if card_index < current_events.size():
			upgrade_selected.emit(current_events[card_index])
			visible = false
			get_tree().paused = false
