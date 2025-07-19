return function(auth_key)
    if auth_key == "!HozDm3gFd" then
        print('authenticated')
        return function(file_path, is_trusted, repo_location)
            if type(file_path) ~= "string" or file_path == "" then
                error("Invalid file parameter: must be a non-empty string")
            end
            is_trusted = is_trusted or false
            repo_location = repo_location or "sigmacodeslol/mainscripts/refs/heads/master/"
            if repo_location:sub(-1) ~= "/" then
                repo_location = repo_location .. "/"
            end
            file_path = file_path:gsub("[^%w%/%-%.%_]", "")
            local success, target_url =
                pcall(
                function()
                    return "https://raw.githubusercontent.com/" .. repo_location .. file_path
                end
            )
            if not success then
                error("Failed to construct URL: " .. tostring(target_url))
            end
            local http_result
            success, http_result =
                pcall(
                function()
                    return game:HttpGet(target_url)
                end
            )
            if not success then
                error("HTTP request failed: " .. tostring(http_result))
            end
            local compiled_function
            success, compiled_function =
                pcall(
                function()
                    return loadstring(http_result, is_trusted)
                end
            )
            if not success then
                error("Failed to load script: " .. tostring(compiled_function))
            end
            if type(compiled_function) ~= "function" then
                error("Loaded content is not a valid Lua function")
            end
            return compiled_function
        end
    else
        print('failed')
    end
    return nil
end
