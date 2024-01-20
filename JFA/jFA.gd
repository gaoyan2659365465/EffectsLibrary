extends Control


onready var texture_rect_demo = $TextureRect

export var voronoi_mat : Material = null
export var uv_mat : Material = null
export var image : Texture = null
signal jfa2(target)

func _ready():
	self.connect("jfa2",self,"_on_JumpFloodAlgorithm_jfa2")
	self.getTextureJFA2(image.get_data())

# 创建渲染目标
func createRenderTarget():
	var viewport = Viewport.new()
	self.add_child(viewport)
	viewport.hdr = false
	viewport.usage = Viewport.USAGE_2D
	viewport.render_target_v_flip = true
	var texture_rect = TextureRect.new()
	viewport.add_child(texture_rect)
	texture_rect.expand = true
	return [viewport,texture_rect]

# 获取图像的JFA算法求得的欧氏距离图(性能优化)
func getTextureJFA2(img:Image):
	var input = self.createRenderTarget()
	input[0].set_update_mode(Viewport.UPDATE_ALWAYS)
	input[0].set_size(img.get_size())
	input[1].set_size(img.get_size())
	input[1].set_material(uv_mat.duplicate())
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	input[1].texture = imgtex
	input[1].material.set_shader_param("u_input_tex", imgtex)

	var mate = voronoi_mat.duplicate()
	var imgage = null
	mate.set_shader_param("u_tex", imgtex)
	
	var passes = ceil(log(max(input[0].get_viewport().size.x, input[0].get_viewport().size.y)) / log(2.0))
	for i in range(0, passes):
		var offset = pow(2, passes - i - 1)
		#这是将数据从 GPU 内存复制到普通内存，然后再次返回 GPU 内存，因此成本非常高昂
		yield(VisualServer, "frame_post_draw")
		#yield(get_tree().create_timer(1.0), "timeout")
		imgage = input[0].get_texture().get_data()
		if i == 0:
			imgtex.set_data(imgage)
			input[1].set_material(mate)
		else:
			imgtex.set_data(imgage)
		mate.set_shader_param("u_offset", offset)
	#imgage.save_png("E:/CasualGame/a.png")
	emit_signal("jfa2",input[0].get_texture())


func _on_JumpFloodAlgorithm_jfa2(target):
	texture_rect_demo.texture = self.image
	texture_rect_demo.material.set_shader_param("sdf_img", target)
