extends Node2D

@export var slime_scene : PackedScene
@export var orc_scene : PackedScene
@export var spawn_timer : Timer
@export var orc_spawn_time : Timer
@export var score : int = 0
@export var skill_score: int = 0
var next_rouge_threshold: int = 10
var rouge_step: int = 10
@export var score_label : Label
@export var game_over_label: Label
@export var pause_button: TextureButton
@export var play_button: TextureButton
@onready var Rouge = get_node("Rouge")
var all_events: Array[EventResource] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_all_events()
	Rouge.upgrade_selected.connect(_on_upgrade_selected)
	
func load_all_events():
	var dir = DirAccess.open("res://Event")
	if not dir:
		print("找不到 Event 文件夹")
		return
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".tres"):
			var event = load("res://Event/" + file)
			if event:
				all_events.append(event)
	dir.list_dir_end()
	print("已加载 ", all_events.size(), " 个事件")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time -= 0.2 * delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time, 1, 3)
	
	score_label.text = "Score: " + str(score)

# 对应SlimeTimer
func _spawn_slime() -> void:
	var slime_node = slime_scene.instantiate()
	slime_node.position = Vector2(260, randf_range(50, 115))
	get_tree().current_scene.add_child(slime_node)

# 
func _on_orc_timer_timeout() -> void:
	if score > 20:
		var orc_node = orc_scene.instantiate()
		orc_node.position = Vector2(260, randf_range(50, 115))
		get_tree().current_scene.add_child(orc_node)
		


func trigger_rouge() -> void:
	rouge_step += 10
	next_rouge_threshold += rouge_step
	var available = all_events.duplicate()
	available.shuffle()
	var selected: Array[EventResource] = []
	for i in min(3, available.size()):
		selected.append(available[i])
	Rouge.show_panel(selected)


func _on_upgrade_selected(event: EventResource) -> void:
	var player = get_node("Player")
	match event.stat_name:
		"speed":
			player.move_speed += event.stat_value
		"bullet":
			player.bullet_count += event.stat_value
		"roll_speed":
			player.roll_speed += event.stat_value


func show_game_over():
	game_over_label.visible = true


func _on_pause_button_pressed() -> void:
	pause_button.focus_mode = Control.FOCUS_NONE
	pause_button.hide()
	play_button.show()
	get_tree().paused = true


func _on_play_button_pressed() -> void:
	play_button.focus_mode = Control.FOCUS_NONE
	pause_button.show()
	play_button.hide()
	get_tree().paused = false
