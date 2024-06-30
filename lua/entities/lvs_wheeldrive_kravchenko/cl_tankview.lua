include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
    if pod == self:GetWeaponSeat() and (pod ~= self:GetDriverSeat() or not pod:GetThirdPersonMode()) then
        local ID = self:LookupAttachment( "turret_viewport" )
        local Muzzle = self:GetAttachment( ID )
        if Muzzle then
            pos = Muzzle.Pos-- + Muzzle.Ang:Up() * 0.5
        end
    end

    return pos, angles, fov
end

function ENT:CalcViewDriver( ply, pos, angles, fov, pod )
    if pod ~= self:GetWeaponSeat() and not pod:GetThirdPersonMode() then
        pos = pos + pod:GetRight() * -64 + pod:GetUp() * 16
    end

    if ply:lvsMouseAim() then
        angles = ply:EyeAngles()
        return self:CalcViewMouseAim( ply, pos, angles,  fov, pod )
    else
        return self:CalcViewDirectInput( ply, pos, angles,  fov, pod )
    end
end

function ENT:CalcViewPassenger(ply, pos, angles, fov, pod)
    if pod == self:GetCommanderSeat() then
        if IsValid(ply:lvsGetWeaponHandler()) then -- MG is mounted
            local ID = self:LookupAttachment("mg_viewport")
            local Muzzle = self:GetAttachment(ID)
            if Muzzle then
                pos = Muzzle.Pos
            end
        else -- Just stand there looking pretty
            -- local ID = self:LookupAttachment("hatch_turret")
            -- local Muzzle = self:GetAttachment(ID)
            -- if Muzzle then
            --     pos = Muzzle.Pos + Muzzle.Ang:Forward() * 40
            -- end
        end
    elseif pod == self:GetGunnerSeat() and pod ~= self:GetWeaponSeat() then
        local ID = self:LookupAttachment("turret_viewport")
        local Muzzle = self:GetAttachment(ID)
        if Muzzle then
            pos = Muzzle.Pos
        end
    elseif not pod:GetThirdPersonMode() then
        angles = pod:LocalToWorldAngles( ply:EyeAngles() )
    end

    return self:CalcTankView( ply, pos, angles, fov, pod )
end