net = require 'net'
http = require 'http'
io = require 'socket.io'
express = require 'express'

config = require './config'

# Create the command request
command = new Buffer 60
command.fill 0x0
command[0] = 0x3f
command[1] = 0xcd
command[2] = 0xdc
command[3] = 0x0

# Keep a bounded array of past readings
readingslimit = 20
readings = []

device1 = config.createDevice()
config1 = config.getConfig()

getReading = ->
    process.nextTick ->
        # Create the connection to the device
        console.log 'Connecting to device...'
        tg = net.Stream()
        tg.connect 10001, 'localhost'

        tg.on 'connect', ->
            console.log 'Connected to device'
            # Write the command
            tg.end command
            console.log 'Wrote the command'

        tg.on 'data', (data) ->
            console.log 'Data returned ' + data.length + ' bytes'

            reading = device1.parse data
            #console.dir reading

            # Add the new reading and keep it bounded
            readings.push reading
            readings.shift() if readings.length > readingslimit
            console.log 'Readings size: ' + readings.length

            # broadcast the new reading to any clients
            io.sockets.json.send { 'readings' : [ reading ] }
		
        tg.on 'end', ->
            console.log 'Connection End'

        tg.on 'drain', ->
            console.log 'Connection drained'

        tg.on 'error', (exception) ->
            console.log exception
		
        tg.on 'close', (had_error) ->
            console.log 'Connection closed with error? ' + had_error


app = express()
app.use express.logger()
app.use express.static __dirname+'/public'

server = http.createServer app
		
io = io.listen server

server.listen 8080

# Client connection
io.sockets.on 'connection', (client) ->

    # Send the configuration and all the readings to the new client
    client.json.send {
        'config': config1,
        'readings': readings
    }
	
    # Send a message to all the other clients
    client.broadcast.json.send { announcement: client.id + ' connected' }

    # Register a callback for client disconnect events
    client.on 'disconnect', ->
        client.broadcast.json.send { announcement: client.id + ' disconnected' }

# Start the reading events
getReading()
setInterval getReading, 5000
