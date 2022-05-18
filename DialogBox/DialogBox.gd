# DialogBox.gd
extends RichTextLabel

var dialog = ["Hey, welcome to my dialog box! This is an incredibly long sentence designed to be skipped through by the user by pressing SPACE when the text is too boring or slow to read.", "Thank you for viewing my dialog box module!", "This is a third test page for you to test out moving through multiple pages. By now you have probably got bored of the text being written to the screen and so you probably want to hit SPACE to just breeze right past all of this nonesense spewing from my keyboard into your eyeballs."]
var page = 0

func _ready():
	set_text(dialog[page])
	set_visible_characters(0)

func _process(deltaTime):
	if Input.is_action_just_pressed("ui_accept"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_text(dialog[page])
				set_visible_characters(0)
		else:
			set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
