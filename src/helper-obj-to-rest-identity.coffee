_ = require 'underscore'

module.exports =  (identity,baseUrl) ->
    return null unless identity
    res =
      url : "#{baseUrl}/#{identity._id}"
      id : identity._id
      provider : identity.provider
      key : identity.key
      v1 : identity.v1
      v2 : identity.v2
      providerType : identity.providerType
      username : identity.username
      displayName : identity.displayName
      profileImage : identity.profileImage
    res