# This rake task was added by annotate_rb gem.

# Can set `ANNOTATERB_SKIP_ON_DB_TASKS` to be anything to skip this
if Rails.env.development? && ENV['ANNOTATERB_SKIP_ON_DB_TASKS'].nil?
  require 'annotate_rb'

  # Config path defaults to .annotaterb.yml in the root of the project. To change it:
  # AnnotateRb::ConfigFinder.config_path = ""
  AnnotateRb::Core.load_rake_tasks
end
