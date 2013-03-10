#
# client.coffee: A client for github
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
request = require 'request'

Me   = require './me'
User = require './user'
Repo = require './repo'
Org  = require './org'
Gist = require './gist'
Team = require './team'
Pr   = require './pr'

Search = require './search'

# Initiate class
class Client

  constructor: (@token) ->

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

  # Github api URL builder
  query: (path = '/', page = null, per_page = null) ->
    path = '/' + path if path[0] isnt '/'
    uri = "https://"
    uri+= if typeof @token == 'object' and @token.username then "#{@token.username}:#{@token.password}@" else ''
    uri+= "api.github.com#{path}?"
    uri+= if typeof @token == 'string' then "access_token=#{@token}" else ''
    uri+= if typeof @token == 'object' and @token.id then "client_id=#{@token.id}&client_secret=#{@token.secret}" else ''
    uri+= "&page=#{page}" if page?
    uri+= "&per_page=#{per_page}" if per_page?
    uri

  errorHandle: (res, body, callback) ->
    # TODO: More detailed HTTP error message
    return callback(new Error('Error ' + res.statusCode)) if Math.floor(res.statusCode/100) is 5
    try
      body = JSON.parse(body || '{}')
    catch err
      return callback(err)
    return callback(new Error(body.message)) if body.message and res.statusCode is 422
    return callback(new Error(body.message)) if body.message and res.statusCode in [400, 401, 404]
    callback null, res.statusCode, body, res.headers

  # Github api GET request
  get: (path, params..., callback) ->
    request
      uri: @query path, params...
      method: 'GET'
      headers:
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api POST request
  post: (path, content, callback) ->
    request
      uri: @query path
      method: 'POST'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api PUT request
  put: (path, content, callback) ->
    request
      uri: @query path
      method: 'PUT'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  # Github api DELETE request
  del: (path, content, callback) ->
    request
      uri: @query path
      method: 'DELETE'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
        'User-Agent': 'octonode/0.3 (https://github.com/pksunkara/octonode) terminal/0.0'
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  limit: (callback) =>
    @get '/rate_limit', (err, s, b) ->
      return callback(err) if err
      if s isnt 200 then callback(new Error('Client rate_limit error')) else callback null, b.rate.remaining, b.rate.limit

# Export modules
module.exports = (token, credentials...) ->
  new Client(token, credentials...)
