[h1]RPGO x ABBA[/h1]
This is a bridge mod to improve compatibility between [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1280477867]Musashi's RGO Overhaul (RPGO)[/url] and [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2243118743]Kiruka's A Better Barracks Arsenal for LWOTC (ABBA)[/url].

[h2]About[/h2]
RPGO makes sweeping changes to weapons and attachments (which actually can be enabled/disabled in the Mod Config Menu).
The Sniple Rifle changes clash (non game-breakingly) with several weapons from ABBA.

If you enable the Sniper Rifle changes in RPGO, that mod does the following:
[list]
	[*] Sniper rifles grant the Squadsight perk, but Squadsight is removed if the soldier moves during the turn.
	[*] Sniper rifles only require 1 action to fire.
[/list]
(You can view the full list of changes that RPGO makes to weapons at the [url=https://steamcommunity.com/workshop/filedetails/discussion/1280477867/1693785669848910158/]original thread[/url])

RPGO does this by reducing the AP cost of the SniperStandardFire ability (which in vanilla is exclusive to all sniple rifles). ABBA has several weapons, even non-sniper rifles, which use the SniperStandardFire ability for its 2AP cost:
[list]
	[*] Auto-Sniper Rifles
	[*] LMGs
	[*] Advent Scout Rifles
	[*] Advent Smartguns
[/list]
The result of RPGO's changes is that these weapons can still be fired with 1 AP. 
My opinion is that these weapons were clearly designed around this restriction, so this bridge mod replaces these weapons' SniperStandardFire ability with a duplicate ability that is exactly the same and costs 2 AP instead of the RPGO-modified 1 AP.

[b]In short, with this mod, the ABBA weapons designed to cost 2 AP will keep their behavior, while all other sniper rifles will follow the RPGO 1 AP changes.[/b]

Note that the Advent Scout Rifles have both the SniperStandardFire and Snapshot abilities, so by design those guns can still be fired after moving.
(You can view the full list of ABBA weapon descriptions at the original threads for [url=https://steamcommunity.com/workshop/filedetails/discussion/2243118743/2841165820094843657/]XCOM weapons[/url] and [url=https://steamcommunity.com/workshop/filedetails/discussion/2243118743/2841165820094895897/]Advent weapons[/url]

I also updated the localization for SniperStandardFire to match RPGO behavior.

[h2]FAQs[/h2]
[h3]Can I run RPGO and ABBA [i]without[/i] this mod?[/h3]
Yes. It is perfectly safe from my experience. The ABBA weapons will just be a bit overpowered.

[h3]Will this affect sniper rifles from other mods?[/h3]
No. I intentionally hard-coded this mod to specifically update the ABBA weapons only by giving them a new HanterRevertSniperStandardFire ability that does everything SniperStandardFire does and always costs 2 AP. This means any other sniper rifles from other mods (which will most likely be using SniperStandardFire) will have RPGO's changes applied.
If you happen to be running other mods with weapons using SniperStandardFire and feel that they should also cost 2 AP to fire, you can leverage my HanterRevertSniperStandardFire ability via .ini configurations thanks to [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2363075446]Iridar's Template Master[/url]. See the [b]XComTemplateEditor.ini[/b] file of this mod to see how I did it for the ABBA weapons.

[h3]Does this mod rebalance anything else?[/h3]
No and Maybe. 
No in a sense that I do not make any alteration to weapon stats, costs etc. and probably never will. 
Maybe in a sense that if I come across any other weapons with similar stituations to the Sniper Rifle changes, then I may update this mod to include a patch for that too.

[h3]Why is Iridar's Template Master required?[/h3]
Iridar's amazing [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2363075446]Template Master[/url] allows anyone to modify various game objects purely through configurations in .ini files. My mod uses it to update the ABBA weapons. Anyway, ABBA was built using the Template Master as well, so you should already have it if you're getting this mod.

[h3]Is this mod compatible with LWotC?[/h3]
Probably? First of all, you have to be pretty ambitious to try running RPGO with LWotC. I'm aware there's a [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2774354113]bridge mod[/url] for that, but I haven't played LWotC yet so I don't know for sure.
I don't know if LWotC does anything to Sniper Rifles and the SniperStandardFire ability. I built this mod to give ABBA weapons a separate ability anyway so it shouldn't cause any problems to other LWotC stuff.

[h2]Credits and Appreciation[/h2]
Musashi for RPGO
Kiruka for ABBA
DerBK for the A Better series of mods, which led to Kiruka making ABBA
Iridar for the Template Master and the immense convenience it brings
LordAbizi for teaching me how to make a copy of the vanilla SniperStandardFire ability

Everyone has permission to reuse my code (which is also available on [url=https://github.com/Hanter-19]my github[/url]) or repackage it if necessary, especially if something breaks and I'm no longer actively modding XCOM 2. Just don't be a weirdo who reuploads other people's mods for internet clout??