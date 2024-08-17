extends CharacterBody2D


const SPEED:float = 3000.0
const JUMP_VELOCITY:float = -400.0
const Drag:float = 0.05
const GRAV:float = 800
const SCALE_PWR:float = .03

var prevdir:int = 1
var snd:bool = true
var size:float = 1.0
var speed_mult:float = 1.0
var inpt_power:Vector2 = Vector2()
var damage_mult:float = 1.0
var diff:float = 1.0
var grav_mult:float = 1.0
var stretch:float = 1.0
var lsnd:bool = false
var cnatk:bool = false

func _physics_process(delta):
	$CanvasLayer/TextureProgressBar.value = diff
	if Global.paused == false:
		### movement
		#handle x movementif not inpt_power.x == 0: 
		if not Input.is_action_pressed("QuickGrow"):
			inpt_power.x = Input.get_axis("left","right")
			if not inpt_power.x == 0:
				prevdir = inpt_power.x
		else:
			inpt_power.x = 0
		if Input.is_action_just_pressed("atk") and $atk/Timer.is_stopped():
			velocity.x += 100 * prevdir
			$atk.position.x = 85 * prevdir
			$atk/Timer.start(.1)
			var e = preload("res://common/pushparticles.tscn").instantiate()
			e.emitting = true
			e.position = $atk.position
			add_child(e)
			$atk/CollisionShape2D.disabled = false
			$smack.play()
		anim()
		velocity.x += (inpt_power.x * (SPEED * (size * 6))) * delta
		velocity.x = clamp(lerp(velocity.x,0.0,Drag / size),-450 - (size * 100),450 + (size * 100))
		if Input.is_action_just_pressed("atk") and $atk/Timer.is_stopped():
			velocity.x += (prevdir * 200) / size
			print(velocity.x)
		#handle y movement
		if $floor.has_overlapping_bodies():
			$CTime.start(0.2)
			if lsnd and velocity.y >= 0:
				lsnd = false
				$land.play()
			if velocity.y >= 0:
				velocity.y = 0
		else:
			velocity.y += (GRAV * grav_mult) * delta
			##anim
			if velocity.y > 0:
				$AnimationPlayer.play("down")
			elif velocity.y < 0:
				$AnimationPlayer.play("up")
			lsnd = true
		velocity.y = clamp(velocity.y,-1000,1000)
		
		if Input.is_action_just_pressed("Jump") and not Input.is_action_pressed("QuickGrow") and not $CTime.is_stopped():
			velocity.y = JUMP_VELOCITY * size
			$jump.play()
			$CTime.stop()
		
		### embed
		##handle mechanics
		
		$instagrowbox.global_scale = Vector2(1,1)
		$instagrowbox2.global_scale = Vector2(1,1)
		$ableggrow.global_scale = Vector2(diff + 0.05,diff + 0.05)
		if not $ableggrow.has_overlapping_bodies() or  inpt_power.y == 1:
			snd = true
			speed_mult = diff
			inpt_power.y = Input.get_axis("up","down")
			diff -= (inpt_power.y * SCALE_PWR)
		if $ableggrow.has_overlapping_bodies() and inpt_power.y == -1:
			snd = false
			diff -= 0.001
		diff = clamp(diff,.5,3)
		size = clamp(lerp(size, diff, Drag),.5,3)
		scale = Vector2(size,size)
		
		if ((not inpt_power.y == 0) and not (diff == 0.5 or diff == 3) and snd):
			$grow.play()
		
		if Input.is_action_pressed("QuickGrow"):
			if not inpt_power.y == 0:
				if inpt_power.y == -1 and not $instagrowbox.has_overlapping_bodies():
					diff = -inpt_power.y * 3
				elif inpt_power.y == 1:
					diff = -inpt_power.y * 3
			if Input.is_action_just_pressed("Jump") and not $instagrowbox2.has_overlapping_bodies():
				diff = 1
				$grow.play()
		
		#operate pitch scale
		var pitch = clamp(2 - size,.5,2)
		$step.pitch_scale = pitch
		$jump.pitch_scale = pitch
		$land.pitch_scale = pitch
		$grow.pitch_scale = pitch
		$smack.pitch_scale = pitch
		
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
	else:
		$AnimationPlayer.pause()
	$step.stream_paused = Global.paused
	$jump.stream_paused = Global.paused
	$land.stream_paused = Global.paused
	$grow.stream_paused = Global.paused
	$smack.stream_paused = Global.paused
	

func anim() -> void:
	if not inpt_power.x == 0: 
		$AnimationPlayer.play("walk")
		if inpt_power.x == 1:$atk.position.x = 0
		$texture/Sprite2D.flip_h = false
		if inpt_power.x == -1:
			$texture/Sprite2D.flip_h = true
	else:
		$AnimationPlayer.play("idle")

func _on_floor_body_entered(body: Node2D) -> void:
	$land.play()


func _on_timer_timeout() -> void:
	$atk/CollisionShape2D.disabled = true
