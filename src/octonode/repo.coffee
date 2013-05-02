#
# repo.coffee: Github repository class
#
# Copyright © 2011 Pavan Kumar Sunkara. All rights reserved
#

# Requiring modules

# Initiate class
class Repo

  constructor: (@name, @client) ->

  # Get a repository
  # '/repos/pksunkara/hub' GET
  info: (cb) ->
    @client.get "/repos/#{@name}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo info error")) else cb null, b

  # Get the commits for a repository
  # '/repos/pksunkara/hub/commits' GET
  commits: (cb) ->
    @client.get "/repos/#{@name}/commits", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo commits error")) else cb null, b

  # Get the commits for a repository
  # '/repos/pksunkara/hub/commits/SHA' GET
  commit: (sha, cb) ->
    @client.get "/repos/#{@name}/commits/#{sha}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo commits error")) else cb null, b

  # Create a commit
  # '/repos/pksunkara/hub/git/commits' POST
  create_commit: (message, tree_sha, parents, cb) ->
    input =
      message: message
      parents: parents
      tree: tree_sha
    @client.post "/repos/#{@name}/git/commits", input, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo create_commit error")) else cb null, b

  # Get the tags for a repository
  # '/repos/pksunkara/hub/tags' GET
  tags: (cb) ->
    @client.get "/repos/#{@name}/tags", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo tags error")) else cb null, b

  # Get the languages for a repository
  # '/repos/pksunkara/hub/languages' GET
  languages: (cb) ->
    @client.get "/repos/#{@name}/languages", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo languages error")) else cb null, b

  # Get the contributors for a repository
  # '/repos/pksunkara/hub/contributors' GET
  contributors: (cb) ->
    @client.get "/repos/#{@name}/contributors", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo contributors error")) else cb null, b

  # Get the teams for a repository
  # '/repos/pksunkara/hub/teams' GET
  teams: (cb) ->
    @client.get "/repos/#{@name}/teams", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo teams error")) else cb null, b

  # Get the branches for a repository
  # '/repos/pksunkara/hub/branches' GET
  branches: (cb) ->
    @client.get "/repos/#{@name}/branches", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo branches error")) else cb null, b

  # Get the issues for a repository
  # '/repos/pksunkara/hub/issues' GET
  issues: (cb) ->
    @client.get "/repos/#{@name}/issues", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo issues error")) else cb null, b

  # Get the README for a repository
  # '/repos/pksunkara/hub/readme' GET
  readme: (cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.get "/repos/#{@name}/readme?ref=#{cbOrRef}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo readme error")) else cb null, b

  # Get the contents of a path in repository
  # '/repos/pksunkara/hub/contents/lib/index.js' GET
  contents: (path, cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.get "/repos/#{@name}/contents/#{path}?ref=#{cbOrRef}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo contents error")) else cb null, b

  # Get archive link for a repository
  # '/repos/pksunkara/hub/tarball/v0.1.0' GET
  archive: (format, cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.get "/repos/#{@name}/#{format}/#{cbOrRef}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 302 then cb(new Error("Repo archive error")) else cb null, h['Location']

  # Get the forks for a repository
  # '/repos/pksunkara/hub/forks' GET
  forks: (cb) ->
    @client.get "/repos/#{@name}/forks", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo forks error")) else cb null, b

  # Get the blob for a repository
  # '/repos/pksunkara/hub/git/blobs/SHA' GET
  blob: (sha, cb) ->
    @client.get "/repos/#{@name}/git/blobs/#{sha}", (err, s, b) ->
      return cb(err) if (err)
      if s isnt 200 then cb(new Error("Repo blob error")) else cb null, b

  # Create a blob (for a future commit)
  # '/repos/pksunkara/hub/git/blobs' POST
  create_blob: (content, encoding, cb) ->
    input =
     content: content
     encoding: encoding
    @client.post "/repos/#{@name}/git/blobs", input, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo create_blob")) else cb null, b

  # Get a tree object (for fetching a particular blob)
  # '/repos/pksunkara/hub/git/trees/SHA' GET
  tree: (sha, cb) ->
    @client.get "/repos/#{@name}/git/trees/#{sha}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo tree error")) else cb null, b

  # Create a tree object
  # '/repos/pksunkara/hub/git/trees' POST
  create_tree: (tree, cb) ->
    @client.post "/repos/#{@name}/git/trees", tree, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo create_tree error")) else cb null, b

  # Get a reference
  # '/repos/pksunkara/hub/git/refs/REF' GET
  ref: (ref, cb) ->
    @client.get "/repos/#{@name}/git/refs/#{ref}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo ref error")) else cb null, b

  # Update a reference
  # '/repos/pksunkara/hub/git/refs/REF' PATCH
  update_reference: (ref, sha, force, cb) ->
    if (!cb)
      cb = force
      force = false
    input =
      sha: sha
      force: force

    @client.patch "/repos/#{@name}/git/refs/#{ref}", input, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo update_ref error")) else cb null, b

  # Delete the repository
  # '/repos/pksunkara/hub' DELETE
  destroy: ->
    @client.del "/repos/#{@name}", {}, (err, s, b) =>
      @destroy() if err? or s isnt 204

  # Get pull-request instance for repo
  pr: (number) ->
    @client.pr @name, number

  # List pull requests
  # '/repos/pksunkara/hub/pulls' GET
  prs: (cbOrPr, cb) ->
    if typeof cb is 'function' and typeof cbOrPr is 'object'
      @createPr cbOrPr, cb
    else
      cb = cbOrPr
      @client.get "/repos/#{@name}/pulls", (err, s, b) ->
        return cb(err) if (err)
        if s isnt 200 then cb(new Error("Repo prs error")) else cb null, b

  # Create a pull request
  # '/repos/pksunkara/hub/pulls' POST
  createPr: (pr, cb) ->
    @client.post "/repos/#{@name}/pulls", pr, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createPr error")) else cb null, b

  # List Stargazers 
  # '/repos/:owner/:repo/stargazers' GET
  # - page, optional     - params[0]
  # - per_page, optional - params[1]
  stargazers: (params..., cb)->
    page = params[0] || 1
    per_page = params[1] || 30
    @client.get "/repos/#{@name}/stargazers", page, per_page, (err, s, b, headers) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo stargazers error")) else cb null, b, headers
    

# Export module
module.exports = Repo
