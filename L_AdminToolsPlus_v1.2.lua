--original admin tools by OtherChen
--new admin tools by KevTSP

local function GetPlayerHelper(pname)
	-- Find a player using their node or part of their name.
	local N = tonumber(pname)
	if N ~= nil and N >= 0 and N < 32 then
		for player in players.iterate do
			if #player == N then
	return player
			end
		end
	end
	for player in players.iterate do
		if string.find(string.lower(player.name), string.lower(pname)) then
			return player
		end
	end
	return nil
end
local function GetPlayer(player, pname)
	local player2 = GetPlayerHelper(pname)
	if not player2 then
		CONS_Printf(player, "No one here has that name.")
	end
	return player2
end

local function CanCheat(player)
	-- Can the player use co-op cheats? (Admins can use them outside of co-op.)
	if (player == server or player == admin or gametype == GT_COOP) then
		return true
	else
		CONS_Printf(player, "You can only use this in co-op.")
		return false
	end
end


COM_AddCommand("adminhelp", function(player, command)
	if not command then
		CONS_Printf(player, "")
		CONS_Printf(player, "PLAYER COMMANDS")
		CONS_Printf(player, "whois   die")
		CONS_Printf(player, "allowgoto")
		CONS_Printf(player, "")
		CONS_Printf(player, "PLAYER CHEATS (co-op only!)")
		CONS_Printf(player, "goto    super   ")
		CONS_Printf(player, "rings   lives   ")
		CONS_Printf(player, "shoes   invuln  ")
		CONS_Printf(player, "shield  flower  ")
		if player == server or player == admin then
		CONS_Printf(player, "")
			CONS_Printf(player, "ADMIN COMMANDS")
			CONS_Printf(player, "print   dofor   setemeralds")
			CONS_Printf(player, "rally   nuke    bring")
			CONS_Printf(player, "freeze  gag     kill    ")
			CONS_Printf(player, "ringcheats   shieldcheats    abilitycheats")
			CONS_Printf(player, "Admins can use player cheats outside of co-op, and can also use all cheats regardless if disabled or not.")
		end
		CONS_Printf(player, "")
		CONS_Printf(player, "adminhelp <command>: get more info")
		
	elseif command == "die" then
		CONS_Printf(player, "die: kill yourself.")
		CONS_Printf(player, "Unlike \"suicide\", \"die\' is stronger and will bypass things such as god mode.")
	elseif command == "super" then
		CONS_Printf(player, "super: become Super and gain 50 rings on demand. This also works on characters that normally wouldn't have super, however it could be buggy.")
	elseif command == "rally" then
		CONS_Printf(player, "rally: teleport everyone to you.")
	elseif command == "nuke" then
		CONS_Printf(player, "nuke: destroy ALL objects in the map")
		CONS_Printf(player, "(WARNING, THIS MAY CRASH THE GAME)")
	elseif command == "setemeralds" then
		CONS_Printf(player, "setemeralds: allows you to set the emeralds the server has.")
		CONS_Printf(player, 'setemeralds none - Remove all emeralds')
		CONS_Printf(player, 'setemeralds all  - Get all emeralds')
		CONS_Printf(player, 'setemeralds 123  - Get emeralds 1, 2, and 3; remove all others')
		CONS_Printf(player, '(Use the same method for any combination of emeralds.)')
	elseif command == "whois"
	or command == "goto"
	or command == "rings"
	or command == "lives"
	or command == "shoes"
	or command == "invuln"
	or command == "shield"
	or command == "print"
	or command == "dofor"
	or command == "freeze"
	or command == "gag"
	or command == "kill"
	or command == "bring" 
	or command == "allowgoto" 
	or command == "ringcheats" 
	or command == "shieldcheats"
	or command == "abilitycheats" then
		COM_BufInsertText(player, command)
	else
		CONS_Printf(player, "Invalid command.")
	end
end)


COM_AddCommand("whois", function(player, pname)
	if not pname then
		CONS_Printf(player, "whois <name/num>: find a player using part of their name.")
		CONS_Printf(player, "\"goto\" and other player-based commands use this to find players.")
		return
	end
	local player2 = GetPlayer(player, pname)
	if player2 then
		CONS_Printf(player, player2.name)
	end
end)


COM_AddCommand("die", function(player)
	player.pflags = $1 & ~PF_GODMODE
	player.powers[pw_super] = 0
	P_DamageMobj(player.mo, nil, nil, 0, DMG_INSTAKILL)
end)

