// Based on https://github.com/Enfyve/MSD-Editor/blob/master/MSDEditor/MSDParser.cs

import std.io;
import std.string;

#define MSD_HEADER_SIZE 0x10

struct MSDHeader {
    char m_Magic[4];
    padding[2];
    u16 m_Version;
    u32 m_NumEntries;
} [[fixed_size(MSD_HEADER_SIZE)]];

MSDHeader Header @ 0x0;

if (Header.m_Magic != "MSDA") {
    std::error("Invalid Header");
}

enum Game : u32 {
    FF3 = 0xCCCC0101,
    FF4 = 0xCCCC0001
};

struct MSDEntry {
    u32 m_ID;
    Game m_Game;
    u32 m_Offset;
    std::string::NullString16 m_Text @ m_Offset;
};

MSDEntry Entries[Header.m_NumEntries] @ MSD_HEADER_SIZE;