ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Kravchenko's Prototype"
ENT.Author = "8Z"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Heavy"

ENT.Spawnable       = true
ENT.AdminOnly       = GetConVar("lvs_kravchenko_admin_only"):GetBool()

ENT.MDL = "models/8z/lvs/russian_prototype_tank.mdl"
ENT.MDL_DESTROYED = "models/8z/lvs/russian_prototype_tank_wreck.mdl"
ENT.MDL_TURRETGIB = "models/8z/lvs/gibs/russian_prototype_tank_turret.mdl"
ENT.MDL_BARRELGIB = "models/8z/lvs/gibs/russian_prototype_tank_barrels.mdl"

ENT.GibModels = nil
ENT.AITEAM = 3

ENT.TurretSeatIndex = 1

ENT.MaxHealth = 9000

--damage system
ENT.DSArmorIgnoreForce = 4000
ENT.CannonArmorPenetration = 22500 --14500
ENT.FrontArmor = 18000
ENT.SideArmor = 12000
ENT.TurretArmor = 15000
ENT.RearArmor = 8000
ENT.TrackArmor = 6000

ENT.CannonAmmo = 40
ENT.CannonCooldown = 6
ENT.GrenadeCooldown = 10
ENT.SmokeCooldown = 15

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 2000
ENT.PhysicsInertia = Vector(7000,7000,2000)

ENT.MaxVelocity = 300
ENT.MaxVelocityReverse = 100

ENT.EngineCurve = 0.06
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
    {
        sound = "lvs/vehicles/tiger/eng_idle_loop.wav",
        Volume = 1,
        Pitch = 60,
        PitchMul = 40,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
    },
    {
        sound = "lvs/vehicles/tiger/eng_loop.wav",
        Volume = 1,
        Pitch = 20,
        PitchMul = 80,
        SoundLevel = 85,
        SoundType = LVS.SOUNDTYPE_NONE,
        UseDoppler = true,
    },
}

ENT.ExhaustPositions = {
    {
        pos = Vector(40,-160,65),
        ang = Angle(0,-90,0),
    },
    {
        pos = Vector(-40,-160,65),
        ang = Angle(0,-90,0),
    },
}

function ENT:OnSetupDataTables()
    self:AddDT( "Entity", "WeaponSeat" )
    self:AddDT( "Entity", "GunnerSeat" )
    self:AddDT( "Entity", "CommanderSeat" )

    self:AddDT( "Entity", "Plow" )

    self:AddDT( "Bool", "UseHighExplosiveL" )
    self:AddDT( "Bool", "UseHighExplosiveR" )
end

local function fire_cannon(veh, ent, pos, ang, he)

    local bullet = {}
    bullet.Src 	= pos
    bullet.Dir 	= ang:Forward()
    bullet.Spread = Vector(0,0,0)

    if he then
        bullet.Force	= 500
        bullet.HullSize = 15
        bullet.Damage	= 400
        bullet.SplashDamage = 1200
        bullet.SplashDamageRadius = 400
        bullet.SplashDamageEffect = "lvs_explosion_bomb"
        bullet.SplashDamageType = DMG_BLAST
        bullet.Velocity = 13000
    else
        bullet.Force	= veh.CannonArmorPenetration
        bullet.HullSize 	= 0
        bullet.Damage	= 2000
        bullet.Velocity = 17000

        bullet.SplashDamage = 200
        bullet.SplashDamageRadius = 200
        bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
        bullet.SplashDamageType = DMG_BLAST
    end

    bullet.TracerName = "lvs_tracer_cannon"
    bullet.Attacker 	= veh:GetPassenger(veh.TurretSeatIndex)
    veh:LVSFireBullet( bullet )
    local effectdata = EffectData()
    effectdata:SetOrigin( bullet.Src )
    effectdata:SetNormal( bullet.Dir )
    effectdata:SetEntity( veh )
    util.Effect( "lvs_muzzle", effectdata )

    local PhysObj = veh:GetPhysicsObject()
    if IsValid( PhysObj ) then
        PhysObj:ApplyForceOffset( -bullet.Dir * 320000, bullet.Src )
    end

    ent:TakeAmmo(1)
end

