require_relative './scientist.rb'

workspace = "/path/to/my/workspace"
target = "//my:target"

# Create your Control invocation
control = BazelInvocation.new
          .set_workspace(workspace)
          .set_target(target)
          .set_label("jobs_default")
          .clean # Do a `bazel clean` before each build
          .sandboxing(false) # Disable sandboxing with --spawn_strategy=standalone
          .profiling(true) # Enable profilng with --profile=${label}_prof.dat

# Create the Candidate invocation with something changed.
candidate = BazelInvocation.new
          .set_workspace(workspace)
          .set_target(target)
          .set_label("jobs_2")
          .clean
          .sandboxing(false)
          .profiling(true)
          .add_flag("--jobs=2") # Limit the number of jobs to 2

# Set your environment variables
ENV['ANDROID_HOME'] = '/path/to/sdk'

# Create an experiment with the two invocations
sandbox_experiment = Experiment.new(control, candidate)
sandbox_experiment.warmup_runs = 1
sandbox_experiment.measured_runs = 3

# Run it
sandbox_experiment.run!
