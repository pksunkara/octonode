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
    @client.get '/user', (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User info error')) else cb null, b, h

  # Update user
  # '/user' PATCH
  update: (info, cb) ->
    @client.post '/user', info, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User update error')) else cb null, b, h

  # Get emails of the user
  # '/user/emails' GET
  emails: (cbOrEmails, cb) ->
    if cb? and typeof cbOrEmails isnt 'function'
      @setEmails cbOrEmails, cb
    else if !cb? and typeof cbOrEmails isnt 'function'
      @deleteEmails cbOrEmails
    else
      cb = cbOrEmails
      @client.get '/user/emails', (err, s, b, h)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User emails error')) else cb null, b, h

  emailsDetailed: (cb) ->
    @client.getOptions '/user/emails', { headers: { Accept: 'application/vnd.github.v3.full+json'} },(err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User emails error')) else cb null, b, h

  # Set emails of the user
  # '/user/emails' POST
  setEmails: (emails, cb) ->
    @client.post '/user/emails', emails, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User setEmails error')) else cb null, b, h

  # Delete emails of the user
  # '/user/emails' DELETE
  deleteEmails: (emails) ->
    @client.del '/user/emails', emails, (err, s, b, h)  =>
      @deleteEmails(emails) if err? or s isnt 204

  # Get the followers of the user
  # '/user/followers' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  followers: (params..., cb) ->
    @client.get '/user/followers', params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User followers error')) else cb null, b, h

  # Get the followings of the user
  # '/user/following' GET
  # TODO: page, user
  following: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @checkFollowing cbOrUser, cb
    else
      cb = cbOrUser
      @client.get '/user/following', (err, s, b, h)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User following error')) else cb null, b, h

  # Check if you are following a user
  # '/user/following/pksunkara' GET
  checkFollowing: (user, cb) ->
    @client.get "/user/following/#{user}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h

  # Follow a user
  # '/user/following/pksunkara' PUT
  follow: (user) ->
    @client.put "/user/following/#{user}", {}, (err, s, b, h)  =>
      @follow(user) if err? or s isnt 204

  # Unfollow a user
  # '/user/following/pksunkara' DELETE
  unfollow: (user) ->
    @client.del "/user/following/#{user}", {}, (err, s, b, h)  =>
      @unfollow(user) if err? or s isnt 204

  # Get the starred repos for the user
  # '/user/starred' GET
  # TODO: page, user
  starred: (cbOrRepo, cb) ->
    if cb? and typeof cbOrRepo isnt 'function'
      @checkStarred cbOrRepo, cb
    else
      cb = cbOrRepo
      @client.get '/user/starred', (err, s, b, h)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User starred error')) else cb null, b, h

  # Check if you have starred a repository
  # '/user/starred/pksunkara/octonode' GET
  checkStarred: (repo, cb) ->
    @client.get "/user/starred/#{repo}", (err, s, b, h)  ->
      return cb(err) if err
      cb null, s is 204, h

  # Star a repository
  # '/user/starred/pksunkara/octonode' PUT
  star: (repo) ->
    @client.put "/user/starred/#{repo}", {}, (err, s, b, h)  =>
      @star(repo) if err? or s isnt 204

  # Unstar a repository
  # '/user/starred/pksunkara/octonode' DELETE
  unstar: (repo) ->
    @client.del "/user/starred/#{repo}", {}, (err, s, b, h)  =>
      @unstar(repo) if err? or s isnt 204

  # Get the subscriptions of the user (what she watches)
  # '/user/subscriptions' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  watched: (params..., cb) ->
    @client.get '/user/subscriptions', params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User subscription error')) else cb null, b, h

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
      @client.get '/user/keys', (err, s, b, h)  ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('User keys error')) else cb null, b, h

  # Get a single public key
  # '/user/keys/1' GET
  getKey: (id, cb) ->
    @client.get "/user/keys/#{id}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User getKey error')) else cb null, b, h

  # Create a public key
  # '/user/keys' POST
  createKey: (key, cb) ->
    @client.post '/user/keys', key, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createKey error')) else cb null, b, h

  # Update a public key
  # '/user/keys/1' PATCH
  updateKey: (id, key, cb) ->
    @client.post "/user/keys/#{id}", key, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User updateKey error')) else cb null, b, h

  # Delete a public key
  # '/user/keys/1' DELETE
  deleteKey: (id) ->
    @client.del "/user/keys/#{id}", {}, (err, s, b, h)  =>
      @deleteKey(id) if err? or s isnt 204

  # Get organization instance for client
  org: (name) ->
    @client.org name

  # List your public and private organizations
  # '/user/orgs' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  orgs: (params..., cb) ->
    @client.get "/user/orgs", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User orgs error')) else cb null, b, h

  # Get repository instance for client
  repo: (nameOrRepo, cb) ->
    if typeof cb is 'function' and typeof nameOrRepo is 'object'
      @createRepo nameOrRepo, cb
    else
      @client.repo nameOrRepo

  # List your repositories
  # '/user/repos' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  repos: (params..., cb) ->
    @client.get "/user/repos", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('User repos error')) else cb null, b, h

  # Create a repository
  # '/user/repos' POST
  createRepo: (repo, cb) ->
    @client.post "/user/repos", repo, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('User createRepo error')) else cb null, b, h

  # Fork a repo
  # '/repos/pksunkara/hub/forks' POST
  fork: (repo, cb) ->
    @client.post "/repos/#{repo}/forks", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 202 then cb(new Error('User fork error')) else cb null, b, h

  # Get pull-request instance for client
  pr: (repo, number) ->
    @client.pr repo, number

# Export module
module.exports = Me
