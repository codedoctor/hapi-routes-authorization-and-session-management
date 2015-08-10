(function() {
  var Boom, _, helperObjToRestUser;

  _ = require('underscore');

  Boom = require('boom');

  helperObjToRestUser = require('./helper-obj-to-rest-user');

  module.exports = function(oauthAuth, baseUrl, _tenantId, userId, clientId, realm, scope, user, cb) {
    if (clientId) {
      return oauthAuth.createOrReuseTokenForUserId(_tenantId, userId, clientId, realm, scope, null, function(err, token) {
        if (err) {
          return cb(err);
        }
        if (!token) {
          return cb(new Boom.badRequest(baseUrl + "/users"));
        }
        user = helperObjToRestUser(user, baseUrl + "/users");
        _.extend(user, {
          token: {
            accessToken: token.accessToken,
            refreshToken: token.refreshToken
          }
        });
        return cb(null, user);
      });
    } else {
      return cb(null, helperObjToRestUser(user, baseUrl + "/users"));
    }
  };

}).call(this);

//# sourceMappingURL=helper-add-token-to-user.js.map
