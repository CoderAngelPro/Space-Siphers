extends CharacterBody2D

const GOOPY_MAX_HEALTH: int = 100
const GOOPY_MOVE_SPEED: float = 120.0
const GOOPY_ATK_CLD: float = 1.0

@onready var goopy_damage_area: Area2D = $"DamageArea (Area2D)"
@onready var goopy_sprite: Sprite2D = $Sprite2D
@onready var goopy_normal_color: Color = goopy_sprite.self_modulate
var hit_flash_tween: Tween

var spawn_position: Vector2
var spawn_min: Vector2 = Vector2(-1000, -600)
var spawn_max: Vector2 = Vector2(1000, 600)

var goopy_current_health: int
var goopy_atk_timer: float = 0.0
var player_node: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goopy_current_health = GOOPY_MAX_HEALTH
	player_node = get_node("../../SS_Player_Node") as CharacterBody2D

	spawn_position = Vector2(
		randf_range(spawn_min.x, spawn_max.x),
		randf_range(spawn_min.y, spawn_max.y)
	)

	global_position = spawn_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	goopy_atk_timer = maxf(goopy_atk_timer - delta, 0.0)
	
	if player_node == null or not is_instance_valid(player_node):
		velocity = Vector2.ZERO
		return
		
	# Flips sprite based on player x-axis position
	if player_node.global_position.x < global_position.x:
		goopy_sprite.flip_h = true
	elif player_node.global_position.x > global_position.x:
		goopy_sprite.flip_h = false
	
	# moves goopy to player
	var direction:= global_position.direction_to(player_node.global_position)
	velocity = direction * GOOPY_MOVE_SPEED
	move_and_slide()
	
	# tries to attack player once colliding with them
	if goopy_damage_area.overlaps_body(player_node):
		_try_attack()

func _try_attack() -> void:
	if goopy_atk_timer > 0.0:
		return
	
	if player_node.has_method("goopy_slowdown_effect"):
		player_node.goopy_slowdown_effect()
		goopy_atk_timer = GOOPY_ATK_CLD
		take_damage(100)
		
func take_damage(amount: int) -> void:
	goopy_current_health -= amount
	if goopy_current_health <= 0:
		queue_free()
		return
		
	flash_hit()
		
func flash_hit() -> void:
	# Stop the previous flash if another hit arrives.
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	goopy_sprite.self_modulate = Color.RED

	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(
		goopy_sprite,
		"self_modulate",
		goopy_normal_color,
		0.15
	)

# Only use to test take_damage()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_enemy_damage") and not event.is_echo():
		take_damage(10)
		print("Goopy health: ", goopy_current_health)
	
