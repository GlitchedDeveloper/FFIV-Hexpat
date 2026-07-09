import std.io;
import std.mem;

#define EMPTY_EFFECT_DATA_SIZE 4
#define CONSUMABLE_EFFECT_DATA_SIZE 12
#define AUGMENT_EFFECT_DATA_SIZE 20

struct BELDHeader {
    char m_Magic[4];

    if (m_Magic != "BELD") {
        std::error("Miss! File Code is not Differnt.");
    }
    
    s32 m_EffectDataTypeNum;

    if (m_EffectDataTypeNum == 0) {
        std::error("Miss! EffectDataTypeNum == 0.!!");
    }

    if (m_EffectDataTypeNum != 3) {
        std::error("Unhandled File Format");
    }
    
    s32 m_EmptyEffectDataNum;
    s32 m_ConsumableEffectDataNum;
    s32 m_AugmentEffectDataNum;
    s32 m_EmptyEffectDataOffset;
    s32 m_ConsumableEffectDataOffset;
    s32 m_AugmentEffectDataOffset;
};

struct BELDEmptyEffectData {
    s8 m_ID;
    padding[3];
} [[fixed_size(EMPTY_EFFECT_DATA_SIZE)]];

struct BELDConsumableEffectData {
    s8 m_ID;
    padding[3];
    s32 m_UsedPower;
    s32 m_RecoverMpValue;
} [[fixed_size(CONSUMABLE_EFFECT_DATA_SIZE)]];

struct BELDAugmentEffectData {
    s8 m_ID;
    padding[3];
    s32 m_UsedPower;
    s32 m_RecoverMpValue;
    s32 m_LearnAbilityId;
    u32 m_ObjectTextureId;
} [[fixed_size(AUGMENT_EFFECT_DATA_SIZE)]];

BELDHeader Header @ 0x0;

BELDEmptyEffectData EmptyEffectData[Header.m_EmptyEffectDataNum] @ Header.m_EmptyEffectDataOffset;
BELDConsumableEffectData ConsumableEffectData[Header.m_ConsumableEffectDataNum] @ Header.m_ConsumableEffectDataOffset;
BELDAugmentEffectData AugmentEffectData[Header.m_AugmentEffectDataNum] @ Header.m_AugmentEffectDataOffset;