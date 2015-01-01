Hoek = require 'hoek'

i18n = require './i18n'
routesSessionsPost = require './routes-sessions-post'
routesSessionsMeDelete = require './routes-sessions-me-delete'

###
options:
  clientId: 'some mongodb guid'
  _tenantId: 'some mongodb guid'
  baseUrl: This is the url to your api. For example https://api.mystuff.com
``realm: ignore for now
  scope: leave to null
###
module.exports.register = (server, options = {}, cb) ->

  defaults =
    realm: "default"
  options = Hoek.applyToDefaults defaults, options

  routesSessionsPost server,options
  routesSessionsMeDelete server,options

  server.expose 'i18n', i18n # if process.env.NODE_ENV is 'test' # test for plugin loaded during test

  cb()

module.exports.register.attributes =
  pkg: require '../package.json'

