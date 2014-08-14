(function() {
  var Boom, Hoek, Joi, helperAddTokenToUser, i18n, url, validationSchemas, _;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  Joi = require("joi");

  url = require('url');

  i18n = require('./i18n');

  helperAddTokenToUser = require('./helper-add-token-to-user');

  validationSchemas = require('./validation-schemas');

  module.exports = function(plugin, options) {
    var OauthAccessTokenModel, hapiOauthStoreMultiTenant, hapiUserStoreMultiTenant, methodsOauthAuth, methodsUsers;
    if (options == null) {
      options = {};
    }
    Hoek.assert(options.clientId, i18n.assertOptionsClientIdRequired);
    Hoek.assert(options._tenantId, i18n.assertOptionsTenantIdRequired);
    Hoek.assert(options.baseUrl, i18n.assertOptionsBaseUrlRequired);
    Hoek.assert(options.realm, i18n.assertOptionsRealm);
    options.scope || (options.scope = null);
    hapiOauthStoreMultiTenant = function() {
      return plugin.plugins['hapi-oauth-store-multi-tenant'];
    };
    Hoek.assert(hapiOauthStoreMultiTenant(), i18n.assertPluginOauth);
    hapiUserStoreMultiTenant = function() {
      return plugin.plugins['hapi-user-store-multi-tenant'];
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
    plugin.route({
      path: "/sessions",
      method: "POST",
      config: {
        auth: false,
        validate: {
          payload: validationSchemas.schemaSessionsPost
        }
      },
      handler: function(request, reply) {
        var login, password;
        login = request.payload.login;
        password = request.payload.password;
        return methodsUsers().validateUserByUsernameOrEmail(options._tenantId, login, password, null, function(err, user) {
          if (err) {
            return reply(err);
          }
          if (!user) {
            return reply(Boom.create(422, i18n.errorInvalidLoginOrPassword));
          }
          return helperAddTokenToUser(methodsOauthAuth(), options.baseUrl, options._tenantId, user._id, options.clientId, options.realm, options.scope, user, function(err, userWithToken) {
            if (err) {
              return reply(err);
            }
            console.log(JSON.stringify(userWithToken));
            return reply(userWithToken).code(201);
          });
        });
      }
    });
    return plugin.route({
      path: "/sessions/me",
      method: "DELETE",
      handler: function(request, reply) {
        var token, _ref, _ref1;
        token = (_ref = request.auth) != null ? (_ref1 = _ref.credentials) != null ? _ref1.token : void 0 : void 0;
        if (!token) {
          return reply(Boom.unauthorized(i18n.errorUnauthorized));
        }
        return OauthAccessTokenModel().remove({
          _id: token
        }, (function(_this) {
          return function(err) {
            if (err) {
              return reply(err);
            }
            return reply().code(204);
          };
        })(this));
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map
