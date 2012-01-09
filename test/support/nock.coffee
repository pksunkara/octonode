# Requiring modules
nock = require 'nock'

# Mocking normal api
viewNock = nock('https://api.github.com')
authNock = nock('https://api.github.com').filteringPath /\?access_token=*/g, '?access_token=someaccesstoken'

# Mocking api with body
viewBodyNock = viewNock.matchHeader 'Content-Type', 'application/json'
authBodyNock = authNock.matchHeader 'Content-Type', 'application/json'

# Module exports
module.exports =

  # Common function
  body: (path, body, code, data, headers, fn) ->
    fn(path, JSON.stringify(body)).reply code, JSON.stringify(data), headers

  # Oauth authorization
  oauth: () ->

  # Basic authorization
  basic: () ->

  # Public API
  viewGet: (path, code, data, headers = {}) ->
    viewNock.get(path).reply code, JSON.stringify(data), headers

  viewPost: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, viewBodyNock.post

  viewPut: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, viewBodyNock.put

  viewDel: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, viewBodyNock.delete

  # Private API
  authGet: (path, code, data, headers) ->
    authNock.get(path).reply code, JSON.stringify(data), headers

  authPost: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, authBodyNock.post

  authPut: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, authBodyNock.put

  authDel: (path, body={}, code, data, headers) ->
    @body path, body, code, data, headers, authBodyNock.delete
