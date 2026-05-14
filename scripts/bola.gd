extends StaticBody2D

var initial_pos : Vector2 = Vector2(DisplayServer.window_get_size(0).x /2, DisplayServer.window_get_size(0).y /2)

const ANGLES : Array[Vector2] = [
	Vector2(-0.5, -1.0), Vector2(1.0, 1.0), Vector2(0.5, -0.5), 
	Vector2(-1, -1), Vector2(-1, 1), Vector2(-1, 0.5), Vector2(1, -1)
]
var SPEED = 400.0
@export var velocity : Vector2 = Vector2.ZERO;
@export var acc : float = 1.0
func _ready() -> void:
	print("bola instanciada!")
	# Escolhe uma direção aleatória e garante que a velocidade seja constante
	var direction = ANGLES.pick_random().normalized()
	velocity = direction * SPEED
	

func _physics_process(delta: float) -> void:

	# move_and_slide usa a propriedade velocity interna
	var collision = move_and_collide(velocity * delta)
	if collision:
		acc += 0.01
		if acc > 1.08:
			acc = 1.08
		velocity = velocity.bounce(collision.get_normal()) * acc
		
	
	# Verifica se saiu da tela (considerando 1200 como largura da sua tela)
	if position.x > 1200:
		reset_state()
		GameStatus.player_one_pontuation += 1
		
	elif position.x < 0:
		reset_state()
		GameStatus.player_two_pontuation += 1
		

func reset_state():
	position = initial_pos
	acc = 1.0
	velocity = ANGLES.pick_random().normalized() * SPEED
