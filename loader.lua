local githubURL = "https://raw.githubusercontent.com/ExtremeAntonis/extremehub/main/scripts/"

local scripts = {
	[680750021] = "case-clicker.lua",
	[7429434108] = "anime-tappers.lua",
	[5852812686] = "candy-clicking-simulator.lua",
	[6075756195] = "clicker-havoc.lua",
	[7444263453] = "jetpack-jumpers.lua",
	[6677985923] = "millionaire-empire-tycoon.lua",
	[7277614831] = "candy-eating-simulator.lua",
	[4058282580] = "boxing-simulator.lua",
	[2619187362] = "super-power-fighting-simulator.lua",
	[7114796110] = "anime-training-simulator.lua",
	[2533391464] = "snowman-simulator.lua",
	[5264342538] = "cems_script.lua",
	[7681451450] = "anime-simulator-x.lua",
	[7586443938] = "anime_stars_simulator.lua",
	[7065731541] = "speedman-simulator.lua",
	[6875469709] = "strongest-punch-simulator.lua",
	[3823781113] = "saber-simulator.lua",
	[3956818381] = "ninja-legends.lua",
	[7244314500] = "fightman-simulator.lua",
	[3102144307] = "anime-clicker-simulator.lua",
	[7560156054] = "clicker-simulator.lua",
	[8357510970] = "anime-punching-simulator.lua",
	[8540346411] = "rebirth-champions-x.lua",
	[6284583030] = "pet-simulator-x.lua",
	[10321372166] = "pet-simulator-x.lua",
	[3101667897] = "legends-of-speed.lua",
	[9281034297] = "goal-kick-simulator.lua",
	[9551640993] = "mining-simulator-2.lua",
	[8571633166] = "pet-gods-simulator.lua",
	[10675066724] = "slime-tower-tycoon.lua",
}

local function ScriptFound(placeId)
	return scripts[placeId] ~= nil
end

local function RunScript(placeId)
	if ScriptFound(placeId) then
		local filename = scripts[placeId]
		local scriptURL = githubURL .. filename
		local script = game:HttpGet(scriptURL)
		return loadstring(script)()
	end
end

if ScriptFound(placeId) then
	_G.keyFound = true
	RunScript(placeId)
end