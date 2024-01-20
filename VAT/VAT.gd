extends Node2D




onready var yumao = $Yumao

# 用来做动画用
var tween

func _ready():
	self.tween = Tween.new()
	self.add_child(tween)
	self.tween.interpolate_property(yumao, "material:shader_param/frame", 0.0, 100.0, 10, Tween.TRANS_LINEAR, Tween.EASE_IN)
	self.tween.start()



func _process(delta):
	pass
