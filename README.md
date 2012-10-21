# Temperature Guard #

This project contains a server written in NodeJS that reads data from a Temperature Guard unit and displays each sensor data while pushing continuous updates to browser clients using Socket.io

The code is based on the specifications from the Microtechnologies [Temperature Guard](http://www.temperatureguard.com) Integration Guide.

## Vendor Applet ##

The device contains a Java applet that is accessed using a web browser when visiting the standard HTTP port.  The applet contains a table with the following information and a way to display a chart for one of two time frames.

* Unit ID:
* Last Updated: date/time
* Trending Time Frame: 1 Hour, 8 Hours
* Display Table
    * Select (checkbox)
    * Sensor (Name from Spec: Zone 1 Temp)
    * Name (Computer room)
    * Reading
    * Units (deg F, %RH, etc)
    * Status (OK, N/C)
    * Lower Limit
    * Upper Limit
    * Time Out Of Limit

## Data model ##

A Device contains an array of Sensor configurations and their offsets in the response bytes.
A Device can parse the response bytes into an array of objects that contains each sensor
config and the current reading data.

Sensor types:

* Temperature
    * Config
        * name
	    * type (Temperature)
	    * upperlimit
	    * lowerlimit
	    * units (Degrees)
    * Reading
	    * value
        * outoflimits (true or false)
	    * timeoutoflimits
	    * connected (true or false)
	    * resolution (1, 10, etc)
	    * scale (C or F)
* Humidity
    * Config
	    * name
	    * type (Humidity)
	    * units (%)
	    * upperlimit
	    * lowerlimit
    * Reading
	    * value
	    * outoflimits (true or false)
	    * timeoutoflimits
	    * connected (true or false)
	    * scale (RH)
* Door (2 kinds)
    * Config
	    * name
	    * type (Door1 or Door2)
    * Reading
	    * state (open, closed, loss of power)
	    * outoflimits (true or false)
        * timeoutoflimits
* Water
    * Config
        * name
	    * type (Water)
    * Reading
        * present
        * loss of power
        * outoflimits (true or false)
        * timeoutoflimits
* Power
    * Config
        * name
	    * type (Power)
    * Reading
        * state (on, off)
        * outoflimits (true or false)
        * timeoutoflimits
* Aux Alarm
    * Config
        * name
	    * type (Aux)
    * Reading
        * state (on, off)
        * outoflimits (true or false)
        * timeoutoflimits

Clone the sensor configuration on each reading and set the current reading values.

Object.create(proto [, propertiesObject])

## Layout ##

Dynamically create a display for each type of sensor that is connected and refreshed when new data
arrives.

Need to find an open source digital font to include.
[Digital Dream](http://www.fontsquirrel.com/fonts/Digital-dream)

Use a responsive layout engine like bootstrap to adjust for desktop, tablet and mobile browsers.

## REST Service ##

* /v1/device [GET]
* /v1/device/{id} [GET]

* /v1/device/{id}/sensors [GET]
* /v1/device/{id}/sensors/{sid} [GET]

## Graphing ##

### Google Visualization ###

Convert the config section on the first message to the DataTable column definitions.

Take the data returned and add a new row to the DataTable created on load.

Call draw(view) for the Table and the Graph with their views against the DataTable

Need a way to group the table data by the timestamp and only get the most recent value for the table.

Need a way to get the timestamp


### Dojo Charts ###

### gRaphael ###
[gRaphael](http://g.raphaeljs.com/)

### D3 ###
[D3](http://d3js.org/)

## TODO ##


