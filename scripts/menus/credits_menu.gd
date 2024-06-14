extends BaseMenu


@export var SCROLL_SPEED: float

var playing: bool = false

var was_visible: bool = false

var alternating: bool = false


func _back_input() -> void:
	menus.change_menu(menus.MAIN, false)
	get_viewport().set_input_as_handled()


func _on_back_pressed() -> void:
	menus.change_menu(menus.MAIN, false)


func perform_show_action() -> void:
	playing = false
	$CreditsWindow/ScrollContainer.scroll_vertical = 0
	await get_tree().create_timer(0.5).timeout
	playing = true


func perform_hide_action() -> void:
	playing = false
	
	
func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP) or Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		playing = false
		await get_tree().create_timer(0.5).timeout
		playing = true
	
	
func _physics_process(delta: float) -> void:
	if was_visible != visible:
		if visible:
			perform_show_action()
		else:
			perform_hide_action()
	was_visible = visible
	if playing:
		alternating = !alternating
		var multiplier: float = 1
		
		if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			multiplier = 4
		
		if alternating:
			$CreditsWindow/ScrollContainer.scroll_vertical += 2 * delta * SCROLL_SPEED * multiplier
