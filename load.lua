require "lfs"
require 'torch'
require 'image'

function readImg(path, cropImgs, labels, index)
    index = string.find(path, "_", 1, true)
    if index == nil then
        index = string.find(path, ".", 1, true)
    end
    digitLength=index - 1
    rets = path.sub(path, 1,index - 1)
    print(rets)
    img = image.load("img/"..path)
    c = {image.crop(img, 0,0,50,50), image.crop(img,25,0,75,50), image.crop(img, 55,0,105,50), image.crop(img, 75,0,125,50) }
    --c2 = image.crop(img,25,0,75,50)
    --c3 = image.crop(img, 55,0,105,50)
    --c4 = image.crop(img, 75,0,125,50)
    for i = 1,digitLength do
        --print(rets.sub(path, i, i))
        --print(c[i]:size())
        cropImgs[index] = c[i]
        labels[1][index] = string.byte(rets.sub(path, i, i))
        index = index + 1
    end
    return index
end

function walkDir(path, cropImgs, labels, fileCount)
    local index = 1
    for file in lfs.dir(path) do
        local fullPath = path..'/'..file
        if lfs.attributes(file) == nil then
            --print(lfs.attributes(file))
            index = readImg(file, cropImgs, labels, index)
            --index += 1
        end
    end
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
fileCount = getDirFileCount('img')
print("Total count of image is "..fileCount)
cropImgs = torch.Tensor(fileCount * 4, 3, 50, 50)
labels = torch.ByteTensor(1, fileCount * 4)
walkDir('img', cropImgs, labels)
result = {}
result.x = cropImgs
result.Y = labels
torch.save("img.t7", result, "ascii")
