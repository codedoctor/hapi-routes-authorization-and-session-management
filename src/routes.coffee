_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"

helperAddTokenToUser = require './helper-add-token-to-user'

Joi = require "joi"
url = require 'url'
validationSchemas = require './validation-schemas'


module.exports = (plugin,options = {}) ->
  Hoek.assert options.clientId,"options parameter requires a clientId"
  Hoek.assert options.accountId,"options parameter requires an accountId"
  Hoek.assert options.baseUrl,"options parameter requires an baseUrl"
  Hoek.assert options.realm,"options parameter requires a realm"
  options.scope ||= null


  hapiIdentityStore = -> plugin.plugins['hapi-identity-store']
  Hoek.assert hapiIdentityStore(),"Could not find 'hapi-identity-store' plugin."

  OauthAccessTokenModel = -> hapiIdentityStore().models.OauthAccessToken
  Hoek.assert OauthAccessTokenModel(),"Could not find 'models.OauthAccessToken' plugin."


  users = -> hapiIdentityStore().methods.users
  oauthAuth = -> hapiIdentityStore().methods.oauthAuth
  oauthApps = -> hapiIdentityStore().methods.oauthApps



  plugin.route
    path: "/sessions"
    method: "POST"
    config:
      auth: false
      validate:
        payload: validationSchemas.schemaSessionsPost
    handler: (request, reply) ->
      login = request.payload.login
      password = request.payload.password


      users().validateUserByUsernameOrEmail options.accountId,login, password, (err, user) ->
        return reply err if err

        ###
        @TODO Should be 422
        ###
        return reply Boom.badRequest("Invalid login or password.") unless user

        helperAddTokenToUser oauthAuth(), options.baseUrl,options.accountId,user._id,options.clientId,options.realm,options.scope,user, (err, userWithToken) ->
          return reply err if err
          reply userWithToken

  plugin.route
    path: "/sessions/me"
    method: "DELETE"
    handler: (request, reply) ->
      token = request.auth.credentials.token

      console.log "DELETING TOKEN #{token}"

      OauthAccessTokenModel().remove _id : token, (err) =>
        return reply err if err
      
        reply {}

