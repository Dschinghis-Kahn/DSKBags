ADDON_NAME = "DSKBags";
ITEM_BUTTON_SIZE = 40;

function console(message)
	print(ADDON_NAME .. ": " .. message);
end

local events = {};
local frame = CreateFrame("FRAME", ADDON_NAME .. "_Frame");
frame:SetScript("OnEvent",
	function(self, event, ...)
		events[event](self, ...);
	end
);
function events:ADDON_LOADED(addon)
	if(addon == ADDON_NAME) then
		console("ADDON_LOADED");

		local vBag = Registry.VirtualBag:Aquire();
		vBag:AddItem(0, 1);
		vBag:AddItem(0, 2);
		vBag:AddItem(0, 3);
		vBag:AddItem(0, 4);
		vBag:AddItem(0, 5);
		vBag:Update();
		--		b2:SetPoint("BOTTOMRIGHT", vBag, "BOTTOMRIGHT", - 10 - (ITEM_BUTTON_SIZE + 5), 10);
	end
end
function events:BAG_UPDATE(bagId)
	console("BAG_UPDATE: " .. bagId);
end
for event, handler in pairs(events) do
	frame:RegisterEvent(event);
end
