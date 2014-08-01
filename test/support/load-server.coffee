_ = require 'underscore'
databaseCleaner = require './database-cleaner'
Hapi = require "hapi"
hapiIdentityStore = require 'hapi-identity-store'
index = require '../../lib/index'
mongoose = require 'mongoose'

testMongoDbUrl = 'mongodb://localhost/codedoctor-test'
testPort = 5675
testHost = "localhost"
loggingEnabled = false



module.exports = loadServer = (cb) ->
  server = new Hapi.Server testPort,testHost,{}

  pluginConf = [
      plugin: hapiIdentityStore
    ,
      plugin: index
      options:
        clientId:  '010101010101010101010a'
        accountId: '010101010101010101010b'
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