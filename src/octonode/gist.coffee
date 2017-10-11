#
# gist.coffee: Github gist class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Gist extends Base

  constructor: (@client) ->

  # List authenticated user's gists
  # '/gists' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  list: (params..., cb) ->
    @client.get "/gists", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist list error')) else cb null, b, h

  # List authenticated user's public gists
  # '/gists/public' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  public: (params..., cb) ->
    @client.get "/gists/public", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist public error')) else cb null, b, h

  # List authenticated user's starred gists
  # '/gists/starred' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  starred: (params..., cb) ->
    @client.get "/gists/starred", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist starred error')) else cb null, b, h

  # List a user's public gists
  # '/users/pksunkara/gists' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  user: (params..., user, cb) ->
    @client.get "/users/#{user}/gists", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist user error')) else cb null, b, h

  # Get a single gist
  # '/gists/37' GET
  get: (id, cb) ->
    @client.get "/gists/#{id}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist get error')) else cb null, b, h

  # Create a gist
  # '/gists' POST
  create: (gist, cb) ->
    @client.post "/gists", gist, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Gist create error')) else cb null, b, h

  # Edit a gist
  # '/gists/37' PATCH
  edit: (id, gist, cb) ->
    @client.post "/gists/#{id}", gist, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist edit error')) else cb null, b, h

  # Delete a gist
  # '/gists/37' DELETE
  delete: (id, cb) ->
    @client.del "/gists/#{id}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Gist delete error")) else cb null

  # Fork a gist
  # '/gists/37/forks' POST
  fork: (id) ->
    @client.post "/gists/#{id}/forks", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Gist fork error')) else cb null, b, h

  # Star a gist
  # '/gists/37/star' PUT
  star: (id, cb) ->
    @client.put "/gists/#{id}/star", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Gist star error")) else cb null

  # Unstar a gist
  # '/gists/37/unstar' DELETE
  unstar: (id, cb) ->
    @client.del "/gists/#{id}/unstar", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Gist unstar error")) else cb null

  # Check if a gist is starred
  # '/gists/37/star' GET
  check: (id, cb) ->
    @client.get "/gists/#{id}/star", (err, s, b, h) ->
      return cb(err) if err
      cb null, s is 204, h

  # List comments on a gist
  # '/gists/37/comments' GET
  listComments: (id, cb) ->
    @client.get "/gists/#{id}/comments", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist comments error')) else cb null, b, h

  # Get a single comment
  # '/gists/comments/1' GET
  getComment: (id, cb) ->
    @client.get "/gists/comments/#{id}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist getComment error')) else cb null, b, h

  # Create a comment
  # '/gists/37/comments' POST
  createComment: (id, comment, cb) ->
    @client.post "/gists/#{id}/comments", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Gist createComment error')) else cb null, b, h

  # Edit a comment
  # '/gists/comments/1' POST
  updateComment: (id, comment, cb) ->
    @client.post "/gists/comments/#{id}", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Gist updateComment error')) else cb null, b, h

  # Delete a comment
  # '/gists/comments/1' DELETE
  deleteComment: (id, cb) ->
    @client.del "/gists/comments/#{id}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Gist deleteComment error")) else cb null

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
