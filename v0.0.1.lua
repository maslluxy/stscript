-- LocalScript (e.g. in StarterPlayerScripts)

-- 1) ST place-IDs
local ST_1_ID = 95508886069297
local ST_2_ID = 79089892790758
local ST_3_ID = 105612566642310
local ST_4_ID = 86082995079744
local ST_5_ID = 93924136437619
local ST_6_ID = 120759571391756
local TP_2_ID = 83312952548612
local TP_4_ID = 88049480741001
local TB_1_ID = 105692451124462
local TLT_1_ID = 128635262479351

-- 2) tweak this delay if you want more/less time between teleports
local tpwait = 0

-- 3) map each ST_ID to its list of Vector3 waypoints
local TowerPositions = {
    [ST_1_ID] = {
        Vector3.new(-22.8364353, -10.6966152, 106.734909),
        Vector3.new(-186.090652, 769.303284,  68.3620224),
        Vector3.new( 183.884705, -10.6966162, 81.0029449),
        Vector3.new(-20.6621647, -10.6966152, 19.1326599),
    },
    [ST_2_ID] = {
        Vector3.new( 36.8214378,   3.99999976,   4.97615194),
        Vector3.new(-339.738434,   3.99999976,  -4.85448503),
        Vector3.new( 162.138702,   3.99999976, -27.6756668),
        Vector3.new(   4.08129835, 353.999969, 321.703857),
    },
    [ST_3_ID] = {
        Vector3.new( 18.0345612,   3.99998736,  68.7657166),
        Vector3.new( 16.2404518,   3.99999976, -157.491669),
        Vector3.new(184.255707,    3.9999969,   -2.32003689),
        Vector3.new(-226.947021,  354.007812,   38.531456),
    },
    [ST_4_ID] = {
        Vector3.new( 51.7022514,  -3.03130937,   6.15416002),
        Vector3.new(-33.1085663, -18.031311,    -33.6732979),
        Vector3.new( 27.1680946,  -3.03131127, -187.073181),
        Vector3.new( 14.7338123, 596.968628,    172.204315),
    },
    [ST_5_ID] = {
        Vector3.new(-59.9814148,  -10.6966152,  49.6715355),
        Vector3.new(-27.8093853,  339.253418,  -173.782761),
    },
    [ST_6_ID] = {
        Vector3.new(64.42, -9.43, 111.52),
        Vector3.new(-142.28, 593.05, 76.05),
    },
    [TP_2_ID] = {
        Vector3.new(272.64, 347.15, -32.93),
    },
    [TP_4_ID] = {
        Vector3.new(353.89, 338.42, 56.05),
    },
    [TB_1_ID] = {
        Vector3.new(567.81, 465.26, -161.32),
    },
    [TLT_1_ID] = {
        Vector3.new(-31.90, 390.51, -213.14),
        Vector3.new(-71.36, -7.65, 55.77),
    },
} 

-- 4) check the current place, grab the matching waypoints
local myPlace = game.PlaceId
local waypoints = TowerPositions[myPlace]
if not waypoints then
    return  -- not one of your ST games, bail out
end

-- 5) wait for character + HRP, then run your tp loop
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- SAVE your original CFrame
local originalCF = hrp.CFrame

-- TELEPORT THROUGH TOWER POINTS
for _, pos in ipairs(waypoints) do
    hrp.CFrame = CFrame.new(pos)
    wait(tpwait)
end

-- AFTER THE LAST ONE, GO BACK
hrp.CFrame = originalCF
