(function() {
  var Hoek, i18n, routesSessionsMeDelete, routesSessionsPost;

  Hoek = require('hoek');

  i18n = require('./i18n');

  routesSessionsPost = require('./routes-sessions-post');

  routesSessionsMeDelete = require('./routes-sessions-me-delete');


  /*
  options:
    clientId: 'some mongodb guid'
    _tenantId: 'some mongodb guid'
    baseUrl: This is the url to your api. For example https://api.mystuff.com
  ``realm: ignore for now
    scope: leave to null
   */

  module.exports.register = function(server, options, cb) {
    var defaults;
    if (options == null) {
      options = {};
    }
    defaults = {
      realm: "default"
    };
    options = Hoek.applyToDefaults(defaults, options);
    routesSessionsPost(server, options);
    routesSessionsMeDelete(server, options);
    server.expose('i18n', i18n);
    return cb();
  };

  module.exports.register.attributes = {
    pkg: require('../package.json')
  };

}).call(this);

//# sourceMappingURL=index.js.map
