#
# search.coffee: Github search class
#
# Copyright © 2013 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Search

  constructor: (@client) ->

  # Search issues
  issues: (repo, state, keyword, cb) ->
    state = 'open' if state isnt 'closed'
    @client.get "/legacy/issues/search/#{repo}/#{state}/#{keyword}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search issues error')) else cb null, b.issues

  # Search repositories
  repos: (keyword, language, start_page, cb) ->
    param = ''
    param+= 'language=#{language}&' if language
    param+= 'start_page=#{start_page}&' if start_page

    @client.get "/legacy/repos/search/#{keyword}?#{param}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search repos error')) else cb null, b.repositories

  # Search users
  users: (keyword, start_page, cb) ->
    param = ''
    param+= 'start_page=#{start_page}&' if start_page

    @client.get "/legacy/user/search/#{keyword}?#{param}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search users error')) else cb null, b.users

  # Search emails
  emails: (email, cb) ->
    @client.get "/legacy/user/email/#{email}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error('Search email error')) else cb null, b.user
