exit if (input = gets).nil?
n, k = input.split.map(&.to_u64)
fri = [] of Array(UInt64)
n.times do
    #exit if (input = gets).nil?
    #fri.push(input.split.map(&.to_i64))
    fri.push([rand(10_u64**5).to_u64, rand(10_u64**9).to_u64])
end
puts "ready!"
fri.sort_by(&.first)
now = 0_i64
while(1)
    now += k
    idx = fri.bsearch_index{ |x| x[0] > now }
    if idx.nil?
        idx = fri.size
    end
    break if idx == 0
    k = fri.delete_at(0, idx).sum(0_i64, &.last)
end
puts now