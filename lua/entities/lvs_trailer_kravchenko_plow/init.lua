AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
end

function ENT:Touch(ent)
    if IsValid(ent) and ent:GetClass() == "lvs_wheeldrive_wheel" then ent = ent:GetBase() end
    if not IsValid(ent) or not IsValid(self:GetOwner()) then return end
    if (ent.LVS_KravchenkoPlowDamage or 0) > CurTime() then return end
    local vel = self:GetOwner():GetVelocity()
    local force = math.Clamp(vel:Dot(-self:GetRight()), 40, 400)
    if (self:GetOwner():GetThrottle() > 0 and not self:GetOwner():GetReverse()) or force > 100 then
        local dmg = DamageInfo()
        if IsValid(self:GetOwner():GetDriver()) then
            dmg:SetAttacker(self:GetOwner():GetDriver())
        else
            dmg:SetAttacker(self:GetOwner())
            dmg:SetInflictor(self:GetOwner())
        end
        dmg:SetDamage(force * 0.25)
        dmg:SetDamageType(DMG_VEHICLE)
        dmg:SetDamagePosition((self:GetPos() + ent:GetPos()) / 2)
        dmg:SetDamageForce(self:GetRight() * -5000)

        ent:TakeDamageInfo(dmg)
        ent.LVS_KravchenkoPlowDamage = CurTime() + 0.2
    end
end

function ENT:OnCollision( data, physobj )
    local ent = data.HitEntity
    -- if IsValid(ent) and ent:GetClass() == "lvs_wheeldrive_wheel" then ent = ent:GetBase() end
    if not IsValid(ent) or ent == self:GetOwner() or ent:GetOwner() == self:GetOwner() then return end
    if (ent.LVS_KravchenkoPlowCrashDamage or 0) > CurTime() then return end

    local force = math.min(-data.OurOldVelocity:Dot(self:GetRight()), 1000)
    if force > 50 and IsValid(ent) then
        local dmg = DamageInfo()
        if IsValid(self:GetOwner()) then
            if IsValid(self:GetOwner():GetDriver()) then
                dmg:SetAttacker(self:GetOwner():GetDriver())
            else
                dmg:SetAttacker(self:GetOwner())
            end
            dmg:SetInflictor(self:GetOwner())
        else
            dmg:SetAttacker(self)
            dmg:SetInflictor(self)
        end
        dmg:SetDamage(force * (ent.LVS and 0.1 or 0.5))
        dmg:SetDamageType(DMG_VEHICLE + DMG_CRUSH)
        dmg:SetDamagePosition(data.HitPos)
        dmg:SetDamageForce(self:GetRight() * (-force * 500))
        ent:TakeDamageInfo(dmg)
        ent.LVS_KravchenkoPlowCrashDamage = CurTime() + 0.25
        ent.LVS_KravchenkoPlowDamage = CurTime() + 0.2
    end
end

-- function ENT:OnDestroyed()
--     if IsValid(self:GetOwner()) then
--         self:GetOwner():SetBodygroup(1, 0)
--     end
-- end

-- function ENT:OnRemove()
--     if IsValid(self:GetOwner()) then
--         self:GetOwner():SetBodygroup(1, 0)
--     end
-- end