COM_AddCommand("kill", function(player, pname)
	if not pname then
		CONS_Printf(player, "kill <name>: kill a player (server/admin only)")
		return
	end
	local player2 = GetPlayer(player, pname)
	if player2 then
		player2.pflags = $1 & ~PF_GODMODE
		player2.powers[pw_super] = 0
		P_DamageMobj(player2.mo, nil, nil, 0, DMG_INSTAKILL)
	end
end, 1)

local shieldcheats = true
local abilitycheats = true
local ringcheats = true

COM_AddCommand("shieldcheats", function(player, yesno)
	if not yesno then
		CONS_Printf(player, "shieldcheats true/false: allow or stop use of shield based commands, such as shield or flower. Currently set to "..tostring(shieldcheats))
		return
	end
	if yesno == "true" then
		shieldcheats = true
	elseif yesno == "false"
		shieldcheats = false
	else
		CONS_Printf(player, "shieldcheats true/false: allow or stop use of shield based commands, such as shield or flower. Currently set to "..tostring(shieldcheats))
	end
end, 1)

COM_AddCommand("abilitycheats", function(player, yesno)
	if not yesno then
		CONS_Printf(player, "abilitycheats true/false: allow or stop use of ability based commands, such as shoes or invincibility. Currently set to "..tostring(abilitycheats))
		return
	end
	if yesno == "true" then
		abilitycheats = true
	elseif yesno == "false"
		abilitycheats = false
	else
		CONS_Printf(player, "abilitycheats true/false: allow or stop use of ability based commands, such as shoes or invincibility. Currently set to "..tostring(abilitycheats))
	end
end, 1)

COM_AddCommand("ringcheats", function(player, yesno)
	if not yesno then
		CONS_Printf(player, "ringcheats true/false: allow or stop use of ring based commands, such as rings or lives. Currently set to "..tostring(ringcheats))
		return
	end
	if yesno == "true" then
		ringcheats = true
	elseif yesno == "false"
		ringcheats = false
	else
		CONS_Printf(player, "ringcheats true/false: allow or stop use of ring based commands, such as rings or lives. Currently set to "..tostring(ringcheats))
	end
end, 1)


COM_AddCommand("goto", function(player, pname)
	local isadmin = IsPlayerAdmin(player)
	if not pname then
		CONS_Printf(player, "goto <name>: teleport to another player's location")
		return
	elseif CanCheat(player) then
		if not player.mo then
			CONS_Printf(player, "You arent on the map, so you can't teleport now.")
			return
		end
		
		local player2 = GetPlayer(player, pname)
		if player2 then
			if not player2.mo then
				CONS_Printf(player, "That player isnt on the map, so you can't teleport to them.")
				return
			elseif player2 == player then
				CONS_Printf(player, "You have teleported to yourself. Good for you.")
			else
				if (player2.allowsgoto and player2.allowsgoto == true) or (isadmin == true or player == server) then
				P_TeleportMove(player.mo, player2.mo.x, player2.mo.y, player2.mo.z)
				player.mo.angle = player2.mo.angle
				P_ResetPlayer(player)
				elseif player2.allowsgoto == false
				CONS_Printf(player, "This person has disabled anyone teleporting to them.")
				end
			end
		end
	end
end)

COM_AddCommand("bring", function(player, pname)
	if not pname then
		CONS_Printf(player, "bring <name>: teleport a player to you.")
		return
	elseif CanCheat(player) then
		local player2 = GetPlayer(player, pname)
		if player2 then
			if not player2.mo then
				CONS_Printf(player, "That player isnt on the map, so you can't teleport them to you.")
				return
			elseif player2 == player then
				CONS_Printf(player, "You have teleported yourself to yourself, nice job.")
			else
				P_TeleportMove(player2.mo, player.mo.x, player.mo.y, player.mo.z)
				player2.mo.angle = player.mo.angle
				P_ResetPlayer(player2)
			end
		end
	end
end, 1)

COM_AddCommand("allowgoto", function(player, yesno)
	if not yesno then
		CONS_Printf(player, "allowgoto true/false: determine if players can goto you or not. Doesn't work against rallying nor admins. Currently set to "..tostring(player.allowsgoto))
		return
	end
		if yesno == "true" then
			if player.allowsgoto ~= nil
				player.allowsgoto = true
			end
		elseif yesno == "false"
			if player.allowsgoto ~= nil
				player.allowsgoto = false
			end
		else
			CONS_Printf(player, "allowgoto true/false: determine if players can goto you or not. Doesn't work against rallying. Currently set to "..tostring(player.allowsgoto))
		end
end)

