--クラスのインスタンス化
events.ENTITY_INIT:register(function ()
    General = require("scripts.general")
    Physics = require("scripts.physics")
    Armor = require("scripts.armor")
    Player = require("scripts.player")
    Config = require("scripts.config")
    Color = require("scripts.color")
    Locale = require("scripts.locale")
    Wing = require("scripts.wing")
    require("scripts.feeler")
    ActionWheel = require("scripts.action_wheel")
end)