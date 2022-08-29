extends CanvasLayer


func change_scene(target: String, type: String = 'dissolve') -> void:
	visible = true
	show()
	if type == 'dissolve':
		transitionDissolve(target)
	else:
		transitionCloud(target)
	visible = false
	hide()

	
func transitionDissolve(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	yield($AnimationPlayer, 'animation_finished')
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards('dissolve')


func transitionCloud(target: String) -> void:
	$AnimationPlayer.play('clouds_in')
	yield($AnimationPlayer, 'animation_finished')
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards('clouds_out')
