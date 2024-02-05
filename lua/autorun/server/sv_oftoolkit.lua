--[[
CreateConVar( "of_allowweaponsinvehicle", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )

util.AddNetworkString("of_allowweaponsinvehiclenet")

hook.Add("Think", "of_allowweaponsinvehiclehook", function( ply )
	net.Start("of_allowweaponsinvehiclenet")
end)

net.Receive("of_allowweaponsinvehiclenet", function(len, ply)
	if GetConVar("of_allowweaponsinvehicle"):GetInt() == 0 then return end
	if ply:GetAllowWeaponsInVehicle() == true then
		ply:SetAllowWeaponsInVehicle(false)
	else
		ply:SetAllowWeaponsInVehicle(true)
	end
	
end)
]]--
CreateConVar( "of_allowweaponsinvehicle", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )
hook.Add( "PlayerEnteredVehicle", "of_allowweaponsinvehiclehook", function( ply, cmd )
	local veh = ( GetConVar("of_allowweaponsinvehicle"):GetInt() > 0 )
	if ply:GetAllowWeaponsInVehicle() != veh then
		ply:SetAllowWeaponsInVehicle( veh )
	end
end )

-- 全球

-- CreateConVar("of_antlion_allied", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )
-- local function UpdateGlobalState1()
--     local state = GetConVarString("of_antlion_allied")
-- 	if state == "1" then
--     	game.SetGlobalState("antlion_allied", 1)
-- 	else
-- 		game.SetGlobalState("antlion_allied", 0)
-- 	end
-- end
-- cvars.AddChangeCallback("of_antlion_allied", UpdateGlobalState1)
-- hook.Add("Initialize", "UpdateGlobalStateOnInit1", UpdateGlobalState1)

-- CreateConVar("of_suit_no_sprint", "0",{ FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "" )
-- local function UpdateGlobalState2()
--     local state = GetConVarString("of_suit_no_sprint")
-- 	if state == "1" then
--     	game.SetGlobalState("suit_no_sprint", 1)
-- 	else
-- 		game.SetGlobalState("suit_no_sprint", 0)
-- 	end
-- end
-- cvars.AddChangeCallback("of_suit_no_sprint", UpdateGlobalState2)
-- hook.Add("Initialize", "UpdateGlobalStateOnInit2", UpdateGlobalState2)



local function UpdateGlobalState(cvarName, globalStateName)
    local state = GetConVarString(cvarName)
    local value = state == "1" and 1 or 0
    game.SetGlobalState(globalStateName, value)
end

local function InitializeGlobalState(cvarName)
	local globalStateName = string.gsub(cvarName, "^ofgs_", "")
    CreateConVar(cvarName, "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }, "")
    cvars.AddChangeCallback(cvarName, function() UpdateGlobalState(cvarName, globalStateName) end)
    hook.Add("Initialize", "UpdateGlobalStateOnInit", function() UpdateGlobalState(cvarName, globalStateName) end)
end

InitializeGlobalState("ofgs_antlion_allied")
InitializeGlobalState("ofgs_suit_no_sprint")
InitializeGlobalState("ofgs_super_phys_gun")
InitializeGlobalState("ofgs_friendly_encounter")
InitializeGlobalState("ofgs_gordon_invulnerable")
InitializeGlobalState("ofgs_no_seagulls_on_jeep")
InitializeGlobalState("ofgs_ep2_alyx_injured")
InitializeGlobalState("ofgs_ep_alyx_darknessmode")
InitializeGlobalState("ofgs_hunters_to_run_over")
InitializeGlobalState("ofgs_citizens_passive")
