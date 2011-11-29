# octonode - nodejs github library

## Description
octonode is a library for nodejs to access the [github v3 api](developer.github.com)

## Installation
```
npm install octonode
```

## Usage
The module exposes the objects `User`, `Organisation` and `Repository`
for interacting with the respective github entities.
All methods take at least a callback function as argument, which is
called with the result data after the method is finished. The callback
function should have the following signature:

```js
function(status, data)
{
  // do something with the data
  console.log(data);
};
```

Status is a string describing whether the function call was a success or
an error occurred and data is the actual result data. The status strings are
available from the octonode module for comparison:

```js
octonode.status = {
  SUCCESS: "success", // everything went great
  ERROR: "error",     // something went wrong
  NIMPL: "notimplemented" // method not yet implemented
};
```

Every object provides several method to interact with the entity it represents.

```js
var octonode = require('octonode');

var me = octonode.User('pkumar');

// work with email data
me.get_email_addresses(callback);
me.set_email_addresses(['new@mail.com', 'alsonew@mail.com'], callback);
me.set_email_addresses('new@mail.com', callback);
me.delete_email_addresses(['new@mail.com', 'alsonew@mail.com'], callback);
me.delete_email_addresses('new@mail.com', callback);

// follower data
me.get_followers(callback);
me.get_following(callback);
me.is_following('user', callback);
me.follow('user', callback);
me.unfollow('user', callback);

// key data
me.get_public_keys(callback);
me.get_public_key('id', callback);
me.add_public_key('title', 'key', callback);
me.update_public_key('title', 'key', callback);
me.delete_public_key('id', callback);

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
var org = octonode.Organisation('bulletjs')
org.info(callback);
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

var repo = octonode.Repository('pkumar/octonode');

// general repo information
repo.info(callback);
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

## Contributors
[Contributors](http://github.com/pkumar/octonode/contributors)

## License
MIT/X11

## Bug Reports
Report [here](http://github.com/pkumar/octonode/issues)

## Contact
Pavan Kumar Sunkara
[pavan [dot] sss1991 [at] gmail [dot] com](mailto:pavan.sss1991@gmail.com)

Follow me on [github](https://github.com/users/follow?target=pkumar), [twitter](http://twitter.com/pksunkara)
