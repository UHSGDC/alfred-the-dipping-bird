extends Control

signal finished

# TODO: SCREENSHAKE, DREAM_TO_REAL_LIFE_TRANSITION

enum {
	INSTANT,
	FAST,
	MEDIUM,
	SLOW,
	VERY_SLOW,
	WAIT_FOR_PLAYER,
	CLEAR,
	ENABLE_SKIPPING,
	DISABLE_SKIPPING,
	DREAM_TO_REAL_LIFE_TRANSITION,
	YES_BUTTON,
}

# Dialog is stored as a series of commands. A string will output text. A speed will set the speed of the dialog. A float will wait the indicated amount of seconds. Commands
@onready var dialog_commands: Array = [
	CLEAR, FAST, "?: Come on little bro! ", 0.5, "Let's go dip our beaks in the lake. ", 0.2, "It's just over this hill.",
	WAIT_FOR_PLAYER, CLEAR, MEDIUM, "?: Oh, you want to take a nap. ", 0.4, "Well, I’m still gonna go dipping. ", 0.4, FAST, "Bye!",
	WAIT_FOR_PLAYER, CLEAR, MEDIUM, "What ? didn’t know was that that \"Bye!\" ", 0.3, SLOW, "would be for far longer than he realized.", DREAM_TO_REAL_LIFE_TRANSITION,
	CLEAR, INSTANT, "Alfred!",
	WAIT_FOR_PLAYER, CLEAR, INSTANT, "Alfred! ", 0.5, FAST, "Wake up!",
	WAIT_FOR_PLAYER, CLEAR, MEDIUM, "You’ve been asleep for 100 years. ", 0.4, "The world needs you. ", 
	WAIT_FOR_PLAYER, CLEAR, FAST, "Wake up! ", 0.4, MEDIUM, "Have you forgotten who you are?",
	WAIT_FOR_PLAYER, CLEAR, SLOW, "You are ", 0.4, VERY_SLOW, "ALFRED THE DIPPING BIRD",
	WAIT_FOR_PLAYER, CLEAR, FAST, "The world is on the verge of destruction", 0.4, MEDIUM, ", for its lakes have not been dipped in years. ", 0.5, FAST, CLEAR, "The Roman Empire has collapsed. ", 0.2, "The Shire is the new Mordor. ", 0.2, "Bandits run the streets. ", 0.2, "Everywhere you go there is chaos.",
	WAIT_FOR_PLAYER, CLEAR, "The world needs its hero.\n", 0.2, "The world needs Alfred.\n", 0.4, MEDIUM, "Will you fight for the world?",
	WAIT_FOR_PLAYER, YES_BUTTON, CLEAR, SLOW, "Good luck hero...\n\n", 1.0, "The world needs you"
]

var skipping_enabled: bool = true
var text_delay: float = 0
var dialog_playing: bool = false
var skip_input: bool = false

@onready var dialog_box: Panel = $DialogBox
@onready var output: Label = $DialogBox/Output
@onready var text_timer: Timer = $TextTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var next_icon: Node2D = $DialogBox/NextIcon

func dream_to_real_life_transition() -> void:
	$AnimationPlayer.play("dream_to_real_life")
	await $AnimationPlayer.animation_finished


func play() -> void:
	dialog_playing = true
	$DreamBackground/AnimationPlayer.play("rgb")
	for command in dialog_commands:
		if !visible:
			break
		if !skip_input:
			await wait_while_paused()
		if command is String:
			if skip_input:
				output.text += command
				output.visible_characters = output.text.length()
			else:
				await output_text(command)
		elif command is float:
			if !skip_input:
				wait_timer.start(command)
				await wait_timer.timeout
		else:
			match command:
				# Dialog commands
				CLEAR:
					skip_input = false
					output.text = ""
					output.visible_characters = 0
				WAIT_FOR_PLAYER:
					next_icon.activate()
					skip_input = false
					await next_icon.finished
				ENABLE_SKIPPING:
					skipping_enabled = true
				DISABLE_SKIPPING:
					skipping_enabled = false
					skip_input = false
				# Special commands
				DREAM_TO_REAL_LIFE_TRANSITION:
					await dream_to_real_life_transition()
				# Speed commands
				INSTANT:
					text_delay = 0
				FAST:
					text_delay = 0.02
				MEDIUM:
					text_delay = 0.04
				SLOW:
					text_delay = 0.1
				VERY_SLOW:
					text_delay = 0.2
	dialog_playing = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 2)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_interval(0.6)
	await tween.finished
	finished.emit()
	

func output_text(text: String) -> void:
	output.visible_characters = output.text.length()
	output.text += text
	if text_delay == 0:
		output.visible_characters = output.text.length()
		return
	for character in text:
		output.visible_characters += 1
		await wait_while_paused()
		if skip_input:
			output.visible_characters = output.text.length()
			return
		text_timer.start(text_delay)
		await text_timer.timeout


func wait_while_paused() -> void:
	while get_tree().paused:
		await get_tree().create_timer(0).timeout
	await get_tree().create_timer(0).timeout


func _input(event: InputEvent) -> void:
	if !dialog_playing:
		return
	if event.is_action_pressed("interact"):
		if next_icon.active:
			next_icon.next()
		elif skipping_enabled:
			text_timer.timeout.emit()
			wait_timer.timeout.emit()
			skip_input = true
		get_viewport().set_input_as_handled()
