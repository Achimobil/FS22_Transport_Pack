--[[
AddConfig

Specialization for extended configurations and register new configurations.

Author:		Ifko[nator]
Date:		12.04.2020

Version:	v8.8

History:	v1.0 @ 28.02.2017 - initial implementation in FS 17 - added possibility to change capacity via configuration --## FS17 (removed)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v2.0 @ 25.03.2017 - added possibility to change rim and axis color via configuration --## FS17 and FS 19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.0 @ 21.07.2017 - added possibility to change fillable fill types and cutable fruit types via configuration --## FS17 (removed)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.1 @ 13.12.2017 - a little bit code optimation --## FS17
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.2 @ 31.12.2017 - increased the limit from 64 to 134.217.728 configurations, i hope thats enough now! --## FS17
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.3 @ 04.03.2018 - the capacity value from the fillUnit in the xml file will now set to the new capacity to avoid fill the fill volume too fast or too slow --## FS17 (removed)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.4 @ 04.07.2018 - added possibility to change the mass and possiblity to deactivate the fillable Spezi of an vehicle via configuration --## FS17 (removed)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v3.9 BETA @ 07.01.2019 - first conversion to FS 19, current only color configs working! --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.0 @ 10.01.2019 - added support for 'design' configurations and finish the conversion but this is currentlly still an TEST Version! --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.2 @ 23.01.2019 - added support for default configurations and possibility to change the honk sound via configuration --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.5 @ 27.01.2019 - added possibility to change the external sound file for motor sounds (wish from Unguided) --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.6 @ 08.02.2019 - added possibility to change the beacon lights (wish from juli7250) --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.7 @ 10.02.2019 - added possibility to make any vehicle selectable (wish from Ahran Modding) --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.8 @ 12.02.2019 - fixed register of an exists configuration, script will stop now --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v4.9 @ 05.03.2019 - fixed issue that additonial wheels won't be colered with color changes and added the TAG 'getColorFromConfig' to get the color from given config --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.0 @ 17.06.2019 - fixed issue that th connectors from the additonial wheels won't be colered with color changes --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.1 @ 08.08.2019 - added compatibility with the FSIconGenerator from GIANTS, so it will not crash anymore. You can't select the new configurations in the generator --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.2 @ 23.08.2019 - added possibility to change the material in a new color configuration (thanks for the hint Unguided) --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.3 @ 24.08.2019 - increased again the limit from 64 to 134.217.728 configurations --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.5 @ 31.08.2019 - added compatibilty with some default configurations --## FS 19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.7 @ 02.09.2019 - added possibility to change the color from top arm and starfire and filename from the top arm --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.8 @ 08.09.2019 - added possibility to change the max forward speed and min forward gear ratio --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v5.9 @ 18.09.2019 - added possibility to change ikChains via configuration --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v6.0 @ 05.10.2019 - added support for strobe lights configuration --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v6.1 @ 11.10.2019 - a little bit code optimation --## FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v6.5 @ 16.10.2019 - added possibility to change the wheel filename --##FS19 (removed in v6.9 because this is not needed anymore!)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v6.8 @ 04.11.2019 - added possibility to change the color from the screws of the wheels --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v6.9 @ 11.12.2019 - added the TAG 'getRimColorFromConfig' to get the color for the rims from given config --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v7.0 @ 29.12.2019 - removed possibility to set an configName with an 'Ö, Ä, Ü or ß' --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v7.5 @ 13.03.2020 - added support to change the collisions mask of root components and support for adding cameras --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v8.0 @ 18.03.2020 - added possibility to change the decal from the starfire --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v8.5 @ 21.03.2020 - added possibility to change the 'additional' and 'normal' charachter --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v8.6 @ 01.04.2020 - added possibility to change the typeDesc of an vehicle --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v8.7 @ 04.04.2020 - added support to color the hubs to any color configuration, like it is possible with 'baseColor' --##FS19
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			v8.8 @ 12.04.2020 - little script fix thanks to Unguided --##FS19
]]

AddConfig = {};

AddConfig.currentModDirectory = g_currentModDirectory;
AddConfig.currentModName = g_currentModName;
AddConfig.debugPriority = 0;
AddConfig.newConfgurations = {};

AddConfig.defaultChangeObjectsConfigurations = {
	"design",
	"vehicleType",
	"attacherJoint",
	"motor",
	"frontloader",
	"powerTakeOff",
	"trailer",
	"tensionBelts",
	"pipe",
	"inputAttacherJoint",
	"cover",
	"folding",
	"fillUnit",
	"fillVolume",
	"consumer",
	"differential"
};

AddConfig.defaultColorConfigurations = {
	"baseColor",
	"designColor",
	"rimColor",
	"baseMaterial",
	"designMaterial",
	"wrappingColor"
};

local function printError(errorMessage, isWarning, isInfo)
	local prefix = "::ERROR:: ";

	if isWarning then
		prefix = "::WARNING:: ";
	elseif isInfo then
		prefix = "::INFO:: ";
	end;

	print(prefix .. "from the AddConfig.lua: " .. tostring(errorMessage));
end;

local function printDebug(debugMessage, priority, addString)
	if AddConfig.debugPriority >= priority then
		local prefix = "";

		if addString then
			prefix = "::DEBUG:: from the AddConfig.lua: ";
		end;

		setFileLogPrefixTimestamp(false);
		print(prefix .. tostring(debugMessage));
		setFileLogPrefixTimestamp(true);
	end;
end;

if ConfigurationUtil.SEND_NUM_BITS < 27 then
	ConfigurationUtil.SEND_NUM_BITS = 27; --## = 134.217.728 possible configurations! I think, thats enough (2^27 = 134.217.728)!
	
	printError("Set max number of configurations to ".. g_i18n:formatNumber(2^ConfigurationUtil.SEND_NUM_BITS), false, true);
end;

function AddConfig.prerequisitesPresent(specializations)
    return true;
end

function AddConfig.registerEventListeners(vehicleType)
	local functionNames = {
		"onLoad",
		"onPreLoad",
		"onUpdate"
	};

	for _, functionName in ipairs(functionNames) do
		SpecializationUtil.registerEventListener(vehicleType, functionName, AddConfig);
	end;
end;

function AddConfig.registerFunctions(vehicleType)
	local functionNames = {
		"setColor",
		"changeObjects",
		"initExtraOptions",
		"getConfigKey",
		"getXMLPrefix",
		"loadExtraOptions",
		"updateBeaconLightBlinking",
		"resetBeaconLightBlinking"
	};

	for _, functionName in ipairs(functionNames) do
		SpecializationUtil.registerFunction(vehicleType, functionName, AddConfig[functionName]);
	end;
end;


function AddConfig.registerOverwrittenFunctions(vehicleType)
	local overwrittenFunctionNames = {
		"getCanBeSelected"
	};

	for _, overwrittenFunctionName in ipairs(overwrittenFunctionNames) do
		SpecializationUtil.registerOverwrittenFunction(vehicleType, overwrittenFunctionName, AddConfig[overwrittenFunctionName]);
	end;
end;

function AddConfig.initSpecialization()
	local modDesc = loadXMLFile("modDesc", AddConfig.currentModDirectory .. "modDesc.xml");
	local configNumber = 0;

	while true do
		local configKey = "modDesc.newConfigurations.newConfiguration(" .. tostring(configNumber) .. ")";

		if not hasXMLProperty(modDesc, configKey) then
			break;
		end;
		
		local newConfguration = {};

		newConfguration.isColorConfig = Utils.getNoNil(getXMLBool(modDesc, configKey .. "#isColorConfig"), false);
		newConfguration.configName = Utils.getNoNil(getXMLString(modDesc, configKey .. "#configName"), "");
		newConfguration.title = g_i18n:getText("configuration_" .. Utils.getNoNil(getXMLString(modDesc, configKey .. "#useTitleFromConfig"),  newConfguration.configName));

		if newConfguration.configName ~= "" then 
			local function getIsValidConfigName(configName)
				if configName:len() == 0 then
					return false;
				end;
			
				if configName:find("%d") == 1 then
					return false;
				end;
				
				if configName:find("[^%w_]") ~= nil then
					return false;
				end;

				return true;
			end;

			if getIsValidConfigName(newConfguration.configName) then 
				if g_configurationManager.configurations[newConfguration.configName] == nil then	
					if newConfguration.isColorConfig then	
						--## config to change color on vehicle

						printDebug("(newConfigurations) :: Register color configuration '" .. newConfguration.configName .. "' (title '" .. newConfguration.title .. "') successfully.", 1, true);

						g_configurationManager:addConfigurationType(newConfguration.configName, newConfguration.title, nil, nil, ConfigurationUtil.getConfigColorSingleItemLoad, ConfigurationUtil.getConfigColorPostLoad, ConfigurationUtil.SELECTOR_COLOR);
					else
						--## config to change objects on vehicle

						printDebug("(newConfigurations) :: Register multi option configuration '" .. newConfguration.configName .. "' (title '" .. newConfguration.title .. "') successfully.", 1, true);

						g_configurationManager:addConfigurationType(newConfguration.configName, newConfguration.title, nil, nil, nil, nil, ConfigurationUtil.SELECTOR_MULTIOPTION);
					end;
				end;

				table.insert(AddConfig.newConfgurations, newConfguration);
			else
				printError("Invalid config name '" .. newConfguration.configName .. "'! Characters allowed: (_, A-Z, a-z, 0-9). Characters not allowed: (Ö, Ä, Ü, ß). The first character must not be a digit! Skipping this configuration now!", false, false);
			end;
		end;

		configNumber = configNumber + 1;
	end;

	delete(modDesc);
end;

function AddConfig:onPreLoad(savegame)
	for _, newConfguration in pairs(AddConfig.newConfgurations) do
		if self.configurations[newConfguration.configName] ~= nil then
			if not newConfguration.isColorConfig then	
				self:initExtraOptions(newConfguration.configName, self.configurations[newConfguration.configName], nil, false, false);
			end;
		end;
	end;

	for _, defaultChangeObjectsConfiguration in pairs(AddConfig.defaultChangeObjectsConfigurations) do
		if self.configurations[defaultChangeObjectsConfiguration] ~= nil then
			self:initExtraOptions(self:getXMLPrefix(defaultChangeObjectsConfiguration), self.configurations[defaultChangeObjectsConfiguration], defaultChangeObjectsConfiguration, false, false);
		end;
	end;
end;

