extends Node2D


onready var particle_1 := $particle_1
onready var particle_2 := $particle_2
onready var screen_size := get_viewport_rect().size


func _process(delta):
	screen_size = get_viewport_rect().size
	particle_1.emission_rect_extents = screen_size
	particle_2.emission_rect_extents = screen_size
