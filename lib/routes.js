(function() {
  var Boom, Hoek, Joi, helperAddTokenToUser, url, validationSchemas, _;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  helperAddTokenToUser = require('./helper-add-token-to-user');

  Joi = require("joi");

  url = require('url');

  validationSchemas = require('./validation-schemas');

  module.exports = function(plugin, options) {
    var OauthAccessTokenModel, hapiIdentityStore, oauthApps, oauthAuth, users;
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
    Hoek.assert(OauthAccessTokenModel(), "Could not find 'models.OauthAccessToken' plugin.");
    users = function() {
      return hapiIdentityStore().methods.users;
    };
    oauthAuth = function() {
      return hapiIdentityStore().methods.oauthAuth;
    };
    oauthApps = function() {
      return hapiIdentityStore().methods.oauthApps;
    };
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
        return users().validateUserByUsernameOrEmail(options.accountId, login, password, function(err, user) {
          if (err) {
            return reply(err);
          }

          /*
          @TODO Should be 422
           */
          if (!user) {
            return reply(Boom.badRequest("Invalid login or password."));
          }
          return helperAddTokenToUser(oauthAuth(), options.baseUrl, options.accountId, user._id, options.clientId, options.realm, options.scope, user, function(err, userWithToken) {
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
        var token;
        token = request.auth.credentials.token;
        console.log("DELETING TOKEN " + token);
        return OauthAccessTokenModel().remove({
          _id: token
        }, (function(_this) {
          return function(err) {
            if (err) {
              return reply(err);
            }
            return reply({});
          };
        })(this));
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map
