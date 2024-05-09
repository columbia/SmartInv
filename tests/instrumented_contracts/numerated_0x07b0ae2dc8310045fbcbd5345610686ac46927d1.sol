1 pragma solidity ^0.5.0;
2 
3 contract Village {
4 
5     struct User {
6         string name;
7         bool landclaimed;
8         bool registered;
9     }
10     struct Land { 
11         address owner;
12         bool house;
13         uint8 xcoord; 
14         uint8 ycoord; 
15         uint8 width;
16         uint8 length;
17     }
18     mapping(address => User) public UserRegistry;
19     mapping(string => address) NameRegistry;
20     Land[] public LandRegistry; 
21     uint8[50][50] public mapGrid;   
22     uint8[50][50] public landGrid;  
23 
24     constructor() public {
25         LandRegistry.push(Land(address(0), false, 0, 0, 0, 0)); 
26         initFauna();
27     }
28 
29     //=>MOD
30     modifier onlyRegistered() {
31         require(UserRegistry[msg.sender].registered == true, "Only registered can call this.");
32         _;
33     }
34     modifier onlyUnregistered() { 
35         require(UserRegistry[msg.sender].registered == false, "Only Unregistered can call this.");
36         _;
37     }
38 
39     //=>EVENT
40     event LandClaimed(uint x); 
41     event HouseBuilt(uint x);
42     event UserRegistered(address user);
43 
44     //=>GET
45     function getMapGrid() public view returns(uint8[50][50] memory) {
46         return mapGrid;
47     }
48     function getLandGrid() public view returns(uint8[50][50] memory) {
49         return landGrid;
50     }
51     function getLandRegistry() public view returns(address[] memory, bool[] memory, uint8[] memory, uint8[] memory, uint8[] memory, uint8[] memory) {
52         address[] memory addr = new address[](LandRegistry.length);
53         bool[] memory house = new bool[](LandRegistry.length);
54         uint8[] memory x = new uint8[](LandRegistry.length);
55         uint8[] memory y = new uint8[](LandRegistry.length);
56         uint8[] memory width = new uint8[](LandRegistry.length);
57         uint8[] memory length = new uint8[](LandRegistry.length);
58         for(uint i=1; i<LandRegistry.length; i++) {
59             addr[i] = LandRegistry[i].owner;
60             house[i] = LandRegistry[i].house;
61             x[i] = LandRegistry[i].xcoord;
62             y[i] = LandRegistry[i].ycoord;
63             width[i] = LandRegistry[i].width;
64             length[i] = LandRegistry[i].length;
65         }
66         return (addr, house, x, y, width, length);
67     } 
68     function getUser(address addr) public view returns(string memory, bool) {
69         return (UserRegistry[addr].name, UserRegistry[addr].landclaimed);
70     }
71 
72     //=>SET
73     function registerName(string memory name) public onlyUnregistered() {
74         bytes memory input = bytes(name);
75         require(NameRegistry[name] == address(0), "Name already registered.");
76         require(input.length>3, "Name is too short");
77         require(input.length<12, "Name is too long");
78         for(uint i; i<input.length; i++){
79             bytes1 char = input[i];
80                 if(
81                     !(char >= 0x30 && char <= 0x39) && //9-0
82                     !(char >= 0x41 && char <= 0x5A) && //A-Z
83                     !(char >= 0x61 && char <= 0x7A) && //a-z
84                     !(char == 0x2E) //.
85                 ) revert("Name has to be alphanumeric!");
86         }
87         UserRegistry[msg.sender].name = name;
88         UserRegistry[msg.sender].registered = true;
89         NameRegistry[name] = msg.sender;
90         emit UserRegistered(msg.sender);
91     }
92     function claimLand(uint xcoord, uint ycoord, uint width, uint length) public onlyRegistered() {
93         require(UserRegistry[msg.sender].landclaimed == false, "cant claim more than one land");
94         require(width>=4 && width<=7, "size invalid");
95         require(length>=4 && length<=7, "size invalid");
96         uint8 landindex = uint8(LandRegistry.length);
97         for(uint x = xcoord; x < xcoord+width; x++) { 
98             for(uint y = ycoord; y < ycoord+length+1; y++) { 
99                 if(landGrid[x][y] == 0) {
100                     landGrid[x][y] = landindex;
101                 } else {
102                     revert("cant claim this land");
103                 }
104             }
105         }
106         LandRegistry.push(Land(msg.sender, false, uint8(xcoord), uint8(ycoord), uint8(width), uint8(length)));
107         UserRegistry[msg.sender].landclaimed = true;
108         emit LandClaimed(landindex);
109     }
110     function buildHouse(uint landindex) public onlyRegistered() {
111         require(LandRegistry[landindex].owner == msg.sender);
112         require(LandRegistry[landindex].house == false);
113         LandRegistry[landindex].house = true;
114         emit HouseBuilt(landindex);
115     }
116 
117     //=>INIT
118     function initFauna() internal {
119         mapGrid[1][1] = 5;
120         mapGrid[1][15] = 5;
121         mapGrid[24][23] = 5;
122         mapGrid[25][25] = 5;
123         mapGrid[27][26] = 5;
124         mapGrid[3][16] = 5;
125         mapGrid[5][19] = 5;
126         mapGrid[8][25] = 5;
127         mapGrid[5][26] = 5;
128         mapGrid[11][39] = 5;
129         mapGrid[12][21] = 5;
130         mapGrid[16][10] = 5;
131         mapGrid[33][46] = 5;
132         mapGrid[36][31] = 5;
133         mapGrid[29][41] = 5;
134         mapGrid[42][23] = 5;
135         mapGrid[46][43] = 5;
136         mapGrid[31][3] = 5;
137         mapGrid[47][47] = 5;
138         mapGrid[19][27] = 5;
139         mapGrid[34][8] = 5;
140     }
141 }