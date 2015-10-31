(function() {
  var Boom, Hoek, Joi, _, i18n, routesDescription, validationSchemas;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  Joi = require('joi');

  i18n = require('./i18n');

  validationSchemas = require('./validation-schemas');

  routesDescription = "Destroys the session of the currently logged in user. E.g. logs that user out.";

  module.exports = function(server, options) {
    var OauthAccessTokenModel, hapiOauthStoreMultiTenant;
    if (options == null) {
      options = {};
    }
    hapiOauthStoreMultiTenant = function() {
      return server.plugins['hapi-oauth-store-multi-tenant'];
    };
    Hoek.assert(hapiOauthStoreMultiTenant(), i18n.assertPluginOauth);
    OauthAccessTokenModel = function() {
      return hapiOauthStoreMultiTenant().models.OauthAccessToken;
    };
    Hoek.assert(OauthAccessTokenModel(), i18n.assertOauthAccessTokenModel);
    return server.route({
      path: "/sessions/me",
      method: "DELETE",
      config: {
        description: routesDescription,
        tags: options.routeTagsPublic,
        validate: {
          params: Joi.object().options({
            allowUnknown: true,
            stripUnknown: true
          })
        },
        response: {
          schema: validationSchemas.responseDelete,
          status: {
            400: validationSchemas.errorBadRequest,
            401: validationSchemas.errorUnauthorized,
            500: validationSchemas.errorInternalServerError
          }
        }
      },
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
