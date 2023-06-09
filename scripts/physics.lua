---@class Physics 物理演算の計算を行うクラス
---@field VelocityAverage table<number> 速度の平均値：1. 頭前後, 2. 頭上下, 4. 体左右
Physics = {
	VelocityAverage = {0, 0, 0, 0}
}

---@type table<table<number>>
local velocityData = {{}, {}, {}, {}} --速度データ：1. 頭前後, 2. 頭上下, 3. 体前後, 4. 体左右
---@type boolean
local renderProcessed = false --このレンダーで処理を行ったかどうか

events.RENDER:register(function ()
    if not (client:isPaused() or renderProcessed) then
        --平均速度の計算
        local velocity = player:getVelocity()
        local velocityRot = math.atan2(velocity.z, velocity.x)
        local lookDir = player:getLookDir()
        local lookRot = math.atan2(lookDir.z, lookDir.x)
        velocityRot = velocityRot < 0 and math.pi * 2 + velocityRot or velocityRot
        local headDirectionAbsFront = math.abs(velocityRot - lookRot % (math.pi * 2))
        headDirectionAbsFront = headDirectionAbsFront > math.pi and math.pi * 2 - headDirectionAbsFront or headDirectionAbsFront
        local bodyYaw = math.rad((player:getBodyYaw() - 90) % 360 - 180)
        local bodyDirectionAbsFront = math.abs(velocityRot - bodyYaw % (math.pi * 2))
        bodyDirectionAbsFront = bodyDirectionAbsFront > math.pi and math.pi * 2 - bodyDirectionAbsFront or bodyDirectionAbsFront
        local bodyDirectionAbsRight = math.abs(velocityRot - (bodyYaw + math.pi / 2) % (math.pi * 2))
        bodyDirectionAbsRight = bodyDirectionAbsRight > math.pi and math.pi * 2 - bodyDirectionAbsRight or bodyDirectionAbsRight
        local horizontalVelocity = math.sqrt(velocity.x ^ 2 + velocity.z ^ 2)
        for index, data in ipairs({horizontalVelocity * math.cos(headDirectionAbsFront) * math.cos(lookDir.y * (math.pi / 2)), velocity.y * math.cos(lookDir.y * (math.pi / 2)) - horizontalVelocity * math.cos(headDirectionAbsFront) * math.sin(lookDir.y * (math.pi / 2)), horizontalVelocity * math.cos(bodyDirectionAbsFront), horizontalVelocity * math.cos(bodyDirectionAbsRight)}) do
            Physics.VelocityAverage[index] = (#velocityData[index] * Physics.VelocityAverage[index] + data) / (#velocityData[index] + 1)
            table.insert(velocityData[index], data)
        end

        --古いデータの切り捨て
        local FPS = client:getFPS()
        for index, velocityTable in ipairs(velocityData) do
            while #velocityTable > FPS * 0.25 do
                if #velocityTable >= 2 then
                    Physics.VelocityAverage[index] = (#velocityTable * Physics.VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
                end
                table.remove(velocityTable, 1)
            end
        end
        renderProcessed = true
    end
end)

events.WORLD_RENDER:register(function ()
    if not client:isPaused() then
        renderProcessed = false
    end
end)

return Physics