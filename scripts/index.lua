--クラスのインスタンス化
events.ENTITY_INIT:register(function ()
    General = require("scripts.general")
    TextureGenerator = require("scripts.texture_generator")
    Physics = require("scripts.physics")
    require("scripts.player")
    Config = require("scripts.config")
    Color = require("scripts.color")
    Locale = require("scripts.locale")
    Wing = require("scripts.wing")
    require("scripts.feeler")
    UpdateChecker = require("scripts.update_checker")
    require("scripts.action_wheel")
    require("scripts.sleep")
end)

require("scripts.skull")