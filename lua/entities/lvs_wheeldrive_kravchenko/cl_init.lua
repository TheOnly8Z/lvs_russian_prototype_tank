include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")

local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("lvs/weapons/bullet_ap.png")
local HE = Material("lvs/weapons/tank_cannon.png")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
    local use_he
    if ID == 2 then
        use_he = self:GetUseHighExplosiveR()
    elseif ID == 1 then
        use_he = self:GetUseHighExplosiveL()
    end
    local Icon = use_he and HE or AP

    surface.SetMaterial( Icon )
    surface.DrawTexturedRect( x, y, width, height )

    local ply = LocalPlayer()

    if not IsValid( ply ) or (ID ~= 1 and ID ~= 2) or not IsSelected then return end

    surface.SetMaterial( switch )
    surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )

    local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]

    if not buttonCode then return end

    local KeyName = input.GetKeyName( buttonCode )

    if not KeyName then return end

    draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
end


function ENT:OnSpawn( PObj )
    self:SetTurretYaw(self.TurretYawOffset + 180) -- ??

    -- shadows when turret is pointing sideways
    self:SetRenderBounds(Vector(-360, -360, -1), Vector(360, 360, 255))

    self.OpticsPodIndex[self.TurretSeatIndex] = true
end