function AddConfig:onLoad(savegame)
	local modDesc = loadXMLFile("modDesc", AddConfig.currentModDirectory .. "modDesc.xml");
	
	AddConfig.debugPriority = Utils.getNoNil(getXMLFloat(modDesc, "modDesc.newConfigurations#debugPriority"), AddConfig.debugPriority);
	
	delete(modDesc);
	
	for _, newConfguration in pairs(AddConfig.newConfgurations) do
		if self.configurations[newConfguration.configName] ~= nil then	
			printDebug("(newConfigurations) :: Found configuration '" .. newConfguration.configName .. "' in vehicle '" .. self.configFileName .. "'.", 1, true);

			if newConfguration.isColorConfig then
				--## config to change color on vehicle
				
				self:setColor(newConfguration.configName, self.configurations[newConfguration.configName]);
				self:applyBaseMaterialConfiguration(self.xmlFile, newConfguration.configName, self.configurations[newConfguration.configName]);
				self:applyBaseMaterial();
			else
				--## config to change objects on vehicle
				
				self:changeObjects(newConfguration.configName, self.configurations[newConfguration.configName]);
			end;
		end;
	end;
	
	for _, defaultColorConfiguration in pairs(AddConfig.defaultColorConfigurations) do
		if self.configurations[defaultColorConfiguration] ~= nil then	
			--## config to change color on vehicle
			
			self:setColor(defaultColorConfiguration, self.configurations[defaultColorConfiguration]);
		end;
	end;

	for _, defaultChangeObjectsConfiguration in pairs(AddConfig.defaultChangeObjectsConfigurations) do
		if self.configurations[defaultChangeObjectsConfiguration] ~= nil then
			--## config to change objects on vehicle
			
			self:changeObjects(self:getXMLPrefix(defaultChangeObjectsConfiguration), self.configurations[defaultChangeObjectsConfiguration], defaultChangeObjectsConfiguration);
		end;
	end;

	self.hasFinishedFirstRun = false;

	local specLights = self.spec_lights;

	if specLights ~= nil and #specLights.beaconLights > 0 then
		specLights.beaconLightsWasActive = false;
	end;

	for _, newConfguration in pairs(AddConfig.newConfgurations) do
		if self.configurations[newConfguration.configName] ~= nil then
			if not newConfguration.isColorConfig then	
				self:initExtraOptions(newConfguration.configName, self.configurations[newConfguration.configName], nil, false, true);
			end;
		end;
	end;

	for _, defaultChangeObjectsConfiguration in pairs(AddConfig.defaultChangeObjectsConfigurations) do
		if self.configurations[defaultChangeObjectsConfiguration] ~= nil then
			self:initExtraOptions(self:getXMLPrefix(defaultChangeObjectsConfiguration), self.configurations[defaultChangeObjectsConfiguration], defaultChangeObjectsConfiguration, false, true);
		end;
	end;

	for hubNumber = 0, 7 do
		local hubColorKey = string.format("vehicle.wheels.hubs.color%d", hubNumber);
		
		if hasXMLProperty(self.xmlFile, hubColorKey) then
			local getHubColorFromConfig = Utils.getNoNil(getXMLString(self.xmlFile, hubColorKey .. "#getHubColorFromConfig"), "");

			if getHubColorFromConfig ~= "" then
				if self.configurations[getHubColorFromConfig] ~= nil then
					local isColorConfig = false;
					local colorName;
					local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, hubColorKey .. "#shaderParameterName"), "colorMat0");

					for _, newConfguration in pairs(AddConfig.newConfgurations) do
						if getHubColorFromConfig == newConfguration.configName then
							isColorConfig = newConfguration.isColorConfig;

							break;
						end;
					end;

					for _, defaultColorConfiguration in pairs(AddConfig.defaultColorConfigurations) do
						if getHubColorFromConfig == defaultColorConfiguration then
							isColorConfig = true;

							break;
						end;
					end;

					if isColorConfig then
						colorName = ConfigurationUtil.getColorByConfigId(self, getHubColorFromConfig, self.configurations[getHubColorFromConfig]);
					else
						printError("(colorChanges) :: The configuration '" .. getHubColorFromConfig .. "' is not an color configuration! Stop coloring wheel hubs!", false, true)
					end;

					if colorName ~= nil then
						for _, hub in pairs(self.spec_wheels.hubs) do
							if hub.node ~= nil then
								local r, g, b, _ = unpack(colorName);

								if materialId == nil then
									_, _, _, materialId = getShaderParameter(hub.node, shaderParameterName);
								end;

								setShaderParameter(hub.node, shaderParameterName, r, g, b, Utils.getNoNil(materialId, Utils.getNoNil(colorName[4], 0)), false);

								printDebug("(colorChanges) :: Change hub color successfully in '" .. self.configFileName .. "'.", 1, true);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;

function AddConfig:getCanBeSelected(superFunc)
	--## Make any Vehicle, wich has the script, selectable

	return true;
end;

function AddConfig:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
	if not self.hasFinishedFirstRun then
		for _, newConfguration in pairs(AddConfig.newConfgurations) do
			if self.configurations[newConfguration.configName] ~= nil then
				if not newConfguration.isColorConfig then	
					self:initExtraOptions(newConfguration.configName, self.configurations[newConfguration.configName], nil, true, false);
				end;
			end;
		end;

		for _, defaultChangeObjectsConfiguration in pairs(AddConfig.defaultChangeObjectsConfigurations) do
			if self.configurations[defaultChangeObjectsConfiguration] ~= nil then
				self:initExtraOptions(self:getXMLPrefix(defaultChangeObjectsConfiguration), self.configurations[defaultChangeObjectsConfiguration], defaultChangeObjectsConfiguration, true, false);
			end;
		end;

		self.hasFinishedFirstRun = true;
	end;

	local specLights = self.spec_lights;

	if specLights ~= nil and #specLights.beaconLights > 0 then
		if self.getIsMotorStarted ~= nil then
			if not self:getIsMotorStarted() then
				if specLights.beaconLightsActive then
					specLights.beaconLightsWasActive = true;

					self:setBeaconLightsVisibility(false, true, nil);
				end;
			else
				if specLights.beaconLightsWasActive then
					self:setBeaconLightsVisibility(true, true, nil);

					specLights.beaconLightsWasActive = false;
				end;
			end;
		end;

		if specLights.beaconLightsActive then
			for _, newConfguration in pairs(AddConfig.newConfgurations) do
				if self.configurations[newConfguration.configName] ~= nil then
					if not newConfguration.isColorConfig then
						local extraOptionNumber = 0;
						
						while true do
							local configKey = self:getConfigKey(newConfguration.configName, self.configurations[newConfguration.configName], nil) .. ".extraOption(" .. tostring(extraOptionNumber) .. ")";
							
							if hasXMLProperty(self.xmlFile, configKey .. "#beaconLightBlinkingSequences") then
								local beaconLightBlinkingSequences = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, configKey .. "#beaconLightBlinkingSequences"))};
								local beaconLightIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, configKey .. "#beaconLightIndices"))};
									
								if #beaconLightIndices > 0 then
									for _, beaconLightIndice in pairs(beaconLightIndices) do
										self:updateBeaconLightBlinking(beaconLightBlinkingSequences, beaconLightIndice, dt, specLights.beaconLights);
									end;
								else
									self:updateBeaconLightBlinking(beaconLightBlinkingSequences, extraOptionNumber + 1, dt, specLights.beaconLights);
								end;
							else
								break;
							end;
							
							extraOptionNumber = extraOptionNumber + 1;
						end;
					end;
				end;
			end;

			for _, defaultChangeObjectsConfiguration in pairs(AddConfig.defaultChangeObjectsConfigurations) do
				if self.configurations[defaultChangeObjectsConfiguration] ~= nil then
					local extraOptionNumber = 0;
					
					while true do
						local configKey = self:getConfigKey(self:getXMLPrefix(defaultChangeObjectsConfiguration), self.configurations[defaultChangeObjectsConfiguration], defaultChangeObjectsConfiguration) .. ".extraOption(" .. tostring(extraOptionNumber) .. ")";
						
						if hasXMLProperty(self.xmlFile, configKey .. "#beaconLightBlinkingSequences") then
							local beaconLightBlinkingSequences = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, configKey .. "#beaconLightBlinkingSequences"))};
							local beaconLightIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, configKey .. "#beaconLightIndices"))};
									
							if #beaconLightIndices > 0 then
								for _, beaconLightIndice in pairs(beaconLightIndices) do
									self:updateBeaconLightBlinking(beaconLightBlinkingSequences, beaconLightIndice, dt, specLights.beaconLights);
								end;
							else
								self:updateBeaconLightBlinking(beaconLightBlinkingSequences, extraOptionNumber + 1, dt, specLights.beaconLights);
							end;
						else
							break;
						end;
						
						extraOptionNumber = extraOptionNumber + 1;
					end;
				end;
			end;

			specLights.hasResetBeaconLightBlinking = false;
		else
			if not specLights.hasResetBeaconLightBlinking then	
				self:resetBeaconLightBlinking(specLights.beaconLights);

				specLights.hasResetBeaconLightBlinking = true;
			end;
		end;
	end;
end;

function AddConfig:updateBeaconLightBlinking(beaconLightBlinkingSequences, beaconLightIndice, dt, beaconLights)
	for beaconLightNumber, beaconLight in pairs(beaconLights) do
		if beaconLightNumber == beaconLightIndice then	
			beaconLight.blinkingSequences = beaconLightBlinkingSequences;
			if #beaconLight.blinkingSequences > 0 then
				if beaconLight.doBlinking == nil then
					beaconLight.doBlinking = false;
				end;
			
				if beaconLight.blinkingTime == nil then
					beaconLight.blinkingTime = 0;
				end;

				if beaconLight.sequence == nil then 
					beaconLight.sequence = 1;
				end;
			
				if beaconLight.blinkingSpeed == nil then
					beaconLight.blinkingSpeed = beaconLight.blinkingSequences[beaconLight.sequence];
				end;
				
				if beaconLight.blinkingTime > beaconLight.blinkingSpeed then
					beaconLight.doBlinking = not beaconLight.doBlinking;

					if beaconLight.realLightNode ~= nil then
						setVisibility(beaconLight.realLightNode, g_gameSettings:getValue("realBeaconLights") and beaconLight.doBlinking and beaconLight.blinkingSpeed > 0);
					end;
				
					if beaconLight.lightNode ~= nil then
						setVisibility(beaconLight.lightNode, beaconLight.doBlinking and beaconLight.blinkingSpeed > 0);
					end;
				
					if beaconLight.lightShaderNode ~= nil then
						local value = 1 * beaconLight.intensity;

						if not beaconLight.doBlinking or beaconLight.blinkingSpeed == 0 then
							value = 0;
						end;

						local _, y, z, w = getShaderParameter(beaconLight.lightShaderNode, "lightControl");
					
						setShaderParameter(beaconLight.lightShaderNode, "lightControl",  value, y, z, w, false);
					end;

					beaconLight.blinkingTime = 0;
					beaconLight.sequence = beaconLight.sequence + 1;
					
					if beaconLight.sequence > #beaconLight.blinkingSequences then
						beaconLight.sequence = 1;
					end;

					beaconLight.blinkingSpeed = beaconLight.blinkingSequences[beaconLight.sequence];
				else
					beaconLight.blinkingTime = beaconLight.blinkingTime + dt;
				end;
			end;
		end;
	end;
