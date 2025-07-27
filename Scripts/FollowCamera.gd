extends Node3D

@export var Target : Node3D
@export var LookAtNode:Node3D
@export var Speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	
	if Target != null:
		global_position = lerp(global_position,Target.global_position,Speed*delta)
	if LookAtNode != null:
		look_at(LookAtNode.global_position)
	
