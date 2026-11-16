extends SceneTree
## Clean-compile headless entry for the gdpackage_user suites, exiting with a CI code.
##     godot --headless --path . --script res://addons/_lib/gdpackage/user/_export_ignore/test/run_headless.gd

const SUITES:PackedStringArray = [
	"res://addons/_lib/gdpackage/user/_export_ignore/test/doc_index_test.gd",
	"res://addons/_lib/gdpackage/user/_export_ignore/test/doc_menu_test.gd",
	"res://addons/_lib/gdpackage/user/_export_ignore/test/doc_viewer_history_test.gd",
]


## Deferred: suites that host nodes need root in the tree, and it only enters after _initialize.
func _initialize() -> void:
	_run_suites.call_deferred()


func _run_suites() -> void:
	var success = true
	var output:Array[String] = []
	for path in SUITES:
		var script = load(path)
		if script == null: # a missing suite fails the run instead of halting it
			success = false
			output.append("FAIL  could not load " + path)
			continue
		var res:Dictionary = script.run_tests()
		success = success and res.result == 0
		output.append_array(res.output)

	print("\n".join(output))
	quit(0 if success else 1)
