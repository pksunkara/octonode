#
# me.coffee: Github authenticated user class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Initiate class
class Me

  constructor: (@client) ->

  profile: (data) ->
    Object.keys(data).forEach (e) =>
      @[e] = data[e]

  # Get a user
  # '/user' GET
  info: (cb) ->
    @client.get '/user', null, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User info error')) else cb null, b

  # Update user
  # '/user' PATCH
  update: (info, cb) ->
    @client.post '/user', null, info, (err, s, b)  ->
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
      cb = cbOrEmails
      @client.get '/user/emails', null, (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User emails error')) else cb null, b

  # Set emails of the user
  # '/user/emails' POST
  setEmails: (emails, cb) ->
    @client.post '/user/emails', null, emails, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User setEmails error')) else cb null, b

  # Delete emails of the user
  # '/user/emails' DELETE
  deleteEmails: (emails) ->
    @client.del '/user/emails', null, emails, (err, s, b)  =>
      @deleteEmails(emails) if err? or s isnt 204

  # Get the followers of the user
  # '/user/followers' GET
  # TODO: page, user
  followers: (cb) ->
    @client.get '/user/followers', null, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User followers error')) else cb null, b

  # Get the followings of the user
  # '/user/following' GET
  # TODO: page, user
  following: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @checkFollowing cbOrUser, cb
    else
      cb = cbOrUser
      @client.get '/user/following', null, (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User following error')) else cb null, b

  # Check if you are following a user
  # '/user/following/pksunkara' GET
  checkFollowing: (user, cb) ->
    @client.get "/user/following/#{user}", null, (err, s, b)  ->
      return cb(err) if err
      cb null, s is 204

  # Follow a user
  # '/user/following/pksunkara' PUT
  follow: (user) ->
    @client.put "/user/following/#{user}", null, {}, (err, s, b)  =>
      @follow(user) if err? or s isnt 204

  # Unfollow a user
  # '/user/following/pksunkara' DELETE
  unfollow: (user) ->
    @client.del "/user/following/#{user}", null, {}, (err, s, b)  =>
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
      cb = cbOrIdOrKey
      @client.get '/user/keys', null, (err, s, b)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User keys error')) else cb null, b

  # Get a single public key
  # '/user/keys/1' GET
  getKey: (id, cb) ->
    @client.get "/user/keys/#{id}", null, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User getKey error')) else cb null, b

  # Create a public key
  # '/user/keys' POST
  createKey: (key, cb) ->
    @client.post '/user/keys', null, key, (err, s, b)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createKey error')) else cb null, b

  # Update a public key
  # '/user/keys/1' PATCH
  updateKey: (id, key, cb) ->
    @client.post "/user/keys/#{id}", null, key, (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User updateKey error')) else cb null, b

  # Delete a public key
  # '/user/keys/1' DELETE
  deleteKey: (id) ->
    @client.del "/user/keys/#{id}", null, {}, (err, s, b)  =>
      @deleteKey(id) if err? or s isnt 204

  # Get organization instance for client
  org: (name) ->
    @client.org name

  # List your public and private organizations
  # '/user/orgs' GET
  orgs: (cb) ->
    @client.get "/user/orgs", null, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User orgs error')) else cb null, b

  # Get repository instance for client
  repo: (name) ->
    @client.repo name

  # List your repositories
  # '/user/repos' GET
  repos: (cbOrRepo, cb) ->
    if typeof cb is 'function' and typeof cbOrRepo is 'object'
      @createRepo cbOrRepo, cb
    else
      cb = cbOrRepo
      @client.get "/user/repos", null, (err, s, b) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User repos error')) else cb null, b

  # Create a repository
  # '/user/repos' POST
  createRepo: (repo, cb) ->
    @client.post "/user/repos", null, repo, (err, s, b)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createRepo error')) else cb null, b

  # Fork a repo
  # '/repos/pksunkara/hub/forks' POST
  fork: (repo, cb) ->
    @client.post "/repos/#{repo}/forks", null, {}, (err, s, b) ->
      return cb(err) if err
      if s isnt 202 then cb(new Error('User fork error')) else cb null, b

  # Get pull-request instance for client
  pr: (repo, number) ->
    @client.pr repo, number

# Export module
module.exports = Me
