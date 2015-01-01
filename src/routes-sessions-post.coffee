_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"
Joi = require 'joi'
url = require 'url'

i18n = require './i18n'
helperAddTokenToUser = require './helper-add-token-to-user'
validationSchemas = require './validation-schemas'


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
    path: "/sessions"
    method: "POST"
    config:
      auth: false
      validate:
        payload: Joi.object().keys(
                                    login: validationSchemas.login.required()
                                    password: validationSchemas.password.required().description('The password used to authenticate this session.')
                                  ).options({ allowUnkown: true, stripUnknown: true })
    handler: (request, reply) ->
      login = request.payload.login
      password = request.payload.password

      methodsUsers().validateUserByUsernameOrEmail options._tenantId,login, password,null, (err, user) ->
        return reply err if err
        return reply Boom.create(422,i18n.errorInvalidLoginOrPassword) unless user

        helperAddTokenToUser methodsOauthAuth(), options.baseUrl,options._tenantId,user._id,options.clientId,options.realm,options.scope,user, (err, userWithToken) ->
          return reply err if err
          reply(userWithToken).code(201)


