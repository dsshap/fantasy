web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -c 5 -q high,5 low,2 default