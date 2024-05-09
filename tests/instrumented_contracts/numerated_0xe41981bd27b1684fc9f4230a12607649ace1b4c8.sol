1 pragma solidity ^0.4.17;
2 
3 contract NovaLabInterface {
4     function bornFamedStar(uint lc) external constant returns(bool) {}
5 }
6 
7 contract NovaAccessControl {
8   mapping (address => bool) managers;
9   address cfoAddress;
10 
11   function NovaAccessControl() public {
12     managers[msg.sender] = true;
13   }
14 
15   modifier onlyManager() {
16     require(managers[msg.sender]);
17     _;
18   }
19 
20   function setManager(address _newManager) external onlyManager {
21     require(_newManager != address(0));
22     managers[_newManager] = true;
23   }
24 
25   function removeManager(address mangerAddress) external onlyManager {
26     require(mangerAddress != msg.sender);
27     managers[mangerAddress] = false;
28   }
29 
30   function updateCfo(address newCfoAddress) external onlyManager {
31     require(newCfoAddress != address(0));
32     cfoAddress = newCfoAddress;
33   }
34 }
35 
36 contract FamedStar is NovaAccessControl {
37   struct Star {
38     bytes32 name;
39     uint mass;
40     uint lc;
41     address owner;
42   }
43 
44   address public labAddress;
45   address public novaAddress;
46 
47   Star[] stars;
48   mapping (bytes32 => uint) public famedStarNameToIds;
49   mapping (uint => uint) public famedStarMassToIds;
50 
51   function FamedStar() public {
52       // add placeholder
53       _addFamedStar("placeholder", 0, 0);
54   }
55 
56   function _bytes32ToString(bytes32 x) internal pure returns (string) {
57     bytes memory bytesString = new bytes(32);
58     uint charCount = 0;
59     for (uint j = 0; j < 32; j++) {
60         byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
61         if (char != 0) {
62             bytesString[charCount] = char;
63             charCount++;
64         }
65     }
66     bytes memory bytesStringTrimmed = new bytes(charCount);
67     for (j = 0; j < charCount; j++) {
68         bytesStringTrimmed[j] = bytesString[j];
69     }
70     return string(bytesStringTrimmed);
71   }
72 
73   function _stringToBytes32(string source) internal pure returns (bytes32 result) {
74     bytes memory tempEmptyStringTest = bytes(source);
75     if (tempEmptyStringTest.length == 0) {
76         return 0x0;
77     }
78 
79     assembly {
80         result := mload(add(source, 32))
81     }
82   }
83 
84   function updateLabAddress(address addr) external onlyManager {
85       labAddress = addr;
86   }
87 
88   function updateNovaAddress(address addr) external onlyManager {
89       novaAddress = addr;
90   }
91 
92   function addFamedStar(string name, uint mass, uint lc) external onlyManager {
93       _addFamedStar(name, mass, lc);
94   }
95 
96   function _addFamedStar(string name, uint mass, uint lc) internal {
97       require(bytes(name).length <= 32);
98       var bN = _stringToBytes32(name);
99       // no repeat on name
100       require(famedStarNameToIds[bN] == 0);
101 
102       // no repeat on mass
103       require(famedStarMassToIds[mass] == 0);
104 
105       var id = stars.push(Star({
106           name: bN,
107           mass: mass,
108           lc: lc,
109           owner: 0x0
110       })) - 1;
111 
112       famedStarNameToIds[bN] = id;
113       famedStarMassToIds[mass] = id;
114   }
115 
116   function getFamedStarByID(uint id) public constant returns(uint starID, string name, uint mass, address owner) {
117       require(id > 0 && id < stars.length);
118       var star = stars[id];
119 
120       return (id, _bytes32ToString(star.name), star.mass, star.owner);
121   }
122 
123   function getFamedStarByName(string n) public constant returns(uint starID, string name, uint mass, address owner) {
124       starID = famedStarNameToIds[_stringToBytes32(n)];
125 
126       require(starID > 0);
127 
128       var star = stars[starID];
129 
130       return (starID, n, star.mass, star.owner);
131   }
132 
133   function getFamedStarByMass(uint m) public constant returns(uint starID, string name, uint mass, address owner) {
134       starID = famedStarMassToIds[m];
135 
136       require(starID > 0);
137 
138       var star = stars[starID];
139 
140       return (starID, _bytes32ToString(star.name), star.mass, star.owner);
141   }
142 
143   function updateFamedStarOwner(uint id, address newOwner) external {
144       require(msg.sender == novaAddress);
145       require(id > 0 && id < stars.length);
146       var star = stars[id];
147       require(star.mass > 0);
148 
149       stars[id].owner = newOwner;
150   }
151 
152   function bornFamedStar(address userAddress, uint mass) external returns(uint id, bytes32 name) {
153       require(msg.sender == novaAddress);
154       var starID = famedStarMassToIds[mass];
155       if (starID == 0) {
156           return (0, 0);
157       }
158 
159       var star = stars[starID];
160 
161       if (star.owner != address(0x0)) {
162           return (0, 0);
163       }
164 
165       bool isGot;
166       var labContract = NovaLabInterface(labAddress);
167       isGot = labContract.bornFamedStar(star.lc);
168       if (isGot) {
169           stars[starID].owner = userAddress;
170           return (starID, stars[starID].name);
171       } else {
172           stars[starID].lc++;
173           return (0, 0);
174       }
175   }
176 }