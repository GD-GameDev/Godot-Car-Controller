extends VehicleBody3D

@export var RefPoint : Node3D
@export var Speed = 200
@export var DriftAngle = 0.2
@export var SteerAngle = 0.7
@export var SteerSpeed = 10

@export var EngineVolume = 0
@export var EngineVolumePitch = 1
@export var TyreVolume = 0
@export var TyrePitch:float = 1
var is_drifting = false
var current_speed = 0
var previous_pos = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	center_of_mass = $CenterOfMass.position
	previous_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	current_speed = (global_position - previous_pos).length()/delta
	Drift()
	previous_pos = global_position
	engine_force = Speed*Input.get_axis("ui_down","ui_up")
	steering = lerp(steering,SteerAngle*-Input.get_axis("ui_left","ui_right"),SteerSpeed*delta)
	AudioManager()

func Drift():
	var Angle = global_basis.z.angle_to(-RefPoint.global_basis.z)
	#print(Angle)
	if Angle > DriftAngle:
		is_drifting = true
		$RL.wheel_friction_slip = 1.7
		$RR.wheel_friction_slip = 1.7
	else:
		is_drifting = false
		$RL.wheel_friction_slip = 2
		$RR.wheel_friction_slip = 2
	$Effects/RLSmoke.emitting = is_drifting
	$Effects/RRSmoke.emitting = is_drifting
	
func AudioManager():
	if $Audio/Engine.playing == false:$Audio/Engine.play()
	$Audio/Engine.volume_db = EngineVolume
	$Audio/Engine.pitch_scale = EngineVolumePitch+current_speed/100
	$Audio/Tyre.volume_db = TyreVolume+current_speed/100
	$Audio/Tyre.pitch_scale = TyrePitch+current_speed/100
	if is_drifting && !$Audio/Tyre.playing:
		$Audio/Tyre.play()
	elif is_drifting == false:
		$Audio/Tyre.stream_paused = true
