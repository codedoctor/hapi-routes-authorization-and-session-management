Joi = require "joi"

minLoginLength = 2
maxLoginLength = 100
minPasswordLength = 8
maxPasswordLength = 40

validateId = Joi.string().length(24)

module.exports =
  validateId: validateId

  password:         Joi.string().min(minPasswordLength).max(maxPasswordLength).example('some password')
  login:            Joi.string().min(minLoginLength).max(maxLoginLength).example('johnsmith')
  clientIdRequired: Joi.string().required().description("The API client id that you received for your oauth app.").example('1234567890abcdef')


  errorBadRequest: Joi.object(
                  statusCode: Joi.number().description("The http status code.").required().default(400).example(400).integer()
                  error: Joi.string().description("The short error name.").required().default("Bad Request").example('Bad Request')
                  message: Joi.string().description("The detailed error message.").required()
                ).description("The passed parameters probably failed some validation.").meta(className: 'ErrorBadRequest').required().options({allowUnknown: true,stripUnknown: false})

  errorUnauthorized: Joi.object(
                  statusCode: Joi.number().description("The http status code.").required().default(401).example(401).integer()
                  error: Joi.string().description("The short error name.").required().default("Unauthorized").example('Unauthorized')
                  message: Joi.string().description("The detailed error message.").required()
                ).description("You are not authorized to access this resource.").meta(className: 'ErrorUnauthorized').required().options({allowUnknown: true,stripUnknown: false})

 
  errorUnprocessableEntity: Joi.object(
                  statusCode: Joi.number().description("The http status code.").required().default(422).example(422).integer()
                  error: Joi.string().description("The short error name.").required().default("Unprocessable Entity").example('Unprocessable Entity')
                  message: Joi.string().description("The detailed error message.").required()
                ).description("The requested resource could not be processed.").meta(className: 'ErrorUnprocessableEntity').required().options({allowUnknown: true,stripUnknown: false})

  errorInternalServerError: Joi.object(
                  statusCode: Joi.number().description("The http status code.").required().default(500).example(500).integer()
                  error: Joi.string().description("The short error name.").required().default("Internal Server Error").example("Internal Server Error")
                  message: Joi.string().description("The detailed error message.").required()
                ).description("An internal server error occurred.").meta(className: 'ErrorInternalServerError').required().options({allowUnknown: true,stripUnknown: false})

  responseDelete: Joi.any().valid(null).description("Null response for DELETE requests.")

  refreshTokenRequired:         Joi.string().required().description("The required refresh token. Not supported in the API yet.").example("lsdfdikwmmsxjewjdjkkekkeee")
  accessTokenRequired:          Joi.string().required().description("The required access token that can be used to access envy api services. Store this in the client and pass it with every request.").example("sduejjfcsuu33ed")
  usernameRequired:             Joi.string().required().description("The username of this user.").example("janedoe")
  userIdRequired:               Joi.string().required().description("The required userId.")
  primaryEmailOptional:         Joi.string().email().allow(null).empty("").optional().description("The users primary email address.").example("jane@doe.com")


