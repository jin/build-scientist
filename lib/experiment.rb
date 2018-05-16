class Experiment

  attr_accessor :warmup_runs, :measured_runs, :measure

  def initialize(control_invocation, candidate_invocation)
    @control_invocation = control_invocation
    @candidate_invocation = candidate_invocation
    @warmup_runs = 1
    @measured_runs = 1
    @measure = :median
  end

  def run!
    control_results = run_control!
    candidate_results = run_candidate!

    puts "#{@control_invocation.label}: #{control_results}"
    puts "#{@candidate_invocation.label}: #{candidate_results}"
  end

  private

  def run_control!
    1.upto @warmup_runs do |idx|
      puts "Warmup run for control: Iteration #{idx}"
      @control_invocation.set_label "control_warmup"
      @control_invocation.invoke!
    end

    control_ary = []
    1.upto @measured_runs do |idx|
      puts "Measured run for control: Iteration #{idx}"
      @control_invocation.set_label "control_measured_#{idx}"
      control_ary.push(@control_invocation.invoke!.wall_mills)
    end

    control_ary
  end

  def run_candidate!
    # Candidate runs
    1.upto @warmup_runs do |idx|
      puts "Warmup run for candidate: Iteration #{idx}"
      @control_invocation.set_label "candidate_warmup"
      @candidate_invocation.invoke!
    end

    candidate_ary = []
    1.upto @measured_runs do |idx|
      puts "Measured run for candidate: Iteration #{idx}"
      @candidate_invocation.set_label "candidate_measured_#{idx}"
      candidate_ary.push(@candidate_invocation.invoke!.wall_millis)
    end

    candidate_ary
  end

end
