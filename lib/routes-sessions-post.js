(function() {
  var Boom, Hoek, Joi, _, helperAddTokenToUser, i18n, routesDescription, url, validationSchemas;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  Joi = require('joi');

  url = require('url');

  i18n = require('./i18n');

  helperAddTokenToUser = require('./helper-add-token-to-user');

  validationSchemas = require('./validation-schemas');

  routesDescription = "Creates a new session for a user. E.g. logs that user in.";

  module.exports = function(server, options) {
    var OauthAccessTokenModel, hapiOauthStoreMultiTenant, hapiUserStoreMultiTenant, methodsOauthAuth, methodsUsers;
    if (options == null) {
      options = {};
    }
    Hoek.assert(options._tenantId, i18n.assertOptionsTenantIdRequired);
    Hoek.assert(options.baseUrl, i18n.assertOptionsBaseUrlRequired);
    Hoek.assert(options.realm, i18n.assertOptionsRealm);
    options.scope || (options.scope = null);
    hapiOauthStoreMultiTenant = function() {
      return server.plugins['hapi-oauth-store-multi-tenant'];
    };
    Hoek.assert(hapiOauthStoreMultiTenant(), i18n.assertPluginOauth);
    hapiUserStoreMultiTenant = function() {
      return server.plugins['hapi-user-store-multi-tenant'];
    };
    Hoek.assert(hapiUserStoreMultiTenant(), i18n.assertPluginUser);
    OauthAccessTokenModel = function() {
      return hapiOauthStoreMultiTenant().models.OauthAccessToken;
    };
    methodsOauthAuth = function() {
      return hapiOauthStoreMultiTenant().methods.oauthAuth;
    };
    methodsUsers = function() {
      return hapiUserStoreMultiTenant().methods.users;
    };
    Hoek.assert(OauthAccessTokenModel(), i18n.assertOauthAccessTokenModel);
    Hoek.assert(methodsOauthAuth(), i18n.assertMethodsOauthAuth);
    Hoek.assert(methodsUsers(), i18n.assertMethodsUsers);
    return server.route({
      path: "/sessions",
      method: "POST",
      config: {
        auth: false,
        tags: options.routeTagsPublic,
        description: routesDescription,
        validate: {
          params: Joi.object().options({
            allowUnknown: true,
            stripUnknown: true
          }),
          payload: Joi.object().keys({
            login: validationSchemas.login.required().description('The login used to authenticate this session, can either be an email address or a username.'),
            password: validationSchemas.password.required().description('The password used to authenticate this session.'),
            clientId: validationSchemas.clientIdRequired
          }).options({
            allowUnknown: true,
            stripUnknown: true
          })
        },
        response: {
          schema: Joi.object().description("The session object. Might contain more info than shown in the docs.").options({
            allowUnknown: true,
            stripUnknown: false
          }),
          status: {
            400: validationSchemas.errorBadRequest,
            422: validationSchemas.errorUnprocessableEntity,
            500: validationSchemas.errorInternalServerError
          }
        }
      },
      handler: function(request, reply) {
        var clientId, login, password;
        login = request.payload.login;
        password = request.payload.password;
        clientId = request.payload.clientId;
        return methodsUsers().validateUserByUsernameOrEmail(options._tenantId, login, password, null, function(err, user) {
          if (err) {
            return reply(err);
          }
          if (!user) {
            return reply(Boom.create(422, i18n.errorInvalidLoginOrPassword));
          }
          return helperAddTokenToUser(methodsOauthAuth(), options.baseUrl, options._tenantId, user._id, clientId, options.realm, options.scope, user, function(err, userWithToken) {
            if (err) {
              return reply(err);
            }
            return reply(userWithToken).code(201);
          });
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes-sessions-post.js.map
