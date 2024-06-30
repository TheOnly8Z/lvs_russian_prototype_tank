ENT.OpticsFov = 30
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {}

local axis = Material( "lvs/axis.png" )
local sight = Material( "lvs/shermansights.png" )
local scope = Material( "lvs/scope.png" )
local xlinked = 12
function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	surface.SetMaterial( axis )
	if self.LinkedCannons then
		surface.SetDrawColor( 255, 255, 255, 25 )
		surface.DrawTexturedRect( Pos2D.x - 7 + xlinked, Pos2D.y - 7, 16, 16 )
		surface.DrawTexturedRect( Pos2D.x - 7 - xlinked, Pos2D.y - 7, 16, 16 )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( Pos2D.x - 8 + xlinked, Pos2D.y - 8, 16, 16 )
		surface.DrawTexturedRect( Pos2D.x - 8 - xlinked, Pos2D.y - 8, 16, 16 )

	else
		if Col.a == 255 then
			surface.SetDrawColor( 255, 255, 255, 25 )
			surface.DrawTexturedRect( Pos2D.x - 7, Pos2D.y - 7, 16, 16 )
			surface.SetDrawColor( 0, 0, 0, 255 )
		else
			surface.SetDrawColor( 0, 0, 0, 150 )
		end
		surface.DrawTexturedRect( Pos2D.x - 8, Pos2D.y - 8, 16, 16 )
		if Col and Col.a < 255 then return end
	end

	surface.SetMaterial( sight )
	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawTexturedRect( Pos2D.x - 210, Pos2D.y - 23, 420, 420 )

	self:DrawRotatedText( Type == 3 and "HE" or "HEAT", Pos2D.x + (self.LinkedCannons and 42 or 30), Pos2D.y + 18, "LVS_FONT_PANEL", Color(0,0,0,220), 0)

	local diameter = ScrH()
	local radius = diameter * 0.5

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius, diameter, diameter )
end