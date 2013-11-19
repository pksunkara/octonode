#
# issue.coffee: Github issue class
#
# Copyright © 2013 Josh Priestley. All rights reserved
#

# Initiate class
class Issue

  constructor: (@repo, @number, @client) ->

  # List comments on an issue
  # '/repos/pksunkara/hub/issues/37/comments' GET
  comments: (cb) ->
    @client.get "/repos/" + @repo + "/issues/" + @number + "/comments", (err, s, b)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Issue Comments error')) else cb null, b

# Export module
module.exports = Issue
