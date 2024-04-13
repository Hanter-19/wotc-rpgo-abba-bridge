class X2Ability_HanterRevertSniperStandardFire extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(HanterRevertSniperStandardFire());

	return Templates;
}

static function X2AbilityTemplate HanterRevertSniperStandardFire()
{
	local X2AbilityTemplate		Template;

	// Make a copy of base game's SniperStandardFire (in this case it may have been modified by Musashi's RPGO already)
	// Thanks LordAbizi for teaching me how to do this at https://discord.com/channels/165245941664710656/165245941664710656/1226079196665876553
	Template = class'X2Ability_WeaponCommon'.static.Add_SniperStandardFire('HanterRevertSniperStandardFire');

	// Make sure this ability has the added cost like the base game Sniper Standard Fire
	GetAbilityCostActionPoints(Template).bAddWeaponTypicalCost = true;

	// We will use Iridar's Template Master to replace SniperStandardFire with HanterRevertSniperStandardFire for the relevant ABBA XCOM weapons
	return Template;
}

// An alternative approach where we create a separate Sniper Standard Fire ability that is specifically 1 AP (Unused)
/*
static function X2AbilityTemplate HanterSingleActionSniperStandardFire()
{
	local X2AbilityTemplate		Template;

	Template = class'X2Ability_WeaponCommon'.static.Add_SniperStandardFire('HanterSingleActionSniperStandardFire');
	GetAbilityCostActionPoints(Template).bAddWeaponTypicalCost = false;

	return Template;
}
*/

// Copied from Musashi's RPGO code
private static function X2AbilityCost_ActionPoints GetAbilityCostActionPoints(X2AbilityTemplate Template)
{
	local X2AbilityCost Cost;
	foreach Template.AbilityCosts(Cost)
	{
		if (X2AbilityCost_ActionPoints(Cost) != none)
		{
			return X2AbilityCost_ActionPoints(Cost);
		}
	}
	return none;
}