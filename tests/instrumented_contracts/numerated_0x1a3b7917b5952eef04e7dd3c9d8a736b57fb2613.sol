1 /**
2  *  
3  *  __                      _   __    __                               
4  * / _\_ __ ___   __ _ _ __| |_/ / /\ \ \__ _ _   _   _ __ _   _ _ __  
5  * \ \| '_ ` _ \ / _` | '__| __\ \/  \/ / _` | | | | | '__| | | | '_ \ 
6  * _\ \ | | | | | (_| | |  | |_ \  /\  / (_| | |_| |_| |  | |_| | | | |
7  * \__/_| |_| |_|\__,_|_|   \__| \/  \/ \__,_|\__, (_)_|   \__,_|_| |_|
8  *                                            |___/                    
9  * Version 2.0
10  * https://smartway.run/
11  * 
12 **/
13 
14 pragma solidity 0.5.13;
15 
16 contract SmartWay {
17 
18     struct User {
19         uint64 id;
20         uint64 referrerId;
21         address payable[] referrals;
22         mapping(uint8 => uint64) levelExpired;
23     }
24     
25     SmartWay public oldSC = SmartWay(0x99280ceFeECcEAf2C5B1537Cd4eeb3B44c3c171F);
26     uint64 public oldSCUserId = 1;
27 
28     uint8 public constant REFERRER_1_LEVEL_LIMIT = 2;
29     uint64 public constant PERIOD_LENGTH = 30 days;
30 
31     address payable public ownerWallet;
32     uint64 public lastUserId;
33     
34     mapping(uint8 => uint) public levelPrice;
35     mapping(uint => uint8) public priceLevel;
36     
37     mapping(address => User) public users;
38     mapping(uint64 => address payable) public userList;
39     
40     event Registration(address indexed user, address referrer);
41     event LevelBought(address indexed user, uint8 level);
42     event GetMoneyForLevel(address indexed user, address indexed referral, uint8 level);
43     event SendMoneyError(address indexed user, address indexed referral, uint8 level);
44     event LostMoneyForLevel(address indexed user, address indexed referral, uint8 level);
45 
46     constructor(address payable owner) public {
47         _initData();
48         ownerWallet = msg.sender;
49         
50         lastUserId++;
51         
52         userList[lastUserId] = owner;
53         users[owner].id = lastUserId;
54         
55         for(uint8 i = 1; i <= 12; i++) {
56             users[owner].levelExpired[i] = 77777777777;
57         }
58     }
59 
60     function () external payable {
61         uint8 level = priceLevel[msg.value];
62         require(level != 0, 'Incorrect value sent');
63         
64         if(users[msg.sender].id != 0)
65             return buyLevel(level);
66         
67         require(level == 1, 'Please buy level 1 for 0.2 ETH');
68         
69         address referrer = bytesToAddress(msg.data);
70 
71         if(users[referrer].id != 0)
72             return regUser(users[referrer].id);
73 
74         require(referrer == address(0));
75     }
76 
77     function regUser(uint64 referrerId) public payable {
78         require(address(oldSC) == address(0), 'Initialize not finished');
79         require(users[msg.sender].id == 0, 'User exist');
80         require(referrerId > 0 && referrerId <= lastUserId, 'Incorrect referrer Id');
81         require(msg.value == levelPrice[1], 'Incorrect Value');
82 
83         if(users[userList[referrerId]].referrals.length >= REFERRER_1_LEVEL_LIMIT) {
84             address freeReferrer = findFreeReferrer(userList[referrerId]);
85             referrerId = users[freeReferrer].id;
86         }
87             
88         lastUserId++;
89 
90         users[msg.sender] = User({
91             id: lastUserId,
92             referrerId: referrerId,
93             referrals: new address payable[](0) 
94         });
95         
96         userList[lastUserId] = msg.sender;
97 
98         users[msg.sender].levelExpired[1] = uint64(now + PERIOD_LENGTH);
99 
100         users[userList[referrerId]].referrals.push(msg.sender);
101 
102         payForLevel(1, msg.sender);
103 
104         emit Registration(msg.sender, userList[referrerId]);
105     }
106 
107     function buyLevel(uint8 level) public payable {
108         require(users[msg.sender].id != 0, 'User is not exists'); 
109         require(level > 0 && level <= 12, 'Incorrect level');
110         require(msg.value == levelPrice[level], 'Incorrect Value');
111     
112         
113         for(uint8 i = level - 1; i > 0; i--) {
114             require(users[msg.sender].levelExpired[i] >= now, 'Buy the previous level');
115         }
116         
117         if(users[msg.sender].levelExpired[level] == 0 || users[msg.sender].levelExpired[level] < now) {
118             users[msg.sender].levelExpired[level] = uint64(now + PERIOD_LENGTH);
119         } else {
120             users[msg.sender].levelExpired[level] += PERIOD_LENGTH;
121         }
122         
123         payForLevel(level, msg.sender);
124 
125         emit LevelBought(msg.sender, level);
126     }
127     
128 
129     function payForLevel(uint8 level, address user) private {
130         address payable referrer;
131 
132         if (level%2 == 0) {
133             referrer = userList[users[userList[users[user].referrerId]].referrerId]; //extra variable will decrease aroud 50 recursion levels
134         } else {
135             referrer = userList[users[user].referrerId];
136         }
137 
138         if(users[referrer].id == 0) {
139             referrer = userList[1];
140         } 
141 
142         if(users[referrer].levelExpired[level] >= now) {
143             if (referrer.send(levelPrice[level])) {
144                 emit GetMoneyForLevel(referrer, msg.sender, level);
145             } else {
146                 emit SendMoneyError(referrer, msg.sender, level);
147             }
148         } else {
149             emit LostMoneyForLevel(referrer, msg.sender, level);
150 
151             payForLevel(level, referrer);
152         }
153     }
154 
155     function _initData() private {
156         levelPrice[1] = 0.2 ether;
157         levelPrice[2] = 0.22 ether;
158         levelPrice[3] = 0.4 ether;
159         levelPrice[4] = 0.44 ether;
160         levelPrice[5] = 0.7 ether;
161         levelPrice[6] = 0.77 ether;
162         levelPrice[7] = 1.2 ether;
163         levelPrice[8] = 1.3 ether;
164         levelPrice[9] = 2 ether;
165         levelPrice[10] = 2.2 ether;
166         levelPrice[11] = 3 ether;
167         levelPrice[12] = 3.3 ether;
168 
169         priceLevel[0.2 ether] = 1;
170         priceLevel[0.22 ether] = 2;
171         priceLevel[0.4 ether] = 3;
172         priceLevel[0.44 ether] = 4;
173         priceLevel[0.7 ether] = 5;
174         priceLevel[0.77 ether] = 6;
175         priceLevel[1.2 ether] = 7;
176         priceLevel[1.3 ether] = 8;
177         priceLevel[2 ether] = 9;
178         priceLevel[2.2 ether] = 10;
179         priceLevel[3 ether] = 11;
180         priceLevel[3.3 ether] = 12;
181     }
182 
183     function findFreeReferrer(address _user) public view returns(address) {
184         if(users[_user].referrals.length < REFERRER_1_LEVEL_LIMIT) 
185             return _user;
186 
187         address[] memory referrals = new address[](256);
188         address[] memory referralsBuf = new address[](256);
189 
190         referrals[0] = users[_user].referrals[0];
191         referrals[1] = users[_user].referrals[1];
192 
193         uint32 j = 2;
194         
195         while(true) {
196             for(uint32 i = 0; i < j; i++) {
197                 if(users[referrals[i]].referrals.length < 1) {
198                     return referrals[i];
199                 }
200             }
201             
202             for(uint32 i = 0; i < j; i++) {
203                 if (users[referrals[i]].referrals.length < REFERRER_1_LEVEL_LIMIT) {
204                     return referrals[i];
205                 }
206             }
207 
208             for(uint32 i = 0; i < j; i++) {
209                 referralsBuf[i] = users[referrals[i]].referrals[0];
210                 referralsBuf[j+i] = users[referrals[i]].referrals[1];
211             }
212 
213             j = j*2;
214 
215             for(uint32 i = 0; i < j; i++) {
216                 referrals[i] = referralsBuf[i];
217             }
218         }
219     }
220     
221     function syncWithOldSC(uint limit) public {
222         require(address(oldSC) != address(0), 'Initialize closed');
223         require(msg.sender == ownerWallet, 'Access denied');
224 
225         for(uint i = 0; i < limit; i++) {
226             address payable user = oldSC.userList(oldSCUserId);
227             (uint64 id, uint64 referrerId) = oldSC.users(user);
228 
229             if(id != 0) {
230                 oldSCUserId++;
231                 
232                 address ref = oldSC.userList(referrerId);
233 
234                 if(users[user].id == 0 && users[ref].id != 0) {
235                     users[user].id = ++lastUserId;
236                     users[user].referrerId = users[ref].id;
237 
238                     userList[lastUserId] = user;
239                     users[ref].referrals.push(user);
240 
241                     for(uint8 j = 1; j <= 12; j++) {
242                         uint levelExpired = oldSC.viewUserLevelExpired(user, j);
243                         if (levelExpired > now) {
244                             users[user].levelExpired[j] = uint64(levelExpired + 30 days);
245                         }
246                     }
247 
248                     emit Registration(user, ref);
249                 }
250             }
251             else break;
252         }
253     }
254 
255     function syncClose() external {
256         require(address(oldSC) != address(0), 'Initialize already closed');
257         require(msg.sender == ownerWallet, 'Access denied');
258 
259         oldSC = SmartWay(0);
260     }
261 
262     function viewUserReferral(address user) public view returns(address payable[] memory) {
263         return users[user].referrals;
264     }
265 
266     function viewUserLevelExpired(address user, uint8 level) public view returns(uint) {
267         return users[user].levelExpired[level];
268     }
269 
270     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
271         assembly {
272             addr := mload(add(bys, 20))
273         }
274     }
275 }