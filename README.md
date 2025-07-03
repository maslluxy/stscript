# Roblox Tower Teleporter 🚀

Hey! This is a simple Roblox LocalScript that teleports your character through preset waypoints across different tower maps. Think of it like a smooth teleport tour through all the key spots in your game.

---

## What’s in here?

- **Place IDs** mapped to specific towers or maps.
- A list of **Vector3 waypoints** for each place — these are the spots you’ll teleport to.
- A teleport loop that zips your character around each waypoint, then sends you back to where you started.
- Adjustable delay (`tpwait`) so you can control the pacing between teleports.

---

## How it works

1. The script checks which place (map) you’re in using `game.PlaceId`.
2. It grabs the list of waypoints for that place.
3. Waits for your character and their HumanoidRootPart (that’s your avatar’s center).
4. Saves your current position.
5. Teleports your character through each waypoint, waiting a bit if you set `tpwait`.
6. After the last teleport, it returns you to your original spot.

---

## Quick setup

- Put this **LocalScript** in StarterPlayerScripts.
- Adjust the `tpwait` variable to add or remove delay between teleports (default is 0, which means instant).
- Make sure your Place IDs and waypoints match your game’s tower maps!

---

## Why use this?

- Automatically navigate key spots on your map.
- Cool for demos, testing, or showing off map areas without manual travel.
- Super lightweight and easy to customize.

---

## Code snippet (because why not)

```lua
local tpwait = 0

local TowerPositions = {
    [95508886069297] = {
        Vector3.new(-22.8, -10.7, 106.7),
        Vector3.new(-186.1, 769.3, 68.3),
        -- more points...
    },
    -- other place IDs and their points
}

local myPlace = game.PlaceId
local waypoints = TowerPositions[myPlace]
if not waypoints then return end

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local originalCF = hrp.CFrame

for _, pos in ipairs(waypoints) do
    hrp.CFrame = CFrame.new(pos)
    wait(tpwait)
end

hrp.CFrame = originalCF
