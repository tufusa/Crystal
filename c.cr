exit if (input = gets).nil?
n, m = input.split.map(&.to_i)
path = [] of Array(Int32)
m.times do
    input = gets
    if input.nil?
        exit
    else
        path.push(input.split.map(&.to_i))
    end
end
bef = [] of Array(Int32)
n.times{ bef.push([] of Int32) }
path.each do |pt|
    bef[pt[1] - 1].push(pt[0])
end
while(1)
    flag = 0
    i = 0
    while(1)
        temp = bef[i]
        bef[i].each do |t|
            temp = (temp + bef[t - 1]).uniq - [i + 1]
        end
        if ! (temp == bef[i])
            flag = 1
        end
        bef[i] = temp
        i += 1
        break if i == n
    end
    break if flag == 0
end
puts bef.sum{ |a| a.size + 1 }