end;

function AddConfig:resetBeaconLightBlinking(beaconLights)
	for _, beaconLight in pairs(beaconLights) do
		beaconLight.doBlinking = false;
		beaconLight.blinkingTime = 0;
		beaconLight.sequence = 1;

		if beaconLight.realLightNode ~= nil then
			setVisibility(beaconLight.realLightNode, false);
		end;

		if beaconLight.lightNode ~= nil then
			setVisibility(beaconLight.lightNode, false);
		end;

		if beaconLight.lightShaderNode ~= nil then
			local _, y, z, w = getShaderParameter(beaconLight.lightShaderNode, "lightControl");
		
			setShaderParameter(beaconLight.lightShaderNode, "lightControl",  0, y, z, w, false);
		end;
	end;
end;

function AddConfig:getXMLPrefix(configName)
	local prefix = "";
	
	if configName == "motor" 
		or configName == "consumer" 
		or configName == "differential" 
	then
		prefix = "motorized.";
	elseif configName == "fillUnit" 
		or configName == "fillVolume"
		or configName == "trailer"
		or configName == "tensionBelts"
		or configName == "cover"
		or configName == "pipe"
	then
		prefix = configName .. ".";
	elseif configName == "attacherJoint" 
		or configName == "powerTakeOff"
	then
		prefix = configName .. "s.";
	elseif configName == "inputAttacherJoint" then
		prefix = "attachable.";
	elseif configName == "folding" then
		prefix = "foldable.";
	end;
	
	return prefix .. configName;
end;

function AddConfig:getConfigKey(configName, configId, secondConfigName)
	if secondConfigName == nil then
		secondConfigName = configName;
	end;

	local configKey = string.format("vehicle." .. configName .. "Configurations." .. secondConfigName .. "Configuration(%d)", configId - 1);

	if not hasXMLProperty(self.xmlFile, configKey) then
        printError("(getConfigKey) :: Invalid " .. configName .. " configuration " .. configId .. " (key = " .. configKey .. ")", true, false);
        
		return "noKeyFound";
	end;

	return configKey;
end;

