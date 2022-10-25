pool = (0..9).to_a

class Array
    def sum5(a, b, c, d, e)
        10000 * self[a] + 1000 * self[b] + 100 * self[c] + 10 * self[d] + self[e]
    end
end

pool.each_permutation(8) do |s| #SATOREPN
    if s.sum5(0, 1, 2, 3, 4) - s.sum5(1, 4, 5, 6, 3) + s.sum5(2, 5, 7, 5, 2) - s.sum5(3, 6, 5, 4, 1) == s.sum5(4, 3, 2, 1, 0)
        print s, '\n'
    end
end