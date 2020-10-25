
function ItemPickFilter(ctx, event, itemParent)
    local unit = EntIndexToHScript(event.inventory_parent_entindex_const)
    local item = EntIndexToHScript(event.item_entindex_const)
    local itemParent = EntIndexToHScript(itemParent.item_parent_entindex_const)
    if unit:GetNumItemsInInventory() >= 6 then
      CreateItemOnPositionSync(unit:GetAbsOrigin(), item)
      return false
    end
end