extends CharacterBody2D

@onready var weapons: Node2D = $Weapons2D

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var player_collision_box: CollisionPolygon2D = $CollisionPolygon2D
@onready var player_normal_color: Color = player_sprite.self_modulate
var hit_flash_tween: Tween

var player_max_health: int = 100
var player_move_speed: float = 200.0
var player_atk_cld: float = 2.0
var player_dmg: int = 50

var spawn_location: Vector2
var player_current_health: int
var player_atk_timer: float
var goopy_slow_time_left: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_current_health = player_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction:= Vector2.ZERO
	
	input_direction.x = Input.get_axis("player_move_left", "player_move_right")
	input_direction.y = Input.get_axis("player_move_up", "player_move_down")
	input_direction = input_direction.normalized()
	
	# Repeated Goopy hits refresh the three-second slowdown.
	if goopy_slow_time_left > 0.0:
		player_move_speed = 100.0
	else:
		player_move_speed = 200.0
	goopy_slow_time_left = maxf(goopy_slow_time_left - delta, 0.0)
	velocity = input_direction * player_move_speed
	move_and_slide()
	
	if velocity.length_squared() > 0.0:
		rotation = velocity.angle()

func take_damage(amount: int) -> void:
	if player_current_health <= 0 or amount <= 0:
		return

	player_current_health = maxi(player_current_health - amount, 0)

	if player_current_health == 0:
		player_sprite.hide()
		player_collision_box.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		set_physics_process(false)
		set_process_unhandled_input(false)

		weapons.process_mode = Node.PROCESS_MODE_DISABLED
		return
	flash_hit()
	
func goopy_slowdown_effect() -> void:
	goopy_slow_time_left = 3.0

func flash_hit() -> void:

	# Stops the previous flash if another hit arrives.
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	player_sprite.self_modulate = Color.RED

	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(
		player_sprite,
		"self_modulate",
		player_normal_color,
		0.15
	)	
	
func add_weapon(weapon_scene: PackedScene) -> void:
	if weapon_scene == null:
		return

	var weapon := weapon_scene.instantiate()
	weapons.add_child(weapon)
