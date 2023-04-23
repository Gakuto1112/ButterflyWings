---@class ActionWheel アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field CopiedColor Vector3|nil カラーパレットでコピーされた色

ActionWheel = {
    MainPage = action_wheel:newPage(),
    CopiedColor = nil
}

--ping関数
---色1（グラデーション1）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor1(newColor)
    Color.Color[1] = newColor
    Color.drawWingGradation()
    Color.setFeelerTipColor()
end

---色2（グラデーション2）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor2(newColor)
    Color.Color[2] = newColor
    Color.drawWingGradation()
end

---色3（縁）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor3(newColor)
    Color.Color[3] = newColor
    Color.setEdgeColor()
end

---色4（模様）を設定する。
---@param newColor Vector3 新しい色
function pings.setColor4(newColor)
    Color.Color[4] = newColor
    Color.setPatternColor()
end

---羽の発光を設定する。
---@param glow boolean 羽を発光させるかどうか
function pings.setWingGlow(glow)
    Wing.setGlowing(glow)
end

if host:isHost() then
    ---ユーザが色を選択可能なカラーピッカーを表示する。
    ---@param currentColor Vector3 現在の色。
    ---@param defaultColor Vector3 デフォルトの色
    ---@param callbackFunction function 色が決定された時に実行する関数（引数1<Vector3>：新しい色）
    local function colorPicker(currentColor, defaultColor, callbackFunction)
        local colorPickerPage = action_wheel:newPage()
        local sprintKey = keybinds:fromVanilla("key.sprint")
        local currentColorHSVInt = nil

        ---カラー選択アクションのタイトルを設定する。
        ---@param index integer アクションのインデックス（2-4）
        local function setColorActionTitle(index)
            colorPickerPage:getAction(index):title(Locale.getTranslate("action_wheel__color_picker__action_"..index)..currentColorHSVInt[index - 1]..Locale.getTranslate("action_wheel__color_picker__message_fast_scroll"))
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
        colorPickerPage:newAction(1):title(Locale.getTranslate("action_wheel__color_picker__action_1"))

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
            currentColorHSVInt[index - 1] = currentColorHSVInt[index - 1] + addValue
            currentColorHSVInt[index - 1] = currentColorHSVInt[index - 1] < 0 and 0 or (currentColorHSVInt[index - 1] > 100 and 100 or currentColorHSVInt[index - 1])
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
        colorPickerPage:newAction(5):title(Locale.getTranslate("action_wheel__color_picker__action_5")):item("book"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
            ActionWheel.CopiedColor = HSVInttoRGB()
            print(Locale.getTranslate("action_wheel__color_picker__action_5__copy"))
        end):onRightClick(function ()
            if ActionWheel.CopiedColor ~= nil then
                RGBToHSVInt(ActionWheel.CopiedColor)
                print(Locale.getTranslate("action_wheel__color_picker__action_5__paste"))
            else
                print(Locale.getTranslate("action_wheel__color_picker__action_5__no_paste_color"))
            end
        end)

        --アクション6. デフォルトにリセット
        colorPickerPage:newAction(6):title(Locale.getTranslate("action_wheel__color_picker__action_6")):item("white_dye"):color(defaultColor):hoverColor(1, 1, 1):onLeftClick(function ()
            RGBToHSVInt(defaultColor)
        end)

        ---カラーピッカーを終了させる関数
        ---@param saveColor boolean 色を保存したかどうか
        local function exit(saveColor)
            if saveColor then
                callbackFunction(HSVInttoRGB())
            end
            action_wheel:setPage(ActionWheel.MainPage)
        end

        --アクション7. 保存して/保存せずに終了
        colorPickerPage:newAction(7):title(Locale.getTranslate("action_wheel__color_picker__action_7")):item("barrier"):color(0.67):hoverColor(1, 0.33, 0.33):onLeftClick(function ()
            exit(true)
        end):onRightClick(function ()
            exit(false)
        end)

        RGBToHSVInt(currentColor)
        action_wheel:setPage(colorPickerPage)
    end

    --メインページのアクションの設定
    --アクション1. 色変更（グラデーション1）
    ActionWheel.MainPage:newAction(1):title(Locale.getTranslate("action_wheel__main__action_1")):item("red_dye"):color(Color.Color[1]):hoverColor(1, 1, 1):onLeftClick(function (action)
        colorPicker(Color.Color[1], vectors.vec3(0.69, 0.51, 0.84), function (newColor)
            pings.setColor1(newColor)
            Config.saveConfig("color1", newColor)
            action:color(newColor)
            print(Locale.getTranslate("action_wheel__color_picker__message__done"))
        end)
    end)

    --アクション2. 色変更（グラデーション2）
    ActionWheel.MainPage:newAction(2):title(Locale.getTranslate("action_wheel__main__action_2")):item("yellow_dye"):color(Color.Color[2]):hoverColor(1, 1, 1):onLeftClick(function (action)
        colorPicker(Color.Color[2], vectors.vec3(0.02, 0.96, 0.97), function (newColor)
            pings.setColor2(newColor)
            Config.saveConfig("color2", newColor)
            action:color(newColor)
            print(Locale.getTranslate("action_wheel__color_picker__message__done"))
        end)
    end)

    --アクション3. 色変更（縁）
    ActionWheel.MainPage:newAction(3):title(Locale.getTranslate("action_wheel__main__action_3")):item("green_dye"):color(Color.Color[3]):hoverColor(1, 1, 1):onLeftClick(function (action)
        colorPicker(Color.Color[3], vectors.vec3(0.2, 0.05, 0.04), function (newColor)
            pings.setColor3(newColor)
            Config.saveConfig("color3", newColor)
            action:color(newColor)
            print(Locale.getTranslate("action_wheel__color_picker__message__done"))
        end)
    end)

    --アクション4. 色変更（模様）
    ActionWheel.MainPage:newAction(4):title(Locale.getTranslate("action_wheel__main__action_4")):item("blue_dye"):color(Color.Color[4]):hoverColor(1, 1, 1):onLeftClick(function (action)
        colorPicker(Color.Color[4], vectors.vec3(0.27, 0.13, 0.45), function (newColor)
            pings.setColor4(newColor)
            Config.saveConfig("color4", newColor)
            action:color(newColor)
            print(Locale.getTranslate("action_wheel__color_picker__message__done"))
        end)
    end)

    --アクション5. 羽の発光
    ActionWheel.MainPage:newAction(5):title(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_off")):toggleTitle(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_on")):item("glow_ink_sac"):color(0.67):toggleColor(0, 0.67):hoverColor(1, 0.33, 0.33):onToggle(function (_, action)
        pings.setWingGlow(true)
        Config.saveConfig("wingGlow", true)
        action:hoverColor(0.33, 1, 0.33)
    end):onUntoggle(function (_, action)
        pings.setWingGlow(false)
        Config.saveConfig("wingGlow", false)
        action:hoverColor(1, 0.33, 0.33)
    end)
    if Config.loadConfig("wingGlow", true) then
		local action = ActionWheel.MainPage:getAction(5)
        Wing.setGlowing(true)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    action_wheel:setPage(ActionWheel.MainPage)
end

return ActionWheel