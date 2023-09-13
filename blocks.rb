def do_yield(fst, snd, kw:, &block)
  # if block
  if block_given?
    [0, 1, 2, 3, 4].each do |i|
      block.call(i, i+1, i+2, kv: 'foo')
    end
  end

  return -5
end

puts do_yield('one', 'two', kw: 5)

do_yield('one', 'two', kw: 5) do |*args, **kwargs|
  puts "#{args.join(',')} --- #{kwargs}"
end
