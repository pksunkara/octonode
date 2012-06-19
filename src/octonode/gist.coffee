#
# gist.coffee: Github gist class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Gist

  constructor: (@client) ->

  # List authenticated user's gists
  # '/gists' GET
  list: (cb) ->
    @client.get "/gists", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist list error')) else cb null, b

  # List authenticated user's public gists
  # '/gists/public' GET
  public: (cb) ->
    @client.get "/gists/public", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist public error')) else cb null, b

  # List authenticated user's starred gists
  # '/gists/starred' GET
  starred: (cb) ->
    @client.get "/gists/starred", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist starred error')) else cb null, b

  # List a user's public gists
  # '/users/pksunkara/gists' GET
  user: (user, cb) ->
    @client.get "/users/#{user}/gists", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist user error')) else cb null, b

  # Get a single gist
  # '/gists/37' GET
  get: (id, cb) ->
    @client.get "/gists/#{id}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist get error')) else cb null, b

  # Create a gist
  # '/gists' POST
  create: (gist, cb) ->
    @client.post "/gists", gist, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Gist create error')) else cb null, b

  # Edit a gist
  # '/gists/37' PATCH
  edit: (id, gist, cb) ->
    @client.post "/gists/#{id}", gist, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist edit error')) else cb null, b

  # Delete a gist
  # '/gists/37' DELETE
  delete: (id) ->
    @client.del "/gists/#{id}", {}, (err, s, b) =>
      @delete(id) if err? or s isnt 204

  # Star a gist
  # '/gists/37/star' PUT
  star: (id) ->
    @client.put "/gists/#{id}/star", {}, (err, s, b) =>
      @star(id) if err? or s isnt 204

  # Unstar a gist
  # '/gists/37/unstar' DELETE
  unstar: (id) ->
    @client.del "/gists/#{id}/unstar", {}, (err, s, b) =>
      @unstar(id) if err? or s isnt 204

  # Check if a gist is starred
  # '/gists/37/star' GET
  check: (id) ->
    @client.get "/gists/#{id}/star", (err, s, b) ->
      return cb(err) if err
      cb null, s is 204

  # List comments on a gist
  # '/gists/37/comments' GET
  listComments: (id, cb) ->
    @client.get "/gists/#{id}/comments", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist comments error')) else cb null, b

  # Get a single comment
  # '/gists/comments/1' GET
  getComment: (id, cb) ->
    @client.get "/gists/comments/#{id}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist getComment error')) else cb null, b

  # Create a comment
  # '/gists/37/comments' POST
  createComment: (id, comment, cb) ->
    @client.post "/gists/#{id}/comments", comment, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Gist createComment error')) else cb null, b

  # Edit a comment
  # '/gists/comments/1' POST
  updateComment: (id, comment, cb) ->
    @client.post "/gists/comments/#{id}", comment, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist updateComment error')) else cb null, b

  # Delete a comment
  # '/gists/comments/1' DELETE
  deleteComment: (id) ->
    @client.del "/gists/comments/#{id}", {}, (err, s, b) =>
      @deleteComment(id) if err? or s isnt 204

  comments: (id, cbOrCmnt, cb) ->
    if !cb? and typeof cbOrCmnt is 'function'
      @listComments id, cbOrCmnt
    else
      @createComment id, cbOrCmnt, cb

  comment: (cbOrIdOrCmnt, cbOrCmnt, cb) ->
    if !cb? and typeof cbOrIdOrCmnt is 'number' and typeof cbOrCmnt is 'function'
      @getComment cbOrIdOrCmnt, cbOrCmnt
    else if !cbOrCmnt? and !cb? and typeof cbOrIdOrCmnt is 'number'
      @deleteComment cbOrIdOrCmnt
    else if typeof cb is 'function' and typeof cbOrIdOrCmnt is 'number' and typeof cbOrCmnt 'object'
      @updateComment cbOrIdOrCmnt, cbOrCmnt, cb
    else
      cbOrIdOrCmnt(new Error('Gist comment error'))

# Export module
module.exports = Gist
