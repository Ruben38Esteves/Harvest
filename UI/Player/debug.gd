extends PanelContainer

var property
@onready var property_container: VBoxContainer = $MarginContainer/VBoxContainer

var fps : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.debug = self
	visible = false
	#add_debug_property("test", "test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#fps = "%.2" % (1/delta)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible
		
func add_debug_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
