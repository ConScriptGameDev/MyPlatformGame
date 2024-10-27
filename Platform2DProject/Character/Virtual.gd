extends KinematicBody2D

onready var anim := $anim as AnimationPlayer 
onready var sprite := $texture as Sprite
onready var timer := $Timer as Timer
onready var pos := $dashPoint as Position2D
onready var particle := $particles as CPUParticles2D
onready var wallColl := $wallColl as RayCast2D
onready var counter := $counter as Area2D

var can_dash = true
var dashPos = true

var velocity = Vector2.ZERO
var enterState = true
var currentState = 0
enum{IDLE, RUN, DASH, JUMP, FALL, HIT, SHIELD}

func _physics_process(delta: float) -> void:
	match currentState:
		IDLE:
			idle(delta)
		RUN:
			run(delta)
		DASH:
			dash(delta)
		JUMP:
			jump(delta)
		FALL:
			fall(delta)
#		HIT:
#			hit(delta)
		SHIELD:
			shield(delta)
	
	if $waterColl.is_colliding():
		self.global_position = Global.check

func gravity(delta):
	velocity.y += 800 * delta

func slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func move():
	if Input.is_action_pressed("left"):
		counter.scale.x = -1
		velocity.x = -120
		sprite.flip_h = true
		CharacterCtrl.facingLeft = true
		pos.position.x = -36
		particle.scale.x = -1
		wallColl.scale.x = -1
		wallColl.position.x = -36
	if Input.is_action_pressed("right"):
		counter.scale.x = 1
		velocity.x = 120
		sprite.flip_h = false
		CharacterCtrl.facingLeft = false
		pos.position.x = 36
		particle.scale.x = 1
		wallColl.scale.x = 1
		wallColl.position.x = 36

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

func dash(delta):
	self.global_position = pos.global_position
	slide()
	can_dash = false
	timer.start()
	setState(isDashing())

func jump(delta):
	if enterState:
		anim.play("jump")
		velocity.y = -250
		enterState = false
	gravity(delta)
	slide()
	move()
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

func shield(delta):
	anim.play("shield")
	gravity(delta)
	slide()
	move()
	canProtect(true)
	velocity.x = 0
	
func isStopped():
	var newState = currentState
	if Input.is_action_pressed("left") || Input.is_action_pressed("right"):
		newState = RUN
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
	if !is_on_floor():
		newState = FALL
	if Input.is_action_just_pressed("unique"):
		newState = SHIELD
	return newState

func isRunning():
	var newState = currentState
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		newState = IDLE
	if Input.is_action_just_pressed("jump"):
		newState = JUMP
	if !is_on_floor():
		newState = FALL
	if Input.is_action_just_pressed("unique"):
		newState = SHIELD
	return newState

func isDashing():
	var newState = currentState
	if !is_on_floor():
		newState = FALL
	if is_on_floor():
		newState = IDLE
	return newState

func isJumping():
	var newState = currentState
	if !is_on_floor() and !wallColl.is_colliding() and dashPos and can_dash and Input.is_action_just_pressed("jump"):
		$particles.emitting = true
		newState = DASH
	if velocity.y >= 0:
		newState = FALL
	if Input.is_action_just_pressed("unique"):
		newState = SHIELD
	return newState
	
func isFalling():
	var newState = currentState
	if !is_on_floor() and !wallColl.is_colliding() and can_dash and Input.is_action_just_pressed("jump"):
		$particles.emitting = true
		newState = DASH
	if is_on_floor():
		newState = IDLE
	if Input.is_action_just_pressed("unique"):
		newState = SHIELD
	return newState

#func isHitted():
#	pass
	
func setState(newState):
	if newState != currentState:
		enterState = true
	currentState = newState

func canProtect(isPossible:bool):
	if isPossible:
		$counter.show()
		$counter.set_deferred("monitoring", true)
	else:
		$counter.hide()
		$counter.set_deferred("monitoring", false)

func _on_Timer_timeout() -> void:
	can_dash = true

func _on_counter_area_entered(area: Area2D) -> void:
	if area.is_in_group("deflect"):
		area.direction *= -1
		area.remove_from_group("deflect")
		area.add_to_group("deflected")

func _on_anim_animation_finished(anim_name: String) -> void:
	if anim_name == "shield":
		canProtect(false)
		setState(IDLE)


func _on_hurtBox_area_entered(area: Area2D) -> void:
	global_position = Global.check
