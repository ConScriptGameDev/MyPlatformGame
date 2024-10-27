extends Node

var facingLeft = false
var newChar
var oldChar

var father
var initPos

var canNinja = false
var canCloundy = false
var canMasked = false
var canFuturist = false

var Def = preload("res://Character/Default.tscn")
var Mask = preload("res://Character/Masked.tscn")
var Ninja = preload("res://Character/Ninja.tscn")
var Pink = preload("res://Character/Pink.tscn")
var Virtual = preload("res://Character/Virtual.tscn")

func characterChange():
	if Input.is_action_just_pressed("ui_up"):# and canNinja:
		change(2, father)
	if Input.is_action_just_pressed("ui_down"):# and canMasked:
		change(1, father)
	if Input.is_action_just_pressed("ui_left"):# and canCloundy:
		change(3, father)
	if Input.is_action_just_pressed("ui_right"):# and canFuturist:
		change(4, father)

func change(value, parent):
	if value == 0:
		var def = Def.instance()
		parent.add_child(def)
		def.global_position = initPos
		newChar = def
		return def
	
	if value == 1:
		oldChar = newChar
		var mask = Mask.instance()
		parent.add_child(mask)
		mask.global_position = oldChar.global_position
		newChar = mask
		oldChar.queue_free()
		if facingLeft:
			mask.sprite.flip_h = true
		else:
			mask.sprite.flip_h = false
		return mask
		
	if value == 2:
		oldChar = newChar
		var ninja = Ninja.instance()
		parent.add_child(ninja)
		ninja.global_position = oldChar.global_position
		newChar = ninja
		oldChar.queue_free()
		if facingLeft:
			ninja.sprite.flip_h = true
		else:
			ninja.sprite.flip_h = false
		return ninja
		
	if value == 3:
		oldChar = newChar
		var pink = Pink.instance()
		parent.add_child(pink)
		pink.global_position = oldChar.global_position
		newChar = pink
		oldChar.queue_free()
		if facingLeft:
			pink.sprite.flip_h = true
		else:
			pink.sprite.flip_h = false
		return pink

	if value == 4:
		oldChar = newChar
		var virtual = Virtual.instance()
		parent.add_child(virtual)
		virtual.global_position = oldChar.global_position
		newChar = virtual
		oldChar.queue_free()
		if facingLeft:
			virtual.sprite.flip_h = true
			virtual.counter.scale.x = -1
			virtual.particle.scale.x = -1
			virtual.pos.position.x = -36
		else:
			virtual.sprite.flip_h = false
			virtual.counter.scale.x = 1
			virtual.particle.scale.x = 1
			virtual.pos.position.x = 36
		return virtual
