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
    @client.get "/repos/#{@repo}/pulls/#{@number}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr info error")) else cb null, b

  # Update a pull request
  # '/repos/pksunkara/hub/pulls/37' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}", obj, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr update error")) else cb null, b

  # Close a pull request
  close: (cb) ->
    @update state: 'closed', cb

  # Get if a pull request has been merged
  # '/repos/pksunkara/hub/pulls/37/merge' GET
  merged: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/merge", (err, s, b) ->
      return cb null, false if err and err.message is 'null'
      if s isnt 204 then cb(new Error("Pr merged error")) else cb null, true

  # Merge a pull request
  # '/repos/pksunkara/hub/pulls/37/merge' PUT
  merge: (msg, cb) ->
    @client.put "/repos/#{@repo}/pulls/#{@number}/merge",
      commit_message: msg
    , (err, s, b) ->
      return cb(err) if err
      cb null, b

  # List commits on a pull request
  # '/repos/pksunkara/hub/pulls/37/commits' GET
  commits: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/commits", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr commits error")) else cb null, b

  # List comments on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments' GET
  comments: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/comments", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr comments error")) else cb null, b

  # List pull request's files
  # '/repos/pksunkara/hub/pulls/37/files' GET
  files: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/files", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr files error")) else cb null, b

# Export module
module.exports = Pr
