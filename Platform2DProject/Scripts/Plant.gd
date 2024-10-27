extends KinematicBody2D

export var facing_left = true
var hitted = false
export var health = 1

onready var bullet_instance = preload("res://Scenes/Seed.tscn")
onready var player

func _physics_process(_delta: float) -> void:
	_set_animation()
	
	if facing_left:
		self.scale.x = 2
	else:
		self.scale.x = -2

func _set_animation():
	var anim = "idle"

	if $playerDetector.overlaps_body(player):
		anim = "attack"
	else:
		anim = "idle"
		
	if hitted == true:
		anim = "hit"
		
	if $anim.assigned_animation != anim:
		$anim.play(anim)
		
func shoot():
	var bullet = bullet_instance.instance()
	get_parent().add_child(bullet)
	bullet.global_position = $spawnShoot.global_position
	
	if facing_left:
		bullet.direction = 1
	else:
		bullet.direction = -1

func _on_playerDetector_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body
		$anim.play("attack")

func _on_playerDetector_body_exited(body: Node) -> void:
	$anim.play("idle")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("deflected"):
		hitted = true
		health -= 1
#		$hitFx.play()
		yield(get_tree().create_timer(0.2), "timeout")
		hitted = false
		if health < 1:
			area.queue_free()
			queue_free()
			get_node("hitbox/collision").set_deferred("disabled", true)
