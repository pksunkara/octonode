(function() {
  var Client, Gist, Me, Org, Repo, Team, User, request;

  request = require('request');

  Me = require('./me');

  User = require('./user');

  Repo = require('./repo');

  Org = require('./org');

  Gist = require('./gist');

  Team = require('./team');

  Client = (function() {

    function Client(token) {
      this.token = token;
    }

    Client.prototype.me = function() {
      return new Me(this);
    };

    Client.prototype.user = function(name) {
      return new User(name, this);
    };

    Client.prototype.repo = function(name) {
      return new Repo(name, this);
    };

    Client.prototype.org = function(name) {
      return new Org(name, this);
    };

    Client.prototype.gist = function() {
      return new Gist(this);
    };

    Client.prototype.team = function(id) {
      return new Team(id, this);
    };

    Client.prototype.query = function(path) {
      var uri;
      if (path == null) path = '/';
      if (path[0] !== '/') path = '/' + path;
      uri = "https://";
      uri += typeof this.token === 'object' ? "" + this.token.username + ":" + this.token.password + "@" : '';
      uri += "api.github.com" + path;
      return uri += typeof this.token === 'string' ? "?access_token=" + this.token : '';
    };

    Client.prototype.errorHandle = function(res, body, callback) {
      var _ref;
      if (Math.floor(res.statusCode / 100) === 5) {
        return callback(new Error('Error ' + res.statusCode));
      }
      try {
        body = JSON.parse(body || '{}');
      } catch (err) {
        return callback(err);
      }
      if (body.message && res.statusCode === 422) {
        return callback(new Error(body.message));
      }
      if (body.message && ((_ref = res.statusCode) === 400 || _ref === 401 || _ref === 404)) {
        return callback(new Error(body.message));
      }
      return callback(null, res.statusCode, body);
    };

    Client.prototype.get = function(path, headers, callback) {
      var _this = this;
      if (!callback || typeof headers === 'function') {
        callback = headers;
        headers = {};
      }
      return request({
        uri: this.query(path),
        method: 'GET',
        headers: headers
      }, function(err, res, body) {
        if (err) return callback(err);
        return _this.errorHandle(res, body, callback);
      });
    };

    Client.prototype.post = function(path, content, callback) {
      var _this = this;
      if (content == null) content = {};
      return request({
        uri: this.query(path),
        method: 'POST',
        body: JSON.stringify(content),
        headers: {
          'Content-Type': 'application/json'
        }
      }, function(err, res, body) {
        if (err) return callback(err);
        return _this.errorHandle(res, body, callback);
      });
    };

    Client.prototype.put = function(path, content, callback) {
      var _this = this;
      if (content == null) content = {};
      return request({
        uri: this.query(path),
        method: 'PUT',
        body: JSON.stringify(content),
        headers: {
          'Content-Type': 'application/json'
        }
      }, function(err, res, body) {
        if (err) return callback(err);
        return _this.errorHandle(res, body, callback);
      });
    };

    Client.prototype.del = function(path, content, callback) {
      var _this = this;
      if (content == null) content = {};
      return request({
        uri: this.query(path),
        method: 'DELETE',
        body: JSON.stringify(content),
        headers: {
          'Content-Type': 'application/json'
        }
      }, function(err, res, body) {
        if (err) return callback(err);
        return _this.errorHandle(res, body, callback);
      });
    };

    return Client;

  })();

  module.exports = function(token) {
    return new Client(token);
  };

}).call(this);
