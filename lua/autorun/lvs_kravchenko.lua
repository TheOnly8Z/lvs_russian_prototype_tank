AddCSLuaFile()

CreateConVar("lvs_kravchenko_turret_driver", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Kravchenko's Prototype] Enable to give turret and weapon controls to the driver instead of the gunner.", 0, 1)
CreateConVar("lvs_kravchenko_top_mg", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Kravchenko's Prototype] Enable to mount a machine gun for the commander (seat 3).", 0, 1)
CreateConVar("lvs_kravchenko_link_cannons", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Kravchenko's Prototype] Enable to make both barrels fire at once; otherwise each barrel can be reloaded and fired separately.", 0, 1)
CreateConVar("lvs_kravchenko_admin_only", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Kravchenko's Prototype] Only allow admins to spawn the vehicle (requires map change).", 0, 1)
CreateConVar("lvs_kravchenko_plow", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Kravchenko's Prototype] Enable to mount the front plow.", 0, 1)

hook.Add("LVS.8Z.AddVehicleSettings", "lvs_kravchenko", function(panel, node)
    local label = vgui.Create("ContentHeader", panel)
    label:SetText("Kravchenko's Prototype Tank")
    panel:Add(label)

    local turret_driver = vgui.Create("DCheckBoxLabel", panel)
    turret_driver:SetText("Driver Controls Turret")
    turret_driver:SetConVar("lvs_kravchenko_turret_driver")
    turret_driver:SizeToContents()
    turret_driver:SetTextColor(color_white)
    panel:Add(turret_driver)

    local top_mg = vgui.Create("DCheckBoxLabel", panel)
    top_mg:SetText("Add Top-Mounted Machine Gun")
    top_mg:SetConVar("lvs_kravchenko_top_mg")
    top_mg:SizeToContents()
    top_mg:SetTextColor(color_white)
    panel:Add(top_mg)

    local plow = vgui.Create("DCheckBoxLabel", panel)
    plow:SetText("Add Front Plow")
    plow:SetConVar("lvs_kravchenko_plow")
    plow:SizeToContents()
    plow:SetTextColor(color_white)
    panel:Add(plow)

    local link_cannons = vgui.Create("DCheckBoxLabel", panel)
    link_cannons:SetText("Link Cannons (both barrels fire simultaneously)")
    link_cannons:SetConVar("lvs_kravchenko_link_cannons")
    link_cannons:SizeToContents()
    link_cannons:SetTextColor(color_white)
    panel:Add(link_cannons)

    local admin_only = vgui.Create("DCheckBoxLabel", panel)
    admin_only:SetText("Admin Only (requires map change)")
    admin_only:SetConVar("lvs_kravchenko_admin_only")
    admin_only:SizeToContents()
    admin_only:SetTextColor(color_white)
    panel:Add(admin_only)
end)