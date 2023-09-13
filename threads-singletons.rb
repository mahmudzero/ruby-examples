require "singleton"

class SC
  def self.instance; Thread.current[:sc] ||= new; end

  attr_reader :cnt
  def initialize; @cnt = 0;  end
  def inc;        @cnt += 1; end
  def dec;        @cnt -= 1; end

  private; def self.new; super; end
end

class SM
  include Singleton
  def self.instance; Thread.current[:sm] ||= super; end

  attr_reader :cnt
  def initialize; @cnt = 0;  end
  def inc;        @cnt += 1; end
  def dec;        @cnt -= 1; end
end

def test_no_thread(klass)
  fst = klass.instance
  snd = klass.instance
  trd = klass.instance

  puts "#{klass.name} crt fst == snd == trd ? #{(fst == snd) && (trd == fst)}"

  fst.inc
  puts "#{klass.name} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
  snd.inc
  puts "#{klass.name} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
  trd.dec
  puts "#{klass.name} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
  puts ""
end

puts "no threads"
test_no_thread(SC)
test_no_thread(SM)

def test_thread(klass)
  threads = []
  insts   = {}
  (1..5).each do |idx|
    threads << Thread.new do
      fst = klass.instance
      snd = klass.instance
      trd = klass.instance

      puts "#{klass.name} thread: #{idx} crt fst == snd == trd ? #{(fst == snd) && (trd == fst)}"

      idx.times { fst.inc }
      puts "#{klass.name} thread: #{idx} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
      idx.times { snd.inc }
      puts "#{klass.name} thread: #{idx} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
      idx.times { trd.dec }
      puts "#{klass.name} thread: #{idx} inc fst == snd == trd ? #{fst.cnt} == #{snd.cnt} == #{trd.cnt}"
      insts[:"#{idx}"] = [ fst, snd, trd ]
    end
  end

  threads.each(&:join)

  unique = []
  insts.each do |k, v|
    unique << v.first.object_id if (v[0] == v[1]) && (v[0] == v[2])
  end
  puts "#{klass.name} unique: #{unique}"
  puts ""
end

puts "ys threads"
test_thread(SC)
test_thread(SM)
