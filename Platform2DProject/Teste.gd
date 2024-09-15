extends Node2D

func _ready() -> void:
	CharacterCtrl.father = self
	CharacterCtrl.initPos = Vector2(280, 584)
	CharacterCtrl.change(0,self)

func _process(delta: float) -> void:
	CharacterCtrl.characterChange()


func _on_end_body_entered(body: Node) -> void:
	get_tree().reload_current_scene()
