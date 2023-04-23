---@class General 他の複数クラスから参照されるデータの管理を行うクラス
---@field Flying boolean クリエイティブ飛行をしているかどうか

General = {
    Flying = false
}

--ping関数
---クリエイティブ飛行のフラグを設定する。
---@param value boolean クリエイティブ飛行のフラグ
function pings.setFlying(value)
    General.Flying = value
end

events.TICK:register(function ()
    if host:isHost() then
        ---@diagnostic disable-next-line: undefined-field
        local flying = host:isFlying()
        if flying ~= General.Flying then
            pings.setFlying(flying)
        end
    end
end)

return General