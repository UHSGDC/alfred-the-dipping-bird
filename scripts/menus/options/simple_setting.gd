@tool
extends HSplitContainer

const LENGTH_PER_CHAR: int = 12

signal value_changed(value)

enum Setting {
	NUMBER,
	PERCENT,
	STRING,
	SWITCH,
}

@export var setting_name: String

@export var setting_type: Setting
@export var initial_value: int

@export var value_string_array: PackedStringArray
@export var min_value: int
@export var max_value: int

@export var update_settings: bool : set = update_export_settings

var current_value
var current_value_index: int
var decrease_button: Button
var increase_button: Button


func _connect_button_signals() -> void:
	match setting_type:
		Setting.NUMBER:
			decrease_button.pressed.connect(_on_number_decreased)
			increase_button.pressed.connect(_on_number_increased)

		Setting.PERCENT:
			decrease_button.pressed.connect(_on_percent_decreased)
			increase_button.pressed.connect(_on_percent_increased)
			
		Setting.STRING:
			decrease_button.pressed.connect(_on_string_decreased)
			increase_button.pressed.connect(_on_string_increased)
			
		Setting.SWITCH:
			decrease_button.pressed.connect(_on_switch_decreased)
			increase_button.pressed.connect(_on_switch_increased)


func _ready() -> void:
	update()


func update_export_settings(_value: bool) -> void:
	update_settings = false
	update()
				
	
func update() -> void:
	decrease_button = $Button/Decrease
	increase_button = $Button/Increase
	increase_button.disabled = false
	decrease_button.disabled = false
	$Label.text = setting_name
	_update_button()


func reset_button() -> void:
	match setting_type:
		Setting.NUMBER:
			current_value = int(clamp(current_value, min_value, max_value))
			
			if current_value >= max_value:
				increase_button.disabled = true
				current_value = max_value
			if current_value <= min_value:
				decrease_button.disabled = true
				current_value = min_value
			
			$Button/Value.custom_minimum_size.x = len(str(max_value)) * LENGTH_PER_CHAR
			
			_update_label(str(current_value))
			
		Setting.PERCENT:
			current_value = int(clamp(current_value, 0, 100))
			
			if current_value >= 100:
				increase_button.disabled = true
				current_value = 100
			elif current_value <= 0:
				decrease_button.disabled = true
				current_value = 0
			
			$Button/Value.custom_minimum_size.x = 4 * LENGTH_PER_CHAR
			
			_update_label(str(current_value) + "%")
			
		Setting.STRING:
			
			current_value_index = current_value
			
			if current_value_index >= value_string_array.size() - 1:
				increase_button.disabled = true
				current_value_index = value_string_array.size() - 1
				
			if current_value_index <= 0:
				decrease_button.disabled = true
				current_value_index = 0
				
			current_value = str(value_string_array[current_value_index])
			
			for value in value_string_array:
				$Button/Value.custom_minimum_size.x = max($Button/Value.custom_minimum_size.x, value.length() * LENGTH_PER_CHAR)
				
			_update_label(current_value)
			
		Setting.SWITCH:
			current_value = bool(current_value)
			
			if current_value:
				_update_label("On")
				increase_button.disabled = true
			else:
				_update_label("Off")
				decrease_button.disabled = true
			
			$Button/Value.custom_minimum_size.x = 3 * LENGTH_PER_CHAR


func _update_button() -> void:
	match setting_type:
		Setting.NUMBER:
			current_value = int(clamp(initial_value, min_value, max_value))
			
			if current_value >= max_value:
				increase_button.disabled = true
				current_value = max_value
			if current_value <= min_value:
				decrease_button.disabled = true
				current_value = min_value
			
			$Button/Value.custom_minimum_size.x = len(str(max_value)) * LENGTH_PER_CHAR
			
			_update_label(str(current_value))
			
		Setting.PERCENT:
			current_value = int(clamp(initial_value, 0, 100))
			
			if current_value >= 100:
				increase_button.disabled = true
				current_value = 100
			elif current_value <= 0:
				decrease_button.disabled = true
				current_value = 0
			
			$Button/Value.custom_minimum_size.x = 4 * LENGTH_PER_CHAR
			
			_update_label(str(current_value) + "%")
			
		Setting.STRING:
			
			current_value_index = initial_value
			
			if current_value_index >= value_string_array.size() - 1:
				increase_button.disabled = true
				current_value_index = value_string_array.size() - 1
				
			if current_value_index <= 0:
				decrease_button.disabled = true
				current_value_index = 0
				
			current_value = str(value_string_array[current_value_index])
			
			for value in value_string_array:
				$Button/Value.custom_minimum_size.x = max($Button/Value.custom_minimum_size.x, value.length() * LENGTH_PER_CHAR)
				
			_update_label(current_value)
			
		Setting.SWITCH:
			current_value = bool(initial_value)
			
			if current_value:
				_update_label("On")
				increase_button.disabled = true
			else:
				_update_label("Off")
				decrease_button.disabled = true
			
			$Button/Value.custom_minimum_size.x = 3 * LENGTH_PER_CHAR
			


func _update_label(text: String) -> void:
	$Button/Value.text = text
	if !Engine.is_editor_hint():
		value_changed.emit(current_value)


func _on_number_decreased() -> void:
	increase_button.disabled = false
	current_value -= 1
	
	if current_value <= min_value:
		current_value = min_value
		decrease_button.disabled = true
	
	_update_label(str(current_value))
	

func _on_number_increased() -> void:
	decrease_button.disabled = false
	current_value += 1
	
	if current_value >= max_value:
		current_value = max_value
		increase_button.disabled = true
		
	_update_label(str(current_value))


func _on_percent_decreased() -> void:
	increase_button.disabled = false
	current_value -= 1
	
	if current_value <= 0:
		current_value = 0
		decrease_button.disabled = true
		
	_update_label(str(current_value) + "%")
	

func _on_percent_increased() -> void:
	decrease_button.disabled = false
	current_value += 1
	
	if current_value >= 100:
		current_value = 100
		increase_button.disabled = true
		
	_update_label(str(current_value) + "%")


func _on_string_decreased() -> void:
	increase_button.disabled = false
	current_value_index -= 1
	
	if current_value_index <= 0:
		current_value_index = 0
		decrease_button.disabled = true
		
	current_value = value_string_array[current_value_index]
		
	_update_label(current_value)
	

func _on_string_increased() -> void:
	decrease_button.disabled = false
	current_value_index += 1
	
	if current_value_index >= value_string_array.size() - 1:
		current_value_index = value_string_array.size() - 1
		increase_button.disabled = true
		
	current_value = value_string_array[current_value_index]
		
	_update_label(current_value)
	
	
func _on_switch_decreased() -> void:
	decrease_button.disabled = true
	increase_button.disabled = false
	
	current_value = false
	_update_label("Off")
	

func _on_switch_increased() -> void:
	increase_button.disabled = true
	decrease_button.disabled = false
	
	current_value = true
	_update_label("On")



func _on_tree_entered() -> void:
	if decrease_button:
		return
	decrease_button = $Button/Decrease
	increase_button = $Button/Increase
	_connect_button_signals()
