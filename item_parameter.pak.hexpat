import std.io;

u32 PointerCount @ 0x0;

u32 Mode @ 0x8;

if (PointerCount != 4) {
    std::error("not category num");
}

u32 PtrOffset;
if (Mode != 0) {
    PtrOffset = 0xC;
} else {
    PtrOffset = 0x10;
}

//From FF4.exe Debug Logs
#define IBP 0x1C
#define NIP 0x2C
#define EP 0x50
#define REP 0x52 // No idea what this is
#define PP 0x54
#define CONSUMPTION_SIZE 0x30
#define WEAPON_SIZE 0x58
#define PROTECTION_SIZE 0x54
#define IMPORTANT_SIZE 0x20

u32 ConsumptionItemsPtr @ PtrOffset;
u32 ConsumptionItemsSize @ PtrOffset + 0x4;
u32 WeaponItemsPtr @ PtrOffset + 0x8;
u32 WeaponItemsSize @ PtrOffset + 0xC;
u32 ProtectionItemsPtr @ PtrOffset + 0x10;
u32 ProtectionItemsSize @ PtrOffset + 0x14;
u32 ImportantItemsPtr @ PtrOffset + 0x18;
u32 ImportantItemsSize @ PtrOffset + 0x1C;

enum ItemType : u8 {
    Consumable = 0,
    None       = 2,
    Knife      = 3,
    Sword      = 4,
    Staff      = 7,
    Rod        = 8,
    Arrow      = 10,
    Claw       = 12,
    Hammer     = 13,
    Throw      = 14,
    Spear      = 15,
    Harp       = 18,
    DarkSword  = 19,
    Shield     = 23,
    Head       = 24,
    Body       = 25,
    Arms       = 26,
    HolySword  = 29,
    NinjaSword = 30,
};

struct ItemBaseParameter {
    ItemType m_Type;
    padding[1];
    s16 m_ID;
    s16 m_HelpID;
    s16 m_HelpMessage;
    s16 m_SortID;
    s16 m_ModelID;
    s16 m_Effect;
    u16 m_SEIndex;
    u16 m_SESeqArcNo;
    u16 m_Metallic;
    s16 m_AbilityID;
    s16 m_EfficacyID;
    s16 m_Flags;
    padding[2]; // 2 for consumable, 4 for phoenix down, 0 for everything else?
} [[fixed_size(IBP)]];

struct NormalItemParameter : ItemBaseParameter {
    s32 m_Cost;
    s32 m_SellPrice;
    u64 m_Condition;
} [[fixed_size(NIP)]];

bitfield EquipPlayer {
    Cecil_Dark : 1;
    Cecil_Paladin : 1;
    Kain : 1;
    Rosa : 1;
    Rydia_Child : 1;
    Rydia_Adult : 1;
    Tellah : 1;
    Porom : 1;
    Palom : 1;
    Edward : 1;
    Yang : 1;
    Cid : 1;
    Edge : 1;
    Fusoya : 1;
    Golbez : 1;
};

struct EquipParameter : NormalItemParameter {
    EquipPlayer m_EquipPlayer;
    s16 m_EquipPosition;
    s16 m_UnknownFlags;
    s16 m_Attack;
    s16 m_Accuracy;
    u16 m_Defense;
    u16 m_Evasion;
    u16 m_MagicDefense;
    u16 m_MagicEvasion;
    u16 m_BonusHealth;
    padding[2];
    u16 m_Strength;
    u16 m_Stamina;
    u16 m_Speed;
    u16 m_Intellect;
    u16 m_Spirit;
    u16 m_EquipFlags;
} [[fixed_size(EP)]];

struct ConsumptionParameter : NormalItemParameter {
    s16 m_ConsumptionFlags;
} [[fixed_size(CONSUMPTION_SIZE)]];

bitfield WeaponParameterFlags {
    WeaponParameterFlags_Throwable : 1;
    WeaponParameterFlags_Unknown : 1;
    padding : 14;
};

struct WeaponParameter : EquipParameter {
    padding[2];
    u16 m_UnknownWeaponFlags;
    WeaponParameterFlags m_WeaponFlags;
    u16 m_ConditionChance;
} [[fixed_size(WEAPON_SIZE)]];

struct ProtectionParameter : EquipParameter {
    padding[2];
    u16 m_ProtectionFlags;
} [[fixed_size(PROTECTION_SIZE)]];

struct ImportantParameter : ItemBaseParameter {
    bool m_IsAugment;
    padding[3];
} [[fixed_size(IMPORTANT_SIZE)]];

ConsumptionParameter ConsumptionItems[ConsumptionItemsSize / CONSUMPTION_SIZE + 1] @ ConsumptionItemsPtr;
WeaponParameter WeaponItems[WeaponItemsSize / WEAPON_SIZE] @ WeaponItemsPtr;
ProtectionParameter ProtectionItems[ProtectionItemsSize / PROTECTION_SIZE] @ ProtectionItemsPtr;
ImportantParameter ImportantItems[ImportantItemsSize / IMPORTANT_SIZE] @ ImportantItemsPtr;