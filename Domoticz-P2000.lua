function Telegram(message)
	local bot = '999999999'; -- Telegram Bot ID
	local token = '<Telegrambot Token here>'; -- Telegram Bot Token
	local chatId = '99999999'; -- Telegram Chat ID
	
	os.execute('curl --data chat_id='..chatId..' --data-urlencode "text='..message..'"  "https://api.telegram.org/bot'..bot..':'..token..'/sendMessage" ')
	return
end

function ProcessItem(item)

	id = tostring(item.id)
	prio1 = tostring(item.prio1)
	dienst = tostring(item.dienst)
	melding = tostring(item.msg) --items[0].msg
	icon = tostring(item.icon)
	datum = tostring(item.date)

	local lat = tostring(item.lat)
	local lon = tostring(item.lon)
	local google = ''
	if( lon ~= nil and lon ~= '0.00000' ) then
		google = ('https://www.google.com/maps/search/?api=1&query='..lat..','..lon)
	end
	composed = ('['..datum..'] '..melding..' '..icon)
	return id,composed,google
end

function ProcessResponse(domoticz,triggerItem,sensor)
	
	local updatesensor = false
	local maxid = tostring(domoticz.data.maxid)
	local composed=''
	
	if (triggerItem.ok) then

		triggerItem.json = domoticz.utils.fromJSON(triggerItem.data) 
		tc = #triggerItem.json.items -- item count
		if (tc > 0 ) then print('Processing '..tc..' items') end
		i = tc
		while i >= 1 do
			local curitem=triggerItem.json.items[i]
--			The message can  contain one message or consists of number of subitems 
			if ( tostring(curitem.hassubs) == '1' )then
				sc = #curitem.subitems -- subitem count
				j=1
				repeat
					id,subcomposedgoogle = ProcessItem(curitem.subitems[j])

					maxid = math.max(tonumber(maxid),tonumber(id))
					composed = tostring(composed..' '..subcomposed) -- Combine subitems into one
 					updatesensor=true
					Telegram('P2000 '..subcomposed..' '..google) -- Send every subitem separate to Telegram

					j = j + 1
				until j > sc
			else
				id,composed,google = ProcessItem(curitem)

				maxid = math.max(tonumber(maxid),tonumber(id))
				updatesensor=true
				Telegram('P2000 '..composed..' '..google)
			end

			i = i - 1
		end
		if ( updatesensor ) then
			sensor.updateText(composed)
			domoticz.data.maxid = maxid
		end
	else
		print('Item not ok')
	end
end

return {
		on = {
			timer = { 'every 5 minutes' }, 
			httpResponses = { 'AlarmeringdroidhttpResponse' } -- matches callback string below
		},
	        data = {
           		maxid = { initial = 1 }
       		},
		execute = function(domoticz, triggerItem)

	sensor = domoticz.devices('P2000')

	--parameters to be set (or not, if you leave empty the results will not be filtered )
	local capcode = '' 
	-- Seemseems to work only if also regio of plaats is used
	local regio = ''
	-- 1=Amsterdam-Amstelland 6=Brabant Noord 11=Brabant Zuid-Oost 12=Drenthe 27=Flevoland 7=Friesland 
	-- 8=Gelderland-Midden 13=Gelderland-Zuid 19=Gooi en Vechtstreek 2=Groningen 25=Haaglanden 
	-- 5=Hollands Midden 17=IJsselland 9=Kennemerland 15=Limburg-Noord 21=Limburg-Zuid 26=Midden- en West Brabant 
	-- 3=Noord- en Oost Gelderland 24=Noord-Holland Noord 10=Rotterdam-Rijnmond 23=Twente 18=Utrecht 
	-- 4=Zaanstreek-Waterland 20=Zeeland 14=Zuid-Holland Zuid
	local priority='true'
	local dienst = ''
	-- 1= Politie 2 = Brandweer 3 = Ambulance 4 = KNRM 5 = Lifeliner 7 = Dares  
	local plaats = 'Utrecht'

	if (triggerItem.isTimer) then
		url = 'https://www.alarmeringdroid.nl/api/livemon?dienst='..dienst..'&regio='..regio..'&capcode='..capcode..'&plaats='..plaats..'&prio1='..priority..'&id='..domoticz.data.maxid 
		domoticz.openURL({
			url = url,
			method = 'GET',
			callback = 'AlarmeringdroidhttpResponse' -- matches above httpResponses
		})
		print(url)
	end
	if (triggerItem.isHTTPResponse) then
		print('Valid Response')
		ProcessResponse(domoticz,triggerItem,sensor)
	end
end
}
