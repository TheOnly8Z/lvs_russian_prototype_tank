AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnTick()
    self:AimTurret()

    local CommanderSeat = self:GetCommanderSeat()
    if IsValid(CommanderSeat) then
        local ply = CommanderSeat:GetDriver()
        if IsValid(ply) then
            local Ang = self:WorldToLocalAngles( ply:GetAimVector():Angle() ) - Angle(0,self:GetTurretYaw(),0)
            Ang:Normalize()
            self:SetPoseParameter("mg_yaw", Ang.y )
            self:SetPoseParameter("mg_pitch", math.Clamp(-Ang.p, -25, 45) )
        end
    end
end

function ENT:OnSpawn( PObj )

    self:SetTurretYaw(self.TurretYawOffset + 180) -- ??

    local DriverSeat = self:AddDriverSeat( Vector(0,72,32), Angle(0,0,0) )
    DriverSeat.HidePlayer = true
    self.DriverHatchHandler = self:AddDoorHandler( "hatch_driver", Vector(0, 145, 70), Angle(0,0,0), Vector(-25,-25,-10), Vector(25,25,15), Vector(-25,-25,-10), Vector(25,25,15))
    self.DriverHatchHandler:LinkToSeat( DriverSeat )
    self.DriverHatchHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    self.DriverHatchHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local GunnerSeat = self:AddPassengerSeat( Vector(-64,0,48), Angle(0,0,0) )
    GunnerSeat.HidePlayer = true
    self:SetGunnerSeat( GunnerSeat )
    self.TurretHatchHandler = self:AddDoorHandler( "hatch_turret", Vector(0,14,100), Angle(0,0,0), Vector(-90,-90,0), Vector(90,90,40), Vector(-90,-90,0), Vector(90,90,40))
    self.TurretHatchHandler:LinkToSeat( GunnerSeat )
    self.TurretHatchHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    self.TurretHatchHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local CommanderSeat = self:AddPassengerSeat( Vector(64,0,48), Angle(0,0,0) )
    CommanderSeat.HidePlayer = true
    self:SetCommanderSeat( CommanderSeat )

    if self.TurretSeatIndex == 1 then
        self:SetWeaponSeat( DriverSeat )
    elseif self.TurretSeatIndex == 2 then
        self:SetWeaponSeat( GunnerSeat )
    end

    self:SetupArmor()

    self:AddEngine( Vector(0, -170, 48), Angle(0,90,0) )

    local ID = self:LookupAttachment( "turret_left" )
    local Muzzle = self:GetAttachment( ID )
    self.SNDTurretL = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
    self.SNDTurretL:SetSoundLevel( 120 )
    self.SNDTurretL:SetParent( self, ID )

    ID = self:LookupAttachment( "turret_right" )
    Muzzle = self:GetAttachment( ID )
    self.SNDTurretR = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
    self.SNDTurretR:SetSoundLevel( 120 )
    self.SNDTurretR:SetParent( self, ID )

    ID = self:LookupAttachment( "mg_muzzle" )
    Muzzle = self:GetAttachment( ID )
    self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/weapons/mg_heavy_loop.wav", "lvs/weapons/mg_heavy_loop.wav" )
    self.SNDTurretMG:SetSoundLevel( 95 )
    self.SNDTurretMG:SetParent( self, ID )

    if GetConVar("lvs_kravchenko_plow"):GetBool() then
        self:SetupPlow()
    end
end

