local mod = RestoredMonsterPack
local game = Game()

local Settings = {
	AttackTime = {60, 120}, -- The amount of frames between each bat charge
	AttackRange = 280, -- Range players must be in to trigger the bat charging
	ChaseSpeed = 3.5, -- Velocity of bat following its target
	DirectionChangeTimes = {10, 30}, -- Amount of frames until the bat changes angle directions
	AngleOffset = {15, 35}, -- The angle offset the bat flies with
	ShotSpeed = 9.25 -- The speed of the echo rings
}

mod.blindBatScreamInc = mod.blindBatScreamInc or 3 --dont ask

local function Lerp(first, second, percent)
	return (first + (second - first) * percent)
end


local function getAngleOffset(direction)
	local multiplier = 1
	if (direction == "down") then
		multiplier = -1
	end

	return math.random(Settings.AngleOffset[1], Settings.AngleOffset[2]) * multiplier
end



function mod:echoBatInit(entity)
	if entity.Variant == CutMonsterVariants.ECHO_BAT then
		local data = entity:GetData()
		local rng = entity:GetDropRNG()

		data.cooldown = math.random(Settings.AttackTime[1], Settings.AttackTime[2])
		data.chargeDirection = Vector.Zero
		data.angleCountdown = math.random(Settings.DirectionChangeTimes[1], Settings.DirectionChangeTimes[2])
		data.angleOffset = math.random(Settings.AngleOffset[1], Settings.AngleOffset[2])
		data.angleDirection = "up"
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.echoBatInit, EntityType.ENTITY_CUTMONSTERS)

function mod:echoBatUpdate(entity)
	if entity.Variant == CutMonsterVariants.ECHO_BAT then
		local sprite = entity:GetSprite()
		local data = entity:GetData()
		local target = entity:GetPlayerTarget()
		local rng = entity:GetDropRNG()

		-- Movement
		data.vector = ((target.Position - entity.Position):Normalized() * Settings.ChaseSpeed):Rotated(data.angleOffset)
		if entity:HasEntityFlags(EntityFlag.FLAG_FEAR) or entity:HasEntityFlags(EntityFlag.FLAG_SHRINK) then
			data.vector = Vector(-data.vector.X, -data.vector.Y)
		end

		if entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			entity.Pathfinder:MoveRandomly(false)
		else
			entity.Velocity = (entity.Velocity + (data.vector - entity.Velocity) * 0.25)
		end


		-- Change direction
		if data.angleCountdown <= 0 then
			if data.angleDirection == "up" then
				data.angleDirection = "down"
			else
				data.angleDirection = "up"
			end
			data.angleOffset = getAngleOffset(data.angleDirection)
			data.angleCountdown = math.random(Settings.DirectionChangeTimes[1], Settings.DirectionChangeTimes[2])
		end

		if data.cooldown > 0 then
			data.cooldown = data.cooldown - 1
		end
		if data.angleCountdown > 0 then
			data.angleCountdown = data.angleCountdown - 1
		end


		if not sprite:IsPlaying("Attack") and not sprite:IsPlaying("Idle") then
			sprite:Play("Idle", true)
		end


		-- Attacking
		if data.cooldown <= 0 and target.Position:Distance(entity.Position) <= Settings.AttackRange and not sprite:IsPlaying("Attack")
		and not (entity:HasEntityFlags(EntityFlag.FLAG_FEAR) or entity:HasEntityFlags(EntityFlag.FLAG_SHRINK) or entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
			sprite:Play("Attack", true)
		end

		if sprite:IsEventTriggered("Sound") then
			entity:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, 1.5, 0, false, 1.5)

		elseif sprite:IsEventTriggered("Shoot") then
			local params = ProjectileParams()
			params.Variant = ProjectileVariant.PROJECTILE_ECHO
			params.FallingAccelModifier = -0.1

			entity:FireProjectiles(entity.Position, (target.Position - entity.Position):Normalized() * Settings.ShotSpeed, 0, params)
		end

		if sprite:IsFinished("Attack") then
			data.cooldown = math.random(Settings.AttackTime[1], Settings.AttackTime[2])
			sprite:Play("Idle", true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.echoBatUpdate, EntityType.ENTITY_CUTMONSTERS)



-- Projectile
function mod:echoRingInit(projectile)
	projectile:GetSprite():Play("Move", true)
	projectile:AddProjectileFlags(ProjectileFlags.GHOST | ProjectileFlags.BOUNCE)
	projectile.Mass = 0
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.echoRingInit, ProjectileVariant.PROJECTILE_ECHO)

