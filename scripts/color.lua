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
    ---@param newPalette table<Vector3|number> 設定するパレット
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
        local drawArea = {{}, {}, {{3, 1}, {8, 4}, {48, 4}, {56, 1}}, {{4, 4}, {12, 3}, {45, 3}, {52, 4}}, {{2, 2}, {7, 5}, {15, 1}, {17, 1}, {42, 1}, {44, 1}, {48, 5}, {56, 2}}, {{4, 3}, {20, 2}, {38, 2}, {53, 3}}, {{2, 2}, {10, 7}, {18, 5}, {37, 5}, {43, 7}, {56, 2}}, {{4, 14}, {19, 5}, {36, 5}, {42, 14}}, {{3, 1}, {5, 13}, {19, 6}, {35, 6}, {42, 13}, {56, 1}}, {{4, 1}, {6, 6}, {18, 1}, {20, 6}, {34, 6}, {41, 1}, {48, 6}, {55, 1}}, {{4, 1}, {12, 8}, {21, 5}, {34, 5}, {40, 8}, {55, 1}}, {{6, 15}, {22, 5}, {33, 5}, {39, 15}}, {{5, 1}, {7, 15}, {23, 4}, {33, 4}, {38, 15}, {54, 1}}, {{6, 1}, {8, 8}, {22, 1}, {24, 4}, {32, 4}, {37, 1}, {44, 8}, {53, 1}}, {{6, 1}, {8, 2}, {16, 8}, {26, 2}, {32, 2}, {36, 8}, {50, 2}, {53, 1}}, {{10, 16}, {28, 1}, {31, 1}, {34, 16}}, {{7, 1}, {9, 19}, {32, 19}, {52, 1}}, {{8, 1}, {10, 12}, {38, 12}, {51, 1}}, {{8, 1}, {10, 6}, {22, 7}, {31, 7}, {44, 6}, {51, 1}}, {{9, 1}, {16, 8}, {36, 8}, {50, 1}}, {{10, 1}, {12, 8}, {40, 8}, {49, 1}}, {{10, 1}, {12, 4}, {44, 4}, {49, 1}}, {}, {}, {{24, 5}, {31, 5}}, {{20, 8}, {32, 8}}, {{16, 9}, {28, 1}, {31, 1}, {35, 9}}, {{13, 3}, {20, 2}, {25, 4}, {31, 4}, {38, 2}, {44, 3}}, {{12, 8}, {22, 4}, {28, 1}, {31, 1}, {34, 4}, {40, 8}}, {{13, 5}, {20, 4}, {26, 2}, {32, 2}, {36, 4}, {42, 5}}, {{11, 2}, {16, 1}, {18, 5}, {24, 2}, {27, 1}, {32, 1}, {34, 2}, {37, 5}, {43, 1}, {47, 2}}, {{10, 6}, {17, 5}, {23, 1}, {25, 2}, {33, 2}, {36, 1}, {38, 5}, {44, 6}}, {{10, 5}, {16, 5}, {22, 2}, {25, 2}, {33, 2}, {36, 2}, {39, 5}, {45, 5}}, {{11, 3}, {15, 5}, {21, 1}, {23, 2}, {35, 2}, {38, 1}, {40, 5}, {46, 3}}, {{10, 1}, {15, 4}, {20, 2}, {23, 3}, {34, 3}, {38, 2}, {41, 4}, {49, 1}}, {{8, 6}, {15, 3}, {19, 4}, {24, 1}, {35, 1}, {37, 4}, {42, 3}, {46, 6}}, {{8, 4}, {14, 1}, {18, 1}, {20, 3}, {24, 1}, {35, 1}, {37, 3}, {41, 1}, {45, 1}, {48, 4}}, {{8, 2}, {12, 2}, {15, 2}, {18, 1}, {20, 4}, {36, 4}, {41, 1}, {43, 2}, {46, 2}, {50, 2}}, {{8, 1}, {10, 4}, {15, 2}, {18, 2}, {21, 3}, {36, 3}, {40, 2}, {43, 2}, {46, 4}, {51, 1}}, {{9, 4}, {14, 3}, {18, 2}, {21, 2}, {37, 2}, {40, 2}, {43, 3}, {47, 4}}, {{8, 5}, {14, 2}, {17, 4}, {22, 1}, {37, 1}, {39, 4}, {44, 2}, {47, 5}}, {{8, 4}, {13, 3}, {17, 5}, {38, 5}, {44, 3}, {48, 4}}, {{8, 4}, {13, 3}, {17, 5}, {38, 5}, {44, 3}, {48, 4}}, {{8, 3}, {12, 3}, {16, 5}, {39, 5}, {45, 3}, {49, 3}}, {{9, 2}, {12, 3}, {16, 5}, {39, 5}, {45, 3}, {49, 2}}, {{9, 1}, {11, 4}, {16, 4}, {40, 4}, {45, 4}, {50, 1}}, {{11, 3}, {15, 3}, {42, 3}, {46, 3}}, {}, {}, {{7, 1}, {52, 1}}, {}, {{6, 1}, {53, 1}}, {}, {{5, 1}, {54, 1}}, {}, {}}
        for y, row in ipairs(drawArea) do
            for _, chunk in ipairs(row) do
                textures["textures.base"]:fill(chunk[1], y - 1, chunk[2], 1, math.map(y, 1, 56, Color.Color[1].x, Color.Color[2].x), math.map(y, 1, 56, Color.Color[1].y, Color.Color[2].y), math.map(y, 1, 56, Color.Color[1].z, Color.Color[2].z))
            end
        end
        textures["textures.base"]:update()
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
    end,

    ---開発用。羽の描画データを出力する。
    ---@param texture Texture 走査するテクスチャ
    printWingDrawData = function(texture)
        local data = {}
        for y = 0, 55 do
            local dataRow = {}
            local strokeStart = 0
            local strokeLength = 0
            for x = 0, 59 do
                ---ストロークの終了処理
                local function strokeEnd()
                    table.insert(dataRow, {strokeStart, strokeLength})
                    strokeLength = 0
                end

                if texture:getPixel(x, y) == vectors.vec4(1, 1, 1, 1) then
                    if strokeLength == 0 then
                        strokeStart = x
                    end
                    strokeLength = strokeLength + 1
                    if x == 59 and strokeLength > 0 then
                        strokeEnd()
                    end
                elseif strokeLength > 0 then
                    strokeEnd()
                end
            end
            table.insert(data, dataRow)
        end
        local dataString = "{"

        ---dataStringに文字列を追加する。
        ---@param stringToAdd string 追加する文字列
        local function addDataString(stringToAdd)
            dataString = dataString..stringToAdd
        end

        for _, dataRow in ipairs(data) do
            addDataString("{")
            if #dataRow > 0 then
                for _, dataChunk in ipairs(dataRow) do
                    addDataString("{"..dataChunk[1]..", "..dataChunk[2].."}, ")
                end
                dataString = dataString:sub(1, -3).."}, "
            else
                addDataString("}, ")
            end
        end
        dataString = dataString:sub(1, -3).."}"
        print(dataString)
    end
}

Color.drawWingGradation()
Color.setFeelerTipColor()
Color.setEdgeColor()
Color.setPatternColor()
Color.setOpacity()

return Color