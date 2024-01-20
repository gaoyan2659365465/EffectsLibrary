tool
extends EditorPlugin

var scene_menu

static func find_child_by_class(node:Node, cls:String):
	var child_list = []
	for child in node.get_children():
		if child.get_class() == cls:
			child_list.append(child)
	return child_list

func _enter_tree():
	var base = get_editor_interface().get_base_control()
	var scene_tree_dock = base.find_node("Scene", true, false)
	scene_menu = find_child_by_class(scene_tree_dock,"PopupMenu")
	scene_menu[1].connect("about_to_show",self,"menu_changed")
	scene_menu[1].connect("id_pressed",self,"id_pressed")
	
	

func menu_changed():
	if scene_menu[1].get_item_count() == 0:
		return
	var name = scene_menu[1].get_item_text(clamp(scene_menu[1].get_item_count() - 1,0,9999))
	var m:PopupMenu = scene_menu[1]
	if name == "删除节点":
		var nodes = get_editor_interface().get_selection().get_selected_nodes()
		if nodes[0] as MeshInstance2D:
			m.add_item("Load Blender Mesh",99)#不能超过100
 

func loadJson():
	var file = File.new()
	file.open("C://Users//yanyan//Desktop//godot//mesh.json", File.READ)
	var data = parse_json(file.get_as_text())
	return data

func id_pressed(id):
	if id == 99:
		print("加载json模型文件")
		var nodes = get_editor_interface().get_selection().get_selected_nodes()
		var data = self.loadJson()
		
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var n=0
		for i in data["polygons"]:
			var vertices = PoolVector3Array()
			var uv = PoolVector2Array()
			var color = PoolColorArray()
			var uv2 = PoolVector2Array()
			var polygons = PoolIntArray()
			vertices.push_back(Vector3(data["vertices"][i[0]][0],data["vertices"][i[0]][1],data["vertices"][i[0]][2]) )
			vertices.push_back(Vector3(data["vertices"][i[1]][0],data["vertices"][i[1]][1],data["vertices"][i[1]][2]) )
			vertices.push_back(Vector3(data["vertices"][i[2]][0],data["vertices"][i[2]][1],data["vertices"][i[2]][2]) )
			uv.push_back(Vector2(data["uv_0"][n][0],data["uv_0"][n][1]))
			uv.push_back(Vector2(data["uv_0"][n+1][0],data["uv_0"][n+1][1]))
			uv.push_back(Vector2(data["uv_0"][n+2][0],data["uv_0"][n+2][1]))
			
			if data.has("uv_1"):
				uv2.push_back(Vector2(data["uv_1"][n][0],data["uv_1"][n][1]))
				uv2.push_back(Vector2(data["uv_1"][n+1][0],data["uv_1"][n+1][1]))
				uv2.push_back(Vector2(data["uv_1"][n+2][0],data["uv_1"][n+2][1]))
				color.push_back(Color(data["uv_1"][n][0],data["uv_1"][n][1],0.0,1.0))
				color.push_back(Color(data["uv_1"][n+1][0],data["uv_1"][n+1][1],0.0,1.0))
				color.push_back(Color(data["uv_1"][n+2][0],data["uv_1"][n+2][1],0.0,1.0))
			st.add_triangle_fan(vertices,uv,color,uv2)
			n=n+3
			nodes[0].mesh = st.commit()
		print(nodes)


func _exit_tree():
	pass
