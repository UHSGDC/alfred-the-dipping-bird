extends BaseMenu


const MAX_SCROLL: int = 905

@export var SCROLL_SPEED: float

var playing: bool = false :
	set(value):
		if fading_out or fading_in or !visible:
			playing = false
		else:
			playing = value
		#print(playing, " ", value)

var was_visible: bool = false

var alternating: bool = false
var fading_in: bool = false
var fading_out: bool = false


func _back_input() -> void:
	if !fading_out:
		menus.change_menu(menus.MAIN, false)
		get_viewport().set_input_as_handled()


func _on_back_pressed() -> void:
	menus.change_menu(menus.MAIN, false)

	
func _input(event: InputEvent) -> void:
	super(event)
	if (!fading_out and !fading_in) and (Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP) or Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN)):
		playing = false
		await get_tree().create_timer(0.5).timeout
		playing = true


func perform_show_action() -> void:
	playing = false
	$CreditsWindow/ScrollContainer.scroll_vertical = 0
	await get_tree().create_timer(0.5).timeout
	fading_in = false
	playing = true


func perform_hide_action() -> void:
	playing = false
	$CreditsWindow/ScrollContainer.scroll_vertical = 0
	
func _physics_process(delta: float) -> void:
	if !was_visible && visible && !fading_in:
		perform_show_action()
	elif was_visible && !visible:
		perform_hide_action()
	was_visible = visible
	if playing:
		alternating = !alternating
		var multiplier: float = 1
		
		if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			multiplier = 4
		
		if alternating:
			$CreditsWindow/ScrollContainer.scroll_vertical += 2 * delta * SCROLL_SPEED * multiplier
		elif $CreditsWindow/ScrollContainer.scroll_vertical >= MAX_SCROLL && !fading_out:
			playing = false
			fading_out = true
			scroll_finished()
			


func scroll_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	$Back.disabled = true
	await menus.credits_to_main()
	$Back.disabled = false
	fading_out = false
