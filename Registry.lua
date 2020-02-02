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
		else
			self.button:SetNormalTexture("Interface\\BUTTONS\\UI-Slot-Background.blp");
			self.button:GetNormalTexture():SetAllPoints();
		end
	end

	return frame;
end
Registry.VirtualButton.Release = function(self, itemButton)
	itemButton:Hide();
	itemButton:AssignItem(nil, nil);
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

	frame.buttonWidth = 4;
	frame.borderWidth = 10;
	frame.buttonSpacing = 5;
	frame.buttons = {};

	frame.AddItem = function(self, bagId, slotId)
		local button = self:AddButton();
		button:AssignItem(bagId, slotId);
		button:Update();
	end
	frame.RemoveItem = function(self, bagId, slotId)
	end

	frame.AddButton = function(self)
		local button = Registry.VirtualButton:Aquire();
		local id = 0;	for k, v in pairs(self.buttons) do id=id+1; end
		self.buttons[id] = button;
		if(id == 0) then
			button:SetPoint("TOPLEFT", self, "TOPLEFT", self.borderWidth, -1 * self.borderWidth);
		else
			if(id % self.buttonWidth == 0) then
				button:SetPoint("TOPLEFT", self.buttons[id-self.buttonWidth], "BOTTOMLEFT", 0, -1 * self.buttonSpacing);
			else
				button:SetPoint("TOPLEFT", self.buttons[id-1], "TOPRIGHT", self.buttonSpacing, 0);
			end
		end
		return button;
	end
	frame.RemoveButton = function(self)
		local id = table.getn(self.buttons)-1;
		local button = self.buttons[id];
		Registry.VirtualButton:Release(button);
		self.buttons[id] = nil;
	end

	frame.Update = function(self)
		for id, button in pairs(self.buttons) do
			button:Update();
		end
	end

	return frame;
end
Registry.VirtualBag.Release = function(self)
end
