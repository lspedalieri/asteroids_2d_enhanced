extends Node2D

# Add a ColorRect or other Control set to fill the screen
# Place it lower in the tree and/or place in CanvasLayer
# so it's on top of the rest of the scene.
onready var blur = $Blur
var blur_amount = 0

func _process(delta):
	blur_amount = wrapf(blur_amount + 0.05, 0.0, 5.0)
	blur.material.set_shader_param("blur_amount", blur_amount)
