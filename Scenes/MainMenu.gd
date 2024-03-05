extends Node2D

onready var fade_to_normal = $FadeToNormal
onready var title = $Title
onready var campaign_boarder = $Campaign/CampaignBoarder
onready var controller_boarder = $Controll/ControllBoarder
onready var campaign_fade_to_black = $Campaign/CampaignFadeToBlack
onready var controller_fade_to_black = $Controll/ControllFadeToBlack

enum {
	campaign,
	controll
}

var selected = campaign

func _ready():
	title.frame = 0
	fade_to_normal.play("FadeToNormal")

func _on_FadeToNormal_animation_finished(anim_name):
	title.play()

func _process(delta):
	match selected:
		campaign:
			campaign_boarder.play("Fader")
			controller_boarder.stop()
			if Input.is_action_just_pressed("ui_accept"):
				campaign_fade_to_black.play("CampaignFadeToBlack")
			elif Input.is_action_just_pressed("ui_down"):
				selected = controll
		controll:
			controller_boarder.play("Fader")
			campaign_boarder.stop()
			if Input.is_action_just_pressed("ui_accept"):
				controller_fade_to_black.play("ControllFadeToBlack")
			elif Input.is_action_just_pressed("ui_up"):
				selected = campaign

func _on_campaignFadeToBlack_animation_finished(CampaignFadeToBlack):
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_ControllFadeToBlack_animation_finished(ControllerFadeToBlack):
	get_tree().change_scene("res://Scenes/ControllDisplay.tscn")
