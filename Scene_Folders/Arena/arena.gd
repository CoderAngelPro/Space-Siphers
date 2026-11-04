extends Node2D

@onready var background: ColorRect = $Background


func _ready() -> void:
	var top_left := background.position
	var bottom_right := top_left + background.size

	add_wall(Vector2.RIGHT, top_left)   
	add_wall(Vector2.LEFT, bottom_right) 
	add_wall(Vector2.DOWN, top_left)  
	add_wall(Vector2.UP, bottom_right) 


func add_wall(inward_normal: Vector2, edge_position: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = edge_position
	wall.collision_layer = 1

	var boundary := WorldBoundaryShape2D.new()
	boundary.normal = inward_normal

	var collision := CollisionShape2D.new()
	collision.shape = boundary
	wall.add_child(collision)
	add_child(wall)