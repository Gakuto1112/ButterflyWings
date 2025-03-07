---@class Locale アバターのテキストの言語を制御するクラス
---@field LocaleData { [string]: { [string]: string } } 言語データ
Locale = {
	LocaleData = {
		en_us = {
            action_wheel__toggle_off = "§coff",
			action_wheel__toggle_on = "§aon",
			action_wheel__main__action_8 = "Change pages",
			action_wheel__main__config_changed = "Config changed!",
            action_wheel__main_1__action_1 = "Change color (Gradation 1)",
            action_wheel__main_1__action_2 = "Change color (Gradation 2)",
            action_wheel__main_1__action_3 = "Change color (Wing edge)",
            action_wheel__main_1__action_4 = "Change color (Wing pattern)",
			action_wheel__main_1__action_5 = "Wing opacity §7(Scroll)§r: ",
            action_wheel__main_1__action_6 = "Wing glowing: ",
			action_wheel__main_1__action_7 = "Wing particle duration §7(Scroll)§r: ",
            action_wheel__main_1__action_7__none = "None",
            action_wheel__main_1__action_7__short = "Short",
            action_wheel__main_1__action_7__normal = "Normal",
            action_wheel__main_1__action_7__long = "Long",
			action_wheel__main_1__action_7__very_long = "Very long",
			action_wheel__main_2__action_1 = "Color palette",
			action_wheel__picker__action_1 = "Current color",
			action_wheel__picker__action_2 = "Hue §7(Scroll)§r：",
			action_wheel__picker__action_3 = "Saturation §7(Scroll)§r：",
			action_wheel__picker__action_4 = "Value §7(Scroll)§r：",
			action_wheel__picker__action_5 = "Copy §7(Left-click)§r\nPaste §7(Right-click)",
			action_wheel__picker__action_5__copy = "Copied current color!",
			action_wheel__picker__action_5__paste = "Pasted copied color!",
			action_wheel__picker__action_5__no_paste_color = "No color to paste!",
			action_wheel__picker__action_6 = "Reset to default",
			action_wheel__picker__action_7 = "Save and close §7(Left-click)§r\nClose without saving §7(Right-click)",
			action_wheel__picker__message__fast_scroll = "\n§bYou can scroll quickly with holding sprint key!",
			action_wheel__picker__message__done = "Changed target color!",
			action_wheel__palette__action_1 = "Current palette\nExport §7(Left-click)§r  Import §7(Right-click)",
			action_wheel__palette__action_2 = "Palette ",
			action_wheel__palette__action_2__control = "\nApply palette §7(Left-click)§r  Save current palette §7(Right-click)",
			action_wheel__palette__action_8 = "Close color palette",
			action_wheel__palette__message__export = "The current palette data has been copied to the clipboard. Please save it separately, etc.",
			action_wheel__palette__message__import = "Applied palette data from clipboard.",
			action_wheel__palette__message__import_init = "This avatar will read palette data from the clipboard. Please copy the palette data and right-click again.\n§7(This message will not appear again until this avatar is reloaded.)",
			action_wheel__palette__message__import_invalid = "§cClipboard text is not palette information.",
			action_wheel__palette__message__get_palette = "Applied palette.",
			action_wheel__palette__message__set_palette = "Saved current palette."
		},
		ja_jp = {
            action_wheel__toggle_off = "§cオフ",
			action_wheel__toggle_on = "§aオン",
			action_wheel__main__action_8 = "ページ切り替え",
			action_wheel__main__config_changed = "設定を変更しました！",
            action_wheel__main_1__action_1 = "色の変更（グラデーション1）",
            action_wheel__main_1__action_2 = "色の変更（グラデーション2）",
            action_wheel__main_1__action_3 = "色の変更（縁）",
            action_wheel__main_1__action_4 = "色の変更（模様）",
            action_wheel__main_1__action_5 = "羽の不透明度§7（スクロール）§r：",
            action_wheel__main_1__action_6 = "羽の発光：",
            action_wheel__main_1__action_7 = "羽のパーティクルの出現時間§7（スクロール）§r：",
            action_wheel__main_1__action_7__none = "なし",
            action_wheel__main_1__action_7__short = "短い",
            action_wheel__main_1__action_7__normal = "ふつう",
            action_wheel__main_1__action_7__long = "長い",
            action_wheel__main_1__action_7__very_long = "とても長い",
			action_wheel__main_2__action_1 = "カラーパレット",
			action_wheel__picker__action_1 = "現在の色",
			action_wheel__picker__action_2 = "色相§7（スクロール）§r：",
			action_wheel__picker__action_3 = "彩度§7（スクロール）§r：",
			action_wheel__picker__action_4 = "明度§7（スクロール）§r：",
			action_wheel__picker__action_5 = "コピー§7（左クリック）§r\nペースト§7（右クリック）",
			action_wheel__picker__action_5__copy = "現在の色をコピーしました！",
			action_wheel__picker__action_5__paste = "色を貼り付けました！",
			action_wheel__picker__action_5__no_paste_color = "貼り付ける色がありません！",
			action_wheel__picker__action_6 = "デフォルトの色にリセット",
			action_wheel__picker__action_7 = "保存して閉じる§7（左クリック）§r\n保存せずに閉じる§7（右クリック）",
			action_wheel__picker__message__fast_scroll = "\n§bダッシュキーを押しながら素早くスクロールできます！",
			action_wheel__picker__message__done = "色を変更しました！",
			action_wheel__palette__action_1 = "現在のパレット\nエクスポート§7（左クリック）§r  インポート§7（右クリック）",
			action_wheel__palette__action_2 = "パレット",
			action_wheel__palette__action_2__control = "\nパレットの適用§7（左クリック）§r  現在のパレットを保存§7（右クリック）",
			action_wheel__palette__action_8 = "カラーパレットを閉じる",
			action_wheel__palette__message__export = "現在のパレット情報をクリップボードにコピーしました。別途保存などを行ってください。",
			action_wheel__palette__message__import = "クリップボードのパレット情報を適用しました。",
			action_wheel__palette__message__import_init = "パレット情報をクリップボードから読み込みます。パレット情報をクリップボードにコピーして、もう一度右クリックして下さい。\n§7（このメッセージはアバターが再読み込みされるまで再び表示されません。）",
			action_wheel__palette__message__import_invalid = "§cクリップボードのテキストはパレット情報ではありません。",
			action_wheel__palette__message__get_palette = "パレットを適用しました。",
			action_wheel__palette__message__set_palette = "現在のパレットを保存しました。"
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