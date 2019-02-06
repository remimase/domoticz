return {

	baseType = 'device',

	name = 'Counter device adapter',

	matches = function (device, adapterManager)
		local res = (       device.deviceSubType == 'RFXMeter counter' 
                        or  device.deviceSubType == 'Counter Incremental'
                        or  device.deviceSubType == 'Managed Counter')

		if (not res) then
			adapterManager.addDummyMethod(device, 'updateCounter')
		end

		return res
	end,

	process = function (device, data, domoticz, utils, adapterManager)

		-- from data: counter, counterToday, valueQuantity, valueUnits

		local valueFormatted = device.counterToday or ''
		local info = adapterManager.parseFormatted(valueFormatted, domoticz['radixSeparator'])
		device['counterToday'] = info['value']

		valueFormatted = device.counter or ''
		info = adapterManager.parseFormatted(valueFormatted, domoticz['radixSeparator'])
		device['counter'] = info['value']
        
        if device.deviceSubType == 'Managed Counter' and ( device.valueUnits == nil or device.valueUnits == "" ) then
            device.valueUnits = string.match(device._data.data.counter, "%a+%d*") or ''  
        end
        
		function device.updateCounter(value)
			return device.update(0, value)
		end

	end

}