function ENT:SetupPlow()
    if IsValid(self:GetPlow()) then return end

    self.Plow = ents.Create("lvs_trailer_kravchenko_plow")
    -- self.Plow:SetModel("models/8z/lvs/russian_prototype_tank_plow.mdl")
    self.Plow:SetPos(self:GetPos())
    self.Plow:SetAngles(self:GetAngles())
    self.Plow:SetOwner(self)
    self.Plow:Spawn()
    self.Plow:Activate()

    -- self.Plow:SetParent(self)
    self._MountConstraint = constraint.Weld( self.Plow, self, 0, 0, 0, false, false )
    for _, wheel in pairs(self:GetWheels()) do
        constraint.NoCollide(self.Plow, wheel, 0, 0)
    end

    -- self.Plow:SetNoDraw(true)
    -- self:SetBodygroup(1, 1)

    self:SetPlow(self.Plow)
    self:DeleteOnRemove(self.Plow)

    local SupportEnt = ents.Create("prop_physics")
    if not IsValid(SupportEnt) then return end

    SupportEnt:SetModel("models/props_junk/PopCan01a.mdl")
    SupportEnt:SetPos(self:LocalToWorld(Vector(0, -140, 34)))
    SupportEnt:SetAngles(self:GetAngles())
    SupportEnt:Spawn()
    SupportEnt:Activate()
    SupportEnt:PhysicsInitSphere(5, "default_silent")
    SupportEnt:SetNoDraw(true)
    SupportEnt:GetPhysicsObject():SetMass(10000)
    SupportEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    SupportEnt.DoNotDuplicate = true
    self:DeleteOnRemove(SupportEnt)
    self.Plow:DeleteOnRemove(SupportEnt)

    SupportEnt:SetOwner(self)

    constraint.Weld( self, SupportEnt, 0, 0, 0, true, false )
    self.SupportEnt = SupportEnt:GetPhysicsObject()
    if not IsValid( self.SupportEnt ) then return end
    self.SupportEnt:SetMass(500)
end

function ENT:RemovePlow()
    if IsValid(self:GetPlow()) then
        self:GetPlow():Remove()
        self:SetPlow(nil)
    end
end

function ENT:OnDestroyed()
    if IsValid(self:GetPlow()) then
        self:GetPlow():Explode()
    end
    self:CreateTurretWreck()
end

function ENT:CreateTurretWreck()
    local ent = ents.Create( "prop_physics" )
    if not IsValid( ent ) then return end

    ent:SetPos( self:GetPos() )
    ent:SetAngles( self:GetAngles() + Angle(0, self:GetTurretYaw() + self.TurretYawOffset, 0) )
    ent:SetModel( self.MDL_TURRETGIB )
    ent:Spawn()
    ent:Activate()
    -- ent:SetRenderMode( RENDERMODE_TRANSALPHA )
    ent:SetCollisionGroup( self:GetCollisionGroup() )
    ent:SetSkin(self:GetSkin())
    ent:SetColor(self:GetColor())
    ent:Ignite(30)

    local PhysObj = ent:GetPhysicsObject()
    if IsValid( PhysObj ) then
        local GibDir = Vector( math.Rand(-1,1), math.Rand(-1,1), 2 ):GetNormalized()
        PhysObj:SetVelocityInstantaneous( GibDir * math.random(300,500) + self:GetVelocity() )

        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
            effectdata:SetStart( PhysObj:GetMassCenter() )
            effectdata:SetEntity( ent )
            effectdata:SetScale( math.Rand(0.25,0.5) )
            effectdata:SetMagnitude( math.Rand(4, 7) )
        util.Effect( "lvs_firetrail", effectdata )
    end

    self:DeleteOnRemove(ent)

    -- Barrels
    local ent2 = ents.Create( "prop_physics" )
    if not IsValid( ent2 ) then return end

    ent2:SetPos( self:GetPos() )
    ent2:SetAngles( self:GetAngles() + Angle(0, self:GetTurretYaw() + self.TurretYawOffset, 0) )
    ent2:SetModel( self.MDL_BARRELGIB )
    ent2:Spawn()
    ent2:Activate()
    -- ent2:SetRenderMode( RENDERMODE_TRANSALPHA )
    ent2:SetCollisionGroup( self:GetCollisionGroup() )
    ent2:SetSkin(self:GetSkin())
    ent2:SetColor(self:GetColor())
    ent2:Ignite(30)

    constraint.NoCollide(ent, ent2, 0, 0)

    local PhysObj2 = ent2:GetPhysicsObject()
    if IsValid( PhysObj2 ) then
        local GibDir = Vector( math.Rand(-1,1), math.Rand(-1,1), 2 ):GetNormalized()
        PhysObj2:SetVelocityInstantaneous( GibDir * math.random(400,600) + self:GetVelocity())

        -- PhysObj2:AddAngleVelocity(VectorRand() * 500)
        -- PhysObj2:EnableDrag(false)

        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
            effectdata:SetStart( PhysObj2:GetMassCenter() )
            effectdata:SetEntity( ent2 )
            effectdata:SetScale( math.Rand(0.25,0.5) )
            effectdata:SetMagnitude( math.Rand(4, 7) )
        util.Effect( "lvs_firetrail", effectdata )
    end

    self:DeleteOnRemove(ent2)
