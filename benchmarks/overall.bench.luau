--!native
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Squash = require(ReplicatedStorage.Squash)

local Amount = 2500

local function rand(): number
    return (math.random() - 0.5) * 2000000
end

local function enumCount(count: number, enum: Enum, transform: ((any) -> any)?): {any}
    local out = table.create(count)

    local selection: {EnumItem} = enum:GetEnumItems()

    for i = 1,count do
        local selected = selection[math.random(1,#selection)]
        if transform then selected = transform(selected) end
        table.insert(out, selected)
    end

    return out
end

local function vectorCount(count: number): {any}
    local out = table.create(count)

    for i = 1,count do
        table.insert(out, Vector3.new(rand(),rand(),rand()))
    end

    return out
end

local function cframeCount(count: number): {any}
    local out = table.create(count)

    for i = 1,count do
        table.insert(out, CFrame.new(rand(),rand(),rand(),rand(),rand(),rand(),rand(),rand(),rand(),rand(),rand(),rand()))
    end

    return out
end

local RandomData: {[string]: {Type: string, Data: {any}, Serdes: any?}} = {
    Axes = {
        Type = "Axes",
        Data = enumCount(Amount, Enum.NormalId, Axes.new)
    },
    Vector3 = {
        Type = "Vector3",
        Serdes = Squash.number(8),
        Data = vectorCount(Amount)
    },
    CFrame = {
        Type = "CFrame",
        Serdes = Squash.number(8),
        Data = cframeCount(Amount)
    }
}

local Functions = {}

for i,v in pairs(RandomData) do
    Functions[i] = function(Profiler)
        local data = v.Data
        local ser = Squash[i](v.Serdes).ser
        local Cursor = Squash.cursor()

        Profiler.Begin("Serialize")
            for i,v in pairs(data) do
                ser(Cursor,v)
            end
        Profiler.End()
    end
end

return {
	Functions = Functions
}
