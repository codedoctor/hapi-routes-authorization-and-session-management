(function() {
  var Boom, Hoek, Joi, helperAddTokenToUser, url, validationSchemas, _;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  Joi = require("joi");

  url = require('url');

  helperAddTokenToUser = require('./helper-add-token-to-user');

  validationSchemas = require('./validation-schemas');

  module.exports = function(plugin, options) {
    var OauthAccessTokenModel, hapiIdentityStore, methodsOauthAuth, methodsUsers;
    if (options == null) {
      options = {};
    }
    Hoek.assert(options.clientId, "options parameter requires a clientId");
    Hoek.assert(options.accountId, "options parameter requires an accountId");
    Hoek.assert(options.baseUrl, "options parameter requires an baseUrl");
    Hoek.assert(options.realm, "options parameter requires a realm");
    options.scope || (options.scope = null);
    hapiIdentityStore = function() {
      return plugin.plugins['hapi-identity-store'];
    };
    Hoek.assert(hapiIdentityStore(), "Could not find 'hapi-identity-store' plugin.");
    OauthAccessTokenModel = function() {
      return hapiIdentityStore().models.OauthAccessToken;
    };
    methodsUsers = function() {
      return hapiIdentityStore().methods.users;
    };
    methodsOauthAuth = function() {
      return hapiIdentityStore().methods.oauthAuth;
    };
    Hoek.assert(methodsUsers(), "Could not find 'methods.users' in 'hapi-identity-store' plugin.");
    Hoek.assert(methodsOauthAuth(), "Could not find  'methods.oauthAuth' in 'hapi-identity-store' plugin.");
    Hoek.assert(OauthAccessTokenModel(), "Could not find 'models.OauthAccessToken' in 'hapi-identity-store' plugin.");
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
        return methodsUsers().validateUserByUsernameOrEmail(options.accountId, login, password, null, function(err, user) {
          if (err) {
            return reply(err);
          }
          if (!user) {
            return reply(Boom.create(422, "Invalid login or password."));
          }
          return helperAddTokenToUser(methodsOauthAuth(), options.baseUrl, options.accountId, user._id, options.clientId, options.realm, options.scope, user, function(err, userWithToken) {
            if (err) {
              return reply(err);
            }
            return reply(userWithToken);
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
          return reply(Boom.unauthorized("Authentication required for this endpoint. You must supply a token"));
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
