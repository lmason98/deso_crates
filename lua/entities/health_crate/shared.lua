ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Health Crate"
ENT.Category = "Deso Ents"
ENT.Spawnable = true

ENT.Author = "MrRalgoman"

/*---------------------------------------------------------
   Name: ENT:SetupDataTables()
---------------------------------------------------------*/
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StoredHealth")
	self:NetworkVar("Bool", 0, "InUse")
end