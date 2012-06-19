#
# me.coffee: Github authenticated user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
User = require './user'
Org = require './org'

# Initiate class
class Me

  constructor: (@client) ->

  profile: (data) ->
    Object.keys(data).forEach (e) =>
      @[e] = data[e]

  # Get a user
  # '/user' GET
  info: (cb) ->
    @client.get '/user', (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User info error')) else cb null, b

  # Update user
  # '/user' PATCH
  update: (info, cb) ->
    @client.post '/user', info, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User update error')) else cb null, b

  # Get emails of the user
  # '/user/emails' GET
  emails: (cbOrEmails, cb) ->
    if cb? and typeof cbOrEmails isnt 'function'
      @setEmails cbOrEmails, cb
    else if !cb? and typeof cbOrEmails isnt 'function'
      @deleteEmails cbOrEmails
    else
      @client.get '/user/emails', (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User emails error')) else cb null, b

  # Set emails of the user
  # '/user/emails' POST
  setEmails: (emails, cb) ->
    @client.post '/user/emails', emails, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User setEmails error')) else cb null, b

  # Delete emails of the user
  # '/user/emails' DELETE
  deleteEmails: (emails) ->
    @client.del '/user/emails', emails, (err, s, b)  =>
      @deleteEmails(emails) if err? or s isnt 204

  # Get the followers of the user
  # '/user/followers' GET
  # TODO: page, user
  followers: (cb) ->
    @client.get '/user/followers', (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User followers error')) else cb null, b

  # Get the followings of the user
  # '/user/following' GET
  # TODO: page, user
  following: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @checkFollowing cbOrUser, cb
    else
      @client.get '/user/following', (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User following error')) else cb null, b

  # Check if you are following a user
  # '/user/following/pksunkara' GET
  checkFollowing: (user, cb) ->
    @client.get "/user/following/#{user}", (err, s, b)  ->
      return cb(err) if err
      cb null, s is 204

  # Follow a user
  # '/user/following/pksunkara' PUT
  follow: (user) ->
    @client.put "/user/following/#{user}", {}, (err, s, b)  =>
      @follow(user) if err? or s isnt 204

  # Unfollow a user
  # '/user/following/pksunkara' DELETE
  unfollow: (user) ->
    @client.del "/user/following/#{user}", {}, (err, s, b)  =>
      @unfollow(user) if err? or s isnt 204

  # Get public keys of a user
  # '/user/keys' GET
  keys: (cbOrIdOrKey, cbOrKey, cb) ->
    if !cb? and typeof cbOrIdOrKey is 'number' and typeof cbOrKey is 'function'
      @getKey cbOrIdOrKey, cbOrKey
    else if !cbOrKey? and !cb? and typeof cbOrIdOrKey is 'number'
      @deleteKey cbOrIdOrKey
    else if !cb? and typeof cbOrKey is 'function' and typeof cbOrIdOrKey is 'object'
      @createKey cbOrIdOrKey, cbOrKey
    else if typeof cb is 'function' and typeof cbOrIdOrKey is 'number' and typeof cbOrKey 'object'
      @updateKey cbOrIdOrKey, cbOrKey, cb
    else
      @client.get '/user/keys', (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User keys error')) else cb null, b

  # Get a single public key
  # '/user/keys/1' GET
  getKey: (id, cb) ->
    @client.get "/user/keys/#{id}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User getKey error')) else cb null, b

  # Create a public key
  # '/user/keys' POST
  createKey: (key, cb) ->
    @client.post '/user/keys', key, (err, s, b)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createKey error')) else cb null, b

  # Update a public key
  # '/user/keys/1' PATCH
  updateKey: (id, key, cb) ->
    @client.post "/user/keys/#{id}", key, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User updateKey error')) else cb null, b

  # Delete a public key
  # '/user/keys/1' DELETE
  deleteKey: (id) ->
    @client.del "/user/keys/#{id}", {}, (err, s, b)  =>
      @deleteKey(id) if err? or s isnt 204

  # Get an organisation
  org: (name) ->
    new Org name, @client

  # List your repositories
  # '/user/repos' GET
  repos: (cbOrRepo, cb) ->
    if typeof cb is 'function' and typeof cbOrRepo is 'object'
      @createRepo cbOrRepo, cb
    else
      @client.get "/user/repos", (err, s, b) ->
        return cbOrRepo(err) if err
        if s isnt 200 then cbOrRepo(new Error('User repos error')) else cbOrRepo null, b

  # Create a repository
  # '/user/repos' POST
  createRepo: (repo, cb) ->
    @client.post "/user/repos", repo, (err, s, b)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createRepo error')) else cb null, b

  # Fork a repo
  # '/repos/pksunkara/hub/forks' POST
  fork: (repo, cb) ->
    @client.post "/repos/#{repo}/forks", {}, (err, s, b) ->
      return cb(err) if err
      if s isnt 202 then cb(new Error('User fork error')) else cb null, b

# Export module
module.exports = Me
