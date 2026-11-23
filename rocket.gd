extends Area2D

@export var speed: float = 350.0
@export var lifetime: float = 4.0
@export var splash_radius: float = 120.0

# Assigned by the weapon when the rocket spawns.
var damage: int = 0

var age: float = 0.0
var has_exploded: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if has_exploded:
		return

	var direction := Vector2.RIGHT.rotated(global_rotation)
	global_position += direction * speed * delta

	age += delta

	if age >= lifetime:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if has_exploded:
		return

	if body.is_in_group("enemies"):
		explode()


func explode() -> void:
	if has_exploded:
		return

	has_exploded = true

	# Find enemies whose centers are inside the explosion radius.
	for node in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(node):
			continue

		if node.is_queued_for_deletion():
			continue

		var enemy := node as Node2D

		if enemy == null:
			continue

		var distance := global_position.distance_to(
			enemy.global_position
		)

		if distance <= splash_radius:
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage)

	# Show a temporary explosion circle before removing the rocket.
	set_deferred("monitoring", false)
	queue_redraw()

	await get_tree().create_timer(0.15).timeout
	queue_free()


func _draw() -> void:
	if has_exploded:
		draw_circle(
			Vector2.ZERO,
			splash_radius,
			Color(1.0, 0.5, 0.0, 0.3)
		)
	else:
		draw_rect(
			Rect2(-8.0, -3.0, 16.0, 6.0),
			Color.ORANGE
		)
