// Created by Crowbar 0.74

$modelname "8z/lvs/russian_prototype_tank.mdl"

$bodygroup "Body"
{
	studio "proto_body.smd"
}
$bodygroup "Plow"
{
	blank
	studio "proto_newplow.smd"
}
$bodygroup "Remote Weapons System"
{
	studio "proto_nsvt_rows.smd"
	studio "proto_right_hatch.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

$illumposition 88.451 -0.02 126.597

// $cdmaterials "models\drgordon\black_ops_2\blyat\"
$cdmaterials "models\8z\lvs\russian_prototype_tank\"

$attachment "turret_left" "barrel_left" 0 -24 0 rotate 0 -90 0
$attachment "turret_right" "barrel_right" 0 -24 0 rotate 0 -90 0
$attachment "turret_viewport" "turret" 20.00 -70.50 21.00 rotate -0 0 0

$attachment "mg_muzzle" "nsvt_mg" 74.00 5.00 0.00 rotate -0 0 -90
$attachment "mg_viewport" "nsvt_turret" 16.00 3.5 0 rotate 0 0 -90

$attachment "smoke_l1" "turret" 80.00 75.00 0.00 rotate -45 30 0
$attachment "smoke_l2" "turret" -20.00 120.00 0.00 rotate -45 120 0
$attachment "smoke_r1" "turret" 80.00 -75.00 0.00 rotate -45 -30 0
$attachment "smoke_r2" "turret" -20.00 -120.00 0.00 rotate -45 -120 0
$attachment "smoke_top" "turret" 40.00 76.00 32.00 rotate -30 0 0

$attachment "vehicle_suspension_l_1" "suspension_left_02" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_l_2" "suspension_left_03" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_l_3" "suspension_left_04" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_l_4" "suspension_left_05" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_l_5" "suspension_left_06" 0 0 0 rotate 0 0 0

$attachment "vehicle_suspension_r_1" "suspension_right_02" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_r_2" "suspension_right_03" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_r_3" "suspension_right_04" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_r_4" "suspension_right_05" 0 0 0 rotate 0 0 0
$attachment "vehicle_suspension_r_5" "suspension_right_06" 0 0 0 rotate 0 0 0


$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}
$animation neutral "anims/idle.smd" frames 0 0

$poseparameter "turret_pitch" -5 15
$weightlist turret_pitch { "barrel" 1.0 }
$animation pitch1 "anims/poses" frame 6 6 subtract neutral 0 weightlist turret_pitch
$animation pitch3 "anims/poses" frame 7 7 subtract neutral 0 weightlist turret_pitch
$sequence turret_pitch { pitch1 pitch3 blendwidth 2 blend "turret_pitch" -5 15 } weightlist turret_pitch delta autoplay

$poseparameter "turret_yaw" 0 360 loop 360 wrap
$weightlist turret_yaw { "turret" 1.0 }
$animation turret_yaw1 "anims/poses" frame 0 0 subtract neutral 0 weightlist turret_yaw
$animation turret_yaw2 "anims/poses" frame 3 3 subtract neutral 0 weightlist turret_yaw
$animation turret_yaw3 "anims/poses" frame 4 4 subtract neutral 0 weightlist turret_yaw
$animation turret_yaw4 "anims/poses" frame 5 5 subtract neutral 0 weightlist turret_yaw
$animation turret_yaw5 "anims/poses" frame 0 0 subtract neutral 0 weightlist turret_yaw
$sequence turret_yaw { turret_yaw1 turret_yaw2 turret_yaw3 turret_yaw4 turret_yaw5 blendwidth 5 blend "turret_yaw" 0 360 } weightlist turret_yaw delta autoplay


$poseparameter "mg_pitch" -25 45
$weightlist mg_pitch { "nsvt_mg" 1.0 }
$animation mg_pitch1 "anims/poses" frame 16 16 subtract neutral 0 weightlist mg_pitch
$animation mg_pitch3 "anims/poses" frame 17 17 subtract neutral 0 weightlist mg_pitch
$sequence mg_pitch { mg_pitch1 mg_pitch3 blendwidth 2 blend "mg_pitch" -25 45 } weightlist mg_pitch delta autoplay

