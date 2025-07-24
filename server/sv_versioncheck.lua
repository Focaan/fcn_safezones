local GITHUB_REPO = "Focaan/versioncheck"
local GITHUB_RAW_BASE_URL = "https://raw.githubusercontent.com/"..GITHUB_REPO.."/main/"

local resourcesToCheck = {
    "fcn_safezones",
}

local function CompareVersions(localVer, remoteVer)
    local l = { string.match(localVer or "0.0.0", "(%d+)%.(%d+)%.(%d+)") }
    local r = { string.match(remoteVer or "0.0.0", "(%d+)%.(%d+)%.(%d+)") }

    for i = 1, 3 do
        l[i] = tonumber(l[i]) or 0
        r[i] = tonumber(r[i]) or 0

        if l[i] < r[i] then return -1 end
        if l[i] > r[i] then return 1 end
    end
    return 0
end

local function CheckForUpdates(resourceName, isMain)
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0) or "0.0.0"
    local githubUrl = GITHUB_RAW_BASE_URL .. resourceName

    PerformHttpRequest(githubUrl, function(status, response, headers)

        if status ~= 200 then
            if status == 404 then
                print("^1["..resourceName.."] Remote version not found (404)^0")
            else
                print("^1["..resourceName.."] Error checking version ("..status..")^0")
            end
            return
        end

        local remoteVersion = string.match(response:gsub("%s+", ""), "^(%d+%.%d+%.%d+)$")
        if not remoteVersion then
            print("^1["..resourceName.."] Invalid version format on remote^0")
            return
        end

        local comparison = CompareVersions(currentVersion, remoteVersion)
        if comparison == -1 then
            print("^1["..resourceName.."] UPDATE AVAILABLE: "..currentVersion.." → "..remoteVersion.."^0")
            print("^3["..resourceName.."] Download: https://github.com/Focaan/"..resourceName.."^0")
        elseif comparison == 0 then
            print("^2["..resourceName.."] You are running the latest version ("..currentVersion..")^0")
        else
            print("^5["..resourceName.."] You are running a newer version ("..currentVersion..") than available ("..remoteVersion..")^0")
        end
    end, 'GET', '', '', { timeout = 5000 })
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for index, resName in ipairs(resourcesToCheck) do
        local isMain = (resName == GetCurrentResourceName())
        CheckForUpdates(resName, isMain)
        Citizen.Wait(500)
    end
end)