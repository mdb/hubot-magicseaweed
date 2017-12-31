# Description
#   Grabs the current Magicseaweed forecast
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_MAGICSEAWEED_API_KEY
#   HUBOT_MAGICSEAWEED_DEFAULT_LOCATION
#
# Commands:
#   hubot seaweed - Get the weather for HUBOT_MAGICSEAWEED_DEFAULT_LOCATION
#   hubot seaweed <location> - Get the weather for <location>
#
# Author:
#   mdb

AsciiTable = require 'ascii-table'
moment = require 'moment'

module.exports = (robot) ->
  robot.respond /seaweed ?(.+)?/i, (msg) ->
    location = msg.match[1] || process.env.HUBOT_MAGICSEAWEED_DEFAULT_LOCATION
    url = "http://magicseaweed.com/api/#{process.env.HUBOT_MAGICSEAWEED_API_KEY}/forecast/?spot_id=#{location}"

    robot.http(url)
      .get() (err, res, body) ->
        if err
          msg.emote "Magicseaweed request responded #{err} :("
          return

        if res.statusCode isnt 200
          msg.emote "Magicseaweed request responded HTTP #{res.statusCode} :("
          return

        msg.emote "```#{format(JSON.parse(body))}```"

format = (forecast) ->
  table = new AsciiTable()

  table.setHeading('Day', 'Combined Swell', 'Wind')

  for day, i in forecast
    swell = day.swell.components.combined
    table.addRow(formatDate(day.localTimestamp), "#{swell.height}#{day.swell.unit} @ #{swell.period}s #{swell.compassDirection}", "#{day.wind.speed}#{day.wind.unit} #{day.wind.compassDirection}")

  table.toString()

formatDate = (timestamp) ->
  moment.unix(timestamp).format("dddd, MMM Do, h:mm a")
