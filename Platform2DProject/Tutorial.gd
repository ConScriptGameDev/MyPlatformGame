extends Area2D

export var canNinja = false
export var canCloundy = false
export var canMasked = false
export var canFuturist = false

func _on_Tutorial_body_entered(body: Node) -> void:
	$texture.show()
	$Label.show()
	CharacterCtrl.canNinja = canNinja
	CharacterCtrl.canCloundy = canCloundy
	CharacterCtrl.canMasked = canMasked
	CharacterCtrl.canFuturist = canFuturist
	
func _on_Tutorial_body_exited(body: Node) -> void:
	$texture.hide()
	$Label.hide()
