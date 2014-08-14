routes = require './routes'
Hoek = require 'hoek'
i18n = require './i18n'
###
options:
  clientId: 'some mongodb guid'
  _tenantId: 'some mongodb guid'
  baseUrl: This is the url to your api. For example https://api.mystuff.com
``realm: ignore for now
  scope: leave to null
###
module.exports.register = (plugin, options = {}, cb) ->

  defaults =
    realm: "default"
  options = Hoek.applyToDefaults defaults, options

  routes plugin,options

  plugin.expose 'i18n', i18n # if process.env.NODE_ENV is 'test' # test for plugin loaded during test

  cb()

module.exports.register.attributes =
  pkg: require '../package.json'

