extends Node2D


onready var icon_2 = $Icon2
onready var color_rect = $CanvasLayer/ColorRect
onready var drag_camera_2d = $DragCamera2D




func _ready():
	pass


func _process(delta):
	var pos = icon_2.position
	# 场景坐标转成UI的坐标
	pos = drag_camera_2d.get_canvas_transform().xform(pos - Vector2(132.0/2.0,100))
	# UI坐标转成场景坐标
	#pos = drag_camera_2d.get_canvas_transform().affine_inverse().xform(pos)
	
	# 加入偏移
	color_rect.rect_position = pos
	color_rect.rect_scale = Vector2(1.0,1.0)/drag_camera_2d.zoom