function mod:echoRingHit(target, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if damageSource.Type == EntityType.ENTITY_PROJECTILE and damageSource.Variant == ProjectileVariant.PROJECTILE_ECHO then
		if target.Type == EntityType.ENTITY_PLAYER then
			if not target:HasEntityFlags(EntityFlag.FLAG_CONFUSION) and not target:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
				-- target:AddConfusion(EntityRef(damageSource.Entity), 90, 0.8, Color(1,1,1, 1))
				target:AddEntityFlags(EntityFlag.FLAG_CONFUSION)
				target:GetData().EchoConfusionCountdown = 90
			end
		else
			target:AddConfusion(EntityRef(damageSource.Entity), 90, 0.8, Color(0.5, 0.5, 0.5, 1.0, 40/255, 40/255, 40/255))
		end

		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.echoRingHit)



local isPolling = false --anti infinite loop

function mod:confusionEffect(player, inputHook, buttonAction)
	if player and player:ToPlayer() and player:HasEntityFlags(EntityFlag.FLAG_CONFUSION) and isPolling == false then
		player = player:ToPlayer()

		local data = player:GetData()


		isPolling = true
		if Input.IsActionPressed(buttonAction, player.ControllerIndex) then
			data.FireDirection = - player:GetShootingJoystick():Normalized()
			data.MoveDirection = - player:GetMovementJoystick():Normalized() or player:GetRecentMovementVector():Normalized()
		else
			data.FireDirection = Vector.Zero
			data.MoveDirection = Vector.Zero
		end

		-- if Input.IsActionTriggered(buttonAction, player.ControllerIndex) then --direction is randomized each time you press any button
		-- 	data.randomFireDirection = player:GetShootingJoystick():Rotated(player:GetDropRNG():RandomInt(8) * 45):Normalized()
		-- end
		local moveDirectionVector = data.MoveDirection --data.randomFireDirection
		local fireDirectionVector = data.FireDirection

		isPolling = false


		local directionTable = {
			[ButtonAction.ACTION_DOWN] = moveDirectionVector:Dot(Vector(0, 1)),
			[ButtonAction.ACTION_LEFT] = moveDirectionVector:Dot(Vector(-1, 0)),
			[ButtonAction.ACTION_RIGHT] = moveDirectionVector:Dot(Vector(1, 0)),
			[ButtonAction.ACTION_UP] = moveDirectionVector:Dot(Vector(0, -1)),
			[ButtonAction.ACTION_SHOOTDOWN] = fireDirectionVector:Dot(Vector(0, 1)),
			[ButtonAction.ACTION_SHOOTLEFT] = fireDirectionVector:Dot(Vector(-1, 0)),
			[ButtonAction.ACTION_SHOOTRIGHT] = fireDirectionVector:Dot(Vector(1, 0)),
			[ButtonAction.ACTION_SHOOTUP] = fireDirectionVector:Dot(Vector(0, -1))
		}

		local buttonVector = directionTable[buttonAction]

		if buttonVector then
			if inputHook == InputHook.GET_ACTION_VALUE then

				return buttonVector
			else

				local highestNum, amount
				for index, value in ipairs(directionTable) do
					if not amount or value > amount then
						highestNum = index
						amount = value
					end
				end

				if highestNum and highestNum == buttonAction then
					return true
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.confusionEffect)



local shaderPosition = Vector.Zero
local lerpTarget =  0
local distortion = 0.0

function mod:confusionShader(shaderName)
	if shaderName == "ChromaticAbberation" then
		local room = Game():GetRoom()

		local confusedCount = 0
		for i = 0, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i)
			if player:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				confusedCount = confusedCount + 1
				shaderPosition:Lerp(player.Position, 1/confusedCount)
			end
		end

		local targetPos = room:WorldToScreenPosition(shaderPosition)

		distortion = Lerp(distortion, lerpTarget * (mod.blindBatScreamInc/3 + 1), .1)
		if confusedCount > 0 then
			lerpTarget = .4
		else
			lerpTarget = 0
		end

		if distortion < .01 then
			distortion = 0
		end


		return {
			TargetPos = { targetPos.X, targetPos.Y},
			MaxDistortion = distortion,
		}
  	end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.confusionShader)



function mod:confusionCountdown(player)
	local data = player:GetData()
	if data.EchoConfusionCountdown then
		if data.EchoConfusionCountdown > 0 then
			player:SetColor(Color(0.5, 0.5, 0.5, 1.0, 40/255, 40/255, 40/255), 1, 1, false, false)
			data.EchoConfusionCountdown = data.EchoConfusionCountdown - 1
		elseif data.EchoConfusionCountdown == 0 then
			player:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
			player:SetMinDamageCooldown(30)
			data.EchoConfusionCountdown = nil
		end
		-- print(data.EchoConfusionCountdown)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.confusionCountdown)

function mod:endConfusionEarly(target, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if target.Type == EntityType.ENTITY_PLAYER then
		local data = target:GetData()
		if target:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			target:ClearEntityFlags(EntityFlag.FLAG_CONFUSION)
			data.EchoConfusionCountdown = 0
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.endConfusionEarly)