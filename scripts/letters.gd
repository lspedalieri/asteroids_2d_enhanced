extends Sprite


func init(letter, font, scaling):
	texture = load(Global.letters_path + "/" + font + "/" + letter.letter + ".png")
	randomize()
	position = Vector2(rand_range(1, 1920), rand_range(1, 1080))
	#position = letter.start_coords
	scale.x = scaling
	scale.y = scaling
	move_to_coordinates(letter.end_coords, letter.time)
	
func move_to_coordinates(coords, t) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	var _test = tween.tween_property(self, "global_position", coords, t)
	yield(tween, "finished")

func composeAndMovePhrase(phrase, font):
	for i in phrase:
		print(i.letter)
		var text_letter : Sprite = Sprite.new()
		text_letter.Texture = load(Global.letters_path + "/" + font + "/" + i.letter + ".png")
		add_child(text_letter)
		text_letter.position = i.start_coords
	
	pass
