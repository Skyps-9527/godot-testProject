extends Node2D

@export var slime_scene : PackedScene
@export var orc_scene : PackedScene
@export var spawn_timer : Timer
@export var orc_spawn_time : Timer
@export var score : int = 0
@export var skill_score: int = 0
@export var score_label : Label
@export var game_over_label: Label
@export var pause_button: TextureButton
@export var play_button: TextureButton
@onready var Rouge = get_node("Rouge")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
