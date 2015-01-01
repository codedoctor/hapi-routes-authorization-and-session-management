_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"

i18n = require './i18n'
helperAddTokenToUser = require './helper-add-token-to-user'

module.exports = (server,options = {}) ->
  Hoek.assert options.clientId,i18n.assertOptionsClientIdRequired
  Hoek.assert options._tenantId,i18n.assertOptionsTenantIdRequired
  Hoek.assert options.baseUrl,i18n.assertOptionsBaseUrlRequired
  Hoek.assert options.realm,i18n.assertOptionsRealm
  options.scope ||= null

  hapiOauthStoreMultiTenant = -> server.plugins['hapi-oauth-store-multi-tenant']
  Hoek.assert hapiOauthStoreMultiTenant(),i18n.assertPluginOauth
  hapiUserStoreMultiTenant = -> server.plugins['hapi-user-store-multi-tenant']
  Hoek.assert hapiUserStoreMultiTenant(),i18n.assertPluginUser

  OauthAccessTokenModel = -> hapiOauthStoreMultiTenant().models.OauthAccessToken
  methodsOauthAuth = -> hapiOauthStoreMultiTenant().methods.oauthAuth
  methodsUsers = -> hapiUserStoreMultiTenant().methods.users

  Hoek.assert OauthAccessTokenModel(),i18n.assertOauthAccessTokenModel
  Hoek.assert methodsOauthAuth(),i18n.assertMethodsOauthAuth
  Hoek.assert methodsUsers(),i18n.assertMethodsUsers

  server.route
    path: "/sessions/me"
    method: "DELETE"
    handler: (request, reply) ->
      token = request.auth?.credentials?.token
      return reply Boom.unauthorized(i18n.errorUnauthorized) unless token

      OauthAccessTokenModel().remove _id : token, (err) ->
        return reply err if err
      
        reply().code(204)

