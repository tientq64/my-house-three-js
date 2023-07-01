Nodes = await load \nodes/Nodes

class Mosaic
	(@scene, @camera, renderer, scale = 128, fade = 0.5) ->
		scr = new Nodes.ScreenNode
		uv = new Nodes.UVNode
		@scl = new Nodes.FloatNode scale
		@fad = new Nodes.FloatNode fade
		@frame = new Nodes.NodeFrame
		@nodepost = new Nodes.NodePostProcessing renderer
		blocks = new Nodes.OperatorNode uv, @scl, Nodes.OperatorNode.MUL
		blocksSize = new Nodes.MathNode blocks, Nodes.MathNode.FLOOR
		mosaicUV = new Nodes.OperatorNode blocksSize, @scl, Nodes.OperatorNode.DIV
		fadeScreen = new Nodes.MathNode uv, mosaicUV, @fad, Nodes.MathNode.MIX
		@nodepost.output = new Nodes.ScreenNode fadeScreen

	scale:~
		-> @scl.value
		(val) !-> @scl.value = val

	fade:~
		-> @fad.value
		(val) !-> @fad.value = val

	setScale: (val) !->
		@scale = val

	setFade: (val) !->
		@fade = val

	update: !->
		@frame.update!
		@nodepost.render @scene, @camera, @frame

return Mosaic
