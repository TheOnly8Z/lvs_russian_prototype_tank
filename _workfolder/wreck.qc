// Created by Crowbar 0.74

$modelname "8z/lvs/russian_prototype_tank_wreck.mdl"

$bodygroup "Body"
{
	studio "wreck_body.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

$illumposition 88.451 -0.02 126.597

$cdmaterials "models\8z\lvs\russian_prototype_tank\"

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "wreck_body_physics.smd"
{
	$mass 2000
	$inertia 10
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}
