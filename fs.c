#include <stddef.h>
#include <string.h>
#include <time.h>

#if defined(__cplusplus)
extern "C" {
#endif
const char *mg_unlist(size_t no);
const char *mg_unpack(const char *, size_t *, time_t *);
#if defined(__cplusplus)
}
#endif

static const unsigned char v1[] = {
  31, 139,   8,   8,  52, 244,  51, 104,   0,   3, 105, 110, // ....4.3h..in
 100, 101, 120,  46, 104, 116, 109, 108,   0, 189,  88, 109, // dex.html..Xm
 111, 219,  54,  16, 254, 222,  95, 193, 234,  67, 157,  96, // o.6..._..C.`
 145,  28, 187, 232, 150, 184, 118, 214,  44, 105, 187,  13, // ......v.,i..
  77, 218,  53, 105, 129, 161,  40,   6,  90, 162, 237, 107, // M.5i..(.Z..k
  41,  82,  35,  41,  55,  73, 209, 255, 178, 255, 178,  63, // )R#)7I.....?
 182,  35, 245,  98,  73, 150, 108, 103,   3, 230,  15, 137, // .#.bI.lg....
  69,  30, 159,  35, 239, 158, 123, 142, 242, 248, 225, 249, // E..#..{.....
 235, 179, 235, 223, 223,  60,  39,  11,  19, 243, 147,   7, // .....<'.....
  99, 251, 143, 112,  42, 230,  19,  15, 140, 103,   7,  24, // c..p*....g..
 141,  78,  30,  16, 252, 140,  99, 102,  40,   9,  23,  84, // .N....cf(..T
 105, 102,  38, 222, 187, 235,  23, 254, 145,  87, 157,  18, // if&......W..
  52, 102,  19, 111,   9, 236,  75,  34, 149, 241,  72,  40, // 4f.o..K"..H(
 133,  97,   2,  77, 191,  64, 100,  22, 147, 136,  45,  33, // .a.M.@d...-!
 100, 190, 123,  56,  32,  32, 192,   0, 229, 190,  14,  41, // d.{8  .....)
 103, 147,  65, 112,  88,  64,  25,  48, 156, 157, 188, 100, // g.ApX@.0...d
 218, 128,  20, 140, 156,  83,   3, 228, 236, 237, 187, 243, // .....S......
 113,  63, 155, 201, 172,  56, 136, 207,  68,  49,  62, 241, // q?...8..D1>.
 180, 185, 229,  76,  47,  24,  67, 143,  11, 197, 102,  19, // ...L/.C...f.
 111,  97,  76,  50, 234, 247,   7, 199, 195,  96, 240, 253, // oaL2.....`..
  81,  48,   8,   6, 131, 209, 209, 225, 209,  97,  63, 134, // Q0.......a?.
  80,  73,  35,  37, 215,  65, 168, 117, 225,  80, 135,  10, // PI#%.A.u.P..
  18,  67,  34,  54,  99, 138, 104,  21, 102,   0,  26,  17, // .C"6c.h.f...
 194,  72,   4, 159, 116, 196,  56,  44,  85,  32, 152, 233, // .H..t.8,U ..
 139,  36, 238,  83, 158, 128,  96, 159, 244, 179, 199, 193, // .$.S..`.....
  77, 112, 211, 143,  64,  27, 103,  24, 131,  53, 246,  78, // Mp..@.g..5.N
 198, 253,  12, 176, 142,  94, 226, 110, 219,  88,  29,  98, // .....^.n.X.b
 220, 207, 226,  63, 158, 202, 232,  54,  71, 140,  96,  73, // ...?...6G.`I
  66,  78, 181, 158, 120, 161,  74,  35, 223, 134, 153, 226, // BN..x.J#....
 150, 148,  71, 110, 252, 136,  26, 154, 141,  95,  80,  65, // ..Gn....._PA
 231,  76, 237, 225, 244,  12, 230, 251, 118, 210, 198,  28, // .L......v...
 243, 138, 127, 247, 246, 243, 211, 183,  34,  90, 159,   8, // ........"Z..
 183, 178, 112,  86, 139,   1,  66,  24, 118, 131,  16,  25, // ..pV..B.v...
 102, 224,  18,  98, 183, 187,  24,  52, 108, 155, 136,  52, // f..b...4l..4
 180, 217, 212,  13,  72, 103,  58,  77, 141, 145, 162, 102, // ....Hg:M...f
  61,  53, 248, 156, 127, 241, 117,  26, 134,  12, 179,  69, // =5....u....E
 158, 133,  28, 194, 207, 152, 240, 133, 252, 114,  26,  69, // .........r.E
  23,  50, 162, 220, 158, 227, 116,  62, 135,  84, 204, 129, // .2....t>.T..
  60, 231,  44,  70, 190, 201, 113,  63, 195, 108, 236,   9, // <.,F..q?.l..
  83, 181, 172,  28,  58, 123, 236,  14,   2,  24,  22, 107, // S...:{.....k
 159,  99, 122, 155, 129, 192, 137, 132,  83, 195,  48,  28, // .cz.....S.0.
  51, 169, 108, 161, 176,  24, 249,  76, 108, 236,   3, 183, // 3.l....Ll...
 204,  35, 163, 207, 236,  54, 155,   9,  32, 106,  59, 118, // .#...6.. j;v
 155, 187,  22, 187,  78, 219, 246,  36, 213,  19, 246, 184, // ....N..$....
  76, 152,  93, 241,  33, 207,  26,  50,  22, 183, 127, 251, // L.].!..2....
   2,  24, 143,  62, 186, 236,  61, 222,   0, 178, 123,  38, // ...>..=...{&
 107, 203, 218, 179, 186,  74,  34, 139, 192, 252, 130, 155, // k....J".....
 218, 179,  59, 195,  36,  98,  54,  97,   6,  33, 109, 207, // ..;.$b6a.!m.
 221, 142, 240,  43, 210,  68, 168,  96, 182,  32,  10, 119, // ...+.D.`. .w
  88, 195, 204, 176, 210,  33, 230,   4, 125,  62, 231, 128, // X....!..}>..
  69, 187, 131, 203,   6, 117, 118, 157,  90,  43, 212,   5, // E....uv.Z+..
 240,  72,  49, 209,  70, 170, 218, 194,  38, 193, 246, 150, // .H1.F...&...
 148, 167, 236, 128,  32, 167, 246,  45, 209,  28,  87, 114, // .... ..-..Wr
 138, 225, 159, 109, 185, 104, 221,  71,  70,  56, 244,  96, // ...m.h.GF8.`
 203, 201, 193, 144, 135, 147,   9, 105, 225,   8, 121, 244, // .......i..y.
 136,  20, 211,  61, 136, 122,  91, 220,  57, 151,  58, 161, // ...=.z[.9.:.
 226, 100, 172, 141, 146,  98,  94, 146, 208, 109,  21, 181, // .d...b^..m..
 205, 141, 158, 140,  50, 171, 114, 214, 157, 209, 205, 187, // ....2.r.....
 181, 217, 191, 205,   7, 235, 142, 125,  54,  93, 196, 241, // .......}6]..
  94, 169, 107,  25, 110,  67, 218, 170,  31, 237, 133, 242, // ^.k.nC......
  47, 228, 142,  46, 217,  41, 119,  74, 119,  69, 249, 146, // /....)wJwE..
 146, 107,  68,   0,   2, 174,  51, 174, 115, 119, 235, 190, // .kD...3.sw..
  62, 105,  41, 252,  88,  98,  19, 144, 235,  18,  63,  44, // >i).Xb....?,
  10, 113, 193,  44, 209, 236, 177,  37, 182,  89, 108, 209, // .q.,...%.Yl.
 100, 239, 215, 171, 215, 151, 251, 168,  22, 195,  45,  90, // d.........-Z
 239,  28, 228,   4, 178,   4, 179,  87, 138, 137, 135,  68, // .......W...D
 142, 169, 177,  24, 123,  86,  39, 247, 109, 166, 239,  39, // ....{V'.m..'
 200, 177,  21, 124, 164, 125,  62, 246, 181, 231,  70,  45, // ...|.}>...F-
 125, 123,  35,  98, 255, 185, 142, 240, 205, 186,  52, 138, // }{#b......4.
  10,  13,  54, 254,  91, 246, 234,  48, 253, 252, 162, 178, // ..6.[..0....
 139,  76, 111,  84,  93, 140, 223, 170,  69, 166,  10,  75, // .LoT]...E..K
 221, 105,  28, 170,  13, 249, 145, 244,  10, 137,  43, 251, // .i........+.
  84, 143, 140,  72, 111, 173, 123, 245, 156,  36,  15,  59, // T..Ho.{..$.;
  60, 220,  87, 248,  66,  46,  53,  43,  91, 229,  35,   3, // <.W.B.5+[.#.
  49, 211,  79, 187,  21, 175, 163,  38, 214, 237, 154,  18, // 1.O....&....
  53, 115,  74, 129, 148, 201,   5, 196,  61, 151, 125, 208, // 5sJ.....=.}.
  61,   5, 246, 126, 184, 107, 139, 179, 116, 241, 231,  74, // =..~.k..t..J
 166, 201,  38, 161, 228, 116, 202, 120,  25, 242, 204,  75, // ..&..t.x...K
  54, 246,  29, 233, 141, 122, 232, 126, 181, 185, 220, 253, // 6....z.~....
 184, 239,  12,  54, 128, 130,  72,  82,  67,  70, 230,  54, // ...6..HRCF.6
  97, 197,  82, 251,  29, 193,  32, 170,  97, 161,  99, 228, // a.R... .a.c.
 143, 189, 131,  86, 146, 253,  97, 101, 240, 177, 235, 176, // ...V..ae....
  93, 194, 211, 173,  87, 219, 137, 185, 185,  47, 239,  46, // ]...W..../..
  59,  27,  21, 183, 170,  73, 174, 153, 238, 111,  89, 208, // ;....I...oY.
  93,  13, 153, 150, 149, 106, 179, 161,  22,  54, 117, 231, // ]....j...6u.
 173, 247, 140,  58, 255,  79, 133,  72,  57, 223, 208, 241, // ...:.O.H9...
  91, 197, 255, 126,  50,  37, 164, 113, 101, 110, 211, 209, // [..~2%.qen..
 165,  86, 160,  47,  43,  86, 239,  65, 195, 148, 179,  76, // .V./+V.A...L
 185,  92, 184, 170,  24,  23, 152,  22, 188, 200, 215, 244, // ............
 178, 186, 137, 113, 245, 117, 195, 126, 250, 125, 114, 230, // ...q.u.~.}r.
 138,  48,  85, 244,  14,   1, 192,  94,  76, 129, 248,  68, // .0U....^L..D
  65, 140, 234,  32, 133,  36,   2,  43, 100,   6,  40, 234, // A.. .$.+d.(.
  63,  95,  95, 188,  42,  23,  98, 233, 106,  67,  18,  37, // ?__.*.b.jC.%
 163,  52,  52, 154,  76, 200, 215,  90,  32, 152, 136,  18, // .44.L..Z ...
   9, 194, 140, 136,  23, 187, 119, 139,  63,  10,  83, 239, // ......w.?.S.
 160, 102, 232,  94,  11, 208, 170, 124, 135, 123, 131, 118, // .f.^...|.{.v
  18, 155,  86, 195, 174, 122, 201,  64, 115,  33, 177, 166, // ..V..z.@s!..
 234,  22, 153, 138, 140, 200, 135, 181,  68, 125, 117, 111, // ........D}uo
 155, 229,  42, 226, 138,  26,  31,  47, 241, 177, 240,  39, // ..*..../...'
 113, 220,  86,  46,  14, 219, 176, 122, 228, 219,  65,  55, // q.V....z..A7
  78, 162, 216, 221, 157, 172,  32, 189,  41,   6, 114,   8, // N..... .).r.
 145, 198,  83, 171, 172, 155,  64, 254,  76, 169, 192, 211, // ..S...@.L...
 211,  10, 204, 111, 217, 208, 223, 127, 181,  32, 213, 128, // ...o..... ..
  62, 214, 113, 243, 247,  99, 108, 242, 180, 253, 252,  96, // >.q..cl....`
  99,  54,  64,  84,  27,   1, 252, 250, 138,  38,  70,  38, // c6@T.....&F&
 248, 156, 157, 100,  68, 142, 143, 143, 131, 227, 227,   3, // ...dD.......
  82, 108, 106,  68,   6, 135, 237, 187, 119,  80, 195,  21, // RljD....wP..
 212,  85,  76, 149,  73,  22, 152, 186,  10, 220, 147,  53, // .UL.I......5
 184, 225, 147, 230,  17, 202, 167, 111,  79,  31,  52, 104, // .......oO.4h
  21, 201,  16,  47,  28, 187, 176,  42, 183, 220,  70, 170, // .../...*..F.
  11, 124, 133,   8, 255,  47,  74, 221, 135,  73,  58,  97, // .|.../J..I:a
  33, 102,  14, 238, 238,  92, 249,  85, 161, 174, 214, 167, // !f.....U....
 118, 134, 149, 138,  42, 168,  18, 244, 117,  49,  80, 135, // v...*...u1P.
 248,  47, 164, 106, 213, 216, 130, 104, 173, 147,  57,  99, // ./.j...h..9c
 206,  85,  64,  46, 236, 118, 200,  91, 169, 117,  51,  43, // .U@..v.[.u3+
 197, 167,  25,  25,  92, 120,  70,  85,   4, 146, 203,  57, // .....xFU...9
 208, 142,  69, 217, 185,  45, 193,  83, 225, 191, 103,   2, // ..E..-.S..g.
 137, 237,  15, 126, 240, 214, 108, 219,  98, 215, 125, 158, // ...~..l.b.}.
 225, 214, 243, 160, 234,  18, 236,  23, 148, 252,   4,  84, // ...........T
 224,  43, 211, 238, 103, 186, 100, 169, 218, 237,  72,  24, // .+..g.d...H.
  50, 255, 165, 253,  54,  56, 244,   7,  71,  45, 103, 218, // 2...68..G-g.
 161, 188, 154, 114, 207,   8,  69, 169, 197, 222, 234, 147, // ...r..E.....
 144, 198,  83, 160,  88, 177,  88,  51, 148,  44, 209,  41, // ..S.X.X3.,.)
 157,  90, 213,  79, 152,  34, 169,   1, 183, 105, 197, 220, // .Z.O."...i..
 239,  22, 154,  97, 137, 194, 146,  41,  13, 141, 194, 205, // ...a...)....
  46, 116,  88, 183, 133, 218,  63, 205,  91, 208, 234,  55, // .tX...?.[..7
 170, 236, 199,  41, 188, 181, 218, 223,  16, 255,   1,  61, // ...).......=
 109,  61, 251,  83,  20,   0,   0, 0 // m=.S...
};
static const unsigned char v2[] = {
  31, 139,   8,   8, 156, 178,  48, 104,   0,   3, 109, 105, // ......0h..mi
  99, 114, 111, 116, 111, 111, 108, 115,  46,  99, 115, 115, // crotools.css
   0, 181,  87,  75, 111, 219,  56,  16, 190, 231,  87,  16, // ..WKo.8...W.
  40, 138,  54,  64,  20, 208, 146,  45, 219, 234, 177, 135, // (.6@...-....
  98,  47, 123, 217,   7, 246,  74, 145,  35, 139, 141,  76, // b/{...J.#..L
  26, 164,  84,  59,  89, 236, 127,  95, 234,  69,  83,  20, // ..T;Y.._.ES.
 101, 167,  11, 108, 224, 216,  50,  61,  67, 206, 124, 243, // e..l..2=C.|.
 205, 131, 207,  84,  53,  44, 162,  82, 212, 132,  11,  80, // ...T5,.R...P
 232, 239,   7, 100, 254,  10, 243,  61,  42, 200, 145,  87, // ...d...=*..W
 175,  25, 250, 244,  27,  28,  36, 160,  63, 126, 249, 244, // ......$.?~..
 132, 126,  39, 165,  60, 146,  39, 244,  13,   4, 252,  48, // .~'.<.'....0
 159, 127, 130,  98,  68, 152,   7,  77, 132, 142,  52,  40, // ...bD..M..4(
  94, 124, 233, 118, 168, 204, 110,  81,   9, 252,  80, 214, // ^|.v..nQ..P.
  25,  90,  61, 167, 253,  42, 149, 149,  84,  25, 250, 144, // .Z=..*..T...
  36,  73, 191, 112,  36, 234, 192,  69, 134, 112, 255, 245, // $I.p$..E.p..
  68,  24, 227, 226, 144, 161,  24, 159,  46, 253,  82,  78, // D.........RN
 232, 203,  65, 201,  70, 180,  86, 246, 218,  69,  49,  28, // ..A.F.V..E1.
 146,  75, 197,  64,  69, 138,  48, 222, 232,  12, 237, 172, // .K.@E.0.....
 142, 188,  68, 186,  36,  76, 158, 205, 206,  40,  62,  93, // ..D.$L...(>]
 208, 218, 252, 171,  67,  78,  62, 227,  39,  52, 188, 158, // ....CN>.'4..
  87, 143, 163,  13, 151, 232, 204,  89,  93,  26,  67,  99, // W......Y].Cc
 108,  15, 182, 166,  33, 210, 212, 242, 203, 195,  63,  15, // l...!.....?.
  15, 207,  29,  88,  37,  16, 102, 145,  98,  92, 159,  42, // ...X%.f.b..*
  98,  80,  42,  42,  24,  20, 191,  55, 186, 230, 197, 107, // bP**...7...k
   7,  42,   8, 227, 190,  62,  17,  10,  81,  14, 245,  25, // .*...>..Q...
  64, 244,  50, 164, 226,   7,  17, 241,  26, 142, 198, 110, // @.2........n
 106, 164,  64, 185, 167,  70, 185, 172, 107, 121, 116, 113, // j.@..F..kytq
  24, 160, 177, 191, 172, 174,   8, 245,  40, 216,  31, 140, // ........(...
 171,  90,  86, 156, 161,  15,   0,  48, 183, 187,  92,  13, // .ZV....0....
 166, 143, 112, 198,  52, 129,  13, 158, 197, 195, 234, 229, // ..p.4.......
 181,  24,  52,   2, 177,  72, 214, 251,  29, 203,  39, 209, // ..4..H....'.
  61, 151, 198,  47, 215, 180,  12,   9,  41, 192, 139, 176, // =../....)...
   9,  22,  90, 165, 158,  15,  99,  36, 215, 227,  58, 109, // ..Z...c$..:m
 148, 110, 247,  60,  73, 126, 197, 168,  99, 167, 230, 111, // .n.<I~..c..o
  96, 156, 181, 146, 181,  50,  12, 228,  53, 151, 198, 122, // `....2..5..z
 223,  78,  19, 236,  68,  79,  61, 202,  74, 249, 195,   6, // .N..DO=.J...
  49, 224,  87, 188, 223, 225, 124,  63, 213, 137,  12, 213, // 1.W...|?....
  15, 183, 148,  96, 187, 166,   9,  13,  42, 221,  59, 143, // ...`....*.;.
 226, 100,  31, 231, 158, 170, 110,  40,   5, 173, 111,  88, // .d....n(..oX
   9, 148, 110,  87,  97, 173, 187,  30, 110,   9, 164, 110, // ..nWa...n..n
 156,   9, 109, 209, 211, 203, 196,  62, 144, 211, 200,  59, // ..m....>...;
 171, 212,  81,  56, 170, 184, 174,   7,  61, 143, 192, 137, // ..Q8....=...
 165, 105,  96, 195, 246,  41,  98,  92,   1, 237, 227, 102, // .i`..)b....f
  76, 107, 142,  67, 134, 140,  25, 137, 241,  71, 239, 184, // Lk.C.....G..
  27, 248, 211,   2,  23, 171,  96,  34, 237, 188,  60, 234, // ......`"..<.
  29,  65, 171, 205,  61,   6,  14, 235,  21,  20, 117, 183, // .A..=.....u.
  58, 230, 150,  75, 252, 137, 173, 182,   0, 241, 183, 238, // :..K........
  28, 155, 158, 239,  35, 106, 172,  17,  16,  13, 158, 207, // ....#j......
 247, 130,   9,  24,  82, 216, 121,  74, 255, 111, 165, 154, // ....R.yJ.o..
  57, 237,  33, 142,  23, 172,  41, 147,   9,  83, 108, 237, // 9.!...)..Sl.
  15, 149,  35,  55, 211, 109, 173, 232,  22, 207,  67, 107, // ..#7.m....Ck
 217,  96, 247,  28,  90, 242, 138,  41,  16,  46,  33, 151, // .`..Z..)..!.
 120, 119,  86,  45, 157, 219, 247,  25, 187,  29, 111, 106, // xwV-......oj
  57,  89,  29, 171, 176, 183,  60, 196, 184,  95,  53,  28, // 9Y....<.._5.
  97,  68, 151,  96,  72,  66,  41, 245, 173, 187,  67,  97, // aD.`HB)...Ca
 219, 219, 166, 133,  50, 126,  31,  77,  39, 213, 159,  49, // ....2~.M'..1
 182, 152, 121, 139,  81, 125,  15,  37, 222,  77, 119, 235, // ..y.Q}.%.Mw.
 249,  81,  50,  82, 249, 241, 112, 154, 130,  28,  19, 162, // .Q2R..p.....
 224,  23,  24, 172, 238, 192,  28, 120, 208, 103,  31,  94, // .......x.g.^
  56, 222, 142,  25,  87, 131, 102, 192, 250, 205, 127,  51, // 8...W.f....3
  52, 255, 183, 136,  11,   6, 151,  78, 121,   1,   1,  23, // 4......Ny...
 158,  32, 110,  83,  55, 251,  71,  93, 202, 115, 152, 128, // . nS7.G].s..
  83, 233, 241, 152, 159,  97,  68, 236, 243, 110,  54,   0, // S....aD..n6.
   5, 114, 211, 206,  56,  27, 140, 195, 115,  82,  91, 220, // .r..8...sR[.
 118, 129,  57,  41, 126, 116, 140,  46, 164,  58,  70, 173, // v.9)~t...:F.
 133, 167, 112, 189, 239,  11, 106,  72, 188,  34,  57,  84, // ..p...jH."9T
 238, 124,  57, 166, 112, 138,  39, 195, 135, 221, 106,  51, // .|9.p.'...j3
 235,  28,  92, 116,  99, 101,  94,  73, 250,  18,  62, 132, // ...tce^I..>.
 139,  83,  51,  98,  57,   3, 225, 102,  74, 133,  83, 103, // .S3b9..fJ.Sg
  41, 221, 130,  35, 200, 221,  52,  16, 210,  48, 139,  83, // )..#..4..0.S
 210, 114, 125,  48, 114, 153, 250, 215,  40, 171,  30, 167, // .r}0r...(...
 217,  44, 216, 163, 189,  76, 135, 245, 141,  25, 122, 156, // .,...L....z.
  28, 156, 202,  59, 153, 219, 222,  67, 140,  85,  32, 135, // ...;...C.U .
 176, 211, 228, 218, 184, 100, 253,  99,  69, 106, 248, 235, // .....d.cEj..
 179,  25, 175,  63,  62, 206, 187, 160,  21, 238, 230, 180, // ...?>.......
 174, 253, 153,  29,  35, 217, 212,  11, 216, 205,  82,  44, // ....#.....R,
 124,  28, 118, 137, 251,  93,  75,  97,  82,  78, 240,  90, // |.v..]KaRN.Z
 170,  41, 117,  59, 180, 215, 115, 112, 111, 223,  65, 118, // .)u;..spo.Av
 197, 190,  32, 247, 174,  33,  97,  98, 133, 109,  42, 227, // .. ..!ab.m*.
 187, 115, 121, 228, 214, 196,  96, 226, 185,  61, 234, 191, // .sy...`..=..
 223,  20,  58, 187, 134, 172, 187,  49,  64, 238, 140, 133, // ..:....1@...
 235, 105, 243,  38, 121,  30, 231, 126, 189, 186,  63, 100, // .i.&y..~..?d
 181, 195,  77,  81, 201, 115, 100,  72, 212, 223, 182, 108, // ..MQ.sdH...l
 146, 217,  91, 232,  87, 217,  40, 110, 230, 135,  95, 225, // ..[.W.(n.._.
 108,  46, 162,   6,  53, 217, 181, 166,  27, 249, 232, 221, // l...5.......
  65,  55, 215,  82,  56,  46,  38, 215,  90, 104,  77, 120, // A7.R8.&.ZhMx
 205, 156,  11,  95, 135, 196,  11, 188, 122, 161,   1, 156, // ..._....z...
 210, 237, 198,  17, 209, 181,  50, 174, 122,  82, 251,  29, // ......2.zR..
  77, 182, 123,  71,  74,  52, 199, 220, 206,  99, 163,  20, // M.{GJ4...c..
  91, 237,  73, 154,  58,  82, 185, 148,  21,  16, 225, 137, // [.I.:R......
 109, 210,  60, 165, 177,  17, 251,  23, 224, 220, 130, 121, // m.<........y
 178,  15,   0,   0, 0 // ....
};
static const unsigned char v3[] = {
  31, 139,   8,   8,   1, 179,  48, 104,   0,   3, 109, 105, // ......0h..mi
  99, 114, 111, 116, 111, 111, 108, 115,  46, 106, 115,   0, // crotools.js.
 165,  86,  93,  79, 219,  48,  20, 125, 223, 175,  48,  17, // .V]O.0.}..0.
  82,  28,  81,   2, 108, 111, 129, 118,  66, 218,  30,  58, // R.Q.lo.vB..:
   9, 246, 192, 180,  23,  96, 146, 155, 184, 237, 221,  28, // .....`......
 187, 179,  29,   6, 219, 250, 223, 119, 237, 132,  54, 105, // .......w..6i
 156, 130, 180, 188, 164,  77, 174, 207, 185, 247, 220, 175, // .....M......
 204,  43, 153,  91,  80, 146, 228, 186,  42, 174, 152, 100, // .+.[P...*..d
  11, 174, 105, 174, 228,  28,  22,   9, 249, 243, 134, 224, // ..i.........
 165, 185, 173, 180, 108, 254, 184, 171, 126, 157,  53, 247, // ....l...~.5.
 209, 230, 121, 193,  44, 203,  90, 118, 238, 226, 178,  88, // ..y.,.Zv...X
  41, 144, 246, 217,  58, 125, 126,  48, 234, 152, 129, 229, // )...:}~0....
 165, 201, 200, 109, 154, 166, 141,  29,  72, 176, 192, 196, // ...m....H...
   7, 196, 188, 223, 152, 174, 183, 167, 204,  82, 253, 186, // .........R..
  82,   5,  19,  25, 153,  51,  97, 248, 246,  13, 152, 107, // R....3a....k
 101,  97,  14,  57, 115, 129, 125,   5,   3,  51, 193, 123, // ea.9s.}..3.{
  86, 178, 101, 115, 197, 141, 193, 192,  51,  18, 199,  91, // V.es....3..[
 131, 188, 210, 154,  75,  59,  69, 207,  48, 168,  22, 243, // ....K;E.0...
 150,   8,  93, 164, 201,  78, 192, 232, 190,  81, 130, 167, // ..]..N...Q..
  66,  45, 104, 132, 222, 131,  51, 251, 141, 145,   0, 201, // B-h...3.....
 153, 246, 132,  89,  52,  34, 118,   9,  38, 117, 130,  37, // ...Y4"v.&u.%
 231, 161, 232,  58,  97,  94,  22, 133, 143, 180, 199, 229, // ...:a^......
  65,  90, 126, 146,  49,  58, 122, 222,  55, 217, 104, 133, // AZ~.1:z.7.h.
   6,  86,  87, 124,  63,  37,  47, 192, 163,  81, 151, 148, // .VW|?%/..Q..
 215,  80,  98, 210, 156, 233, 255,  51, 231,  66,  25, 190, // .Pb....3.B..
  39, 212,  54, 154,  79, 103, 128, 113,  88, 142, 160, 188, // '.6.Og.qX...
 236, 129, 251,  88, 119, 249,  96,  78, 232,  46,  94,  10, // ...Xw.`N..^.
 197, 174, 153, 247,  26,  51, 110,  49, 203,   5, 127, 116, // .....3n1...t
  81,  62,  39, 214, 107,  98, 210,  57, 190, 152, 186, 119, // Q>'.kb.9...w
  20, 200, 120,  66,   0,  65, 200, 120,  60, 238,  57, 235, // ..xB.A.x<.9.
 192, 207, 123, 216, 206, 141,  26, 249,   0, 207,  28, 159, // ..{.........
 133, 248,  55, 161, 111,  89, 111, 253, 153, 251,  38,  57, // ..7.oYo...&9
 187,  84, 235,  62,  79,  71, 226, 118, 251, 208, 248, 163, // .T.>OG.v....
 224,  37,  30,  84, 164,  84,  69, 253,  88, 185, 144, 137, // .%.T.TE.X...
 169, 242,  28, 251,  70, 197,   1, 183, 215, 157,  39, 107, // ....F.....'k
 194,  49,  87, 131, 202,  73, 254, 107, 138, 154, 144,  43, // .1W..I.k...+
 102, 151, 105, 201,  30, 233, 179, 203,  45,  21,  75, 182, // f.i.....-.K.
 170, 245,  91,  49, 109, 248,  84,  90, 234, 132,  76, 146, // ..[1m.TZ..L.
 132,  28, 145, 179,  62, 127,  64,  92,  36, 240,  68, 169, // ....>.@.$.D.
  85,  55,  86, 131,  92, 208, 128, 223, 187, 180, 171, 202, // U7V.........
  44, 105,  80, 194, 161, 195, 123, 244,  99, 139,   5,  84, // ,iP...{.c..T
 242,   5, 245, 214, 129, 138, 110, 117, 197, 254, 106,  46, // ......nu..j.
 184, 224, 182, 174, 231, 126, 169, 186,  82,  58, 240, 195, // .....~..R:..
  85, 151,  52, 190, 225,  64,  12,  96,  68, 138,  20,  64, // U.4..@.`D..@
  30, 112,  98, 105, 204,  18, 148,  32, 153, 230, 228, 103, // .pbi... ...g
 197,  13,  58, 202,  27, 215, 223, 199,  40, 116, 189,   6, // ..:.....(t..
   2,  29, 183, 213,  43,  88, 254, 194, 226,  70,   1, 223, // ....+X...F..
 142,  19,  63, 231,  93,  50,  92,  53, 247,  10, 254,  37, // ..?.]2.5...%
   1,  27, 255, 246,  40,  56,  52,  65,  59, 128, 101,  61, // ....(84A;.e=
 237, 131,  19,  38, 176,  21,  48, 168, 230,  68, 192, 219, // ...&..0..D..
 224, 174, 233, 205,  58, 239,   6, 183,  95, 160, 228, 170, // ....:..._...
 178,  20, 135,  13,  74, 209, 111, 135, 189, 136, 129, 121, // ....J.o....y
 183,  30, 145, 119, 167, 167, 167,  47, 196, 207, 204, 147, // ...w.../....
 204, 253, 160, 187,  20, 253, 185, 218, 173, 138, 169, 124, // ...........|
   0, 151, 127,  91,  89, 183, 184, 220,  70, 135, 109, 223, // ...[Y...F.m.
   3, 193, 201,  59,  99, 249,  15, 220, 225, 195,  37, 161, // ...;c.....%.
 159,   6,  58, 189, 187,  21,  11, 134,  35, 211, 179,  13, // ..:.....#...
 173, 195, 142,  44, 253, 178, 240,  40, 134, 137,   7, 119, // ...,...(...w
 111,  23,   4, 254, 216, 184, 121,  64, 168, 129, 178,  18, // o.....y@....
  88,  52,  73, 175, 213, 112,  33, 219, 124,  73,  40, 215, // X4I..p!.|I(.
  90, 233, 161, 201, 238, 188, 246,   6,  88, 136, 238, 198, // Z.......X...
 113, 140, 136, 134, 215, 117, 180, 202, 226,  17, 169,  17, // q....u......
  94,  63,  18, 130,  64, 195, 163,  32, 148, 214, 185, 210, // ^?..@.. ....
  37, 179, 159, 110,  62,  95,  83, 175,  91, 224,  51, 196, // %..n>_S.[.3.
 146, 239,  70, 201, 122, 218,  97,   5,  57, 219, 212, 248, // ..F.z.a.9...
 127,  48, 127, 242, 167,  70,  68,  86,  66, 140, 200, 219, // .0...FDVB...
  29, 234, 230, 147, 111, 123, 188,  23,  89, 170, 249,  74, // ....o{..Y..J
 176, 156, 211, 147, 136, 222, 126, 139, 238, 143, 146,  40, // ......~....(
  59,  89, 140,  72, 124,  97,  86,  12, 191,  38,   5,  51, // ;Y.H|aV..&.3
 102,  28,  57, 128, 227,  31, 252,  41, 154,  68, 135, 103, // f.9....).D.g
 209, 197, 137, 123,  55, 201, 226, 228,  53, 112,   3, 104, // ...{7...5p.h
 117,   0,  29, 192, 189, 120, 119,  51, 234, 154, 241, 175, // u....xw3....
 239, 159, 228, 110,  54,   0,  59,  83, 152, 104,  38, 163, // ...n6.;S.h&.
 201, 225, 217,  43,  81, 239, 138, 163,  97,  56,  89, 149, // ...+Q...a8Y.
  51, 174,  59, 104, 173,  46, 245, 191, 112,  11, 175, 255, // 3.;h....p...
   1,  64,  54,   7, 255, 126,  11,   0,   0, 0 // .@6..~...
};

static const struct packed_file {
  const char *name;
  const unsigned char *data;
  size_t size;
  time_t mtime;
} packed_files[] = {
  {"/fs/index.html.gz", v1, sizeof(v1), 1748545341},
  {"/fs/microtools.css.gz", v2, sizeof(v2), 1748545341},
  {"/fs/microtools.js.gz", v3, sizeof(v3), 1748545341},
  {NULL, NULL, 0, 0}
};

static int scmp(const char *a, const char *b) {
  while (*a && (*a == *b)) a++, b++;
  return *(const unsigned char *) a - *(const unsigned char *) b;
}
const char *mg_unlist(size_t no) {
  return packed_files[no].name;
}
const char *mg_unpack(const char *name, size_t *size, time_t *mtime) {
  const struct packed_file *p;
  for (p = packed_files; p->name != NULL; p++) {
    if (scmp(p->name, name) != 0) continue;
    if (size != NULL) *size = p->size - 1;
    if (mtime != NULL) *mtime = p->mtime;
    return (const char *) p->data;
  }
  return NULL;
}
