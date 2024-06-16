extends CharacterBody2D

const MAX_SPEED := 400
const ACCELERATION := 6000
const FRICTION := 6000

enum {
	MOVE,
	ATTACK
}

var state = MOVE
@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack()

func move(delta):
	y_sort_enabled = true
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animatedSprite.play("run")
		if input_vector.x > 0:
			animatedSprite.flip_h = false
		elif input_vector.x < 0:
			animatedSprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animatedSprite.play("idle")
		
	move_and_slide()
	
	if Input.get_action_strength("attack"):
		state = ATTACK

func attack():
	animatedSprite.play("attack2")
	await animatedSprite.animation_finished
	state = MOVE
	
