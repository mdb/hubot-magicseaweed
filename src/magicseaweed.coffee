# Description
#   Grabs the current Magic Seaweed forecast
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_MAGIC_SEAWEED_API_KEY
#   HUBOT_MAGIC_SEAWEED_DEFAULT_LOCATION
#
# Commands:
#   hubot seaweed - Get the weather for HUBOT_MAGIC_SEAWEED_DEFAULT_LOCATION
#   hubot seaweed <location> - Get the weather for <location>
#
# Author:
#   mdb
module.exports = (robot) ->
  robot.respond /seaweed ?(.+)?/i, (msg) ->
    location = msg.match[1] || process.env.HUBOT_MAGIC_SEAWEED_DEFAULT_LOCATION
    url = "http://magicseaweed.com/api/#{process.env.HUBOT_MAGIC_SEAWEED_API_KEY}/forecast/?spot_id=#{location}"

    robot.http(url)
      .get() (err, res, body) ->
        if res.statusCode isnt 200
          msg.emote "Magic Seaweed request responded HTTP #{res.statusCode} :("
          return

        msg.emote body
