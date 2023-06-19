-- hook.Add("PlayerSpawnNPC", "ReplaceNPCWeapons", function(ply, npcType, weapon)
--     if( GetConVarNumber( "of_tfa_weapon" ) == 0 ) then return end
--     if not IsValid(ply) or not IsValid(weapon) then return end

--     local weaponClass = weapon:GetClass()

--     -- Check if the weapon is a TFA weapon
--     if weapons.IsBasedOn(weaponClass, "tfa_gun_base") then return end

--     -- Find a TFA weapon of the same type
--     local tfaWeaponClass = FindTFAWeaponClass(weaponClass)

--     -- Replace the weapon with the TFA weapon
--     if tfaWeaponClass then
--         local tfaWeapon = weapons.GetStored(tfaWeaponClass)
--         if tfaWeapon and tfaWeapon.Spawnable and not tfaWeapon.AdminOnly then
--             ply:Give(tfaWeaponClass)
--             ply:SelectWeapon(tfaWeaponClass)
--         end
--     end
-- end)

-- function FindTFAWeaponClass(weaponClass)
--     local tfaWeaponClass = nil

--     for _, wep in pairs(weapons.GetList()) do
--         if wep and wep.Spawnable and weapons.IsBasedOn(wep.ClassName, "tfa_gun_base") then
--             local tfaWeaponType = string.gsub(wep.ClassName, "tfa_", "")
--             local weaponType = string.gsub(weaponClass, "weapon_", "")

--             if tfaWeaponType == weaponType then
--                 tfaWeaponClass = wep.ClassName
--                 break
--             end
--         end
--     end

--     return tfaWeaponClass
-- end