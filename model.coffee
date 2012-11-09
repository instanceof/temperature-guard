
getNumberFromBytes = (high, low) ->
    result = (high << 8) + (0xff & low)
    if result >= 0x8000 then -(0x10000 - result) else result

class Device
    constructor: (config) ->
        @name = config.name || ""
        @sensors = []

        for {id, name, type}, i in config.sensors
            sensor = {
                start: config.offsets[i].start
                end: config.offsets[i].end
            }
            switch type
                when 'Temperature' then sensor['sensor'] = new Temperature id, name
                when 'Humidity' then sensor['sensor'] = new Humidity id, name
                when 'Door' then sensor['sensor'] = new Door id, name
                when 'Water' then sensor['sensor'] = new Water id, name
                when 'Power' then sensor['sensor'] = new Power id, name
                when 'Aux' then sensor['sensor'] = new Aux id, name
            @sensors.push sensor

    parse: (data, options = {}) ->
        datetime = new Date()
        readings = []
        readings.push config.sensor?.parse?((data.slice config.start, config.end), options) for config in @sensors
        {
            'datetime': datetime.toISOString(),
            'sensors': readings
        }

class Sensor
    constructor: (@id, @name, @type) ->

    parse: (data, options = {}) ->
        {
            id: @id,
            name: @name,
            type: @type
        }

    toString: ->
        "#{@name} #{@type}"

class Temperature extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Temperature"

    parse: (data, options = {}) ->
        sensor = super
        resolution = options.resolution ? 1
        reading = (getNumberFromBytes data[0], data[1]) / resolution
        connected = (reading isnt 1000)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['reading'] = reading
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor['connected'] = connected
        sensor['resolution'] = resolution
        sensor['scale'] = options.scale if options.scale
        sensor

class Humidity extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Humidity"

    parse: (data, options = {}) ->
        sensor = super
        reading = getNumberFromBytes data[0], data[1]
        connected = (reading isnt 1000)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['reading'] = reading
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor['connected'] = connected
        sensor

class Door extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Door"

    parse: (data, options = {}) ->
        sensor = super
        state = getNumberFromBytes data[0], data[1]
        open = (state is 0)
        lop = (state is 1000)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['open'] = open
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor['lossofpower'] = lop
        sensor

class Water extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Water"

    parse: (data, options = {}) ->
        sensor = super
        state = getNumberFromBytes data[0], data[1]
        present = (state is 1)
        lop = (state is 1000)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['present'] = present
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor['lossofpower'] = lop
        sensor

class Power extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Power"

    parse: (data, options = {}) ->
        sensor = super
        status = getNumberFromBytes data[0], data[1]
        power = (status is 1)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['power'] = power
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor

class Aux extends Sensor
    constructor: (@id, @name) ->
        super @id, @name, "Aux"

    parse: (data, options = {}) ->
        sensor = super
        status = getNumberFromBytes data[0], data[1]
        power = (status is 1)
        ool = (data[4] is 1)
        tool = if ool then getNumberFromBytes data[2], data[3] else 0
        sensor['power'] = power
        sensor['outoflimits'] = ool
        sensor['timeoutoflimits'] = tool
        sensor

#
# VM500-5-DCP-E and VM500-10-DCP-E
#
exports.VM500_5 = exports.VM500_10 = class VM500_5 extends Device
    constructor: (config) ->
        super

    parse: (data) ->
        options = {}
        # Add this check only for devices in the spec that use resolution
        options.resolution = if data[58] is 10 then 10 else 1
        options.scale = String.fromCharCode data[59] if data[59] isnt 0
        super data, options

# 
# VM500-8-DCP-E
#
exports.VM500_8 = class VM500_8 extends Device
    constructor: (config) ->
        super

    parse: (data) ->
        options = {}
        # Add this check only for devices in the spec that use resolution
        options.resolution = 1
        options.scale = String.fromCharCode data[59] if data[59] isnt 0
        super data, options

#
# VM540-LV-DCP-E
# 
exports.VM540_LV = class VM540_LV extends Device
    constructor: (config) ->
        super

    parse: (data) ->
        options = {}
        # Add this check only for devices in the spec that use resolution
        options.resolution = 1
        options.scale = String.fromCharCode data[59] if data[59] isnt 0
        super data, options

