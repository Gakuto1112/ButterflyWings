---@class TextureGenerator テクスチャを生成する処理を行うクラス
---@field TextureQueue table テクスチャ処理のキュー
TextureGenerator = {
    TextureQueue = {},

    ---テクスチャを処理キューに入れる
    ---@param texture Texture 処理対象のテクスチャ
    ---@param x integer テクスチャのx（横）の大きさ（2つ目のループ数）
    ---@param y integer テクスチャのy（縦）の大きさ（1つ目のループ数）
    ---@param processFunction function ループ内で処理を行う処理。引数：texture, x, y, args　返り値：number 処理後に減らす利用可能命令数
    ---@param args? table processFunctionの引数にする値（テーブルで格納）
    addTextureQueue = function (texture, x, y, processFunction, args)
        table.insert(TextureGenerator.TextureQueue, 1, {
            texture = texture,
            x = x,
            y = y,
            iterationCount = 0,
            processFunction = processFunction,
            args = args
        })
    end
}

events.TICK:register(function ()
    if #TextureGenerator.TextureQueue > 0 then
        local instructionsAvailable = avatar:getMaxTickCount() - 750
        while #TextureGenerator.TextureQueue > 0 and instructionsAvailable > 0 do
			for y = math.floor(TextureGenerator.TextureQueue[1].iterationCount / TextureGenerator.TextureQueue[1].x), TextureGenerator.TextureQueue[1].y - 1 do
				for x = TextureGenerator.TextureQueue[1].iterationCount % TextureGenerator.TextureQueue[1].x, TextureGenerator.TextureQueue[1].x - 1 do
                    local instructionsUsed = TextureGenerator.TextureQueue[1].processFunction(TextureGenerator.TextureQueue[1].texture, x, y, TextureGenerator.TextureQueue[1].args)
					TextureGenerator.TextureQueue[1].iterationCount = TextureGenerator.TextureQueue[1].iterationCount + 1
					instructionsAvailable = instructionsAvailable - instructionsUsed
					if instructionsAvailable <= 0 then
						break
					end
				end
				if instructionsAvailable <= 0 then
					break
				end
			end
			TextureGenerator.TextureQueue[1].texture:update()
			if TextureGenerator.TextureQueue[1].iterationCount == TextureGenerator.TextureQueue[1].x * TextureGenerator.TextureQueue[1].y then
                table.remove(TextureGenerator.TextureQueue, 1)
			end
		end
    end
end)

return TextureGenerator