web: bundle exec puma -C config/puma.rb
worker: env QUEUE=* bundle exec rake environment resque:work
scheduler: PIDFILE=./resque-scheduler.pid BACKGROUND=yes rake resque:scheduler
