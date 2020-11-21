extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 700

var velocity = Vector2()

onready var gravity = 980

var key_pressed = false

var direction = "right"

onready var root = get_node("/root/Globals")

func _ready():
	get_node("Name").text = root.player_name

func _physics_process(delta):
	
	var global_pos = get_node("../Player").get_global_transform_with_canvas()
	
	get_node("Coordinates").text = str(stepify(global_position.x, 0.01)) + "," + str(stepify(global_position.y, 0.01))
	
	var key_right = Input.is_action_pressed("move_right")
	var key_left = Input.is_action_pressed("move_left")
	var key_jump = Input.is_action_pressed("jump")
	
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		get_node("AnimatedSprite").set_scale(Vector2(-0.7,0.7))
	else:
		velocity.x += walk * delta
		
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	if(key_right and is_on_floor()):
		get_node("AnimatedSprite").play("walk")
		get_node("AnimatedSprite").set_scale(Vector2(0.7,0.7))
		direction = "right"
	if(key_left and is_on_floor()):
		get_node("AnimatedSprite").play("walk")
		get_node("AnimatedSprite").set_scale(Vector2(-0.7,0.7))
		direction = "left"
	

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	if(Input.is_action_just_released("move_right")):
		get_node("AnimatedSprite").play("idle")
	if(Input.is_action_just_released("move_left")):
		get_node("AnimatedSprite").play("idle")
	if(Input.is_action_just_released("jump")):
		get_node("AnimatedSprite").play("idle")

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and key_jump:
		velocity.y = -JUMP_SPEED
		if(direction == "right"):
			get_node("AnimatedSprite").set_scale(Vector2(0.7,0.7))
		elif(direction == "left"):
			get_node("AnimatedSprite").set_scale(Vector2(-0.7,0.7))
		get_node("AnimatedSprite").play("jump")
		
		
	


func _on_Right_pressed():
	Input.action_press("move_right")


func _on_Left_pressed():
	Input.action_press("move_left")


func _on_Jump_pressed():
	Input.action_press("jump")


func _on_Right_released():
	Input.action_release("move_right")


func _on_Left_released():
	Input.action_release("move_left")



func _on_Jump_released():
	Input.action_release("jump")
