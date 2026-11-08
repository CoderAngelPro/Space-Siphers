extends Area2D

@export var speed: float = 700.0
@export var lifetime: float = 2.0

var damage: int = 50
var age: float = 0.0
var has_hit: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if has_hit:
		return

	var direction := Vector2.RIGHT.rotated(global_rotation)
	global_position += direction * speed * delta

	age += delta

	if age >= lifetime:
		queue_free()


#func _on_body_entered(body: Node2D) -> void:
	#if has_hit or not body.is_in_group("enemies"):
		#return

	#has_hit = true

	#if body.has_method("take_damage"):
		#body.take_damage(damage)

	#queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	print("Bullet touched: ", body.name)
	print("In enemies group: ", body.is_in_group("enemies"))
	print("Has take_damage: ", body.has_method("take_damage"))

	if has_hit or not body.is_in_group("enemies"):
		return

	has_hit = true

	if body.has_method("take_damage"):
		print("Applying damage: ", damage)
		body.take_damage(damage)

	queue_free()

#Temporary bullet sprite, remove later
func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color.YELLOW)
