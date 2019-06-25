// Requiring modules
const nock = require('nock');

// Mocking normal api
const viewNock = nock('https://api.github.com');

// Mocking api with body
const viewBodyNock = viewNock.matchHeader('Content-Type', 'application/json');
const authBodyNock = authNock.matchHeader('Content-Type', 'application/json');

// Module exports
module.exports = {

  // Common function
  body(path, body, code, data, headers, fn) {
    return fn(path, JSON.stringify(body)).reply(code, JSON.stringify(data), headers);
  },

  // Oauth authorization
  oauth() {},

  // Basic authorization
  basic() {},

  // Public API
  viewGet(path, code, data, headers) {
    if (headers == null) { headers = {}; }
    return viewNock.get(path).reply(code, JSON.stringify(data), headers);
  },

  viewPost(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, viewBodyNock.post);
  },

  viewPut(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, viewBodyNock.put);
  },

  viewDel(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, viewBodyNock.delete);
  },

  // Private API
  authGet(path, code, data, headers) {
    return authNock.get(path).reply(code, JSON.stringify(data), headers);
  },

  authPost(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, authBodyNock.post);
  },

  authPut(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, authBodyNock.put);
  },

  authDel(path, body, code, data, headers) {
    if (body == null) { body = {}; }
    return this.body(path, body, code, data, headers, authBodyNock.delete);
  }
};
