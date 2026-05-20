extends CharacterBody2D


@export var move_speed : float = 50
@export var animator : AnimatedSprite2D
@export var roll_speed : float = 250.0
@export var roll_duration : float = 0.15
var is_rolling := false
var roll_dir := Vector2.ZERO
var roll_time := 0.0

var is_game_over : bool = false
var bullet_count: int = 1

@export var bullet_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#velocity = Vector2(50, 0)
	pass
	
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_game_over:
		return

	# ===== 翻滚状态 =====
	if is_rolling:
		velocity = roll_dir * roll_speed
		roll_time -= delta

		if animator.animation != "roll":
			animator.play("roll")

		if roll_time <= 0:
			is_rolling = false

		move_and_slide()
		return   # ⭐⭐⭐ 关键
	
	# ===== 普通移动 =====
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_dir * move_speed

	if Input.is_action_just_pressed("Roll") and input_dir != Vector2.ZERO:
		start_roll(input_dir)
		return

	if velocity == Vector2.ZERO:
		if animator.animation != "idle":
			animator.play("idle")
	else:
		if animator.animation != "run":
			animator.play("run")

	move_and_slide()
	
func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("game_over")
		
		get_tree().current_scene.show_game_over()
		
		$GameOverSound.play()
		$RestartTimer.start()


func _on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:
		return

	$FireSound.play()

	var spread = (bullet_count - 1) * 6.0
	for i in range(bullet_count):
		var bullet_node = bullet_scene.instantiate()
		var y_offset = -spread / 2.0 + i * 6.0 if bullet_count > 1 else 0.0
		bullet_node.position = position + Vector2(6, 6 + y_offset)
		get_tree().current_scene.add_child(bullet_node)
	
func start_roll(dir: Vector2):
	is_rolling = true
	roll_dir = dir.normalized()
	roll_time = roll_duration
	animator.play("roll")

func _on_reload_scene() -> void:
	get_tree().reload_current_scene()
