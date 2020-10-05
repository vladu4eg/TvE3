function CDOTA_BaseNPC:ClearInventory()
	local item_count = self:GetNumItemsInInventory()
	for i=0, item_count do
		local item = self:GetItemInSlot(i)
		self:RemoveItem(item)
	end
end

function CDOTA_BaseNPC:RemoveDesol2()
	local item = self:FindItemInInventory("item_disable_repair_2")
	self:RemoveItem(item)
end

function CDOTA_BaseNPC:GetCollisionSize()
	if GetUnitKV(self:GetUnitName()) then
		return GetUnitKV(self:GetUnitName(),"CollisionSize")
	end
	return nil
end

function CDOTA_BaseNPC:ClearInventoryCM()
	local item_count = self:GetNumItemsInInventory()
	local blink = self:FindItemInInventory("item_blink_datadriven")
	for i=0, item_count do
		local item = self:GetItemInSlot(i)
		DebugPrint(item)
		if blink ~= item then
			self:RemoveItem(item)
		end
	end
end

function CDOTA_BaseNPC:ClearInventoryFull()
	for i=0, 5 do
		local item = self:GetItemInSlot(i)
		if item ~= nil then
			self:RemoveItem(item)
		end
	end
end