---@class Wing 蝶の羽を制御するクラス
---@field SlowFallEffect boolean 低速落下のバフを受けているかどうか
---@field WingOpened boolean 羽を開く条件を満たしているかどうか
---@field WingOpenedPrev boolean 前レンダーチックに羽を開く条件を満たしていたかどうか
---@field CloseStep number 羽の開閉のアニメーションの進行度：0. 開いている ～ 1. 閉じている
---@field WingCrouchRatio number スニークによる羽の開閉がどれぐらいの割合で影響を及ぼすかの変数（0-1）
---@field Glowing boolean 羽が発光しているかどうか

Wing = {
    SlowFallEffect = false,
    WingOpened = false,
    WingOpenedPrev = false,
    CloseStep = 1,
    WingCrouchRatio = 1,
    Glowing = true,

    ---羽の発光を設定する。
    ---@param glow boolean 羽の発光させるかどうか
    setGlowing = function (glow)
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Base, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Base, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
            modelPart:light(glow and 15 or nil)
        end
        Wing.Glowing = glow
    end
}

---低速落下のバフのフラグを設定する。
---@param value boolean 低速落下のバフを受けているかどうか
function pings.setSlowFallEffect(value)
    Wing.SlowFallEffect = value
end

events.TICK:register(function ()
    if host:isHost() then
        local slowFallEffect = false
        for _, effect in ipairs(host:getStatusEffects()) do
            if effect.name == "effect.minecraft.slow_falling" then
                slowFallEffect = true
                break
            end
        end
        if slowFallEffect ~= Wing.SlowFallEffect then
            pings.setSlowFallEffect(slowFallEffect)
        end
    end
    local flap = General.Flying or player:getPose() == "FALL_FLYING" or (Wing.SlowFallEffect and not (player:isOnGround() or player:getVehicle() ~= nil or player:isInWater() or player:isInLava()))
    Wing.WingOpened = flap or player:isCrouching()
    animations["models.butterfly"]["flap"]:setPlaying(flap)
    if flap then
        ---モデルの絶対位置を返す
        ---@param modelPart ModelPart 対象のモデル
        ---@return Vector3 modelPos モデルの基点の絶対座標
        local function getAbsoluteModelPos(modelPart)
            local matrix = modelPart:partToWorldMatrix()
            return vectors.vec3(matrix[4][1], matrix[4][2], matrix[4][3])
        end

        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.ParticleAnchorRT, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.ParticleAnchorLT}) do
            particles:newParticle("firework", getAbsoluteModelPos(modelPart)):color(Color.Color[1]):scale(0.1)
        end
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.ParticleAnchorRB, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.ParticleAnchorLB}) do
            particles:newParticle("firework", getAbsoluteModelPos(modelPart)):color(Color.Color[2]):scale(0.1)
        end
    end
end)

events.RENDER:register(function ()
    local FPS = client:getFPS()
    if Wing.WingOpened then
        if Wing.CloseStep > 0 then
            Wing.CloseStep = math.max(Wing.CloseStep - 1 / FPS, 0)
            if not Wing.WingOpenedPrev then
                Wing.CloseStep = math.pow(Wing.WingCrouchRatio, 0.25)
            end
            Wing.WingCrouchRatio = math.pow(Wing.CloseStep, 4)
        end
    else
        if Wing.CloseStep < 1 then
            Wing.CloseStep = math.min(Wing.CloseStep + 1 / FPS, 1)
            if Wing.WingOpenedPrev then
                Wing.CloseStep = 1 - math.pow(1 - Wing.WingCrouchRatio, 0.25)
            end
            Wing.WingCrouchRatio = 1 - math.pow(1 - Wing.CloseStep, 4)
        end
    end
    local rightLegRotX = player:getVehicle() == nil and vanilla_model.RIGHT_LEG:getOriginRot().x or 0
    models.models.main.Player.Body.ButterflyB.RightWing:setRot(0, rightLegRotX * 0.1 - (Wing.WingCrouchRatio * 60 + 10))
    models.models.main.Player.Body.ButterflyB.LeftWing:setRot(0, rightLegRotX * -0.1 + (Wing.WingCrouchRatio * 60 + 10))
    models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing:setRot(0, 0, Wing.WingCrouchRatio * -20)
    models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing:setRot(0, 0, Wing.WingCrouchRatio * -10)
    models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing:setRot(0, 0, Wing.WingCrouchRatio * 20)
    models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing:setRot(0, 0, Wing.WingCrouchRatio * 10)
    Wing.WingOpenedPrev = Wing.WingOpened
end)

return Wing