function AddConfig:loadExtraOptions(configKey, extraOptionNeedUpdate, extraOptionOnLoad)
	local extraOptionNumber = 0;

	while true do
		local extraOptionKey = string.format(configKey .. ".extraOption(%d)", extraOptionNumber);

	   	if not hasXMLProperty(self.xmlFile, extraOptionKey) then
		   break;
	   	end;

		if extraOptionNeedUpdate then   
			local coverFillUnit = Utils.getNoNil(getXMLInt(self.xmlFile, extraOptionKey .. "#fillUnit"), 1);
			local setCoverOpen = getXMLBool(self.xmlFile, extraOptionKey .. "#setCoverOpen");
			   
			if self.spec_cover ~= nil and setCoverOpen ~= nil then
				self:setCoverState(coverFillUnit, setCoverOpen);
 
				printDebug("(loadExtraOptions) :: Open cover state is '" .. tostring(setCoverOpen) .. "'." , 1, true);
			end;

		elseif extraOptionOnLoad then
			local newCollisionMask = Utils.getNoNil(getXMLInt(self.xmlFile, extraOptionKey .. "#newCollisionMask"), -1);

			if newCollisionMask > -1 then
				local componentIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, extraOptionKey .. "#componentIndices"))};

				if #componentIndices > 0 then
					for _, componentIndice in pairs(componentIndices) do
						if self.components[componentIndice].node ~= nil then	
							setCollisionMask(self.components[componentIndice].node, newCollisionMask);

							printDebug("(loadExtraOptions) :: Set collision mask to '" .. tostring(newCollisionMask) .. "' for index '" .. componentIndice .. ">'." , 1, true);
						end;
					end;
				end;
			end;
		else
	  		local honkSoundTemplate = string.upper(Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#honkSoundTemplate"), ""));
			local honkSoundFilename = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#honkSoundFilename"), "");
			local honkSoundOuterRadius = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#honkSoundOuterRadius"), "");
			local honkSoundInnerRadius = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#honkSoundInnerRadius"), "");
			local externalMotorSoundFile = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#externalMotorSoundFile"), "");
			local beaconLightFilename = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#beaconLightFilename"), "");
			local supportAnimationName = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#supportAnimationName"), "");
			local changeConfigurationName = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#changeConfigurationName"), "");
			local topArmFilename = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#topArmFilename"), "");
			local maxForwardSpeed = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#maxForwardSpeed"), "");
			local ikChain = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#ikChain"), "");
			local addCamera = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#addCameraNode"), "");
			local additionalCharacterNode = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. ".additionalCharacter#node"), "");
			local characterNode = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. ".character#node"), "");
			local newTypeDesc = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#newTypeDesc"), "");

			if newTypeDesc ~= "" then
				setXMLString(self.xmlFile, "vehicle.base.typeDesc", newTypeDesc);

				printDebug("(extraOptions) :: Set 'typeDesc' to " .. newTypeDesc .. ".", 1, true);
			end;

			if characterNode ~= "" then
				setXMLString(self.xmlFile, "vehicle.enterable.character#node", characterNode);

				printDebug("(extraOptions) :: Set character 'node' to " .. characterNode .. ".", 1, true);

				local foldMinLimit = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".character#foldMinLimit"), "");
				local foldMaxLimit = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".character#foldMaxLimit"), "");
				local cameraMinDistance = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".character#foldMaxLimit"), "");
				local spineRotation = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. ".character#spineRotation"), "");

				if foldMinLimit ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.enterable.character#foldMinLimit", foldMinLimit);

					printDebug("(extraOptions) :: Set character 'foldMinLimit' to " .. foldMinLimit .. ".", 1, true);
				end;

				if foldMaxLimit ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.enterable.character#foldMaxLimit", foldMaxLimit);

					printDebug("(extraOptions) :: Set character 'foldMaxLimit' to " .. foldMaxLimit .. ".", 1, true);
				end;

				if cameraMinDistance ~= "" then
					setXMLString(self.xmlFile, "vehicle.enterable.character#cameraMinDistance", cameraMinDistance);

					printDebug("(extraOptions) :: Set character 'cameraMinDistance' to " .. cameraMinDistance .. ".", 1, true);
				end;

				if spineRotation ~= "" then
					setXMLString(self.xmlFile, "vehicle.enterable.character#spineRotation", spineRotation);

					printDebug("(extraOptions) :: Set character 'spineRotation' to " .. spineRotation .. ".", 1, true);
				end;
				
				local targetNumber = 0;
				
				while true do
					local targetKey = extraOptionKey .. ".character.target(" .. tostring(targetNumber) .. ")";
					
					if not hasXMLProperty(self.xmlFile, targetKey) then
						break;
					end;
					
					local ikChain = Utils.getNoNil(getXMLString(self.xmlFile, targetKey .. "#ikChain"), "");
					local targetNode = Utils.getNoNil(getXMLString(self.xmlFile, targetKey .. "#targetNode"), "");
					
					if ikChain ~= "" and targetNode ~= "" then
						setXMLString(self.xmlFile, "vehicle.enterable.character.target(" .. tostring(targetNumber) .. ")#ikChain", ikChain);
						setXMLString(self.xmlFile, "vehicle.enterable.character.target(" .. tostring(targetNumber) .. ")#targetNode", targetNode);
						
						printDebug("(extraOptions) :: Set character 'ikChain' to " .. ikChain .. ".", 1, true);
						printDebug("(extraOptions) :: Set character 'targetNode' to " .. targetNode .. ".", 1, true);
					else
						printError("(extraOptions) :: Missing 'ikChain' or 'targetNode' in '" .. targetKey .. "' Stop changeing character!", true, false);
					end;

					targetNumber = targetNumber + 1;
				end;
			end;

			if additionalCharacterNode ~= "" then
				setXMLString(self.xmlFile, "vehicle.enterable.additionalCharacter#node", additionalCharacterNode);

				printDebug("(extraOptions) :: Set additional character 'node' to " .. additionalCharacterNode .. ".", 1, true);

				local foldMinLimit = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".additionalCharacter#foldMinLimit"), "");
				local foldMaxLimit = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".additionalCharacter#foldMaxLimit"), "");
				local cameraMinDistance = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. ".additionalCharacter#foldMaxLimit"), "");
				local spineRotation = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. ".additionalCharacter#spineRotation"), "");

				if foldMinLimit ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.enterable.additionalCharacter#foldMinLimit", foldMinLimit);

					printDebug("(extraOptions) :: Set additional character 'foldMinLimit' to " .. foldMinLimit .. ".", 1, true);
				end;

				if foldMaxLimit ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.enterable.additionalCharacter#foldMaxLimit", foldMaxLimit);

					printDebug("(extraOptions) :: Set additional character 'foldMaxLimit' to " .. foldMaxLimit .. ".", 1, true);
				end;

				if cameraMinDistance ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.enterable.additionalCharacter#cameraMinDistance", cameraMinDistance);

					printDebug("(extraOptions) :: Set additional character 'cameraMinDistance' to " .. cameraMinDistance .. ".", 1, true);
				end;

				if spineRotation ~= "" then
					setXMLString(self.xmlFile, "vehicle.enterable.additionalCharacter#spineRotation", spineRotation);

					printDebug("(extraOptions) :: Set additional character 'spineRotation' to " .. spineRotation .. ".", 1, true);
				end;

				local targetNumber = 0;
				
				while true do
					local targetKey = extraOptionKey .. ".additionalCharacter.target(" .. tostring(targetNumber) .. ")";
					
					if not hasXMLProperty(self.xmlFile, targetKey) then
						break;
					end;
					
					local ikChain = Utils.getNoNil(getXMLString(self.xmlFile, targetKey .. "#ikChain"), "");
					local targetNode = Utils.getNoNil(getXMLString(self.xmlFile, targetKey .. "#targetNode"), "");
					
					if ikChain ~= "" and targetNode ~= "" then
						setXMLString(self.xmlFile, "vehicle.enterable.additionalCharacter.target(" .. tostring(targetNumber) .. ")#ikChain", ikChain);
						setXMLString(self.xmlFile, "vehicle.enterable.additionalCharacter.target(" .. tostring(targetNumber) .. ")#targetNode", targetNode);
						
						printDebug("(extraOptions) :: Set additional character 'ikChain' to " .. ikChain .. ".", 1, true);
						printDebug("(extraOptions) :: Set additional character 'targetNode' to " .. targetNode .. ".", 1, true);
					else
						printError("(extraOptions) :: Missing 'ikChain' or 'targetNode' in '" .. targetKey .. "' Stop changeing additional character!", true, false);
					end;

					targetNumber = targetNumber + 1;
				end;
			end;

			if addCamera ~= "" then
				local transMin = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#cameraTransMin"), 0);
				local transMax = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#cameraTransMax"), 2);
				local rotMinX = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#rotMinX"), -1.1);
				local rotMaxX = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#rotMaxX"), 0.4);

				local useWorldXZRotation = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#cameraUseWorldXZRotation"), false);
				local rotatable = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#rotatable"), false);
				local limit = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#limit"), true);
				local useDefaultPositionSmoothing = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#useDefaultPositionSmoothing"), false);
				local isInside = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#isInside"), false);
				local useMirror = Utils.getNoNil(getXMLBool(self.xmlFile, extraOptionKey .. "#useMirror"), false);
				
				local cameraNumber = Utils.getNoNil(getXMLInt(self.xmlFile, extraOptionKey .. "#cameraNumber"), "");

				if cameraNumber == "" then
					printError("(extraOptions) :: Missing 'cameraNumber' for '" .. addCamera .. "' in '" .. extraOptionKey .. "' Using default value '3' instead! This could mess up your cameras!", true, false);

					cameraNumber = 3;
				end;

				local floatTable = {
					transMax = transMax, 
					transMin = transMin, 
					rotMinX = rotMinX, 
					rotMaxX = rotMaxX,
				};

				for tag, value in pairs(floatTable) do
					setXMLFloat(self.xmlFile, "vehicle.enterable.cameras.camera(" .. cameraNumber - 1 .. ")#" .. tag, value);

					printDebug("(extraOptions) :: Set camera tag '" .. tag .. "' to " .. tostring(value) .. ".", 1, true);
				end;

				local boolTable = {
					useWorldXZRotation = useWorldXZRotation, 
					rotatable = rotatable, 
					limit = limit, 
					useDefaultPositionSmoothing = useDefaultPositionSmoothing, 
					isInside = isInside, 
					useMirror = useMirror
				}; 

				for tag, value in pairs(boolTable) do
					setXMLBool(self.xmlFile, "vehicle.enterable.cameras.camera(" .. cameraNumber - 1 .. ")#" .. tag, value);

					printDebug("(extraOptions) :: Set camera tag '" .. tag .. "' to " .. tostring(value) .. ".", 1, true);
				end;

				setXMLString(self.xmlFile, "vehicle.enterable.cameras.camera(" .. cameraNumber - 1 .. ")#node", addCamera);
				
				printDebug("(extraOptions) :: Add camera '" .. addCamera .. "'.", 1, true);
			end;

			if ikChain ~= "" then
				local targetNode = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#targetNode"), "");

				if targetNode ~= "" then
					local ikChainNumber = 0;

					while true do
						local ikChainKey = "vehicle.enterable.characterNode.target(" .. tostring(ikChainNumber) .. ")";

						if not hasXMLProperty(self.xmlFile, ikChainKey) then
							break;
						end;

						local ikChainOld = getXMLString(self.xmlFile, ikChainKey .. "#ikChain");

						if ikChain == ikChainOld then
							local targetNodeOld = getXMLString(self.xmlFile, ikChainKey .. "#targetNode");
							local characterTargetNodeModifier = getXMLString(self.xmlFile, "vehicle.enterable.characterTargetNodeModifier#node");
							local stateNodeIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, extraOptionKey .. "#stateNodeIndices"))};

							if #stateNodeIndices > 0 then
								printDebug("(extraOptions) :: targetNodeOld = '" .. targetNodeOld .. "' vs characterTargetNodeModifier = '" .. characterTargetNodeModifier .. "'.", 2, true);

								if characterTargetNodeModifier == targetNodeOld then
									local stateNode = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#stateNode"), "");
									local referenceNode = Utils.getNoNil(getXMLString(self.xmlFile, extraOptionKey .. "#referenceNode"), "");

									if stateNode ~= "" and referenceNode ~= "" then
										setXMLString(self.xmlFile, "vehicle.enterable.characterTargetNodeModifier#node", targetNode);

										printDebug("(extraOptions) :: Set characterTargetNodeModifier target node to '" .. targetNode .. "'.", 1, true);

										for _, stateNodeIndice in pairs(stateNodeIndices) do
											local stateNodeKey = "vehicle.enterable.characterTargetNodeModifier.state(" .. tostring(stateNodeIndice - 1) .. ")";

											if hasXMLProperty(self.xmlFile, stateNodeKey) then	
												setXMLString(self.xmlFile, stateNodeKey .. "#node", stateNode);
												setXMLString(self.xmlFile, stateNodeKey .. "#referenceNode", referenceNode);

												printDebug("(extraOptions) :: Set state(" .. tostring(stateNodeIndice) .. ") node to '" .. stateNode .. "'.", 1, true);
												printDebug("(extraOptions) :: Set state(" .. tostring(stateNodeIndice) .. ") referenceNode to '" .. referenceNode .. "'.", 1, true);
											end;
										end;
									else
										if stateNode == "" then
											printError("(extraOptions) :: Missing 'stateNode' TAG for vehicle '" .. self.configFileName .. "'! Stop change ikChain!", true, false);
										else
											printError("(extraOptions) :: Missing 'referenceNode' TAG for vehicle '" .. self.configFileName .. "'! Stop change ikChain!", true, false);
										end;
									end;
								end;

								setXMLString(self.xmlFile, ikChainKey .. "#targetNode", targetNode);

								printDebug("(extraOptions) :: Set characterNode target node to '" .. targetNode .. "'.", 1, true);

								break;
							else
								printError("(extraOptions) :: Missing 'stateNodeIndices' TAG for vehicle '" .. self.configFileName .. "'! Stop change ikChain!", true, false);
							end;
						end;

						ikChainNumber = ikChainNumber + 1;
					end; 
				end;
			end;

			if maxForwardSpeed ~= "" then
				local motorIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, extraOptionKey .. "#motorIndices"))};

				if #motorIndices > 0 then
					for _, motorIndice in pairs(motorIndices) do
						local motorKey = string.format("vehicle.motorized.motorConfigurations.motorConfiguration(" .. tostring(motorIndice - 1) .. ")");

						if hasXMLProperty(self.xmlFile, motorKey) then
							setXMLFloat(self.xmlFile, motorKey .. ".motor#maxForwardSpeed", maxForwardSpeed);

							printDebug("(extraOptions) :: Set motor config(" .. tostring(motorIndice) .. ") max forward speed to '" .. maxForwardSpeed .. "'.", 1, true);

							local minForwardGearRatio = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#minForwardGearRatio"), "");

							if minForwardGearRatio ~= "" then
								local gearRatioKey = motorKey .. ".transmission";

								setXMLFloat(self.xmlFile, gearRatioKey .. "#minForwardGearRatio", minForwardGearRatio);

								printDebug("(extraOptions) :: Set motor config(" .. tostring(motorIndice) .. ") min forward gear ratio to '" .. minForwardGearRatio .. "'.", 1, true);
							end;
						end;
					end;
				else
					printError("(extraOptions) :: Missing 'motorIndices' TAG for vehicle '" .. self.configFileName .. "'! Stop change max forward speed!", true, false);
				end;
			end;

			if topArmFilename ~= "" then
				local attacherJointIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, extraOptionKey .. "#attacherJointIndices"))};
				
				if #attacherJointIndices > 0 then
					for _, attacherJointIndice in pairs(attacherJointIndices) do
						local attacherJointKey = string.format("vehicle.attacherJoints.attacherJoint(" .. tostring(attacherJointIndice - 1) .. ")");

						if hasXMLProperty(self.xmlFile, attacherJointKey) then
							if hasXMLProperty(self.xmlFile, attacherJointKey .. ".topArm#filename") then	
								setXMLString(self.xmlFile, attacherJointKey .. ".topArm#filename", topArmFilename);

								printDebug("(extraOptions) :: Set attacher joint(" .. tostring(attacherJointIndice) + 1 .. ") top arm filename to '" .. topArmFilename .. "'.", 1, true);
							end;
						end;
					end;
				else
					printError("(extraOptions) :: Missing 'attacherJointIndices' TAG for vehicle '" .. self.configFileName .. "'! Stop change top arm filename!", true, false);
				end;
			end;
			
			if supportAnimationName ~= "" then
				setXMLString(self.xmlFile, "vehicle.attachable.supportArm#animationName", "notDefined"); --## deactivate the manual support animation of my SupportArm Script
				setXMLString(self.xmlFile, "vehicle.attachable.support#animationName", supportAnimationName);

				printDebug("(extraOptions) :: Set support animation name to '" .. supportAnimationName .. "'.", 1, true);
			end;

			if beaconLightFilename ~= "" then
				local beaconLightIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, extraOptionKey .. "#beaconLightIndices"))};
				local beaconLightSpeed = Utils.getNoNil(getXMLFloat(self.xmlFile, extraOptionKey .. "#beaconLightSpeed"), "");
				
				if #beaconLightIndices > 0 then
					for _, beaconLightIndice in pairs(beaconLightIndices) do
						local beaconLightKey = string.format("vehicle.lights.beaconLights.beaconLight(" .. tostring(beaconLightIndice - 1) .. ")");

						if hasXMLProperty(self.xmlFile, beaconLightKey) then
							setXMLString(self.xmlFile, beaconLightKey .. "#filename", beaconLightFilename);

							printDebug("(extraOptions) :: Set beacon light(" .. tostring(beaconLightIndice) .. ") filename to '" .. beaconLightFilename .. "'.", 1, true);

							if beaconLightSpeed ~= "" then
								setXMLFloat(self.xmlFile, beaconLightKey .. "#speed", beaconLightSpeed);

								printDebug("(extraOptions) :: Set beacon light(" .. tostring(beaconLightIndice) .. ") speed to '" .. beaconLightSpeed .. "'.", 1, true);
							end;
						end;
					end;
				else
					local beaconLightNumber = 0;

					while true do
						local beaconLightKey = "vehicle.lights.beaconLights.beaconLight(" .. tostring(beaconLightNumber) .. ")";

						if not hasXMLProperty(self.xmlFile, beaconLightKey) then
							break;
						end;

						setXMLString(self.xmlFile, beaconLightKey .. "#filename", beaconLightFilename);

						printDebug("(extraOptions) :: Set beacon light(" .. tostring(beaconLightNumber + 1) .. ") filename to '" .. beaconLightFilename .. "'.", 1, true);

						if beaconLightSpeed ~= "" then
							setXMLFloat(self.xmlFile, beaconLightKey .. "#speed", beaconLightSpeed);

							printDebug("(extraOptions) :: Set beacon light(" .. tostring(beaconLightNumber) .. ") speed to '" .. beaconLightSpeed .. "'.", 1, true);
						end;

						beaconLightNumber = beaconLightNumber + 1;
					end;
				end;
			end;

			if externalMotorSoundFile ~= "" then
				setXMLString(self.xmlFile, "vehicle.motorized.sounds#externalSoundFile", externalMotorSoundFile);

				printDebug("(extraOptions) :: Set external motor sound file to '" .. externalMotorSoundFile .. "'.", 1, true);
			end;

			if self.spec_honk ~= nil then
				if honkSoundOuterRadius ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.honk.sound#outerRadius", honkSoundOuterRadius);
				end;

				if honkSoundInnerRadius ~= "" then
					setXMLFloat(self.xmlFile, "vehicle.honk.sound#innerRadius", honkSoundInnerRadius);
				end;

				if honkSoundTemplate ~= "" then	
					if hasXMLProperty(self.xmlFile, "vehicle.honk.sound#file") then	
						removeXMLProperty(self.xmlFile, "vehicle.honk.sound#file");
					end;

					setXMLString(self.xmlFile, "vehicle.honk.sound#template", honkSoundTemplate);

					printDebug("(extraOptions) :: Set honk sound template to '" .. honkSoundTemplate .. "'.", 1, true);
				elseif honkSoundFilename ~= "" then
					if hasXMLProperty(self.xmlFile, "vehicle.honk.sound#template") then	
						removeXMLProperty(self.xmlFile, "vehicle.honk.sound#template");
					end;

					setXMLString(self.xmlFile, "vehicle.honk.sound#file", honkSoundFilename);

					printDebug("(extraOptions) :: Set honk sound filename to '" .. AddConfig.currentModDirectory .. honkSoundFilename .. "'.", 1, true);
				end;
			end;

			if changeConfigurationName ~= "" then
				if self.configurations[changeConfigurationName] ~= nil then
					local configurationIndex = Utils.getNoNil(getXMLInt(self.xmlFile, extraOptionKey .. "#configurationIndex"), 1);
					
					local storeItem = g_storeManager:getItemByXMLFilename(self.configFileName);
					local config = storeItem.configurations[changeConfigurationName][configurationIndex];

					configName = config.name;

					if configName == "" then
						configName = "index " .. configurationIndex;
					end;

					ConfigurationUtil.setConfiguration(self, changeConfigurationName, configurationIndex);
					
					printDebug("(extraOptions) :: Set '" .. changeConfigurationName .. "' configuration to '" .. configName .. "' for vehicle '" .. self.configFileName .. "'.", 1, true);
				else
					printError("(extraOptions) :: Invalid '" .. changeConfigurationName .. "' configuration for vehicle '" .. self.configFileName .. "'! Stop change this configuration!", true, false);
				end;
			end;
		end;

	   extraOptionNumber = extraOptionNumber + 1;
   	end;
