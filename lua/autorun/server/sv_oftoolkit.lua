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