---@class Color アバターのカスタマイズ可能な色を制御するクラス
---@field Color table<Vector3> 管理する色のテーブル：1. グラデーション1, 2. グラデーション2, 3. 縁, 4. 模様
---@field Palette table<table<Vector3|number>> カラーパレットのテーブル（読み込みはアクションホイールで行う）
---@field Opacity number 羽や触角の透明度

Color = {
    Color = {Config.loadConfig("color1", vectors.vec3(0.69, 0.51, 0.84)), Config.loadConfig("color2", vectors.vec3(0.02, 0.96, 0.97)), Config.loadConfig("color3", vectors.vec3(0.2, 0.05, 0.04)), Config.loadConfig("color4", vectors.vec3(0.27, 0.13, 0.45))},
    Palette = {},
    Opacity = Config.loadConfig("opacity", 0.75),

    ---現在の羽の色のカラーパレットのプレビューを設定する。
    ---@param colorIndex integer 色のインデックス（1-4）
    ---@param newColor Vector3 設定する色
    setPaletteColor = function (colorIndex, newColor)
        textures["textures.palette"]:setPixel((colorIndex - 1) % 2, math.ceil(colorIndex / 2) - 1, newColor)
        textures["textures.palette"]:update()
    end,

    ---カラーパレットセットのプレイヤーを設定する。
    ---@param paletteIndex integer カラーパレットのインデックス：0. 現在のパレット, 1-6. パレット1～6（アクションホイールからカラーパレットを開くまで呼び出さない。）
    ---@param newPalette table<Vector3> 設定するパレット
    ---@param update boolean 最後にテクスチャの適用処理を行うかどうか
    setPaletteColorSet = function (paletteIndex, newPalette, update)
        for i = 1, 4 do
            textures["textures.palette"]:setPixel(paletteIndex * 2 + (i - 1) % 2, math.ceil(i / 2) - 1, newPalette[i])
        end
        if update then
            textures["textures.palette"]:update()
        end
    end,

    ---羽のグラデーションを描画する。
    drawWingGradation = function ()
        local drawArea = {{{3, 9}}, {{1, 14}}, {{0, 18}}, {{0, 20}}, {{0, 22}}, {{0, 23}}, {{0, 24}}, {{1, 24}}, {{1, 25}}, {{2, 25}}, {{2, 25}}, {{3, 25}}, {{3, 25}}, {{4, 25}}, {{4, 25}}, {{5, 25}}, {{5, 25}}, {{6, 24}}, {{6, 24}}, {{7, 23}}, {{7, 17}}, {{8, 12}}, {{9, 7}}, {{20, 6}}, {{16, 10}}, {{12, 14}}, {{8, 18}}, {{7, 19}}, {{6, 20}}, {{5, 20}}, {{5, 20}}, {{4, 20}}, {{4, 20}}, {{3, 20}}, {{3, 20}}, {{2, 20}}, {{1, 21}}, {{1, 20}}, {{2, 19}}, {{2, 18}}, {{1, 19}}, {{1, 18}}, {{2, 17}}, {{2, 16}}, {{1, 17}}, {{1, 16}}, {{2, 15}}, {{3, 13}}, {{3, 11}}, {{2, 4}, {7, 2}, {11, 2}}, {{2, 3}}, {{1, 3}}, {{1, 3}}, {{0, 3}}, {{0, 3}}, {{1, 1}}}
        for y, row in ipairs(drawArea) do
            for _, chunk in ipairs(row) do
                textures["textures.main"]:fill(chunk[1], y - 1, chunk[2], 1, math.map(y, 1, 56, Color.Color[1].x, Color.Color[2].x), math.map(y, 1, 56, Color.Color[1].y, Color.Color[2].y), math.map(y, 1, 56, Color.Color[1].z, Color.Color[2].z))
            end
        end
        textures["textures.main"]:update()
    end,

    ---触角の先の色を設定する。
    setFeelerTipColor = function ()
        for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
            modelPart:setColor(Color.Color[1])
        end
    end,

    ---羽の縁の色を設定する。
    setEdgeColor = function ()
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Edge, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Edge, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Edge, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Edge, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler1, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeeler2, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightFeelerTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler1, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeeler2, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftFeelerTip}) do
            modelPart:setColor(Color.Color[3])
        end
    end,

    ---羽の模様の色を設定する。
    setPatternColor = function ()
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Pattern, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Pattern}) do
            modelPart:setColor(Color.Color[4])
        end
    end,

    ---羽や触角の透明度を設定する。
    setOpacity = function ()
        for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Base, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Base, models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
            modelPart:setOpacity(Color.Opacity)
        end
    end
}

Color.drawWingGradation()
Color.setFeelerTipColor()
Color.setEdgeColor()
Color.setPatternColor()
Color.setOpacity()

return Color