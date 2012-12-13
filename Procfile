web: bundle exec thin start -p $PORT -e $RACK_ENV
default: env HEROKU_PROCESS=default bundle exec sidekiq -c 4 -e $RACK_ENV