---@class Player バニラやアバタープレイヤーモデルを制御するクラス
---@field FlyAnimationCount number クリエイティブ飛行のアニメーションのカウンター
---@field FlyIdle boolean クリエイティブ飛行時に止まっているかどうか（垂直方向は考慮しない）
---@field FlyIdleAnimationCount number クリエイティブ飛行時の止まっている時のアニメーションのカウンター

Player = {
    FlyAnimationCount = 0,
    FlyIdle = false,
    FlyIdleAnimationCount = 0
}

events.TICK:register(function ()
    if General.Flying then
        local velocity = player:getVelocity()
        Player.FlyIdle = math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) < 0.001
    else
        Player.FlyAnimationCount = 0
        Player.FlyIdle = false
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

    models.models.main.Player.RightArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, 6.25, -13.65)))
    models.models.main.Player.LeftArm:setRot(flyIdleAnimationScale(vectors.vec3(24.25, -6.28, 13.65)))
    models.models.main.Player.RightLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, -8.65, 5.04)))
    models.models.main.Player.LeftLeg:setRot(flyIdleAnimationScale(vectors.vec3(59.62, 8.65, -5.04)))
end)

for _, modelPart in ipairs({models.models.main.Player.Head.Head, models.models.main.Player.Head.HeadLayer, models.models.main.Player.Body.Body, models.models.main.Player.Body.BodyLayer, models.models.main.Player.RightArm, models.models.main.Player.LeftArm, models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
    modelPart:setPrimaryTexture("SKIN")
end
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.main.Player.RightArm.RightArmSlim, models.models.main.Player.LeftArm.LeftArmSlim} or {models.models.main.Player.RightArm.RightArmClassic, models.models.main.Player.LeftArm.LeftArmClassic}) do
	modelPart:setVisible(false)
end
for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ELYTRA}) do
    vanillaModel:setVisible(false)
end

return Player