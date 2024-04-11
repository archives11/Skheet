local function execute(path, r)
    if r then
        return loadstring(readfile(tostring("skheet/" .. path .. ".lua")))()
    else
        loadstring(readfile(tostring("skheet/" .. path .. ".lua")))()
    end 
end

execute("ui")
execute("source")