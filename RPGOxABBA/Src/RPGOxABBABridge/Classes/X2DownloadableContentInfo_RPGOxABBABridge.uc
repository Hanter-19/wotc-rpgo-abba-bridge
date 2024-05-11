class X2DownloadableContentInfo_RPGOxABBABridge extends X2DownloadableContentInfo config (RPGOxABBA);

var config bool bLOG;

delegate ModifyTemplate(X2DataTemplate DataTemplate);

static event OnPostTemplatesCreated()
{
    /* Example if we want to revert Sniper Standard Fire to 2 AP
    Template = TemplateManager.FindAbilityTemplate('SniperStandardFire');
    GetAbilityCostActionPoints(Template).bAddWeaponTypicalCost = true;
    */

    // Use the helper function to patch all abilities
	// Only necessary if XModBase is running, because we are patching the behavior of XModBase templates
	// (actually both RPGO and ABBA have XModBase either in themselves or as dependencies, so the check isn't really necessary)
	// (nevertheless, I'm leaving it in as an example of how to check for XModBase being present)
	local int XMBVersion;

	XMBVersion = class'XMBDownloadableContentInfo_XModBase'.default.MajorVersion;

	if (XMBVersion != 0)
	{
		`LOG(GetFuncName() @ "Detected XModBase version" @ XMBVersion @ "; Proceeding to patch abilities.", default.bLOG, 'RPGOxABBA');
		IterateTemplatesAllDiff(class'X2AbilityTemplate', PatchAbilityTemplates);
	}
	else
	{
		`LOG(GetFuncName() @ "XModBase not detected. Skipping ability patching.", default.bLOG, 'RPGOxABBA');
	}
}

