import std.mem;
import std.io;
import type.Base64;

fn BIT(u8 n) {
    return 1 << n;
};

enum enAchievementCheckTimings : u32 {
    All            = 0,
    EventStart     = BIT(0),
    EventFinish    = BIT(1),
    PlayNewGame    = BIT(2),
    FreeMove       = BIT(3),
    FreeVehicle    = BIT(4),
    BattleEnd      = BIT(5),
    Reported       = BIT(6),
    UseAbilityItem = BIT(7),
    ShopSell       = BIT(8),
};

enum enAchievementCheckTypes : u32 {
    Flag              = 0,
    FlagRange         = 1,
    HardModeBeat      = 2,
    BeatCount         = 3,
    GetItem           = 4,
    GetDecant         = 5,
    GetDecantCnt      = 6,
    LearnSummon       = 7,
    LearnSummonCnt    = 8,
    CompletedMap      = 9,
    OverPlayerLevel   = 10,
    Gill              = 11,
    MonsterKillCount  = 12,
    MonsterDictionary = 13,
    MonsterPartyKill  = 14,
    NoCheck           = 15,
    Field             = 16,
    AchievementComp   = 17
};

enum PLAYER_TYPES : s32 {
    InvalidPlayer = 0xFFFFFFFF,
    Cecil_Dark    = 0,
    Cecil_Paladin = 1,
    Kain          = 2,
    Rosa          = 3,
    Rydia_Child   = 4,
    Rydia_Adult   = 5,
    Tellah        = 6,
    Porom         = 7,
    Palom         = 8,
    Edward        = 9,
    Yang          = 10,
    Cid           = 11,
    Edge          = 12,
    Fusoya        = 13,
    Golbez        = 14,
};

enum ABILITY_ID : s8 {
};

fn formatIdentifier(str id) {
    str decoded = type::impl::decode_base64(id);
    u8 idx = std::string::at(decoded, 12);
    return std::format("{} | id: {}", id, idx);
};

struct FlagParam {
    s32 m_Bank;
    s32 m_Offset;
    bool m_Value;
    padding[3];

    if (m_Bank == -1)
        break;
};

struct FlagRangeParam {
    s32 m_Bank;
    s32 m_Start;
    s32 m_End;
    bool m_Value;
    padding[3];

    if (m_Bank == -1)
        break;
};

struct HardModeBeatParam {
    s32 m_MonsterPartyId;
};

struct BeatCountParam {
    s32 m_MonsterPartyId;
    s32 m_Count;
};

struct GetItemParam {
    s32 m_ItemId;

    if (m_ItemId == -1)
        break;
};

struct GetDecantParam {
    s32 m_DecantId;

    if (m_DecantId == -1)
        break;
};

struct GetDecantCntParam {
    s32 m_Count;
};

struct LearnSummonParam {
    PLAYER_TYPES m_Player;
    ABILITY_ID m_AbilityId;
    padding[3];

    if (m_Player == PLAYER_TYPES::InvalidPlayer)
        break;
};

struct LearnSummonCntParam {
    FlagParam m_Flags[2];
    padding[0xc];
    PLAYER_TYPES m_Player;
    s32 m_Count;
};

struct OverPlayerLevelParam {
    PLAYER_TYPES m_Player;
    u32 m_Level;

    if (m_Player == PLAYER_TYPES::InvalidPlayer)
        break;
};

struct GillParam {
    u32 m_Amount;
};

struct MonsterKillCountParam {
    u32 m_Count;
};

struct MonsterDictionaryParam {
    u32 m_Amount;
};

struct MonsterPartyKillParam {
    s32 m_MonsterPartyId;

    if (m_MonsterPartyId == -1)
        break;
};

struct FieldParam {
    FlagParam m_Flags[2];
    padding[0xc];
    s32 m_FieldType;
    s32 m_FieldMatch1;
    s32 m_FieldMatch2;
};

#define ACHIEVEMENT_PARAM_SIZE 320

struct AchievementParam {
    char m_Identifier[0x40] [[format("formatIdentifier")]];
    enAchievementCheckTimings m_Timing;
    enAchievementCheckTypes m_Type;
    match (m_Type) {
        (enAchievementCheckTypes::Flag): FlagParam m_FlagParam[20];
        (enAchievementCheckTypes::FlagRange): FlagRangeParam m_FlagRangeParam[14];
        (enAchievementCheckTypes::HardModeBeat): HardModeBeatParam m_HardModeBeatParam;
        (enAchievementCheckTypes::BeatCount): BeatCountParam m_BeatCountParam;
        (enAchievementCheckTypes::GetItem): GetItemParam m_GetItemParam[60];
        (enAchievementCheckTypes::GetDecant): GetDecantParam m_GetDecantParam[60];
        (enAchievementCheckTypes::GetDecantCnt): GetDecantCntParam m_GetDecantCntParam;
        (enAchievementCheckTypes::LearnSummon): LearnSummonParam m_LearnSummonParam[30];
        (enAchievementCheckTypes::LearnSummonCnt): LearnSummonCntParam m_LearnSummonCntParam;
        (enAchievementCheckTypes::CompletedMap): {}
        (enAchievementCheckTypes::OverPlayerLevel): OverPlayerLevelParam m_OverPlayerLevelParam[30];
        (enAchievementCheckTypes::Gill): GillParam m_GillParam;
        (enAchievementCheckTypes::MonsterKillCount): MonsterKillCountParam m_MonsterKillCountParam;
        (enAchievementCheckTypes::MonsterDictionary): MonsterDictionaryParam m_MonsterDictionaryParam;
        (enAchievementCheckTypes::MonsterPartyKill): MonsterPartyKillParam m_MonsterPartyKillParam[60];
        (enAchievementCheckTypes::NoCheck): {}
        (enAchievementCheckTypes::Field): FieldParam m_FieldParam;
        (enAchievementCheckTypes::AchievementComp): {}
    }
} [[fixed_size(ACHIEVEMENT_PARAM_SIZE)]];

AchievementParam achievements[std::mem::size() / ACHIEVEMENT_PARAM_SIZE] @ 0x0;