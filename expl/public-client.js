/*
 * Get info about a public user
 */
var github = require('../lib/octonode');

/*
 * Build a client without any token or authentication
 */
var client = new github.client();

client.get('/users/pkumar', function (s, b) {
  console.log(b);
});
