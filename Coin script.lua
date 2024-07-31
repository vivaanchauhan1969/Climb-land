local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Gameplay.Constants)
local validateInstance = require(ServerScriptService.Utility.TypeValidation.validateInstance)

local remotes = ReplicatedStorage.Gameplay.Remotes
local pickupCoinRemote = remotes.PickupCoin

local MAX_PICKUP_DISTANCE = 50

local playerCoins = {}

local function onPlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Parent = leaderstats
end

local function onPlayerRemoving(player: Player)
	if playerCoins[player] then
		playerCoins[player] = nil
	end
end

local function onPickupCoinFunction(player: Player, coin: BasePart): boolean
	if not validateInstance(coin, "BasePart") then
		return false
	end
