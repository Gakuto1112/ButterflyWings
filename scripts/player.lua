---@class PlayerModel バニラやアバタープレイヤーモデルを制御するクラス

models.models.player:setPrimaryTexture("SKIN")
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.player.Player.RightArm.RightArmSlim, models.models.player.Player.LeftArm.LeftArmSlim} or {models.models.player.Player.RightArm.RightArmClassic, models.models.player.Player.LeftArm.LeftArmClassic}) do
	modelPart:setVisible(false)
end
for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ELYTRA}) do
    vanillaModel:setVisible(false)
end