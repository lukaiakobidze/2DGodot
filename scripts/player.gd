extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const reach = 5


func _ready():
	animation_tree.active = true


func _physics_process(delta: float):
	

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		sprite.flip_h = false
	if direction < 0:
		sprite.flip_h = true
	
	
	if direction != 0 and state_machine.check_can_move():
		animation_tree.set("parameters/Move/blend_position", direction)
		velocity.x = direction * SPEED
		
	else:
		animation_tree.set("parameters/Move/blend_position", direction)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
