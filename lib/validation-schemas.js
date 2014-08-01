(function() {
  var Joi, maxLoginLength, maxPasswordLength, minLoginLength, minPasswordLength, validateId, validatePassword;

  Joi = require("joi");

  minLoginLength = 2;

  maxLoginLength = 100;

  minPasswordLength = 8;

  maxPasswordLength = 40;

  validatePassword = Joi.string().min(minPasswordLength).max(maxPasswordLength).example('some password');

  validateId = Joi.string().length(24);

  module.exports = {
    validateId: validateId,
    validatePassword: validatePassword,

    /*
    Posting a new session.
     */
    schemaSessionsPost: Joi.object().keys({
      login: Joi.string().min(minLoginLength).max(maxLoginLength).required().example('johnsmith').description('The login field can either be an email address or a username.'),
      password: validatePassword.required().description('The password used to authenticate this session.')
    }).options({
      allowUnkown: true,
      stripUnknown: true
    })
  };

}).call(this);

//# sourceMappingURL=validation-schemas.js.map
