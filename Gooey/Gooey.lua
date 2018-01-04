
----------------------------------------------------------------------------------------------------

local GLOBAL, REFERENCE_NAME = getfenv(0), "GOOEY"

if GLOBAL[REFERENCE_NAME] then return end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local Coordinator = Coordinator or CreateFrame("frame")

local function Event_Handler(self, event, ...)
	if event == "ADDON_LOADED" then
		local namespace = self[event][...]
		if namespace then
			Coordinator[event][namespace.Name] = nil
			if next(Coordinator[event]) == nil then
				Coordinator:UnregisterEvent(event)
				Coordinator[event] = nil
			end
			pcall(namespace[event], namespace, event, ...)
		end
	else
		for key,namespace in pairs(self[event]) do
			pcall(namespace[event], namespace, event, ...)
		end
	end
end

local function Event_Trigger(name, namespace, event)
	if not Coordinator[event] then Coordinator[event] = {} end
	Coordinator[event][name] = namespace
	Coordinator:RegisterEvent(event)
end

local function Start_Trigger(name, namespace)
	namespace.Name, namespace.Title, namespace.Version, namespace.Masked, namespace.Shared, namespace.Global, namespace.Index, namespace.Events = name, strmatch(GetAddOnMetadata(name, "Title") or name, "[%w_]+"), strmatch(GetAddOnMetadata(name, "Version"), "^([%d.]+)") or 0, {}, {}, { Name = REFERENCE_NAME }, { { name, namespace } }, Coordinator
	GLOBAL[REFERENCE_NAME] = namespace.Global

	for method, reference in pairs(namespace.Masked) do
		namespace[method] = reference
	end

	Event_Trigger(name, namespace, "ADDON_LOADED")

	return namespace, namespace.Shared, namespace.Global
end

Coordinator:SetScript("OnEvent", Event_Handler)

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

local Gooey = Start_Trigger(...)

function Gooey:ADDON_LOADED(event, ...)
  print("GOOEY ADDON_LOADED TEST")
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function Gooey.Shared.AddEvent(self, ...)
	for _,event in pairs({...}) do
		if type(event) == "string" then
			event = string.upper(event)
			Coordinator:RegisterEvent(event)
			if Coordinator:IsEventRegistered(event) then
				if not Coordinator[event] then Coordinator[event] = {} end
				Coordinator[event][self.Name] = self
			end
		end
	end

	return self
end

function Gooey.Shared.EndEvent(self, ...)
	for _,event in pairs({...}) do
		if type(event) == "string" then
			event = string.upper(event)
			Coordinator[event][self.Name] = nil
			if next(Coordinator[event]) == nil then
				Coordinator:UnregisterEvent(event)
				Coordinator[event] = nil
			end
		end
	end

	return self
end

function Gooey.Shared.GetEvent(self, event)
	if type(event) == "string" then event = string.upper(event) else return end

	if Coordinator:IsEventRegistered(event) then
		local count = 0
		for key, value in pairs(Coordinator[event]) do
			print(key, value)
			count = count + 1
		end
		--print(count)
		return count
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function Gooey.Global.GetGooey(self, name, namespace)
	if namespace.Name == name then
		return namespace, self
	else
		return self[name] or false, self
	end
end

function Gooey.Global.NewGooey(self, name, namespace)
	if type(name) ~= "string" then return end
	if not namespace or type(namespace) ~= "table" then namespace = {} end
	namespace.Name, namespace.Title, namespace.Version, namespace.Events, Gooey.Index[#Gooey.Index+1], self[name] = name, strmatch(GetAddOnMetadata(name, "Title") or name, "[%w_]+") or name, strmatch(GetAddOnMetadata(name, "Version"), "^([%d.]+)") or 0, Coordinator, { name, namespace }, namespace

	for method, reference in pairs(Gooey.Shared) do
		namespace[method] = reference
	end

	Event_Trigger(name, namespace, "ADDON_LOADED")

	return namespace, self
end


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

