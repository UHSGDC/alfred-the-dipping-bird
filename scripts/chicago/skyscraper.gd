@tool
extends StaticBody2D

@export_range(0,3) var skyscraper_type: int = 0 :
	set(value):
		skyscraper_type = value
		hide_and_disable_all()
		match value:
			0:
				$Sprite2D.show()
				$CollisionShape2D.show()
				$CollisionShape2D2.show()
				$CollisionShape2D.disabled = false
				$CollisionShape2D2.disabled = false
			1:
				$Sprite2D2.show()
				$CollisionShape2D3.show()
				$CollisionShape2D3.disabled = false
			2:
				$Sprite2D3.show()
				$CollisionShape2D4.show()
				$CollisionShape2D5.show()
				$CollisionShape2D4.disabled = false
				$CollisionShape2D5.disabled = false
			3:
				$Sprite2D4.show()
				$CollisionShape2D6.show()
				$CollisionShape2D6.disabled = false				


func hide_and_disable_all() -> void:
	for child in get_children():
		child.hide()
		if child is CollisionShape2D:
			child.disabled = true
