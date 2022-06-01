class Delta
    @m : UInt32
    @line : UInt32
    def initialize(line, modulo)
        @m = modulo
        @memo = [[1] of UInt64?]
        @line = line
        (1..line).each{|i| @memo.push(Array(UInt64?).new(i + 1, nil))}
    end
    def delta(n, r)
        return 0_u64 if r < 0 || r > n
        return @memo[n][r].not_nil! if @memo[n]? && @memo[n][r]?
        value = delta(n - 1, r - 1) * (n - r + 1) + delta(n - 1, r)
        value %= @m if @m != 0
        return @memo[n][r] = value
    end
    def puts
        if @m == 0
            puts (0...@line).map{|n| @memo[n].join(" ")}.join("\n")
        else
            puts (0...@line).map{|n| @memo[n].map{ |v| v.not_nil! % 2 == 0 ? '#' : '.' }.join(" ")}.join("\n")
        end
    end
end

while(true)
    print "\nLine(exit at 0) > "
    line = gets.not_nil!.to_u32
    exit if line == 0
    print "Modulo(disabled at 0) > "
    modulo = gets.not_nil!.to_u32

    d = Delta.new(line, modulo)
    (0...line).each{|r| d.delta(line - 1, r) }
    d.puts
end