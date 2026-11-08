extends Node2D

@export var bullet_scene: PackedScene
@export var damage: int = 50
@export var attack_range: float = 600.0
@export_range(0.05, 10.0) var fire_interval: float = 0.3

@onready var muzzle: Marker2D = $Muzzle2D

var cooldown: float = 0.0


#func _physics_process(delta: float) -> void:
	#cooldown = maxf(cooldown - delta, 0.0)

	#var target := find_nearest_enemy()

	#if target == null:
		#return

	#if global_position.distance_squared_to(target.global_position) < 0.001:
		#return

	#look_at(target.global_position)

	#if cooldown <= 0.0 and bullet_scene != null:
		#shoot()
		#cooldown = fire_interval

func _physics_process(delta: float) -> void:
	cooldown = maxf(cooldown - delta, 0.0)

	var target := find_nearest_enemy()

	# Print occasionally instead of every physics tick.
	if Engine.get_physics_frames() % 60 == 0:
		print(
			"Enemies: ",
			get_tree().get_nodes_in_group("enemies").size(),
			" | Target: ",
			target,
			" | Bullet assigned: ",
			bullet_scene != null
		)

	if target == null:
		return

	if global_position.distance_squared_to(target.global_position) < 0.001:
		return

	look_at(target.global_position)

	if cooldown <= 0.0 and bullet_scene != null:
		print("Attempting to fire")
		shoot()
		cooldown = fire_interval

func find_nearest_enemy() -> Node2D:
	var closest: Node2D = null
	var closest_distance := attack_range * attack_range

	for node in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(node):
			continue

		if node.is_queued_for_deletion():
			continue

		var enemy := node as Node2D

		if enemy == null:
			continue

		var distance := global_position.distance_squared_to(
			enemy.global_position
		)

		if distance < closest_distance:
			closest = enemy
			closest_distance = distance

	return closest


func shoot() -> void:
	print("Turret fired")
	
	var bullet := bullet_scene.instantiate() as Area2D
	bullet.set("damage", damage)

	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = global_rotation

func _ready() -> void:
	print("Turret loaded: ", get_path())
	print("Bullet scene assigned: ", bullet_scene != null)
