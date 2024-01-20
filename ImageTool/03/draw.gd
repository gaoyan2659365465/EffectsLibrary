extends Control

# 是否按下
var is_pressed
var is_pressed_right
# 画布
var texture_rect

onready var viewport = $Viewport
onready var drawing = $Viewport/Drawing
onready var drawing_2 = $Viewport/Drawing2
onready var drawing_3 = $CanvasLayer/Drawing3


func _ready():
	self.createTextureRect()

# 创建新的画布
func createTextureRect():
	self.texture_rect = TextureRect.new()
	self.add_child(texture_rect)
	
	var img = Image.new()
	var img_tex = ImageTexture.new()
	
	img.create(512,512,false,Image.FORMAT_RGBA8)
	img.fill(Color(1, 0, 0))
	
	img_tex.create_from_image(img)
	texture_rect.texture = img_tex
	
	texture_rect.connect("gui_input",self,"guiInputEvent")

# 画布的槽函数
func guiInputEvent(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.is_pressed = event.is_pressed()
		if event.button_index == BUTTON_RIGHT:
			self.is_pressed_right = event.is_pressed()
	if event is InputEventMouseMotion:
		if self.is_pressed:
			self.drawPen(false)
		if self.is_pressed_right:
			self.drawPen(true)

# 绘画操作
func drawPen(is_erase):
	var pos = self.get_local_mouse_position()
	
	var img = Image.new()
	img.create(50,50,false,Image.FORMAT_RGBA8)
	if is_erase:
		img.fill(Color(0, 0, 0, 0))
	else:
		img.fill(Color(0, 1, 0, 1))
	
	var random_float = randf()
	drawing.material.set_shader_param("angle",random_float)
	drawing_2.material.set_shader_param("angle",random_float)
	
	var pen_img = viewport.get_texture().get_data()
	
	var old_img_tex = texture_rect.texture
	var old_img = old_img_tex.get_data()
	
	if is_erase:
		old_img.blit_rect(img,Rect2(Vector2.ZERO,img.get_size()),pos-img.get_size()/2.0)
	else:
		old_img.blend_rect(pen_img,Rect2(Vector2.ZERO,pen_img.get_size()),pos-pen_img.get_size()/2.0)
	old_img_tex.set_data(old_img)
	
	
func _process(delta):
	var pos = self.get_local_mouse_position()
	drawing_3.rect_position = pos - drawing_3.rect_size/2.0
	


func _on_ColorPickerButton_color_changed(color):
	drawing.material.set_shader_param("color",color)
	drawing_2.material.set_shader_param("color",color)


func _on_HSlider_value_changed(value):
	drawing.rect_size = Vector2(value,value)
	drawing_2.rect_size = Vector2(value,value)
	drawing_3.rect_size = Vector2(value,value)
	viewport.size = Vector2(value,value)
