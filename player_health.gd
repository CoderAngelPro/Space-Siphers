extends CharacterBody2D

signal health_changed(current_health: int, maximum_health: int)
signal died

@export_range(1, 10000) var max_health: int = 100

var health: int
var is_dead: bool = false


func _ready() -> void:
	health = max_health
	health_changed.emit(health, max_health)
	
	# These 3 lines are for testing purposes, remove later.
	#take_damage(25)
	#heal(10)
	#take_damage(85)


func take_damage(amount: int) -> void:
	if is_dead or amount <= 0:
		return

	health = maxi(health - amount, 0)
	print("Health: ", health, "/", max_health)
	health_changed.emit(health, max_health)

	if health == 0:
		die()


func heal(amount: int) -> void:
	if is_dead or amount <= 0:
		return

	health = mini(health + amount, max_health)
	print("Health: ", health, "/", max_health)
	health_changed.emit(health, max_health)


func die() -> void:
	is_dead = true
	print("Player died!")
	died.emit()
