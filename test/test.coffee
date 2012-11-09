chai = require('chai')
should = chai.should()
expect = chai.expect

config = require '../config'

describe 'VM508', ->
    device1 = config.createDevice('VM500_8')

    testdata = new Buffer 60
    beforeEach ->
        testdata.fill 0x0
        testdata[0] = 0x3f
        testdata[1] = 0xcd
        testdata[2] = 0xdc
        testdata[3] = 0x0

    describe 'Temperature 1', ->

        it 'should be Temperature type', ->
            result = device1.parse testdata
            result.sensors[0].type.should.equal 'Temperature'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[0].id.should.be.greaterThan 0

        it 'should not be connected', ->
            testdata[4] = 0x03
            testdata[5] = 0xe8
        
            result = device1.parse testdata
            result.sensors[0].connected.should.be.false

        it 'should be out of limits', ->
            testdata[6] = 0x0
            testdata[7] = 0x0a
            testdata[8] = 0x1

            result = device1.parse testdata
            result.sensors[0].outoflimits.should.be.true
            result.sensors[0].timeoutoflimits.should.equal 10

        it 'should be normal temperature', ->
            testdata[4] = 0x0
            testdata[5] = 0x48

            result = device1.parse testdata
            result.sensors[0].connected.should.be.true
            result.sensors[0].reading.should.equal 72

        it 'should have resolution of 1', ->
            testdata[58] = 0xa
            
            result = device1.parse testdata
            result.sensors[0].resolution.should.equal 1

        it 'should have scale in degrees F', ->
            testdata[59] = 0x46

            result = device1.parse testdata
            result.sensors[0].scale.should.equal 'F'

    describe 'Humidity 1', ->

        it 'should be Humidity type', ->
            result = device1.parse testdata
            result.sensors[1].type.should.equal 'Humidity'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[1].id.should.be.greaterThan 0

        it 'should not be connected', ->
            testdata[9] = 0x03
            testdata[10] = 0xe8
        
            result = device1.parse testdata
            result.sensors[1].connected.should.be.false

        it 'should be out of limits', ->
            testdata[11] = 0x0
            testdata[12] = 0x0b
            testdata[13] = 0x1

            result = device1.parse testdata
            result.sensors[1].outoflimits.should.be.true
            result.sensors[1].timeoutoflimits.should.equal 11

        it 'should be normal humidity', ->
            testdata[9] = 0x0
            testdata[10] = 0xf

            result = device1.parse testdata
            result.sensors[1].connected.should.be.true
            result.sensors[1].reading.should.equal 15

    describe 'Water', ->

        it 'should be Water type', ->
            result = device1.parse testdata
            result.sensors[8].type.should.equal 'Water'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[8].id.should.be.greaterThan 0

        it 'should be loss of power', ->
            testdata[44] = 0x03
            testdata[45] = 0xe8

            result = device1.parse testdata
            result.sensors[8].lossofpower.should.be.true

        it 'should be water present', ->
            testdata[44] = 0x0
            testdata[45] = 0x1

            result = device1.parse testdata
            result.sensors[8].present.should.be.true

        it 'should be out of limits', ->
            testdata[46] = 0x0
            testdata[47] = 0x0c
            testdata[48] = 0x1

            result = device1.parse testdata
            result.sensors[8].outoflimits.should.be.true
            result.sensors[8].timeoutoflimits.should.equal 12

        it 'should be no water present', ->
            testdata[44] = 0x0
            testdata[45] = 0x0

            result = device1.parse testdata
            result.sensors[8].present.should.be.false
            result.sensors[8].lossofpower.should.be.false

