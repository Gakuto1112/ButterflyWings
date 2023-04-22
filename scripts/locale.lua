---@class Locale アバターのテキストの言語を制御するクラス
---@field LocaleData table<string, table<string, string>> 言語データ

Locale = {
	LocaleData = {
		en_us = {
            action_wheel__toggle_off = "§coff",
			action_wheel__toggle_on = "§aon",
            action_wheel__main__action_1 = "Change color (Gradation 1)",
            action_wheel__main__action_2 = "Change color (Gradation 2)",
            action_wheel__main__action_3 = "Change color (Wing edge)",
            action_wheel__main__action_4 = "Change color (Wing pattern)",
            action_wheel__main__action_5 = "Wing luminescence: "
		},
		ja_jp = {
            action_wheel__toggle_off = "§cオフ",
			action_wheel__toggle_on = "§aオン",
            action_wheel__main__action_1 = "色の変更（グラデーション1）",
            action_wheel__main__action_2 = "色の変更（グラデーション2）",
            action_wheel__main__action_3 = "色の変更（縁）",
            action_wheel__main__action_4 = "色の変更（模様）",
            action_wheel__main__action_5 = "羽の発光："
		}
	},

	---翻訳キーに対する訳文を返す。設定言語が存在しない場合は英語の文が返される。また、指定したキーの訳が無い場合は英語->キーそのままが返される。
	---@param keyName string 翻訳キー
	---@return string translatedString 翻訳キーに対する翻訳データ。設定言語での翻訳が存在しない場合は英文が返される。英文すら存在しない場合は翻訳キーがそのまま返される。
	getTranslate = function(keyName)
		local activeLanguage = client:getActiveLang()
		return (Locale.LocaleData[activeLanguage] and Locale.LocaleData[activeLanguage][keyName]) and Locale.LocaleData[activeLanguage][keyName] or (Locale.LocaleData["en_us"][keyName] and Locale.LocaleData["en_us"][keyName] or keyName)
	end
}

return Locale