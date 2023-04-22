---@class ActionWheel アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ

ActionWheel = {
    MainPage = action_wheel:newPage()
}

--メインページのアクションの設定
--アクション1. 色変更（グラデーション1）
ActionWheel.MainPage:newAction(1):title(Locale.getTranslate("action_wheel__main__action_1")):item("red_dye"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onLeftClick(function ()
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
ActionWheel.MainPage:newAction(5):title(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_off")):toggleTitle(Locale.getTranslate("action_wheel__main__action_5")..Locale.getTranslate("action_wheel__toggle_on")):item("glow_ink_sac"):color(0.67, 0, 0):toggleColor(0, 0.67, 0):hoverColor(1, 0.33, 0.33):onToggle(function (_, action)
    action:hoverColor(0.33, 1, 0.33)
end):onUntoggle(function (_, action)
    action:hoverColor(1, 0.33, 0.33)
end)

action_wheel:setPage(ActionWheel.MainPage)

return ActionWheel