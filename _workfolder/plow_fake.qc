// Created by Crowbar 0.74

$modelname "8z/lvs/russian_prototype_tank_plow_fake.mdl"

$scale 0.5

$bodygroup "Body"
{
	studio "proto_newplow.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

$origin 100 0 17

$cdmaterials "models\8z\lvs\russian_prototype_tank\"

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "plow_physics.smd"
{
	$mass 100
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}