extends Camera2D
class_name DragCamera2D

# 鼠标右键拖拽区域
export(NodePath) var widget
onready var camera_control:Control = get_node(widget)


# 是否右键拖拽
var is_drag
# 鼠标按下时的位置
var pressed_mouse_pos = Vector2.ZERO

# 右键拖拽相机的原始位置
var camera_pos = Vector2.ZERO

func _ready():
	camera_control.connect("gui_input",self,"_on_gui_input")

func _on_gui_input(event):
	if event is InputEventMouseButton:
		self.pressed_mouse_pos = camera_control.get_global_mouse_position()
		if event.button_index == BUTTON_RIGHT:
			self.is_drag = event.is_pressed()
			if self.is_drag:
				# 记录拖拽前的原始相机坐标
				self.camera_pos = self.position
		# 鼠标滚轮缩放视角
		if event.button_index == BUTTON_WHEEL_UP:
			var _zoom = self.zoom - Vector2(0.02,0.02)
			if _zoom > Vector2(0.1,0.1):
				self.zoom = _zoom
		if event.button_index == BUTTON_WHEEL_DOWN :
			self.zoom = self.zoom + Vector2(0.02,0.02)
	if event is InputEventMouseMotion:
		if self.is_drag:
			var mouse_offset = camera_control.get_global_mouse_position() - self.pressed_mouse_pos
			self.position = self.camera_pos - mouse_offset

