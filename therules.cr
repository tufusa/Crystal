# j2015 鈴木鷲也 夏休み課題 ソルバ crystal版

enum RuleKey
    Inverse; Type; Mode; Angle; Symbol; Value
end
enum RuleValue
    MSE; C; S
    L; I; A; V; H; P
    Less; Equal; Greater
end
EDGENUM = 6
adjacent = Array(Array(Bool)).new(EDGENUM){ Array(Bool).new(EDGENUM, false) }
paths = Array(Array(Int32)).new(EDGENUM){ [] of Int32 }
lines = Array(Array(Int32)).new
history = [] of Int32
intersections = Array(Int32).new(13, 0)
ans = [] of String
LINE_LIST = (0...EDGENUM).to_a.combinations(2)
INTER_LIST = [[] of Int32, [0, 1, 2], [5, 11, 12], [8, 9, 10], [] of Int32, [] of Int32, [2, 3, 4],
             [1, 7, 12], [0, 10, 11], [] of Int32, [4, 5, 6], [3, 9, 12], [] of Int32, [6, 7, 8], [] of Int32]
CORRECTION = { RuleValue::H => [-1, 0], RuleValue::V => [-1, 3], RuleValue::P => [1, 3] }

rules = Array(Array(Int32|RuleValue|Bool|Nil)).new
REGMSE = /^(?<Inverse>!?)(?<Type>MSE)$/
REGCNT = /^(?<Inverse>!?)(?<Type>C)((?<Mode>L|I)|((?<Mode>A)(?<Angle>30|60|90|120)))(?<Symbol><|=|>)(?<Value>\d+)$/
REGSYM = /^(?<Inverse>!?)(?<Type>S)(?<Mode>V|H|P)$/

puts "<Please input rule...>\n\n"
gets.not_nil!.tap{ print "Active Rule:" }.split.uniq.each do |rule|
    data = Array(Int32|RuleValue|Bool|Nil).new(6, nil)
    case rule
    when REGMSE then REGMSE.match(rule).not_nil!.named_captures.each{ |k, v| data[RuleKey.parse(k).value] = k == "Inverse" ? v == "!" : v && RuleValue.parse(v) }
    when REGCNT
        REGCNT.match(rule).not_nil!.named_captures.each do |k, v|
            next if !v
            case RuleKey.parse(k)
            when RuleKey::Symbol
                data[RuleKey::Symbol.value] =
                    case v
                    when "<" then RuleValue::Less
                    when "=" then RuleValue::Equal
                    when ">" then RuleValue::Greater
                    end
            when RuleKey::Inverse then data[RuleKey::Inverse.value] = v == "!"
            else data[RuleKey.parse(k).value] = v.to_i? ? v.to_i : RuleValue.parse(v)
            end
        end
    when REGSYM then REGSYM.match(rule).not_nil!.named_captures.each{ |k, v| data[RuleKey.parse(k).value] = k == "Inverse" ? v == "!" : v && RuleValue.parse(v) }
    else next
    end
    print " ", rule
    rules.push data
end
print "\n<Press Enter to start solution search...>"
gets

(1...2**LINE_LIST.size).each do |num|
    achievenum = 0
    paths.map! &.clear
    adjacent.map!{ |e| e.fill false }
    lines.clear
    intersections.fill 0
    history.clear

    (0...LINE_LIST.size).each do |i|
        next if num.bit(i) == 0
        bef, aft = LINE_LIST[i]
        lines.push LINE_LIST[i]
        adjacent[bef][aft] = adjacent[aft][bef] = true
        paths[bef].push aft
        paths[aft].push bef
    end
    
    odd = paths.map(&.size).count(&.odd?)
    next if ![0, 2].includes? odd

    adjclone = adjacent.clone
    que = [paths.index{ |x| odd == 2 ? x.size.odd? : x.size > 0 }]
    while(!que.empty?)
        moved = (0...EDGENUM).each do |aft|
            if adjclone[que[-1].not_nil!][aft]
                adjclone[que[-1].not_nil!][aft] = adjclone[aft][que[-1].not_nil!] = false
                que.push aft
                break true
            end
        end
        history.push que.pop.not_nil! if !moved
    end

    next if history.size - 1 != lines.size

    rules.each do |rule|
        achieve = false
        case rule[RuleKey::Type.value]
        when RuleValue::MSE
            achieve = odd == 0
        when RuleValue::C
            count = 0
            case rule[RuleKey::Mode.value]
            when RuleValue::L
                count = lines.size
            when RuleValue::A
                (0...EDGENUM).each do |i|
                    paths[i].map{ |n| (n - i) % EDGENUM }.sort.each_cons 2 do |con|
                        a, b = con
                        count += 1 if b - a == rule[RuleKey::Angle.value].try{ |x| x.is_a?(Int32) && x // 30 }
                    end
                end
            when RuleValue::I
                lines.each do |line|
                    bef, aft = line
                    INTER_LIST[14 - (5 - bef) * (6 - bef) // 2 + aft - bef].each{ |i| intersections[i] += 1 }
                end
                count = intersections.count{ |x| x >= 2 }
            end
            value = 0
            rule[RuleKey::Value.value].try{ |x| x.is_a?(Int32) && (value = x) }
            case rule[RuleKey::Symbol.value]
            when RuleValue::Less
                achieve = count < value
            when RuleValue::Equal
                achieve = count == value
            when RuleValue::Greater
                achieve = count > value
            end
        when RuleValue::S
            corr = CORRECTION[rule[RuleKey::Mode.value]]
            achieve = !(0...EDGENUM).each do |a|
                break true if paths[a].each do |b|
                    break true if !adjacent[(corr[0] * a + corr[1]) % 6][(corr[0] * b + corr[1]) % 6]
                end
            end
        end
        achieve = !achieve if rule[RuleKey::Inverse.value]
        achievenum += 1 if achieve
    end
    if achievenum == rules.size
        ans.push history.to_s
    end
end

puts ans.join "\n"
if ans.empty?
    puts "Solution not found:("
else
    puts "\n#{ ans.size } solution#{ ans.size > 1 ? "s" : nil } found."
end
print "\n<Press Enter to exit...>"
gets