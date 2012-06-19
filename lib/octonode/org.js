(function() {
  var Org;

  Org = (function() {

    function Org(name, client) {
      this.name = name;
      this.client = client;
    }

    Org.prototype.info = function(cb) {
      return this.client.get("/orgs/" + this.name, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Org info error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Org.prototype.repos = function(cbOrRepo, cb) {
      if (typeof cb === 'function' && typeof cbOrRepo === 'object') {
        return this.createRepo(cbOrRepo, cb);
      } else {
        return this.client.get("/orgs/" + this.name + "/repos", function(err, s, b) {
          if (err) return cb(err);
          if (s !== 200) {
            return cb(new Error('Org repos error'));
          } else {
            return cb(null, b);
          }
        });
      }
    };

    Org.prototype.createRepo = function(repo, cb) {
      return this.client.post("/orgs/" + this.name + "/repos", repo, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 201) {
          return cb(new Error('Org createRepo error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Org.prototype.teams = function(cb) {
      return this.client.get("/orgs/" + this.name + "/teams", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Org teams error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Org.prototype.members = function(cb) {
      return this.client.get("/orgs/" + this.name + "/members", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error('Org members error'));
        } else {
          return cb(null, b);
        }
      });
    };

    Org.prototype.member = function(user, cb) {
      return this.client.get("/orgs/" + this.name + "/members/" + user, function(err, s, b) {
        if (err) return cb(err);
        return cb(null, s === 204);
      });
    };

    return Org;

  })();

  module.exports = Org;

}).call(this);
