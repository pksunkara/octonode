#
# client.coffee: A client for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'
url = require 'url'

Me        = require './me'
User      = require './user'
Repo      = require './repo'
Org       = require './org'
Gist      = require './gist'
Team      = require './team'
Pr        = require './pr'
Issue     = require './issue'
Milestone = require './milestone'
Label     = require './label'
extend    = require 'deep-extend'

Search = require './search'

# Specialized error
class HttpError extends Error
  constructor: (@message, @statusCode, @headers) ->

# Initiate class
class Client

  constructor: (@token, @options) ->
    @request = @options and @options.request or request
    @requestDefaults =
      headers:
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'

  # Get authenticated user instance for client
  me: ->
    new Me @

  # Get user instance for client
  user: (name) ->
    new User name, @

  # Get repository instance for client
  repo: (name) ->
    new Repo name, @

  # Get organization instance for client
  org: (name) ->
    new Org name, @

  # Get gist instance for client
  gist: ->
    new Gist @

  # Get team instance for client
  team: (id) ->
    new Team id, @

  # Get pull request instance for client
  pr: (repo, number) ->
    new Pr repo, number, @

  # Get search instance for client
  search: ->
    new Search @

  issue: (repo, number) ->
    new Issue repo, number, @

  milestone: (repo, number) ->
    new Milestone repo, number, @

  label: (repo, name) ->
    new Label repo, name, @

  requestOptions: (params1, params2) =>
    return extend @requestDefaults, params1, params2

  # Github api URL builder
  buildUrl: (path = '/', pageOrQuery = null, per_page = null) ->
    if pageOrQuery? and typeof pageOrQuery == 'object'
      query = pageOrQuery
    else
      query = {}
      query.page     = pageOrQuery if pageOrQuery?
      query.per_page = per_page if per_page?
    if @token
      if typeof @token == 'string'
        query.access_token = @token
      else if typeof @token == 'object' and @token.id
        query.client_id = @token.id
        query.client_secret = @token.secret

    # https://github.com/pksunkara/octonode/issues/87
    if query.q
      q = query.q
      delete query.q
      if Object.keys(query).length
        separator = '&'
      else
        separator = '?'

    _url = url.format
      protocol: @options and @options.protocol or "https:"
      auth: if @token and @token.username and @token.password then "#{@token.username}:#{@token.password}" else ''
      hostname: @options and @options.hostname or "api.github.com"
      port: @options and @options.port
      pathname: path
      query: query

    if q
      _url += "#{separator}q=#{q}"
      query.q = q

    return _url

  errorHandle: (res, body, callback) ->
    # TODO: More detailed HTTP error message
    return callback(new HttpError('Error ' + res.statusCode, res.statusCode, res.headers)) if Math.floor(res.statusCode/100) is 5
    if typeof body == 'string'
      try
        body = JSON.parse(body || '{}')
      catch err
        return callback(err)
    return callback(new HttpError(body.message, res.statusCode, res.headers)) if body.message and res.statusCode in [400, 401, 403, 404, 410, 422]
    callback null, res.statusCode, body, res.headers

  # Github api GET request
  get: (path, params..., callback) ->
    @request @requestOptions(
      uri: @buildUrl path, params...
      method: 'GET'
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api GET request
  getNoFollow: (path, params..., callback) ->
    @request @requestOptions(
      uri: @buildUrl path, params...
      method: 'GET'
      followRedirect: false
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api GET request
  getOptions: (path, options, params..., callback) ->
    @request @requestOptions({
      uri: @buildUrl path, params...
      method: 'GET'
    }, options), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api POST request
  post: (path, content, callback) ->
    @request @requestOptions(
      uri: @buildUrl path
      method: 'POST'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api PATCH request
  patch: (path, content, callback) ->
    @request @requestOptions(
      uri: @buildUrl path
      method: 'PATCH'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api PUT request
  put: (path, content, callback) ->
    @request @requestOptions(
      uri: @buildUrl path
      method: 'PUT'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api DELETE request
  del: (path, content, callback) ->
    @request @requestOptions(
      uri: @buildUrl path
      method: 'DELETE'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
    ), (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  limit: (callback) =>
    @get '/rate_limit', (err, s, b) ->
      return callback(err) if err
      if s isnt 200 then callback(new HttpError('Client rate_limit error', s)) else callback null, b.rate.remaining, b.rate.limit, b

# Export modules
module.exports = (token, credentials...) ->
  new Client(token, credentials...)
