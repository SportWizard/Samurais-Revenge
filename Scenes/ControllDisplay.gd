extends Node2D

onready var fade_to_normal = $FadeToNormal
onready var fade_to_black = $FadeToBlack
onready var controller_display = $Controller
onready var keyboard_display = $KeyBoard
onready var L2LT = $L2LT
onready var R2RT = $R2RT
onready var q = $Q
onready var e = $E
onready var controller_text = $ControllerText
onready var keyboard_text = $KeyboardText
onready var timer = $Timer

var controll = controller
var use_controller = false

enum {
	controller,
	keyboard
}

func _ready():
	timer.start(0.5)

func _process(delta):
	if use_controller:
		match controll:
			controller:
				keyboard_display.visible = false
				controller_display.visible = true
				keyboard_text.visible = true
				L2LT.visible = false
				R2RT.visible = true
				e.visible = false
				q.visible = false
				controller_text.visible = false
			keyboard:
				controller_display.visible = false
				keyboard_display.visible = true
				controller_text.visible = true
				L2LT.visible = true
				R2RT.visible = false
				q.visible = false
				e.visible = false
				keyboard_text.visible = false
	else:
		match controll:
			controller:
				keyboard_display.visible = false
				controller_display.visible = true
				keyboard_text.visible = true
				L2LT.visible = false
				R2RT.visible = false
				e.visible = true
				q.visible = false
				controller_text.visible = false
			keyboard:
				controller_display.visible = false
				keyboard_display.visible = true
				controller_text.visible = true
				L2LT.visible = false
				R2RT.visible = false
				q.visible = true
				e.visible = false
				keyboard_text.visible = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		fade_to_black.play("FadeToBlack")
	if Input.is_action_just_pressed("next_tab") and controll == controller:
		controll = keyboard
	if Input.is_action_just_pressed("previous_tab") and controll == keyboard:
		controll = controller

func _on_Timer_timeout():
	if use_controller == true:
		controll = controller
	else:
		controll = keyboard
	
	fade_to_normal.play("FadeToNormal")

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		use_controller = true
	else:
		use_controller = false

func _on_FadeToBlack_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
