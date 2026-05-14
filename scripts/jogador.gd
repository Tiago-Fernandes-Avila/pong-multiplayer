extends StaticBody2D
const SPEED = 150.0
var velocity : Vector2 = Vector2.ZERO
@export var input_up : String = "w"
@export var input_down : String = "s"   

@rpc
func _att_pos():
	if name.to_int() == 1:
		position = Vector2(60, 315)
	else:
		position = Vector2(1090, 315)
 
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	_att_pos()

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var axis = InputProcessor()
		if(axis > 0):
			velocity.y += SPEED 
		elif axis < 0:
			velocity.y -= SPEED 
		else:
			velocity.y = 0
	move_and_collide(velocity * delta)

		
	
func InputProcessor():
	return Input.get_axis(input_up, input_down);
