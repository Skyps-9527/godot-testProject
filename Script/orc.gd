extends Area2D

@export var orc_speed : float = -100
@export var orc_health : int = 2
@export var hit_stun_time: float = 0.25   # 受击停顿时间

var is_hit: bool = false
var is_dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if is_dead or is_hit:
		return

	position += Vector2(orc_speed, 0) * delta

	if position.x < -260:
		queue_free()
		

func _on_area_entered(area: Area2D) -> void:
	if is_dead:
		return

	if area.is_in_group("bullet"):
		orc_health -= 1
		area.queue_free()

		if orc_health <= 0:
			die()
		else:
			hit()
			
func die():
	is_dead = true
	$AnimatedSprite2D.play("die")
	get_tree().current_scene.score += 2
	get_tree().current_scene.skill_score += 2
		
	if(get_tree().current_scene.skill_score >= 10):
		get_tree().current_scene.skill_score -= 10
		get_tree().current_scene.Rouge.visible = true

	await get_tree().create_timer(0.6).timeout
	queue_free()

func hit():
	is_hit = true
	$AnimatedSprite2D.play("hit")

	await get_tree().create_timer(hit_stun_time).timeout

	is_hit = false
	$AnimatedSprite2D.play("walk")

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_dead:
		body.game_over()
