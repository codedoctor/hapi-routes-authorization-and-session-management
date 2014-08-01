assert = require 'assert'
should = require 'should'

loadServer = require './support/load-server'


describe 'WHEN testing routes', ->
  server = null

  beforeEach (cb) ->
    loadServer (err,serverResult) ->
      server = serverResult
      cb err

  describe '/sessions', ->
    it 'POST with valid data should return a token', (cb) ->
      options =
        method: "POST"
        url: "/sessions"
        payload: 
          login: 'mw'
          password: '12345678abc'
 
      server.inject options, (response) ->
        result = response.result

        response.statusCode.should.equal 201
        should.exist result

  
        cb null

  describe '/sessions/me', ->
    it 'DELETE should return a status code 204', (cb) ->
      options =
        method: "DELETE"
        url: "/sessions/me"
        credentials:
          token: "someToken"


      server.inject options, (response) ->
        result = response.result

        response.statusCode.should.equal 204
        should.exist result

  
        cb null
