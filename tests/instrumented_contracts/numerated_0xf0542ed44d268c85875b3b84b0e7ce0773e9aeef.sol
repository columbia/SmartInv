1 pragma solidity >=0.4.24;
2 
3 contract Matrix {
4     struct User {
5         uint id;
6         address referrer;
7         uint personalMatrixCnt;
8         uint personalMatrixNum;
9         uint personalMatrixFills;
10         uint totalReferrals;
11         uint levelsOpen;
12     }
13 
14     mapping(uint => uint) public LEVEL_PRICE;
15     mapping(uint => uint) public LEVEL_SLOTS;
16     mapping(uint => uint) public EXTRA_SLOTS;
17 
18     mapping(address => User) public users;
19     mapping(uint => address) public binaryUsers;
20     mapping(uint => address) public usersById;
21 
22     mapping(address => mapping (uint => uint)) public positionsByAddress;
23     mapping(address => uint) public positionsByAddressCnt;
24     mapping(uint => uint) public binaryPositionsLevels;
25 
26     uint public lastUserId = 2;
27     uint public lastBinaryId = 1;
28     uint public lastPersonalMatrixId = 2;
29     address public owner;
30 
31     uint REGISTRATION_COST = 0.05 ether;
32 
33     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
34     event LevelUpgraded(address indexed user, uint indexed userId, uint indexed level);
35     event LevelFilled(address indexed user, uint indexed userId, uint indexed level);
36     event Transfer(address indexed user, uint indexed userId, uint indexed amount);
37 
38     function isUserExists(address user) public view returns (bool) {
39         return (users[user].id != 0);
40     }
41 
42     constructor(address ownerAddress) public {
43         owner = ownerAddress;
44 
45         User memory user = User({
46             id: 1,
47             referrer: address(0),
48             personalMatrixCnt: 0,
49             personalMatrixNum: 1,
50             personalMatrixFills: 0,
51             totalReferrals: 0,
52             levelsOpen: 1
53             });
54 
55         users[ownerAddress] = user;
56         usersById[1] = ownerAddress;
57 
58         LEVEL_PRICE[1] = 0.05 ether;
59         LEVEL_PRICE[2] = 0.1 ether;
60         LEVEL_PRICE[3] = 0.2 ether;
61         LEVEL_PRICE[4] = 1 ether;
62         LEVEL_PRICE[5] = 6 ether;
63         LEVEL_PRICE[6] = 50 ether;
64         LEVEL_PRICE[7] = 50 ether;
65         LEVEL_PRICE[8] = 100 ether;
66         LEVEL_PRICE[9] = 400 ether;
67         LEVEL_PRICE[10] = 1600 ether;
68 
69         LEVEL_SLOTS[1] = 2;
70         LEVEL_SLOTS[2] = 4;
71         LEVEL_SLOTS[3] = 8;
72         LEVEL_SLOTS[4] = 16;
73         LEVEL_SLOTS[5] = 32;
74         LEVEL_SLOTS[6] = 2;
75         LEVEL_SLOTS[7] = 4;
76         LEVEL_SLOTS[8] = 8;
77         LEVEL_SLOTS[9] = 16;
78         LEVEL_SLOTS[10] = 32;
79 
80         EXTRA_SLOTS[1] = 0;
81         EXTRA_SLOTS[2] = 1;
82         EXTRA_SLOTS[3] = 6;
83         EXTRA_SLOTS[4] = 20;
84         EXTRA_SLOTS[5] = 200;
85         EXTRA_SLOTS[6] = 200;
86         EXTRA_SLOTS[7] = 400;
87         EXTRA_SLOTS[8] = 2000;
88         EXTRA_SLOTS[9] = 16000;
89         EXTRA_SLOTS[10] = 124000;
90     }
91 
92     function reg(address referrer) public payable {
93         registration(msg.sender, referrer);
94     }
95 
96     function purchasePosition() public payable {
97         require(msg.value == 0.05 ether, "purchase cost 0.05");
98         require(isUserExists(msg.sender), "user not exists");
99 
100         updateBinaryMatrix(msg.sender);
101     }
102 
103     function registration(address userAddress, address referrerAddress) private {
104         require(msg.value == 0.1 ether, "registration cost 0.1");
105         require(!isUserExists(userAddress), "user exists");
106         require(isUserExists(referrerAddress), "referrer not exists");
107 
108         uint32 size;
109         assembly {
110             size := extcodesize(userAddress)
111         }
112         require(size == 0, "cannot be a contract");
113 
114         users[userAddress] = User({
115             id: lastUserId,
116             referrer: referrerAddress,
117             levelsOpen: 1,
118             personalMatrixCnt: 0,
119             personalMatrixFills: 0,
120             personalMatrixNum: lastPersonalMatrixId,
121             totalReferrals: 0
122             });
123         usersById[lastUserId] = userAddress;
124 
125         lastUserId++;
126         lastPersonalMatrixId++;
127 
128         updatePersonalMatrix(referrerAddress);
129         updateBinaryMatrix(userAddress);
130 
131         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
132     }
133 
134     function updatePersonalMatrix(address referrer) private {
135         users[referrer].totalReferrals++;
136         if (users[referrer].personalMatrixCnt < 2) {
137             payRegDividends(referrer);
138             users[referrer].personalMatrixCnt++;
139         } else if (users[referrer].personalMatrixCnt == 2) {
140             updateBinaryMatrix(referrer);
141             users[referrer].personalMatrixCnt++;
142         } else {
143             if (users[referrer].referrer == address(0)) {
144                 payRegDividends(referrer);
145             } else {
146                 updatePersonalMatrix(users[referrer].referrer);
147             }
148             users[referrer].personalMatrixCnt = 0;
149             users[referrer].personalMatrixNum = lastPersonalMatrixId;
150             users[referrer].personalMatrixFills++;
151             lastPersonalMatrixId++;
152         }
153     }
154 
155     function payRegDividends(address user) private {
156         emit Transfer(user, users[user].id, REGISTRATION_COST);
157         address(uint160(user)).transfer(REGISTRATION_COST);
158     }
159 
160     function updateBinaryMatrix(address user) private {
161         positionsByAddress[user][positionsByAddressCnt[user]] = lastBinaryId;
162         positionsByAddressCnt[user]++;
163         binaryPositionsLevels[lastBinaryId] = 1;
164 
165         binaryUsers[lastBinaryId] = user;
166         lastBinaryId++;
167 
168         uint div = 1;
169         uint level = 0;
170         uint initIndex = lastBinaryId-1;
171         uint index = lastBinaryId-1;
172 
173         while (level < 5) {
174             level++;
175             div *= 2;
176 
177             if (index % div == div - 1) {
178                 index = index / div;
179 
180                 if (index != 0) {
181                     binaryPositionsLevels[index] = level;
182                     fillLevel(binaryUsers[index], level);
183                 } else {
184                     return;
185                 }
186             } else {
187                 return;
188             }
189         }
190 
191         index = initIndex;
192 
193         while (level < 10) {
194             level++;
195             div *= 2;
196 
197             if (index % div == div - 1) {
198                 index = index / div;
199 
200                 if (index != 0) {
201                     binaryPositionsLevels[index] = level;
202                     fillLevel(binaryUsers[index], level);
203                 } else {
204                     return;
205                 }
206             } else {
207                 return;
208             }
209         }
210     }
211 
212     function fillLevel(address user, uint level) private {
213         emit LevelFilled(user, users[user].id, level);
214 
215         level = level + 1;
216 
217         uint payment = LEVEL_PRICE[level - 1] * LEVEL_SLOTS[level - 1];
218 
219         if (users[user].levelsOpen < level) {
220             users[user].levelsOpen++;
221             emit LevelUpgraded(user, users[user].id, level);
222         }
223 
224         payment -= LEVEL_PRICE[level];
225         payment -= REGISTRATION_COST * EXTRA_SLOTS[level-1];
226 
227         if (level > 2) {
228             emit Transfer(user, users[user].id, payment);
229 
230             address(uint160(user)).transfer(payment);
231         }
232 
233         uint i = 0;
234         while (i < EXTRA_SLOTS[level-1]) {
235             updateBinaryMatrix(user);
236             i++;
237         }
238     }
239 
240     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
241         assembly {
242             addr := mload(add(bys, 20))
243         }
244     }
245 }