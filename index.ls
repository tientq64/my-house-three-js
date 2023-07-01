load = (path, notExampleJsm) ->
	if notExampleJsm
		import "https://cdn.skypack.dev/three@0.134.0/#path.js"
	else
		import "https://cdn.skypack.dev/three@0.134.0/examples/jsm/#path.js"
local = (name) ->
	code = await (await fetch "local/#name.ls")text!
	code = livescript.compile code
	eval code

Three = await load \build/three.module yes
{ OrbitControls } = await load \controls/OrbitControls
Mosaic = await local \mosaic

scene = new Three.Scene

camera = new Three.PerspectiveCamera 75 innerWidth / innerHeight, 0.1 1000

renderer = new Three.WebGLRenderer
renderer.setSize innerWidth, innerHeight
renderer.shadowMap.enabled = yes
renderer.shadowMap.type = Three.PCFSoftShadowMap

document.body.appendChild renderer.domElement

camera.position.set 4 6 12

geo = new Three.BoxGeometry
mat = new Three.MeshToonMaterial do
	color: 0xcc0000
cube = new Three.Mesh geo, mat
cube.position.y = 1
cube.castShadow = yes
scene.add cube

geo = new Three.PlaneGeometry 10 10
mat = new Three.MeshToonMaterial do
	color: 0xeeeeee
land = new Three.Mesh geo, mat
land.rotation.x = -Math.PI / 2
land.receiveShadow = yes
scene.add land

ambLight = new Three.AmbientLight 0x333333
scene.add ambLight

dirLight = new Three.DirectionalLight 0xffffff 0.5
dirLight.position.set 16 33 51
dirLight.castShadow = yes
scene.add dirLight

control = new OrbitControls camera, renderer.domElement
control.update!

filter = new Mosaic scene, camera, renderer, 128 0.5

helper = new Three.GridHelper 10 10
scene.add helper

loader = new Three.ObjectLoader
loader.load \scene.json (obj) !~>
	obj.scale.set 0.25 0.25 0.25
	scene.add obj

do animate = !->
	requestAnimationFrame animate

	cube.rotation.x += 0.01
	cube.rotation.y += 0.01

	filter.update!
