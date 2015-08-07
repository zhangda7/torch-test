require "lfs"
require 'torch'
require 'image'


function readImg(path, index)
    print(path)
    -- only for 4 digits now
    subIndex = string.find(string.reverse(path), "/", 1, true)
    --if index == nil then
    --    index = string.find(path, ".", 1, true)
    --end
    rets = path.sub(path, string.len(path) - subIndex + 2, string.len(path))
    print(rets)
    digitLength=4
    img = image.load(path)
    c = {image.crop(img, 0,0,50,50), image.crop(img,25,0,75,50), image.crop(img, 55,0,105,50), image.crop(img, 75,0,125,50) }
    for i = 1,digitLength do
        --print(c[i]:size())
        print("index:"..index)
        result.X[index] = c[i]
        result.y[1][index] = string.byte(rets.sub(rets, i, i))
        index = index + 1
    end
    --print(result.X[2][1])
    return index
end

function walkDir(path, index)
    for file in lfs.dir(path) do
        local fullPath = path..'/'..file
        if lfs.attributes(file) == nil then
            index = readImg(path.."/"..file, index)
        end
    end
    --print(result.X[2][1])
    return index
end

function getDirFileCount(path)
    local count = 0
    for file in lfs.dir(path) do
        local fullPath = path..'/'..file
        if lfs.attributes(file) == nil then
            count = count + 1
        end
    end
    return count
end

print("===== Begin =====")
indexDict={}
dirs = {'/root/code/torch-test/img', '/root/code/torch-test/img2'}
fileCount = 0
for index, value in ipairs(dirs) do
    print(value)
    fileCount = getDirFileCount(value) + fileCount
end
print("Total count of image is "..fileCount)
result = {}
result.X = torch.Tensor(fileCount * 4, 3, 50, 50)
result.y = torch.ByteTensor(1, fileCount * 4)
imgIndex = 1
for index, value in ipairs(dirs) do
    imgIndex = walkDir(value, imgIndex)
end
--print(result.X[2][1])
torch.save("img.t7", result, "ascii")
