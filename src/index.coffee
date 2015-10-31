Hoek = require 'hoek'

i18n = require './i18n'



routesToExpose = [
  require './routes-sessions-post'
  require './routes-sessions-me-delete'
]



###
options:
  _tenantId: 'some mongodb guid'
  baseUrl: This is the url to your api. For example https://api.mystuff.com
``realm: ignore for now
  scope: leave to null
###
module.exports.register = (server, options = {}, cb) ->

  defaults =
    realm: "default"
    routeTagsPublic: ['api','api-public','session']
    routeTagsAdmin: ['api','api-admin','session']
  options = Hoek.applyToDefaults defaults, options

  r server,options for r in routesToExpose

  server.expose 'i18n', i18n # if process.env.NODE_ENV is 'test' # test for plugin loaded during test

  cb()

module.exports.register.attributes =
  pkg: require '../package.json'

