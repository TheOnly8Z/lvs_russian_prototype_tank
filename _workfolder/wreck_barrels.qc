// Created by Crowbar 0.74

$modelname "8z/lvs/gibs/russian_prototype_tank_barrels.mdl"

$bodygroup "Body"
{
	studio "wreck_barrels.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

$cdmaterials "models\8z\lvs\russian_prototype_tank\"

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "wreck_barrels_physics.smd"
{
	$mass 300
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}
