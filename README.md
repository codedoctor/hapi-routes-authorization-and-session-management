(C) 2014 Martin Wawrusch

DO NOT USE YET

Exposes routes to aquire and destroy sessions for APIs

Dependencies:

* Requires HAPI >= 6.0.0 and hapi-identity-store

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


