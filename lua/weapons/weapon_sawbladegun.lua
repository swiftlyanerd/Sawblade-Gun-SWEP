-- Just some lame gun that shoots sawblades.

SWEP.PrintName    = "Sawblade Gun"
SWEP.Author       = "(swiftlyanerd)"
SWEP.Purpose      = "Shoots sawblades, kinda lame"
SWEP.Instructions = "Left click to shoot one, right click to shoot five"

SWEP.Category = "Sawblade Gun"

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Weight                = 5
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.Slot                  = 3
SWEP.SlotPos               = 2
SWEP.DrawAmmo              = false
SWEP.DrawCrosshair         = true

SWEP.ViewModel             = "models/weapons/v_irifle.mdl"
SWEP.WorldModel            = "models/weapons/w_irifle.mdl"

-- Preloads the weapon sound
local ShootSound = Sound("Metal.SawbladeStick")

-- Pew pew stuff, delay on left click attack
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
end

-- Even more pew pew stuff, spam away
function SWEP:SecondaryAttack()
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
	self:ThrowSawBlade("models/props_junk/sawblade001a.mdl")
end

-- Actual pew pew part
function SWEP:ThrowSawBlade(model_file)
	self:EmitSound(ShootSound)
	
	if(CLIENT) then return end
	
	local ent = ents.Create("prop_physics")
	
	-- Check if the entity is valid
	if(!IsValid(ent)) then return end
	
	ent:SetModel(model_file)
	
	-- Shoots the entity from the player's eye level and stuff
	ent:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 16)
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	
	local phys = ent:GetPhysicsObject()
	if(!IsValid(phys)) then ent:Remove() return end
	
	-- Speed at which the entity will travel
	local velocity = self.Owner:GetAimVector()
	-- It's fast as feck boi
	velocity = velocity * 1000000
	velocity = velocity + (VectorRand() * 10)
	phys:ApplyForceCenter(velocity)
	
	-- Adds the entities to the cleanup menu so you can mass delete
	cleanup.Add(self.Owner, "props", ent)
	
	undo.Create("Thrown_Sawblade")
		undo.AddEntity(ent)
		undo.SetPlayer(self.Owner)
	undo.Finish()
end