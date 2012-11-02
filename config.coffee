{VM500_5,VM500_10,VM500_8} = require('./model')

devices = {}

# Uncomment the device to create
#device = 'VM500_5'
#device = 'VM500_10'
devices['VM500_5'] = {
    config: {
        name: "Computer Room"
        sensors: [
            {
                'id': 1,
                'name': 'Temperature 1',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 2,
                'name': 'Temperature 2',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 3,
                'name': 'Temperature 3',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 4,
                'name': 'Temperature 4',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 5,
                'name': 'Temperature 5',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 6,
                'name': 'Temperature 6',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 7,
                'name': 'Temperature 7',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 8,
                'name': 'Temperature 8',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 9,
                'name': 'Door 1',
                'type': 'Door'
            },
            {
                'id': 10,
                'name': 'Door 2',
                'type': 'Door'
            }
        ],
        offsets: [
            { start: 4, end: 9 },
            { start: 9, end: 14 },
            { start: 14, end: 19 },
            { start: 19, end: 24 },
            { start: 24, end: 29 },
            { start: 29, end: 34 },
            { start: 34, end: 39 },
            { start: 39, end: 44 },
            { start: 44, end: 49 },
            { start: 49, end: 55 }
        ]
    },
    cons: VM500_5
}
devices['VM500_10'] = devices['VM500_5']
#
device = 'VM500_8'
devices['VM500_8'] = {
    config: {
        name: "Computer Room"
        sensors: [
            {
                'id': 1,
                'name': 'Temperature 1',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 2,
                'name': 'Humidity 1',
                'type': 'Humidity',
                'units': '%',
                'upperlimit': 0,
                'lowerlimit': 0
            },
            {
                'id': 3,
                'name': 'Temperature 2',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 4,
                'name': 'Humidity 2',
                'type': 'Humidity',
                'units': '%',
                'upperlimit': 0,
                'lowerlimit': 0
            },
            {
                'id': 5,
                'name': 'Temperature 3',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 6,
                'name': 'Humidity 3',
                'type': 'Humidity',
                'units': '%',
                'upperlimit': 0,
                'lowerlimit': 0
            },
            {
                'id': 7,
                'name': 'Temperature 4',
                'type': 'Temperature',
                'units': 'Deg',
                'upperlimit': 75,
                'lowerlimit': 60
            },
            {
                'id': 8,
                'name': 'Humidity 4',
                'type': 'Humidity',
                'units': '%',
                'upperlimit': 0,
                'lowerlimit': 0
            },
            {
                'id': 9,
                'name': 'Water',
                'type': 'Water'
            }
        ],
        offsets: [
            { start: 4, end: 9 },
            { start: 9, end: 14 },
            { start: 14, end: 19 },
            { start: 19, end: 24 },
            { start: 24, end: 29 },
            { start: 29, end: 34 },
            { start: 34, end: 39 },
            { start: 39, end: 44 },
            { start: 44, end: 49 }
        ]
    },
    cons: VM500_8
}

exports.createDevice = (name) ->
    dev = name || device
    new devices[dev].cons devices[dev].config

exports.getConfig = (name) ->
    dev = name || device
    devices[dev].config

