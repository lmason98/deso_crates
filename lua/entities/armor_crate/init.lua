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
	self:SetColor(Color(41, 41, 85))
	self:SetMaterial("models/debug/debugwhite")

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() phys:SetMass(30) end

	self.delay = 0.25
	self.health = 150

	self:SetStoredArmor(1000)
	self:SetInUse(false)
end

/*---------------------------------------------------------
   Name: ENT:Use()
   Desc: Handles timing for ENT:GiveArmor()
---------------------------------------------------------*/
local armorTime

function ENT:Use(activator, caller)
	if (!armorTime) then
		armorTime = CurTime() + self.delay
	end

	if (CurTime() >= armorTime) then
		armorTime = CurTime() + self.delay

		self:GiveArmor(caller)
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
   Name: ENT:GiveArmor()
   Desc: Give's the player using armor
---------------------------------------------------------*/
function ENT:GiveArmor(ply)
	if (ply:Armor() < 200 && self:GetStoredArmor() > 0) then
		ply:SetArmor(ply:Armor() + 1)
		self:SetStoredArmor(self:GetStoredArmor() - 1)
	elseif (self:GetStoredArmor() <= 0) then
		deso.Notify(ply, 1, 4, "This armor crate is empty!")
	else
		deso.Notify(ply, 1, 4, "Your armor is full!")
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