local COLOR_WHITE = Color(255,255,255,255)
local COLOR_DIM = Color(200, 200, 200, 100)
local function paint(att, ent, X, Y, ply, he, dim)
    local veh = ent:GetVehicle()
    local Muzzle = veh:GetAttachment( veh:LookupAttachment(att) or -1 )

    if Muzzle then
        local traceTurret = util.TraceLine( {
            start = Muzzle.Pos,
            endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
            filter = veh:GetCrosshairFilterEnts()
        } )

        local MuzzlePos2D = traceTurret.HitPos:ToScreen()

        if he then
            veh:PaintCrosshairSquare( MuzzlePos2D, dim and COLOR_DIM or COLOR_WHITE )
        else
            veh:PaintCrosshairOuter( MuzzlePos2D, dim and COLOR_DIM or COLOR_WHITE )
        end

        if not dim then
            veh:LVSPaintHitMarker( MuzzlePos2D )
        end
    end
end

function ENT:InitWeapons()
    self.LinkedCannons = GetConVar("lvs_kravchenko_link_cannons"):GetBool()
    if GetConVar("lvs_kravchenko_turret_driver"):GetBool() then
        self.TurretSeatIndex = 1
    else
        self.TurretSeatIndex = 2
    end

    local stats = {
        Ammo = self.CannonAmmo,
        Delay = self.CannonCooldown,
        HeatRateUp = 1,
        HeatRateDown = 1 / self.CannonCooldown,
    }

    local weapon

    -- Main cannons
    if self.LinkedCannons then
        stats.Ammo = stats.Ammo * 2
        weapon = {}
        weapon.Icon = true
        table.Merge(weapon, stats)
        weapon.OnThink = function( ent )
            local veh = ent:GetVehicle()
            if ent:GetSelectedWeapon() ~= 1 then return end
            local ply = veh:GetPassenger(veh.TurretSeatIndex)

            if not IsValid( ply ) then return end

            local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

            if veh._oldSwitchType ~= SwitchType then
                veh._oldSwitchType = SwitchType

                if SwitchType then
                    veh:SetUseHighExplosiveL( not veh:GetUseHighExplosiveL() )
                    veh:EmitSound("lvs/vehicles/sherman/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
                    ent:SetHeat( 1 )
                    ent:SetOverheated( true )
                end
            end
        end
        weapon.Attack = function( ent )
            local veh = ent:GetVehicle()
            local Muzzle = veh:GetAttachment( veh:LookupAttachment( "turret_left" ) )
            local Muzzle2 = veh:GetAttachment( veh:LookupAttachment( "turret_right" ) )

            if not Muzzle or not Muzzle2 then return end

            fire_cannon(veh, ent, Muzzle.Pos, Muzzle.Ang, veh:GetUseHighExplosiveL())

            if ent:GetAmmo() > 0 then
                fire_cannon(veh, ent, Muzzle2.Pos, Muzzle2.Ang, veh:GetUseHighExplosiveL())
                veh:PlayAnimation("fire")
                if not IsValid( veh.SNDTurretL ) or not IsValid( veh.SNDTurretR ) then return end
                veh.SNDTurretL:PlayOnce( 85 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 8 + math.Rand(-1,1), 1 )
                veh.SNDTurretR:PlayOnce( 85 + math.sin( CurTime() + veh:EntIndex() * 1337 ) * 8 + math.Rand(-1,1), 1 )
                veh:EmitSound("lvs/vehicles/tiger/cannon_reload.wav", 75, 85, 1, CHAN_WEAPON )
            else
                veh:PlayAnimation( "fire_left" )
                if not IsValid( veh.SNDTurretL ) then return end
                veh.SNDTurretL:PlayOnce( 85 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 8 + math.Rand(-1,1), 1 )
                veh:EmitSound("lvs/vehicles/tiger/cannon_reload.wav", 75, 85, 1, CHAN_WEAPON )
            end
        end
        weapon.HudPaint = function( ent, X, Y, ply )
            local veh = ent:GetVehicle()
            local Muzzle = veh:GetAttachment( veh:LookupAttachment("turret_left") or -1 )
            local Muzzle2 = veh:GetAttachment( veh:LookupAttachment("turret_right") or -1 )

            if Muzzle and Muzzle2 then
                local pos = (Muzzle.Pos + Muzzle2.Pos) / 2
                local traceTurret = util.TraceLine( {
                    start = pos,
                    endpos = pos + Muzzle.Ang:Forward() * 50000,
                    filter = veh:GetCrosshairFilterEnts()
                } )

                local MuzzlePos2D = traceTurret.HitPos:ToScreen()

                if veh:GetUseHighExplosiveL() then
                    veh:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )
                else
                    veh:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
                end

                if not dim then
                    veh:LVSPaintHitMarker( MuzzlePos2D )
                end
            end
        end
        self:AddWeapon(weapon, self.TurretSeatIndex)
    else
        weapon = {}
        weapon.Icon = true
        table.Merge(weapon, stats)
        weapon.OnThink = function( ent )
            local veh = ent:GetVehicle()
            if ent:GetSelectedWeapon() ~= 1 then return end
            local ply = veh:GetPassenger(veh.TurretSeatIndex)

            if not IsValid( ply ) then return end

            if ent:GetAmmo() == 0 and (veh.WEAPONS[ent:GetPodIndex()][2]._CurAmmo or 0) > 1 then
                veh.WEAPONS[ent:GetPodIndex()][2]._CurAmmo = veh.WEAPONS[ent:GetPodIndex()][2]._CurAmmo - 1
                ent:TakeAmmo(-1)
            end

            if ent.ReadyToSwap == true and not ply:lvsKeyDown("ATTACK") then
                ent:SelectWeapon(2)
                ent.ReadyToSwap = nil
            end

            local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

            if veh._oldSwitchType ~= SwitchType then
                veh._oldSwitchType = SwitchType

                if SwitchType then
                    veh:SetUseHighExplosiveL( not veh:GetUseHighExplosiveL() )
                    veh:EmitSound("lvs/vehicles/sherman/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
                    ent:SetHeat( 1 )
                    ent:SetOverheated( true )
                    -- ent.ReadyToSwap = true
                end
            end
        end
        weapon.Attack = function( ent )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "turret_left" )
            local Muzzle = veh:GetAttachment( ID )

            if not Muzzle then return end

            fire_cannon(veh, ent, Muzzle.Pos, Muzzle.Ang, veh:GetUseHighExplosiveL())

            veh:PlayAnimation( "fire_left" )

            if not IsValid( veh.SNDTurretL ) then return end
            veh.SNDTurretL:PlayOnce( 85 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 8 + math.Rand(-1,1), 1 )
            veh:EmitSound("lvs/vehicles/tiger/cannon_reload.wav", 75, 85, 1, CHAN_WEAPON )
        end
        weapon.HudPaint = function( ent, X, Y, ply )
            paint("turret_left", ent, X, Y, ply, ent:GetVehicle():GetUseHighExplosiveL())
            paint("turret_right", ent, X, Y, ply, ent:GetVehicle():GetUseHighExplosiveR(), true)
        end
        weapon.FinishAttack = function( ent )
            if self:GetAI() then return end
            ent.ReadyToSwap = true
        end
        self:AddWeapon(weapon, self.TurretSeatIndex)

        weapon = {}
        weapon.Icon = true
        table.Merge(weapon, stats)
        weapon.OnThink = function( ent )
            local veh = ent:GetVehicle()
            if ent:GetSelectedWeapon() ~= 2 then return end
            local ply = veh:GetPassenger(veh.TurretSeatIndex)

            if not IsValid( ply ) then return end

            if ent:GetAmmo() == 0 and (veh.WEAPONS[ent:GetPodIndex()][1]._CurAmmo or 0) > 1 then
                veh.WEAPONS[ent:GetPodIndex()][1]._CurAmmo = veh.WEAPONS[ent:GetPodIndex()][1]._CurAmmo - 1
                ent:TakeAmmo(-1)
            end

            if ent.ReadyToSwap == true and not ply:lvsKeyDown("ATTACK") then
                ent:SelectWeapon(1)
                ent.ReadyToSwap = nil
            end

            local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

            if veh._oldSwitchType ~= SwitchType then
                veh._oldSwitchType = SwitchType

                if SwitchType then
                    veh:SetUseHighExplosiveR( not veh:GetUseHighExplosiveR() )
                    veh:EmitSound("lvs/vehicles/sherman/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
                    ent:SetHeat( 1 )
                    ent:SetOverheated( true )
                    -- ent.ReadyToSwap = true
                end
            end
        end
        weapon.Attack = function( ent )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "turret_right" )
            local Muzzle = veh:GetAttachment( ID )

            if not Muzzle then return end

            fire_cannon(veh, ent, Muzzle.Pos, Muzzle.Ang, veh:GetUseHighExplosiveR())

            veh:PlayAnimation( "fire_right" )

            if not IsValid( veh.SNDTurretR ) then return end
            veh.SNDTurretR:PlayOnce( 85 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 8 + math.Rand(-1,1), 1 )
            veh:EmitSound("lvs/vehicles/tiger/cannon_reload.wav", 75, 85, 1, CHAN_WEAPON )
        end
        weapon.HudPaint = function( ent, X, Y, ply )
            paint("turret_left", ent, X, Y, ply, ent:GetVehicle():GetUseHighExplosiveL(), true)
            paint("turret_right", ent, X, Y, ply, ent:GetVehicle():GetUseHighExplosiveR())
        end
        weapon.FinishAttack = function( ent )
            if self:GetAI() then return end
            ent.ReadyToSwap = true
        end
        self:AddWeapon(weapon, self.TurretSeatIndex)
    end

    local smokes = {
        "smoke_top",
        "smoke_l1",
        "smoke_r1",
        "smoke_l2",
        "smoke_r2",
    }
    local smoke_force = {
        300,
        100,
        100,
        0,
        0,
    }

    -- Smokes
    weapon = {}
    weapon.Icon = Material("lvs/weapons/smoke_launcher.png")
    weapon.Ammo = 2
    weapon.Delay = self.SmokeCooldown
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 1 / self.SmokeCooldown
    weapon.Attack = function( ent )
        local veh = ent:GetVehicle()
        ent:TakeAmmo(1)
        for i, v in ipairs(smokes) do
            timer.Simple((i - 1) * 0.16, function()
                if not IsValid(veh) then return end
                local data = veh:GetAttachment( veh:LookupAttachment(v) or -1 )
                if not data then return end
                veh:EmitSound("lvs/smokegrenade.wav", nil, math.Rand(95, 105), 1, CHAN_ITEM + i)
                local grenade = ents.Create( "lvs_item_smoke" )
                grenade:SetPos( data.Pos )
                grenade:SetAngles( data.Ang )
                grenade:Spawn()
                grenade:Activate()
                grenade:GetPhysicsObject():SetVelocity( data.Ang:Forward() * (500 + smoke_force[i]) + veh:GetVelocity() )
            end)
        end
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    -- Grenades
    weapon = {}
    weapon.Icon = Material("lvs/weapons/grenade_launcher.png")
    weapon.Ammo = 3
    weapon.Delay = self.GrenadeCooldown
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 1 / self.GrenadeCooldown
    weapon.Attack = function(ent)
        local veh = ent:GetVehicle()
        ent:TakeAmmo(1)

        for i, v in ipairs(smokes) do
            timer.Simple((i - 1) * 0.1, function()
                if not IsValid(veh) then return end
                local data = veh:GetAttachment( veh:LookupAttachment(v) or -1 )
                if not data then return end
                local ang = data.Ang
                veh:EmitSound("lvs/smokegrenade.wav", nil, math.Rand(100, 110))
                local grenade = ents.Create("lvs_item_explosive")
                grenade:SetPos( data.Pos )
                grenade:SetAngles(ang)
                grenade:Spawn()
                grenade:Activate()
                grenade:GetPhysicsObject():SetVelocity(ang:Forward() * (400 + smoke_force[i]) + veh:GetVelocity() )
            end)

            -- local grenade = ents.Create("lvs_item_explosive")
            -- grenade:SetPos(data.Pos)
            -- grenade:SetAngles(ang)
            -- grenade:Spawn()
            -- grenade:Activate()
            -- grenade:SetAttacker(veh:GetPassenger(veh.TurretSeatIndex))
            -- grenade:GetPhysicsObject():SetVelocity(ang:Forward() * 500 + veh:GetVelocity())
        end


    end
    self:AddWeapon(weapon, self.TurretSeatIndex)


    -- Disable turret
    weapon = {}
    weapon.Icon = Material("lvs/weapons/tank_noturret.png")
    weapon.Ammo = -1
    weapon.Delay = 0
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.OnSelect = function( ent )
        local veh = ent:GetVehicle()
        if veh.SetTurretEnabled then
            veh:SetTurretEnabled( false )
        end
    end
    weapon.OnDeselect = function( ent )
        local veh = ent:GetVehicle()
        if veh.SetTurretEnabled then
            veh:SetTurretEnabled( true )
        end
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    -- Top MG
    if GetConVar("lvs_kravchenko_top_mg"):GetBool() then
        weapon = {}
        weapon.Icon = Material("lvs/weapons/mg.png")
        weapon.Ammo = 1500
        weapon.Delay = 0.085
        weapon.HeatRateUp = 0.28
        weapon.HeatRateDown = 0.35
        weapon.Attack = function( ent )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "mg_muzzle" )
            local Muzzle = veh:GetAttachment( ID )
            if not Muzzle then return end

            local spread = Lerp(ent:GetHeat() ^ 0.75, 0.008, 0.02)
            local bullet = {}
            bullet.Src = Muzzle.Pos
            bullet.Dir = Muzzle.Ang:Forward()
            bullet.Spread = Vector(spread,spread,spread)
            bullet.TracerName = "lvs_tracer_white"
            bullet.Force = 1800
            bullet.HullSize = 1
            bullet.Damage = 35
            bullet.Velocity = 20000
            bullet.Attacker = veh:GetPassenger(3)
            veh:LVSFireBullet( bullet )

            local effectdata = EffectData()
            effectdata:SetOrigin( bullet.Src )
            effectdata:SetNormal( bullet.Dir )
            effectdata:SetEntity( ent )
            util.Effect( "lvs_muzzle", effectdata )

            ent:TakeAmmo(1)
        end
        weapon.StartAttack = function( ent )
            local veh = ent:GetVehicle()
            if not IsValid( veh.SNDTurretMG ) then return end
            veh.SNDTurretMG:Play()
        end
        weapon.FinishAttack = function( ent )
            local veh = ent:GetVehicle()
            if not IsValid( veh.SNDTurretMG ) then return end
            veh.SNDTurretMG:Stop()
            -- veh:EmitSound("lvs/weapons/mg_heavy_lastshot.wav", 95)
        end
        weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
        weapon.HudPaint = function( ent, X, Y, ply )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "mg_muzzle" )
            local Muzzle = veh:GetAttachment( ID )

            if Muzzle then
                local traceTurret = util.TraceLine( {
                    start = Muzzle.Pos,
                    endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
                    filter = veh:GetCrosshairFilterEnts()
                } )

                local MuzzlePos2D = traceTurret.HitPos:ToScreen()

                veh:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
                veh:LVSPaintHitMarker( MuzzlePos2D )
            end
        end
        self:AddWeapon(weapon, 3)
    else
        self:SetBodygroup(2, 1)
    end
end

--[[ lights ]]
ENT.Lights = {
    {
        Trigger = "main+high",
        Sprites = {
            [1] = {
                pos = Vector(-102.5, 185, 72.5),
                colorB = 200,
                colorA = 150,
            },
            [2] = {
                pos = Vector(102.5, 185, 72.5),
                colorB = 200,
                colorA = 150,
            },
        },
        ProjectedTextures = {
            [1] = {
                pos = Vector(-102.5, 185, 72.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = true,
            },
            [2] = {
                pos = Vector(102.5, 185, 72.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 200,
                shadows = true,
            },
        },
    },
    {
        Trigger = "brake",
        Sprites = {
            [1] = {
                pos = Vector(-122, -160, 75),
                colorG = 80,
                colorB = 0,
                colorA = 150,
            },
            [2] = {
                pos = Vector(122, -160, 75),
                colorG = 80,
                colorB = 0,
                colorA = 150,
            },
        },
    },
}