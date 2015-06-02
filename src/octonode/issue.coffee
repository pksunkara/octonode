#
# issue.coffee: Github issue class
#
# Copyright © 2013 Josh Priestley. All rights reserved
#

# Initiate class
class Issue

  constructor: (@repo, @number, @client) ->

  # Get a single issue
  # '/repos/pksunkara/hub/issues/37' GET
  info: (cb) ->
    @client.get "/repos/#{@repo}/issues/#{@number}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue info error")) else cb null, b, h

  # Edit an issue for a repository
  # '/repos/pksunkara/hub/issues/37' PATCH
  update: (obj, cb) ->
    @client.patch "/repos/#{@repo}/issues/#{@number}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue update error")) else cb null, b, h

  # List comments on an issue
  # '/repos/pksunkara/hub/issues/37/comments' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  comments: (params..., cb) ->
    @client.get "/repos/" + @repo + "/issues/" + @number + "/comments", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue Comments error')) else cb null, b, h

  # Create a comment
  # '/repos/pksunkara/hub/issues/37/comments' POST
  createComment: (comment, cb) ->
    @client.post "/repos/#{@repo}/issues/#{@number}/comments", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error('Issue createComment error')) else cb null, b, h

  # Edit a comment
  # '/repos/pksunkara/hub/issues/comments/3' PATCH
  updateComment: (id, comment, cb) ->
    @client.patch "/repos/#{@repo}/issues/comments/#{id}", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue updateComment error')) else cb null, b, h

  # Delete a comment
  # '/repos/pksunkara/hub/issues/comments/3' DELETE
  deleteComment: (id) ->
    @client.del "/repos/#{@repo}/issues/comments/#{id}", {}, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 204 then cb(new Error("Issue deleteComment error")) else cb null, b, h

# Export module
module.exports = Issue