end;

function AddConfig:initExtraOptions(configName, configId, secondConfigName, extraOptionNeedUpdate, extraOptionOnLoad)
	local configKey = self:getConfigKey(configName, configId, secondConfigName);

	if configKey ~= "noKeyFound" then
		self:loadExtraOptions(configKey, extraOptionNeedUpdate, extraOptionOnLoad);
	else
		printError("(" .. configName .. "Configurations) :: Failed to load config key! Stop loading extra options from '" .. configName .. "Configurations'!", true, false);
	end;
end;

function AddConfig:setColor(configName, configId)
	local color = ConfigurationUtil.getColorByConfigId(self, configName, configId);

	printDebug("(" .. configName .. "Configurations) :: color = '" .. tostring(color) .. "'.", 1, true);

	if color ~= nil then
		local r, g, b, material = unpack(color);

		printDebug("(" .. configName .. "Configurations) :: r, g, b, materialId = " .. r .. ", " .. g .. ", " .. b .. ", " .. tostring(material), 1, true);

		local configNumber = 0;

		while true do
			local colorKey = string.format("vehicle.%sConfigurations.colorNode(%d)", configName, configNumber);

			if not hasXMLProperty(self.xmlFile, colorKey) then
				break;
			end;

			local node = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, colorKey .. "#node"), self.i3dMappings);

			if node ~= nil then
				local shaderParameter = Utils.getNoNil(getXMLString(self.xmlFile, colorKey .. "#shaderParameter"), "colorScale");
				local materialId = getXMLInt(self.xmlFile, colorKey .. "#materialId");

				if getHasClassId(node, ClassIds.SHAPE) then
					if getHasShaderParameter(node, shaderParameter) then
						if materialId == nil then
							_, _, _, materialId = getShaderParameter(node, shaderParameter);
						end
		
						printDebug("(" .. configName .. "Configurations) :: shader parameter values (r, g, b, materialId) = " .. r .. ", " .. g .. ", " .. b .. ", " .. tostring(Utils.getNoNil(materialId, Utils.getNoNil(color[4], 0))), 1, true);
						
						if Utils.getNoNil(getXMLBool(self.xmlFile, colorKey .. "#recursive"), false) then				
							I3DUtil.setShaderParameterRec(node, shaderParameter, r, g, b, Utils.getNoNil(materialId, Utils.getNoNil(color[4], 0)));
						else
							setShaderParameter(node, shaderParameter, r, g, b, Utils.getNoNil(materialId, Utils.getNoNil(color[4], 0)), true);
						end;
					else
						printError("(" .. configName .. "Configurations) :: Could not set vehicle color to '" .. getName(node) .. "' because the node has not the shader parameter '" .. shaderParameter .. "'! Stop try to coloring!", true, false);
					end;
				else
					printError("(" .. configName .. "Configurations) :: Could not set vehicle color to '" .. getName(node) .. "' because the node is not a shape! Stop try to coloring!", true, false);
				end;
			else
				printError("(" .. configName .. "Configurations) :: Could not find node! Stop try to coloring!", true, false);
			end;

			configNumber = configNumber + 1;
		end;

		configNumber = 0;

		while true do
			local materialKey = string.format("vehicle.%sConfigurations.material(%d)", configName, configNumber);

			if not hasXMLProperty(self.xmlFile, materialKey) then
				break;
			end;

			local materialName = getXMLString(self.xmlFile, materialKey .. "#name");

			if materialName ~= nil then
				local shaderParameterName = getXMLString(self.xmlFile, materialKey .. "#shaderParameter");

				if shaderParameterName ~= nil then
					local colorStr = getXMLString(self.xmlFile, materialKey .. "#color");
					local color;

					if colorStr ~= nil then
						color = g_brandColorManager:getBrandColorByName(colorStr);
					end;

					if color == nil then
						color = ConfigurationUtil.getColorByConfigId(self, configName, configId);
					end;

					if color ~= nil then
						local materialId = getXMLInt(self.xmlFile, materialKey .. "#materialId");

						if self.setBaseMaterialColor ~= nil then
							self:setBaseMaterialColor(materialName, shaderParameterName, color, Utils.getNoNil(materialId, Utils.getNoNil(color[4], 0)));
						else
							printError("(" .. configName .. "Configurations) :: Missing function 'setBaseMaterialColor'!", true, false);
						end;
					else
						printError("(" .. configName .. "Configurations) :: Failed to load color '" .. tostring(colorStr) .. "' in '" .. self.cofingFileName .. "'! Stop coloring '" .. materialName .. "'!", false, false);
					end;
				else
					printError("(" .. configName .. "Configurations) :: Missing shader parameter in '" .. self.cofingFileName .. "'! Stop coloring '" .. materialName .. "'!", true, false);
				end;
			end;

			configNumber = configNumber + 1;
		end;
	end;
end;

