# script: utils

extends Node

var view_size setget , _get_view_size

func _get_view_size():
	return get_tree().get_root().get_visible_rect().size
	pass

