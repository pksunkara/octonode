# octonode

octonode is a library for nodejs to access the [github v3 api](http://developer.github.com)

## Installation
```
npm install octonode
```

## Usage

```js
var github = require('octonode');

// Then we instanciate a client with or without a token (as show in a later section)

var ghme   = client.me();
var ghuser = client.user('pksunkara');
var ghrepo = client.repo('pksunkara/hub');
var ghorg  = client.org('flatiron');
var ghgist = client.gist();
var ghteam = client.team(37);
```

__Many of the below use cases use parts of the above code__

## Authentication

### Authenticate to github in cli mode (desktop application)

```js
github.auth.config({
  username: 'pksunkara',
  password: 'password'
}).login(['user', 'repo', 'gist'], function (err, id, token) {
  console.log(id, token);
});
```

### Revoke authentication to github in cli mode (desktop application)

```js
github.auth.config({
  username: 'pksunkara',
  password: 'password'
}).revoke(id, function (err) {
  if (err) throw err;
});
```

### Authenticate to github in web mode (web application)

```js
// Web application which authenticates to github
var http = require('http')
  , url = require('url')
  , qs = require('querystring')
  , github = require('octonode');

// Build the authorization config and url
var auth_url = github.auth.config({
  id: 'mygithubclientid',
  secret: 'mygithubclientsecret'
}).login(['user', 'repo', 'gist']);

// Web server
http.createServer(function (req, res) {
  uri = url.parse(req.url);
  // Redirect to github login
  if (uri.pathname=='/login') {
    res.writeHead(301, {'Content-Type': 'text/plain', 'Location': auth_url})
    res.end('Redirecting to ' + auth_url);
  }
  // Callback url from github login
  else if (uri.pathname=='/auth') {
    github.auth.login(qs.parse(uri.query).code, function (err, token) {
      console.log(token);
    });
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('');
  } else {
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('');
  }
}).listen(3000);

console.log('Server started on 3000');
```

### Build a client which accesses any public information

```js
var client = github.client();

client.get('/users/pksunkara', function (err, status, body) {
  console.log(body); //json object
});
```

### Build a client from an access token

```js
var client = github.client('someaccesstoken');

client.get('/user', function (err, status, body) {
  console.log(body); //json object
});
```

### Build a client from credentials

```js
var client = github.client({
  username: 'pksunkara',
  password: 'password'
});

client.get('/user', function (err, status, body) {
  console.log(body); //json object
});
```

## API Callback Structure

__All the callbacks for the following will take first an error argument, then a data argument, like this:__

```js
ghme.info(function(err, data) {
  console.log("error: " + err);
  console.log("data: " + data);
});
```

## Github authenticated user api

Token/Credentials required for the following:

### Get information about the user (GET /user)

```js
ghme.info(callback); //json
```

### Update user profile (PATCH /user)

```js
ghme.update({
  "name": "monalisa octocat",
  "email": "octocat@github.com",
}, callback);
```

### Get emails of the user (GET /user/emails)

```js
ghme.emails(callback); //array of emails
```

### Set emails of the user (POST /user/emails)

```js
ghme.emails(['new1@ma.il', 'new2@ma.il'], callback); //array of emails
ghme.emails('new@ma.il', callback); //array of emails
```

### Delete emails of the user (DELETE /user/emails)

```js
ghme.emails(['new1@ma.il', 'new2@ma.il']);
ghme.emails('new@ma.il');
```

### Get the followers of the user (GET /user/followers)

```js
ghme.followers(callback); //array of github users
```

### Get users whom the user is following (GET /user/following)

```js
ghme.following(callback); //array of github users
```

### Check if the user is following a user (GET /user/following/marak)

```js
ghme.following('marak', callback); //boolean
```

### Follow a user (PUT /user/following/marak)

```js
ghme.follow('marak');
```

### Unfollow a user (DELETE /user/following/marak)

```js
ghme.unfollow('marak');
```

### Get public keys of a user (GET /user/keys)

```js
ghme.keys(callback); //array of keys
```

### Get a single public key (GET /user/keys/1)

```js
ghme.keys(1, callback); //key
```

### Create a public key (POST /user/keys)

```js
ghme.keys({"title":"laptop", "key":"ssh-rsa AAA..."}, callback); //key
```

### Update a public key (PATCH /user/keys/1)

```js
ghme.keys(1, {"title":"desktop", "key":"ssh-rsa AAA..."}, callback); //key
```

### Delete a public key (DELETE /user/keys/1)

```js
ghme.keys(1);
```

### List your public and private organizations (GET /user/orgs)

```js
ghme.orgs(callback); // array of orgs
```

### List your repositories (GET /user/repos)

```js
ghme.repos(callback); //array of repos
```

### Create a repository (POST /user/repos)

```js
ghme.repos({
  "name": "Hello-World",
  "description": "This is your first repo",
}, callback); //repo
```

### Fork a repository (POST /repos/pksunkara/hub/forks)

```js
ghme.fork('pksunkara/hub', callback); //forked repo
```

## Github users api

No token required for the following

### Get information about an user (GET /users/pksunkara)

```js
ghuser.info(callback); //json
```

### Get an user followers (GET /users/pksunkara/followers)

```js
ghuser.followers(callback); //array of github users
```

### Get an user followings (GET /users/pksunkara/following)

```js
ghuser.following(callback); //array of github users
```

## Github repositories api

### Get information about a repository (GET /repos/pksunkara/octonode)

```js
ghrepo.info(callback); //json
```

### Get the commits for a repository (GET /repos/pkumar/hub/commits)

```js
ghrepo.commits(callback); //array of commits
```

### Get the tags for a repository (GET /repos/pksunkara/hub/tags)

```js
ghrepo.tags(callback); //array of tags
```

### Get the languages for a repository (GET /repos/pksunkara/hub/languages)

```js
ghrepo.languages(callback); //array of languages
```

### Get the contributors for a repository (GET /repos/pksunkara/hub/contributors)

```js
ghrepo.contributors(callback); //array of github users
```

### Get the branches for a repository (GET /repos/pksunkara/hub/branches)

```js
ghrepo.branches(callback); //array of branches
```

### Get the issues for a repository (GET /repos/pksunkara/hub/issues)

```js
ghrepo.issues(callback); //array of issues
```

### Get the README for a repository (GET /repos/pksunkara/hub/readme)

```js
ghrepo.readme(callback); //file
ghrepo.readme('v0.1.0', callback); //file
```

### Get the contents of a path in repository

```js
ghrepo.contents('lib/index.js', callback); //path
ghrepo.contents('lib/index.js', 'v0.1.0', callback); //path
```

### Get archive link for a repository

```js
ghrepo.archive('tarball', callback); //link to archive
ghrepo.archive('zipball', 'v0.1.0', callback); //link to archive
```

### Get the blob for a repository (GET /repos/pksunkara/hub/git/blobs/SHA)

```js
ghrepo.blob('18293abcd72', callback); //blob
```

### Get the teams for a repository (GET /repos/pksunkara/hub/teams)

```js
ghrepo.teams(callback); //array of teams
```

### Delete the repository (DELETE /repos/pksunkara/hub)

```js
ghrepo.destroy();
```

## Github organizations api

### Get information about an organization (GET /orgs/flatiron)

```js
ghorg.info(callback); //json
```

### List organization repositories (GET /orgs/flatiron/repos)

```js
ghorg.repos(callback); //array of repos
```

### Create an organization repository (POST /orgs/flatiron/repos)

```js
ghorg.repos({
  name: 'Hello-world',
  description: 'My first world program'
}, callback); //repo
```

### Get an organization's teams (GET /orgs/flatiron/teams)

```js
ghorg.teams(callback); //array of teams
```

### Get an organization's members (GET /orgs/flatiron/members)

```js
ghorg.members(callback); //array of github users
```

### Check an organization member (GET /orgs/flatiron/members/pksunkara)

```js
ghorg.member('pksunkara', callback); //boolean
```

## Github gists api

### List authenticated user's gists (GET /gists)

```js
ghgist.list(callback); //array of gists
```

### List authenticated user's public gists (GET /gists/public)

```js
ghgist.public(callback); //array of gists
```

### List authenticated user's starred gists (GET /gists/starred)

```js
ghgist.starred(callback); //array of gists
```

### List a user's public gists (GET /users/pksunkara/gists)

```js
ghgist.user('pksunkara', callback); //array of gists
```

### Get a single gist (GET /gists/37)

```js
ghgist.get(37, callback); //gist
```

### Create a gist (POST /gists)

```js
ghgist.create({
  description: "the description",
  files: { ... }
}), callback); //gist
```

### Edit a gist (PATCH /gists/37)

```js
ghgist.edit(37, {
  description: "hello gist"
}, callback); //gist
```

### Delete a gist (DELETE /gists/37)

```js
ghgist.delete(37);
```

### Star a gist (PUT /gists/37/star)

```js
ghgist.star(37);
```

### Unstar a gist (DELETE /gists/37/unstar)

```js
ghgist.unstar(37);
```

### Check if a gist is starred (GET /gists/37/star)

```js
ghgist.check(37); //boolean
```

### List comments on a gist (GET /gists/37/comments)

```js
ghgist.comments(37, callback); //array of comments
```

### Create a comment (POST /gists/37/comments)

```js
ghgist.comments(37, {
  body: "Just commenting"
}, callback); //comment
```

### Get a single comment (GET /gists/comments/1)

```js
ghgist.comment(1, callback); //comment
```

### Edit a comment (POST /gists/comments/1)

```js
ghgist.comment(1, {
  body: "lol at commenting"
}, callback); //comment
```

### Delete a comment (DELETE /gists/comments/1)

```js
ghgist.comment(1);
```

## Github teams api

### Get a team (GET /team/37)

```js
ghteam.info(callback); //json
```

### Get the team members (GET /team/37/members)

```js
ghteam.members(callback); //array of github users
```

### Check if a user is part of the team (GET /team/37/members/pksunkara)

```js
ghteam.member('pksunkara'); //boolean
```

## Testing
```
npm test
```

If you like this project, please watch this and follow me.

## Contributors
Here is a list of [Contributors](http://github.com/pksunkara/octonode/contributors)

### TODO

The following method names use underscore as an example. The library contains camel cased method names.

```js
// public orgs for unauthenticated, private and public for authenticated
me.get_organizations(callback);

// public repos for unauthenticated, private and public for authenticated
me.get_watched_repositories(callback);
me.is_watching('repo', callback);
me.start_watching('repo', callback);
me.stop_watching('repo', callback);
me.get_issues(params, callback);

// organization data
var org = octonode.Organization('bulletjs');

org.update(dict_with_update_properties, callback);
org.add_member('user', 'team', callback);
org.remove_member('user', callback);
org.get_public_members(callback);
org.is_public_member('user', callback);
org.make_member_public('user', callback);
org.conceal_member('user', callback);

org.get_team('team', callback);
org.create_team({name:'', repo_names:'', permission:''}, callback);
org.edit_team({name:'', permission:''}, callback);
org.delete_team('name', callback);
org.get_team_members('team', callback);
org.get_team_member('team', 'user', callback);
org.remove_member_from_team('user', 'team', callback);
org.get_repositories(callback);
org.create_repository({name: ''}, callback);
org.get_team_repositories('team', callback);
org.get_team_repository('team', 'name', callback);
org.add_team_repository('team', 'name', callback);
org.remove_team_repository('team', 'name', callback);

var repo = octonode.Repository('pksunkara/octonode');

repo.update({name: ''}, callback);

// collaborator information
repo.get_collaborators(callback);
repo.has_collaborator('name', callback);
repo.add_collaborator('name', callback);
repo.remove_collaborator('name', callback);

// commit data
repo.get_commit('sha-id', callback);
repo.get_all_comments(callback);
repo.get_commit_comments('SHA ID', callback);
repo.comment_on_commit({body: '', commit_id: '', line: '', path: '', position: ''}, callback);
repo.get_single_comment('comment id', callback);
repo.edit_single_comment('comment id', callback);
repo.delete_single_comment('comment id', callback);

// downloads
repo.get_downloads(callback);
repo.get_download(callback);
repo.create_download({name: ''}, 'filepath', callback);
repo.delete_download(callback);

// keys
repo.get_deploy_keys(callback);
repo.get_deploy_key('id', callback);
repo.create_deploy_key({title: '', key: ''}, callback);
repo.edit_deploy_key({title: '', key: ''}, callback);
repo.delete_deploy_key('id', callback);

// watcher data
repo.get_watchers(callback);

// pull requests
repo.get_all_pull_request_comments(callback);
repo.get_pull_request_comment('id', callback);
repo.create_pull_request_comment('id', {body:'', commit_id:'', path:'', position:''}, callback);
repo.reply_to_pull_request_comment('id', 'body', callback);
repo.edit_pull_request_comment('id', 'body', callback);
repo.delete_pull_request_comment('id', callback);
repo.get_issues(params, callback);
repo.get_issue('id', callback);
repo.create_issue({title: ''}, callback);
repo.edit_issue({title: ''}, callback);
repo.get_issue_comments('issue', callback);
repo.get_issue_comment('id', callback);
repo.create_issue_comment('id', 'comment', callback);
repo.edit_issue_comment('id', 'comment', callback);
repo.delete_issue_comment('id', callback);
repo.get_issue_events('id', callback);
repo.get_events(callback);
repo.get_event('id', callback);
repo.get_labels(callback);
repo.get_label('id', callback);
repo.create_label('name', 'color', callback);
repo.edit_label('name', 'color', callback);
repo.delete_label('id', callback);
repo.get_issue_labels('issue', callback);
repo.add_labels_to_issue('issue', ['label1', 'label2'], callback);
repo.remove_label_from_issue('issue', 'labelid', callback);
repo.set_labels_for_issue('issue', ['label1', 'label2'], callback);
repo.remove_all_labels_from_issue('issue', callback);
repo.get_labels_for_milestone_issues('milestone', callback);
repo.get_milestones(callback);
repo.get_milestone('id', callback);
repo.create_milestone('title', callback);
repo.edit_milestone('title', callback);
repo.delete_milestone('id', callback);

// raw git access
repo.create_blob('content', 'encoding', callback);
repo.get_commit('sha-id', callback);
repo.create_commit('message', 'tree', [parents], callback);
repo.get_reference('ref', callback);
repo.get_all_references(callback);
repo.create_reference('ref', 'sha', callback);
repo.update_reference('ref', 'sha', force, callback);
```

__I accept pull requests and guarantee a reply back within a day__

## License
MIT/X11

## Bug Reports
Report [here](http://github.com/pksunkara/octonode/issues). __Guaranteed reply within a day__.

## Contact
Pavan Kumar Sunkara (pavan.sss1991@gmail.com)

Follow me on [github](https://github.com/users/follow?target=pksunkara), [twitter](http://twitter.com/pksunkara)
