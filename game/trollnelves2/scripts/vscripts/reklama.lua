local msgs = {
	['You can support the game on Patreon. Вы можете поддержать игру на Патрион.'] = {
		StartTime = 100,
		Interval = 300,
		MaxCount = 12,
	},
	['DONATE: https://patreon.com/troll_vs_elves3'] = {
		StartTime = 600,
		Interval = 600,
		MaxCount = 12
	},
	['Join our server Discord! Присоединяйтесь к нашему серверу Дискорд!'] = {
		StartTime = 900,
		Interval = 600,
		MaxCount = 3
	},
	['Discord: https://discord.gg/zwYYbex'] = {
		StartTime = 950,
		Interval = 650,
		MaxCount = 3	
	},
	['Вы можете поделиться идеями/багами/пожеланиями на нашем сервере Дискорд.!'] = {
		StartTime = 1900,
		Interval = 650,
		MaxCount = 3	
	},
	['Submit your ideas on what to add to the game in our Discord server!'] = {
		StartTime = 2000,
		Interval = 700,
		MaxCount = 3	
	},
	['Спасибо всем  тестирам  за  такой значительный  вклад  в развитие кастомки! Спасибо:*'] = {
		StartTime = 7200	
	},
	['Thanks to all the testers for such a significant contribution to the development of the game! Thank:*'] = {
		StartTime = 7500	
	}
}

for msg, info in pairs( msgs ) do
	Timers:CreateTimer( function()
		GameRules:SendCustomMessage("<font color='#58ACFA'>" .. msg .. "</font>", 0, 0)
		if info.MaxCount then
			info.MaxCount = info.MaxCount - 1
			if info.MaxCount <= 0 then
				return
			end
		end
		return info.Interval
	end, info.StartTime )
end