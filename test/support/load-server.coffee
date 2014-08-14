_ = require 'underscore'
databaseCleaner = require './database-cleaner'
Hapi = require "hapi"
hapiOauthStoreMultiTenant = require 'hapi-oauth-store-multi-tenant'
hapiUserStoreMultiTenant = require 'hapi-user-store-multi-tenant'
index = require '../../lib/index'
mongoose = require 'mongoose'

fixtures = require './fixtures'

testMongoDbUrl = 'mongodb://localhost/codedoctor-test'
testPort = 5675
testHost = "localhost"
loggingEnabled = false



module.exports = loadServer = (cb) ->
  server = new Hapi.Server testPort,testHost,{}

  pluginConf = [
      plugin: hapiOauthStoreMultiTenant
    ,
      plugin: hapiUserStoreMultiTenant
    ,
      plugin: index
      options:
        clientId:  fixtures.clientId
        _tenantId: fixtures._tenantId
        baseUrl: "http://localhost:#{testPort}"
        realm: 'codedoctor'
        scope: null
  ]

  mongoose.disconnect()
  mongoose.connect testMongoDbUrl, (err) ->
    return cb err if err
    databaseCleaner loggingEnabled, (err) ->
      return cb err if err

      server.pack.register pluginConf, (err) ->
        cb err,server