end


function ENT:SetupArmor()

    self:AddAmmoRack( Vector(48,-64,40), Vector(48,-64,100), Angle(0,0,0), Vector(-18,-36,-12), Vector(18,48,24) )
    self:AddAmmoRack( Vector(-48,-64,40), Vector(-48,-64,100), Angle(0,0,0), Vector(-18,-36,-12), Vector(18,48,24) )

    self:AddAmmoRack( Vector(48,48,40), Vector(48,48,100), Angle(0,0,0), Vector(-12,-24,-12), Vector(12,24,24) )
    self:AddAmmoRack( Vector(-48,48,40), Vector(-48,48,100), Angle(0,0,0), Vector(-12,-24,-12), Vector(12,24,24) )

    self:AddFuelTank( Vector(0,-72,32), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-24,-24,0), Vector(24,24,36) )

    -- self:AddDriverViewPort( Vector(0,120,68), Angle(0,0,0), Vector(-10,-4,0), Vector(10,4,12) )

    -- front
    -- self:AddArmor(Vector(0, 135, 80), Angle(0, 0, -10), Vector(-75, -32, -20), Vector(75, 60, 0), 8000, self.FrontArmor)
    self:AddArmor(Vector(0, 135, 25), Angle(0, 0, 45), Vector(-75, 0, -20), Vector(75, 60, 0), 5000, self.FrontArmor)

    self:AddArmor(Vector(50, 135, 80), Angle(0, 0, -10), Vector(-25, -32, -20), Vector(25, 60, 0), 3500, self.FrontArmor)
    self:AddArmor(Vector(-50, 135, 80), Angle(0, 0, -10), Vector(-25, -32, -20), Vector(25, 60, 0), 3500, self.FrontArmor)
    self:AddArmor(Vector(0, 135, 70), Angle(0, 0, 0), Vector(-25, -32, -20), Vector(25, 55, 0), 3500, self.FrontArmor)
    self:AddArmor(Vector(0, 100, 75), Angle(0, 0, 0), Vector(-25, -10, -10), Vector(25, 10, 10), 1500, self.FrontArmor)

    -- side
    self:AddArmor(Vector(128, 0, 90), Angle(0, 0, 0), Vector(-55, -160, -30), Vector(5, 190, 0), 3000, self.SideArmor)
    self:AddArmor(Vector(-128, 0, 90), Angle(0, 0, 0), Vector(-5, -160, -30), Vector(55, 190, 0), 3000, self.SideArmor)
    -- skirt
    self:AddArmor(Vector(-140, 0, 80), Angle(0, 0, 0), Vector(-10, -90, -45), Vector(10, 150, 0), 2000, self.FrontArmor)
    self:AddArmor(Vector(140, 0, 80), Angle(0, 0, 0), Vector(-10, -90, -45), Vector(10, 150, 0), 2000, self.FrontArmor)

    -- rear top
    self:AddArmor(Vector(0, -110, 90), Angle(0, 0, 0), Vector(-72, -48, -20), Vector(72, 48, 0), 3000, self.RearArmor)
    -- engine part
    self:AddArmor(Vector(0, -150, 70), Angle(0, 0, 0), Vector(-72, -16, -50), Vector(72, 16, 0), 2000, self.RearArmor)

    -- turret
    local TurretArmor = self:AddArmor(Vector(0,14,80), Angle(0,0,0), Vector(-96,-96,0), Vector(96,96,50), 6000, self.TurretArmor)
    TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
    TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
    TurretArmor:SetLabel( "Turret" )
    self:SetTurretArmor( TurretArmor )
end