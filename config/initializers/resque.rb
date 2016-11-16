rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'

Resque.logger.formatter = Resque::VeryVerboseFormatter.new
Resque.redis = ENV['REDIS_URL'] || 'localhost'

# Important: 
# In order to delete dynamic schedules via resque-web in the "Schedule" tab, you must include the Rack::MethodOverride 
# middleware (in config.ru or equivalent). More info: https://github.com/resque/resque-scheduler
Resque::Scheduler.dynamic = true
Resque.schedule = YAML.load_file( rails_root + '/config/resque-schedule.yml')