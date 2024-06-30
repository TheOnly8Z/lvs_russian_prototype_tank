if SERVER then
    ENT.PivotSteerEnable = true
    ENT.PivotSteerByBrake = false
    ENT.PivotSteerWheelRPM = 25

    local wheel_pos = {
        Vector(-105, 163.2, 48), -- 1
        Vector(-105, 114.9, 28), -- 2
        Vector(-105, 89.9, 28),
        Vector(-105, 63.9, 28), -- 3
        Vector(-105, 38.8, 28),
        Vector(-105, 13.7, 28), -- 4
        Vector(-105, -11.6, 28),
        Vector(-105, -36.9, 28), -- 5
        Vector(-105, -62.85, 28),
        Vector(-105, -88.8, 28), -- 6
        Vector(-105, -136.4, 48), -- 7
    }

    function ENT:TracksCreate(PObj)
        local WheelModel = "models/props_vehicles/tire001b_truck.mdl"

        local L, R = {}, {}

        for i = 1, #wheel_pos do
            L[i] = self:AddWheel({
                hide = true,
                wheeltype = LVS.WHEELTYPE_LEFT,
                pos = wheel_pos[i],
                mdl = WheelModel,
                mdl_ang = Angle(0, 0, 0),
            })
            local r_pos = Vector(wheel_pos[i])
            r_pos.x = r_pos.x * -1
            R[i] = self:AddWheel({
                hide = true,
                wheeltype = LVS.WHEELTYPE_RIGHT,
                pos = r_pos,
                mdl = WheelModel,
                mdl_ang = Angle(0, 0, 0),
            })
        end

        self:SetTrackDriveWheelLeft(L[6])
        self:SetTrackDriveWheelRight(R[6])

        local LeftWheelChain = self:CreateWheelChain(L)
        local RightWheelChain = self:CreateWheelChain(R)

        local LeftTracksArmor = self:AddArmor(Vector(128, 0, 60), Angle(0, 0, 0), Vector(-50, -150, -60), Vector(5, 180, 0), 5000, self.TrackArmor)
        LeftTracksArmor.OnDestroyed = LeftWheelChain.OnDestroyed
        LeftTracksArmor.OnRepaired = LeftWheelChain.OnRepaired
        LeftTracksArmor:SetLabel("Tracks")
        local RightTracksArmor = self:AddArmor(Vector(-128, 0, 60), Angle(0, 0, 0), Vector(-5, -150, -60), Vector(50, 180, 0), 5000, self.TrackArmor)
        RightTracksArmor.OnDestroyed = RightWheelChain.OnDestroyed
        RightTracksArmor.OnRepaired = RightWheelChain.OnRepaired
        RightTracksArmor:SetLabel("Tracks")

        local susp = {
            Height = 14,
            MaxTravel = 12,
            ControlArmLength = 150,
            SpringConstant = 20000,
            SpringDamping = 1000,
            SpringRelativeDamping = 2000,
        }


        self:DefineAxle({
            Axle = {
                ForwardAngle = Angle(0, 90, 0),
                SteerType = LVS.WHEEL_STEER_FRONT,
                SteerAngle = 30,
                TorqueFactor = 0,
                BrakeFactor = 1,
                UseHandbrake = true,
            },
            Wheels = {R[1], L[1], R[2], L[2], R[3], L[3]},
            Suspension = table.Copy(susp),
        })

        self:DefineAxle({
            Axle = {
                ForwardAngle = Angle(0, 90, 0),
                SteerType = LVS.WHEEL_STEER_NONE,
                TorqueFactor = 1,
                BrakeFactor = 1,
                UseHandbrake = true,
            },
            Wheels = {R[4], L[4], L[5], R[5], L[6], R[6], L[7], R[7], L[8], R[8]},
            Suspension = table.Copy(susp),

        })

        self:DefineAxle({
            Axle = {
                ForwardAngle = Angle(0, 90, 0),
                SteerType = LVS.WHEEL_STEER_REAR,
                SteerAngle = 30,
                TorqueFactor = 0,
                BrakeFactor = 1,
                UseHandbrake = true,
            },
            Wheels = {R[9], L[9], R[10], L[10], R[11], L[11]},
            Suspension = table.Copy(susp),

        })
    end
else
    ENT.TrackSystemEnable = true
    ENT.TrackScrollTexture = "models/8z/lvs/russian_prototype_tank/proto_treads"
    ENT.ScrollTextureData = {
        ["$bumpmap"] = "models/8z/lvs/russian_prototype_tank/proto_treads_n",
        ["$nocull"] = "1",
        ["$phong"] = "1",
        ["$phongboost"] = "0.15",
        ["$phongexponent"] = "25",
        ["$phongalbedotint"] = "1",
        ["$phongfresnelranges"] = "[1 2 3]",
        ["$translate"] = "[0.0 0.0 0.0]",
        ["$colorfix"] = "{255 255 255}",
        ["$translucent"] = "1",
        ["Proxies"] = {
            ["TextureTransform"] = {
                ["translateVar"] = "$translate",
                ["centerVar"] = "$center",
                ["resultVar"] = "$basetexturetransform",
            },
            ["Equals"] = {
                ["srcVar1"] = "$colorfix",
                ["resultVar"] = "$color",
            }
        }
    }

    ENT.TrackLeftSubMaterialID = 3
    ENT.TrackLeftSubMaterialMul = Vector(0, 0.075 * 0.0625, 0)
    ENT.TrackRightSubMaterialID = 2
    ENT.TrackRightSubMaterialMul = Vector(0, 0.075 * 0.0625, 0)
    ENT.TrackPoseParameterLeft = "spin_wheels_left"
    ENT.TrackPoseParameterLeftMul = -1.252
    ENT.TrackPoseParameterRight = "spin_wheels_right"
    ENT.TrackPoseParameterRightMul = -1.252
    ENT.TrackSounds = "lvs/vehicles/tiger/tracks_loop.wav"
    ENT.TrackHull = Vector(20, 20, 20)
    ENT.TrackData = {}

    for i = 1, 5 do
        for n = 0, 1 do
            local LR = n == 0 and "l" or "r"
            local LeftRight = n == 0 and "left" or "right"

            local data = {
                Attachment = {
                    name = "vehicle_suspension_" .. LR .. "_" .. i,
                    toGroundDistance = 40,
                    traceLength = 100,
                },
                PoseParameter = {
                    name = "suspension_" .. LeftRight .. "_" .. i,
                    rangeMultiplier = -1,
                    lerpSpeed = 20,
                }
            }

            table.insert(ENT.TrackData, data)
        end
    end
end