$poseparameter "mg_yaw" 0 360 loop 360 wrap
$weightlist mg_yaw { "nsvt_turret" 1.0 }
$animation mg_yaw1 "anims/poses" frame 12 12 subtract neutral 0 weightlist mg_yaw
$animation mg_yaw2 "anims/poses" frame 13 13 subtract neutral 0 weightlist mg_yaw
$animation mg_yaw3 "anims/poses" frame 14 14 subtract neutral 0 weightlist mg_yaw
$animation mg_yaw4 "anims/poses" frame 15 15 subtract neutral 0 weightlist mg_yaw
$animation mg_yaw5 "anims/poses" frame 12 12 subtract neutral 0 weightlist mg_yaw
$sequence mg_yaw { mg_yaw1 mg_yaw2 mg_yaw3 mg_yaw4 mg_yaw5 blendwidth 5 blend "mg_yaw" 0 360 } weightlist mg_yaw delta autoplay

$poseparameter "spin_wheels_right" -180 180 loop 360
$weightlist r_spin {
	"wheel_right_01" 1.0
	"wheel_right_02" 1.0
	"wheel_right_03" 1.0
	"wheel_right_04" 1.0
	"wheel_right_05" 1.0
	"wheel_right_06" 1.0
	"wheel_right_07" 1.0
}
$animation r_spin1 "anims/poses" frame 8 8 subtract neutral 0 weightlist r_spin
$animation r_spin2 "anims/poses" frame 9 9 subtract neutral 0 weightlist r_spin
$animation r_spin3 "anims/poses" frame 10 10 subtract neutral 0 weightlist r_spin
$animation r_spin4 "anims/poses" frame 11 11 subtract neutral 0 weightlist r_spin
$animation r_spin5 "anims/poses" frame 12 12 subtract neutral 0 weightlist r_spin
$sequence spin_wheels_right { r_spin1 r_spin2 r_spin3 r_spin4 r_spin5 blendwidth 5 blend "spin_wheels_right" -180 180 } weightlist r_spin delta autoplay

$poseparameter "spin_wheels_left" -180 180 loop 360
$weightlist l_spin {
	"wheel_left_01" 1.0
	"wheel_left_02" 1.0
	"wheel_left_03" 1.0
	"wheel_left_04" 1.0
	"wheel_left_05" 1.0
	"wheel_left_06" 1.0
	"wheel_left_07" 1.0
}
$animation l_spin1 "anims/poses" frame 8 8 subtract neutral 0 weightlist l_spin
$animation l_spin2 "anims/poses" frame 9 9 subtract neutral 0 weightlist l_spin
$animation l_spin3 "anims/poses" frame 10 10 subtract neutral 0 weightlist l_spin
$animation l_spin4 "anims/poses" frame 11 11 subtract neutral 0 weightlist l_spin
$animation l_spin5 "anims/poses" frame 12 12 subtract neutral 0 weightlist l_spin
$sequence spin_wheels_left { l_spin1 l_spin2 l_spin3 l_spin4 l_spin5 blendwidth 5 blend "spin_wheels_left" -180 180 } weightlist l_spin delta autoplay

$poseparameter "suspension_right_1" 0 14 loop 0
$weightlist sus_r1 {
	"treads_right_02_top" 1.0
	"treads_right_02" 1.0
	"wheel_right_02" 1.0
}
$animation sus_r1_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_r1
$animation sus_r1_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_r1
$sequence sus_r1 { sus_r1_min sus_r1_max blendwidth 2 blend "suspension_right_1" 0 14 } weightlist sus_r1 delta autoplay

$poseparameter "suspension_right_2" 0 14 loop 0
$weightlist sus_r2 {
	"treads_right_03_top" 1.0
	"treads_right_03" 1.0
	"wheel_right_03" 1.0
}
$animation sus_r2_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_r2
$animation sus_r2_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_r2
$sequence sus_r2 { sus_r2_min sus_r2_max blendwidth 2 blend "suspension_right_2" 0 14 } weightlist sus_r2 delta autoplay

$poseparameter "suspension_right_3" 0 14 loop 0
$weightlist sus_r3 {
	"treads_right_04_top" 1.0
	"treads_right_04" 1.0
	"wheel_right_04" 1.0
}
$animation sus_r3_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_r3
$animation sus_r3_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_r3
$sequence sus_r3 { sus_r3_min sus_r3_max blendwidth 2 blend "suspension_right_3" 0 14 } weightlist sus_r3 delta autoplay

$poseparameter "suspension_right_4" 0 14 loop 0
$weightlist sus_r4 {
	"treads_right_05_top" 1.0
	"treads_right_05" 1.0
	"wheel_right_05" 1.0
}
$animation sus_r4_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_r4
$animation sus_r4_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_r4
$sequence sus_r4 { sus_r4_min sus_r4_max blendwidth 2 blend "suspension_right_4" 0 14 } weightlist sus_r4 delta autoplay