COM_AddCommand("rally", function(player)
	if not player.mo then
		CONS_Printf(player, "You don't exist, so players can't teleport to you now.")
		return
	end
	for player2 in players.iterate do
		if player2.mo then
			if player2 ~= player then
				if player2.ve then -- compatibility with Vehicles
					P_TeleportMove(player2.ve, player.mo.x, player.mo.y, player.mo.z)
				end
				P_TeleportMove(player2.mo, player.mo.x, player.mo.y, player.mo.z)
				player2.mo.angle = player.mo.angle
			end
			P_ResetPlayer(player2)
		end
	end
	print(player.name.." rallied everyone to them.")
end, 1)

COM_AddCommand('setemeralds', function(player, arg, arg2)
	if arg == nil or arg2 ~= nil then
		CONS_Printf(player, 'setemeralds <all, none, 123, etc>: set the current emeralds in the server.')
	else
		if arg == 'all' then arg = '1234567' end
		local previous = emeralds
		emeralds = 0
		local bit = 1
		for i=1,7 do
			if string.find(arg, tostring(i)) ~= nil then
				emeralds = $ | bit
			end
			bit = $ * 2
		end
		print('Emeralds have been set.')
		if emeralds & ~previous then
			S_StartSound(nil, sfx_cgot)
		end
	end
end, 1)

COM_AddCommand("shield", function(player, shield, strength)
	local isadmin = IsPlayerAdmin(player)
	if shieldcheats == true or (isadmin == true or player == server) then
	if not shield then
		CONS_Printf(player, "shield <type>: give yourself a shield")
		CONS_Printf(player, "n: none")
		CONS_Printf(player, "p: pity")
		CONS_Printf(player, "w: whirlwind")
		CONS_Printf(player, "f: force")
		CONS_Printf(player, "e: elemental")
		CONS_Printf(player, "m: attraction")
		CONS_Printf(player, "a: armageddon")
		return
	end

	if CanCheat(player) then
		if player.mo and player.mo.health then
			if shield == "f" then
				P_SwitchShield(player, SH_FORCE|1)
			elseif shield == "p" then
				P_SwitchShield(player, SH_PITY)
			elseif shield == "w" then
				P_SwitchShield(player, SH_WHIRLWIND)
			elseif shield == "e" then
				P_SwitchShield(player, SH_ELEMENTAL)
			elseif shield == "m" then
				P_SwitchShield(player, SH_ATTRACT)
			elseif shield == "a" then
				P_SwitchShield(player, SH_ARMAGEDDON)
			elseif shield == "n"
				P_SwitchShield(player, SH_NONE)
				P_SpawnShieldOrb(player)
			else
				CONS_Printf(player, "Invalid shield, use one of the letters below.")
				CONS_Printf(player, "N: none")
				CONS_Printf(player, "P: pity")
				CONS_Printf(player, "W: whirlwind")
				CONS_Printf(player, "F: force")
				CONS_Printf(player, "E: elemental")
				CONS_Printf(player, "M: attraction")
				CONS_Printf(player, "A: armageddon")
			end
		end
	end
	elseif shieldcheats == false then
		CONS_Printf(player, "Shield cheats have been disabled by an admin")
	end
end)

COM_AddCommand("flower", function(player)
	local isadmin = IsPlayerAdmin(player)
	if shieldcheats == true or (isadmin == true or player == server) then
	if CanCheat(player)
	and player.mo and player.mo.health then
		player.powers[pw_shield] = $1 ^^ SH_FIREFLOWER
	end
	elseif shieldcheats == false then
		CONS_Printf(player, "Shield cheats have been disabled by an admin")
	end
end)

COM_AddCommand("rings", function(player, amount)
	local isadmin = IsPlayerAdmin(player)
	if ringcheats == true or (isadmin == true or player == server) then
	if not amount then
		CONS_Printf(player, "rings <amount>: give yourself rings")
		return
	end
	
	if CanCheat(player) then
		local N = tonumber(amount)
		if N ~= nil then
			P_GivePlayerRings(player, -9999)
			P_GivePlayerRings(player, N)
		end
	end
	elseif ringcheats == false then
		CONS_Printf(player, "Ring cheats have been disabled by an admin")	
	end
end)


COM_AddCommand("lives", function(player, amount)
	local isadmin = IsPlayerAdmin(player)
	if ringcheats == true or (isadmin == true or player == server) then
	-- You cannot accidentally Game Over with this command.
	if not amount then
		CONS_Printf(player, "lives <amount>: give yourself extra lives")
		return
	end
	
	if CanCheat(player) then
		local N = tonumber(amount)
		if N ~= nil then
			P_GivePlayerLives(player, -99)
			P_GivePlayerLives(player, N-1)
		end
	end
	elseif ringcheats == false then
		CONS_Printf(player, "Ring cheats have been disabled by an admin")
	end
end)


