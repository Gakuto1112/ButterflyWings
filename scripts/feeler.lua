---@class Feeler 触角を制御するクラス

events.RENDER:register(function ()
        local feelerRot = math.clamp(Physics.VelocityAverage[1] * 30 - Physics.VelocityAverage[2] * 30 - 30, -50, -10)
        models.models.main.Player.Head.ButterflyH.RightFeeler1:setRot(feelerRot, 20)
        models.models.main.Player.Head.ButterflyH.LeftFeeler1:setRot(feelerRot, -20)
        for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2}) do
            modelPart:setRot(feelerRot)
        end
end)