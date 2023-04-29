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
    if not client:isPaused() then
        if host:isHost() then
            ---@diagnostic disable-next-line: undefined-field
            local flying = host:isFlying()
            if flying ~= General.Flying then
                pings.setFlying(flying)
            end
        end
    end
end)

events.RENDER:register(function (_, context)
    if not client:isPaused() then
        if context == "PAPERDOLL" then
            General.RenderPaperdoll = true
        end
    end
end)

events.WORLD_RENDER:register(function ()
    if not client:isPaused() then
        General.RenderPaperdollPrev = General.RenderPaperdoll
        General.RenderPaperdoll = false
    end
end)

return General