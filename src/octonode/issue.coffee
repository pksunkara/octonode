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
    @client.get "/repos/#{@repo}/issues/#{@number}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue info error")) else cb null, b

  # Edit an issue for a repository
  # '/repos/pksunkara/hub/issues/37' PATCH
  update: (obj, cb) ->
    @client.post "/repos/#{@repo}/issues/#{@number}", obj, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Issue update error")) else cb null, b

  # List comments on an issue
  # '/repos/pksunkara/hub/issues/37/comments' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  comments: (params..., cb) ->
    @client.get "/repos/" + @repo + "/issues/" + @number + "/comments", params..., (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue Comments error')) else cb null, b

# Export module
module.exports = Issue
