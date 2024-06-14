extends RigidBody2D


func _ready() -> void:
	$Passenger1.visible = randi_range(0, 1) == 1
	$Passenger1.frame = randi_range(0, 1)
	$Passenger1/Shirt.frame = randi_range(0, 5)
	$Passenger1/Hair.frame = randi_range(0, 7)
	$Passenger2.visible = randi_range(0, 1) == 1
	$Passenger2.frame = randi_range(0, 1)
	$Passenger2/Shirt.frame = randi_range(0, 5)
	$Passenger2/Hair.frame = randi_range(0, 7)
