---@class PlayerModel バニラやアバタープレイヤーモデルを制御するクラス

for _, modelPart in ipairs({models.models.main.Player.Head.Head, models.models.main.Player.Head.HeadLayer, models.models.main.Player.Body.Body, models.models.main.Player.Body.BodyLayer, models.models.main.Player.RightArm, models.models.main.Player.LeftArm, models.models.main.Player.RightLeg, models.models.main.Player.LeftLeg}) do
    modelPart:setPrimaryTexture("SKIN")
end
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.main.Player.RightArm.RightArmSlim, models.models.main.Player.LeftArm.LeftArmSlim} or {models.models.main.Player.RightArm.RightArmClassic, models.models.main.Player.LeftArm.LeftArmClassic}) do
	modelPart:setVisible(false)
end
for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ELYTRA}) do
    vanillaModel:setVisible(false)
end