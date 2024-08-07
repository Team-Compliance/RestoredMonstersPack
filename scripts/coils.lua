local mod = RestoredMonsterPack
local game = Game()

local CoilRoomRecord = {}



-- Helper function to connect a coil and enemy pair with a laser
local function addLaser(npc_target, coil_source)
	local laser_source_pos = Vector(coil_source.Position.X, coil_source.Position.Y+1)
	local laser_ent_pair = {laser=EntityLaser.ShootAngle(2, laser_source_pos, ((npc_target.Position - laser_source_pos):GetAngleDegrees()), 0, Vector(0, -30), coil_source), npc=npc_target}
	local _, endPos = Game():GetRoom():CheckLine(laser_source_pos, laser_ent_pair.npc.Position, 3)

    laser_ent_pair.laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	laser_ent_pair.laser:SetMaxDistance(laser_source_pos:Distance(endPos))
	laser_ent_pair.laser.CollisionDamage = 0
	laser_ent_pair.laser:SetColor(Color(0,0,0,1,0.89,0.92,0.81), 0, 1, false, false)
	laser_ent_pair.laser.Mass = 0
	laser_ent_pair.laser.DepthOffset = 200.0

	table.insert(coil_source:GetData()["Lasers"], laser_ent_pair)
	npc_target:GetData()[("CoilTagged"..tostring(coil_source:GetData()["CoilID"]))] = true
end

-- Helper function to adjust lasers to connect properly after an enemy moves
local function adjust_laser(laser_pair, coil_source)
    local laser_source_pos = Vector(coil_source.Position.X, coil_source.Position.Y-10)
    laser_pair.laser.Angle = (laser_pair.npc.Position - laser_source_pos):GetAngleDegrees()
    local _, endPos = Game():GetRoom():CheckLine(laser_source_pos, laser_pair.npc.Position, 3)
    laser_pair.laser:SetMaxDistance(laser_source_pos:Distance(endPos))
end



function mod:GetCoils()
    local room_index = Game():GetLevel():GetCurrentRoomIndex()

	-- Get Coil spawns
    if game:GetRoom():IsFirstVisit() then
        local coil_table = {}

        for _,v in pairs(Isaac.GetRoomEntities()) do
            if v:IsEnemy() and v.Type == EntityType.ENTITY_CUTMONSTERS and v.Variant == CutMonsterVariants.COIL then
				table.insert(coil_table, v.Position)
			end
        end
        CoilRoomRecord[room_index] = coil_table

	-- Respawn Coils
    else
        if CoilRoomRecord[room_index] ~= nil then
            for _,v in pairs(CoilRoomRecord[room_index]) do
                Isaac.Spawn(EntityType.ENTITY_CUTMONSTERS, CutMonsterVariants.COIL, 0, v, Vector.Zero, nil)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.GetCoils)

-- Reset coil record upon new stage entry
function mod:CoilClearRecord()
    CoilRoomRecord = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.CoilClearRecord)



function mod:CoilInit(npc)
    if npc.Variant == CutMonsterVariants.COIL then
        npc:GetData()["StartPos"] = npc.Position -- Get anchor position
        npc:GetData()["CoilID"] = math.random(100)
        npc:GetData()["Lasers"] = {}
        npc:GetData()["AliveFrames"] = 0

		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_TARGET) -- Same as grimaces

		if CoilsMod then
			npc:GetSprite():Load("gfx/coil.anm2", true)
		end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CoilInit, EntityType.ENTITY_CUTMONSTERS)

function mod:CoilUpdate(npc)
    if npc.Variant == CutMonsterVariants.COIL then
        npc.Position = npc:GetData()["StartPos"] -- anchor to position
        npc:GetSprite():Play("Idle")

        local room = game:GetRoom()
        room:SetGridPath(room:GetGridIndex(npc.Position), 3999) --same as grimaces

        if npc:GetData()["AliveFrames"] > 8 then -- delay laser spawning
            local room_entities = Isaac.GetRoomEntities()
            for _,v in pairs(room_entities) do
                if v:IsActiveEnemy(false) and not v:GetData()[("CoilTagged"..tostring(npc:GetData()["CoilID"]))] and v.EntityCollisionClass > 0
				and inAMLblacklist("Coil", v.Type, v.Variant, v.SubType) == false and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    addLaser(v, npc)
                end
            end

			-- Remove lasers from dead, or adjust them to follow entities
            for _,v in pairs(npc:GetData()["Lasers"]) do
                if v.npc:IsDead() or v.npc.EntityCollisionClass <= 0 then
                    v.laser:Remove()
					if not v.npc:IsDead() then
						v.npc:GetData()[("CoilTagged"..tostring(npc:GetData()["CoilID"]))] = nil
					end
                else
                    adjust_laser(v, npc)
                end
            end
        else
            npc:GetData()["AliveFrames"] = npc:GetData()["AliveFrames"] + 1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CoilUpdate, EntityType.ENTITY_CUTMONSTERS)

function mod:CoilDamage(entity, amount, dmg_flags)
    if entity.Variant == CutMonsterVariants.COIL then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CoilDamage, EntityType.ENTITY_CUTMONSTERS)