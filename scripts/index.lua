--クラスのインスタンス化
events.ENTITY_INIT:register(function ()
    require("scripts.player")
    Color = require("scripts.color")
    Locale = require("scripts.locale")
    ActionWheel = require("scripts.action_wheel")
    Wing = require("scripts.wing")
    Feeler = require("scripts.feeler")
end)