local highPriority = {
	-- strings of the script names
}

local function initializeModule(module: ModuleScript)
	local required = require(module)

	if required.init and type(required.init) == "function" then
		task.spawn(required.init)
	else
		warn(`module {module} does not have an init function`)
	end
end

for _, moduleName in highPriority do
	local module = script:FindFirstChild(moduleName)

	if not module then
		warn(`module not found: {moduleName}`)
		continue
	end

	if not module:IsA("ModuleScript") then
		warn(`module is not a ModuleScript: {moduleName}`)
		continue
	end

	initializeModule(module)
end

for _, module in script:GetChildren() do
	if not module:IsA("ModuleScript") then
		continue
	end

	if table.find(highPriority, module.Name) then
		continue
	end

	initializeModule(module)
end
