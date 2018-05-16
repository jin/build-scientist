class Experiment

  attr_accessor :warmup_runs, :measured_runs, :measure

  def initialize(invocation_a, invocation_b)
    @invocation_a = invocation_a
    @invocation_b = invocation_b
    @warmup_runs = 1
    @measured_runs = 1
    @measure = :median
  end

  def run!
    1.upto @warmup_runs do |idx|
      puts "Warmup run. Iteration #{idx}"
      @invocation_a.invoke!
      @invocation_b.invoke!
    end

    a_ary = []
    b_ary = []

    1.upto @measured_runs do |idx|
      puts "Measured run. Iteration #{idx}"
      @invocation_a.invoke!
      a_ary.push(@invocation_a.wall_millis)

      @invocation_b.invoke!
      b_ary.push(@invocation_b.wall_millis)
    end

    puts "#{@invocation_a.label}: #{a_ary}"
    puts "#{@invocation_b.label}: #{b_ary}"
  end

end
