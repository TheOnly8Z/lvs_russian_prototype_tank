AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName = "Kravchenko's Plow"
ENT.Author = "8Z"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS]"

ENT.Spawnable = true

ENT.Type = "anim"
ENT._LVS = true

ENT.MDL = "models/8z/lvs/russian_prototype_tank_plow_fake.mdl"

if SERVER then

    function ENT:Initialize()
        self:SetModel(self.MDL)
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysWake()
    end

    function ENT:PhysicsCollide( data )
        local ent = data.HitEntity
        if not self.USED and IsValid(ent)
                and (ent:GetClass() == "lvs_wheeldrive_kravchenko" or ent:GetClass() == "lvs_wheeldrive_kravchenko_admin")
                and not IsValid(ent:GetPlow()) then
            self.USED = true
            timer.Simple(0, function()
                ent:SetupPlow()
            end)
            self:EmitSound("physics/metal/metal_box_strain1.wav")
            self:Remove()
        end
    end
end