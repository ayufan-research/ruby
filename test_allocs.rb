def stats
  s=GC.stat
  puts(count: s[:count], slots: s[:heap_live_slots], objects: s[:total_allocated_objects])
end

def difference(s, e, times, keys = e.keys)
  result = {}

  keys.each do |key|
    diff = e[key] - s[key].to_i
    result[key] = diff
    result[:"#{key}_per"] = diff.to_f / times
  end

  result
end

def with_diff(times: 1)
  s_start = GC.stat
  t_start = Thread.current.stat
  i = 0
  while i < times
    yield
    i += 1
  end
  s_end = GC.stat
  t_end = Thread.current.stat

  {
    gc: difference(s_start, s_end, times, [:count, :heap_live_slots, :total_allocated_objects, :malloc_increase_bytes, :total_freed_objects]),
    thread: difference(t_start, t_end, times),
  }
end

def with_many_threads(threads: 1)
  thrs = threads.times.map.with_index do |idx|
    Thread.new { yield(idx) }
  end

  thrs
    .map(&:join)
    .map(&:value)
end

result = with_many_threads(threads: 5) do |idx|
  with_diff(times: 100) do
    text = '0' * (4096 * idx)
    idx.times do
      { aa: 10 }.dup
    end
    sleep(0.001)
  end
end

pp result
