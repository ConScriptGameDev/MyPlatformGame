extends KinematicBody2D

onready var anim := $anim as AnimationPlayer 
onready var sprite := $texture as Sprite
onready var rightCollider := $RayCast2D3 as RayCast2D
onready var leftCollider := $RayCast2D4 as RayCast2D

var velocity = Vector2.ZERO
var enterState = true
var currentState = 0
var canRich = false
enum{IDLE, RUN, JUMP, BALL, FALL, HIT}

func _physics_process(delta: float) -> void:
	match currentState:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		JUMP:
			jump(delta)
		BALL:
			ball(delta)
		FALL:
			fall(delta)
#		HIT:
#			hit(delta)
		
	if $waterColl.is_colliding():
		self.global_position = Global.check
		
	wall(delta)
	
	if Input.is_action_just_pressed("unique"):
		canBouce(true)
	
func gravity(delta):
	velocity.y += 400 * delta

func slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func move(value):
	if Input.is_action_pressed("left"):
		velocity.x = -120 * value
		sprite.flip_h = true
		CharacterCtrl.facingLeft = true
	elif Input.is_action_pressed("right"):
		velocity.x = 120 * value
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
	move(1)
	setState(isRunning())

func jump(delta):
	if enterState:
		anim.play("jump")
		velocity.y = -250
		enterState = false
	gravity(delta)
	move(2)
	slide()
	setState(isJumping())

func ball(delta):
	if enterState:
		anim.play("jump")
		velocity.y = -250
		enterState = false
	gravity(delta)
	move(2)
	slide()

func wall(delta):
	if rightCollider.is_colliding():
		move_and_slide(Vector2.LEFT * 200)
		velocity.x = -400
		setState(BALL)
	if leftCollider.is_colliding():
		move_and_slide(Vector2.RIGHT * 200)
		velocity.x = 400
		setState(BALL)

#func hit(delta):
#	anim.play("hit")
#	setState(isHitted())

func fall(delta):
	anim.play("fall")
	gravity(delta)
	slide()
	move(2)
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
	canBouce(false)
	var newState = currentState
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		newState = IDLE
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
	if !is_on_floor():
		newState = FALL
	return newState

func isJumping():
	canBouce(false)
	var newState = currentState
	if velocity.y >= 0:
		newState = FALL
	return newState

func isFalling():
	canBouce(false)
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

func canBouce(value:bool = false):
	if value:
		canRich = true
		$ball.show()
		leftCollider.set_deferred("enabled", true)
		rightCollider.set_deferred("enabled", true)
	else:
		canRich = false
		$ball.hide()
		leftCollider.set_deferred("enabled", false)
		rightCollider.set_deferred("enabled", false)


func _on_hurtBox_area_entered(area: Area2D) -> void:
	global_position = Global.check
