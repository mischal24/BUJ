extends KinematicBody2D
class_name enemy

export(int, "Hunter", "Dog") var type
onready var player = get_tree().get_nodes_in_group("Player")
var health = 100

var inRange := []

enum hunter {
	Move,
	Shoot,
	Flee
}

enum dog {
	Move,
	Bite
}

var current_state = hunter.Move
export(float) var speed = 100

func _process(delta):
	health = clamp(health, 0, 100)
	if health == 0:
		queue_free()

	#movement
	var playerPos = player[0].global_position
	var dir = global_position.direction_to(playerPos)
	var dist = global_position.distance_to(playerPos)

	#keep way
	for i in inRange:
		var range_dir = global_position.direction_to(i.global_position)
		move_and_slide(-range_dir * (speed/3.5))

	if type == 0: #hunter
		if dist > 510:
			set_state(hunter.Move)
		elif dist < 490:
			set_state(hunter.Flee)
		elif dist >= 490 and dist <= 510:
			set_state(hunter.Shoot)

		match current_state:
			hunter.Move:
				move_and_slide(dir * speed)
			hunter.Shoot:
				pass
			hunter.Flee:
				move_and_slide(-dir * speed)

	if type == 1: #dog
		if dist > 100:
			set_state(dog.Move)
		else:
			set_state(dog.Bite)

		match current_state:
			dog.Move:
				move_and_slide(dir * speed)
			dog.Bite:
				pass

func set_state(state):
	current_state = state

func range_enter(body):
	if body != self and body.is_in_group("Enemies"):
		inRange.append(body)

func range_exit(body):
	if body:
		inRange.erase(body)