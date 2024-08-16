extends CharacterBody2D


const SPEED:float = 3000.0
const JUMP_VELOCITY:float = -400.0
const Drag:float = 0.05
const GRAV:float = 800
const SCALE_PWR:float = .03

var snd:bool = true
var size:float = 1.0
var speed_mult:float = 1.0
var inpt_power:Vector2 = Vector2()
var damage_mult:float = 1.0
var diff:float = 1.0
var grav_mult:float = 1.0
var stretch:float = 1.0

func _physics_process(delta):
	### movement
	#handle x movementif not inpt_power.x == 0: 
	if not Input.is_action_pressed("QuickGrow"):
		inpt_power.x = Input.get_axis("left","right")
	else:
		inpt_power.x = 0
	anim()
	
	#handle y movement
	if $floor.has_overlapping_bodies():
		velocity.x += (inpt_power.x * (SPEED * (size * 3))) * delta
		velocity.x = clamp(lerp(velocity.x,0.0,Drag / size),-450 - (size * 50),450 + (size * 50))
		$CTime.start(0.2)
		if velocity.y <= 0:
			velocity.y = 0
	else:
		velocity.y += (GRAV * grav_mult) * delta
		##anim
		if velocity.y > 0:
			$AnimationPlayer.play("down")
		elif velocity.y < 0:
			$AnimationPlayer.play("up")
	
	velocity.y = clamp(velocity.y,-1000,1000)
	
	if Input.is_action_just_pressed("Jump") and not Input.is_action_pressed("QuickGrow") and not $CTime.is_stopped():
		velocity.y = JUMP_VELOCITY * size
		$jump.play()
		$CTime.stop()
	
	
	### embed
	##handle mechanics
	$instagrowbox.global_scale = Vector2(1,1)
	$ableggrow.global_scale = Vector2(diff + 0.05,diff + 0.05)
	if not $ableggrow.has_overlapping_bodies():
		speed_mult = diff
		inpt_power.y = Input.get_axis("up","down")
		diff -= (inpt_power.y * SCALE_PWR)
	if $ableggrow.has_overlapping_bodies():
		diff -= 0.001
	diff = clamp(diff,.5,3)
	size = clamp(lerp(size, diff, Drag),.5,3)
	scale = Vector2(size,size)
	
	if (not inpt_power.y == 0) and not (diff == 0.5 or diff == 3):
		$grow.play()
	
	if Input.is_action_pressed("QuickGrow"):
		if not inpt_power.y == 0:
			if inpt_power.y == -1 and not $instagrowbox.has_overlapping_bodies():
				diff = -inpt_power.y * 3
			elif inpt_power.y == 1:
				diff = -inpt_power.y * 3
		if Input.is_action_just_pressed("Jump"):
			diff = 1
			$grow.play()
	
	#operate pitch scale
	var pitch = clamp(2 - size,.5,2)
	$step.pitch_scale = pitch
	$jump.pitch_scale = pitch
	$land.pitch_scale = pitch
	$grow.pitch_scale = pitch
	
	##other
	#camera magic
	var zoommod = ((1 + (stretch / 2)) - 1.25)
	$Camera2D.position = lerp($Camera2D.position,(velocity/20) + Vector2(0,-64),Drag)
	
	# proc anim
	stretch = clamp((velocity.y / 260) / size,-1.5,1.5) 
	$texture/Sprite2D.skew = lerp($texture/Sprite2D.skew,(((-(velocity.x / 3000) * (clamp(velocity.y,-1,1))) / size)),Drag)
	
	$texture/Sprite2D.scale = lerp($texture/Sprite2D.scale,Vector2(1 - (((abs(stretch))) / 3), 1 + (((abs(stretch) / 2)))),Drag)
	#finish
	move_and_slide()

func anim():
	if not inpt_power.x == 0: 
		$AnimationPlayer.play("walk")
		if inpt_power.x == 1:
			$texture/Sprite2D.flip_h = false
		if inpt_power.x == -1:
			$texture/Sprite2D.flip_h = true
	else:
		$AnimationPlayer.play("idle")


func _on_floor_body_entered(body: Node2D) -> void:
	$land.play()
