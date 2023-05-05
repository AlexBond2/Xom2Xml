# Extended information on XEnum Types for WUM

### /xomSCHM/XContainer/XAnimClipLibrary/AnimClips/AnimChannel/ PostInfinity, PreInfinity
```
kInfinityConstant = 0
kInfinityLinear = 1
kInfinityCycle = 2
kInfinityCycleRelative = 3
kInfinityOscillate = 4
kInfinityInvalid = 5
```
### /xomSCHM/XContainer/XGeometry, XNode/ BoundMode
```
kUpdateModeStatic = 0
kUpdateModeDynamic = 1
kUpdateModeIgnore = 2
```
### /xomSCHM/XContainer/XExportAttribute/ AttributeType
```
kExportAttributeNone = 0
kExportAttributeString = 1
kExportAttributeInt = 2
kExportAttributeFloat = 3
kExportAttribureBool = 4
```
### /xomSCHM/XContainer/XCore/XMatrix/XTransform/ RotateOrder
```
kRotateOrderXYZ = 0
kRotateOrderYZX = 1
kRotateOrderZXY = 2
kRotateOrderXZY = 3
kRotateOrderYXZ = 4
kRotateOrderZYX = 5
```
### /xomSCHM/XContainer/XAttribute/XMaterial/ DiffuseSource, AmbientSource, SpecularSource, EmissiveSource
```
kMaterialColorSourceMaterial = 0
kMaterialColorSourceColor1 = 1
kMaterialColorSourceColor2 = 2
```
### /xomSCHM/XContainer/XAttribute/XAlphaTest, XDepthTest/ CompareFunction
```
kCompareFunctionNever = 0
kCompareFunctionLess = 1
kCompareFunctionEqual = 2
kCompareFunctionLessEqual = 3
kCompareFunctionGreater = 4
kCompareFunctionNotEqual = 5
kCompareFunctionGreaterEqual = 6
kCompareFunctionAlways = 7
```
### /xomSCHM/XContainer/XAttribute/XCullFace/ CullMode
```
kCullModeOff = 0
kCullModeFront = 1
kCullModeBack = 2
kCullModeForceFront = 3
kCullModeForceBack = 4
```
### /xomSCHM/XContainer/XAttribute/XLightingEnable/ Normalize
```
kNormalizeNever = 0
kNormalizeAlways = 1
kNormalizeIfRequired = 2
```
### /xomSCHM/XContainer/XAttribute/XBlendModeGL/ SourceFactor, DestFactor
```
kBlendFactorZero = 0
kBlendFactorOne = 1
kBlendFactorDestColor = 2
kBlendFactorOneMinusDestColor = 3
kBlendFactorSrcColor = 4
kBlendFactorOneMinusSrcColor = 5
kBlendFactorSrcAlpha = 6
kBlendFactorOneMinusSrcAlpha = 7
kBlendFactorDestAlpha = 8
kBlendFactorOneMinusDestAlpha = 9
kBlendFactorSrcAlphaSaturate = 10
kBlendFactorMinusOne = 11
```
### /xomSCHM/XContainer/XImage/ Format
```
kImageFormat_R8G8B8 = 0
kImageFormat_A8R8G8B8 = 1
kImageFormat_X8R8G8B8 = 2
kImageFormat_X1R5G5B5 = 3
kImageFormat_A1R5G5B5 = 4
kImageFormat_R5G6B5 = 5
kImageFormat_A8 = 6
kImageFormat_P8 = 7
kImageFormat_P4 = 8
kImageFormat_DXT1 = 9
kImageFormat_DXT3 = 10
kImageFormat_NgcRGBA8 = 11
kImageFormat_NgcRGB5A3 = 12
kImageFormat_NgcR5G6B5 = 13
kImageFormat_NgcIA8 = 14
kImageFormat_NgcIA4 = 15
kImageFormat_NgcI8 = 16
kImageFormat_NgcI4 = 17
kImageFormat_NgcCI12A4 = 18
kImageFormat_NgcCI8 = 19
kImageFormat_NgcCI4 = 20
kImageFormat_NgcCMPR = 21
kImageFormat_NgcIndirect = 22
kImageFormat_P2P8 = 23
kImageFormat_P2P4 = 24
kImageFormat_Linear = 25
kImageFormat_Count = 26
```
### /xomSCHM/XContainer/XPalette/ Format
```
kPaletteFormat_R8G8B8X8 = 0
kPaletteFormat_R8G8B8A8 = 1
kPaletteFormat_R5G5B5 = 2
kPaletteFormat_R5G6B5 = 3
kPaletteFormat_NgcRGB5A3 = 4
kPaletteFormat_Count = 5
```
### /xomSCHM/XContainer/XTextureStage/XTextureMap/XOglTextureMap/ Blend
### /xomSCHM/XContainer/XShader/XEnvironmentMapShader/ BlendType
```
kOglBlendReplace = 0
kOglBlendModulate = 1
kOglBlendDecal = 2
kOglBlendBlend = 3
kOglBlendAdd = 4
```
### /xomSCHM/XContainer/XTextureStage/ AddressModeS, AddressModeT
```
kAddressModeInvalid = 0
kAddressModeRepeat = 1
kAddressModeMirror = 2
kAddressModeClamp = 3
kAddressModeBorder = 4
```
### /xomSCHM/XContainer/XTextureStage/ MagFilter, MinFilter, MipFilter
```
kFilterModeNone = 0
kFilterModeNearest = 1
kFilterModeLinear = 2
kFilterModeAnisotropic = 3
kFilterMode_Count = 4
```
### /xomSCHM/XContainer/WormDataContainer/ PhysicsState
```
kWPS_Ambulatory = 0
kWPS_DetectJump = 1
kWPS_Ballistic = 2
kWPS_Sliding = 3
kWPS_Vaulting = 4
kWPS_Override = 5
kWPS_Passive = 6
kWPS_DeathThroes = 7
kWPS_DrownFloat = 8
kWPS_Undefined = 9
```
### /xomSCHM/XContainer/WormDataContainer/ WeaponIndex
### /xomSCHM/XContainer/TeamDataContainer/ WormpotSuperWeapon
```
kWeaponOneBeforeFirst = 0
kWeaponBazooka = 1
kWeaponGrenade = 2
kWeaponClusterGrenade = 3
kWeaponAirstrike = 4
kWeaponDynamite = 5
kWeaponHolyHandGrenade = 6
kWeaponBananaBomb = 7
kWeaponLandmine = 8
kWeaponShotgun = 9
kWeaponBaseballBat = 10
kWeaponProd = 11
kWeaponFirePunch = 12
kWeaponHomingMissile = 13
kWeaponFlood = 14
kWeaponSheep = 15
kWeaponGasCanister = 16
kWeaponOldWoman = 17
kWeaponConcreteDonkey = 18
kWeaponSuperSheep = 19
kWeaponStarburst = 20
kWeaponFactoryWeapon = 21
kWeaponAlienAbduction = 22
kWeaponFatkins = 23
kWeaponScouser = 24
kWeaponNoMoreNails = 25
kWeaponPoisonArrow = 26
kWeaponSentryGun = 27
kWeaponSniperRifle = 28
kWeaponSuperAirstrike = 29
kWeaponClusterBomb = 30
kWeaponBananette = 31
kWeaponOneAfterLast = 32
kUtilityOneBeforeFirst = 33
kUtilityGirder = 34
kUtilityNinjaRope = 35
kUtilityParachute = 36
kUtilityJetpack = 37
kUtilitySkipGo = 38
kUtilitySurrender = 39
kUtilityChangeWorm = 40
kUtilityRedbull = 41
kUtilityBubbleTrouble = 42
kUtilityBinoculars = 43
kUtilityDoubleDamage = 44
kUtilityCrateShower = 45
kUtilityCrateSpy = 46
kUtilityArmour = 47
kUtilityOneAfterLast = 48
kMysteryOneBeforeFirst = 49
kMysteryMineLayer = 50
kMysteryMineTriplet = 51
kMysteryBarrelTriplet = 52
kMysteryFlood = 53
kMysteryDisarm = 54
kMysteryTeleport = 55
kMysteryQuickWalk = 56
kMysteryLowGravity = 57
kMysteryDoubleTurnTime = 58
kMysteryHealth = 59
kMysteryDamage = 60
kMysterySuperHealth = 61
kMysterySpecialWeapon = 62
kMysteryBadPoison = 63
kMysteryGoodPoison = 64
kMysteryOneAfterLast = 65
kInventorySize = 66
kWeaponUndefined = 67
kWeaponTerminal = 68
```
### /xomSCHM/XContainer/TeamDataContainer/ DefaultCameraDistance
```
kCloseup = 0
kLongshot = 1
```
### /xomSCHM/XContainer/ParticleEmitterContainer/ EmitterType
```
kNormal = 0
kSnow = 1
kRain = 2
kTrail = 3
```
### /xomSCHM/XContainer/ParticleEmitterContainer/ ParticleCollisionWormType
```
kWC_Standard = 0
kWC_Expire = 1
kWC_Lightside = 2
kWC_Darkside = 3
```
### /xomSCHM/XContainer/ParticleEmitterContainer/ ParticleLandCollideType
```
kLC_None = 0
kLC_Bounce = 1
kLC_Expire = 2
kLC_StopMoving = 3
kLC_StopMovingAndAttach = 4
```
### /xomSCHM/XContainer/ParticleEmitterContainer/ ParticleRenderScene
```
kPS_Default = 0
kPS_Scene1 = 1
kPS_Scene2 = 2
kPS_Scene3 = 3
kPS_Scene4 = 4
kPS_Scene5 = 5
```
### /xomSCHM/XContainer/LensFlareElementContainer/ Type
```
kLens_SunGlow = 0
kLens_Circle = 1
kLens_FadedRing = 2
kLens_Ring = 3
kLens_FadedHex = 4
kLens_Hex = 5
kLens_RainbowRing = 6
kLens_NumElementTypes = 7
```
### /xomSCHM/XContainer/InputDetailsContainer/ Type
```
kIM_Keyboard = 0
kIM_MouseButton = 1
kIM_JoystickButton = 2
kIM_JoystickAxis = 3
kIM_MouseSensitivity = 4
kIM_InvertX = 5
kIM_InvertY = 6
kIM_BackFlip = 7
kIM_Vibration = 8
kIM_Other = 9
kIM_Undefined = 10
kIM_InvertYFP = 11
kIM_JoystickPov = 12
kIM_PreSetJoypadConfig = 13
kIM_UndefinedButAllowed = 14
kIM_LAST = 15
```
### /xomSCHM/XContainer/FMVSubTiles/ FMV
```
kFMVSTF_None = 0
kFMVSTF_MeetTheProfessor = 1
kFMVSTF_Camelot = 2
kFMVSTF_WildWest = 3
kFMVSTF_Arabian = 4
kFMVSTF_Jurassic = 5
```
### /xomSCHM/XContainer/BaseWeaponContainer/PayloadWeaponPropertiesContainer/ DetonateMultiEffect
```
kDT_Random = 0
kDT_Normal = 1
kDT_Fire = 2
kDT_Clusters = 3
kDT_BigPush = 4
```
### /xomSCHM/XContainer/BaseWeaponContainer/PayloadWeaponPropertiesContainer/ WormCollideResponse
```
kWC_Default = 0
kWC_StealInventory = 1
kWC_FloatAway = 2
```
### /xomSCHM/XContainer/BaseWeaponContainer/MeleeWeaponPropertiesContainer/ MeleeType
```
kNoMeleeType = 0
kMeleeBaseballBat = 1
kMeleeFirepunch = 2
kMeleeProd = 3
kMeleeTailNail = 4
```
### /xomSCHM/XContainer/BaseWeaponContainer/ WeaponType
```
kNoType = 0
kUtility = 1
kProjectile = 2
kTargetted = 3
kThrown = 4
kMelee = 5
kEnvironment = 6
kHitscan = 7
kAnimal = 8
kControlled = 9
kStrike = 10
kMovement = 11
```
### /xomSCHM/XContainer/WeaponFactoryContainer/ Type
```
kWT_Projectile = 0
kWT_Cluster = 1
```
### /xomSCHM/XContainer/WeaponFactoryContainer/ Detonate
```
kWD_Impact = 0
kWD_Fused = 1
kWD_FirePress = 2
kWD_AtRest = 3
```
### /xomSCHM/XContainer/WeaponFactoryContainer/ PayloadResourceId
```
kWP_8ball = 0
kWP_Banana = 1
kWP_Baseball = 2
kWP_Bazookashell = 3
kWP_Beans = 4
kWP_Beechball = 5
kWP_Bomb2 = 6
kWP_Book = 7
kWP_Boot = 8
kWP_BowlingBall = 9
kWP_Brick = 10
kWP_Burger = 11
kWP_C4 = 12
kWP_Canary = 13
kWP_Cheese = 14
kWP_Chicken = 15
kWP_Classic = 16
kWP_Cluster = 17
kWP_Dice = 18
kWP_Doll = 19
kWP_Donut = 20
kWP_Dumbell = 21
kWP_Easterhead = 22
kWP_Eyeball = 23
kWP_Fish = 24
kWP_Foot = 25
kWP_Globe = 26
kWP_Grenade = 27
kWP_Hamster = 28
kWP_Hotdog = 29
kWP_Kitten = 30
kWP_Looroll = 31
kWP_MagicBullet = 32
kWP_Meat = 33
kWP_Mingvase = 34
kWP_Monkey = 35
kWP_MorningStar = 36
kWP_Nut = 37
kWP_Parcel = 38
kWP_Penguin = 39
kWP_Pineapple = 40
kWP_Poo = 41
kWP_Present = 42
kWP_Rabbit = 43
kWP_RazorBall = 44
kWP_Rubikcube = 45
kWP_ShrunkenHead = 46
kWP_Sickbucket = 47
kWP_Skull = 48
kWP_Snowglobe = 49
kWP_Teeth = 50
kWP_Tonweight = 51
kWP_USfootball = 52
kWP_DLC1Payload1 = 53
kWP_DLC1Payload2 = 54
kWP_DLC1Payload3 = 55
kWP_DLC1Payload4 = 56
kWP_DLC1Payload5 = 57
kWP_Bullet = 58
kWP_Bomb = 59
kWP_Rocket = 60
kWP_Lazer = 61
kWP_LAST = 62
```
### /xomSCHM/XContainer/WeaponFactoryContainer/ ProjectileLaunchType
```
kWL_Bomber = 0
kWL_Launched = 1
kWL_Thrown = 2
kWL_Dropped = 3
kWL_LauchLAST = 4
```
### /xomSCHM/XContainer/LevelDetails/ LevelType
```
kCampagne = 0
kRandom = 1
kCustom = 2
kTutorial = 3
kChallenge = 4
kMultiplayer = 5
kAttract = 6
kLast = 7
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_MenuDescription/ BorderType
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_BriefingDesc/ Border_Type
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_TextBoxDesc, WXFE_HowToPlayTextBoxDesc/ Border_Normal, Border_Disabled, Border_Highlight, Border_Active
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_MenuButtonDesc, WXFE_FlagObjectDesc, WXFE_ListControlDesc, WXFE_LandscapeBoxDesc, WXFE_GalleryThumbDesc/ Border_Normal, Border_Disabled, Border_Highlight
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_ImageViewDesc, WXFE_GalleryImageDesc, WXFE_ScrollingTextDesc/ Border
### /xomSCHM/XContainer/WXFE_ListBoxRows/ Border_Normal, Border_Highlight, Border_Disabled
```
kMT_NoBorder = 0
kMT_FrameBorder = 1
kMT_BasicBorder = 2
kMT_ArmouryBorder = 3
kMT_BlueListBorder = 4
kMT_OrangeListBorder = 5
kMT_TextNormalBorder = 6
kMT_TextDisabledBorder = 7
kMT_TextEditBorder = 8
kMT_TextHighlightBorder = 9
kMT_TextActiveBorder = 10
kMT_TextCharcoalBorder = 11
kMT_ButtonSmallNormal = 12
kMT_ButtonSmallDisabled = 13
kMT_ButtonSmallHighlight = 14
kMT_ButtonBigNormal = 15
kMT_ButtonBigDisabled = 16
kMT_ButtonBigHighlight = 17
kMT_NavStartNormal = 18
kMT_NavStartDisabled = 19
kMT_NavStartHighlight = 20
kMT_NavTickNormal = 21
kMT_NavTickDisabled = 22
kMT_NavTickHighlight = 23
kMT_NavBackNormal = 24
kMT_NavBackDisabled = 25
kMT_NavBackHighlight = 26
kMT_NavCrossNormal = 27
kMT_NavCrossDisabled = 28
kMT_NavCrossHighlight = 29
kMT_NavArrowLeftNorm = 30
kMT_NavArrowLeftHighlight = 31
kMT_NavArrowLeftDisabled = 32
kMT_NavArrowRightNorm = 33
kMT_NavArrowRightHighlight = 34
kMT_NavArrowRightDisabled = 35
kMT_BubbleBorder = 36
kMT_BubbleBorderNoPointer = 37
kMT_PaperBorder = 38
kMT_BorderNamePlate = 39
kMT_ComPanelBorder = 40
kMT_PaperNormalBorder = 41
kMT_PaperShadowBorder = 42
kMT_MemoryNormalBorder = 43
kMT_MemoryHighlightBorder = 44
kMT_MemoryHighlightDisabled = 45
kMT_ComPanelBorderTrans = 46
kMT_LAST = 47
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_BriefingDesc/ Briefing_Colour_Front, Continue_Colour_Front
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_TextBoxDesc/ Colour_Front, Colour_Front_Edit, Colour_Front_Highlight, Colour_Front_Disabled
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_HowToPlayTextBoxDesc/ Colour_Front
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_ScrollingTextDesc/ Colour_Front
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_MenuButtonDesc/ ColourFRONT_Normal, ColourFRONT_Highlight, ColourFRONT_Disabled
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_TitleControlDesc/ FrontColour
### /xomSCHM/XContainer/WXFE_Columns/WXFE_StringColumns/ ColourFRONT_Normal, ColourFRONT_Highlight, ColourFRONT_Disabled
```
kGC_Invalid = 0
kGC_Blank = 1
kGC_Solid_White = 2
kGC_Solid_Black = 3
kGC_Solid_Team_Blue = 4
kGC_Solid_Team_Red = 5
kGC_Solid_Team_Green = 6
kGC_Solid_Team_Yellow = 7
kGC_Header_Orange = 8
kGC_SubHeader_Blue = 9
kGC_TextBox_Yellow = 10
kGC_List_Lable_Blue = 11
kGC_List_Data_Orange = 12
kGC_Button_Yellow = 13
kGC_Wormpot_Orange = 14
kGC_Team_Red = 15
kGC_Team_Blue = 16
kGC_Team_Green = 17
kGC_Team_Yellow = 18
kGC_Disabled_Grey = 19
kGC_Disabled_Grey_Light = 20
kGC_PressFire_Turquoise = 21
kGC_TextEdit_Turquoise = 22
kGC_Book_Brown = 23
kGC_PopUp_Red = 24
kGC_PopUp_Blue = 25
kGC_PopUp_Brown = 26
kGC_PopUp_LightBrown = 27
kGC_PopUp_Green = 28
kGC_ScrollText = 29
kGC_TextBox_Green = 30
kGC_ERROR_RED = 31
kGC_List_Lable_Cluster = 32
kGC_ControllerUndefined = 33
kGC_LAST_Dont_Use = 34
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_BriefingDesc/ Briefing_Colour_Back, Continue_Colour_Back
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_TextBoxDesc/ Colour_Back_Highlight, Colour_Back_Disabled, Colour_Back_Edit, Colour_Back
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_HowToPlayTextBoxDesc/ Colour_Back
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_ScrollingTextDesc/ Colour_Back
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_MenuButtonDesc/ ColourBACK_Normal, ColourBACK_Highlight, ColourBACK_Disabled
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_TitleControlDesc/ BackColour
### /xomSCHM/XContainer/WXFE_Columns/WXFE_StringColumns/ ColourBACK_Normal, ColourBACK_Highlight, ColourBACK_Disabled
```
kBC_Invalid = 0
kBC_Blank = 1
kBC_Black = 2
kBC_White = 3
kBC_Dark = 4
kBC_ScrollText = 5
kBC_ControllerUndefined = 6
kBC_LAST_Dont_Use = 7
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_BriefingDesc/ Briefing_TextAnim, Continue_TextAnim
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_TextBoxDesc/ TextAnim
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_TitleControlDesc/ TextAnim
### /xomSCHM/XContainer/WXFE_Columns/WXFE_StringColumns/ TextAnim
```
kTA_None = 0
kTA_LargeWobble = 1
kTA_SmallWobble = 2
kTA_TitleRandom = 3
kTA_MediumWobble = 4
kTA_LAST_DontUse = 5
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_BriefingDesc/ ControlPositionAdjustment
```
kPO_Top = 0
kPO_Middle = 1
kPO_Bottom = 2
kPO_LAST_DontUse = 3
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/WXFE_TextBoxDesc, WXFE_HowToPlayTextBoxDesc/ Justification
### /xomSCHM/XContainer/WXFE_Columns/WXFE_StringColumns/ Justification
```
kEdgeJustifyTopLeft = 0
kEdgeJustifyTopCentre = 1
kEdgeJustifyTopRight = 2
kEdgeJustifyCentreLeft = 3
kEdgeJustifyCentreCentre = 4
kEdgeJustifyCentreRight = 5
kEdgeJustifyBottomLeft = 6
kEdgeJustifyBottomCentre = 7
kEdgeJustifyBottomRight = 8
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/ Anim_Activated, Anim_Highlighted
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/ Anim_Incoming, Anim_Outgoing
### /xomSCHM/XContainer/WXFE_ListBoxRows/ Anim_Highlight, Anim_Clicked
```
kANIM_None = 0
kANIM_Click = 1
kANIM_Click_Error = 2
kANIM_Highlight = 3
kANIM_In_BigBounce = 4
kANIM_In_Flipy = 5
kANIM_In_Next = 6
kANIM_In_Prev = 7
kANIM_In_ScaleHitXY = 8
kANIM_In_ScaleY = 9
kANIM_In_SlideX = 10
kANIM_In_Speech = 11
kANIM_In_SpringX = 12
kANIM_In_SpringXY = 13
kANIM_In_TitleUnderline = 14
kANIM_In_ToolTip = 15
kANIM_Out_Next = 16
kANIM_Out_Prev = 17
kANIM_Out_ScaleX = 18
kANIM_Out_ScaleXY = 19
kANIM_Out_ScaleY = 20
kANIM_Out_Speech = 21
kANIM_Out_TitleUnderline = 22
kANIM_Out_ToolTip = 23
kANIM_Reset = 24
kANIM_Title_Scroll = 25
kANIM_Wide_Highlight = 26
kANIM_In_Chat = 27
kANIM_Out_Chat = 28
kANIM_LAST = 29
```
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/WXFE_BaseInputItemDesc/ Audio_Activated, Audio_Highlighted
### /xomSCHM/XContainer/WXFE_BaseItemDesc/WXFE_BaseGfxItemDesc/ Audio_Incoming, Audio_Outgoing
```
kAUDIO_None = 0
kAUDIO_Cancel = 1
kAUDIO_Click = 2
kAUDIO_Click2 = 3
kAUDIO_Click3 = 4
kAUDIO_Error = 5
kAUDIO_Grenade = 6
kAUDIO_Highlight = 7
kAUDIO_In_BigBounce = 8
kAUDIO_In_Book = 9
kAUDIO_In_Controller = 10
kAUDIO_In_CrateDice = 11
kAUDIO_In_Custom = 12
kAUDIO_In_Net = 13
kAUDIO_In_Next = 14
kAUDIO_In_Prev = 15
kAUDIO_In_ScaleHitXY = 16
kAUDIO_In_ScaleY = 17
kAUDIO_In_SlideX = 18
kAUDIO_In_SoundVid = 19
kAUDIO_In_Speech = 20
kAUDIO_In_SpringX = 21
kAUDIO_In_WeaponFactory = 22
kAUDIO_In_WormPot = 23
kAUDIO_Out_Book = 24
kAUDIO_Out_Next = 25
kAUDIO_Out_Prev = 26
kAUDIO_Out_Scale = 27
kAUDIO_Out_ScaleXY = 28
kAUDIO_Out_ScaleY = 29
kAUDIO_Typewriter = 30
kAUDIO_WormPot_Button = 31
kAUDIO_WormPot_HandlePull = 32
kAUDIO_WormPot_Intro = 33
kAUDIO_WormPot_Nudge = 34
kAUDIO_WormPot_Outro = 35
kAUDIO_WormPot_Spin_Loop = 36
kAUDIO_WormPot_Spin_Start = 37
kAUDIO_WormPot_Spin_Stop = 38
kAUDIO_Page_Turn = 39
kAUDIO_Typewriter_Delete = 40
kAUDIO_LAST = 41
```
### /xomSCHM/XContainer/WXFE_Columns/WXFE_PowerColumns/ Style
```
kPCS_Normal = 0
kPCS_Grow = 1
kPCS_NormalZeroDisable = 2
kPCS_GrowZeroDisable = 3
kPCS_LAST = 4
```
### /xomSCHM/XContainer/WXFE_Columns/WXFE_GapColumns/ GapType
```
kGAP_Normal = 0
kGAP_Dots = 1
kGAP_Line = 2
kGAP_LAST = 3
```
### /xomSCHM/XContainer/WXFE_WormAttachments/ Type
```
kAttachmentHat = 0
kAttachmentGloves = 1
kAttachmentGlasses = 2
kAttachmentMustache = 3
kAttachmentPartialHat = 4
```
### /xomSCHM/XContainer/WXFE_LevelDetails/ Level_Type
```
kLT_Multiplayer = 0
kLT_MultiplayerDestruction = 1
kLT_MultiplayerDefend = 2
kLT_MultiplayerSurvivor = 3
kLT_Story = 4
kLT_Random = 5
kLT_Tutorial = 6
kLT_Challenge_Endurance = 7
kLT_Challenge_Quickest = 8
kLT_Deathmatch = 9
kLT_ChallengeRESERVED = 10
kLT_MultiplayerFort = 11
kLT_Network = 12
kLT_NetworkDemo = 13
kLT_ChallengeW3D = 14
kLT_StoryW3D = 15
kLT_Outtake = 16
kLT_ERROR = 17
kLT_Last = 18
```
### /xomSCHM/XContainer/WXFE_LevelDetails/ Theme_Type
```
kTT_Ababian = 0
kTT_Wildwest = 1
kTT_Camelot = 2
kTT_Prehistoric = 3
kTT_Building = 4
kTT_PreSelectedTheme = 5
kTT_Arctic = 6
kTT_England = 7
kTT_Horror = 8
kTT_Lunar = 9
kTT_Pirate = 10
kTT_War = 11
kTT_Last_Do_Not_Select = 12
```
### /xomSCHM/XContainer/WXFE_LevelDetails/ Preview_Type
```
kPT_ImagePreview = 0
kPT_GeneratePreview = 1
kPT_Last_Do_Not_Select = 2
```
### /xomSCHM/XContainer/WXFE_LevelDetails/ LevelSection
```
kLS_Undefined = 0
kLS_RandomTheme = 1
kLS_MayhemPreBuilt = 2
kLS_Worms3DPreBuilt = 3
kLS_Saved = 4
```
### /xomSCHM/XContainer/WXFE_UnlockableItem/ Type
```
kURT_Unknown = 0
kURT_SoundBank = 1
kURT_Map = 2
kURT_Hat = 3
kURT_Spectacles = 4
kURT_Hands = 5
kURT_FacialHair = 6
kURT_Weapon = 7
kURT_WeaponScheme = 8
kURT_CharacterSet = 9
kURT_CharacterSetItem = 10
kURT_Loyalty = 11
kURT_NumTypes = 12
```
### /xomSCHM/XContainer/WXFE_UnlockableItem/ State
```
kUS_Hidden = 0
kUS_Purchasable = 1
kUS_Unlocked = 2
```
### /xomSCHM/XContainer/WXTemplate/LandCost
```
kLT_SmallFlatLand = 0
kLT_SmallMedLand = 1
kLT_SmallTallLand = 2
kLT_MedFlatLand = 3
kLT_MedMedLand = 4
kLT_MedTallLand = 5
kLT_BigFlatLand = 6
kLT_BigMedLand = 7
kLT_BigTallLand = 8
kLT_SmallBeach = 9
kLT_MedBeach = 10
kLT_BigBeach = 11
kLT_SmallGap = 12
kLT_MedGap = 13
kLT_LongGap = 14
kLT_SmallPillarGap = 15
kLT_MedPillarGap = 16
kLT_TallPillarGap = 17
kLT_SmallBridge = 18
kLT_MedBridge = 19
kLT_LongBridge = 20
kLT_SmallObject = 21
kLT_LargeObject = 22
kLT_NumTypes = 23
```
