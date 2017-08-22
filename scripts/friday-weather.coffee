# Description:
#   Tells you what the weather will be at 6 PM next Friday.
#
# Pretty hard-coded and mostly copied from the forecastio weather script.
# Defaults to Budapest.
#
# Dependencies:
#   Moment (for doing maths with time)
#
# Configuration:
#   HUBOT_FORECAST_IO_API_KEY
#   HUBOT_FORECAST_IO_UNITS
#
# Commands:
#   hubot Friday weather in {location}

moment = require 'moment'

forecastIoApiKey = process.env.HUBOT_FORECAST_IO_API_KEY
forecastIoUnits = process.env.HUBOT_FORECAST_IO_UNITS || 'ca'

module.exports = (robot) ->
  robot.logger.error "friday-weather: You must set HUBOT_FORECAST_IO_API_KEY in your envrionment variables" unless forecastIoApiKey

  robot.respond /Friday weather( in)?( .*)?/i, (msg) ->

    friday = moment({hour: 18}).day('Friday')
    # Hourly weather only available up to 48 hours, daily weather only shown for 7 AM
    if friday.isAfter(moment().add(2, 'days'))
      friday = friday.utc().hour(7)
      lowaccuracy = true

    location = if msg.match[2]? then encodeURI(msg.match[2]) else 'Budapest'
    msg.http("http://maps.googleapis.com/maps/api/geocode/json?address=#{location}&sensor=false")
    .get() (err, res, body) ->
      geocodeResponse = JSON.parse(body)
      formattedLocation = geocodeResponse.results[0].formatted_address
      lat = geocodeResponse.results[0].geometry.location.lat
      lng = geocodeResponse.results[0].geometry.location.lng

      msg.http("https://api.darksky.net/forecast/#{forecastIoApiKey}/#{lat},#{lng}?units=#{forecastIoUnits}")
        .get() (err, res, body) ->
          forecastResponse = JSON.parse(body)
          datapoints = if lowaccuracy? then forecastResponse.daily else forecastResponse.hourly
          robot.logger.error datapoints.data
          weather = datapoints.data.find (x) -> moment.unix(x.time).isSame(
            friday,
            if lowaccuracy then 'day' else 'hour'
          )
          if weather
            msg.send "This Friday in #{formattedLocation}, it will be #{weather.summary}."
          else
            msg.send "Something went wrong checking the weather..."
