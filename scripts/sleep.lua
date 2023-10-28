---@class Sleep ベッドで寝る時の挙動を制御するクラス

---前ティックに寝ていたかどうか
---@type boolean
local isSleepingPrev = false

---睡眠中の羽ばたきのタイミングを計るカウンター
---@type number
local sleepFlipCount = 300

events.TICK:register(function ()
    if not client:isPaused() then
        local isSleeping = player:getPose() == "SLEEPING"
        if isSleeping then
            if not isSleepingPrev then
                animations["models.main"]["sleep"]:play()
                if renderer:isFirstPerson() then
                    models.models.main.Player.Head:setVisible(false)
                    renderer:setCameraPos(0, -0.25, 0)
                    renderer:setOffsetCameraRot(10, 180)
                end
            end
            if sleepFlipCount == 0 then
                animations["models.butterfly"]["sleep"]:play()
                sleepFlipCount = 300
            else
                sleepFlipCount = sleepFlipCount - 1
            end
        elseif not isSleeping and isSleepingPrev then
            for _, modelName in ipairs({"main", "butterfly"}) do
                animations["models."..modelName]["sleep"]:stop()
            end
            models.models.main.Player.Head:setVisible()
            renderer:setCameraPos()
            renderer:setOffsetCameraRot()
            sleepFlipCount = 300
        end
        isSleepingPrev = isSleeping
    end
end)