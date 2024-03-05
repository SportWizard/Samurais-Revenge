extends Node2D

onready var animated_sprite = $AnimatedSprite

func _on_Hurtbox_area_entered(area):
	animated_sprite.play("Animation")

func _on_AnimatedSprite_animation_finished():
	animated_sprite.stop()
