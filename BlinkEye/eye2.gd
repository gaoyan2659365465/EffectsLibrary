tool
extends ColorRect


onready var position_2d = $Position2D




func _ready():
	pass


# 计算坐标点
func computePos():
	# 512,512 -0.5,0.5
	var pos = position_2d.position
	var size = self.rect_size
	var out_pos = Vector2(0,0)
	out_pos.x = range_lerp(pos.x,0.0,size.x,0.5,-0.5)
	out_pos.y = range_lerp(pos.y,0.0,size.y,0.5,-0.5)
	return out_pos


func _process(delta):
	self.material.set("shader_param/pos",self.computePos())
