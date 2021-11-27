local table_gen = require "gamesense/table_gen"

local BUILDS = { "17-11-2021" }
local CURRENT_BUILD = "Resolver-Stats-" .. BUILDS[#BUILDS]

local HITGROUP_NAMES = { "head", "body", "body", "limbs", "limbs",  "limbs", "limbs" }
local resolver_stats = database.read(CURRENT_BUILD) or {
	head = {shots = 0, hits = 0, percentage = "Nan"}, 
	body = {shots = 0, hits = 0, percentage = "Nan"},
	limbs = {shots = 0, hits = 0, percentage = "Nan"}
}

local game_state_api = panorama.open().GameStateAPI

local log_stats = ui.new_checkbox("MISC", "Settings", "Log resolver stats")
local dump_stats = ui.new_button("MISC", "Settings", "Dump resolver stats", function()
	local headings = {"head hit %", "Body hit %", "Limbs hit %"}
	local rows = {
		{
			string.format("%s%% (%d/%d)", resolver_stats.head.percentage, resolver_stats.head.hits, resolver_stats.head.shots),
			string.format("%s%% (%d/%d)", resolver_stats.body.percentage, resolver_stats.body.hits, resolver_stats.body.shots), 
			string.format("%s%% (%d/%d)", resolver_stats.limbs.percentage, resolver_stats.limbs.hits, resolver_stats.limbs.shots), 
		}
	}
	
	local table_out = table_gen(rows, headings, {
		style = "Unicode (Single Line)",
		value_justify = "center"
	})

	client.log("Correction statistics of " .. resolver_stats.head.shots + resolver_stats.body.shots +  resolver_stats.limbs.shots .. " shots:\n", table_out)
end)

local function on_aim_hit(e)
	if not ui.get(log_stats) or game_state_api.GetPlayerXuidStringFromEntIndex(e.target):len() < 4 then
		return
	end

	local hitgroup = HITGROUP_NAMES[e.hitgroup] or nil

	if not hitgroup then
		return
	end

	resolver_stats[hitgroup].hits = resolver_stats[hitgroup].hits + 1
	resolver_stats[hitgroup].shots = resolver_stats[hitgroup].shots + 1
	resolver_stats[hitgroup].percentage = tostring(math.floor(resolver_stats[hitgroup].hits / resolver_stats[hitgroup].shots * 100 + 0.5))
end

local function on_aim_miss(e)
	if not ui.get(log_stats) or game_state_api.GetPlayerXuidStringFromEntIndex(e.target):len() < 4 or e.reason ~= "?" then
		return
	end

	local hitgroup = HITGROUP_NAMES[e.hitgroup] or nil

	if not hitgroup then
		return
	end

	resolver_stats[hitgroup].shots = resolver_stats[hitgroup].shots + 1
	resolver_stats[hitgroup].percentage = tostring(math.floor(resolver_stats[hitgroup].hits / resolver_stats[hitgroup].shots * 100 + 0.5))
end

ui.set_callback(log_stats, function()
	local toggle_state = ui.get(log_stats)
	local update_callback = toggle_state and client.set_event_callback or client.unset_event_callback

	update_callback('aim_hit', on_aim_hit)
	update_callback('aim_miss', on_aim_miss)
end)

client.set_event_callback('shutdown', function()
	database.write(CURRENT_BUILD, resolver_stats)
end)