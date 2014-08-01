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
  methodsUsers = -> hapiIdentityStore().methods.users
  methodsOauthAuth = -> hapiIdentityStore().methods.oauthAuth

  Hoek.assert methodsUsers(),"Could not find 'methods.users' in 'hapi-identity-store' plugin."
  Hoek.assert methodsOauthAuth(),"Could not find  'methods.oauthAuth' in 'hapi-identity-store' plugin."
  Hoek.assert OauthAccessTokenModel(),"Could not find 'models.OauthAccessToken' in 'hapi-identity-store' plugin."


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

      methodsUsers().validateUserByUsernameOrEmail options.accountId,login, password,null, (err, user) ->
        console.log "B"
        return reply err if err

        ###
        @TODO Should be 422
        ###
        return reply Boom.badRequest("Invalid login or password.") unless user

        helperAddTokenToUser methodsOauthAuth(), options.baseUrl,options.accountId,user._id,options.clientId,options.realm,options.scope,user, (err, userWithToken) ->
          return reply err if err
          reply userWithToken

  plugin.route
    path: "/sessions/me"
    method: "DELETE"
    handler: (request, reply) ->
      token = request.auth?.credentials?.token
      return reply Boom.unauthorized("Authentication required for this endpoint. You must supply a token") unless token

      OauthAccessTokenModel().remove _id : token, (err) =>
        return reply err if err
      
        reply().code(204)

