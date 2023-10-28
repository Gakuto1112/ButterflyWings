---@class ActionWheel アクションホイールを制御するクラス

---アクションホイールのメインページ
---@type Page
local mainPage = action_wheel:newPage()

---アクションホイールのカラーパレットのページ
---@type Page
local palettePage = action_wheel:newPage()

---前チックにアクションホイールを開いていたかどうか
---@type boolean
local isOpenActionWheelPrev = false

---メインページの初期処理を行ったかどうか
---@type boolean
local mainPageInit = false

---カラーパレットのページの初期処理を行ったかどうか
---@type boolean
local palettePageInit = false

---カラーピッカーでコピーされた色
---@type Vector3|nil
local copiedColor = nil

---羽の透明度
---@type number
local wingOpacity = Config.loadConfig("opacity", 0.75)

---現在の羽の透明度
---@type number
local currentWingOpacity = wingOpacity

---羽のパーティクルの長さ
---@type number
local particleDuration = Config.loadConfig("particleDuration", 2)

---現在の羽のパーティクルの長さ
---@type number
local currentParticleDuration = particleDuration

---パレットのインポートの初回メッセージを表示したかどうか
---@type boolean
local paletteImportMessage = false


--ping関数
---色1（グラデーション1）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor1(newColor)
    Color.Color[1] = newColor
    Color.drawBaseTexture()
    Color.setFeelerTipColor()
end

---色2（グラデーション2）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor2(newColor)
    Color.Color[2] = newColor
    Color.drawBaseTexture()
end

---色3（縁）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor3(newColor)
    Color.Color[3] = newColor
    Color.drawEdgeTexture()
    Color.setFeelerBaseColor()
end

---色4（模様）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor4(newColor)
    Color.Color[4] = newColor
    Color.drawPatternTexture()
end

---羽の透明度を設定する。
---@param newOpacity number 新しい透明度
function pings.setOpacity(newOpacity)
    Color.Opacity = newOpacity
    Color.setOpacity()
end

---羽の発光を設定する。
---@param glow boolean 羽を発光させるかどうか
function pings.setWingGlow(glow)
    Wing.setGlowing(glow)
end

---羽のパーティクルの長さを設定する。
---@param newDuration number 新しい長さの値
function pings.setParticleDuration(newDuration)
    Wing.ParticleDuration = newDuration
end

---透明度変更アクションのタイトルを設定する。
local function setOpacityActionTitle()
    mainPage:getAction(5):title(Locale.getTranslate("action_wheel__main__action_5")..math.round(wingOpacity * 100)..Locale.getTranslate("action_wheel__picker__message__fast_scroll"))
end

---現在のカラーパレットを設定する。
---@param palette table<Vector3|number> パレット情報
function pings.setPalette(palette)
    Color.Color = {palette[1], palette[2], palette[3], palette[4]}
    Color.drawAllTexture()
    Color.setFeelerBaseColor()
    Color.setFeelerTipColor()
    Color.Opacity = palette[5]
    Color.setOpacity()
    wingOpacity = palette[5]
    currentWingOpacity = wingOpacity
    setOpacityActionTitle()
end

