tool
extends Control
class_name PBlinkEye


onready var position_2d = $TextureRect/Position2D
onready var texture_rect = $TextureRect
onready var tween = $Tween

var pos_list = [Vector2(274,290),Vector2(169,253),Vector2(276,190),Vector2(382,261)]

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.set_seed(rect_global_position.x + randf())
	while true:
		var pos = position_2d.position
		var new_pos = pos_list[rng.randi_range(0,pos_list.size()-1)]
		tween.interpolate_property(position_2d,"position",pos,new_pos,rand_range(0.4,1.0),Tween.TRANS_LINEAR,Tween.EASE_IN,rand_range(0.4,1.0))
		if randi() % 5 > 2:
			tween.interpolate_property(texture_rect,"material:shader_param/size",null,rand_range(1.0,1.5),rand_range(0.2,0.3),Tween.TRANS_LINEAR,Tween.EASE_IN,rand_range(0.1,0.2))

		if randi() % 5 > 2:
			tween.interpolate_property(texture_rect,"material:shader_param/offset2",Vector2(1.148,2.158),Vector2(1.148,10.0),0.05,Tween.TRANS_LINEAR,Tween.EASE_IN,0.0)
			tween.interpolate_property(texture_rect,"material:shader_param/offset2",Vector2(1.148,10.0),Vector2(1.148,2.158),0.05,Tween.TRANS_LINEAR,Tween.EASE_IN,0.1)
			tween.interpolate_property(texture_rect,"material:shader_param/offset3",0.764,2.72,0.05,Tween.TRANS_LINEAR,Tween.EASE_IN,0.0)
			tween.interpolate_property(texture_rect,"material:shader_param/offset3",2.72,0.764,0.05,Tween.TRANS_LINEAR,Tween.EASE_IN,0.1)
			
		tween.start()
		yield(tween,"tween_all_completed")
	
	

# 计算坐标点
func computePos():
	# 512,512 -0.5,0.5
	var pos = position_2d.position
	var size = texture_rect.rect_size
	var out_pos = Vector2(0,0)
	out_pos.x = range_lerp(pos.x,0.0,size.x,0.5,-0.5)
	out_pos.y = range_lerp(pos.y,0.0,size.y,0.5,-0.5)
	return out_pos


func _process(delta):
	if texture_rect:
		texture_rect.material.set("shader_param/offset",self.computePos())
