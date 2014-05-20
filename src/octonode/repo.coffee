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
    @client.get "/repos/#{@name}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo info error")) else cb null, b, h

  # Get the collaborators for a repository
  # '/repos/pksunkara/hub/collaborators
  collaborators: (cbOrUser, cb) ->
    if cb? and typeof cbOrUser isnt 'function'
      @hasCollaborator cbOrUser, cb
    else
      cb = cbOrUser
      @client.get "repos/#{@name}/collaborators", (err, s, b, h) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error("Repo collaborators error")) else cb null, b, h

  # Check if user is collaborator for a repository
  # '/repos/pksunkara/hub/collaborators/pksunkara
  hasCollaborator: (user, cb) ->
    @client.get "repos/#{@name}/collaborators/#{user}", (err, s, b, h) ->
      return cb(err) if err
      cb null, s is 204, h

  # Get the commits for a repository
  # '/repos/pksunkara/hub/commits' GET
  commits: (cb) ->
    @client.get "/repos/#{@name}/commits", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo commits error")) else cb null, b, h

  # Get a certain commit for a repository
  # '/repos/pksunkara/hub/commits/SHA' GET
  commit: (sha, cb) ->
    @client.get "/repos/#{@name}/commits/#{sha}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo commits error")) else cb null, b, h

  # Create a commit
  # '/repos/pksunkara/hub/git/commits' POST
  createCommit: (message, tree, parents, cbOrOptions, cb) ->
    if !cb? and cbOrOptions
      cb = cbOrOptions
      param = {message: message, parents: parents, tree: tree}
    else if typeof cbOrOptions is 'hash'
      param = cbOrOptions
      param['message'] = message
      param['parents'] = parents
      param['tree'] = tree
    @client.post "/repos/#{@name}/git/commits", param, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createCommit error")) else cb null, b, h

  # Get the tags for a repository
  # '/repos/pksunkara/hub/tags' GET
  tags: (cb) ->
    @client.get "/repos/#{@name}/tags", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo tags error")) else cb null, b, h

  # Get the releases for a repository
  # '/repos/pksunkara/hub/releases' GET
  releases: (cb) ->
    @client.get "/repos/#{@name}/releases", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo releases error")) else cb null, b, h

  # Get the languages for a repository
  # '/repos/pksunkara/hub/languages' GET
  languages: (cb) ->
    @client.get "/repos/#{@name}/languages", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo languages error")) else cb null, b, h

  # Get the contributors for a repository
  # '/repos/pksunkara/hub/contributors' GET
  contributors: (cb) ->
    @client.get "/repos/#{@name}/contributors", (err, s, b, h) ->
      return cb(err) if err
      if s is 204
        cb null, [], h
      else if s isnt 200 then cb(new Error("Repo contributors error")) else cb null, b, h

  # Get the teams for a repository
  # '/repos/pksunkara/hub/teams' GET
  teams: (cb) ->
    @client.get "/repos/#{@name}/teams", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo teams error")) else cb null, b, h

  # Get the branches for a repository
  # '/repos/pksunkara/hub/branches' GET
  branches: (cb) ->
    @client.get "/repos/#{@name}/branches", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo branches error")) else cb null, b, h

  # Get issue instance for a repo
  issue: (numberOrIssue, cb) ->
    if typeof cb is 'function' and typeof numberOrIssue is 'object'
      @createIssue numberOrIssue, cb
    else
      @client.issue @name, numberOrIssue

  # List issues for a repository
  # '/repos/pksunkara/hub/issues' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  issues: (params..., cb) ->
    @client.get "/repos/#{@name}/issues", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo issues error")) else cb null, b, h

  # Create an issue for a repository
  # '/repos/pksunkara/hub/issues' POST
  createIssue: (issue, cb) ->
    @client.post "/repos/#{@name}/issues", issue, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createIssue error")) else cb null, b, h

  # Get milestone instance for a repo
  milestone: (numberOrMilestone, cb) ->
    if typeof cb is 'function' and typeof numberOrMilestone is 'object'
      @createMilestone numberOrMilestone, cb
    else
      @client.milestone @name, numberOrMilestone

  # List milestones for a repository
  # '/repos/pksunkara/hub/milestones' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  milestones: (params..., cb) ->
    @client.get "/repos/#{@name}/milestones", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo milestones error")) else cb null, b, h

  # Create a milestone for a repository
  # '/repos/pksunkara/hub/milestones' POST
  createMilestone: (milestone, cb) ->
    @client.post "/repos/#{@name}/milestones", milestone, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createMilestone error")) else cb null, b, h

  # Get the README for a repository
  # '/repos/pksunkara/hub/readme' GET
  readme: (cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.get "/repos/#{@name}/readme", {ref: cbOrRef}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo readme error")) else cb null, b, h

  # Get the contents of a path in repository
  # '/repos/pksunkara/hub/contents/lib/index.js' GET
  contents: (path, cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.get "/repos/#{@name}/contents/#{path}", {ref: cbOrRef}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo contents error")) else cb null, b, h

  # Create a file at a path in repository
  # '/repos/pksunkara/hub/contents/lib/index.js' PUT
  createContents: (path, message, content, cbOrBranchOrOptions, cb) ->
    content = new Buffer(content).toString('base64')
    if !cb? and cbOrBranchOrOptions
      cb = cbOrBranchOrOptions
      cbOrBranchOrOptions = 'master'
    if typeof cbOrBranchOrOptions is 'string'
      param = {branch: cbOrBranchOrOptions, message: message, content: content}
    else if typeof cbOrBranchOrOptions is 'hash'
      param = cbOrBranchOrOptions
      param['message'] = message
      param['content'] = content
    @client.put "/repos/#{@name}/contents/#{path}", param, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createContents error")) else cb null, b, h

  # Update a file at a path in repository
  # '/repos/pksunkara/hub/contents/lib/index.js' PUT
  updateContents: (path, message, content, sha, cbOrBranch, cb) ->
    if !cb? and cbOrBranch
      cb = cbOrBranch
      cbOrBranch = 'master'
    @client.put "/repos/#{@name}/contents/#{path}", {branch: cbOrBranch, message: message, content: new Buffer(content).toString('base64'), sha: sha}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo updateContents error")) else cb null, b, h

  # Delete a file at a path in repository
  # '/repos/pksunkara/hub/contents/lib/index.js' DELETE
  deleteContents: (path, message, sha, cbOrBranch, cb) ->
    if !cb? and cbOrBranch
      cb = cbOrBranch
      cbOrBranch = 'master'
    @client.del "/repos/#{@name}/contents/#{path}", {branch: cbOrBranch, message: message, sha: sha}, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo deleteContents error")) else cb null, b, h

  # Get archive link for a repository
  # '/repos/pksunkara/hub/tarball/v0.1.0' GET
  archive: (format, cbOrRef, cb) ->
    if !cb? and cbOrRef
      cb = cbOrRef
      cbOrRef = 'master'
    @client.getNoFollow "/repos/#{@name}/#{format}/#{cbOrRef}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 302 then cb(new Error("Repo archive error")) else cb null, h['location'], h

  # Get the forks for a repository
  # '/repos/pksunkara/hub/forks' GET
  forks: (cb) ->
    @client.get "/repos/#{@name}/forks", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo forks error")) else cb null, b, h

  # Get the blob for a repository
  # '/repos/pksunkara/hub/git/blobs/SHA' GET
  blob: (sha, cb) ->
    @client.get "/repos/#{@name}/git/blobs/#{sha}",
      Accept: 'application/vnd.github.raw'
    , (err, s, b, h) ->
      return cb(err) if (err)
      if s isnt 200 then cb(new Error("Repo blob error")) else cb null, b, h

  # Create a blob (for a future commit)
  # '/repos/pksunkara/hub/git/blobs' POST
  createBlob: (content, encoding, cb) ->
    @client.post "/repos/#{@name}/git/blobs", {content: content, encoding: encoding}, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createBlob error")) else cb null, b

  # Get a git tree
  # '/repos/pksunkara/hub/git/trees/SHA' GET
  # '/repos/pksunkara/hub/git/trees/SHA?recursive=1' GET
  tree: (sha, cbOrRecursive, cb) ->
    if !cb? and cbOrRecursive
      cb = cbOrRecursive
      cbOrRecursive = false
    param = {recursive: 1} if cbOrRecursive
    @client.get "/repos/#{@name}/git/trees/#{sha}", param, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo tree error")) else cb null, b, h

  # Create a tree object
  # '/repos/pksunkara/hub/git/trees' POST
  createTree: (tree, cbOrBase, cb) ->
    if !cb? and cbOrBase
      cb = cbOrBase
      cbOrBase = null
    @client.post "/repos/#{@name}/git/trees", {tree: tree, base_tree: cbOrBase}, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createTree error")) else cb null, b

  # Get a reference
  # '/repos/pksunkara/hub/git/refs/REF' GET
  ref: (ref, cb) ->
    @client.get "/repos/#{@name}/git/refs/#{ref}", (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo ref error")) else cb null, b

  # Create a reference
  # '/repos/pksunkara/hub/git/refs' POST
  createRef: (ref, sha, cb) ->
    @client.post "/repos/#{@name}/git/refs", {ref: "refs/" + ref, sha: sha}, (err, s, b) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createRef error")) else cb null, b

  # Update a reference
  # '/repos/pksunkara/hub/git/refs/REF' PATCH
  updateRef: (ref, sha, cb) ->
    @client.post "/repos/#{@name}/git/refs/#{ref}", {sha: sha}, (err, s, b) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo updateRef error")) else cb null, b

  # Delete the repository
  # '/repos/pksunkara/hub' DELETE
  destroy: ->
    @client.del "/repos/#{@name}", {}, (err, s, b, h) =>
      @destroy() if err? or s isnt 204

  # Get pull-request instance for repo
  pr: (numberOrPr, cb) ->
    if typeof cb is 'function' and typeof numberOrPr is 'object'
      @createPr numberOrPr, cb
    else
      @client.pr @name, numberOrPr

  # List pull requests
  # '/repos/pksunkara/hub/pulls' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  prs: (params..., cb) ->
    @client.get "/repos/#{@name}/pulls", params..., (err, s, b, h) ->
      return cb(err) if (err)
      if s isnt 200 then cb(new Error("Repo prs error")) else cb null, b, h

  # Create a pull request
  # '/repos/pksunkara/hub/pulls' POST
  createPr: (pr, cb) ->
    @client.post "/repos/#{@name}/pulls", pr, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createPr error")) else cb null, b, h

  # List hooks
  # '/repos/pksunkara/hub/hooks' GET
  hooks: (cb) ->
    @client.get "/repos/#{@name}/hooks", (err, s, b, h) ->
      return cb(err) if (err)
      if s isnt 200 then cb(new Error("Repo hooks error")) else cb null, b, h

  # Create a hook
  # '/repos/pksunkara/hub/hooks' POST
  hook: (hookInfo, cb) ->
    @client.post "/repos/#{@name}/hooks", hookInfo, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo createHook error")) else cb null, b, h

  # List statuses for a specific ref
  # '/repos/pksunkara/hub/statuses/master' GET
  statuses: (ref, cb) ->
    @client.get "/repos/#{@name}/statuses/#{ref}", (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo statuses error")) else cb null, b, h

  # Create a status
  # '/repos/pksunkara/hub/statuses/18e129c213848c7f239b93fe5c67971a64f183ff' POST
  status: (sha, obj, cb) ->
    @client.post "/repos/#{@name}/statuses/#{sha}", obj, (err, s, b, h) ->
      return cb(err) if err
      if s isnt 201 then cb(new Error("Repo status error")) else cb null, b, h

  # List Stargazers
  # '/repos/:owner/:repo/stargazers' GET
  # - page or query object, optional - params[0]
  # - per_page, optional             - params[1]
  stargazers: (params..., cb)->
    @client.get "/repos/#{@name}/stargazers", params..., (err, s, b, h) ->
      return cb(err) if err
      if s isnt 200 then cb(new Error("Repo stargazers error")) else cb null, b, h

# Export module
module.exports = Repo
