class X2DownloadableContentInfo_RPGOxABBABridge extends X2DownloadableContentInfo;

// Example if we want to revert Sniper Standard Fire to 2 AP
/*
static event OnPostTemplatesCreated()
{
	Template = TemplateManager.FindAbilityTemplate('SniperStandardFire');
	GetAbilityCostActionPoints(Template).bAddWeaponTypicalCost = true;
}
*/