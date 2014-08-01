assert = require 'assert'
should = require 'should'

fixtures = require './support/fixtures'
loadServer = require './support/load-server'
setupServer = require './support/setup-server'

describe 'WHEN testing routes', ->
  server = null

  beforeEach (cb) ->
    loadServer (err,serverResult) ->
      server = serverResult
      cb err

  describe '/sessions without server setup', ->
    it 'POST with invalid data should 422', (cb) ->
      options =
        method: "POST"
        url: "/sessions"
        payload: 
          login: 'mw'
          password: '12345678abc'
 
      server.inject options, (response) ->
        result = response.result

        response.statusCode.should.equal 422
        should.exist result
        cb null

  describe '/sessions with server setup', ->
    beforeEach (cb) ->
      setupServer server,cb

    it 'POST with invalid data should return a 422', (cb) ->
      options =
        method: "POST"
        url: "/sessions"
        payload: 
          login: 'mw'
          password: '12345678abc'
 
      server.inject options, (response) ->
        result = response.result

        response.statusCode.should.equal 422
        should.exist result
  
        cb null


    it 'POST with valid data should return a token', (cb) ->
      options =
        method: "POST"
        url: "/sessions"
        payload: 
          login: fixtures.user1.username
          password: fixtures.user1.password
 
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
          token: "01234567890123456789000b"


      server.inject options, (response) ->
        result = response.result

        response.statusCode.should.equal 204
  
        cb null
