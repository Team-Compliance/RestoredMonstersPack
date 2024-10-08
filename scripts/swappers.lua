local mod = RestoredMonsterPack
local game = Game()



function mod:swapperUpdate(entity)
	if entity.Variant == EntityVariant.SWAPPER then
		local sprite = entity:GetSprite()
		local data = entity:GetData()
		local stage = game:GetLevel():GetStage()


		-- Prevent certain champions
		if entity:GetChampionColorIdx() == ChampionColor.GREEN or entity:GetChampionColorIdx() == ChampionColor.RAINBOW or entity:GetChampionColorIdx() == ChampionColor.BROWN then
			entity:MakeChampion(1, -1, true)
		end

		-- Gehenna skin
		if (stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2) and game:GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
			entity:Morph(entity.Type, entity.Variant, 1, entity:GetChampionColorIdx())
		end


		-- Get laser end point
		if sprite:IsEventTriggered("GetPos") then
			data.pos = entity:GetPlayerTarget().Position

		-- Shoot laser
		elseif sprite:IsEventTriggered("Laser") then
			data.canTP = true

			-- Set laser start and end position
			local laser_ent_pair = {laser = EntityLaser.ShootAngle(2, entity.Position, ((data.pos - entity.Position):GetAngleDegrees()), 3, Vector(0, entity.SpriteScale.Y * -48), entity), entity}
			local _, endPos = game:GetRoom():CheckLine(entity.Position, data.pos, 3)
			laser_ent_pair.laser:SetMaxDistance(entity.Position:Distance(endPos))

			-- Extra parameters
			laser_ent_pair.laser.Mass = 0
			laser_ent_pair.laser.DepthOffset = 200
			laser_ent_pair.laser.DisableFollowParent = true
			laser_ent_pair.laser.OneHit = true
			laser_ent_pair.laser.CollisionDamage = 0

			-- Laser color
			if entity.SubType == 1 then
				laser_ent_pair.laser:SetColor(Color(1,1,1, 1, 0.8,0.1,0.3), 0, 1, false, false)
			else
				laser_ent_pair.laser:SetColor(Color(1,1,1, 1, 0.2,0.1,0.8), 0, 1, false, false)
			end

		-- Disable teleporting
		elseif sprite:IsEventTriggered("NoTp") then
			data.canTP = false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.swapperUpdate, EntityType.ENTITY_BABY)



-- Swap Isaac and Swapper positions on successful hit
function mod:swapperHit(target, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if damageSource.Type == EntityType.ENTITY_BABY and damageSource.Variant == EntityVariant.SWAPPER and damageFlags & DamageFlag.DAMAGE_LASER > 0 then
		if damageSource.Entity:GetData().canTP == true then
			-- Get positions for teleporting
			local swapToPos = damageSource.Entity.Position
			local swapFromPos = target.Position

			-- Make sure they don't teleport the player on top of rocks or pits when they can't fly
			local room = game:GetRoom()
			if target:ToPlayer().CanFly == false and (room:GetGridCollisionAtPos(swapToPos) == GridCollisionClass.COLLISION_PIT or room:GetGridCollisionAtPos(swapToPos) == GridCollisionClass.COLLISION_SOLID) then
				swapToPos = room:FindFreeTilePosition(swapToPos, 52)
			end


			-- Visuals + sound
			if not (damageSource.Entity:HasEntityFlags(EntityFlag.FLAG_CHARM) or damageSource.Entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				target:ToPlayer():AnimateTeleport(false)
				target:GetSprite():SetFrame(12)

				damageSource.Entity:GetSprite():Play("TeleportDown", true)
				SFXManager():Play(SoundEffect.SOUND_HELL_PORTAL2, 1, 0, false, 1, 0)


				target.Position = swapToPos
				damageSource.Entity.Position = swapFromPos

				target:ToPlayer():SetMinDamageCooldown(20)
			end
			damageSource.Entity:GetData().canTP = false
		end

		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.swapperHit, EntityType.ENTITY_PLAYER)