---@class Skull プレイヤーの頭（ブロック）を制御するクラス

events.SKULL_RENDER:register(function ()
    models.models.main.Player.Head.ButterflyH.RightFeeler1:setRot(-30, 20)
    models.models.main.Player.Head.ButterflyH.LeftFeeler1:setRot(-30, -20)
    for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2}) do
        modelPart:setRot(-30)
    end
end)

for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
    modelPart:setColor(vectors.vec3(0.69, 0.51, 0.84))
    modelPart:setOpacity(0.75)
    modelPart:light(15)
end
for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler1, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeeler2, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightFeelerTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler1, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeeler2, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftFeelerTip}) do
    modelPart:setColor(vectors.vec3(0.2, 0.05, 0.04))
end