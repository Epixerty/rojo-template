--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local module = {}

export type ReceiptInfo = {
	PurchaseId: string,
	PlayerId: number,
	ProductId: number,
	PlaceIdWherePurchased: number,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel,
}

local callbacks = {}

function module.SetCallback(productId: number, callback: (ReceiptInfo) -> boolean)
	if callbacks[productId] then
		warn("Overriding existing callback for productId: " .. productId)
	end

	callbacks[productId] = callback
end

function module.RemoveCallback(productId: number)
	if not callbacks[productId] then
		warn("No callback found for productId: " .. productId)
		return
	end

	callbacks[productId] = nil
end

function module.init()
	MarketplaceService.ProcessReceipt = function(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision
		local callback = callbacks[receiptInfo.ProductId]
		local result = Enum.ProductPurchaseDecision.NotProcessedYet

		local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)

		if not player then
			warn("No player found for userId: " .. receiptInfo.PlayerId)
			return result
		end

		if not callback then
			warn("No callback found for productId: " .. receiptInfo.ProductId)
			return result
		end

		local success, callbackResult = pcall(function()
			return callback(receiptInfo)
		end)

		if success and callbackResult then
			result = Enum.ProductPurchaseDecision.PurchaseGranted
		elseif success and not callbackResult then
			warn("Callback for productId: " .. receiptInfo.ProductId .. " returned false")
		else
			warn(
				"Error processing callback for productId: "
					.. receiptInfo.ProductId
					.. " - "
					.. tostring(callbackResult)
			)
		end

		return result
	end
end

return module
