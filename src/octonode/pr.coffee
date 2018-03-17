#
# pr.coffee: Github pull-request class
#
# Copyright © 2012 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules
Base = require './base'

# Initiate class
class Pr extends Base

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
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  comments: (params..., cb) ->
    @client.get "/repos/" + @repo + "/pulls/" + @number + "/comments", params..., (err, s, b, h)  ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Pr Comments error')) else cb null, b, h

  # Create a comment on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments' POST
  createComment: (comment, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}/comments", comment, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Pr createComment error")) else cb null, b, h

  # Removes a comment on a pull request
  # '/repos/pksunkara/hub/pulls/37/comments/104' DELETE
  removeComment: (id, cb) ->
    @client.del "/repos/#{@repo}/pulls/#{@number}/comments/#{id}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 204 then cb(new Error("Pr removeComment error")) else cb null, b, h

  # List files in pull request
  # '/repos/pksunkara/hub/pulls/37/files' GET
  files: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/files", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr files error")) else cb null, b, h

  # List pull request reviews
  # '/repos/pksunkara/hub/pulls/37/reviews' GET
  reviews: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/reviews", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr reviews error")) else cb null, b, h

  # Get a single pull request review
  # '/repos/pksunkara/hub/pulls/37/reviews/104' GET
  review: (id, cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/reviews/#{id}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr review error")) else cb null, b, h

  # Delete a pending pull request review (pending only)
  # '/repos/pksunkara/hub/pulls/37/reviews/104' DELETE
  removeReview: (id, cb) ->
    @client.del "/repos/#{@repo}/pulls/#{@number}/reviews/#{id}", {}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr removeReview error")) else cb null, b, h

  # List comments for a pull request review
  # '/repos/pksunkara/hub/pulls/37/reviews/104/comments' GET
  reviewComments: (id, cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/reviews/#{id}/comments", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr reviewComments error")) else cb null, b, h

  # Create a pull request review
  # '/repos/pksunkara/hub/pulls/37/reviews' POST
  createReview: (reviewBody, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}/reviews", reviewBody, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr createReview error")) else cb null, b, h

  # Submit a pull request review
  # '/repos/pksunkara/hub/pulls/37/reviews/104/events' POST
  submitReview: (id, reviewBody, cb) ->
    @client.post "/repos/#{@repo}/pulls/#{@number}/reviews/#{id}/events", reviewBody, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr submitReview error")) else cb null, b, h

  # Dismiss a pull request review
  # '/repos/pksunkara/hub/pulls/37/reviews/104/dismissals' PUT
  dismissReview: (id, dismissalMessage, cb) ->
    dismissal =
      message: dismissalMessage
    @client.put "/repos/#{@repo}/pulls/#{@number}/reviews/#{id}/dismissals", dismissal, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr dismissReview error")) else cb null, b, h

  # List review requests
  # '/repos/pksunkara/hub/pulls/37/requested_reviewers' GET
  reviewRequests: (cb) ->
    @client.get "/repos/#{@repo}/pulls/#{@number}/requested_reviewers", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr reviewRequests error")) else cb null, b, h

  # Create review request(s)
  # '/repos/pksunkara/hub/pulls/37/requested_reviewers' POST
  createReviewRequests: (usernames, cb) ->
    reviewRequest =
      reviewers: usernames
    @client.post "/repos/#{@repo}/pulls/#{@number}/requested_reviewers", reviewRequest, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Pr createReviewRequests error")) else cb null, b, h

  # Remove review request(s)
  # '/repos/pksunkara/hub/pulls/37/requested_reviewers' DELETE
  removeReviewRequests: (usernames, cb) ->
    reviewRequest =
      reviewers: usernames
    @client.del "/repos/#{@repo}/pulls/#{@number}/requested_reviewers", reviewRequest, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Pr removeReviewRequests error")) else cb null, b, h

# Export module
module.exports = Pr
