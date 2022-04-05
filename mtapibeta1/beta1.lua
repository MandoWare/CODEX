newcclosure(
if not getgenv().MTAPIDebug and getgenv().MTAPIMutex ~= nil then
    return
end
local a = function()
    if is_protosmasher_caller ~= nil then
        return 0
    end
    if elysianexecute ~= nil then
        return 1
    end
    if fullaccess ~= nil then
        return 2
    end
    if syn ~= nil then
        return 3
    end
    return 4
end
local function b()
    local c = a()
    if c == 0 then
        return is_protosmasher_caller
    end
    if c == 1 or c == 3 then
        return checkcaller
    end
    if c == 2 then
        error("mt-api: Exploit not supported")
    end
    return nil
end
local d = {}
local e = {}
local f = {}
local g = {}
local h = {}
local i = {}
local j = {}
local k = {}
local l = {}
local m = 0
local n = 0
local o = 0
local function p()
    if not getrawmetatable then
        error("mt-api: Exploit not supported")
    end
    local c = a()
    local q = b()
    local r = getrawmetatable(game)
    if c == 0 then
        make_writeable(r)
    elseif c == 2 then
        error("mt-api: Exploit not supported")
    else
        if setreadonly then
            setreadonly(r, false)
        else
            error("mt-api: Exploit not supported")
        end
    end
    local s = r.__index
    local t = r.__newindex
    local u = r.__namecall
    r.__index =
        newcclosure(
        function(self, v)
            if not getgenv().MTAPIDebug and q() then
                return s(self, v)
            end
            if d[self] and d[self][v] then
                local w = d[self][v]
                if w.IsCallback then
                    return w.Value(self, s(self, v)) or s(self, v)
                else
                    return w.Value or s(self, v)
                end
            elseif h[self] and h[self][v] then
                local x = h[self][v].Emulator
                return x[1]
            else
                for y, z in next, i do
                    if z[v] then
                        local A = z[v]
                        if A.IsCallback then
                            return A.Value(self) or s(self, v)
                        else
                            return A.Value or s(self, v)
                        end
                        break
                    end
                end
            end
            return s(self, v)
        end
    )
    r.__newindex =
        newcclosure(
        function(self, v, B)
            if not getgenv().MTAPIDebug and q() then
                return t(self, v, B)
            end
            if f[self] and f[self][v] then
                local C = f[self][v]
                if C.IsCallback then
                    local D = C.Value(self, B)
                    return t(self, v, D or B)
                else
                    return t(self, v, C.Value or B)
                end
            elseif e[self] and e[self][v] then
                return
            elseif h[self] and h[self][v] then
                local x = h[self][v].Emulator
                x[1] = B
                return
            else
                for y, z in next, j do
                    if z[v] then
                        local E = z[v]
                        if E.IsCallback then
                            local D = E.Value(self, B)
                            return t(self, v, D or B)
                        else
                            return t(self, v, E.Value or B)
                        end
                        break
                    end
                end
                for y, z in next, l do
                    if z[v] then
                        return
                    end
                end
            end
            return t(self, v, B)
        end
    )
    r.__namecall =
        newcclosure(
        function(self, ...)
            local F = {...}
            local G = getnamecallmethod()
            if q() then
                if getgenv()["MTAPISuperUser"] then
                    local H = tostring(self) .. ":" .. tostring(G) .. "("
                    local I = ""
                    local J = ""
                    for y, z in next, F do
                        I = I .. tostring(z) .. ", "
                        J = J .. typeof(z) .. ", "
                    end
                    I = I:sub(1, -3)
                    J = J:sub(1, -3)
                    H = H .. I .. ") (" .. J .. ")"
                    rconsolewarn(H)
                end
                if G == "AddGetHook" then
                    if #F < 1 then
                        error("mt-api: Invalid argument count")
                    end
                    local K = self
                    local v = F[1]
                    local L = F[2]
                    if type(v) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    if not d[self] then
                        d[self] = {}
                    end
                    d[self][v] = {Value = L, IsCallback = type(L) == "function"}
                    local function M()
                        d[self][v] = nil
                    end
                    local function N(O, P)
                        d[self][v] = {Value = P, IsCallback = type(P) == "function"}
                    end
                    return {remove = M, Remove = M, modify = N, Modify = N}
                elseif G == "AddGlobalGetHook" then
                    if #F < 1 then
                        error("mt-api: Invalid argument count")
                    end
                    local K = self
                    local v = F[1]
                    local L = F[2]
                    if type(v) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    n = n + 1
                    if not i[n] then
                        i[n] = {}
                    end
                    i[n][v] = {Value = L, IsCallback = type(L) == "function"}
                    local function M()
                        i[n][v] = nil
                    end
                    local function N(O, P)
                        i[n][v] = {Value = P, IsCallback = type(P) == "function"}
                    end
                    return {remove = M, Remove = M, modify = N, Modify = N}
                elseif G == "AddSetHook" then
                    local K = self
                    local v = F[1]
                    local L = F[2]
                    if type(v) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    if L ~= nil then
                        if not f[self] then
                            f[self] = {}
                        end
                        f[self][v] = {Value = L, IsCallback = type(L) == "function"}
                        local function M()
                            f[self][v] = nil
                        end
                        local function N(O, P)
                            f[self][v] = {Value = P, IsCallback = type(P) == "function"}
                        end
                        return {remove = M, Remove = M, modify = N, Modify = N}
                    else
                        if not e[self] then
                            e[self] = {}
                        end
                        e[self][v] = true
                        local function M()
                            e[self][v] = nil
                        end
                        local function N()
                            return
                        end
                        return {remove = M, Remove = M, modify = N, Modify = N}
                    end
                elseif G == "AddGlobalSetHook" then
                    local K = self
                    local v = F[1]
                    local L = F[2]
                    if type(v) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    if L ~= nil then
                        o = o + 1
                        if not j[o] then
                            j[o] = {}
                        end
                        j[o][v] = {Value = L, IsCallback = type(L) == "function"}
                        local function M()
                            j[o][v] = nil
                        end
                        local function N(O, P)
                            j[o][v] = {Value = P, IsCallback = type(P) == "function"}
                        end
                        return {remove = M, Remove = M, modify = N, Modify = N}
                    else
                        o = o + 1
                        if not l[o] then
                            l[o] = {}
                        end
                        l[o][v] = true
                        local function M()
                            l[o][v] = nil
                        end
                        local function N(O, P)
                            if type(P) == "boolean" then
                                l[o][v] = P
                            end
                        end
                        return {remove = M, Remove = M, modify = N, Modify = N}
                    end
                elseif G == "AddCallHook" then
                    local K = self
                    local functionName = F[1]
                    local Q = F[2]
                    if type(Q) ~= "function" or type(functionName) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    if not g[self] then
                        g[self] = {}
                    end
                    g[self][functionName] = {Callback = Q}
                    local function M()
                        g[self][functionName] = nil
                    end
                    local function N(O, P)
                        g[self][functionName] = {Callback = P}
                    end
                    return {remove = M, Remove = M, modify = N, Modify = N}
                elseif G == "AddGlobalCallHook" then
                    local K = self
                    local functionName = F[1]
                    local Q = F[2]
                    if type(Q) ~= "function" or type(functionName) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    m = m + 1
                    if not k[m] then
                        k[m] = {}
                    end
                    k[m][functionName] = {Callback = Q}
                    local function M()
                        k[m][functionName] = nil
                    end
                    local function N(O, P)
                        k[m][functionName] = {Callback = P}
                    end
                    return {remove = M, Remove = M, modify = N, Modify = N}
                elseif G == "AddPropertyEmulator" then
                    local K = self
                    local v = F[1]
                    if type(v) ~= "string" then
                        error("mt-api: Invalid hook type")
                    end
                    if not h[self] then
                        h[self] = {}
                    end
                    h[self][v] = {Emulator = {[1] = getrawmetatable(game).__index(self, v)}}
                    local function M()
                        h[self][functionName] = nil
                    end
                    return {remove = M, Remove = M}
                end
            end
            if not checkcaller() or getgenv().MTAPIDebug then
                if g[self] and g[self][G] then
                    local R = g[self][G]
                    if R.Callback then
                        local function S(...)
                            return u(self, ...)
                        end
                        return R.Callback(S, ...)
                    end
                    error("mt-api: Callback is nil")
                end
                for y, z in next, k do
                    if z[G] then
                        local T = z[G]
                        if T.Callback then
                            return T.Callback(self, u, ...) or {Failure = true}
                        end
                        error("mt-api: Callback is nil")
                        break
                    end
                end
            end
            return u(self, ...)
        end
    )
    if c == 0 then
        make_readonly(r)
    elseif c == 2 then
        error("mt-api: Exploit not supported")
    else
        if setreadonly then
            setreadonly(r, true)
        else
            error("mt-api: Exploit not supported")
        end
    end
end
local function U()
    if getgenv().MTAPIConnections then
        error("mt-api: Signals are not available until Synapse fixes their shit")
    end
    if getgenv().MTAPIGui then
        game:AddGlobalCallHook(
            "MouseButton1Down",
            function(self, V, ...)
                local W = {...}
                local X = W[1]
                local Y = W[2]
                firesignal(getrawmetatable(game).__index(self, "MouseButton1Down"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseButton1Up",
            function(self, V, ...)
                local W = {...}
                local X = W[1] or nil
                local Y = W[2] or nil
                firesignal(getrawmetatable(game).__index(self, "MouseButton1Up"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseButton1Click",
            function(self, V, ...)
                firesignal(getrawmetatable(game).__index(self, "MouseButton1Click"))
            end
        )
        game:AddGlobalCallHook(
            "MouseButton2Down",
            function(self, V, ...)
                local W = {...}
                local X = W[1]
                local Y = W[2]
                firesignal(getrawmetatable(game).__index(self, "MouseButton2Down"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseButton2Up",
            function(self, V, ...)
                local W = {...}
                local X = W[1] or nil
                local Y = W[2] or nil
                firesignal(getrawmetatable(game).__index(self, "MouseButton2Up"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseButton2Click",
            function(self, V, ...)
                firesignal(getrawmetatable(game).__index(self, "MouseButton2Click"))
            end
        )
        game:AddGlobalCallHook(
            "MouseEnter",
            function(self, V, ...)
                local W = {...}
                local X = W[1] or nil
                local Y = W[2] or nil
                firesignal(getrawmetatable(game).__index(self, "MouseEnter"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseLeave",
            function(self, V, ...)
                local W = {...}
                local X = W[1] or nil
                local Y = W[2] or nil
                firesignal(getrawmetatable(game).__index(self, "MouseLeave"), X, Y)
            end
        )
        game:AddGlobalCallHook(
            "MouseMoved",
            function(self, V, ...)
                local W = {...}
                local X = W[1] or nil
                local Y = W[2] or nil
                firesignal(getrawmetatable(game).__index(self, "MouseMoved"), X, Y)
            end
        )
    end
end
p()
U()
getgenv().MTAPIMutex = true
)
