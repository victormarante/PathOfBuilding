loadStatFile("stat_descriptions.txt")

local lab = {
	[32] = "NORMAL",
	[53] = "CRUEL",
	[66] = "MERCILESS",
	[75] = "ENDGAME",
}
local labOrder = { "NORMAL", "CRUEL", "MERCILESS", "ENDGAME" }

local function doOtherEnchantment(fileName, group)
	local byDiff = { }
	for _, modKey in ipairs(Mods.GenerationType(10)) do
		local mod = Mods[modKey]
		if mod.CorrectGroup == group and mod.SpawnWeight_Values[1] > 0 then
			local stats, orders = describeMod(mod)
			local diff = lab[mod.Level]
			byDiff[diff] = byDiff[diff] or { }
			table.insert(byDiff[diff], stats)
		end
	end
	local out = io.open(fileName, "w")
	out:write('-- This file is automatically generated, do not edit!\n')
	out:write('-- Item data (c) Grinding Gear Games\n\nreturn {\n')
	for _, diff in ipairs(labOrder) do
		if byDiff[diff] then
			out:write('\t["'..diff..'"] = {\n')
			for _, stats in ipairs(byDiff[diff]) do
				out:write('\t\t"'..table.concat(stats, ' ')..'",\n')
			end
			out:write('\t},\n')
		end
	end
	out:write('}')
	out:close()
end

doOtherEnchantment("../Data/3_0/EnchantmentBoots.lua", "ConditionalBuffEnchantment")
doOtherEnchantment("../Data/3_0/EnchantmentGloves.lua", "TriggerEnchantment")

local skillMap = {
	["Summone?d?RagingSpirit"] = "Summon Raging Spirit",
	["Discharge"] = "Discharge",
	["AncestorTotem[^S][^l]"] = "Ancestral Protector",
	["AncestorTotemSlamMelee"] = "Ancestral Warchief",
	["AnimateGuardian"] = "Animate Guardian",
	["AnimateWeapon"] = "Animate Weapon",
	["BlinkArrow"] = "Blink Arrow",
	["ConversionTrap"] = "Conversion Trap",
	["MirrorArrow"] = "Mirror Arrow",
	["Spectre"] = "Raise Spectre",
	["Zombie"] = "Raise Zombie",
	["ChaosGolem"] = "Summon Chaos Golem",
	["FlameGolem"] = "Summon Flame Golem",
	["IceGolem"] = "Summon Ice Golem",
	["LightningGolem"] = "Summon Lightning Golem",
	["StoneGolem"] = "Summon Stone Golem",
	["Skeleton"] = "Summon Skeleton",
	["Bladefall"] = "Bladefall",
	["BlastRain"] = "Blast Rain",
	["ChargedAttack"] = "Blade Flurry",
	["Desecrate"] = "Desecrate",
	["DetonateDead"] = "Detonate Dead",
	["DevouringTotem"] = "Devouring Totem",
	["DominatingBlow"] = "Dominating Blow",
	["FireBeam"] = "Scorching Ray",
	["Firestorm"] = "Firestorm",
	["FreezeMine"] = "Freeze Mine",
	["EnchantmentFrenzy"] = "Frenzy",
	["GroundSlam"] = "Ground Slam",
	["HeavyStrike"] = "Heavy Strike",
	["IceSpear"] = "Ice Spear",
	["ImmortalCall"] = "Immortal Call",
	["Incinerate"] = "Incinerate",
	["KineticBlast"] = "Kinetic Blast",
	["LightningArrow"] = "Lightning Arrow",
	["ChargedDash"] = "Charged Dash",
	["PhaseRun"] = "Phase Run",
	["Puncture"] = "Puncture",
	["RejuvinationTotem"] = "Rejuvenation Totem",
	["ShockNova"] = "Shock Nova",
	["SpectralThrow"] = "Spectral Throw",
	["TectonicSlam"] = "Tectonic Slam",
	["TornadoShot"] = "Tornado Shot",
	["VolatileDead"] = "Volatile Dead",
	["BoneLance"] = "Unearth",
	["CorpseEruption"] = "Cremation",
	["PowerSiphon"] = "Power Siphon",
	["Smite"] = "Smite",
	["ConsecratedPath"] = "Consecrated Path",
	["ScourgeArrow"] = "Scourge Arrow",
	["HolyRelic"] = "Summon Holy Relic",
	["HeraldOfAgony"] = "Herald of Agony",
	["HeraldOfPurity"] = "Herald of Purity",
}

local bySkill = { }
for _, modKey in ipairs(Mods.GenerationType(10)) do
	local mod = Mods[modKey]
	if mod.CorrectGroup == "SkillEnchantment" and mod.SpawnWeight_Values[1] > 0 then
		local statKeys = { mod.StatsKey1, mod.StatsKey2, mod.StatsKey3, mod.StatsKey4, mod.StatsKey5, mod.StatsKey6 }
		local skill
		for _, statsKey in pairs(statKeys) do
			for _, activeSkillsKey in ipairs(ActiveSkills.Input_StatKeys(statsKey)) do
				local activeSkill = ActiveSkills[activeSkillsKey]
				local isVaal = false
				for _, skillType in ipairs(activeSkill.ActiveSkillTypes) do
					if skillType == 39 then
						isVaal = true
						break
					end
				end
				if not isVaal and activeSkill.DisplayedName ~= "" then
					skill = activeSkill.DisplayedName
					break
				end
			end
		end
		if not skill then
			for id, name in pairs(skillMap) do
				if mod.Id:match(id) then
					skill = name
					break
				end
			end
		end
		local stats, orders = describeMod(mod)
		if not skill or not stats[1] then
			printf("%s\n%s", mod.Id, stats[1])
		else
			bySkill[skill] = bySkill[skill] or { }
			local diff = lab[mod.Level]
			bySkill[skill][diff] = bySkill[skill][diff] or { }
			table.insert(bySkill[skill][diff], stats)
		end
	end
end
local skillOrder = { }
for skill in pairs(bySkill) do
	table.insert(skillOrder, skill)
end
table.sort(skillOrder)
local out = io.open("../Data/3_0/EnchantmentHelmet.lua", "w")
out:write('-- This file is automatically generated, do not edit!\n')
out:write('-- Item data (c) Grinding Gear Games\n\nreturn {\n')
for _, skill in pairs(skillOrder) do
	out:write('\t["'..skill..'"] = {\n')
	for _, diff in ipairs(labOrder) do
		if bySkill[skill][diff] then
			out:write('\t\t["'..diff..'"] = {\n')
			for _, stats in ipairs(bySkill[skill][diff]) do
				out:write('\t\t\t"'..table.concat(stats, ' ')..'",\n')
			end
			out:write('\t\t},\n')
		end
	end
	out:write('\t},\n')
end
out:write('}')
out:close()

print("Enchantments exported.")