ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "Kravchenko Tank Plow"
ENT.Author = "8Z"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.Spawnable       = false
ENT.MDL = "models/8z/lvs/russian_prototype_tank_plow.mdl"

ENT.AITEAM = 0

ENT.PhysicsMass = 500

ENT.MaxHealth = 4000
ENT.DSArmorIgnoreForce = 5000

ENT.ForceAngleMultiplier = 1

ENT.lvsShowInSpawner = false

hook.Add("PhysgunPickup", "lvs_trailer_kravchenko_plow", function(ply, ent)
    if ent:GetClass() == "lvs_trailer_kravchenko_plow" then return false end
end)