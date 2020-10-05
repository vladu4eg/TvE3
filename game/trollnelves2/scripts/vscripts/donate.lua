if Donate == nil then
	print ( '[Donate] creating Donate' )
	Donate = {}
end

FirstSpawned = {}

DONATE_SET_PREMIUM_1 = {
	players = {
		--		201083179,
	},
}

DONATE_SET_PREMIUM_2 = {
	players = {
		--		201083179,
	},
}

DONATE_SET_PREMIUM_3 = {
	players = {
		201083179,
	},
}

DONATE_ITEM_TANGOS = {
	players = {
		--		201083179,
	},	
}

DONATE_ITEM_BOOTS = {
	players = {
		--		201083179,
	},	
}

DONATE_ITEM_AGANIM = {
	players = {
		--		201083179,
	},	
}

DONATE_ITEM_RAPIER = {
	players = {
		--		201083179,
	},	
}

DONATE_ITEM_APEX = {
	players = {
		--		201083179,
	},	
}


DONATE_ITEMS = {
	heroes = {
		--{
		--	name = "item_root_ability",
		--	can_be_bought = true,
		--	free_available = true,
		--	count = 1,
		--	sets ={
		--	},
		--},
		--{
		--	name = "item_dmg_2",
		--	can_be_bought = true,
		--	free_available = true,
		--	count = 1,
		--	sets ={
		--	},
		--},
		{
			name = "item_refresher",
			can_be_bought = true,
			count = 3,
			sets ={
				DONATE_SET_PREMIUM_1,
				DONATE_SET_PREMIUM_2,
				DONATE_SET_PREMIUM_3,
			},
		},
		
	},
	artifacts = {
		{
			name = "item_ironwood_tree",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_ITEM_TANGOS,
				DONATE_SET_PREMIUM_1,
				DONATE_SET_PREMIUM_2,
				DONATE_SET_PREMIUM_3,
			},
		},
		{
			name = "item_boots",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_ITEM_BOOTS,
				DONATE_SET_PREMIUM_1,
				DONATE_SET_PREMIUM_2,
				DONATE_SET_PREMIUM_3,
			},
		},
		{
			name = "item_ultimate_scepter",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_SET_PREMIUM_2,
				DONATE_SET_PREMIUM_3,
				DONATE_ITEM_AGANIM,
			},
		},
		{
			name = "item_rapier",
			can_be_bought = true,
			count = 1,
			sets ={
				DONATE_ITEM_RAPIER,
				DONATE_SET_PREMIUM_3,
			},
		},
		{
			name = "item_apex",
			can_be_bought = false,
			count = 1,
			sets ={
				DONATE_ITEM_APEX,
				DONATE_SET_PREMIUM_3,
			},
		},
		
	},
}

function Donate:CreateList()
	self.players = {}
	for p = 0, PlayerResource:GetPlayerCount() - 1 do
		self.players[p] = {}
		local acc_id = PlayerResource:GetSteamAccountID( p )
		local player = self.players[p]
		
		if acc_id then
			for list, items in pairs( DONATE_ITEMS ) do
				for _, item in pairs( items ) do
					local item_info = {
						name = item.name,
						sets = {}
					}
					local player_has = item.free_available or nil
					for _, set in pairs( item.sets ) do
						for _, id in pairs( set.players or {} ) do
							if id == acc_id then
								player_has = true
							end
						end
						if set.name and set.can_be_bought then
							local set_info = {
								name = set.name,
								can_be_bought = set.can_be_bought,
								free_available = set.free_available,
							}
							table.insert( item_info.sets, set_info )
						end
					end
					
					if item.can_be_bought or player_has then
						player[list] = player[list] or {}
						
						if player_has then
							item_info.count = item.count
							else
							item_info.count = -1
						end
						table.insert( player[list], item_info )
					end
				end
			end
		end
		self:UpdateNetTables( p )
	end
end

function Donate:UpdateNetTables( pId )
	CustomNetTables:SetTableValue( "donate", tostring( pId ), self.players[pId] )
end

function Donate:PlayerTake( info )
	local self = Donate
	
	local player_data = self.players[info.id]
	if not player_data then return end
	
	local player = PlayerResource:GetPlayer( info.id )
	
	if player and player:GetAssignedHero() then
		for _, l in pairs( player_data ) do
			for _, i in pairs( l ) do
				if i.name == info.itemname and i.count > 0 then
					local hero = player:GetAssignedHero()
					for ii = 0, 8 do
						if not hero:GetItemInSlot( ii ) then
							player:GetAssignedHero():AddItemByName( i.name )
							i.count = i.count - 1
							self:UpdateNetTables( info.id )
							return
						end
					end
				end
			end
		end
	end
end


function addModifierBySteamID(enum,modifier_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddNewModifier( npc, nil, modifier_name, nil) end)
		end
	end
end
CustomGameEventManager:RegisterListener( "donate_player_take", Dynamic_Wrap( Donate, "PlayerTake" ) )