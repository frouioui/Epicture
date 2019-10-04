# API Imgur

## Client ID

*3aab9940d90a6ac*

## Client Secret

*c2608ee588ab2aaae163fd780c679211edf184a9*

<!-- ## Call the API

For each request to the API put this in the header of the request
> Authorization: 3aab9940d90a6ac c2608ee588ab2aaae163fd780c679211edf184a9 -->

_____

## OAuth2

### **First step - Authorization**

In order to log into imgur you need to make a first call to *https://api.imgur.com/oauth2/authorize?client_id=3aab9940d90a6ac&response_type=token&state=test* in order to authorize our app to use imgur API.

The expected response is : *http://our/web/url?state=test#access_token=ACCESS_TOKEN&expires_in=SECONDS&token_type=bearer&refresh_token=REFRESH_TOKEN&account_username=NAME_ACCOUNT&account_id=ID_ACCOUNT*

Here is a full example of response : https://imgur.com/?state=test#access_token=1bc9d951f4b68fd3e7e8d50633467fc045f1eae1&expires_in=315360000&token_type=bearer&refresh_token=d152b7894fd0e4817b2892fefebca4274639effe&account_username=frouioui&account_id=114888747

We need to have an endpoint (a route / URL) accepting those parameters (state, access_token, expires_in, ...). Those information will be esential in order to get the user's data. We need to store them for each session.

### **Second step - Refreshing tokens (making sure the user is logged in)**

In order to refresh a token make a **POST** call to this URL : *https://api.imgur.com/oauth2/token*.

The request must include : 

refresh_token -> The refresh token stored from the first step

client_id -> *3aab9940d90a6ac*

client_secret -> *c2608ee588ab2aaae163fd780c679211edf184a9*

grant_type -> *refresh_token*

____

## Manage favorite pictures

### **Get all favorite pictures**

Header of the request :

> Bearer {{access token found during authorization}}

URL to call : *https://api.imgur.com/3/account/{{username}}/favorites/{{page}}/{{favoritesSort}}*

{{page}} : Nb of the page to return, if there are a lot of favorite the API wont return them all at once, you need to make multiple call in order to have all the favorites.

{{favoriteSort}} : Is the way to order the results you have the choice between *"oldest"* and *"newest"*.

Those two parameters are optional.
