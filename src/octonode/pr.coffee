#
# pr.coffee: Github pull-request class
#
# Copyright © 2012 Pavan Kumar Sunkara. All rights reserved
#

# Initiate class
class Pr

  constructor: (@repo, @number, @client) ->

  # Get a single pull request
  # '/repos/pksunkara/hub/pulls/37' GET
  info: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr info error")) else cb null, b, h

  # Update a pull request
  # '/repos/pksunkara/hub/pulls/37' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr update error")) else cb null, b, h

  # Close a pull request
  close: (cb) ->
    @update state: 'closed', cb

  # Get if a pull request has been merged
  # '/repos/pksunkara/hub/pulls/37/merge' GET
  merged: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/merge", (err, s, b, h) ->
      return cb null, false if err and err.message is 'null'
      cb null, s is 204, h

  # Merge a pull request
  # '/repos/pksunkara/hub/pulls/37/merge' PUT
  merge: (msg, cb) ->
    commit =
      commit_message: msg
    @client.put "/repos/#{@repo}/pulls/#{@number}/merge", commit, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr merge error")) else cb null, b, h

  # List commits on a pull request
  # '/repos/pksunkara/hub/pulls/37/commits' GET
  commits: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/commits", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr commits error")) else cb null, b, h

  # List comments on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments' GET
  comments: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/comments", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr comments error")) else cb null, b, h

  # Create a comment on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments' POST
  comment: (comment, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}/comments", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Pr comment error")) else cb null, b, h

  # Removes a comment on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments/104' DELETE
  removeComment: (comment, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}/comments/#{@comment}", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Pr removeComment error")) else cb null, b, h

  # List files in pull request
  # '/repos/pksunkara/hub/pulls/37/files' GET
  files: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/files", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr files error")) else cb null, b, h

# Export module
module.exports = Pr
