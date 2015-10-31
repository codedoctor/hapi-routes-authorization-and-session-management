_ = require 'underscore'
should = require 'should'
Hoek = require 'hoek'

module.exports =
  get200PagedEmptyResult: (server,pathWithRoot,credentials,cb) ->
    options =
      method: "GET"
      url: pathWithRoot
      credentials: credentials

    server.inject options, (response) ->
      response.statusCode.should.equal 200
      should.exist response.result
      
      response.result.should.have.property "_pagination"
      response.result._pagination.should.have.property "totalCount",0

      cb null,response

  get200Paged: (server,pathWithRoot,resultCount,credentials,cb) ->
    options =
      method: "GET"
      url: pathWithRoot
      credentials: credentials

    server.inject options, (response) ->
      response.statusCode.should.equal 200    
      should.exist response.result
      response.result.should.have.property "_pagination"
      response.result._pagination.should.have.property "totalCount",resultCount

      cb null,response

  get: (server,pathWithRoot,credentials,statusCode,cb) ->
    options =
      method: "GET"
      url: pathWithRoot
      credentials: credentials

    server.inject options, (response) ->
      response.statusCode.should.equal statusCode
      cb null,response

  post: (server,pathWithRoot,payload,credentials,statusCode = 200,cb) ->
    Hoek.assert _.isObject(server),"The required parameter server is missing or not an object."
    Hoek.assert _.isString(pathWithRoot), "The required parameter pathWithRoot is not a string."
    Hoek.assert _.isNumber(statusCode), "The required parameter statuscode is missing or not a number."
    Hoek.assert _.isFunction(cb), "The required parameter cb is missing or not a function."        
    options =
      method: "POST"
      credentials: credentials
      payload: payload
      url: pathWithRoot

    server.inject options, (response) ->
      response.statusCode.should.equal statusCode  
      cb null,response

  patch: (server,pathWithRoot,payload,credentials,statusCode = 200,cb) ->
    options =
      method: "PATCH"
      url: pathWithRoot
      credentials : credentials
      payload: payload

    server.inject options, (response) ->
      response.statusCode.should.equal statusCode
      cb null,response

  put: (server,pathWithRoot,payload,credentials,statusCode = 200,cb) ->
    options =
      method: "PUT"
      url: pathWithRoot
      credentials : credentials
      payload: payload

    server.inject options, (response) ->
      response.statusCode.should.equal statusCode
      cb null,response
 
  delete: (server,pathWithRoot,credentials,statusCode = 200,cb) ->
    options =
      method: "DELETE"
      url: pathWithRoot
      credentials: credentials

    server.inject options, (response) ->
      response.statusCode.should.equal statusCode
      cb null,response

