_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"
Joi = require 'joi'
i18n = require './i18n'


module.exports = (server,options = {}) ->

  hapiOauthStoreMultiTenant = -> server.plugins['hapi-oauth-store-multi-tenant']
  Hoek.assert hapiOauthStoreMultiTenant(),i18n.assertPluginOauth

  OauthAccessTokenModel = -> hapiOauthStoreMultiTenant().models.OauthAccessToken
  Hoek.assert OauthAccessTokenModel(),i18n.assertOauthAccessTokenModel

  server.route
    path: "/sessions/me"
    config:
      description: "Destroys the session of the currently logged in user. E.g. logs that user out."
      tags: options.routeTagsPublic
    method: "DELETE"
    handler: (request, reply) ->
      token = request.auth?.credentials?.token
      return reply Boom.unauthorized(i18n.errorUnauthorized) unless token

      OauthAccessTokenModel().remove _id : token, (err) ->
        return reply err if err
      
        reply().code(204)

