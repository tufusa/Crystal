question = "コンピューターシステムの設計仕様のことを、「建築学」という意味の英語で何というでしょう？"
correct = "アーキテクチャ"

slash = false
spawn do
    input = STDIN.noecho &.gets.not_nil!.chomp
    puts
    slash = true
end

Fiber.yield

question.each_char do |c|
    break if slash
    print c
    sleep 0.1
end

input = gets.not_nil!.chomp
puts correct == input ? "Correct!" : "Wrong!"