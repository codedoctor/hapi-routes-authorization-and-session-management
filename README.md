[![Build Status](https://travis-ci.org/codedoctor/hapi-routes-authorization-and-session-management.svg?branch=master)](https://travis-ci.org/codedoctor/hapi-routes-authorization-and-session-management)
[![Coverage Status](https://img.shields.io/coveralls/codedoctor/hapi-routes-authorization-and-session-management.svg)](https://coveralls.io/r/codedoctor/hapi-routes-authorization-and-session-management)
[![NPM Version](http://img.shields.io/npm/v/hapi-routes-authorization-and-session-management.svg)](https://www.npmjs.org/package/hapi-routes-authorization-and-session-management)
[![Dependency Status](https://gemnasium.com/codedoctor/hapi-routes-authorization-and-session-management.svg)](https://gemnasium.com/codedoctor/hapi-routes-authorization-and-session-management)
[![NPM Downloads](http://img.shields.io/npm/dm/hapi-routes-authorization-and-session-management.svg)](https://www.npmjs.org/package/hapi-routes-authorization-and-session-management)
[![Issues](http://img.shields.io/github/issues/codedoctor/hapi-routes-authorization-and-session-management.svg)](https://github.com/codedoctor/hapi-routes-authorization-and-session-management/issues)
[![HAPI 8.0](http://img.shields.io/badge/hapi-8.0-blue.svg)](http://hapijs.com)
[![API Documentation](http://img.shields.io/badge/API-Documentation-ff69b4.svg)](http://coffeedoc.info/github/codedoctor/hapi-routes-authorization-and-session-management)



(C) 2014 Martin Wawrusch

Exposes routes to aquire and destroy sessions for APIs

Dependencies:

* Requires HAPI >= 10.0.0 and hapi-oauth-store-multi-tenant

Routes exposed

POST /sessions

returns 
```json
{  
   "url":"http://localhost:5675/users/53dc1187ee1768a162ea4060",
   "id":"53dc1187ee1768a162ea4060",
   "username":"user1",
   "description":"",
   "identities":[  

   ],
   "profileLinks":[  

   ],
   "userImages":[  

   ],
   "emails":[  
      "user1@user.com"
   ],
   "roles":[  

   ],
   "data":{  

   },
   "stats":{  

   },
   "resourceLimits":[  

   ],
   "createdAt":"2014-08-01T22:15:35.518Z",
   "updatedAt":"2014-08-01T22:15:35.518Z",
   "isDeleted":false,
   "deletedAt":null,
   "onboardingState":null,
   "primaryEmail":"user1@user.com",
   "needsInit":false,
   "gender":"",
   "timezone":0,
   "locale":"en_us",
   "verified":false,
   "token":{  
      "accessToken":"53dc1187ee1768a162ea4061",
      "refreshToken":"TPCID3RwjdPMDt8rwcCMIRvyCVSz00FdkiBUrkwVc3IIIU8TWTBsyjfQjgtagW6HgivNfLcvnkZQobmb"
   }
}
```

on success with 201, otherwise 422


DELETE /sessions/me
expects a token (24 char hex string, mongodb uid) in the credentials, deletes the session if exists, returns 204 on success

## Change Log

3.0.0
* Most of the API is now fully validated, although the individual validation needs more fine tuning.
* BREAKING: Posting to create a session now requires a clientId, the options parameter is now ignored.


## See also

* [hapi-auth-bearer-mw](https://github.com/codedoctor/hapi-auth-bearer-mw)
* [hapi-loggly](https://github.com/codedoctor/hapi-loggly)
* [hapi-mandrill](https://github.com/codedoctor/hapi-mandrill)
* [hapi-mongoose-db-connector](https://github.com/codedoctor/hapi-mongoose-db-connector)
* [hapi-oauth-store-multi-tenant](https://github.com/codedoctor/hapi-oauth-store-multi-tenant)
* [hapi-routes-authorization-and-session-management](https://github.com/codedoctor/hapi-routes-authorization-and-session-management)
* [hapi-routes-oauth-management](https://github.com/codedoctor/hapi-routes-oauth-management)
* [hapi-routes-roles](https://github.com/codedoctor/hapi-routes-roles)
* [hapi-routes-status](https://github.com/codedoctor/hapi-routes-status)
* [hapi-routes-users-authorizations](https://github.com/codedoctor/hapi-routes-users-authorizations)
* [hapi-routes-users](https://github.com/codedoctor/hapi-routes-users)
* [hapi-user-store-multi-tenant](https://github.com/codedoctor/hapi-user-store-multi-tenant)

and additionally

* [api-pagination](https://github.com/codedoctor/api-pagination)
* [mongoose-oauth-store-multi-tenant](https://github.com/codedoctor/mongoose-oauth-store-multi-tenant)
* [mongoose-rest-helper](https://github.com/codedoctor/mongoose-rest-helper)
* [mongoose-user-store-multi-tenant](https://github.com/codedoctor/mongoose-user-store-multi-tenant)

## Contributing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Martin Wawrusch 
