#
# issue.coffee: Github issue class
#
# Copyright © 2013 Josh Priestley. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Issue extends Base

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
  deleteComment: (id, cb) ->
    @client.del "/repos/#{@repo}/issues/comments/#{id}", {}, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 204 then cb(new Error("Issue deleteComment error")) else cb null, b, h

  # List events on an issue
  # '/repos/pksunkara/hub/issues/37/events' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  events: (params..., cb) ->
    @client.get "/repos/" + @repo + "/issues/" + @number + "/events", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue events error')) else cb null, b, h

  # List labels
  # '/repos/pksunkara/hub/issues/37/labels' GET
  labels: (cb) ->
    @client.get "/repos/" + @repo + "/issues/" + @number + "/labels", {}, (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue labels error')) else cb null, b, h

  # Add label(s)
  # '/repos/pksunkara/hub/issues/37/labels' POST
  addLabels: (labels, cb) ->
    @client.post "/repos/#{@repo}/issues/#{@number}/labels", labels, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue addLabels error")) else cb null, b, h

  # Replace all labels
  # '/repos/pksunkara/hub/issues/37/labels' PUT
  replaceAllLabels: (labels, cb) ->
    @client.put "/repos/#{@repo}/issues/#{@number}/labels", labels, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue replaceLabels error")) else cb null, b, h

  # Remove a label
  # '/repos/pksunkara/hub/issues/37/labels/label-name' DELETE
  removeLabel: (label, cb) ->
    @client.del encodeURI("/repos/#{@repo}/issues/#{@number}/labels/#{label}"), {}, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue removeLabel error")) else cb null, b, h
      ## The documenation here https://developer.github.com/v3/issues/labels/#remove-a-label-from-an-issue
      ## claims that a 204 status is returned when deleting a single label, but in fact a 200 status is returned.

  # Remove all labels
  # '/repos/pksunkara/hub/issues/37/labels' DELETE
  removeAllLabels: (cb) ->
    @client.del "/repos/#{@repo}/issues/#{@number}/labels", {}, (err, s, b, h) =>
      return cb(err) if err
      if s isnt 204 then cb(new Error("Issue removeAllLabels error")) else cb null, b, h

# Export module
module.exports = Issue
