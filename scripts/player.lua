---@class Player バニラやアバタープレイヤーモデルを制御するクラス

local flyAnimationCount = 0 --クリエイティブ飛行のアニメーションのカウンター
local flyIdle = false --クリエイティブ飛行時に止まっているかどうか（垂直方向は考慮しない）
local unlockArms = true --移動中に腕を振らせるかどうか
local flyIdleAnimationCount = 0 --クリエイティブ飛行時の止まっている時のアニメーションのカウンター
local heldItemCorrection = {false, false} --手にアイテムを持っている為に、腕の角度を補正するかどうか
local hasChargedCrossbow = false --装填済みのクロスボウを持っているかどうか

events.TICK:register(function ()
    if General.Flying then
        local velocity = player:getVelocity()
        flyIdle = math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) < 0.001
    else
        flyAnimationCount = 0
        flyIdle = false
    end
    if host:isHost() and renderer:isFirstPerson() and not client:hasIrisShader() and not General.RenderPaperdollPrev then
        flyIdleAnimationCount = flyIdle and 1 or 0
    end
    if General.Flying and not flyIdle then
        local leftHanded = player:isLeftHanded()
        local heldItems = {player:getHeldItem(leftHanded), player:getHeldItem(not leftHanded)}
        hasChargedCrossbow = false
        for i = 1, 2 do
            if heldItems[i].id == "minecraft:crossbow" and heldItems[i].tag["Charged"] == 1 then
                hasChargedCrossbow = true
                break
            end
        end
        unlockArms = player:getActiveItem().id ~= "minecraft:air" or hasChargedCrossbow
        for _, modelPart in ipairs({models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
            modelPart:setParentType("None")
        end
        for i = 1, 2 do
            heldItemCorrection[i] = heldItems[i].id ~= "minecraft:air" and not unlockArms
        end
    else
        unlockArms = true
        models.models.main.Player.RightLeg:setParentType("RightLeg")
        models.models.main.Player.LeftLeg:setParentType("LeftLeg")
    end
end)

events.RENDER:register(function (_, context)
    local armSwing = player:isSwingingArm()
    local firstPerson = context == "FIRST_PERSON"
    local leftHanded = player:isLeftHanded()
    models.models.main.Player.Body.RightArm:setParentType((unlockArms or ((armSwing or firstPerson) and not leftHanded)) and "RightArm" or "None")
    models.models.main.Player.Body.LeftArm:setParentType((unlockArms or ((armSwing or firstPerson) and leftHanded)) and "LeftArm" or "None")
end)

events.WORLD_RENDER:register(function ()
    if not renderer:isFirstPerson() or client:hasIrisShader() or General.RenderPaperdollPrev then
        local FPS = client:getFPS()
        if General.Flying then
            flyAnimationCount = flyAnimationCount + 0.33 / FPS
            flyAnimationCount = flyAnimationCount >= 1 and flyAnimationCount - 1 or flyAnimationCount
        end
        if flyIdle then
            if flyIdleAnimationCount < 1 then
                flyIdleAnimationCount = math.min(flyIdleAnimationCount + 4 / FPS, 1)
            end
        else
            if flyIdleAnimationCount > 0 then
                flyIdleAnimationCount = math.max(flyIdleAnimationCount - 4 / FPS, 0)
            end
        end
        local crouching = player:isCrouching()
        if crouching then
            models.models.main.Player.Body.RightArm:setPos(0, 3)
            models.models.main.Player.Body.LeftArm:setPos(0, 3)
        else
            models.models.main.Player.Body.RightArm:setPos()
            models.models.main.Player.Body.LeftArm:setPos()
        end
        local FlyAnimationCountSin = math.sin(flyAnimationCount * math.pi * 2)
        models.models.main:setPos(0, FlyAnimationCountSin, 0)

        ---クリエイティブ飛行のアイドル時のベクトルのスケール処理
        ---@param vectorToScale Vector3 スケール処理をするベクトル
        ---@return Vector3 scaledVector スケール処理をしたベクトル
        local function flyIdleAnimationScale(vectorToScale)
            return vectorToScale:scale(0.95 - FlyAnimationCountSin * 0.1):scale(flyIdleAnimationCount)
        end

        models.models.main.Player.Body.RightArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, 6.25, -13.65)):add((crouching and 30 or 0) + (heldItemCorrection[1] and 20 or 0)))
        models.models.main.Player.Body.LeftArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, -6.28, 13.65)):add((crouching and 30 or 0) + (heldItemCorrection[2] and 20 or 0)))
        if General.Flying and flyIdle then
            models.models.main.Player.RightLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, -8.65, 5.04)))
            models.models.main.Player.LeftLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, 8.65, -5.04)))
        else
            local legsNS = math.clamp(Physics.VelocityAverage[3] * -30, -30, 30)
            local legsEW = math.clamp(Physics.VelocityAverage[4] * -30, -30, 30)
            models.models.main.Player.RightLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, -8.65, 5.04)):add(legsNS, 0, legsEW))
            models.models.main.Player.LeftLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, 8.65, -5.04)):add(legsNS, 0, legsEW))
        end
    end
end)

for _, modelPart in ipairs({models.models.main.Player.Head.Head, models.models.main.Player.Head.HeadLayer, models.models.main.Player.Body.Body, models.models.main.Player.Body.BodyLayer, models.models.main.Player.Body.RightArm, models.models.main.Player.Body.LeftArm, models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
    modelPart:setPrimaryTexture("SKIN")
end
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.main.Player.Body.RightArm.RightArmSlim, models.models.main.Player.Body.LeftArm.LeftArmSlim} or {models.models.main.Player.Body.RightArm.RightArmClassic, models.models.main.Player.Body.LeftArm.LeftArmClassic}) do
	modelPart:setVisible(false)
end
for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR, vanilla_model.ELYTRA}) do
    vanillaModel:setVisible(false)
end