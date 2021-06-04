function tp1(event)
   local unit = event.activator
   local wws = tostring("tp_out" .. string.match(event.caller:GetName(),"%d+"))  -- вот та сама точка, куда мы будем телепортировать героя, мы её указали в скрипте
	DebugPrint(wws)
   local ent =  Entities:FindAllByName("tp_in1") --строка ищет как раз таки нашу точку pnt1
   DebugPrint(#ent)
   DebugPrintTable(#ent)   
   local point = ent[RandomInt(1,#ent)]:GetAbsOrigin() --эта строка выясняет где находится pnt1 и получает её координаты
   unit:SetAbsOrigin( point ) -- получили координаты, теперь меняем место героя на pnt1
   FindClearSpaceForUnit(unit, point, false) --нужно чтобы герой не застрял
   unit:Stop() --приказываем ему остановиться, иначе он побежит назад к предыдущей точке
end