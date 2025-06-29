--// Services
local Players = game:GetService("Players")

--// Configuration
local tpWait = 0 -- Time between teleports

--// Place ID registry (for easy lookup)
local PlaceIDs = {
	ST_1  = 95508886069297,
	ST_2  = 79089892790758,
	ST_3  = 105612566642310,
	ST_4  = 86082995079744,
	ST_5  = 93924136437619,
	ST_6  = 120759571391756,
	TP_2  = 83312952548612,
	TP_4  = 88049480741001,
	TB_1  = 105692451124462,
	TLT_1 = 128635262479351,
}

--// Waypoints per place ID
local TowerWaypoints = {
	[PlaceIDs.ST_1] = {
		Vector3.new(-22.836, -10.696, 106.735),
		Vector3.new(-186.091, 769.303, 68.362),
		Vector3.new(183.885, -10.696, 81.003),
		Vector3.new(-20.662, -10.696, 19.133),
	},
	[PlaceIDs.ST_2] = {
		Vector3.new(36.821, 4, 4.976),
		Vector3.new(-339.738, 4, -4.854),
		Vector3.new(162.139, 4, -27.676),
		Vector3.new(4.081, 354, 321.704),
	},
	[PlaceIDs.ST_3] = {
		Vector3.new(18.035, 4, 68.766),
		Vector3.new(16.240, 4, -157.492),
		Vector3.new(184.256, 4, -2.320),
		Vector3.new(-226.947, 354, 38.531),
	},
	[PlaceIDs.ST_4] = {
		Vector3.new(51.702, -3.031, 6.154),
		Vector3.new(-33.109, -18.031, -33.673),
		Vector3.new(27.168, -3.031, -187.073),
		Vector3.new(14.734, 597, 172.204),
	},
	[PlaceIDs.ST_5] = {
		Vector3.new(-59.981, -10.697, 49.672),
		Vector3.new(-27.809, 339.253, -173.783),
	},
	[PlaceIDs.ST_6] = {
		Vector3.new(64.42, -9.43, 111.52),
		Vector3.new(-142.28, 593.05, 76.05),
	},
	[PlaceIDs.TP_2] = {
		Vector3.new(272.64, 347.15, -32.93),
	},
	[PlaceIDs.TP_4] = {
		Vector3.new(353.89, 338.42, 56.05),
	},
	[PlaceIDs.TB_1] = {
		Vector3.new(567.81, 465.26, -161.32),
	},
	[PlaceIDs.TLT_1] = {
		Vector3.new(-31.90, 390.51, -213.14),
		Vector3.new(-71.36, -7.65, 55.77),
	},
}

--// Main
local currentPlaceId = game.PlaceId
local waypoints = TowerWaypoints[currentPlaceId]
if not waypoints then return end -- Exit if not a supported game

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local originalCFrame = hrp.CFrame

--// Teleport loop
for _, position in ipairs(waypoints) do
	hrp.CFrame = CFrame.new(position)
	task.wait(tpWait)
end

--// Return to original position
hrp.CFrame = originalCFrame
