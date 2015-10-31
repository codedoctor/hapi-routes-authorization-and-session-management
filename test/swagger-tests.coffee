_ = require 'underscore'
should = require 'should'
shouldHttp = require './support/should-http'
loadServer = require './support/load-server'

describe 'swagger-tests', ->
  server = null

  beforeEach (cb) ->
    loadServer (err,serverResult) ->
      server = serverResult
      cb err

  describe 'GET /swagger', ->
    it 'should return a 200', (cb) ->
      shouldHttp.get server,"/swagger",null,200, (err,response) ->
        should.exist response.result
        cb err


