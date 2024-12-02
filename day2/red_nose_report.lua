-- read the content of a file organized as rows of numbers separated by a space.
local function read_file(path)
    local data = {}
    for line in io.lines(path) do
        local words = {}
        for word in line:gmatch("%S+") do
            table.insert(words, tonumber(word))
        end
        table.insert(data, words)
    end
    return data
end

-- get the length of a table
local function len(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- convert a bool to an integer (if true get 1, 0 otherwise)
local function bool2int(bool)
    if bool then return 1 else return 0 end
end

local function is_safe(report)
    local prev = nil
    local sign = nil -- 0 means decrease, 1 means increase
    for _, level in ipairs(report) do
        if prev ~= nil then
            local diff = level - prev
            if math.abs(diff) < 1 or math.abs(diff) > 3 then
                return false
            end
            if sign ~= bool2int(diff > 0) and sign ~= nil then return false end
            sign = bool2int(diff > 0)
        end
        prev = level
    end
    return true
end

local function task1()
    local data = read_file("data.txt")
    local safe_rows = {}
    for _, row in ipairs(data) do
        if is_safe(row) then
            table.insert(safe_rows, row)
        end
    end
    print(len(safe_rows))
end

local function copy_table(t)
    local new_t = {}
    for _, v in ipairs(t) do
        table.insert(new_t, v)
    end
    return new_t
end

local function shorter_reports(report)
    local result = {}
    for i, _ in ipairs(report) do
        local report_copy = copy_table(report)
        table.remove(report_copy, i)
        table.insert(result, report_copy)
    end
    return result
end

local function is_tolerably_safe(report)
    if is_safe(report) then return true
    else
        for _, rep in ipairs(shorter_reports(report)) do
            if is_safe(rep) then return true end
        end
    end
    return false
end

local function task2()
    local data = read_file("data.txt")
    local safe_rows = {}
    for _, row in ipairs(data) do
        if is_tolerably_safe(row) then
            table.insert(safe_rows, row)
        end
    end
    print(len(safe_rows))
end

print("Task 1")
task1()
print("Task 2")
task2()
