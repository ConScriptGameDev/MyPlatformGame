extends Node2D

func _on_start_body_entered(body: Node) -> void:
	if body.is_in_group("bounce") and body.canRich:
		$Path2D/PathFollow2D/RemoteTransform2D.remote_path = body.get_path()
		$AnimationPlayer.play("new")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	CharacterCtrl.change(3, self)
