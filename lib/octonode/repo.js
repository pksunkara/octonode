(function() {
  var Repo;

  Repo = (function() {

    function Repo(name, client) {
      this.name = name;
      this.client = client;
    }

    Repo.prototype.info = function(cb) {
      return this.client.get("/repos/" + this.name, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo info error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.commits = function(cb) {
      return this.client.get("/repos/" + this.name + "/commits", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo commits error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.tags = function(cb) {
      return this.client.get("/repos/" + this.name + "/tags", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo tags error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.languages = function(cb) {
      return this.client.get("/repos/" + this.name + "/languages", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo languages error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.contributors = function(cb) {
      return this.client.get("/repos/" + this.name + "/contributors", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo contributors error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.teams = function(cb) {
      return this.client.get("/repos/" + this.name + "/teams", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo teams error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.branches = function(cb) {
      return this.client.get("/repos/" + this.name + "/branches", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo branches error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.issues = function(cb) {
      return this.client.get("/repos/" + this.name + "/issues", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo issues error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.forks = function(cb) {
      return this.client.get("/repos/" + this.name + "/forks", function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo forks error"));
        } else {
          return cb(null, b);
        }
      });
    };

    Repo.prototype.blob = function(sha, cb) {
      return this.client.get("/repos/" + this.name + "/git/blobs/" + sha, {
        Accept: 'application/vnd.github.raw'
      }, function(err, s, b) {
        if (err) return cb(err);
        if (s !== 200) {
          return cb(new Error("Repo blob error"));
        } else {
          return cb(null, b);
        }
      });
    };

    return Repo;

  })();

  module.exports = Repo;

}).call(this);
