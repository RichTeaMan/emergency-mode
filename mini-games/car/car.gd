extends RigidBody2D

# inspired by a forum post: https://ask.godotengine.org/16041/top-down-car-physics

var steering_com = 0.0
var force_com = 0.0

func _process(delta):
	if Input.is_action_pressed("forward"):
		force_com = 16.0
	elif Input.is_action_pressed("back"):
		force_com = -8.0
	else:
		force_com = 0.0
	
	steering_com = 0
	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		steering_com = -750
	elif !Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		steering_com = 750
	
	print("force: %s | steering: %s" % [force_com, steering_com])
	
func _ready():
	set_process_input(true)

func _physics_process(delta):
	var tf = get_global_transform()
	var vel = get_linear_velocity()
#   get the orthogonal velocity vector
	var right_vel = tf.x * tf.x.dot(vel)
#   decrease the force in proportion to the velocity to stop endless acceleration
	var force = force_com - force_com * clamp(vel.length() / 400.0, 0.0, 1.0)
	print("force %s" % [force])
	var steering_torque = steering_com
	if tf.y.dot(vel) < 0.0:
#   if reversing, reverse the steering
		steering_torque = -steering_com
#   make reversing slower
		if force_com <= 0.0:
			force *= 0.3
#   apply the side force, the lower this is the more the car slides
#   make the sliding depend on the power command somewhat
	apply_impulse(-right_vel * 0.07 * clamp(1.0 / abs(force), 0.01, 1.0))
#  
	apply_impulse(tf.basis_xform(Vector2(0, force)))
#   scale the steering torque with velocity to prevent turning the car when not moving
	apply_torque(steering_torque * vel.length() / 200.0)
