import std.mem;

#define SHOP_SIZE 124

struct Item {
    s32 m_ID;
    
    if (m_ID < 5001)
        break;
};

struct Shop {
    char m_Name[0x20];
    u32 m_NameID;
    padding[24];
    Item m_Items[16];
} [[fixed_size(SHOP_SIZE)]];

Shop Shops[std::mem::size() / SHOP_SIZE] @ 0x0;