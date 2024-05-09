1 pragma solidity ^0.4.0;
2 
3 contract LiterallyMinecraft {
4 
5   // total number of chunks
6   uint constant global_width = 32;
7   uint constant global_height = 32;
8   uint constant global_length = global_width*global_height;
9 
10   // size of chunk in bytes32
11   uint constant chunk_size = 32;
12 
13   // represents a 32x32 8-bit image with owner and stake meta data
14   struct Chunk {
15     bytes32[chunk_size] colors;
16 
17     address owner;
18     uint value;
19   }
20 
21   // chunk array in row major order
22   Chunk[global_length] public screen;
23   
24   // block number of last update
25   uint public lastUpdateOverall;
26 
27   // block number of last update for each individual block
28   uint[global_length] public lastUpdateByChunk;
29 
30   // this forces abi to give us the whole array
31   function getUpdateTimes() external view
32     returns(uint[global_length])
33   {
34     return lastUpdateByChunk;
35   }  
36 
37   // helper index conversion function
38   function getIndex(uint8 x, uint8 y) public pure returns(uint) {
39     return y*global_width+x;
40   }
41 
42   // access chunk data by x y coordinates
43   function getChunk(uint8 x, uint8 y) external view
44     withinBounds(x,y)
45     returns(bytes32[chunk_size], address, uint, uint)
46   {
47     uint index = getIndex(x,y);
48     
49     if (lastUpdateByChunk[index] == 0)     // initial default image is gaint cat
50       return (getCatImage(x,y), 0x0, 0, 0);
51     
52     Chunk storage p = screen[index];
53     return (p.colors, p.owner, p.value, lastUpdateByChunk[index]);
54   }
55 
56   // modifier to check if point is in bounds
57   modifier withinBounds(uint8 x, uint8 y) {
58     require(x >= 0 && x < global_width, "x out of range");
59     require(y >= 0 && y < global_height, "y out of range");
60     _;
61   }
62 
63   // modifier to check if msg value is sufficient to take control of a chunk
64   modifier hasTheMoneys(uint8 x, uint8 y) {
65     Chunk storage p = screen[getIndex(x,y)];
66     require(msg.value > p.value, "insufficient funds");
67     _;
68   }
69 
70   // indicate the chunk has been updated
71   function touch(uint8 x, uint8 y) internal {
72     lastUpdateByChunk[getIndex(x,y)] = block.number;
73     lastUpdateOverall = block.number;
74   }
75 
76   // This function claims a chunk in the screen grid.
77   // In order to claim it, the amount paid needs to
78   // exceed the amount that was last paid on the chunk
79   // (starting at 0). Previous updater is refunded the
80   // ether they staked.
81   function setColors(uint8 x, uint8 y, bytes32[chunk_size] clr) external payable
82     withinBounds(x,y)
83     hasTheMoneys(x,y)
84   {
85     Chunk storage p = screen[getIndex(x,y)];
86     
87     uint refund = p.value;
88     address oldOwner = p.owner;
89     
90     p.value = msg.value;
91     p.owner = msg.sender;
92     p.colors = clr;
93     
94     touch(x,y);
95 
96     oldOwner.send(refund); // ignore if the send fails
97   }
98 
99   // Generate a giant cat image
100   function getCatImage(uint8 x, uint8 y) internal pure
101     returns(bytes32[chunk_size])
102   {
103     bytes32[chunk_size] memory cat;
104     cat[0] =  hex"0000000000000000000000000000000000000000000000000000000000000000";
105     cat[1] =  hex"0000000000000000000000000000000000000000000000000000000000000000";
106     cat[2] =  hex"0000e3e300e0e0e0001c1c1c0000000000000000000000000000000000000000";
107     cat[3] =  hex"0000e30000e000e000001c000000000000fc000000fc0000000000f0f0f00000";
108     cat[4] =  hex"0000e30000e0e0e000001c000000000000fcfc00fcfc0000000000f000000000";
109     cat[5] =  hex"0000e3e300e000e000001c000000000000fcfcfcfcfc0000000000f000f00000";
110     cat[6] =  hex"00000000000000000000000000000000fcfcfcfcfcfcfc00000000f0f0f00000";
111     cat[7] =  hex"000000000000000000000000000000fcfcfcfcfcfcfcfcfc0000000000000000";
112     cat[8] =  hex"00000000000000000000000000001ffcfc0000fcfc0000fc000000fcfcfc0000";
113     cat[9] =  hex"00000000000000000000000000001ffcfcfcfcfcfcfcfcfc000000fc00fc0000";
114     cat[10] = hex"00000000000000ff000000001f1f1ffcfcfcfc0000fcfcfc000000fcfcfc0000";
115     cat[11] = hex"0000000000ffff00000000001f1f1f1ffcfc00fcfc00fc00000000fc00fc0000";
116     cat[12] = hex"00000000ff0000000000001f1ffcfc1f1ffcfcfcfcfc1f1f0000000000000000";
117     cat[13] = hex"000000ff00000000ff00000000fcfc1f1f1f1f1f1f1f1f1f00001f0000001f00";
118     cat[14] = hex"0000ff000000ffff00000000fcfc1f1f1f1f1f1f1f1f1f1f00001f1f001f1f00";
119     cat[15] = hex"0000ffff00ff00000000fcfcfc001f1f1ffc1f1f1f1f1f0000001f001f001f00";
120     cat[16] = hex"000000ffff000000ffff00000000001ffcfc1f1f1f1f1f0000001f0000001f00";
121     cat[17] = hex"00000000ffff00ff00000000ff000000fc1f1f1f1f1f1f0000001f0000001f00";
122     cat[18] = hex"0000000000ffff000000ffff0000fcfc001f1f1f1f1f00000000000000000000";
123     cat[19] = hex"000000000000ffff00ff00000000ff0000001f1f1f000000000000ffffff0000";
124     cat[20] = hex"00000000000000ffff000000ffff00000000001f1f000000000000ff00000000";
125     cat[21] = hex"0000000000000000ffff00ff00000000ff00000000000000000000ffff000000";
126     cat[22] = hex"000000000000000000ffff000000ffff0000000000000000000000ff00000000";
127     cat[23] = hex"00000000000000000000ffff00ff00000000ff0000000000000000ffffff0000";
128     cat[24] = hex"0000000000000000000000ffff000000ffff00000000ff000000000000000000";
129     cat[25] = hex"000000000000000000000000ffff00ff00000000ff0000ff0000000000000000";
130     cat[26] = hex"00000000000000000000000000ffff000000ffff0000ff000000000000000000";
131     cat[27] = hex"0000000000000000000000000000ffff00ff000000ff00000000000000000000";
132     cat[28] = hex"000000000000000000000000000000ffff0000ffff0000000000000000000000";
133     cat[29] = hex"00000000000000000000000000000000ffffff00000000000000000000000000";
134     cat[30] = hex"0000000000000000000000000000000000000000000000000000000000000000";
135     cat[31] = hex"0000000000000000000000000000000000000000000000000000000000000000";
136 
137     bytes32 pixel_row = cat[y][x];
138       
139     pixel_row |= (pixel_row >> 1*8);
140     pixel_row |= (pixel_row >> 2*8);
141     pixel_row |= (pixel_row >> 4*8);
142     pixel_row |= (pixel_row >> 8*8);
143     pixel_row |= (pixel_row >> 16*8);
144 
145     for (y = 0; y < 32; ++y)
146       cat[y] = pixel_row;
147 
148     return cat;
149 
150   }
151 }