describe 'VM505', ->
    device1 = config.createDevice('VM500_5')

    testdata = new Buffer 60
    beforeEach ->
        testdata.fill 0x0
        testdata[0] = 0x3f
        testdata[1] = 0xcd
        testdata[2] = 0xdc
        testdata[3] = 0x0

    describe 'Temperature 1', ->

        it 'should be Temperature type', ->
            result = device1.parse testdata
            result.sensors[0].type.should.equal 'Temperature'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[0].id.should.be.greaterThan 0

        it 'should not be connected', ->
            testdata[4] = 0x03
            testdata[5] = 0xe8
        
            result = device1.parse testdata
            result.sensors[0].connected.should.be.false

        it 'should be out of limits', ->
            testdata[6] = 0x0
            testdata[7] = 0x0a
            testdata[8] = 0x1

            result = device1.parse testdata
            result.sensors[0].outoflimits.should.be.true
            result.sensors[0].timeoutoflimits.should.equal 10

        it 'should be normal temperature', ->
            testdata[4] = 0x2
            testdata[5] = 0xD0
            testdata[58] = 0xa

            result = device1.parse testdata
            result.sensors[0].connected.should.be.true
            result.sensors[0].reading.should.equal 72.0

        it 'should have resolution of 10', ->
            testdata[58] = 0xa
            
            result = device1.parse testdata
            result.sensors[0].resolution.should.equal 10

        it 'should have scale in degrees F', ->
            testdata[59] = 0x46

            result = device1.parse testdata
            result.sensors[0].scale.should.equal 'F'

    describe 'Door 1', ->

        it 'should be Door type', ->
            result = device1.parse testdata
            result.sensors[8].type.should.equal 'Door'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[8].id.should.be.greaterThan 0

        it 'should be open', ->
            testdata[44] = 0x0
            testdata[45] = 0x0

            result = device1.parse testdata
            result.sensors[8].open.should.be.true

        it 'should be closed', ->
            testdata[44] = 0x0
            testdata[45] = 0x1

            result = device1.parse testdata
            result.sensors[8].open.should.be.false

        it 'should be loss of power', ->
            testdata[44] = 0x03
            testdata[45] = 0xe8

            result = device1.parse testdata
            result.sensors[8].lossofpower.should.be.true

        it 'should be out of limits', ->
            testdata[47] = 0x0a
            testdata[48] = 0x1

            result = device1.parse testdata
            result.sensors[8].outoflimits.should.be.true
            result.sensors[8].timeoutoflimits.should.equal 10

describe 'VM540', ->
    device1 = config.createDevice('VM540_LV')

    testdata = new Buffer 60
    beforeEach ->
        testdata.fill 0x0
        testdata[0] = 0x3f
        testdata[1] = 0xcd
        testdata[2] = 0xdc
        testdata[3] = 0x0

    describe 'Temperature 1', ->

        it 'should be Temperature type', ->
            result = device1.parse testdata
            result.sensors[0].type.should.equal 'Temperature'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[0].id.should.be.greaterThan 0

        it 'should not be connected', ->
            testdata[4] = 0x03
            testdata[5] = 0xe8
        
            result = device1.parse testdata
            result.sensors[0].connected.should.be.false

        it 'should be out of limits', ->
            testdata[6] = 0x0
            testdata[7] = 0x0a
            testdata[8] = 0x1

            result = device1.parse testdata
            result.sensors[0].outoflimits.should.be.true
            result.sensors[0].timeoutoflimits.should.equal 10

        it 'should be normal temperature', ->
            testdata[4] = 0x0
            testdata[5] = 0x48

            result = device1.parse testdata
            result.sensors[0].connected.should.be.true
            result.sensors[0].reading.should.equal 72

        it 'should have resolution of 1', ->
            testdata[58] = 0xa
            
            result = device1.parse testdata
            result.sensors[0].resolution.should.equal 1

        it 'should have scale in degrees F', ->
            testdata[59] = 0x46

            result = device1.parse testdata
            result.sensors[0].scale.should.equal 'F'

    describe 'Power 1', ->

        it 'should be Power type', ->
            result = device1.parse testdata
            result.sensors[4].type.should.equal 'Power'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[4].id.should.be.greaterThan 0

        it 'should be power on', ->
            testdata[24] = 0x0
            testdata[25] = 0x1

            result = device1.parse testdata
            result.sensors[4].power.should.be.true

        it 'should be power off', ->
            testdata[24] = 0x0
            testdata[25] = 0x0

            result = device1.parse testdata
            result.sensors[4].power.should.be.false

        it 'should be out of limits', ->
            testdata[26] = 0x0
            testdata[27] = 0x0c
            testdata[28] = 0x1

            result = device1.parse testdata
            result.sensors[4].outoflimits.should.be.true
            result.sensors[4].timeoutoflimits.should.equal 12

    describe 'Aux', ->

        it 'should be Aux type', ->
            result = device1.parse testdata
            result.sensors[8].type.should.equal 'Aux'

        it 'should have an id set', ->
            result = device1.parse testdata
            result.sensors[8].id.should.be.greaterThan 0

        it 'should be power on', ->
            testdata[44] = 0x0
            testdata[45] = 0x1

            result = device1.parse testdata
            result.sensors[8].power.should.be.true

        it 'should be power off', ->
            testdata[44] = 0x0
            testdata[45] = 0x0

            result = device1.parse testdata
            result.sensors[8].power.should.be.false

        it 'should be out of limits', ->
            testdata[46] = 0x0
            testdata[47] = 0x0c
            testdata[48] = 0x1

            result = device1.parse testdata
            result.sensors[8].outoflimits.should.be.true
            result.sensors[8].timeoutoflimits.should.equal 12

