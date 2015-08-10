(function() {
  var Boom, Hoek, _, helperAddTokenToUser, i18n;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  i18n = require('./i18n');

  helperAddTokenToUser = require('./helper-add-token-to-user');

  module.exports = function(server, options) {
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
      path: "/sessions/me",
      method: "DELETE",
      handler: function(request, reply) {
        var ref, ref1, token;
        token = (ref = request.auth) != null ? (ref1 = ref.credentials) != null ? ref1.token : void 0 : void 0;
        if (!token) {
          return reply(Boom.unauthorized(i18n.errorUnauthorized));
        }
        return OauthAccessTokenModel().remove({
          _id: token
        }, function(err) {
          if (err) {
            return reply(err);
          }
          return reply().code(204);
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes-sessions-me-delete.js.map
