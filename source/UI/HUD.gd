extends CanvasLayer

signal start_game

onready var message = get_node("Message")
onready var button = get_node("Start_but")
onready var score_label = get_node("Score_label")

func show_messages(text):
	message.text = str(text)
	message.show()
	$Message_timer.start()

func show_game_over():
	show_messages("YOU DED!")
	yield($Message_timer,"timeout")
	message.text = "Dodge the\nCreeps!"
	message.show()
	yield(get_tree().create_timer(1), "timeout")
	button.show()

func update_score(score):
	score_label.text = str(score)
	
func _on_Start_but_pressed():
	button.hide()
	emit_signal("start_game")

func _on_Message_timer_timeout():
	message.hide()