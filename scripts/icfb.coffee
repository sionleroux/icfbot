# Description:
#   Scripts specific to ICFB
#
# Mostly not very useful stuff, just maybe some Christian greetings

module.exports = (robot) ->

  robot.hear /amen/i, (res) ->
    res.send "Amen!"

  robot.error (err, res) ->
    robot.logger.error "BEYOND MY COMPREHENSION"

    if res?
      res.reply "BEYOND MY COMPREHENSION"

