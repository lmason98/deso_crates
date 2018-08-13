include "shared.lua"

local icon = Material("deso_crates/health_crate.png")
local white, back, outline, red = Color(255, 255, 255), Color(48, 48, 48), Color(28, 28, 28), Color(255, 0, 0)

local num = 520 / 1000

/*---------------------------------------------------------
   Name: ENT:Draw()
   Desc: Draws health icon/stored health bar
---------------------------------------------------------*/
function ENT:Draw()
	self:DrawModel()

	local distance = LocalPlayer():GetPos():Distance(self:GetPos())
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)

	local alpha = deso.CalcOpacity(distance)
	white.a = alpha
	back.a = alpha
	outline.a = alpha
	red.a = alpha

	if (distance < 210) then
		cam.Start3D2D(pos + ang:Up() * 18 + ang:Forward() * -26 + ang:Right() * -13, ang, 0.1)
			surface.SetDrawColor(back)
			surface.DrawRect(0, 0, 520, 50)

			surface.SetDrawColor(red)
			surface.DrawRect(0, 0, num * self:GetStoredHealth(), 50)

			surface.SetDrawColor(outline)
			surface.DrawOutlinedRect(0, 0, 520, 50)
			surface.DrawOutlinedRect(1, 1, 518, 48)

			surface.SetMaterial(icon)
			surface.SetDrawColor(255, 255, 255, alpha)
			surface.DrawTexturedRect(182, 75, 150, 150)

			draw.SimpleTextOutlined(self:GetStoredHealth(), "deso_hud_reserve", 255, 25, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outline)
		cam.End3D2D()
	end
end