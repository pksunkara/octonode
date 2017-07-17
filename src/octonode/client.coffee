#
# client.coffee: A client for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'
rp = require 'request-promise-native'
url = require 'url'

Me           = require './me'
User         = require './user'
Repo         = require './repo'
Org          = require './org'
Gist         = require './gist'
Team         = require './team'
Pr           = require './pr'
Release      = require './release'
Issue        = require './issue'
Milestone    = require './milestone'
Label        = require './label'
Notification = require './notification'
extend       = require 'deep-extend'

Search = require './search'

# Specialized error
class HttpError extends Error
  constructor: (@message, @statusCode, @headers, @body) ->

# Initiate class
class Client

  constructor: (@token, @options) ->
    @request = @options and @options.request or request
    @rp = @options and @options.rp or rp
    @requestDefaults =
      headers:
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'

    if @token and typeof @token == 'string'
      @requestDefaults.headers.Authorization = "token " + @token

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

  release: (repo, number) ->
    new Release repo, number, @

  # Get search instance for client
  search: ->
    new Search @

  issue: (repo, number) ->
    new Issue repo, number, @

  project: (repo, number) ->
    new Project repo, number, @

  milestone: (repo, number) ->
    new Milestone repo, number, @

  label: (repo, name) ->
    new Label repo, name, @

  notification: (id) ->
    new Notification id, @

  requestOptions: (params1, params2) =>
    return extend @requestDefaults, params1, params2

  # Github api URL builder
  buildUrl: (path = '/', pageOrQuery = null, per_page = null, since = null) ->
    if pageOrQuery? and typeof pageOrQuery == 'object'
      query = pageOrQuery
    else
      query = {}
      if pageOrQuery?
        if since? and since == true
          query.since = pageOrQuery
        else
          query.page = pageOrQuery
      query.per_page = per_page if per_page?
    if @token and typeof @token == 'object' and @token.id
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

    urlFromPath = url.parse path

    _url = url.format
      protocol: urlFromPath.protocol or @options and @options.protocol or "https:"
      auth: urlFromPath.auth or if @token and @token.username and @token.password then "#{@token.username}:#{@token.password}" else ''
      hostname: urlFromPath.hostname or @options and @options.hostname or "api.github.com"
      port: urlFromPath.port or @options and @options.port
      pathname: urlFromPath.pathname
      query: query

    if q
      _url += "#{separator}q=#{q}"
      query.q = q

    return _url

  errorHandle: (res, body, callback) ->
    return callback(new HttpError('Error ' + res.statusCode, res.statusCode, res.headers)) if Math.floor(res.statusCode/100) is 5

    if typeof body == 'string'
      try
        body = JSON.parse(body || '{}')
      catch err
        return callback(err)
    debugger
    return callback(new HttpError(body.message, res.statusCode, res.headers, body)) if body.message and res.statusCode in [400, 401, 403, 404, 410, 422]
    callback null, res.statusCode, body, res.headers

  errorHandlePromise: (response, cb) ->
    debugger
    {statusCode, body, headers} = response

    fiveError = new HttpError('Error ' + statusCode, statusCode, headers)
    fourError = new HttpError(body.message, statusCode, headers, body)

    return cb(fiveError) if Math.floor(statusCode/100) is 5
    return cb(fourError) if body.message and Math.floor(statusCode/100) is 4

    return cb(null, statusCode, body, headers)

  # Github api GET request

  get: (path, params..., cb) =>

    cb = if cb then cb else () -> arguments

    options = @requestOptions(
      uri: @buildUrl path, params...
      method: 'GET'
      followRedirect: true
      json: true
      simple: false
      resolveWithFullResponse: true
    )

    return @rp options
      .then((response) => @errorHandlePromise(response, cb))
      .catch((err) -> cb(err))

  # original get with callback
  # get: (path, params..., callback) ->
  #   @request @requestOptions(
  #     uri: @buildUrl path, params...
  #     method: 'GET'
  #   ), (err, res, body) =>
  #     return callback(err) if err
  #     @errorHandle res, body, callback

  getNoFollow: (path, params..., cb) =>

    cb = if cb then cb else () -> arguments

    options = @requestOptions(
      uri: @buildUrl path, params...
      method: 'GET'
      followRedirect: false
      json: true
      simple: false
      resolveWithFullResponse: true
    )

    return @rp options
      .then((response) => @errorHandlePromise(response, cb))
      .catch((err) -> cb(err))
  # Github api GET request no redirect follow
  # getNoFollow: (path, params..., callback) ->
  #
  #   @request @requestOptions(
  #     uri: @buildUrl path, params...
  #     method: 'GET'
  #     followRedirect: false
  #   ), (err, res, body) =>
  #     return callback(err) if err
  #     @errorHandle res, body, callback

  getOptions: (path, options, params..., cb) ->

    if typeof options != 'object'
      console.log('options arg must be an object, if no options use .get')
      return

    cb = if cb then cb else () -> arguments

    options = @requestOptions({
      uri: @buildUrl path, params...
      method: 'GET'
      followRedirect: false
      json: true
      simple: false
      resolveWithFullResponse: true
    }, options)

    return @rp options
      .then((response) => @errorHandlePromise(response, cb))
      .catch((err) -> cb(err))

  # Github api GET request with specified options
  # getOptions: (path, options, params..., callback) ->
  #   @request @requestOptions({
  #     uri: @buildUrl path, params...
  #     method: 'GET'
  #   }, options), (err, res, body) =>
  #     return callback(err) if err
  #     @errorHandle res, body, callback

  # Github api POST request
  post: (path, content, options, callback) ->
    if !callback? and typeof options is 'function'
      callback = options
      options = {}

    reqDefaultOption =
      uri: @buildUrl path, options.query
      method: 'POST'
      headers:
        'Content-Type': 'application/json'

    if content
      reqDefaultOption.body = JSON.stringify content

    reqOpt = @requestOptions extend reqDefaultOption, options
    @request reqOpt, (err, res, body) =>
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
  put: (path, content, options, callback) ->
    if !callback and options
      callback = options
      options =
        'Content-Type': 'application/json'
    @request @requestOptions(
      uri: @buildUrl path
      method: 'PUT'
      body: JSON.stringify content
      headers: options
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
      if s isnt 200 then callback(new HttpError('Client rate_limit error', s))
      else callback null, b.resources.core.remaining, b.resources.core.limit, b.resources.core.reset, b

# Export modules
module.exports = (token, credentials...) ->
  new Client(token, credentials...)
