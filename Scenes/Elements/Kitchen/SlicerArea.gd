extends Area3D

# TODO: Grabar y anyadir command al minijuego de cocina

signal element_cutted()

@onready var slicer = $"../Slicer"
@onready var cooldown: Timer = $CutCooldown
var cross_section_material = preload("res://Scenes/Elements/Kitchen/CarrotOrangeMaterial.tres")
var meshSlicer = MeshSlicer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_exited.connect(cutBody)

func cutBody(body: Node3D)-> void:
	if (body is RigidBody3D) == false:
		push_warning("Not RigidBody set in the CuttingLayer")
		return
	if cooldown.is_stopped() == false:
		return
	cooldown.start()

	#The plane transform at the rigidbody local transform
	var meshinstance = body.get_node("MeshInstance3D")
	var Transform = Transform3D.IDENTITY
	Transform.origin = meshinstance.to_local((slicer.global_transform.origin))
	Transform.basis.x = meshinstance.to_local((slicer.global_transform.basis.x+body.global_position))
	Transform.basis.y = meshinstance.to_local((slicer.global_transform.basis.y+body.global_position))
	Transform.basis.z = meshinstance.to_local((slicer.global_transform.basis.z+body.global_position))
	var collision = body.get_node("CollisionShape3D")
	
	#Slice the mesh
	var meshes = meshSlicer.slice_mesh(Transform,meshinstance.mesh,cross_section_material)
	
	#get mesh size
	var aabb = meshes[0].get_aabb()
	var aabb2 = meshes[1].get_aabb()
	#queue_free() if the mesh is too small
	if aabb2.size.length() < 0.1 || aabb.size.length() < 0.1:
		push_warning("Cut part too small")
		return
	meshinstance.mesh = meshes[0]
	
	#generate collision
	if len(meshes[0].get_faces()) > 2:
		collision.shape = meshes[0].create_convex_shape()

	#adjust the rigidbody center of mass
	body.center_of_mass_mode = 1
	body.center_of_mass = body.to_local(meshinstance.to_global(calculate_center_of_mass(meshes[0])))
	
	#second half of the mesh
	var body2 = body.duplicate()
	
	get_tree().get_first_node_in_group('CookingElementsNode').add_child(body2)
	meshinstance = body2.get_node("MeshInstance3D")
	collision = body2.get_node("CollisionShape3D")
	meshinstance.mesh = meshes[1]
	#generate collision
	if len(meshes[1].get_faces()) > 2:
		collision.shape = meshes[1].create_convex_shape()
		
	#adjust the rigidbody center of mass
	body2.center_of_mass = body2.to_local(meshinstance.to_global(calculate_center_of_mass(meshes[1])))
	body2.set_freeze_enabled(false)
	body2.set_collision_layer_value(3,true)
	body2.set_collision_mask_value(1,true)
	body2.set_collision_mask_value(2,true)
	body2.set_collision_mask_value(3,true)
	body2.set_collision_mask_value(17,true)
	body2.set_collision_mask_value(18,true)
	body2.add_to_group("cutted_" + body.name)
	emit_signal("element_cutted")
	#TODO - Give some feedback to the player

func calculate_center_of_mass(mesh:ArrayMesh):
	#Not sure how well this work
	var meshVolume = 0
	var temp = Vector3(0,0,0)
	for i in range(len(mesh.get_faces())/3):
		var v1 = mesh.get_faces()[i]
		var v2 = mesh.get_faces()[i+1]
		var v3 = mesh.get_faces()[i+2]
		var center = (v1 + v2 + v3) / 3
		var volume = (Geometry3D.get_closest_point_to_segment_uncapped(v3,v1,v2).distance_to(v3)*v1.distance_to(v2))/2
		meshVolume += volume
		temp += center * volume
	
	if meshVolume == 0:
		return Vector3.ZERO
	return temp / meshVolume
