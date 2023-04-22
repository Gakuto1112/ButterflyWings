---@class Wing 蝶の羽を制御するクラス
---@field WingOpenedPrev boolean 前チックに羽を開く条件を満たしていたかどうか
---@field CloseStep number 羽の開閉のアニメーションの進行度：0. 開いている ～ 1. 閉じている
---@field WingCrouchRatio number スニークによる羽の開閉がどれぐらいの割合で影響を及ぼすかの変数（0-1）

Wing = {
    WingOpenedPrev = false,
    CloseStep = 1,
    WingCrouchRatio = 1
}

events.RENDER:register(function ()
    local wingOpened = player:isCrouching() or player:getPose() == "FALL_FLYING"
    local FPS = client:getFPS()
    if wingOpened then
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
    models.models.main.Body.ButterflyWings.RightWing:setRot(0, rightLegRotX * 0.1 - (Wing.WingCrouchRatio * 60 + 10))
    models.models.main.Body.ButterflyWings.LeftWing:setRot(0, rightLegRotX * -0.1 + (Wing.WingCrouchRatio * 60 + 10))
    models.models.main.Body.ButterflyWings.RightWing.RightTop:setRot(0, 0, Wing.WingCrouchRatio * -20)
    models.models.main.Body.ButterflyWings.RightWing.RightBottom:setRot(0, 0, Wing.WingCrouchRatio * -10)
    models.models.main.Body.ButterflyWings.LeftWing.LeftTop:setRot(0, 0, Wing.WingCrouchRatio * 20)
    models.models.main.Body.ButterflyWings.LeftWing.LeftBottom:setRot(0, 0, Wing.WingCrouchRatio * 10)
    Wing.WingOpenedPrev = wingOpened
end)

return Wing