function AddConfig:changeObjects(configName, configId, secondConfigName)
	secondConfigName = Utils.getNoNil(secondConfigName, configName);

	local configKey = self:getConfigKey(configName, configId, secondConfigName);

	if configKey ~= "noKeyFound" then
    	local configNumber = 0;

   		while true do
     		local materialKey = string.format(configKey .. ".material(%d)", configNumber);

			if not hasXMLProperty(self.xmlFile, materialKey) then
            	break;
        	end;

			local baseMaterialNode = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, materialKey .. "#node"), self.i3dMappings);
        	local refMaterialNode = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, materialKey .. "#refNode"), self.i3dMappings);

			if baseMaterialNode ~= nil and refMaterialNode ~= nil then
            	local oldMaterial = getMaterial(baseMaterialNode, 0);
            	local newMaterial = getMaterial(refMaterialNode, 0);

				for _, component in pairs(self.components) do
               		ConfigurationUtil.replaceMaterialRec(self, component.node, oldMaterial, newMaterial);
            	end;
        	end;

			configNumber = configNumber + 1;
		end;
		
		local getRimColorAndIndexFromConfig = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.additional#getRimColorAndIndexFromConfig"), "");
		local getRimColorFromConfig = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.additional#getRimColorFromConfig"), "");
		
		if getRimColorAndIndexFromConfig ~= "" then
			if self.configurations[getRimColorAndIndexFromConfig] ~= nil then
				for _, wheel in pairs(self.spec_wheels.wheels) do
					if wheel.wheelAdditional ~= nil then
						local xmlKey = self:getConfigKey(self:getXMLPrefix(getRimColorAndIndexFromConfig), self.configurations[getRimColorAndIndexFromConfig], getRimColorAndIndexFromConfig);
						
						if xmlKey ~= "noKeyFound" then
							local additionalColor = getXMLString(self.xmlFile, xmlKey .. ".colorChanges.rim#color");
							local materialId = getXMLInt(self.xmlFile, xmlKey .. ".colorChanges.rim#materialId");
							local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, xmlKey .. ".colorChanges.rim#shaderParameterName"), "colorMat0");
							
							if additionalColor ~= nil then
								local additionalColorName = g_brandColorManager:getBrandColorByName(additionalColor);

								if additionalColorName == nil then
									additionalColorName = ConfigurationUtil.getColorFromString(additionalColor);
								end;

								if additionalColorName ~= nil then
									local r, g, b, _ = unpack(additionalColorName);
								
									if materialId == nil then
										_, _, _, materialId = getShaderParameter(wheel.wheelAdditional, shaderParameterName);
									end;

									setShaderParameter(wheel.wheelAdditional, shaderParameterName, r, g, b, Utils.getNoNil(materialId, Utils.getNoNil(additionalColorName[4], 0)), false);

									printDebug("(colorChanges) :: Change additional wheel color successfully in '" .. self.configFileName .. "'.", 1, true);
								else
									printError("(colorChanges) :: Failed to load rim color in configuration '" .. tostring(getRimColorAndIndexFromConfig) .. "'(line " .. self.configurations[getRimColorAndIndexFromConfig] + 1 .. ") in '" .. self.configFileName .. "'! Stop coloring '" .. tostring(getXMLString(self.xmlFile, xmlKey .. ".colorChanges#materialName")) .. "'!", false, false);
								end;
							end;
						end;
					end;
				end;
			end;
		elseif getRimColorFromConfig ~= "" then
			if self.configurations[getRimColorFromConfig] ~= nil then
				local isColorConfig = false;
				local colorName;
				local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.additional#shaderParameterName"), "colorMat0");

				for _, newConfguration in pairs(AddConfig.newConfgurations) do
					if getRimColorFromConfig == newConfguration.configName then
						isColorConfig = newConfguration.isColorConfig;

						break;
					end;
				end;

				for _, defaultColorConfiguration in pairs(AddConfig.defaultColorConfigurations) do
					if getRimColorFromConfig == defaultColorConfiguration then
						isColorConfig = true;

						break;
					end;
				end;

				if isColorConfig then
					colorName = ConfigurationUtil.getColorByConfigId(self, getRimColorFromConfig, self.configurations[getRimColorFromConfig]);
				else
					printError("(colorChanges) :: The configuration '" .. getRimColorFromConfig .. "' is not an color configuration! Stop coloring wheel weights!", false, true)
				end;
				
				if colorName ~= nil then
					for _, wheel in pairs(self.spec_wheels.wheels) do
						if wheel.wheelAdditional ~= nil then
							local r, g, b, _ = unpack(colorName);
							
							if materialId == nil then
								_, _, _, materialId = getShaderParameter(wheel.wheelAdditional, shaderParameterName);
							end;

							setShaderParameter(wheel.wheelAdditional, shaderParameterName, r, g, b, Utils.getNoNil(materialId, Utils.getNoNil(colorName[4], 0)), false);

							printDebug("(colorChanges) :: Change additional wheel color successfully in '" .. self.configFileName .. "'.", 1, true);
						end;
					end;
				end;
			end;
		end;

		--## change body color

		local colorNumber = 0;

		while true do
			local colorKey = configKey .. ".colorChanges.colorChange(" .. tostring(colorNumber) .. ")";

			if not hasXMLProperty(self.xmlFile, colorKey) then
				break;
			end;

			local color = getXMLString(self.xmlFile, colorKey .. "#color");
			local getColorFromConfig = getXMLString(self.xmlFile, colorKey .. "#getColorFromConfig");
			local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, colorKey .. "#shaderParameterName"), "colorMat0");
			local materialName = getXMLString(self.xmlFile, colorKey .. "#materialName");
			local materialId = getXMLInt(self.xmlFile, colorKey .. "#materialId");
			local colorName;
			local isColorConfig = false;
			local doStop = false;

			if materialName ~= nil then
				if getColorFromConfig ~= nil then
					if self.configurations[getColorFromConfig] ~= nil then	
						for _, newConfguration in pairs(AddConfig.newConfgurations) do
							if getColorFromConfig == newConfguration.configName then
								isColorConfig = newConfguration.isColorConfig;

								break;
							end;
						end;

						for _, defaultColorConfiguration in pairs(AddConfig.defaultColorConfigurations) do
							if getColorFromConfig == defaultColorConfiguration then
								isColorConfig = true;

								break;
							end;
						end;	


						if isColorConfig then
							colorName = ConfigurationUtil.getColorByConfigId(self, getColorFromConfig, self.configurations[getColorFromConfig]);
						else
							printError("(colorChanges) :: The configuration '" .. getColorFromConfig .. "' is not an color configuration! Stop coloring part '" .. materialName .. "'!", false, true);

							doStop = true;
						end;
					else
						printError("(colorChanges) :: Can't find the configuration '" .. getColorFromConfig .. "' in vehicle '" .. self.configFileName .. "'! Stop coloring part '" .. materialName .. "'!", false, true);

						doStop = true;
					end;
				else
					colorName = g_brandColorManager:getBrandColorByName(color);
				end;

				if not doStop then
					if colorName == nil then
						colorName = ConfigurationUtil.getColorFromString(color);
					end;

					if colorName ~= nil then
						self:setBaseMaterialColor(materialName, shaderParameterName, colorName, Utils.getNoNil(materialId, Utils.getNoNil(colorName[4], 0)));
					
						printDebug("(colorChanges) :: Change color successfully in '" .. self.configFileName .. "' for '" .. materialName .. "'.", 1, true);
					else
						printError("(colorChanges) :: Failed to load color '" .. tostring(color) .. "' in '" .. self.configFileName .. "'! Stop coloring '" .. materialName .. "'!", false, false);
					end;
				end;
			else
				printError("(colorChanges) :: Missing 'materialName' in '" .. self.configFileName .. "'! Stop coloring this vehicle body!", false, false);
			end;

			colorNumber = colorNumber + 1;
		end;

		--## change crawler color

		local specCrawlers = self.spec_crawlers;
		
		if specCrawlers ~= nil then
			local crawlerColorStr = getXMLString(self.xmlFile, configKey .. ".colorChanges.crawler#color");
			local crawlerColor2Str = getXMLString(self.xmlFile, configKey .. ".colorChanges.crawler#color2");
			local materialId = getXMLInt(self.xmlFile, configKey .. ".colorChanges.crawler#materialId");
			local materialIdBackUp = materialId;
			local materialId1 = getXMLInt(self.xmlFile, configKey .. ".colorChanges.crawler#materialId1");
			local materialId2 = getXMLInt(self.xmlFile, configKey .. ".colorChanges.crawler#materialId2");

			if crawlerColorStr ~= nil then
				crawlerColor = g_brandColorManager:getBrandColorByName(crawlerColorStr);
			
				if crawlerColor == nil then
					crawlerColor = StringUtil.getVectorNFromString(crawlerColorStr, 3);
				end;
			
				crawlerColor2 = crawlerColor;

				if crawlerColor2Str ~= nil then
					crawlerColor2 = g_brandColorManager:getBrandColorByName(crawlerColor2Str);
				
					if crawlerColor2 == nil then
						crawlerColor2 = StringUtil.getVectorNFromString(crawlerColor2Str, 3);
					end;
				end;
			
				for _, crawler in pairs(specCrawlers.crawlers) do
					if materialId1 ~= nil then
						materialId = materialId1;
					end;

					I3DUtil.setShaderParameterRec(crawler.loadedCrawler, "colorMat0", crawlerColor[1], crawlerColor[2], crawlerColor[3], Utils.getNoNil(materialId, Utils.getNoNil(crawlerColor[4], 0)));

					printDebug("(colorChanges) :: Change crawler color (colorMat0) successfully in '" .. self.configFileName .. "' to '" .. crawlerColorStr .. "' for node '" .. getName(crawler.loadedCrawler) .. "'.", 1, true);
					
					materialId = materialIdBackUp;

					if materialId2 ~= nil then
						materialId = materialId2;
					end;
					
					I3DUtil.setShaderParameterRec(crawler.loadedCrawler, "colorMat1", crawlerColor2[1], crawlerColor2[2], crawlerColor2[3], Utils.getNoNil(materialId, Utils.getNoNil(crawlerColor2[4], 0)));

					printDebug("(colorChanges) :: Change crawler color (colorMat1) successfully in '" .. self.configFileName .. "' to '" .. Utils.getNoNil(crawlerColor2Str, crawlerColorStr) .. "' for node '" .. getName(crawler.loadedCrawler) .. "'.", 1, true);

					for _, scrollerNode in pairs(crawler.scrollerNodes) do
						--## fix for not coloring the track..
						setShaderParameter(scrollerNode.node, "colorMat0", 0.028, 0.025, 0.023, 5, false);

						printDebug("(colorChanges) :: Stop coloring successfully in '" .. self.configFileName .. "' for '" .. getName(scrollerNode.node) .. "'.", 1, true);
					end;

					materialId = materialIdBackUp;
				end;
			end;
		end;
			
		--## change top arm color

		local attacherJointIndices = {StringUtil.getVectorFromString(getXMLString(self.xmlFile, configKey .. ".colorChanges.topArm#attacherJointIndices"))};
		local topArmColorStr = getXMLString(self.xmlFile, configKey .. ".colorChanges.topArm#color");
		local topArmColor2Str = getXMLString(self.xmlFile, configKey .. ".colorChanges.topArm#color2");
		local topArmColor3Str = getXMLString(self.xmlFile, configKey .. ".colorChanges.topArm#decalColor");
		
		if topArmColorStr ~= nil then
			local topArmColor = g_brandColorManager:getBrandColorByName(topArmColorStr);

			if topArmColor == nil then
				topArmColor = StringUtil.getVectorNFromString(topArmColorStr, 3);
			end;

			local topArmColor2 = topArmColor;
			local topArmColor3;

			if topArmColor2Str ~= nil then
				topArmColor2 = g_brandColorManager:getBrandColorByName(topArmColor2Str);

				if topArmColor2 == nil then
					topArmColor2 = StringUtil.getVectorNFromString(topArmColor2Str, 3);
				end;
			end;


			if topArmColor3Str ~= nil then
				topArmColor3 = g_brandColorManager:getBrandColorByName(topArmColor3Str);

				if topArmColor3 == nil then
					topArmColor3 = StringUtil.getVectorNFromString(topArmColor3Str, 3);
				end;
			end;

			if attacherJointIndices ~= nil then
				for _, attacherJointIndice in pairs(attacherJointIndices) do
					local baseName = string.format("vehicle.attacherJoints.attacherJoint(" .. attacherJointIndice - 1 .. ")");

					if hasXMLProperty(self.xmlFile, baseName) then
						local baseNode = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, baseName.. ".topArm#baseNode"), self.i3dMappings);

						if baseNode ~= nil then
							local materialId = getXMLInt(self.xmlFile, configKey .. ".colorChanges.topArm#materialId");
							local materialIdBackUp = materialId;
							local materialId1 = getXMLInt(self.xmlFile, configKey .. ".colorChanges.topArm#materialId1");
							local materialId2 = getXMLInt(self.xmlFile, configKey .. ".colorChanges.topArm#materialId2");

							if materialId1 ~= nil then
								materialId = materialId1;
							end;

							I3DUtil.setShaderParameterRec(baseNode, "colorMat0", topArmColor[1], topArmColor[2], topArmColor[3], Utils.getNoNil(materialId, Utils.getNoNil(topArmColor[4], 0)));
							
							materialId = materialIdBackUp;

							if materialId2 ~= nil then
								materialId = materialId2;
							end;
							
							I3DUtil.setShaderParameterRec(baseNode, "colorMat1", topArmColor2[1], topArmColor2[2], topArmColor2[3], Utils.getNoNil(materialId, Utils.getNoNil(topArmColor2[4], 0)));

							printDebug("(colorChanges) :: Change top arm color (colorMat0) successfully in '" .. self.configFileName .. "' to '" .. topArmColorStr .. "' for node '" .. getName(baseNode) .. "'.", 1, true);
							printDebug("(colorChanges) :: Change top arm color (colorMat1) successfully in '" .. self.configFileName .. "' to '" .. Utils.getNoNil(topArmColor2Str, topArmColorStr) .. "' for node '" .. getName(baseNode) .. "'.", 1, true);

							if topArmColor3 ~= nil then
								I3DUtil.setShaderParameterRec(baseNode, "colorMat2", topArmColor3[1], topArmColor3[2], topArmColor3[3], 1);
								
								printDebug("(colorChanges) :: Change top arm decal color (colorMat2) successfully in '" .. self.configFileName .. "' to '" .. topArmColor3Str .. "' for node '" .. getName(baseNode) .. "'.", 1, true);
							end;

							materialId = materialIdBackUp;
						end;
					end;
				end;
			end;
		end;

		--## change starfire color

		local starfireNumber = 0;

		while true do
			local starfireKey = configKey .. ".colorChanges.starfires.starfire(" .. tostring(starfireNumber) .. ")";

			if not hasXMLProperty(self.xmlFile, starfireKey) then
				break;
			end;

			local starfire = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, starfireKey .. "#node"), self.i3dMappings);

			if starfire ~= nil then
				local starfireColorStr = getXMLString(self.xmlFile, starfireKey .. "#color");
				local starfireColor2Str = getXMLString(self.xmlFile, starfireKey .. "#color2");

				if starfireColorStr ~= nil then
					local starfireColor = g_brandColorManager:getBrandColorByName(starfireColorStr);
				
					if starfireColor == nil then
						starfireColor = StringUtil.getVectorNFromString(starfireColorStr, 3);
					end;

					local starfireColor2 = starfireColor;

					if starfireColor2Str ~= nil then
						starfireColor2 = g_brandColorManager:getBrandColorByName(starfireColor2Str);
					
						if starfireColor2 == nil then
							starfireColor2 = StringUtil.getVectorNFromString(starfireColor2Str, 3);
						end;
					end;

					local materialId = getXMLInt(self.xmlFile, starfireKey .. "#materialId");
					local materialIdBackUp = materialId;
					local materialId1 = getXMLInt(self.xmlFile, starfireKey .. "#materialId1");
					local materialId2 = getXMLInt(self.xmlFile, starfireKey .. "#materialId2");

					if starfireColor ~= nil then
						if materialId1 ~= nil then
							materialId = materialId1;
						end;

						I3DUtil.setShaderParameterRec(starfire, "colorMat0", starfireColor[1], starfireColor[2], starfireColor[3], Utils.getNoNil(materialId, Utils.getNoNil(starfireColor[4], 0)));

						printDebug("(colorChanges) :: Change starfire color (colorMat0) successfully in '" .. self.configFileName .. "' to '" .. starfireColorStr .. "' for node '" .. getName(starfire) .. "'.", 1, true);
					else
						printError("(colorChanges) :: Failed to load color (colorMat0) '" .. tostring(starfireColorStr) .. "' in '" .. self.configFileName .. "'! Stop coloring starfire!", false, false);
					end;

					if starfireColor2 ~= nil then
						materialId = materialIdBackUp;
						
						if materialId2 ~= nil then
							materialId = materialId2;
						end;
						
						I3DUtil.setShaderParameterRec(starfire, "colorMat1", starfireColor2[1], starfireColor2[2], starfireColor2[3], Utils.getNoNil(materialId, Utils.getNoNil(starfireColor2[4], 0)));

						printDebug("(colorChanges) :: Change starfire color (colorMat1) successfully in '" .. self.configFileName .. "' to '" .. Utils.getNoNil(starfireColor2Str, starfireColorStr) .. "' for node '" .. getName(starfire) .. "'.", 1, true);
					else
						printError("(colorChanges) :: Failed to load color (colorMat1) '" .. tostring(starfireColor2Str) .. "' in '" .. self.configFileName .. "'! Stop coloring starfire!", false, false);
					end;

					materialId = materialIdBackUp;
				end;

				local decalMaterialHolderNode = I3DUtil.indexToObject(self.components, getXMLString(self.xmlFile, starfireKey .. "#decalMaterialHolderNode"), self.i3dMappings);

				if decalMaterialHolderNode ~= nil then
					local decalIndex = Utils.getNoNil(getXMLInt(self.xmlFile, starfireKey .. "#decalIndex"), 0);
					local getChildFromStarfire = Utils.getNoNil(getXMLBool(self.xmlFile, starfireKey .. "#getChildFromStarfire"), true);
					local starfireNode = starfire;

					if getChildFromStarfire then
						starfireNode = getChildAt(starfire, 0);
					end;
					
					if getHasClassId(starfireNode, ClassIds.SHAPE) then
						if getHasClassId(getChildAt(starfireNode, decalIndex), ClassIds.SHAPE) then
							local newMaterial = getMaterial(decalMaterialHolderNode, 0);

							setMaterial(getChildAt(starfireNode, decalIndex), newMaterial, 0);

							printDebug("(colorChanges) :: Change starfire decal color successfully in '" .. self.configFileName .. "' for node '" .. getName(getChildAt(starfireNode, decalIndex)) .. "'.", 1, true);
						else
							printError("(colorChanges) :: The decal node  '" .. getName(getChildAt(starfireNode, decalIndex)) .. "' is not a shape in '" .. self.configFileName .. "'! Stop change starfire decal!", false, false);
						end;
					else
						printError("(colorChanges) :: The parent node  '" .. getName(starfireNode) .. "' is not a shape in '" .. self.configFileName .. "'! Stop change starfire decal!", false, false);
					end;
        		end;
			end;

			starfireNumber = starfireNumber + 1;
		end;
		
		--## change rim and axis color
		if self.spec_wheels ~= nil then
			local innerRimColor = getXMLString(self.xmlFile, configKey .. ".colorChanges.innerRim#color");
			local outerRimColor = getXMLString(self.xmlFile, configKey .. ".colorChanges.outerRim#color");
			local additionalColor = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.additional#color"), getXMLString(self.xmlFile, configKey .. ".colorChanges.rim#color"));

			if additionalColor ~= nil then
				local materialId = getXMLInt(self.xmlFile, configKey .. ".colorChanges.additional#materialId");
				local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.additional#shaderParameterName"), "colorMat0");
				local additionalColorName = g_brandColorManager:getBrandColorByName(additionalColor);

				if additionalColorName == nil then
					additionalColorName = ConfigurationUtil.getColorFromString(additionalColor);
				end;
				
				if additionalColorName ~= nil then
					local r, g, b, mat = unpack(additionalColorName);

					for _, wheel in pairs(self.spec_wheels.wheels) do
						if wheel.wheelAdditional ~= nil then
							if getHasShaderParameter(wheel.wheelAdditional, shaderParameterName) then	
								if materialId == nil then
									materialId = mat;

									if materialId == nil then		
										_, _, _, materialId = getShaderParameter(wheel.wheelAdditional, shaderParameterName);
									end;
								end;

								setShaderParameter(wheel.wheelAdditional, shaderParameterName, r, g, b, materialId, false);

								printDebug("(colorChanges) :: Change additional wheel color successfully in '" .. self.configFileName .. "'.", 1, true);
							else
								printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional wheels!", false, false);
							end;
						end;
					end;
				else
					printError("(colorChanges) :: Failed to load color '" .. tostring(additionalColor) .. "' in '" .. self.configFileName .. "'! Stop coloring additional wheels!", false, false);
				end;
			end;

			local hubColorNumber = 0;

			while true do
				local hubColorKey = configKey .. ".colorChanges.hub(" .. tostring(hubColorNumber) .. ")";

				if not hasXMLProperty(self.xmlFile, hubColorKey) then
					break;
				end;

				local hubColor = getXMLString(self.xmlFile, hubColorKey .. "#color");

				if hubColor ~= nil then
					local materialId = getXMLInt(self.xmlFile, hubColorKey .. "#materialId");
					local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, hubColorKey .. "#shaderParameterName"), "colorMat0");
	
					for _, hub in pairs(self.spec_wheels.hubs) do
						local hubColorName = g_brandColorManager:getBrandColorByName(hubColor);
	
						if hubColorName == nil then
							hubColorName = ConfigurationUtil.getColorFromString(hubColor);
						end;
	
						if hubColorName ~= nil then
							if hub.node ~= nil then
								if getHasShaderParameter(hub.node, shaderParameterName) then	
									local r, g, b, mat = unpack(hubColorName);
								
									if materialId == nil then
										materialId = mat;
									
										if materialId == nil then	
											_, _, _, materialId = getShaderParameter(hub.node, shaderParameterName);
										end;
									end;
								
									setShaderParameter(hub.node, shaderParameterName, r, g, b, materialId, false);
								
									printDebug("(colorChanges) :: Change hub color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
								else
									printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring hubs!", false, false);
								end;
							end;
						else
							printError("(colorChanges) :: Failed to load color '" .. tostring(hubColor) .. "' in '" .. self.configFileName .. "'! Stop coloring hubs!", false, false);
						end;
					end;
				end;

				hubColorNumber = hubColorNumber + 1;
			end;

			local rimColorNumber = 0;

			while true do
				local rimColorKey = configKey .. ".colorChanges.rim(" .. tostring(rimColorNumber) .. ")";

				if not hasXMLProperty(self.xmlFile, rimColorKey) then
					break;
				end;

				local getColorFromConfig = getXMLString(self.xmlFile, rimColorKey .. "#getColorFromConfig");
				local rimColor = getXMLString(self.xmlFile, rimColorKey .. "#color");
				local rimColorName;

				if getColorFromConfig ~= nil then
					if self.configurations[getColorFromConfig] ~= nil then	
						for _, newConfguration in pairs(AddConfig.newConfgurations) do
							if getColorFromConfig == newConfguration.configName then
								isColorConfig = newConfguration.isColorConfig;

								break;
							end;
						end;

						for _, defaultColorConfiguration in pairs(AddConfig.defaultColorConfigurations) do
							if getColorFromConfig == defaultColorConfiguration then
								isColorConfig = true;

								break;
							end;
						end;	


						if isColorConfig then
							rimColorName = ConfigurationUtil.getColorByConfigId(self, getColorFromConfig, self.configurations[getColorFromConfig]);
						else
							printError("(colorChanges) :: The configuration '" .. getColorFromConfig .. "' is not an color configuration! Stop coloring rims!", false, true);

							doStop = true;
						end;
					else
						printError("(colorChanges) :: Can't find the configuration '" .. getColorFromConfig .. "' in vehicle '" .. self.configFileName .. "'! Stop coloring rims!", false, true);

						doStop = true;
					end;
				end;

				if rimColor ~= nil or rimColorName ~= nil then			
					local materialId = getXMLInt(self.xmlFile, rimColorKey .. "#materialId");
					local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, rimColorKey .. "#shaderParameterName"), "colorMat0");

					if rimColor ~= nil then
						rimColorName = g_brandColorManager:getBrandColorByName(rimColor);

						if rimColorName == nil then
							rimColorName = ConfigurationUtil.getColorFromString(rimColor);
						end;
					end;

					if rimColorName ~= nil then
						local r, g, b, mat = unpack(rimColorName);

						for _, wheel in pairs(self.spec_wheels.wheels) do
							if wheel.wheelOuterRim ~= nil then
								if getHasShaderParameter(wheel.wheelOuterRim, shaderParameterName) then	
									if materialId == nil then
										materialId = mat;
									
										if materialId == nil then	
											_, _, _, materialId = getShaderParameter(wheel.wheelOuterRim, shaderParameterName);
										end;
									end;
								
									setShaderParameter(wheel.wheelOuterRim, shaderParameterName, r, g, b, materialId, false);
								
									printDebug("(colorChanges) :: Change outer rim color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
								else
									printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring outer rims!", false, false);
								end;
							end;

							if wheel.wheelInnerRim ~= nil then
								if getHasShaderParameter(wheel.wheelInnerRim, shaderParameterName) then
									if materialId == nil then
										materialId = mat;
									
										if materialId == nil then	
											_, _, _, materialId = getShaderParameter(wheel.wheelInnerRim, shaderParameterName);
										end;
									end;
								
									setShaderParameter(wheel.wheelInnerRim, shaderParameterName, r, g, b, materialId, false);
								
									printDebug("(colorChanges) :: Change inner rim color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
								else
									printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring inner rims!", false, false);
								end;
							end;

							if wheel.additionalWheels ~= nil then
								for _, additionalWheel in pairs(wheel.additionalWheels) do	
									if additionalWheel.wheelOuterRim ~= nil then	
										if getHasShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName) then	
											if materialId == nil then
												materialId = mat;
											
												if materialId == nil then	
													_, _, _, materialId = getShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName);
												end;
											end;
										
											setShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName, r, g, b, materialId, false);

											printDebug("(colorChanges) :: Change additional outer rim color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
										else
											printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional outer rims!", false, false);
										end;
									end;

									if additionalWheel.wheelInnerRim ~= nil then
										if getHasShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName) then
											if materialId == nil then
												materialId = mat;
											
												if materialId == nil then	
													_, _, _, materialId = getShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName);
												end;
											end;
										
											setShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName, r, g, b, materialId, false);

											printDebug("(colorChanges) :: Change inner rim color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
										else
											printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional inner rims!", false, false);
										end;
									end;

									if additionalWheel.connector ~= nil and additionalWheel.connector.node ~= nil then	
										if getHasShaderParameter(additionalWheel.connector.node, shaderParameterName) then
											if materialId == nil then
												materialId = mat;
											
												if materialId == nil then
													_, _, _, materialId = getShaderParameter(additionalWheel.connector.node, shaderParameterName);
												end;
											end;
										
											setShaderParameter(additionalWheel.connector.node, shaderParameterName, r, g, b, materialId, false);

											printDebug("(colorChanges) :: Change additional connector color (shaderParameterName = '" .. shaderParameterName .. "') successfully in '" .. self.configFileName .. "'.", 1, true);
										else
											printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional connector!", false, false);
										end;
									end;
								end;
							end;
						end;
					else
						printError("(colorChanges) :: Failed to load color '" .. tostring(rimColor) .. "' in '" .. self.configFileName .. "'! Stop coloring rims!", false, false);
					end;
				end;
				
				rimColorNumber = rimColorNumber + 1;
			end;

			if innerRimColor ~= nil then			
				local materialId = getXMLInt(self.xmlFile, configKey .. ".colorChanges.innerRimColor#materialId");
				local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.innerRimColor#shaderParameterName"), "colorMat0");

				local innerRimColorName = g_brandColorManager:getBrandColorByName(innerRimColor);

				if innerRimColorName == nil then
					innerRimColorName = ConfigurationUtil.getColorFromString(innerRimColor);
				end;

				if innerRimColorName ~= nil then
					local r, g, b, mat = unpack(innerRimColorName);
					
					for _, wheel in pairs(self.spec_wheels.wheels) do
						if wheel.wheelInnerRim ~= nil then
							if getHasShaderParameter(wheel.wheelInnerRim, shaderParameterName) then
								if materialId == nil then
									materialId = mat;

									if materialId == nil then	
										_, _, _, materialId = getShaderParameter(wheel.wheelInnerRim, shaderParameterName);
									end;
								end;
							
								setShaderParameter(wheel.wheelInnerRim, shaderParameterName, r, g, b, materialId, false);
							
								printDebug("(colorChanges) :: Change inner rim color successfully in '" .. self.configFileName .. "'.", 1, true);
							else
								printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring inner rims!", false, false);
							end;
						end;

						if wheel.additionalWheels ~= nil then
							for _, additionalWheel in pairs(wheel.additionalWheels) do	
								if additionalWheel.wheelInnerRim ~= nil then
									if getHasShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName) then
										if materialId == nil then
											materialId = mat;
										
											if materialId == nil then	
												_, _, _, materialId = getShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName);
											end;
										end;
									
										setShaderParameter(additionalWheel.wheelInnerRim, shaderParameterName, r, g, b, materialId, false);

										printDebug("(colorChanges) :: Change additional inner rim color successfully in '" .. self.configFileName .. "'.", 1, true);
									else
										printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional inner rims!", false, false);
									end;
								end;
							end;
						end;
					end;
				else
					printError("(colorChanges) :: Failed to load color '" .. tostring(innerRimColor) .. "' in '" .. self.configFileName .. "'! Stop coloring inner rims!", false, false);
				end;
			end;

			if outerRimColor ~= nil then			
				local materialId = getXMLInt(self.xmlFile, configKey .. ".colorChanges.outerRimColor#materialId");
				local shaderParameterName = Utils.getNoNil(getXMLString(self.xmlFile, configKey .. ".colorChanges.outerRimColor#shaderParameterName"), "colorMat0");

				local outerRimColorName = g_brandColorManager:getBrandColorByName(outerRimColor);

				if outerRimColorName == nil then
					outerRimColorName = ConfigurationUtil.getColorFromString(outerRimColor);
				end;

				if outerRimColorName ~= nil then
					local r, g, b, mat = unpack(outerRimColorName);
					
					for _, wheel in pairs(self.spec_wheels.wheels) do
						if wheel.wheelOuterRim ~= nil then
							if getHasShaderParameter(wheel.wheelOuterRim, shaderParameterName) then
								if materialId == nil then
									materialId = mat;

									if materialId == nil then
										_, _, _, materialId = getShaderParameter(wheel.wheelOuterRim, shaderParameterName);
									end;
								end;
							
								setShaderParameter(wheel.wheelOuterRim, shaderParameterName, r, g, b, materialId, false);
							
								printDebug("(colorChanges) :: Change outer rim color successfully in '" .. self.configFileName .. "'.", 1, true);
							else
								printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring outer rims!", false, false);
							end;
						end;

						if wheel.additionalWheels ~= nil then
							for _, additionalWheel in pairs(wheel.additionalWheels) do	
								if additionalWheel.wheelOuterRim ~= nil then
									if getHasShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName) then
										if materialId == nil then
											materialId = mat;
										
											if materialId == nil then	
												_, _, _, materialId = getShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName);
											end;
										end;
									
										setShaderParameter(additionalWheel.wheelOuterRim, shaderParameterName, r, g, b, materialId, false);

										printDebug("(colorChanges) :: Change additional outer rim color successfully in '" .. self.configFileName .. "'.", 1, true);
									else
										printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional outer rims!", false, false);
									end;
								end;

								if additionalWheel.connector ~= nil and additionalWheel.connector.node ~= nil then	
									if getHasShaderParameter(additionalWheel.connector.node, shaderParameterName) then
										if materialId == nil then
											materialId = mat;
										
											if materialId == nil then
												_, _, _, materialId = getShaderParameter(additionalWheel.connector.node, shaderParameterName);
											end;
										end;
									
										setShaderParameter(additionalWheel.connector.node, shaderParameterName, r, g, b, materialId, false);

										printDebug("(colorChanges) :: Change additional connector color successfully in '" .. self.configFileName .. "'.", 1, true);
									else
										printError("(colorChanges) :: Failed to load shader parameter '" .. tostring(shaderParameterName) .. "' in '" .. self.configFileName .. "'! Stop coloring additional connector!", false, false);
									end;
								end;
							end;
						end;
					end;
				else
					printError("(colorChanges) :: Failed to load color '" .. tostring(outerRimColor) .. "' in '" .. self.configFileName .. "'! Stop coloring outer rims!", false, false);
				end;
			end;
		end;

		ObjectChangeUtil.updateObjectChanges(self.xmlFile, "vehicle." .. configName .. "Configurations." .. secondConfigName .. "Configuration", configId, self.components, self);
	end;
end;