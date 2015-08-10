(function() {
  var Hoek, i18n, routesToExpose;

  Hoek = require('hoek');

  i18n = require('./i18n');

  routesToExpose = [require('./routes-sessions-post'), require('./routes-sessions-me-delete')];


  /*
  options:
    clientId: 'some mongodb guid'
    _tenantId: 'some mongodb guid'
    baseUrl: This is the url to your api. For example https://api.mystuff.com
  ``realm: ignore for now
    scope: leave to null
   */

  module.exports.register = function(server, options, cb) {
    var defaults, i, len, r;
    if (options == null) {
      options = {};
    }
    defaults = {
      realm: "default",
      routeTagsPublic: ['api', 'api-public', 'session'],
      routeTagsAdmin: ['api', 'api-admin', 'session']
    };
    options = Hoek.applyToDefaults(defaults, options);
    for (i = 0, len = routesToExpose.length; i < len; i++) {
      r = routesToExpose[i];
      r(server, options);
    }
    server.expose('i18n', i18n);
    return cb();
  };

  module.exports.register.attributes = {
    pkg: require('../package.json')
  };

}).call(this);

//# sourceMappingURL=index.js.map
