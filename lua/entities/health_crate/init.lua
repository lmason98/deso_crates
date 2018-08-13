AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

include "shared.lua"

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetModel("models/items/ammocrate_rockets.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(CONTINUOUS_USE)
	self:SetColor(Color(85, 41, 41))
	self:SetMaterial("models/debug/debugwhite")

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() phys:SetMass(30) end

	self.delay = 0.25
	self.health = 150

	self:SetStoredHealth(1000)
	self:SetInUse(false)
end

/*---------------------------------------------------------
   Name: ENT:Use()
   Desc: Handles timing for ENT:GiveHealth()
---------------------------------------------------------*/
local healTime

function ENT:Use(activator, caller)
	if (!healTime) then
		healTime = CurTime() + self.delay
	end

	if (CurTime() >= healTime) then
		healTime = CurTime() + self.delay

		self:GiveHealth(caller)
	end
end

/*---------------------------------------------------------
   Name: ENT:OnTakeDamage()
   Desc: Handles health of ent
---------------------------------------------------------*/
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)

	self.health = self.health - dmg:GetDamage()
	
	if (self.health <= 0) then
		self:Explode()
	end
end

/*---------------------------------------------------------
   Name: ENT:GiveHealth()
   Desc: Give's the player using health
---------------------------------------------------------*/
function ENT:GiveHealth(ply)
	if (ply:Health() < 200 && self:GetStoredHealth() > 0) then
		ply:SetHealth(ply:Health() + 1)
		self:SetStoredHealth(self:GetStoredHealth() - 1)
	elseif (self:GetStoredHealth() <= 0) then
		deso.Notify(ply, 1, 4, "This health crate is empty!")
	else
		deso.Notify(ply, 1, 4, "Your health is full!")
	end 
end

/*---------------------------------------------------------
   Name: ENT:Explode()
   Desc: Removes the entity and adds an explosion effect
---------------------------------------------------------*/
function ENT:Explode()
	timer.Simple(0, function()
		if (self:IsValid()) then
			local effectData = EffectData()
			effectData:SetOrigin(self:GetPos())
			effectData:SetScale(15)
			util.Effect("Explosion", effectData)
			self:Remove()
		end
	end)
end