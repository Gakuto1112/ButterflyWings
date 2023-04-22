---@class ActionWheel アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ

ActionWheel = {
    MainPage = action_wheel:newPage()
}

---ユーザが色を選択可能なカラーピッカーを表示する。
---@param currentColor Vector3 現在の色。
---@param defaultColor Vector3 デフォルトの色
---@param callbackFunction function 色が決定された時に実行する関数（引数1<boolean>：色が更新されたか, 引数2<Vector3>：新しい色）
local function colorPicker(currentColor, defaultColor, callbackFunction)
    local colorPickerPage = action_wheel:newPage()
    local color = currentColor
    local currentColorHSVInt = vectors.rgbToHSV(currentColor):applyFunc(function (value, index)
        return math.floor(value * (index == 1 and 360 or 100))
    end)

    --カラーピッカーのアクションの設定
    --アクション1. 現在の色
    colorPickerPage:newAction(1):title(Locale.getTranslate("action_wheel__color_picker__action_1")):color(color):hoverColor(color)

    --アクション2. H（色相）
    colorPickerPage:newAction(2):title(Locale.getTranslate("action_wheel__color_picker__action_2")..currentColorHSVInt[1]):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function ()
    end)

    --アクション3. S（彩度）
    colorPickerPage:newAction(3):title(Locale.getTranslate("action_wheel__color_picker__action_3")..currentColorHSVInt[2]):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function ()
    end)

    --アクション4. V（明度）
    colorPickerPage:newAction(4):title(Locale.getTranslate("action_wheel__color_picker__action_4")..currentColorHSVInt[3]):item("painting"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function ()
    end)

    --アクション5. コピー/貼り付け
    colorPickerPage:newAction(5):title(Locale.getTranslate("action_wheel__color_picker__action_5")):item("book"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
    end):onRightClick(function ()
    end)

    --アクション6. デフォルトにリセット
    colorPickerPage:newAction(6):title(Locale.getTranslate("action_wheel__color_picker__action_6")):item("white_dye"):color(defaultColor):hoverColor(1, 1, 1):onLeftClick(function ()
    end)

    --アクション7. 保存して/保存せずに終了
    colorPickerPage:newAction(7):title(Locale.getTranslate("action_wheel__color_picker__action_7")):item("barrier"):color(0.67):hoverColor(1, 0.33, 0.33):onLeftClick(function ()
    end):onRightClick(function ()
    end)

    action_wheel:setPage(colorPickerPage)
end

--メインページのアクションの設定
--アクション1. 色変更（グラデーション1）
ActionWheel.MainPage:newAction(1):title(Locale.getTranslate("action_wheel__main__action_1")):item("red_dye"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
    colorPicker(vectors.vec3(105 / 255, 255 / 255, 175 / 255), vectors.vec3(105 / 255, 255 / 255, 175 / 255), function ()
    end)
end)

--アクション2. 色変更（グラデーション2）
ActionWheel.MainPage:newAction(2):title(Locale.getTranslate("action_wheel__main__action_2")):item("yellow_dye"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
end)

--アクション3. 色変更（縁）
ActionWheel.MainPage:newAction(3):title(Locale.getTranslate("action_wheel__main__action_3")):item("green_dye"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
end)

--アクション4. 色変更（模様）
ActionWheel.MainPage:newAction(4):title(Locale.getTranslate("action_wheel__main__action_4")):item("blue_dye"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
end)

--アクション5. 羽の発光
ActionWheel.MainPage:newAction(5):title(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_off")):toggleTitle(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_on")):item("glow_ink_sac"):color(0.67):toggleColor(0, 0.67):hoverColor(1, 0.33, 0.33):onToggle(function (_, action)
    action:hoverColor(0.33, 1, 0.33)
end):onUntoggle(function (_, action)
    action:hoverColor(1, 0.33, 0.33)
end)

action_wheel:setPage(ActionWheel.MainPage)

return ActionWheel