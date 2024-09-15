extends KinematicBody2D

onready var anim := $anim as AnimationPlayer 
onready var sprite := $texture as Sprite 

var velocity = Vector2.ZERO
var enterState = true
var currentState = 0
enum{IDLE, RUN, JUMP, FALL, HIT}

func _physics_process(delta: float) -> void:
	match currentState:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		JUMP:
			jump(delta)
		FALL:
			fall(delta)
#		HIT:
#			hit(delta)
		
func gravity(delta):
	velocity.y += 800 * delta

func slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func move():
	if Input.is_action_pressed("left"):
		velocity.x = -120
		sprite.flip_h = true
		CharacterCtrl.facingLeft = true
	elif Input.is_action_pressed("right"):
		velocity.x = 120
		sprite.flip_h = false
		CharacterCtrl.facingLeft = false

func idle(delta):
	anim.play("idle")
	velocity.x = 0
	gravity(delta)
	slide()
	setState(isStopped())

func run(delta):
	anim.play("run")
	gravity(delta)
	slide()
	move()
	setState(isRunning())

func jump(delta):
	if enterState:
		anim.play("jump")
		velocity.y = -650
		velocity.x = 0
		enterState = false
	gravity(delta)
	slide()
	setState(isJumping())

#func hit(delta):
#	anim.play("hit")
#	setState(isHitted())

func fall(delta):
	anim.play("fall")
	gravity(delta)
	slide()
	move()
	setState(isFalling())

func isStopped():
	var newState = currentState
	if Input.is_action_pressed("left") || Input.is_action_pressed("right"):
		newState = RUN
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
	if !is_on_floor():
		newState = FALL
	return newState

func isRunning():
	var newState = currentState
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		newState = IDLE
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
	if !is_on_floor():
		newState = FALL
	return newState

func isJumping():
	var newState = currentState
	if velocity.y >= 0:
		newState = FALL
	return newState
	
func isFalling():
	var newState = currentState
	if is_on_floor():
		newState = IDLE
	return newState

#func isHitted():
#	pass
	
func setState(newState):
	if newState != currentState:
		enterState = true
	currentState = newState
