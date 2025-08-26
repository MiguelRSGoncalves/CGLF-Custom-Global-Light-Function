@tool
extends EditorPlugin

var dock : Control

func _enter_tree() -> void:
	_register_project_setting("cglf/inc_path", "res://addons/custom_global_light_function/cglf.gdshaderinc")
	_register_project_setting("cglf/ignore_blacklist", false)
	_register_project_setting("cglf/replace_existing_light_functions", false)
	_register_project_setting("cglf/blacklist", PackedStringArray())
	
	dock = preload("res://addons/custom_global_light_function/cglf.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
	
func _register_project_setting(name: String, default_value, hint: int = PROPERTY_HINT_NONE, hint_string: String = ""):
	if not ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, default_value)
	ProjectSettings.set_initial_value(name, default_value)
	ProjectSettings.add_property_info({
		"name": name,
		"type": typeof(default_value),
		"hint": hint,
		"hint_string": hint_string
	})