COM_AddCommand("shoes", function(player, time)
	local isadmin = IsPlayerAdmin(player)
	if abilitycheats == true or (isadmin == true or player == server) then
	if not time then
		CONS_Printf(player, "shoes <time>: give yourself Super Sneakers")
		return
	end

	if CanCheat(player) then
		local N = tonumber(time)
		if N ~= nil then
			player.powers[pw_sneakers] = N*TICRATE
		end
	end
	elseif abilitycheats == false then
		CONS_Printf(player, "Ability cheats have been disabled by an admin")
	end
end)

COM_AddCommand("invuln", function(player, time)
	local isadmin = IsPlayerAdmin(player)
	if abilitycheats == true or (isadmin == true or player == server) then
	if not time then
		CONS_Printf(player, "invuln <time>: give yourself invulnerability")
		return
	end

	if CanCheat(player) then
		local N = tonumber(time)
		if N ~= nil then
			player.powers[pw_invulnerability] = N*TICRATE
		end
	end
	elseif abilitycheats == false then
		CONS_Printf(player, "Ability cheats have been disabled by an admin")
	end
end)


COM_AddCommand("super", function(player)
	local isadmin = IsPlayerAdmin(player)
	if abilitycheats == true or (isadmin == true or player == server) then
	if CanCheat(player) then
		if player.mo and player.mo.health then
			if (All7Emeralds(emeralds)) then
			if player.powers[pw_super] then
				local N = player.mo.health - 1
				P_GivePlayerRings(player, -9999)
				-- Need to wait a frame before restoring the previous ring count
				COM_BufInsertText(player, "wait 1; rings "..N)
			else
				if player.mo.health < 21 then
					P_GivePlayerRings(player, -9999)
					P_GivePlayerRings(player, 50)
				end
				player.charflags = $1|SF_SUPER 
				P_DoSuperTransformation(player, false)
			end
			else
			CONS_Printf(player, "You don't have all 7 chaos emeralds yet.")
			end
		end
	end
	elseif abilitycheats == false then
		CONS_Printf(player, "Ability cheats have been disabled by an admin")
	end
end)


COM_AddCommand("dofor", function(player, pname, command)
	-- Force someone else's console to execute an arbitrary command.
	-- You can't read their console output, so make sure you don't make a mistake.
	if not pname then
		CONS_Printf(player, "dofor <name> <command>: execute a command for someone else (server/admin only)")
		return
	end
	local player2 = GetPlayer(player, pname)
	if player2 then
		if player2 == server then
			CONS_Printf(player, "You cannot run commands on the server's console.")
			return
		end
		COM_BufInsertText(player2, command)
	end
end, 1)


COM_AddCommand("print", function(player, t, message)
	-- Print an arbitrary message to the console, not in chat.
	-- You can even make your message look like a Lua violation or other in-game error.

	if not t then
		CONS_Printf(player, "print <type> <message>: print something to the console (server/admin only)")
		CONS_Printf(player, "type: Standard, Notice, Warning, Error")
		return
	end
	if not message then
		message = t
		t = "s"
	end
	
	if string.sub(string.lower(t), 1, 1) == "n" then
		print("\x83".."NOTICE: \x80"..message)
	elseif string.sub(string.lower(t), 1, 1) == "w" then
		print("\x82".."WARNING: \x80"..message)
	elseif string.sub(string.lower(t), 1, 1) == "e" then
		print("\x85".."ERROR: \x80"..message)
	else
		print(message)
	end
end, 1)


