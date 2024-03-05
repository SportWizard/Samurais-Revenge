extends Node2D

onready var timer = $Timer
onready var fade_to_normal = $FadeToNormal
onready var fade_to_black = $FadeToBlack

func _ready():
	fade_to_normal.play("FadeToNormal")

func _on_FadeToNormal_animation_finished(anim_name):
	timer.start(3)

func _on_Timer_timeout():
	fade_to_black.play("FadeToBlack")

func _on_FadeToBlack_animation_finished(FadeToBlack):
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
