---@class Feeler 触角を制御するクラス
---@field VelocityData table 速度データ：1. 前後, 2. 上下,
---@field VelocityAverage table 速度の平均値：1. 前後, 2. 上下

Feeler = {
    VelocityData = {{}, {}},
	VelocityAverage = {0, 0},
}

events.RENDER:register(function ()
    --平均速度の計算
    local velocity = player:getVelocity()
    local velocityRot = math.atan2(velocity.z, velocity.x)
    local lookDir = player:getLookDir()
    local lookRot = math.atan2(lookDir.z, lookDir.x)
    velocityRot = velocityRot < 0 and math.pi * 2 + velocityRot or velocityRot
    local directionAbsFront = math.abs(velocityRot - lookRot % (math.pi * 2))
    directionAbsFront = directionAbsFront > math.pi and math.pi * 2 - directionAbsFront or directionAbsFront
    local directionAbsRight = math.abs(velocityRot - (lookRot + math.pi / 2) % (math.pi * 2))
    directionAbsRight = directionAbsRight > math.pi and math.pi * 2 - directionAbsRight or directionAbsRight
    local horizontalVelocity = math.sqrt(velocity.x ^ 2 + velocity.z ^ 2)
    local velocityFront = horizontalVelocity * math.cos(directionAbsFront) * math.cos(lookDir.y * (math.pi / 2))
    local velocityTop = velocity.y * math.cos(lookDir.y * (math.pi / 2)) - horizontalVelocity * math.cos(directionAbsFront) * math.sin(lookDir.y * (math.pi / 2))
    Feeler.VelocityAverage[1] = (#Feeler.VelocityData[1] * Feeler.VelocityAverage[1] + velocityFront) / (#Feeler.VelocityData[1] + 1)
	table.insert(Feeler.VelocityData[1], velocityFront)
	Feeler.VelocityAverage[2] = (#Feeler.VelocityData[2] * Feeler.VelocityAverage[2] + velocityTop) / (#Feeler.VelocityData[2] + 1)
	table.insert(Feeler.VelocityData[2], velocityTop)
    --古いデータの切り捨て
    local FPS = client:getFPS()
	for index, velocityTable in ipairs(Feeler.VelocityData) do
		while #velocityTable > FPS * 0.25 do
			if #velocityTable >= 2 then
				Feeler.VelocityAverage[index] = (#velocityTable * Feeler.VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
			end
			table.remove(velocityTable, 1)
		end
	end
    --触角の角度の決定
    local feelerRot = math.clamp(Feeler.VelocityAverage[1] * 30 - Feeler.VelocityAverage[2] * 30 - 30, -50, -10)
    for _, modelPart in ipairs({models.models.main.Head.Feeler.RightFeeler, models.models.main.Head.Feeler.LeftFeeler}) do
        modelPart:setRot(feelerRot, modelPart:getRot().y)
    end
end)

return Feeler