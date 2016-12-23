# Description:
#   Scripts specific to ICFB
#
# Mostly not very useful stuff, just maybe some Christian greetings

module.exports = (robot) ->

  # robot.hear /pray for.\+/i, (res) ->
  #   res.send "Amen!"

  # robot.hear /amen/i, (res) ->
  #   robot.messageRoom res.message.user.name,
  #     'I no longer respond to spontaneously to "amen"'

  robot.error (err, res) ->
    robot.logger.error "BEYOND MY COMPREHENSION"

    if res?
      res.reply "BEYOND MY COMPREHENSION"

