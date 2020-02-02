ADDON_NAME = "DSKBags";
ITEM_BUTTON_SIZE = 40;

function console(message)
	print(ADDON_NAME .. ": " .. message);
end

local events = {};
local frame = CreateFrame("FRAME", ADDON_NAME .. "_Frame");
frame.bags = {}
frame:SetScript("OnEvent",
	function(self, event, ...)
		events[event](self, ...);
	end
);
function events:ADDON_LOADED(addon)
	if(addon == ADDON_NAME) then
		console("ADDON_LOADED");

		local id = 0;	for k, v in pairs(self.bags) do id=id+1; end
		self.bags[id]= Registry.VirtualBag:Aquire();
		self.bags[id]:AddItem(0, 1);
		self.bags[id]:AddItem(0, 2);
		self.bags[id]:AddItem(0, 3);
		self.bags[id]:AddItem(0, 4);
		self.bags[id]:AddItem(0, 5);
		self.bags[id]:AddItem(0, 6);
		self.bags[id]:AddItem(0, 7);
		self.bags[id]:AddItem(0, 8);
		self.bags[id]:AddItem(0, 9);
		self.bags[id]:AddItem(0, 10);
		self.bags[id]:Update();
	end
end
function events:BAG_UPDATE(bagId)
	console("BAG_UPDATE: " .. bagId);
	for id, button in pairs(self.bags) do
		button:Update();
	end
end
for event, handler in pairs(events) do
	frame:RegisterEvent(event);
end