if host:isHost() then
    ---パーティクルの出現時間変更アクションのタイトルを設定する。
    local function setParticleDurationActionTitle()
        mainPage:getAction(7):title(Locale.getTranslate("action_wheel__main__action_7")..Locale.getTranslate(particleDuration == 0 and "action_wheel__main__action_7__none" or (particleDuration == 1 and "action_wheel__main__action_7__short" or (particleDuration == 2 and "action_wheel__main__action_7__normal" or (particleDuration == 3 and "action_wheel__main__action_7__long" or "action_wheel__main__action_7__very_long")))))
    end

    local sprintKey = keybinds:fromVanilla("key.sprint")
    ---ユーザが色を選択可能なカラーピッカーを表示する。
    ---@param currentColor Vector3 現在の色。
    ---@param defaultColor Vector3 デフォルトの色
    ---@param callbackFunction function 色が決定された時に実行する関数（引数1<Vector3>：新しい色）
    local function colorPicker(currentColor, defaultColor, callbackFunction)
        local colorPickerPage = action_wheel:newPage()
        local currentColorHSVInt = nil

        ---カラー選択アクションのタイトルを設定する。
        ---@param index integer アクションのインデックス（2-4）
        local function setColorActionTitle(index)
            colorPickerPage:getAction(index):title(Locale.getTranslate("action_wheel__picker__action_"..index)..currentColorHSVInt[index - 1]..Locale.getTranslate("action_wheel__picker__message__fast_scroll"))
        end

        ---HSVIntをRGBに変換する。
        ---@return Vector3 colorRGB 変換されたRGBカラー
        local function HSVInttoRGB()
            return vectors.hsvToRGB(currentColorHSVInt:copy():applyFunc(function (value, index)
                return value / (index == 1 and 360 or 100)
            end))
        end

        ---プレビューカラーを設定する。
        local function setPreviewColor()
            local color = HSVInttoRGB()
            colorPickerPage:getAction(1):color(color):hoverColor(color)
        end

        ---RGBをHSVIntに変換し、変数に代入し、各所を更新する。
        ---@param color Vector3 変換するRGBカラー
        local function RGBToHSVInt(color)
            currentColorHSVInt = vectors.rgbToHSV(color):applyFunc(function (value, index)
                return math.floor(value * (index == 1 and 360 or 100))
            end)
            for i = 2, 4 do
                setColorActionTitle(i)
            end
            setPreviewColor()
        end

        --カラーピッカーのアクションの設定
        --アクション1. 現在の色
        colorPickerPage:newAction(1):title(Locale.getTranslate("action_wheel__picker__action_1"))

        --アクション2. H（色相）
        colorPickerPage:newAction(2):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
            local addValue = (direction > 0 and 1 or -1) * (sprintKey:isPressed() and 10 or 1)
            currentColorHSVInt[1] = currentColorHSVInt[1] + addValue
            currentColorHSVInt[1] = currentColorHSVInt[1] < 0 and currentColorHSVInt[1] + 360 or (currentColorHSVInt[1] > 360 and currentColorHSVInt[1] - 360 or currentColorHSVInt[1])
            setColorActionTitle(2)
            setPreviewColor()
        end)

        ---彩度と明度のスクロール関数
        ---@param index integer アクションのインデックス
        local function SVScroll(index, direction)
            local addValue = (direction > 0 and 1 or -1) * (sprintKey:isPressed() and 5 or 1)
            currentColorHSVInt[index - 1] = math.clamp(currentColorHSVInt[index - 1] + addValue, 0, 100)
            setColorActionTitle(index)
            setPreviewColor()
        end

        --アクション3. S（彩度）
        colorPickerPage:newAction(3):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
            SVScroll(3, direction)
        end)

        --アクション4. V（明度）
        colorPickerPage:newAction(4):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
            SVScroll(4, direction)
        end)

        --アクション5. コピー/貼り付け
        colorPickerPage:newAction(5):title(Locale.getTranslate("action_wheel__picker__action_5")):item("book"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
            copiedColor = HSVInttoRGB()
            print(Locale.getTranslate("action_wheel__picker__action_5__copy"))
        end):onRightClick(function ()
            if copiedColor ~= nil then
                RGBToHSVInt(copiedColor)
                print(Locale.getTranslate("action_wheel__picker__action_5__paste"))
            else
                print(Locale.getTranslate("action_wheel__picker__action_5__no_paste_color"))
            end
        end)

        --アクション6. デフォルトにリセット
        colorPickerPage:newAction(6):title(Locale.getTranslate("action_wheel__picker__action_6")):item("white_dye"):color(defaultColor):hoverColor(1, 1, 1):onLeftClick(function ()
            RGBToHSVInt(defaultColor)
        end)

        ---カラーピッカーを終了させる関数
        ---@param saveColor boolean 色を保存したかどうか
        local function exit(saveColor)
            if saveColor then
                callbackFunction(HSVInttoRGB())
            end
            action_wheel:setPage(mainPage)
        end

        --アクション7. 保存して/保存せずに終了
        colorPickerPage:newAction(7):title(Locale.getTranslate("action_wheel__picker__action_7")):item("barrier"):color(0.67):hoverColor(1, 0.33, 0.33):onLeftClick(function ()
            exit(true)
        end):onRightClick(function ()
            exit(false)
        end)

        RGBToHSVInt(currentColor)
        action_wheel:setPage(colorPickerPage)
    end

    ---現在のカラーパレットを設定する。
    ---@param palette table<Vector3|number> 設定するパレット
    local function setCurrentPalette(palette)
        pings.setPalette(palette)
        Color.setPaletteColorSet(0, palette, true)
        for i = 1, 4 do
            Config.saveConfig("color"..i, palette[i])
        end
        Config.saveConfig("opacity", palette[5])
    end

    events.TICK:register(function ()
        local isOpenActionWheel = action_wheel:isEnabled()
        if isOpenActionWheel and not mainPageInit then
            setOpacityActionTitle()
            setParticleDurationActionTitle()
            Color.setPaletteColorSet(0, Color.Color, true)
            mainPageInit = true
        end
        if not isOpenActionWheel and isOpenActionWheelPrev then
            if wingOpacity ~= currentWingOpacity then
                pings.setOpacity(wingOpacity)
                Config.saveConfig("opacity", wingOpacity)
                currentWingOpacity = wingOpacity
            end
            if particleDuration ~= currentParticleDuration then
                pings.setParticleDuration(particleDuration)
                Config.saveConfig("particleDuration", particleDuration)
                currentParticleDuration = particleDuration
            end
        end
        isOpenActionWheelPrev = isOpenActionWheel
    end)

    --メインページのアクションの設定
    --アクション1. 色変更（グラデーション1）
    mainPage:newAction(1):title(Locale.getTranslate("action_wheel__main__action_1")):texture(textures["textures.palette"], 0, 0, 1, 1, 16):color(Color.Color[1]):color(0.67, 0.67):hoverColor(1, 1, 0.33):onLeftClick(function (action)
        colorPicker(Color.Color[1], vectors.vec3(0.69, 0.51, 0.84), function (newColor)
            pings.setColor1(newColor)
            Color.setPaletteColor(1, newColor)
            Config.saveConfig("color1", newColor)
            print(Locale.getTranslate("action_wheel__picker__message__done"))
        end)
    end)

    --アクション2. 色変更（グラデーション2）
    mainPage:newAction(2):title(Locale.getTranslate("action_wheel__main__action_2")):texture(textures["textures.palette"], 1, 0, 1, 1, 16):color(Color.Color[2]):color(0.67, 0.67):hoverColor(1, 1, 0.33):onLeftClick(function (action)
        colorPicker(Color.Color[2], vectors.vec3(0.02, 0.96, 0.97), function (newColor)
            pings.setColor2(newColor)
            Color.setPaletteColor(2, newColor)
            Config.saveConfig("color2", newColor)
            print(Locale.getTranslate("action_wheel__picker__message__done"))
        end)
    end)

    --アクション3. 色変更（縁）
    mainPage:newAction(3):title(Locale.getTranslate("action_wheel__main__action_3")):texture(textures["textures.palette"], 0, 1, 1, 1, 16):color(Color.Color[3]):color(0.67, 0.67):hoverColor(1, 1, 0.33):onLeftClick(function (action)
        colorPicker(Color.Color[3], vectors.vec3(0.2, 0.05, 0.04), function (newColor)
            pings.setColor3(newColor)
            Color.setPaletteColor(3, newColor)
            Config.saveConfig("color3", newColor)
            print(Locale.getTranslate("action_wheel__picker__message__done"))
        end)
    end)

    --アクション4. 色変更（模様）
    mainPage:newAction(4):title(Locale.getTranslate("action_wheel__main__action_4")):texture(textures["textures.palette"], 1, 1, 1, 1, 16):color(Color.Color[4]):color(0.67, 0.67):hoverColor(1, 1, 0.33):onLeftClick(function (action)
        colorPicker(Color.Color[4], vectors.vec3(0.27, 0.13, 0.45), function (newColor)
            pings.setColor4(newColor)
            Color.setPaletteColor(4, newColor)
            Config.saveConfig("color4", newColor)
            print(Locale.getTranslate("action_wheel__picker__message__done"))
        end)
    end)

    --アクション5. 羽の透明度
    mainPage:newAction(5):item("minecraft:glass_pane"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
        wingOpacity = math.clamp(wingOpacity + (direction > 0 and 1 or -1) * (sprintKey:isPressed() and 0.05 or 0.01), 0, 1)
        setOpacityActionTitle()
    end):onLeftClick(function ()
        wingOpacity = currentWingOpacity
        setOpacityActionTitle()
    end):onRightClick(function ()
        wingOpacity = 0.75
        setOpacityActionTitle()
    end)

    --アクション6. 羽の発光
    mainPage:newAction(6):title(Locale.getTranslate("action_wheel__main__action_6")..Locale.getTranslate("action_wheel__toggle_off")):toggleTitle(Locale.getTranslate("action_wheel__main__action_6")..Locale.getTranslate("action_wheel__toggle_on")):item("glow_ink_sac"):color(0.67):toggleColor(0, 0.67):hoverColor(1, 0.33, 0.33):onToggle(function (_, action)
        pings.setWingGlow(true)
        Config.saveConfig("wingGlow", true)
        action:hoverColor(0.33, 1, 0.33)
    end):onUntoggle(function (_, action)
        pings.setWingGlow(false)
        Config.saveConfig("wingGlow", false)
        action:hoverColor(1, 0.33, 0.33)
    end)
    local wingGlow = Config.loadConfig("wingGlow", true)
    Wing.setGlowing(wingGlow)
    if wingGlow then
		local action = mainPage:getAction(6)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    --アクション7. パーティクルの出現時間
    mainPage:newAction(7):item("glowstone_dust"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
        particleDuration = math.clamp(particleDuration + (direction > 0 and 1 or -1), 0, 4)
        setParticleDurationActionTitle()
    end):onLeftClick(function ()
        particleDuration = currentParticleDuration
        setParticleDurationActionTitle()
    end):onRightClick(function ()
        particleDuration = 2
        setParticleDurationActionTitle()
    end)

    --アクション8. カラーパレット
    mainPage:newAction(8):title(Locale.getTranslate("action_wheel__main__action_8")):item("book"):color(0, 0.67, 0.67):hoverColor(0.33, 1, 1):onLeftClick(function ()
        if not palettePageInit then
            for i = 1, 6 do
                table.insert(Color.Palette, Config.loadConfig("palette"..i, {vectors.vec3(0.69, 0.51, 0.84), vectors.vec3(0.02, 0.96, 0.97), vectors.vec3(0.2, 0.05, 0.04), vectors.vec3(0.27, 0.13, 0.45), 0.75}))
                Color.setPaletteColorSet(i, Color.Palette[i], false)
            end
            textures["textures.palette"]:update()
            palettePageInit = true
        end
        action_wheel:setPage(palettePage)
    end)

    --カラーパレットのアクションの設定
    --アクション1. 現在の色
    palettePage:newAction(1):title(Locale.getTranslate("action_wheel__palette__action_1")):texture(textures["textures.palette"], 0, 0, 2, 2, 8):color(0, 0.67, 0.67):hoverColor(0.33, 1, 1):onLeftClick(function ()
        local exportString = ""
        for _, colorVector in ipairs(Color.Color) do
            local color1, color2, color3 = colorVector:unpack()
            exportString = exportString..color1..","..color2..","..color3..","
        end
        exportString = exportString..Color.Opacity
        host:clipboard(exportString)
        print(Locale.getTranslate("action_wheel__palette__message__export"))
    end):onRightClick(function ()
        if paletteImportMessage then
            local dataTable = {}
            for chunk in host:getClipboard():gmatch("[^,]+") do
                table.insert(dataTable, tonumber(chunk))
            end
            if #dataTable == 13 then
                ---数値を色に適合するように0-1の範囲に収める。
                ---@param value number 収める値
                ---@return number clampedValue 収めた値
                local function clampColor(value)
                    return math.clamp(value, 0, 1)
                end

                local palette = {}
                for i = 1, 4 do
                    table.insert(palette, vectors.vec3(clampColor(dataTable[i * 3 - 2]), clampColor(dataTable[i * 3 - 1]), clampColor(dataTable[i * 3])))
                end
                table.insert(palette, clampColor(dataTable[13]))
                setCurrentPalette(palette)
                print(Locale.getTranslate("action_wheel__palette__message__import"))
            else
                print(Locale.getTranslate("action_wheel__palette__message__import_invalid"))
            end
        else
            print(Locale.getTranslate("action_wheel__palette__message__import_init"))
            paletteImportMessage = true
        end
    end)

    --アクション2～7. カラーパレット
    for i = 2, 7 do
        palettePage:newAction(i):title(Locale.getTranslate("action_wheel__palette__action_2")..(i - 1)..Locale.getTranslate("action_wheel__palette__action_2__control")):texture(textures["textures.palette"], (i - 1) * 2, 0, 2, 2, 8):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
            setCurrentPalette(Color.Palette[i - 1])
            print(Locale.getTranslate("action_wheel__palette__message__get_palette"))
    end):onRightClick(function ()
            local palette = {}
            for _, colorVector in ipairs(Color.Color) do
                table.insert(palette, colorVector)
            end
            table.insert(palette, Color.Opacity)
            Color.Palette[i - 1] = palette
            Color.setPaletteColorSet(i - 1, Color.Palette[i - 1], true)
            Config.saveConfig("palette"..(i - 1), Color.Palette[i - 1])
            print(Locale.getTranslate("action_wheel__palette__message__set_palette"))
        end)
    end

    --アクション8. カラーパレットを閉じる
    palettePage:newAction(8):title(Locale.getTranslate("action_wheel__palette__action_8")):item("barrier"):color(0.67):hoverColor(1, 0.33, 0.33):onLeftClick(function ()
        action_wheel:setPage(mainPage)
    end)

    action_wheel:setPage(mainPage)
end