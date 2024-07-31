local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Gameplay.Constants)
local CoinController = require(script.Parent.CoinController)

local coinControllers = {}

local function onCoinAdded(coin: Instance)
	assert(coin:IsA("BasePart"), `{coin} should be a BasePart`)

	if coinControllers[coin] then
		return
	end

	coin.Transparency = 1
	local controller = CoinController.new(coin)
	coinControllers[coin] = controller
end

local function onCoinRemoved(coin: Instance)
	assert(coin:IsA("BasePart"), `{coin} should be a BasePart`)

	if coinControllers[coin] then
		coinControllers[coin]:destroy()
		coinControllers[coin] = nil
	end
end

local function initialize()
	CollectionService:GetInstanceAddedSignal(Constants.COIN_TAG):Connect(onCoinAdded)
	CollectionService:GetInstanceRemovedSignal(Constants.COIN_TAG):Connect(onCoinRemoved)

	for _, coin in CollectionService:GetTagged(Constants.COIN_TAG) do
		onCoinAdded(coin)
	end
end

initialize()
