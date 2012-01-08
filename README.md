# octonode

octonode is a library for nodejs to access the [github v3 api](http://developer.github.com)

## Installation
```
npm install octonode
```

## Usage

```js
var github = require('octonode');

var ghme  = client.me();
var ghuser = client.user('pkumar');
var ghrepo = client.repository('pkumar/hub');
var ghorg  = client.organization('flatiron');
```

__Many of the below use cases use parts of the above code__

### Authentication

- Authenticate to github in cli mode (desktop application)

```js
github.auth.config({
  username: 'pkumar',
  password: 'password'
}).login(['user', 'repo', 'gist'], function (token) {
  console.log(token);
});
```

- Authenticate to github in web mode (web application)

```js
// Web application which authenticates to github
var http = require('http');
var url = require('url');
var qs = require('querystring');

// Build the authorization config and url
var auth_url = github.auth.config({
  client_id: 'mygithubclientid',
  client_secret: 'mygithubclientsecret'
}).login(['user', 'repo', 'gist']);

// Web server
http.createServer(function (req, res) {
  uri = url.parse(req.url);
  // Redirect to github login
  if (uri.pathname=='/') {
    res.writeHead(301, {'Content-Type': 'text/plain', 'Location': auth_url})
    res.end('Redirecting to ' + auth_url);
  }
  // Callback url from github login
  else if (uri.pathname=='/auth') {
    github.auth.login(qs.parse(uri.query).code, function (token) {
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

- Build a client which accesses any public information

```js
var client = new github.client();

client.get('/users/pkumar', function (status, body) {
  console.log(body); //json object
});
```

- Build a client from an access token

```js
var client = new github.client('someaccesstoken');

client.get('/user', function (status, body) {
  console.log(body); //json object
});
```

__All the callbacks for the following will take only a data argument__

### Github authenticated user api
__Token required for the following__

- Get information about the user (GET /user)

```js
ghme.info(callback); //json
```

- Update user profile (PATCH /user)

```js
ghme.update({
  "name": "monalisa octocat",
  "email": "octocat@github.com",
  "blog": "https://github.com/blog",
  "company": "GitHub",
  "location": "San Francisco",
  "hireable": true,
  "bio": "There once..."
}, callback);
```

- Get emails of the user (GET /user/emails)

```js
ghme.emails(callback); //array of emails
```

- Set emails of the user (POST /user/emails)

```js
ghme.emails(['new1@ma.il', 'new2@ma.il'], callback); //array of emails
ghme.emails('new@ma.il', callback); //array of emails
```

- Delete emails of the user (DELETE /user/emails)

```js
ghme.emails(['new1@ma.il', 'new2@ma.il']);
ghme.emails('new@ma.il');
```

- Get the followers of the user (GET /user/followers)

```js
ghme.followers(callback); //array of github users
```

- Get users whom the user is following (GET /user/following)

```js
ghme.following(callback); //array of github users
```

- Check if the user is following a user (GET /user/following/marak)

```js
ghme.following('marak', callback); //boolean
```

- Follow a user (PUT /user/following/marak)

```js
ghme.follow('marak');
```

- Unfollow a user (DELETE /user/following/marak)

```js
ghme.unfollow('marak');
```

- Get public keys of a user (GET /user/keys)

```js
ghme.keys(callback); //array of keys
```

- Get a single public key (GET /user/keys/1)

```js
ghme.keys(1, callback); //key
```

- Create a public key (POST /user/keys)

```js
ghme.keys({"title":"laptop", "key":"ssh-rsa AAA..."}, callback); //key
```

- Update a public key (PATCH /user/keys/1)

```js
ghme.keys(1, {"title":"desktop", "key":"ssh-rsa AAA..."}, callback); //key
```

- Delete a public key (DELETE /user/keys/1)

```js
ghme.keys(1);
```

### Github users api
__No token required for the following__

- Get information about an user (GET /users/pkumar)

```js
ghuser.info(callback); //json
```

- Get an user followers (GET /users/pkumar/followers)

```js
ghuser.followers(callback); //array of github users
```

- Get an user followings (GET /users/pkumar/following)

```js
ghuser.following(callback); //array of github users
```

### Github repositories api
__No token required for the following__

- Get information about a repository (/repos/pkumar/octonode)

```js
ghrepo.info(callback); //json
```

### Github organizations api
__No token required for the following__

- Get information about an organization (/orgs/flatiron)

```js
ghorg.info(callback); //json
```

If you like this project, please watch this and follow me.

## Testing
```
npm test
```

## Contributors
Here is a list of [Contributors](http://github.com/pksunkara/octonode/contributors)

### TODO

```js
// public orgs for unauthenticated, private and public for authenticated
me.get_organizations(callback);

// public repos for unauthenticated, private and public for authenticated
me.get_repositories(callback);
me.create_repository({name: ''}, callback);
me.get_watched_repositories(callback);
me.is_watching('repo', callback);
me.start_watching('repo', callback);
me.stop_watching('repo', callback);
me.get_issues(params, callback);

// organization data
var org = octonode.Organization('bulletjs');

org.update(dict_with_update_properties, callback);
org.get_members(callback);
org.get_member('user', callback);
org.add_member('user', 'team', callback);
org.remove_member('user', callback);
org.get_public_members(callback);
org.is_public_member('user', callback);
org.make_member_public('user', callback);
org.conceal_member('user', callback);
org.get_teams(callback);
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
repo.get_contributors(callback);
repo.get_languages(callback);
repo.get_teams(callback);
repo.get_tags(callback);
repo.get_branches(callback);

// collaborator information
repo.get_collaborators(callback);
repo.has_collaborator('name', callback);
repo.add_collaborator('name', callback);
repo.remove_collaborator('name', callback);

// commit data
repo.get_commits(callback);
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

// fork data
repo.get_forks(callback);
repo.create_fork(callback);

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
repo.get_blob('sha-id', callback);
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
