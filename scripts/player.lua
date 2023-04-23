---@class Player バニラやアバタープレイヤーモデルを制御するクラス
---@field FlyAnimationCount number クリエイティブ飛行のアニメーションのカウンター
---@field FlyIdle boolean クリエイティブ飛行時に止まっているかどうか（垂直方向は考慮しない）
---@field FlyIdleAnimationCount number クリエイティブ飛行時の止まっている時のアニメーションのカウンター
---@field ArmsOffset table<Vector3> レンダーで腕の角度を決定する際のオフセット

Player = {
    FlyAnimationCount = 0,
    FlyIdle = false,
    FlyIdleAnimationCount = 0,
    ArmsOffset = {vectors.vec3(), vectors.vec3()}
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
        local hasChargedCrossbox = false
        for i = 1, 2 do
            if heldItems[i].id == "minecraft:crossbow" and heldItems[i].tag["Charged"] == 1 then
                hasChargedCrossbox = true
                break
            end
        end
        local unlockArms = player:getActiveItem().id ~= "minecraft:air" or hasChargedCrossbox
        if unlockArms then
            models.models.main.Player.Body.RightArm:setParentType("RightArm")
            models.models.main.Player.Body.LeftArm:setParentType("LeftArm")
        else
            local armSwing = player:isSwingingArm()
            models.models.main.Player.Body.RightArm:setParentType((armSwing and not leftHanded) and "RightArm" or "None")
            models.models.main.Player.Body.LeftArm:setParentType((armSwing and leftHanded) and "LeftArm" or "None")
        end
        for _, modelPart in ipairs({models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
            modelPart:setParentType("None")
        end
        for i = 1, 2 do
            Player.ArmsOffset[i] = vectors.vec3((heldItems[i].id ~= "minecraft:air" and not unlockArms) and 20 or 0, 0, 0)
        end
    else
        models.models.main.Player.Body.RightArm:setParentType("RightArm")
        models.models.main.Player.Body.LeftArm:setParentType("LeftArm")
        models.models.main.Player.RightLeg:setParentType("RightLeg")
        models.models.main.Player.LeftLeg:setParentType("LeftLeg")
        Player.ArmsOffset = {vectors.vec3(), vectors.vec3()}
    end
end)

events.RENDER:register(function ()
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
    local FlyAnimationCountSin = math.sin(Player.FlyAnimationCount * math.pi * 2)
    models.models.main:setPos(0, FlyAnimationCountSin, 0)

    ---クリエイティブ飛行のアイドル時のベクトルのスケール処理
    ---@param vectorToScale Vector3 スケール処理をするベクトル
    ---@return Vector3 scaledVector スケール処理をしたベクトル
    local function flyIdleAnimationScale(vectorToScale)
        return vectorToScale:scale(0.95 - FlyAnimationCountSin * 0.1):scale(Player.FlyIdleAnimationCount)
    end

    models.models.main.Player.Body.RightArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, 6.25, -13.65)):add(Player.ArmsOffset[1]))
    models.models.main.Player.Body.LeftArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, -6.28, 13.65)):add(Player.ArmsOffset[2]))
    if General.Flying and Player.FlyIdle then
        models.models.main.Player.RightLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, -8.65, 5.04)))
        models.models.main.Player.LeftLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, 8.65, -5.04)))
    else
        local legsNS = math.clamp(Physics.VelocityAverage[3] * -30, -30, 30)
        local legsEW = math.clamp(Physics.VelocityAverage[4] * -30, -30, 30)
        models.models.main.Player.RightLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, -8.65, 5.04)):add(legsNS, 0, legsEW))
        models.models.main.Player.LeftLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, 8.65, -5.04)):add(legsNS, 0, legsEW))
    end
end)

for _, modelPart in ipairs({models.models.main.Player.Head.Head, models.models.main.Player.Head.HeadLayer, models.models.main.Player.Body.Body, models.models.main.Player.Body.BodyLayer, models.models.main.Player.Body.RightArm, models.models.main.Player.Body.LeftArm, models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
    modelPart:setPrimaryTexture("SKIN")
end
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.main.Player.Body.RightArm.RightArmSlim, models.models.main.Player.Body.LeftArm.LeftArmSlim} or {models.models.main.Player.Body.RightArm.RightArmClassic, models.models.main.Player.Body.LeftArm.LeftArmClassic}) do
	modelPart:setVisible(false)
end
vanilla_model.ALL:setVisible(false)

return Player