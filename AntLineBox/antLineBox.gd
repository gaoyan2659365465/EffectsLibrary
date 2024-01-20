extends Control


onready var color_rect = $ColorRect
# 鼠标是否按下
var is_pressed = false
# 鼠标按下时的位置
var pressed_mouse_pos = Vector2.ZERO


func _on_AntLineBox_gui_input(event):
	if event is InputEventMouseButton:
		self.is_pressed = event.pressed
		self.pressed_mouse_pos = get_global_mouse_position()
	if event is InputEventMouseMotion:
		if self.is_pressed:
			var mouse_pos = get_global_mouse_position()
			var mouse_offset = mouse_pos - self.pressed_mouse_pos
			var pos = Vector2.ZERO
			pos = self.pressed_mouse_pos
			if mouse_offset.x < 0:
				pos.x = mouse_pos.x
			if mouse_offset.y < 0:
				pos.y = mouse_pos.y
			
			color_rect.set_position(pos)
			color_rect.set_size(mouse_offset.abs())
			color_rect.material.set_shader_param("pos", pos)
			color_rect.material.set_shader_param("size", mouse_offset.abs())
