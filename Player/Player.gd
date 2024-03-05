extends KinematicBody2D

export var gravity = 1500
export var max_speed = 150
export var acceleration = 1000
export var friction = 1000
export var attack_forward = 25

enum {
	move,
	draw_left,
	draw_right,
	combat,
	retrieving,
	quick_cut_left,
	quick_cut_right,
	downward_cut_left,
	downward_cut_right,
	upward_cut_left,
	upward_cut_right,
	stab_left,
	stab_right,
	kick_left,
	kick_right
}

var state = move
var direction = "left"
var velocity = Vector2.ZERO
var time_started = false
var combo_points = 1

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var retrieve_timer = $RetrieveTimer
onready var combo_timer = $ComboTimer

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	velocity.y += gravity * delta
	move()
	
	match state:
		move:
			move_state(delta)
		draw_left:
			draw_left_state(delta)
		draw_right:
			draw_right_state(delta)
		combat:
			combat_state(delta)
		retrieving:
			retrieving_state(delta)
		quick_cut_left:
			quick_cut_left_state(delta)
		quick_cut_right:
			quick_cut_right_state(delta)
		downward_cut_left:
			downward_cut_left_state(delta)
		downward_cut_right:
			downward_cut_right_state(delta)
		upward_cut_left:
			upward_cut_left_state(delta)
		upward_cut_right:
			upward_cut_right_state(delta)
		stab_left:
			stab_left_state(delta)
		stab_right:
			stab_right_state(delta)
		kick_left:
			kick_left_state(delta)
		kick_right:
			kick_right_state(delta)

func animation(input_vector):
	animation_tree.set("parameters/Idle/blend_position", input_vector)
	animation_tree.set("parameters/Run/blend_position", input_vector)
	animation_tree.set("parameters/Combat/blend_position", input_vector)
	animation_tree.set("parameters/CombatRun/blend_position", input_vector)
	animation_tree.set("parameters/Retrieving/blend_position", input_vector)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation(input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if velocity.x < 0:
		direction = "left"
	elif velocity.x > 0:
		direction = "right"
	
	move()
	
	if direction == "left" and Input.is_action_just_pressed("draw_left"):
		state = draw_left
	if direction == "right" and Input.is_action_just_pressed("draw_right"):
		state = draw_right

func move():
	velocity = move_and_slide(velocity)

func draw_left_state(delta):
	animation_state.travel("DrawingLeft")

func draw_right_state(delta):
	animation_state.travel("DrawingRight")

func draw_state_finished():
	state = combat

func combat_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation(input_vector)
		animation_state.travel("CombatRun")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animation_state.travel("Combat")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if velocity.x < 0:
		direction = "left"
	elif velocity.x > 0:
		direction = "right"
	
	move()
	
	if direction == "left" and Input.is_action_just_pressed("quick_cut_left"):
		state = quick_cut_left
	if direction == "right" and Input.is_action_just_pressed("quick_cut_right"):
		state = quick_cut_right
	
	if direction == "left" and Input.is_action_just_pressed("downward_cut"):
		state = downward_cut_left
	if direction == "right" and Input.is_action_just_pressed("downward_cut"):
		state = downward_cut_right
	
	if direction == "left" and Input.is_action_just_pressed("upward_cut"):
		state = upward_cut_left
	if direction == "right" and Input.is_action_just_pressed("upward_cut"):
		state = upward_cut_right
	
	if direction == "left" and Input.is_action_just_pressed("stab_left"):
		state = stab_left
	if direction == "right" and Input.is_action_just_pressed("stab_right"):
		state = stab_right
	
	if direction == "left" and Input.is_action_just_pressed("kick"):
		state = kick_left
	if direction == "right" and Input.is_action_just_pressed("kick"):
		state = kick_right
	
	if velocity.x == 0 and time_started == false:
		time_started = true
		retrieve_timer.start(5)
	elif velocity.x != 0:
		time_started = false
		retrieve_timer.stop()

func _on_RetrieveTimer_timeout():
	time_started = false
	state = retrieving

func retrieving_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Retrieving")

func retrieving_state_finished():
	state = move

func attack_left_movement():
	velocity = Vector2.LEFT * attack_forward

func attack_right_movement():
	velocity = Vector2.RIGHT * attack_forward

func quick_cut_left_state(delta):
	combo_timer.start(0.5)
	if combo_points == 1:
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutLeft1")
		move()
		combo_points += 1
	elif combo_points == 2 and Input.is_action_just_pressed("quick_cut_left"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutLeft2")
		move()
		combo_points += 1
	elif combo_points == 3 and Input.is_action_just_pressed("quick_cut_left"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutLeft3")
		move()
		combo_points += 1
	elif combo_points == 4 and Input.is_action_just_pressed("quick_cut_left"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutLeft4")
		move()

func quick_cut_right_state(delta):
	combo_timer.start(0.5)
	if combo_points == 1:
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutRight1")
		move()
		combo_points += 1
	elif combo_points == 2 and Input.is_action_just_pressed("quick_cut_right"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutRight2")
		move()
		combo_points += 1
	elif combo_points == 3 and Input.is_action_just_pressed("quick_cut_right"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutRight3")
		move()
		combo_points += 1
	elif combo_points == 4 and Input.is_action_just_pressed("quick_cut_right"):
		time_started = false
		retrieve_timer.stop()
		combo_timer.stop()
		animation_state.travel("QuickCutRight4")
		move()

func _on_ComboTimer_timeout():
	time_started = false
	retrieve_timer.stop()
	combo_points = 1
	state = combat

func reset_combo():
	combo_points = 1
	quick_cut_state_finished()

func quick_cut_state_finished():
	state = combat

func downward_cut_left_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("DownwardCutLeft")
	move()

func downward_cut_right_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("DownwardCutRight")
	move()

func downward_cut_state_finished():
	state = combat

func upward_cut_left_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("UpwardCutLeft")
	move()

func upward_cut_right_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("UpwardCutRight")
	move()

func upward_cut_state_finished():
	state = combat

func stab_left_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("StabLeft")
	move()

func stab_right_state(delta):
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("StabRight")
	move()

func stab_state_finished():
	state = combat

func kick_left_state(delta):
	velocity = Vector2.ZERO
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("KickLeft")
	move()

func kick_right_state(delta):
	velocity = Vector2.ZERO
	time_started = false
	retrieve_timer.stop()
	animation_state.travel("KickRight")
	move()

func kick_state_finished():
	state = combat
