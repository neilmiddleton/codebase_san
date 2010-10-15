codebase_san
============

codebase_san is an integration between the heroku_san gem and [CodebaseHQ](http://url.com/ "CodebaseHQ.com")

If you are using the heroku_san gem to deploy to [heroku](http://heroku.com) then adding this gem to your applications manifest
will add deployment notifications to your Codebase projects.

Installation
------------

Add the following to your Gemfile:

`group :development do
  gem 'codebase_san'
end`

This gem must only be used in applications that use Heroku, CodebaseHQ and Git.  You may be asked to configure the codebase gem on first use.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.