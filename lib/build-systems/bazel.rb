require 'open3'

class BazelInvocation

  attr_reader :workspace, :label, :wall_millis

  def initialize
    @startup_flags = []
    @build_flags = []

    @target = nil
    @workspace = Dir.pwd

    @clean = false
    @expunge = false

    @is_profiling = false
    @is_sandboxed = true

    @label = "invocation"
    @wall_millis = nil
  end

  def invoke!(dry_run: false)
    Dir.chdir(@workspace) do
      command = build_command
      puts "\nRunning Bazel command: #{command}"

      timed_command = "TIMEFORMAT='%R' && { time #{command} >/dev/null 2>&1 ; }"
      unless dry_run
        `bazel clean >/dev/null 2>&1` if @clean
        `bazel clean --expunge >/dev/null 2>&1` if @expunge

        # time(1) logs to stderr
        _, stderr, _ = Open3.capture3(timed_command)
        @wall_millis = (stderr.strip.to_f * 1000).to_i
      end
    end

    self
  end

  def clean
    @clean = true
    self
  end

  def expunge
    @expunge = true
    self
  end

  def set_label(label)
    @label = label
    self
  end

  def set_workspace(path)
    @workspace = path
    self
  end

  def set_target(target)
    @target = target
    self
  end

  def enable_aapt2
    @build_flags.push "--android_aapt=aapt2"
    self
  end

  def sandboxing(is_sandboxed)
    @is_sandboxed = is_sandboxed
    self
  end

  def profiling(is_profiling)
    @is_profiling = is_profiling
    self
  end

  def add_flag(flag)
    @build_flags.push flag
    self
  end

  private

  def build_command
    fail("Please specify a target.") if @target.nil?

    command_ary = ["bazel"] + @startup_flags + ["build", @target.to_s] + @build_flags
    command_ary.push("--profile=#{@label}_prof.dat") if @is_profiling
    command_ary.push("--spawn_strategy=standalone") unless @is_sandboxed
    command_ary.join(" ")
  end

end
