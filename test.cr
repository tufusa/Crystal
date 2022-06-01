require "benchmark"
data = Array(Int32|String|Nil).new(6, nil)
data[0] = 1
data[2] = "a"
p data.compact!
enum Data
    Inverse; Type; Mode; Angle; Symbol; Value
    MSE; C; S
    L; I; A; V; H; P
    Less; Equal; Greater
end
p Data::Value.value
p Data::MSE.value
h = { :str2 => 1, 0 => 0 }
t = 10**9
Benchmark.bm do |x|
    x.report "normal" do
        data.fill(nil)
    end
    x.report "string" do
        data = Array(Int32|String|Nil).new(6, nil)

    end
end