// Patch abilities whose effects require SniperStandardFire (such as Favid's Compensation perk)
static function PatchAbilityTemplates(X2DataTemplate DataTemplate)
{
    local X2AbilityTemplate             AbilityTemplate;
    local X2Effect                      Effect;
    local X2Effect_Persistent           PersistentEffect;
    local XMBEffect_AbilityCostRefund   RefundEffect;
    local X2Condition                   Condition;
    local XMBCondition_AbilityName      AbilityNameCondition;
    local array<name>                   IncludeAbilityNames;
    local X2AbilityTrigger              Trigger;

    AbilityTemplate = X2AbilityTemplate(DataTemplate);

    if (AbilityTemplate != none)
    {
        //`LOG(GetFuncName() @ "Iterating over ability:" @ AbilityTemplate.Name, default.bLOG, 'RPGOxABBA');
        // Patch Effects
        foreach AbilityTemplate.AbilityTargetEffects(Effect)
        {
            PersistentEffect = X2Effect_Persistent(Effect);
            if (PersistentEffect != none)
            {
                // This Effect is from XModBase, which means we will only pick up perks that were made using the same version of XModBase
                RefundEffect = XMBEffect_AbilityCostRefund(PersistentEffect);
                if (RefundEffect != none)
                {
                    `LOG(GetFuncName() @ "The ability" @ AbilityTemplate.Name @ "has XMBEffect_AbilityCostRefund", default.bLOG, 'RPGOxABBA');
                    foreach RefundEffect.AbilityTargetConditions(Condition)
                    {
                        AbilityNameCondition = XMBCondition_AbilityName(Condition);
                        if (AbilityNameCondition != none)
                        {
                            IncludeAbilityNames = AbilityNameCondition.IncludeAbilityNames;
                            if (IncludeAbilityNames.Length > 0 && IncludeAbilityNames.Find('SniperStandardFire') != INDEX_NONE)
                            {
                                AbilityNameCondition.IncludeAbilityNames.AddItem('HanterRevertSniperStandardFire');
                                `LOG(GetFuncName() @ "Added HanterRevertSniperStandardFire to IncludeAbilityNames of" @ Condition.Name @ "in" @ RefundEffect.Name @ "of" @ AbilityTemplate.Name, default.bLOG, 'RPGOxABBA');
                                break;
                            }
                        }
                    }
                }
            }
        }
        // Patch event listeners
        foreach AbilityTemplate.AbilityTriggers(Trigger)
        {
            //`LOG(GetFuncName() @ "Checking trigger" @ Trigger.Name @ "for" @ AbilityTemplate.Name, default.bLOG, 'RPGOxABBA');
            if (XMBAbilityTrigger_EventListener(Trigger) != none && XMBAbilityTrigger_EventListener(Trigger).AbilityTargetConditions.Length > 0)
            {
                foreach XMBAbilityTrigger_EventListener(Trigger).AbilityTargetConditions(Condition)
                {
                    //`LOG(GetFuncName() @ "Found" @ Condition.Name @ "for" @ Trigger.Name @ "for" @ AbilityTemplate.Name, default.bLOG, 'RPGOxABBA');
                    if (XMBCondition_AbilityName(Condition) != none && XMBCondition_AbilityName(Condition).IncludeAbilityNames.Length > 0 && XMBCondition_AbilityName(Condition).IncludeAbilityNames.Find('SniperStandardFire') != INDEX_NONE)
                    {
                        XMBCondition_AbilityName(Condition).IncludeAbilityNames.AddItem('HanterRevertSniperStandardFire');
                        `LOG(GetFuncName() @ "Added HanterRevertSniperStandardFire to IncludeAbilityNames of" @ Condition.Name @ "in" @ Trigger.Name @ "of" @ AbilityTemplate.Name, default.bLOG, 'RPGOxABBA');
                        break;
                    }
                }
            }
        }
    }
}

// Helper function from https://www.reddit.com/r/xcom2mods/wiki/index/build_against_mod/
static function bool IsModLoaded(name DLCName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for(Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--)  
    {
        if(EventManager.GetDLCNames(Index) == DLCName)  
        {
            return true;
        }
    }
    return false;
}

// Boilerplate helper code from https://www.reddit.com/r/xcom2mods/wiki/wotc_modding/optc/
static private function IterateTemplatesAllDiff(class TemplateClass, delegate<ModifyTemplate> ModifyTemplateFn)
{
    local X2DataTemplate                                    IterateTemplate;
    local X2DataTemplate                                    DataTemplate;
    local array<X2DataTemplate>                             DataTemplates;
    local X2DownloadableContentInfo_RPGOxABBABridge         CDO;

    local X2ItemTemplateManager             ItemMgr;
    local X2AbilityTemplateManager          AbilityMgr;
    local X2CharacterTemplateManager        CharMgr;
    local X2StrategyElementTemplateManager  StratMgr;
    local X2SoldierClassTemplateManager     ClassMgr;

    if (ClassIsChildOf(TemplateClass, class'X2ItemTemplate'))
    {
        CDO = GetCDO();
        ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

        foreach ItemMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            ItemMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {   
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2AbilityTemplate'))
    {
        CDO = GetCDO();
        AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

        foreach AbilityMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            AbilityMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2CharacterTemplate'))
    {
        CDO = GetCDO();
        CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
        foreach CharMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            CharMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2StrategyElementTemplate'))
    {
        CDO = GetCDO();
        StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
        foreach StratMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            StratMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2SoldierClassTemplate'))
    {

        CDO = GetCDO();
        ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
        foreach ClassMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            ClassMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }    
}

static private function ModifyTemplateAllDiff(name TemplateName, class TemplateClass, delegate<ModifyTemplate> ModifyTemplateFn)
{
    local X2DataTemplate                                    DataTemplate;
    local array<X2DataTemplate>                             DataTemplates;
    local X2DownloadableContentInfo_RPGOxABBABridge         CDO;

    local X2ItemTemplateManager             ItemMgr;
    local X2AbilityTemplateManager          AbilityMgr;
    local X2CharacterTemplateManager        CharMgr;
    local X2StrategyElementTemplateManager  StratMgr;
    local X2SoldierClassTemplateManager     ClassMgr;

    if (ClassIsChildOf(TemplateClass, class'X2ItemTemplate'))
    {
        ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
        ItemMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2AbilityTemplate'))
    {
        AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
        AbilityMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2CharacterTemplate'))
    {
        CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
        CharMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2StrategyElementTemplate'))
    {
        StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
        StratMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2SoldierClassTemplate'))
    {
        ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
        ClassMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else return;

    CDO = GetCDO();
    foreach DataTemplates(DataTemplate)
    {
        CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
    }
}

static private function X2DownloadableContentInfo_RPGOxABBABridge GetCDO()
{
    return X2DownloadableContentInfo_RPGOxABBABridge(class'XComEngine'.static.GetClassDefaultObjectByName(default.Class.Name));
}

protected function CallModifyTemplateFn(delegate<ModifyTemplate> ModifyTemplateFn, X2DataTemplate DataTemplate)
{
    ModifyTemplateFn(DataTemplate);
}