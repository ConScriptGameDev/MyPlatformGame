extends KinematicBody2D

onready var anim := $anim as AnimationPlayer 
onready var sprite := $texture as Sprite
onready var isWall := $RayCast2D3 as RayCast2D
var jumpCount = 0

var velocity = Vector2.ZERO
var direction = 0
var enterState = true
var currentState = 0
enum{IDLE, RUN, JUMP, DOUBLE, WALL, FALL, HIT}

func _physics_process(delta: float) -> void:
	match currentState:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		JUMP:
			jump(delta)
		DOUBLE:
			double(delta)
		WALL:
			wall(delta)
		FALL:
			fall(delta)
#		HIT:
#			hit(delta)
		
	if $waterColl.is_colliding():
		self.global_position = Global.check
		
func gravity(delta):
	velocity.y += 800 * delta

func slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func move():
	if Input.is_action_pressed("left"):
		direction = -1
		isWall.scale.x = -1
		velocity.x = -150
		sprite.flip_h = true
		CharacterCtrl.facingLeft = true
	elif Input.is_action_pressed("right"):
		direction = 1
		isWall.scale.x = 1
		velocity.x = 150
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
		velocity.y = -350
		jumpCount += 1
		enterState = false
	gravity(delta)
	slide()
	move()
	setState(isJumping())

func double(delta):
	if enterState and jumpCount > 0:
		anim.play("doubleJump")
		velocity.y = -350
		jumpCount = 0
		enterState = false
	gravity(delta)
	slide()
	move()
	setState(isJumpingTwice())

func wall(delta):
	anim.play("wallJump")
	gravity(delta)
	setState(isJumpingWall())

#func hit(delta):
#	anim.play("hit")
#	setState(isHitted())

func fall(delta):
	anim.play("fall")
	gravity(delta)
	slide()
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
	if Input.is_action_just_pressed("jump") and jumpCount > 0:
		newState = DOUBLE
	if isWall.is_colliding() and !is_on_floor():
		newState = WALL
	return newState

func isJumpingTwice():
	var newState = currentState
	if velocity.y >= 0:
		newState = FALL
	if is_on_floor():
		newState = IDLE
	if isWall.is_colliding() and !is_on_floor():
		newState = WALL
	return newState

func isJumpingWall():
	var newState = currentState
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
		if direction > 0:
			sprite.flip_h = true
			velocity.x = -180
			isWall.scale.x = direction * -1
			direction *= -1
		else:
			sprite.flip_h = false
			velocity.x = 180
			isWall.scale.x = direction * -1
			direction *= -1
	if is_on_floor():
		newState = IDLE
	if !is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		newState = FALL
	return newState
	
func isFalling():
	var newState = currentState
	if is_on_floor():
		newState = IDLE
	if Input.is_action_just_pressed("jump") and jumpCount > 0:
		newState = DOUBLE
	if isWall.is_colliding() and !is_on_floor():
		newState = WALL
	return newState

#func isHitted():
#	pass
	
func setState(newState):
	if newState != currentState:
		enterState = true
	currentState = newState


func _on_hurtBox_area_entered(area: Area2D) -> void:
	global_position = Global.check
