require 'torch'

function test(r)
    r[1] = 2
end
r = torch.Tensor(2)
print(r[1])
test(r)
print(r[1])
