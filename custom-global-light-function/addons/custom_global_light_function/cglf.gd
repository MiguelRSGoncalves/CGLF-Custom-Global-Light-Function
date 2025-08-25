@tool
extends Control

var _cglf_injection_path: String = "res://addons/custom_global_light_function/cglf.gdshaderinc"
var _blacklisted_files: Array[String] = []

var _cglf_injection_boiler_plate: String = "\n\n//CGLF - Custom Global Light Function\n"
var _cglf_injection_boiler_plate_ending: String = "\n//CGLF"

@export_category("Nodes")
@export var _cglf_inc_path_text_window : TextEdit = null
@export var _ignore_blacklist_checkbox : CheckBox = null
@export var _replace_existing_light_functions_checkbox : CheckBox = null
@export var _blacklist : ItemList = null
@export var _blacklist_input : TextEdit = null

func _ready() -> void:
	_cglf_inc_path_text_window.text = _cglf_injection_path
	_fill_blacklist_node()

func _update_shaders() -> void:
	var shader_files = _find_shader_files("res://")
	if shader_files.size() > 0:
		push_warning("CGLF: The following ERRORS, one per shader file updated, are expected and are part of the inner works of the plugin! Didn't find a way to not make them appear :(")
		var files_injected: int = _inject_custom_global_light_function(shader_files, _cglf_injection_path)
		print("CGLF: Added Custom Global Light Function to ", files_injected, " shaders!")
	else:
		print("CGLF: No shaders files found! Go create some!")

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
			var code: String = shader_file_resource.code
			var boilerplate_regex := RegEx.new()
			boilerplate_regex.compile("//CGLF - Custom Global Light Function\\n#include \".*\"\\n//CGLF")
			if boilerplate_regex.search(code):
				var include_regex := RegEx.new()
				include_regex.compile('#include ".*"')
				code = include_regex.sub(code, '#include "' + code_injection_path + '"', true)
			else:
				code += _cglf_injection_boiler_plate + '#include "' + code_injection_path + '"' + _cglf_injection_boiler_plate_ending
			
			shader_file_resource.code = code
			ResourceSaver.save(shader_file_resource, shader_file, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
			
			var fs_dock = EditorInterface.get_file_system_dock()
			fs_dock.file_removed.emit(shader_file)
			
			var fs = EditorInterface.get_resource_filesystem()
			fs.reimport_files([shader_file])
			counter += 1
	return counter

func _open_cglf_inc():
	if not FileAccess.file_exists(_cglf_injection_path):
		push_error("CGLF: Include file not found: %s" % _cglf_injection_path)
		return
	
	var _cglf_injection = load(_cglf_injection_path)
	if _cglf_injection:
		EditorInterface.edit_resource(_cglf_injection)
	else:
		push_error("CGLF: Failed to load ShaderInclude resource at: %s" % _cglf_injection_path)
		
func _cglf_copy_path_pressed() -> void:
	DisplayServer.clipboard_set(_cglf_injection_path)
	print("CGLF : CGLF Include file path copied to clipboard!")

func _on_cglf_inc_path_text_window_text_changed() -> void:
	_cglf_injection_path = _cglf_inc_path_text_window.text

func _add_blacklist_item():
	if _blacklist_input.text in _blacklisted_files:
		push_warning("CGLF: Shader file already blacklisted! You must really hate this one!!")
		return
	if(!FileAccess.file_exists(_blacklist_input.text)):
		push_error("CGLF: Shader file doesnt exist! Try another path!")
		return
	_blacklisted_files.append(_blacklist_input.text)
	_blacklist_input.clear()
	_fill_blacklist_node()

func _fill_blacklist_node():
	_blacklist.clear()
	for item in _blacklisted_files:
		_blacklist.add_item(item)
