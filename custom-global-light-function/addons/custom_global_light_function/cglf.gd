@tool
extends Control

var _cglf_injection_path: String = "res://addons/custom_global_light_function/cglf.gdshaderinc"

var _cglf_injection_boiler_plate: String = "\n\n//CGLF - Custom Global Light Function\n"
var _cglf_injection_boiler_plate_ending: String = "\n//CGLF\n"

func _on_button_pressed() -> void:
	var shader_files = _find_shader_files("res://")
	var files_injected: int = _inject_custom_global_light_function(shader_files, _cglf_injection_path)
	print("\nCGLF: Added Custom Global Light Function to ", files_injected, " shaders!\n")

func _find_shader_files(path: String) -> Array:
	var results: Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				results += _find_shader_files(path.path_join(file_name))
			elif file_name.ends_with(".gdshader") or file_name.ends_with(".shader"):
				results.append(path.path_join(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	return results

func _inject_custom_global_light_function(shader_files: Array, code_injection_path: String) -> int:
	var counter: int = 0
	for shader_file in shader_files:
		var shader_file_resource = ResourceLoader.load(shader_file, "Shader", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
		if shader_file_resource is Shader:
			counter += 1
			shader_file_resource.code += _cglf_injection_boiler_plate + '#include "' + code_injection_path + '"' + _cglf_injection_boiler_plate_ending
			ResourceSaver.save(shader_file_resource, shader_file, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
			
			var fs_dock = EditorInterface.get_file_system_dock()
			fs_dock.file_removed.emit(shader_file)
			
			var fs = EditorInterface.get_resource_filesystem()
			fs.reimport_files([shader_file])
	return counter

func _open_cglf_inc():
	print("OPEN")
	EditorInterface.edit_script(load(_cglf_injection_path))
