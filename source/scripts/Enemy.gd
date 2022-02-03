extends RigidBody2D


export var min_speed := 150
export var max_speed := 250

const anim_list = ["fly","swim","walk"]

onready var anim = get_node("animation")

func _ready():
	anim.animation = anim_list[randi() % anim_list.size()]
	anim.play()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
