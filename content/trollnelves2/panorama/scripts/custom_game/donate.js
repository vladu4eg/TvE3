function DonateToggleButtonActivate() {
	var panel = $( "#DonateContainer" )
	panel.SetHasClass('Visible', !panel.BHasClass('Visible'))
	// if ( panel.style.visibility == "visible" ) {
	// 	panel.style.visibility = "collapse"
	// } else {
	// 	panel.style.visibility = "visible"
	// }
}

function AddEvent( button, itemname ) {
	button.SetPanelEvent( "onactivate", function() {
		GameEvents.SendCustomGameEventToServer( "donate_player_take", { id: Players.GetLocalPlayer(), itemname: itemname } );
    } )
}




function DonatePanelUpdate( table, id, lists ) {
	if ( id == Players.GetLocalPlayer() ) {
		var panel = $( "#DonateItemsList" )
		if ( panel.GetAttributeInt( "created", 0 ) == 0 ) {
			for ( name in lists ) {
				var items = lists[name]
				// var list_panel = $.CreatePanel( "Panel", panel, "" )
				var list_name = $.CreatePanel( "Label", panel, "" )
				list_name.text = $.Localize( "donate_list_name_" + name )
				list_name.AddClass( "ListName" )
				var list = $.CreatePanel( "Panel", panel, "" )
				list.AddClass( "DonateItemsList" )

				var item_count = 0
				var row = null
				var countRow = 8
				for ( i in items ) {
					if ( item_count % 7 == 0 ) {
						row = $.CreatePanel( "Panel", list, "" )
						row.AddClass( "Row" )
					}

					var iteminfo = items[i]
					var button = $.CreatePanel( "Button", row, "" )
					AddEvent( button, iteminfo.name )
					button.SetAttributeString( "itemname", iteminfo.name )
					var item = $.CreatePanel( "DOTAItemImage", button, "" )
					item.itemname = iteminfo.name
					item.hittest = true

					if ( iteminfo.count > 0 ) {
						button.AddClass( "DonateItemButton" )
					} else {
						button.AddClass( "DonateItemButtonHidden" )
					}

					panel.SetAttributeInt( "created", 1 )

					item_count++
				}
			} 
		} else {
//			$.Msg( "ANIME" )
			var listsinfo = panel.Children()
			for ( i in listsinfo ) {
				var rows = listsinfo[i].Children()
				for ( int in rows ) {
					var items = rows[int].Children()
					for ( ii in items ) {
						var button = items[ii]
						var item_name = button.GetAttributeString( "itemname", "" )
						for ( n in lists ) {
							for ( iitem in lists[n] ) {
								var iteminfo = lists[n][iitem]
//								$.Msg( iteminfo )
//								$.Msg( lists[n] )
								if ( iteminfo.name == item_name ) {
									if ( iteminfo.count > 0 ) {
										button.AddClass( "DonateItemButton" )
									} else {
										button.AddClass( "DonateItemButtonHidden" ) 
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

( function () {
	GameEvents.SendCustomGameEventToServer( "donate_player_create", { id: Players.GetLocalPlayer() } );
	CustomNetTables.SubscribeNetTableListener( "donate", DonatePanelUpdate )
	var items = CustomNetTables.GetTableValue( "donate", Players.GetLocalPlayer().toString() )
	$( "#DonateItemsList" ).SetAttributeInt( "created", 0 )
	if ( items ) {
		DonatePanelUpdate( null, Players.GetLocalPlayer(), items )
	}
} )();