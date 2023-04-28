---@class Config アバター設定を管理するクラス
---@field Config.DefaultValues table 読み込んだ値のデフォルト値を保持するテーブル

Config = {
	DefaultValues = {},

	---設定を読み出す
	---@param keyName string 読み出す設定の名前
	---@param defaultValue any 該当の設定が無い場合や、ホスト外での実行の場合はこの値が返される。
	---@return any data 読み出した値
	loadConfig = function (keyName, defaultValue)
		if host:isHost() then
			local data = config:load(keyName)
			Config.DefaultValues[keyName] = defaultValue
			if data ~= nil then
				return data
			else
				return defaultValue
			end
		else
			return defaultValue
		end
	end,

	---設定を保存する
	---@param keyName string 保存する設定の名前
	---@param value any 保存する値
	saveConfig = function (keyName, value)
		if host:isHost() then
			if Config.DefaultValues[keyName] == value then
				config:save(keyName, nil)
			else
				config:save(keyName, value)
			end
		end
	end
}

local isSynced = host:isHost() --アバターの設定がホストと同期されたかどうか
local nextSyncCount = 0 --次の同期pingまでのカウンター

--ping関数
---アバター設定を他Figuraクライアントと同期する。
---@param colors table<Vector3> 色設定のテーブル
---@param wingOpacity number 羽の透明度
---@param wingGlow boolean 羽を発光させるかどうか
---@param particleDuration integer 羽のパーティクルの出現時間
---@param flyingFlag boolean クリエイティブ飛行のフラグ
---@param slowFallFlag boolean 低速落下のバフのフラグ
function pings.syncAvatarConfig(colors, wingOpacity, wingGlow, particleDuration, flyingFlag, slowFallFlag)
	if host:isHost() then
		if not isSynced then
			Color.Color = colors
			Color.drawWingGradation()
			Color.setFeelerTipColor()
			Color.setEdgeColor()
			Color.setPatternColor()
			Wing.setGlowing(wingGlow)
			General.Flying = flyingFlag
			Wing.SlowFallEffect = slowFallFlag
		end
		if Color.Opacity ~= wingOpacity then
			Color.Opacity = wingOpacity
			Color.setOpacity()
		end
		Wing.ParticleDuration = particleDuration
	end
end

events.TICK:register(function ()
	if nextSyncCount == 0 then
		pings.syncAvatarConfig(Color.Color, Color.Opacity, Wing.Glowing, Wing.ParticleDuration, General.Flying, Wing.SlowFallEffect)
		nextSyncCount = 300
	else
		nextSyncCount = nextSyncCount - 1
	end
end)

if host:isHost() then
	config:name("butterfly_wings")
end

return Config