COM_AddCommand("nuke", function(player, confirm)
	-- Destroy everything except springs and other movement-essential objects.
	-- Removes items, enemies, spawners, and even scenery. (Crashing has been fixed, I hope)
	if confirm == "confirm" then
	S_StopMusic()
	for player2 in players.iterate do
		P_FlashPal(player2, PAL_NUKE, 8*TICRATE)
	end
	S_StartSound(nil, sfx_bkpoof)
	
	for ma in mapthings.iterate do
		if ma.mobj and ma.mobj.valid
		and ma.type > 35 -- Don't remove player spawns!
		and not ma.mobj.player
		and ma.mobj.type ~= MT_BUBBLES
		and ma.mobj.type ~= MT_SIGN
		and ma.mobj.type ~= MT_SPIKE
		and ma.mobj.type ~= MT_METALSONIC_RACE
		and (ma.mobj.flags & (MF_MONITOR|MF_ENEMY|MF_BOSS|MF_SCENERY|MF_AMBIENT|MF_SPECIAL|MF_PAIN) ) then
			P_RemoveMobj(ma.mobj)
		end
	end

	for mo in thinkers.iterate("mobj") do
		local MT = mo.type
		if (mo.flags & (MF_MONITOR|MF_ENEMY|MF_BOSS|MF_SPECIAL|MF_PAIN)
		or MT == MT_ROCKSPAWNER
		or MT == MT_CANNONLAUNCHER
		or MT == MT_FJSPINAXISA
		or MT == MT_FJSPINHELPERA
		or MT == MT_FJSPINAXISB
		or MT == MT_FJSPINHELPERB
		or MT == MT_SNOWMAN
		or MT == MT_TOKEN)
		and MT ~= MT_TARGET
		and MT ~= MT_TELEPORTMAN
		and MT ~= MT_ALTVIEWMAN
		and MT ~= MT_PUSH
		and MT ~= MT_PULL
		and MT ~= MT_POLYANCHOR
		and MT ~= MT_POLYSPAWN
		and MT ~= MT_POLYSPAWNCRUSH
		and MT ~= MT_SKYBOX
		and MT ~= MT_HANGMACEPOINT
		and MT ~= MT_SPINMACEPOINT
		and MT ~= MT_HIDDEN_SLING
		and MT ~= MT_SMALLMACECHAIN
		and MT ~= MT_BIGMACECHAIN
		and MT ~= MT_METALSONIC_RACE
		and MT ~= MT_PLAYER then
			mo.state = S_THOK
			mo.tics = 4
		end
	end
	
	S_StartSound(nil, sfx_timeup)
	else
		CONS_Printf(player, "WARNING: this can crash your game, use with caution. Put 'nuke confirm' in console to force a nuke")
	end
end, 1)


COM_AddCommand("freeze", function(player, pname)
	-- Freezing "everyone" will exclude the server and admin.

	if not pname then
		CONS_Printf(player, "freeze <name>: lock a player's controls (server/admin only)")
		CONS_Printf(player, "Use \"all\" to freeze everyone, and \"none\" to unfreeze everyone.")
		return
	elseif pname == "all" then
		for everyone in players.iterate do
			everyone.frozen = true
		end
		print(player.name.." froze everyone.")
		return
	elseif pname == "none" then
		for everyone in players.iterate do
			everyone.frozen = false
		end
		print(player.name.." unfroze everyone.")
		return
	end
	
	local player2 = GetPlayer(player, pname)
	if player2 then
		player2.frozen = not $1
		if player2.frozen then
			print(player2.name.." is now frozen.")
		else
			print(player2.name.." is no longer frozen.")
		end
	end
end, 1)


COM_AddCommand("gag", function(player, pname)
	-- A gagged player can still use "sayto" to speak with admins.

	if not pname then
		CONS_Printf(player, "gag <name>: prevent a player from speaking")
		CONS_Printf(player, "Use \"all\" to gag everyone, and \"none\" to ungag everyone.")
		CONS_Printf(player, "Do not combine with SRB2's \"mute\"!")
		return
	elseif pname == "all" then
		for everyone in players.iterate do
			everyone.gagged = true
		end
		print(player.name.." gagged everyone.")
		return
	elseif pname == "none" then
		for everyone in players.iterate do
			everyone.gagged = false
		end
		print(player.name.." ungagged everyone.")
		return
	end

	local player2 = GetPlayer(player, pname)
	if player2 then
		player2.gagged = not $1
		if player2.gagged then
			print(player2.name.." cannot speak now.")
		else
			print(player2.name.." can speak again.")
		end
	end
end, 1)


addHook("PlayerMsg", function(player, audience, target, message)
	if not player.gagged
	or (audience == 2 and (target == server or target == admin) )
	or (cv_mute and cv_mute.value) then -- apparently cv_mute doesn't exist, but I'll leave this here
		return false
	end
	CONS_Printf(player, "You cannot speak right now.")
	return true
end)

addHook("ThinkFrame", function()
	for player in players.iterate do
		if player.frozen then
			player.powers[pw_nocontrol] = max($1, 2)
		end
		if player.deadtimer and player.gotflag then
			P_PlayerFlagBurst(player, false)
			player.tossdelay = max($1, 2*TICRATE)
		end
		if player.allowsgoto == nil then
			player.allowsgoto = true
			local prefix = "\x83".."[".."\x84".."Sonic".."\x83".."] ".."\x80"
			chatprintf(player, prefix.."type adminhelp in console for help with admin tools.")
		end
	end
end)
