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


	if not coin:HasTag(Constants.COIN_TAG) then
		return false
	end


	if not playerCoins[player] then
		playerCoins[player] = {}
	end
	if playerCoins[player][coin] then
		return false
	end

	local character = player.Character
	if not character then
		return false
	end
	local distance = (character:GetPivot().Position - coin.Position).Magnitude
	if distance > MAX_PICKUP_DISTANCE then
		return false
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return false
	end
	local coins = leaderstats:FindFirstChild("Coins")
	if not coins then
		return false
	end
	coins.Value += 1
	playerCoins[player][coin] = true

local function onPickupCoinFunction(player: Player, coin: BasePart): boolean
	if not validateInstance(coin, "BasePart") then
		return false
	end
