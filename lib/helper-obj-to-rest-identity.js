(function() {
  var _;

  _ = require('underscore');

  module.exports = function(identity, baseUrl) {
    var res;
    if (!identity) {
      return null;
    }
    res = {
      url: baseUrl + "/" + identity._id,
      id: identity._id,
      provider: identity.provider,
      key: identity.key,
      v1: identity.v1,
      v2: identity.v2,
      providerType: identity.providerType,
      username: identity.username,
      displayName: identity.displayName,
      profileImage: identity.profileImage
    };
    return res;
  };

}).call(this);

//# sourceMappingURL=helper-obj-to-rest-identity.js.map
