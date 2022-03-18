extends Area2D

signal hit

const PLAYER_WIDTH  := 27 
const PLAYER_HEIGHT := 34

onready var anim        := get_node("animation")
onready var screen_size := get_viewport_rect().size
onready var trail := get_node("Trail")

var target = Vector2()

export var speed := 400 

func _ready():
	hide()
	target = Vector2(screen_size.x / 2,screen_size.y/2)
	position = Vector2(screen_size.x / 2,screen_size.y/2)
	trail.emitting = false
	


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
		

func _process(delta):
	screen_size = get_viewport_rect().size
	var velocity := Vector2.ZERO
	if position.distance_to(target) > 10:
		velocity = target - position
		
	# if Input.is_action_pressed("ui_right"):
	#     velocity.x += 1
	# if Input.is_action_pressed("ui_left"):
	#     velocity.x -= 1
	# if Input.is_action_pressed("ui_up"):
	#     velocity.y -= 1
	# if Input.is_action_pressed("ui_down"):
	#     velocity.y += 1

	# if velocity.x != 0:
	#     anim.animation = "walk"
	#     anim.flip_v = false
	#     anim.flip_h = velocity.x < 0 
	# elif velocity.y != 0:
	#     anim.animation = "fly"
	#     anim.flip_h = false
	#     anim.flip_v = velocity.y > 0

	if velocity.length() != 0:
		if abs(velocity.x) > abs(velocity.y):
			anim.animation = "walk"
			anim.flip_v = false
			anim.flip_h = velocity.x < 0
		elif abs(velocity.y) > abs(velocity.x):
			anim.animation = "fly"
			anim.flip_h = false
			anim.flip_v = velocity.y > 0 

	if velocity.length() != 0:
		velocity = velocity.normalized() * speed
		anim.play()
		trail.emitting = true
	else:
		anim.stop()
		trail.emitting = false

	position.x = clamp(position.x,PLAYER_WIDTH, screen_size.x - PLAYER_WIDTH)
	position.y = clamp(position.y , PLAYER_HEIGHT, screen_size.y - PLAYER_HEIGHT)
	position += velocity * delta


	

func start(pos):
	position = pos
	show()
	$collision_shape.disabled = false


func _on_Player_body_entered(_body:Node):

	hide()
	emit_signal("hit")
	$collision_shape.set_deferred("disabled",true)