$poseparameter "suspension_right_5" 0 14 loop 0
$weightlist sus_r5 {
	"treads_right_06_top" 1.0
	"treads_right_06" 1.0
	"wheel_right_06" 1.0
}
$animation sus_r5_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_r5
$animation sus_r5_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_r5
$sequence sus_r5 { sus_r5_min sus_r5_max blendwidth 2 blend "suspension_right_5" 0 14 } weightlist sus_r5 delta autoplay


$poseparameter "suspension_left_1" 0 14 loop 0
$weightlist sus_l1 {
	"treads_left_02_top" 1.0
	"treads_left_02" 1.0
	"wheel_left_02" 1.0
}
$animation sus_l1_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_l1
$animation sus_l1_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_l1
$sequence sus_l1 { sus_l1_min sus_l1_max blendwidth 2 blend "suspension_left_1" 0 14 } weightlist sus_l1 delta autoplay

$poseparameter "suspension_left_2" 0 14 loop 0
$weightlist sus_l2 {
	"treads_left_03_top" 1.0
	"treads_left_03" 1.0
	"wheel_left_03" 1.0
}
$animation sus_l2_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_l2
$animation sus_l2_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_l2
$sequence sus_l2 { sus_l2_min sus_l2_max blendwidth 2 blend "suspension_left_2" 0 14 } weightlist sus_l2 delta autoplay

$poseparameter "suspension_left_3" 0 14 loop 0
$weightlist sus_l3 {
	"treads_left_04_top" 1.0
	"treads_left_04" 1.0
	"wheel_left_04" 1.0
}
$animation sus_l3_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_l3
$animation sus_l3_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_l3
$sequence sus_l3 { sus_l3_min sus_l3_max blendwidth 2 blend "suspension_left_3" 0 14 } weightlist sus_l3 delta autoplay

$poseparameter "suspension_left_4" 0 14 loop 0
$weightlist sus_l4 {
	"treads_left_05_top" 1.0
	"treads_left_05" 1.0
	"wheel_left_05" 1.0
}
$animation sus_l4_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_l4
$animation sus_l4_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_l4
$sequence sus_l4 { sus_l4_min sus_l4_max blendwidth 2 blend "suspension_left_4" 0 14 } weightlist sus_l4 delta autoplay

$poseparameter "suspension_left_5" 0 14 loop 0
$weightlist sus_l5 {
	"treads_left_06_top" 1.0
	"treads_left_06" 1.0
	"wheel_left_06" 1.0
}
$animation sus_l5_min "anims/poses" frame 1 1 subtract neutral 0 weightlist sus_l5
$animation sus_l5_max "anims/poses" frame 2 2 subtract neutral 0 weightlist sus_l5
$sequence sus_l5 { sus_l5_min sus_l5_max blendwidth 2 blend "suspension_left_5" 0 14 } weightlist sus_l5 delta autoplay

$poseparameter "hatch_driver" 0 1 loop 0
$weightlist hatch_driver {
	"hatch_driver" 1.0
}
$animation hatch_driver1 "anims/poses" frame 19 19 subtract neutral 0 weightlist hatch_driver
$animation hatch_driver2 "anims/poses" frame 20 20 subtract neutral 0 weightlist hatch_driver
$sequence hatch_driver { hatch_driver1 hatch_driver2 blendwidth 2 blend "hatch_driver" 0 1 } weightlist hatch_driver delta autoplay

$poseparameter "hatch_turret" 0 1 loop 0
$weightlist hatch_turret {
	"top_hatch" 1.0
}
$animation hatch_turret1 "anims/poses" frame 19 19 subtract neutral 0 weightlist hatch_turret
$animation hatch_turret2 "anims/poses" frame 20 20 subtract neutral 0 weightlist hatch_turret
$sequence hatch_turret { hatch_turret1 hatch_turret2 blendwidth 2 blend "hatch_turret" 0 1 } weightlist hatch_turret delta autoplay

$sequence "fire" {
	"anims\fire.smd"
	fadein 0.1
	fadeout 0.5
	fps 30
}
$sequence "fire_left" {
	"anims\fire_left.smd"
	fadein 0.1
	fadeout 0.5
	fps 30
}
$sequence "fire_right" {
	"anims\fire_right.smd"
	fadein 0.1
	fadeout 0.5
	fps 30
}

$collisionmodel "proto_physics.smd"
{
	$mass 3000
	$inertia 10
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}
