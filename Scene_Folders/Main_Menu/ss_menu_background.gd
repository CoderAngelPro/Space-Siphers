@tool
extends Control


func _ready() -> void:
	resized.connect(queue_redraw)
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("080e20"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 2407
	for index in range(180):
		var point := Vector2(rng.randf() * size.x, rng.randf() * size.y)
		var tint := Color("a8d9ec")
		tint.a = rng.randf_range(0.15, 0.65)
		draw_circle(point, rng.randf_range(0.6, 1.7), tint)
		if index % 19 == 0:
			draw_line(point - Vector2(4, 0), point + Vector2(4, 0), tint, 1.0)
			draw_line(point - Vector2(0, 4), point + Vector2(0, 4), tint, 1.0)
	var orbit_center := size * Vector2(0.83, 0.35)
	for radius in [180.0, 225.0, 330.0]:
		draw_arc(orbit_center, radius, 0.0, TAU, 160, Color(0.20, 0.64, 0.74, 0.12), 1.0, true)
	draw_circle(orbit_center + Vector2(-135, 119), 5.0, Color("79d9da"))
