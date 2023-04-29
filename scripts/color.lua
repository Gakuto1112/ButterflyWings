---@alias TatterLevel
---| "NONE"
---| "SOFT"
---| "HARD"

---@class Color アバターのカスタマイズ可能な色を制御するクラス
---@field Color table<Vector3> 管理する色のテーブル：1. グラデーション1, 2. グラデーション2, 3. 縁, 4. 模様
---@field Palette table<table<Vector3|number>> カラーパレットのテーブル（読み込みはアクションホイールで行う）
---@field Opacity number 羽や触角の透明度
---@field TatterState TatterLevel 羽のボロボロの度合い
---@field SoftTatterDrawData table<table<table<integer>>> 羽が少しボロボロになっている状態の描画データ
---@field HardTatterDrawData table<table<table<integer>>> 羽が酷くボロボロになっている状態の描画データ

Color = {
    Color = {Config.loadConfig("color1", vectors.vec3(0.69, 0.51, 0.84)), Config.loadConfig("color2", vectors.vec3(0.02, 0.96, 0.97)), Config.loadConfig("color3", vectors.vec3(0.2, 0.05, 0.04)), Config.loadConfig("color4", vectors.vec3(0.27, 0.13, 0.45))},
    Palette = {},
    Opacity = Config.loadConfig("opacity", 0.75),
    TatterState = "NONE",
    SoftTatterDrawData = {{{3, 1}}, {{1, 4}}, {{2, 2}, {15, 3}}, {{16, 2}}, {}, {{49, 2}}, {{36, 1}, {48, 4}}, {{35, 3}, {49, 2}}, {{24, 2}, {35, 2}}, {{2, 2}, {25, 2}}, {{2, 3}}, {{3, 1}}, {{32, 1}}, {{31, 3}}, {{31, 2}}, {{53, 1}}, {{52, 3}}, {{7, 1}, {52, 2}}, {{6, 3}, {53, 1}}, {{7, 2}, {37, 1}}, {{7, 1}, {36, 3}}, {}, {}, {{34, 2}}, {{35, 5}}, {{36, 3}}, {{12, 2}, {45, 3}}, {{11, 3}, {46, 3}}, {{12, 1}, {47, 3}}, {{48, 1}}, {{27, 2}}, {{26, 2}}, {{27, 1}}, {{7, 1}, {33, 1}}, {{7, 2}, {33, 2}}, {{6, 2}, {34, 1}, {52, 2}}, {{53, 2}}, {{52, 3}}, {{52, 2}}, {{53, 1}}, {{54, 1}}, {}, {{6, 1}}, {{6, 2}}, {{5, 2}, {20, 2}}, {{19, 2}}, {{20, 1}, {39, 2}}, {{13, 1}, {40, 2}}, {{12, 3}}, {{12, 1}, {15, 1}}, {}, {}, {}, {}, {}, {}},
    HardTatterDrawData = {{{3, 1}, {53, 4}}, {{1, 4}, {54, 5}}, {{2, 2}, {14, 4}, {50, 1}, {56, 4}}, {{14, 4}, {49, 3}, {56, 4}}, {{15, 2}, {47, 2}, {50, 1}, {57, 3}}, {{11, 1}, {46, 5}, {56, 4}}, {{10, 3}, {36, 1}, {47, 5}, {56, 4}}, {{10, 4}, {23, 2}, {35, 3}, {48, 3}, {56, 3}}, {{3, 2}, {10, 4}, {23, 3}, {35, 2}, {48, 2}, {57, 2}}, {{2, 3}, {11, 2}, {24, 3}, {47, 4}}, {{2, 4}, {48, 4}}, {{3, 2}, {32, 2}, {49, 2}}, {{3, 1}, {32, 3}}, {{31, 5}, {53, 2}}, {{31, 5}, {52, 4}}, {{34, 1}, {52, 3}}, {{6, 2}, {52, 3}}, {{6, 4}, {52, 2}}, {{6, 3}, {22, 2}, {25, 1}, {39, 2}, {53, 1}}, {{7, 2}, {14, 1}, {16, 2}, {22, 3}, {37, 6}}, {{7, 1}, {14, 4}, {22, 2}, {36, 8}}, {{13, 4}, {40, 3}, {46, 2}}, {{13, 3}, {45, 4}}, {{34, 2}}, {{20, 3}, {35, 5}}, {{19, 5}, {36, 3}}, {{12, 2}, {20, 3}, {45, 3}}, {{11, 3}, {46, 3}}, {{10, 4}, {26, 2}, {46, 4}}, {{10, 5}, {25, 4}, {47, 4}}, {{11, 3}, {25, 4}, {40, 1}, {47, 3}}, {{25, 3}, {39, 3}, {48, 1}}, {{25, 3}, {34, 1}, {39, 4}}, {{7, 1}, {26, 1}, {33, 3}, {40, 4}}, {{7, 2}, {33, 3}, {41, 2}}, {{6, 4}, {34, 2}, {52, 2}}, {{5, 5}, {34, 1}, {53, 2}}, {{6, 3}, {52, 3}}, {{22, 1}, {52, 2}}, {{21, 3}, {53, 1}}, {{7, 2}, {22, 2}, {54, 1}}, {{6, 4}, {37, 3}}, {{6, 3}, {22, 1}, {37, 4}}, {{6, 4}, {20, 2}, {38, 3}}, {{5, 4}, {20, 2}, {38, 3}, {53, 2}}, {{13, 1}, {19, 2}, {39, 2}, {52, 3}}, {{12, 3}, {20, 1}, {39, 2}, {50, 4}}, {{12, 3}, {40, 2}, {49, 4}}, {{12, 3}, {47, 6}}, {{12, 1}, {15, 1}, {47, 2}, {50, 4}}, {{51, 3}}, {{52, 3}}, {{5, 1}, {52, 3}}, {{4, 3}, {53, 3}}, {{4, 3}, {53, 3}}, {{5, 1}, {54, 1}}},

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

    ---羽のベーステクスチャを描画する。
    drawBaseTexture = function ()
        local baseDrawData = {{}, {}, {{3, 1}, {8, 4}, {48, 4}, {56, 1}}, {{4, 4}, {12, 3}, {45, 3}, {52, 4}}, {{2, 2}, {7, 5}, {15, 1}, {17, 1}, {42, 1}, {44, 1}, {48, 5}, {56, 2}}, {{4, 3}, {20, 2}, {38, 2}, {53, 3}}, {{2, 2}, {10, 7}, {18, 5}, {37, 5}, {43, 7}, {56, 2}}, {{4, 14}, {19, 5}, {36, 5}, {42, 14}}, {{3, 1}, {5, 13}, {19, 6}, {35, 6}, {42, 13}, {56, 1}}, {{4, 1}, {6, 6}, {18, 1}, {20, 6}, {34, 6}, {41, 1}, {48, 6}, {55, 1}}, {{4, 1}, {12, 8}, {21, 5}, {34, 5}, {40, 8}, {55, 1}}, {{6, 15}, {22, 5}, {33, 5}, {39, 15}}, {{5, 1}, {7, 15}, {23, 4}, {33, 4}, {38, 15}, {54, 1}}, {{6, 1}, {8, 8}, {22, 1}, {24, 4}, {32, 4}, {37, 1}, {44, 8}, {53, 1}}, {{6, 1}, {8, 2}, {16, 8}, {26, 2}, {32, 2}, {36, 8}, {50, 2}, {53, 1}}, {{10, 16}, {28, 1}, {31, 1}, {34, 16}}, {{7, 1}, {9, 19}, {32, 19}, {52, 1}}, {{8, 1}, {10, 12}, {38, 12}, {51, 1}}, {{8, 1}, {10, 6}, {22, 7}, {31, 7}, {44, 6}, {51, 1}}, {{9, 1}, {16, 8}, {36, 8}, {50, 1}}, {{10, 1}, {12, 8}, {40, 8}, {49, 1}}, {{10, 1}, {12, 4}, {44, 4}, {49, 1}}, {}, {}, {{24, 5}, {31, 5}}, {{20, 8}, {32, 8}}, {{16, 9}, {28, 1}, {31, 1}, {35, 9}}, {{13, 3}, {20, 2}, {25, 4}, {31, 4}, {38, 2}, {44, 3}}, {{12, 8}, {22, 4}, {28, 1}, {31, 1}, {34, 4}, {40, 8}}, {{13, 5}, {20, 4}, {26, 2}, {32, 2}, {36, 4}, {42, 5}}, {{11, 2}, {16, 1}, {18, 5}, {24, 2}, {27, 1}, {32, 1}, {34, 2}, {37, 5}, {43, 1}, {47, 2}}, {{10, 6}, {17, 5}, {23, 1}, {25, 2}, {33, 2}, {36, 1}, {38, 5}, {44, 6}}, {{10, 5}, {16, 5}, {22, 2}, {25, 2}, {33, 2}, {36, 2}, {39, 5}, {45, 5}}, {{11, 3}, {15, 5}, {21, 1}, {23, 2}, {35, 2}, {38, 1}, {40, 5}, {46, 3}}, {{10, 1}, {15, 4}, {20, 2}, {23, 3}, {34, 3}, {38, 2}, {41, 4}, {49, 1}}, {{8, 6}, {15, 3}, {19, 4}, {24, 1}, {35, 1}, {37, 4}, {42, 3}, {46, 6}}, {{8, 4}, {14, 1}, {18, 1}, {20, 3}, {24, 1}, {35, 1}, {37, 3}, {41, 1}, {45, 1}, {48, 4}}, {{8, 2}, {12, 2}, {15, 2}, {18, 1}, {20, 4}, {36, 4}, {41, 1}, {43, 2}, {46, 2}, {50, 2}}, {{8, 1}, {10, 4}, {15, 2}, {18, 2}, {21, 3}, {36, 3}, {40, 2}, {43, 2}, {46, 4}, {51, 1}}, {{9, 4}, {14, 3}, {18, 2}, {21, 2}, {37, 2}, {40, 2}, {43, 3}, {47, 4}}, {{8, 5}, {14, 2}, {17, 4}, {22, 1}, {37, 1}, {39, 4}, {44, 2}, {47, 5}}, {{8, 4}, {13, 3}, {17, 5}, {38, 5}, {44, 3}, {48, 4}}, {{8, 4}, {13, 3}, {17, 5}, {38, 5}, {44, 3}, {48, 4}}, {{8, 3}, {12, 3}, {16, 5}, {39, 5}, {45, 3}, {49, 3}}, {{9, 2}, {12, 3}, {16, 5}, {39, 5}, {45, 3}, {49, 2}}, {{9, 1}, {11, 4}, {16, 4}, {40, 4}, {45, 4}, {50, 1}}, {{11, 3}, {15, 3}, {42, 3}, {46, 3}}, {}, {}, {{7, 1}, {52, 1}}, {}, {{6, 1}, {53, 1}}, {}, {{5, 1}, {54, 1}}, {}, {}}
        for y = 1, 56 do
            for _, chunk in ipairs(baseDrawData[y]) do
                textures["base"]:fill(chunk[1], y - 1, chunk[2], 1, math.map(y, 1, 56, Color.Color[1].x, Color.Color[2].x), math.map(y, 1, 56, Color.Color[1].y, Color.Color[2].y), math.map(y, 1, 56, Color.Color[1].z, Color.Color[2].z))
            end
            if Color.TatterState == "SOFT" then
                for _, chunk in ipairs(Color.SoftTatterDrawData[y]) do
                    textures["base"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            elseif Color.TatterState == "HARD" then
                for _, chunk in ipairs(Color.HardTatterDrawData[y]) do
                    textures["base"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            end
        end
        textures["base"]:update()
    end,

    ---羽の縁テクスチャを描画する。
    drawEdgeTexture = function()
        local edgeDrawData = {{{3, 9}, {48, 9}}, {{1, 14}, {45, 14}}, {{0, 3}, {4, 4}, {12, 6}, {42, 6}, {52, 4}, {57, 3}}, {{0, 4}, {8, 4}, {15, 5}, {40, 5}, {48, 4}, {56, 4}}, {{0, 2}, {4, 3}, {12, 3}, {16, 1}, {18, 4}, {38, 4}, {43, 1}, {45, 3}, {53, 3}, {58, 2}}, {{0, 4}, {7, 13}, {22, 1}, {37, 1}, {40, 13}, {56, 4}}, {{0, 2}, {4, 6}, {23, 1}, {36, 1}, {50, 6}, {58, 2}}, {{1, 3}, {24, 1}, {35, 1}, {56, 3}}, {{1, 2}, {25, 1}, {34, 1}, {57, 2}}, {{2, 2}, {26, 1}, {33, 1}, {56, 2}}, {{2, 2}, {26, 1}, {33, 1}, {56, 2}}, {{3, 2}, {27, 1}, {32, 1}, {55, 2}}, {{3, 2}, {27, 1}, {32, 1}, {55, 2}}, {{4, 2}, {28, 1}, {31, 1}, {54, 2}}, {{4, 2}, {28, 1}, {31, 1}, {54, 2}}, {{5, 2}, {29, 2}, {53, 2}}, {{5, 2}, {29, 2}, {53, 2}}, {{6, 2}, {29, 2}, {52, 2}}, {{6, 2}, {29, 2}, {52, 2}}, {{7, 2}, {24, 12}, {51, 2}}, {{7, 3}, {20, 4}, {36, 4}, {50, 3}}, {{8, 2}, {16, 4}, {40, 4}, {50, 2}}, {{9, 7}, {44, 7}}, {{24, 12}}, {{20, 4}, {29, 2}, {36, 4}}, {{16, 4}, {29, 2}, {40, 4}}, {{12, 4}, {29, 2}, {44, 4}}, {{11, 2}, {29, 2}, {47, 2}}, {{10, 2}, {29, 2}, {48, 2}}, {{9, 3}, {28, 1}, {31, 1}, {48, 3}}, {{9, 2}, {28, 1}, {31, 1}, {49, 2}}, {{8, 2}, {27, 1}, {32, 1}, {50, 2}}, {{8, 2}, {27, 1}, {32, 1}, {50, 2}}, {{7, 3}, {26, 1}, {33, 1}, {50, 3}}, {{7, 3}, {26, 1}, {33, 1}, {50, 3}}, {{6, 2}, {25, 1}, {34, 1}, {52, 2}}, {{5, 3}, {25, 1}, {34, 1}, {52, 3}}, {{5, 3}, {24, 1}, {35, 1}, {52, 3}}, {{6, 2}, {24, 1}, {35, 1}, {52, 2}}, {{6, 2}, {23, 1}, {36, 1}, {52, 2}}, {{5, 3}, {23, 1}, {36, 1}, {52, 3}}, {{5, 3}, {22, 1}, {37, 1}, {52, 3}}, {{6, 2}, {22, 1}, {37, 1}, {52, 2}}, {{6, 2}, {21, 1}, {38, 1}, {52, 2}}, {{5, 4}, {21, 1}, {38, 1}, {51, 4}}, {{5, 4}, {20, 1}, {39, 1}, {51, 4}}, {{6, 5}, {18, 3}, {39, 3}, {49, 5}}, {{7, 13}, {40, 13}}, {{7, 11}, {42, 11}}, {{6, 1}, {8, 2}, {11, 2}, {15, 2}, {43, 2}, {47, 2}, {50, 2}, {53, 1}}, {{6, 3}, {51, 3}}, {{5, 1}, {7, 1}, {52, 1}, {54, 1}}, {{5, 3}, {52, 3}}, {{4, 1}, {6, 1}, {53, 1}, {55, 1}}, {{4, 3}, {53, 3}}, {{5, 1}, {54, 1}}}
        for y = 1, 56 do
            for _, chunk in ipairs(edgeDrawData[y]) do
                textures["edge"]:fill(chunk[1], y - 1, chunk[2], 1, Color.Color[3])
            end
            if Color.TatterState == "SOFT" then
                for _, chunk in ipairs(Color.SoftTatterDrawData[y]) do
                    textures["edge"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            elseif Color.TatterState == "HARD" then
                for _, chunk in ipairs(Color.HardTatterDrawData[y]) do
                    textures["edge"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            end
        end
        textures["edge"]:update()
    end,

    ---羽の模様テクスチャを描画する。
    drawPatternTexture = function()
        local patternDrawData = {{}, {}, {}, {}, {}, {}, {{17, 1}, {42, 1}}, {{18, 1}, {41, 1}}, {{4, 1}, {18, 1}, {41, 1}, {55, 1}}, {{5, 1}, {12, 6}, {19, 1}, {40, 1}, {42, 6}, {54, 1}}, {{5, 7}, {20, 1}, {39, 1}, {48, 7}}, {{5, 1}, {21, 1}, {38, 1}, {54, 1}}, {{6, 1}, {22, 1}, {37, 1}, {53, 1}}, {{7, 1}, {16, 6}, {23, 1}, {36, 1}, {38, 6}, {52, 1}}, {{7, 1}, {10, 6}, {24, 2}, {34, 2}, {44, 6}, {52, 1}}, {{7, 3}, {26, 2}, {32, 2}, {50, 3}}, {{8, 1}, {28, 1}, {31, 1}, {51, 1}}, {{9, 1}, {22, 7}, {31, 7}, {50, 1}}, {{9, 1}, {16, 6}, {38, 6}, {50, 1}}, {{10, 6}, {44, 6}}, {{11, 1}, {48, 1}}, {{11, 1}, {48, 1}}, {}, {}, {}, {{28, 1}, {31, 1}}, {{25, 3}, {32, 3}}, {{12, 1}, {16, 4}, {22, 3}, {35, 3}, {40, 4}, {47, 1}}, {{20, 2}, {26, 2}, {32, 2}, {38, 2}}, {{12, 1}, {18, 2}, {24, 2}, {34, 2}, {40, 2}, {47, 1}}, {{13, 3}, {17, 1}, {23, 1}, {26, 1}, {33, 1}, {36, 1}, {42, 1}, {44, 3}}, {{16, 1}, {22, 1}, {24, 1}, {35, 1}, {37, 1}, {43, 1}}, {{15, 1}, {21, 1}, {24, 1}, {35, 1}, {38, 1}, {44, 1}}, {{10, 1}, {14, 1}, {20, 1}, {22, 1}, {25, 1}, {34, 1}, {37, 1}, {39, 1}, {45, 1}, {49, 1}}, {{11, 4}, {19, 1}, {22, 1}, {37, 1}, {40, 1}, {45, 4}}, {{14, 1}, {18, 1}, {23, 1}, {36, 1}, {41, 1}, {45, 1}}, {{12, 2}, {15, 3}, {19, 1}, {23, 1}, {36, 1}, {40, 1}, {42, 3}, {46, 2}}, {{10, 2}, {14, 1}, {17, 1}, {19, 1}, {40, 1}, {42, 1}, {45, 1}, {48, 2}}, {{9, 1}, {14, 1}, {17, 1}, {20, 1}, {39, 1}, {42, 1}, {45, 1}, {50, 1}}, {{8, 1}, {13, 1}, {17, 1}, {20, 1}, {39, 1}, {42, 1}, {46, 1}, {51, 1}}, {{13, 1}, {16, 1}, {21, 1}, {38, 1}, {43, 1}, {46, 1}}, {{12, 1}, {16, 1}, {43, 1}, {47, 1}}, {{12, 1}, {16, 1}, {43, 1}, {47, 1}}, {{11, 1}, {15, 1}, {44, 1}, {48, 1}}, {{11, 1}, {15, 1}, {44, 1}, {48, 1}}, {{10, 1}, {15, 1}, {44, 1}, {49, 1}}, {{14, 1}, {45, 1}}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
        for y = 1, 56 do
            for _, chunk in ipairs(patternDrawData[y]) do
                textures["pattern"]:fill(chunk[1], y - 1, chunk[2], 1, Color.Color[4])
            end
            if Color.TatterState == "SOFT" then
                for _, chunk in ipairs(Color.SoftTatterDrawData[y]) do
                    textures["pattern"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            elseif Color.TatterState == "HARD" then
                for _, chunk in ipairs(Color.HardTatterDrawData[y]) do
                    textures["pattern"]:fill(chunk[1], y - 1, chunk[2], 1, 0, 0, 0, 0)
                end
            end
        end
        textures["pattern"]:update()
    end,

    ---触角の先の色を設定する。
    setFeelerTipColor = function ()
        for _, modelPart in ipairs({models.models.main.Player.Head.ButterflyH.RightFeeler1.RightFeeler2.RightFeelerTip.RightColoredTip, models.models.main.Player.Head.ButterflyH.LeftFeeler1.LeftFeeler2.LeftFeelerTip.LeftColoredTip}) do
            modelPart:setColor(Color.Color[1])
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

for _, textureName in ipairs({"base", "edge", "pattern"}) do
    textures:newTexture(textureName, 60, 56)
    textures[textureName]:fill(0, 0, 60, 56, 0, 0, 0, 0)
end
for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Base, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Base, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Base}) do
    modelPart:setPrimaryTexture("CUSTOM", textures["base"])
end
for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Edge, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Edge, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Edge, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Edge}) do
    modelPart:setPrimaryTexture("CUSTOM", textures["edge"])
end
for _, modelPart in ipairs({models.models.main.Player.Body.ButterflyB.RightWing.RightTopWing.Pattern, models.models.main.Player.Body.ButterflyB.RightWing.RightBottomWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftTopWing.Pattern, models.models.main.Player.Body.ButterflyB.LeftWing.LeftBottomWing.Pattern}) do
    modelPart:setPrimaryTexture("CUSTOM", textures["pattern"])
end

Color.drawBaseTexture()
Color.drawEdgeTexture()
Color.drawPatternTexture()
Color.setFeelerTipColor()
Color.setOpacity()

return Color