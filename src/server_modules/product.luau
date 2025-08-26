--!strict
local MarketplaceService = game:GetService("MarketplaceService")
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

function module.SetCallback(productId: number, callback: (ReceiptInfo) -> Enum.ProductPurchaseDecision)
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
	MarketplaceService.ProcessReceipt = function(receiptInfo): Enum.ProductPurchaseDecision
		local callback = callbacks[receiptInfo.ProductId]
		local result = Enum.ProductPurchaseDecision.NotProcessedYet

		if callback then
			result = callback(receiptInfo)
		else
			warn("No callback found for productId: " .. receiptInfo.ProductId)
			return result
		end

		return result
	end
end

return module
