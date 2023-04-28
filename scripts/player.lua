---@class Player バニラやアバタープレイヤーモデルを制御するクラス
---@field FlyAnimationCount number クリエイティブ飛行のアニメーションのカウンター
---@field FlyIdle boolean クリエイティブ飛行時に止まっているかどうか（垂直方向は考慮しない）
---@field UnlockArms boolean 移動中に腕を振らせるかどうか
---@field FlyIdleAnimationCount number クリエイティブ飛行時の止まっている時のアニメーションのカウンター
---@field HeldItemCorrection  table<boolean> 手にアイテムを持っている為に、腕の角度を補正するかどうか
---@field HasChargedCrossbow boolean 装填済みのクロスボウを持っているかどうか

Player = {
    FlyAnimationCount = 0,
    FlyIdle = false,
    UnlockArms = true,
    FlyIdleAnimationCount = 0,
    HeldItemCorrection = {false, false},
    HasChargedCrossbow = false
}

events.TICK:register(function ()
    if General.Flying then
        local velocity = player:getVelocity()
        Player.FlyIdle = math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) < 0.001
    else
        Player.FlyAnimationCount = 0
        Player.FlyIdle = false
    end
    if General.Flying and not Player.FlyIdle then
        local leftHanded = player:isLeftHanded()
        local heldItems = {player:getHeldItem(leftHanded), player:getHeldItem(not leftHanded)}
        Player.hasChargedCrossbow = false
        for i = 1, 2 do
            if heldItems[i].id == "minecraft:crossbow" and heldItems[i].tag["Charged"] == 1 then
                Player.HasChargedCrossbow = true
                break
            end
        end
        Player.UnlockArms = player:getActiveItem().id ~= "minecraft:air" or Player.HasChargedCrossbow
        for _, modelPart in ipairs({models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
            modelPart:setParentType("None")
        end
        for i = 1, 2 do
            Player.HeldItemCorrection[i] = heldItems[i].id ~= "minecraft:air" and not Player.UnlockArms
        end
    else
        Player.UnlockArms = true
        models.models.main.Player.RightLeg:setParentType("RightLeg")
        models.models.main.Player.LeftLeg:setParentType("LeftLeg")
    end
end)

events.RENDER:register(function (delta, context)
    local FPS = client:getFPS()
    if General.Flying then
        Player.FlyAnimationCount = Player.FlyAnimationCount + 0.33 / FPS
        Player.FlyAnimationCount = Player.FlyAnimationCount >= 1 and Player.FlyAnimationCount - 1 or Player.FlyAnimationCount
    end
    if Player.FlyIdle then
        if Player.FlyIdleAnimationCount < 1 then
            Player.FlyIdleAnimationCount = math.min(Player.FlyIdleAnimationCount + 4 / FPS, 1)
        end
    else
        if Player.FlyIdleAnimationCount > 0 then
            Player.FlyIdleAnimationCount = math.max(Player.FlyIdleAnimationCount - 4 / FPS, 0)
        end
    end
    local armSwing = player:isSwingingArm()
    local firstPerson = context == "FIRST_PERSON"
    local leftHanded = player:isLeftHanded()
    models.models.main.Player.Body.RightArm:setParentType((Player.UnlockArms or ((armSwing or firstPerson) and not leftHanded)) and "RightArm" or "None")
    models.models.main.Player.Body.LeftArm:setParentType((Player.UnlockArms or ((armSwing or firstPerson) and leftHanded)) and "LeftArm" or "None")
    if context ~= "FIRST_PERSON" then
        local crouching = player:isCrouching()
        if crouching then
            models.models.main.Player.Body.RightArm:setPos(0, 3)
            models.models.main.Player.Body.LeftArm:setPos(0, 3)
        else
            models.models.main.Player.Body.RightArm:setPos()
            models.models.main.Player.Body.LeftArm:setPos()
        end
        local FlyAnimationCountSin = math.sin(Player.FlyAnimationCount * math.pi * 2)
        models.models.main:setPos(0, FlyAnimationCountSin, 0)

        ---クリエイティブ飛行のアイドル時のベクトルのスケール処理
        ---@param vectorToScale Vector3 スケール処理をするベクトル
        ---@return Vector3 scaledVector スケール処理をしたベクトル
        local function flyIdleAnimationScale(vectorToScale)
            return vectorToScale:scale(0.95 - FlyAnimationCountSin * 0.1):scale(Player.FlyIdleAnimationCount)
        end

        models.models.main.Player.Body.RightArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, 6.25, -13.65)):add((crouching and 30 or 0) + (Player.HeldItemCorrection[1] and 20 or 0)))
        models.models.main.Player.Body.LeftArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, -6.28, 13.65)):add((crouching and 30 or 0) + (Player.HeldItemCorrection[2] and 20 or 0)))
        if General.Flying and Player.FlyIdle then
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

return Player