---@class General 他の複数クラスから参照されるデータの管理を行うクラス
---@field Flying boolean クリエイティブ飛行をしているかどうか
---@field RenderPaperdoll boolean ペーパードールが描画されているかどうか
---@field RenderPaperdollPrev boolean 前レンダーにペーパードールが描画されていたかどうか

General = {
    Flying = false,
    RenderPaperdoll = false,
    RenderPaperdollPrev = false
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

events.RENDER:register(function (_, context)
    if context == "PAPERDOLL" then
        General.RenderPaperdoll = true
    end
end)

events.WORLD_RENDER:register(function ()
    General.RenderPaperdollPrev = General.RenderPaperdoll
    General.RenderPaperdoll = false
end)

return General