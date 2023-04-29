---@alias HealthLevel
---| "HIGH"
---| "MEDIUM"
---| "LOW"

---@class Wing 蝶の羽を制御するクラス
---@field SlowFallEffect boolean 低速落下のバフを受けているかどうか
---@field ParticleDuration integer 羽のパーティクルの出現時間の長さ：0. なし, 1. 短い, 2. ふつう, 3. 長い
---@field Glowing boolean 羽が発光しているかどうか

Wing = {
    SlowFallEffect = false,
    WingCrouchRatio = 1,
    Glowing = true,
    ParticleDuration = Config.loadConfig("particleDuration", 2),

    ---羽の発光を設定する。
    ---@param glow boolean 羽の発光させるかどうか
    setGlowing = function (glow)
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Base, models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Pattern, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Base, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Pattern, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
            modelPart:light(glow and 15 or nil)
        end
        Wing.Glowing = glow
    end
}

local wingOpened = false --羽を開く条件を満たしているかどうか
local wingOpenedPrev = false --前レンダーに羽を開く条件を満たしていたかどうか
local closeStep = 0 --羽の開閉のアニメーションの進行度：0. 開いている ～ 1. 閉じている
local wingCrouchRatio = 0 --スニークによる羽の開閉がどれぐらいの割合で影響を及ぼすかの変数（0-1）
local healthConditionPrev = "HIGH" --前チックのプレイヤーのHPの状態
local wingSoundCount = 0 --羽の音のカウンター
local renderProcessed = false --このレンダーで処理を行ったかどうか

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
        if renderer:isFirstPerson() and not client:hasIrisShader() and not General.RenderPaperdollPrev then
            if wingOpened then
                closeStep = 0
                wingCrouchRatio = 0
            else
                closeStep = 1
                wingCrouchRatio = 1
            end
        end
    end
    local flap = General.Flying or player:getPose() == "FALL_FLYING" or (Wing.SlowFallEffect and not (player:isOnGround() or player:getVehicle() ~= nil or player:isInWater() or player:isInLava()))
    wingOpened = flap or player:isCrouching()
    animations["models.butterfly"]["flap"]:setPlaying(flap)
    if flap then
        if Wing.ParticleDuration > 0 then
            ---モデルの絶対位置を返す
            ---@param modelPart ModelPart 対象のモデル
            ---@return Vector3 modelPos モデルの基点の絶対座標
            local function getAbsoluteModelPos(modelPart)
                local matrix = modelPart:partToWorldMatrix()
                return vectors.vec3(matrix[4][1], matrix[4][2], matrix[4][3])
            end

            local lifeTime = 2 ^ Wing.ParticleDuration / 4 * 60
            for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.ParticleAnchorRT, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.ParticleAnchorLT}) do
                particles:newParticle("firework", getAbsoluteModelPos(modelPart)):color(Color.Color[1]):scale(0.1):lifetime(lifeTime)
            end
            for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.ParticleAnchorRB, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.ParticleAnchorLB}) do
                particles:newParticle("firework", getAbsoluteModelPos(modelPart)):color(Color.Color[2]):scale(0.1):lifetime(lifeTime)
            end
        end
        if wingSoundCount == 1 then
            sounds:playSound("block.wool.step", player:getPos(), 0.25, 2)
        end
        wingSoundCount = wingSoundCount == 4 and 0 or wingSoundCount + 1
    else
        wingSoundCount = 0
    end
    local healthPercent = (player:getHealth() + player:getAbsorptionAmount()) / player:getMaxHealth()
    local gamemode = player:getGamemode()
    local healthCondition = (healthPercent > 0.5 or gamemode == "CREATIVE" or gamemode == "SPECTATOR") and "HIGH" or (healthPercent > 0.2 and "MEDIUM" or "LOW")
    if healthCondition ~= healthConditionPrev then
        Color.TatterState = healthCondition == "HIGH" and "NONE" or (healthCondition == "MEDIUM" and "SOFT" or "HARD")
        Color.drawBaseTexture()
        Color.drawEdgeTexture()
        Color.drawPatternTexture()
        healthConditionPrev = healthCondition
    end
end)

events.RENDER:register(function ()
    if not renderer:isFirstPerson() or client:hasIrisShader() or General.RenderPaperdollPrev then
        local rightLegRotX = player:getVehicle() == nil and vanilla_model.RIGHT_LEG:getOriginRot().x or 0
        models.models.main.Player.Body.ButterflyB.RightWing:setRot(0, rightLegRotX * 0.1 - (wingCrouchRatio * 60 + 10))
        models.models.main.Player.Body.ButterflyB.LeftWing:setRot(0, rightLegRotX * -0.1 + (wingCrouchRatio * 60 + 10))
        models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing:setRot(0, 0, wingCrouchRatio * -20)
        models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing:setRot(0, 0, wingCrouchRatio * -10)
        models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing:setRot(0, 0, wingCrouchRatio * 20)
        models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing:setRot(0, 0, wingCrouchRatio * 10)
    end
    if not renderProcessed then
        local FPS = client:getFPS()
        if wingOpened then
            if closeStep > 0 then
                closeStep = math.max(closeStep - 1 / FPS, 0)
                if not wingOpenedPrev then
                    closeStep = math.pow(wingCrouchRatio, 0.25)
                end
                wingCrouchRatio = math.pow(closeStep, 4)
            end
        else
            if closeStep < 1 then
                closeStep = math.min(closeStep + 1 / FPS, 1)
                if wingOpenedPrev then
                    closeStep = 1 - math.pow(1 - wingCrouchRatio, 0.25)
                end
                wingCrouchRatio = 1 - math.pow(1 - closeStep, 4)
            end
        end
        wingOpenedPrev = wingOpened
        renderProcessed = true
    end
end)

events.WORLD_RENDER:register(function ()
    renderProcessed = false
end)

return Wing