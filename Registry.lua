Registry = {};

Registry.VirtualButton = {};
Registry.VirtualButton.Aquire = function(self)
	local id = _G[ADDON_NAME .. "_VirtualButton_Counter"] or 0;
	_G[ADDON_NAME .. "_VirtualButton_Counter"] = id + 1;

	local frame = CreateFrame("Frame", ADDON_NAME .. "_ItemButton_" .. id, UIParent);
	frame:SetSize(40, 40);
	frame.button = CreateFrame("ItemButton", "$parent_Button", frame, "ContainerFrameItemButtonTemplate");
	frame.button:SetAllPoints();
	frame.button:Show();

	if frame.button.BattlepayItemTexture then
		frame.button.BattlepayItemTexture:Hide()
	end
	if frame.button.NewItemTexture then
		frame.button.NewItemTexture:Hide()
	end
	if frame.button.IconQuestTexture then
		frame.button.IconQuestTexture:Hide()
	end
	frame.AssignItem = function(self, bagId, slotId)
		self:SetID(bagId);
		self.button:SetID(slotId);
	end
	frame.Update = function(self)
		local texture = select(1, GetContainerItemInfo(self:GetID(), self.button:GetID()));
		if(texture) then
			self.button:SetNormalTexture(select(1, GetContainerItemInfo(self:GetID(), self.button:GetID())));
			self.button:GetNormalTexture():SetAllPoints();
		end
	end

	return frame;
end
Registry.VirtualButton.Release = function(self, itemButton)
	itemButton:Hide();
end

Registry.VirtualBag = {};
Registry.VirtualBag.Aquire = function(self)
	local id = _G[ADDON_NAME .. "_VirtualBag_Counter"] or 0;
	_G[ADDON_NAME .. "_VirtualBag_Counter"] = id + 1;

	local frame = CreateFrame("Frame", ADDON_NAME .. "_VirtualBag_" .. id, UIParent);
	frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", - 100, 100);
	frame:SetSize(300, 500);
	frame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	});
	frame:SetBackdropColor(0, 0, 0, 0.9);
	frame:SetBackdropBorderColor(0.1, 0.1, 0.1, 1);

	frame.items = {};
	frame.itemAnchor = frame;
	frame.AddItem = function(self, bagId, slotId)
		local button = Registry.VirtualButton:Aquire();
		button:AssignItem(bagId, slotId);
		button:Update();
		self.items[bagId.."_"..slotId] = button;
		if(self.itemAnchor == self) then
			button:SetPoint("BOTTOMRIGHT", self.itemAnchor, "BOTTOMRIGHT", - 10, 10);
		else
			button:SetPoint("BOTTOMRIGHT", self.itemAnchor, "BOTTOMLEFT", - 5, 0);
		end
		self.itemAnchor = button;
	end
	frame.RemoveItem = function(self, bagId, slotId)
		Registry.VirtualButton:Release(self.items[bagId.."_"..slotId]);
		self.items[bagId.."_"..slotId] = nil;
	end
	frame.Update = function(self)
		for i, v in pairs(self.items) do
			v:Update();
		end
	end
	return frame;
end
Registry.VirtualBag.Release = function(self)
end
