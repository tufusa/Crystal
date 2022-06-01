num = 12
line = 4
count = 0
s = Array.new(line, 0)
class Array
    def s(x : Int32, y : Int32)
        self[x..y].sum
    end
end
(1..num).to_a.each_permutation do |c|
    break
    s[0] = c.s(0, 3)
    s[1] = c.s(3, 6)
    s[2] = c.s(6, 9)
    s[3] = c.s(9, 11) + c[0]
    if s.uniq.one?
        count += 1
        puts c
    end
end
puts count == 0 ? "SOLUTION NOT FOUND:(" : "#{count} SOLUTION FOUND"