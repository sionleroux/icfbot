# Description:
#
# Basic HTTP Web frontend so that you don't get "Can't get /" message

module.exports = (robot) ->

  robot.router.get '/', (req, res) ->
    res.send 'I am a robot.'
