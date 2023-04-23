---@class Armor 防具の表示を制御するクラス
---@field Armor.ArmorSlotItemsPrev table 前チックの防具スロットのアイテム
---@field Armor.ArmorVisible table 各防具の部位（ヘルメット、チェストプイート、レギンス、ブーツ）が可視状態かどうか。

Armor = {
	ArmorSlotItemsPrev = {world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air")},
	ArmorVisible = {false, false, false, false}
}

events.TICK:register(function ()
	---防具の色を取得する。
	---@param armorItem ItemStack 調べるアイテムのオブジェクト
	---@return number color 防具モデルに設定すべき色
	local function getArmorColor(armorItem)
		if armorItem.id:find("^minecraft:leather_") then
			if armorItem.tag then
				if armorItem.tag.display then
					return armorItem.tag.display.color and armorItem.tag.display.color or 10511680
				else
					return 10511680
				end
			else
				return 10511680
			end
		else
			return 16777215
		end
	end

	local armorSlotItems = {player:getItem(6), player:getItem(5), player:getItem(4), player:getItem(3)}
	for index, armorSlotItem in ipairs(armorSlotItems) do
		if armorSlotItem.id ~= Armor.ArmorSlotItemsPrev[index].id then
			--防具変更
			if index == 1 then
				local helmetFound = armorSlotItems[1].id:find("^minecraft:.+_helmet$") == 1
				models.models.main.Player.Head.ArmorH.Helmet:setVisible(helmetFound)
				Armor.ArmorVisible[1] = helmetFound
				if helmetFound then
					local material = armorSlotItems[1].id:match("^minecraft:(%a+)_helmet$")
					models.models.main.Player.Head.ArmorH.Helmet.Helmet:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
				end
				models.models.main.Player.Head.ArmorH.Helmet.HelmetOverlay:setVisible(armorSlotItems[1].id == "minecraft:leather_helmet")
			elseif index == 2 then
				local chestplateFound = armorSlotItems[2].id:find("^minecraft:.+_chestplate$") == 1
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Chestplate, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate}) do
					armorPart:setVisible(chestplateFound)
				end
				Armor.ArmorVisible[2] = chestplateFound
				if chestplateFound then
					local material = armorSlotItems[2].id:match("^minecraft:(%a+)_chestplate$")
					for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Chestplate.Chestplate, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate.RightChestplate, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate.LeftChestplate}) do
						armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					end
				end
                models.models.main.Player.Body.ButterflyB:setPos(0, 0, chestplateFound and 1 or 0)
				local overlayVisible = armorSlotItems[2].id == "minecraft:leather_chestplate"
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			elseif index == 3 then
				local leggingsFound = armorSlotItems[3].id:find("^minecraft:.+_leggings$") == 1
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings, models.models.main.Player.RightLeg.ArmorRL.RightLeggings, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings}) do
					armorPart:setVisible(leggingsFound)
				end
				Armor.ArmorVisible[3] = leggingsFound
				if leggingsFound then
					local material = armorSlotItems[3].id:match("^minecraft:(%a+)_leggings$")
					for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings.Leggings, models.models.main.Player.RightLeg.ArmorRL.RightLeggings.RightLeggings, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings.LeftLeggings}) do
						armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_2.png")
					end
				end
				local overlayVisible = armorSlotItems[3].id == "minecraft:leather_leggings"
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Player.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			else
				local bootsFound = armorSlotItems[4].id:find("^minecraft:.+_boots$") == 1
				for _, armorPart in ipairs({models.models.main.Player.RightLeg.ArmorRL.RightBoots, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots}) do
					armorPart:setVisible(bootsFound)
				end
				Armor.ArmorVisible[4] = bootsFound
				if bootsFound then
					local material = armorSlotItems[4].id:match("^minecraft:(%a+)_boots$")
					for _, armorPart in ipairs({models.models.main.Player.RightLeg.ArmorRL.RightBoots.RightBoots, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots.LeftBoots}) do
                        armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					end
				end
				local overlayVisible = armorSlotItems[4].id == "minecraft:leather_boots"
				for _, armorPart in ipairs({models.models.main.Player.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			end
		end
		local glint = armorSlotItem:hasGlint()
		if glint ~= Armor.ArmorSlotItemsPrev[index]:hasGlint() then
			--エンチャント変更
			local renderType = glint and "GLINT" or "NONE"
			if index == 1 then
				models.models.main.Player.Head.ArmorH.Helmet:setSecondaryRenderType(renderType)
			elseif index == 2 then
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Chestplate, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			elseif index == 3 then
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings, models.models.main.Player.RightLeg.ArmorRL.RightLeggings, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			else
				for _, armorPart in ipairs({models.models.main.Player.RightLeg.ArmorRL.RightBoots, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			end
		end
		local armorColor = getArmorColor(armorSlotItem)
		if armorColor ~= getArmorColor(Armor.ArmorSlotItemsPrev[index]) then
			--色変更
			local colorVector = vectors.intToRGB(armorColor)
			if index == 1 then
                models.models.main.Player.Head.ArmorH.Helmet.Helmet:setColor(colorVector)
			elseif index == 2 then
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Chestplate.Chestplate, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate.RightChestplate, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate.LeftChestplate}) do
					armorPart:setColor(colorVector)
				end
			elseif index == 3 then
				for _, armorPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings.Leggings, models.models.main.Player.RightLeg.ArmorRL.RightLeggings.RightLeggings, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings.LeftLeggings}) do
					armorPart:setColor(colorVector)
				end
			else
				for _, armorPart in ipairs({models.models.main.Player.RightLeg.ArmorRL.RightBoots.RightBoots, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots.LeftBoots}) do
					armorPart:setColor(colorVector)
				end
			end
		end
	end
	Armor.ArmorSlotItemsPrev = armorSlotItems
end)

for _, overlayPart in ipairs({models.models.main.Player.Head.ArmorH.Helmet.HelmetOverlay, models.models.main.Player.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Player.Body.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Player.Body.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Player.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Player.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay}) do
	overlayPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
end
for _, overlayPart in ipairs({models.models.main.Player.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Player.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Player.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay}) do
	overlayPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/leather_layer_2_overlay.png")
end

return Armor