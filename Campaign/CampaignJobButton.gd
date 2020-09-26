extends Button
class_name CampaignJobButton

var job = null
signal selected_job(job)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_pressed_button")
	self.rect_min_size.x = 160
	self.rect_min_size.y = 160
	#$JobText.text = "blahblah"
	#print($JobText.text)

func _set_job(selected_job):
	print("selected_job is "+selected_job)
	job = globals.campaignLevels[selected_job]
	var buttontext = "Level: " + job['name'] + "\n"
	buttontext += "Experience: " + str(job['experienceEarned']) + "\n"
	buttontext += "Money: " + str(job['moneyEarned']) + "\n"
	var newLabel = Label.new()
	newLabel.align = 1
	newLabel.valign = 1
	newLabel.anchor_right = 1
	newLabel.anchor_bottom = 1
	newLabel.text = buttontext
	self.add_child(newLabel)
	#$JobText.text = buttontext
	

func _pressed_button():
	print(" in _pressed_button")
	emit_signal("selected_job", job)
