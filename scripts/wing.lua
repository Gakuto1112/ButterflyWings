---@class Wing 蝶の羽を制御するクラス

events.RENDER:register(function ()
    local rightLegRotX = player:getVehicle() == nil and vanilla_model.RIGHT_LEG:getOriginRot().x or 0
    models.models.main.Body.ButterflyWings.Right:setRot(0, rightLegRotX * 0.1 - 70)
    models.models.main.Body.ButterflyWings.Left:setRot(0, rightLegRotX * -0.1 + 70)
end)