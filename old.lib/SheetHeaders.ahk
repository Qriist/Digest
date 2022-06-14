SheetHeaders(Module)
{
	headers=
	if Module in armor, weapon, misc
		headers=name	version	compactsave	rarity	spawnable	minac	maxac	absorbs	speed	reqstr	reqdex	block	durability	nodurability	level	levelreq	cost	gamble cost	code	namestr	magic lvl	auto prefix	alternategfx	OpenBetaGfx	normcode	ubercode	ultracode	spelloffset	component	invwidth	invheight	hasinv	gemsockets	gemapplytype	flippyfile	invfile	uniqueinvfile	setinvfile	rArm	lArm	Torso	Legs	rSPad	lSPad	useable	throwable	stackable	minstack	maxstack	type	type2	dropsound	dropsfxframe	usesound	unique	transparent	transtbl	quivered	lightradius	belt	quest	missiletype	durwarning	qntwarning	mindam	maxdam	StrBonus	DexBonus	gemoffset	bitfield1	CharsiMin	CharsiMax	CharsiMagicMin	CharsiMagicMax	CharsiMagicLvl	GheedMin	GheedMax	GheedMagicMin	GheedMagicMax	GheedMagicLvl	AkaraMin	AkaraMax	AkaraMagicMin	AkaraMagicMax	AkaraMagicLvl	FaraMin	FaraMax	FaraMagicMin	FaraMagicMax	FaraMagicLvl	LysanderMin	LysanderMax	LysanderMagicMin	LysanderMagicMax	LysanderMagicLvl	DrognanMin	DrognanMax	DrognanMagicMin	DrognanMagicMax	DrognanMagicLvl	HraltiMin	HraltiMax	HraltiMagicMin	HraltiMagicMax	HraltiMagicLvl	AlkorMin	AlkorMax	AlkorMagicMin	AlkorMagicMax	AlkorMagicLvl	OrmusMin	OrmusMax	OrmusMagicMin	OrmusMagicMax	OrmusMagicLvl	ElzixMin	ElzixMax	ElzixMagicMin	ElzixMagicMax	ElzixMagicLvl	AshearaMin	AshearaMax	AshearaMagicMin	AshearaMagicMax	AshearaMagicLvl	CainMin	CainMax	CainMagicMin	CainMagicMax	CainMagicLvl	HalbuMin	HalbuMax	HalbuMagicMin	HalbuMagicMax	HalbuMagicLvl	JamellaMin	JamellaMax	JamellaMagicMin	JamellaMagicMax	JamellaMagicLvl	LarzukMin	LarzukMax	LarzukMagicMin	LarzukMagicMax	LarzukMagicLvl	MalahMin	MalahMax	MalahMagicMin	MalahMagicMax	MalahMagicLvl	DrehyaMin	DrehyaMax	DrehyaMagicMin	DrehyaMagicMax	DrehyaMagicLvl	Source Art	Game Art	Transform	InvTrans	SkipName	NightmareUpgrade	HellUpgrade	mindam	maxdam	nameable
	
	if Module in charstats
		headers=class	str	dex	int	vit	tot	stamina	hpadd	PercentStr	PercentDex	PercentInt	PercentVit	ManaRegen	ToHitFactor	WalkVelocity	RunVelocity	RunDrain	Comment	LifePerLevel	StaminaPerLevel	ManaPerLevel	LifePerVitality	StaminaPerVitality	ManaPerMagic	StatPerLevel	#walk	#run	#swing	#spell	#gethit	#bow	BlockFactor	StartSkill	Skill 1	Skill 2	Skill 3	Skill 4	Skill 5	Skill 6	Skill 7	Skill 8	Skill 9	Skill 10	StrAllSkills	StrSkillTab1	StrSkillTab2	StrSkillTab3	StrClassOnly	baseWClass	item1	item1loc	item1count	item2	item2loc	item2count	item3	item3loc	item3count	item4	item4loc	item4count	item5	item5loc	item5count	item6	item6loc	item6count	item7	item7loc	item7count	item8	item8loc	item8count	item9	item9loc	item9count	item10	item10loc	item10count
	
	if module in cubemain
		headers=description	enabled	ladder	min diff	version	op	param	value	class	numinputs	input 1	input 2	input 3	input 4	input 5	input 6	input 7	output	lvl	plvl	ilvl	mod 1	mod 1 chance	mod 1 param	mod 1 min	mod 1 max	mod 2	mod 2 chance	mod 2 param	mod 2 min	mod 2 max	mod 3	mod 3 chance	mod 3 param	mod 3 min	mod 3 max	mod 4	mod 4 chance	mod 4 param	mod 4 min	mod 4 max	mod 5	mod 5 chance	mod 5 param	mod 5 min	mod 5 max	output b	b lvl	b plvl	b ilvl	b mod 1	b mod 1 chance	b mod 1 param	b mod 1 min	b mod 1 max	b mod 2	b mod 2 chance	b mod 2 param	b mod 2 min	b mod 2 max	b mod 3	b mod 3 chance	b mod 3 param	b mod 3 min	b mod 3 max	b mod 4	b mod 4 chance	b mod 4 param	b mod 4 min	b mod 4 max	b mod 5	b mod 5 chance	b mod 5 param	b mod 5 min	b mod 5 max	output c	c lvl	c plvl	c ilvl	c mod 1	c mod 1 chance	c mod 1 param	c mod 1 min	c mod 1 max	c mod 2	c mod 2 chance	c mod 2 param	c mod 2 min	c mod 2 max	c mod 3	c mod 3 chance	c mod 3 param	c mod 3 min	c mod 3 max	c mod 4	c mod 4 chance	c mod 4 param	c mod 4 min	c mod 4 max	c mod 5	c mod 5 chance	c mod 5 param	c mod 5 min	c mod 5 max	*eol
	;~ StringReplace(headers,headers,"`r")
	;~ StringReplace(headers,header,"`n",a_tab)
	return headers
}