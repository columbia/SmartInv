1 /*
2 
3  $$$$$$\  $$$$$$\  
4  \_$$  _|$$  __$$\ 
5    $$ |  $$ /  $$ |
6    $$ |  $$ |  $$ |
7    $$ |  $$ |  $$ |
8    $$ |  $$ |  $$ |
9  $$$$$$\  $$$$$$  |
10  \______| \______/ 
11 
12 */
13 pragma solidity ^0.5.10;
14 
15 library Util {
16     struct User {
17         bool isExist;
18         uint256 id;
19         uint256 origRefID;
20         uint256 referrerID;
21         address[] referral;
22         uint256[] expiring;
23     }
24 
25 }
26 
27 contract IOCrypto {
28     /////////////////////
29     // Events
30     /////////////////////
31     event registered(address indexed user, address indexed referrer);
32     event levelBought(address indexed user, uint256 level);
33     event receivedEther(address indexed user, address indexed referral, uint256 level);
34     event lostEther(address indexed user, address indexed referral, uint256 level);
35 
36     /////////////////////
37     // Storage variables
38     /////////////////////
39     address public wallet;
40 
41     uint256 constant MAX_REFERRERS = 2;
42     uint256 LEVEL_PERIOD = 365 days;
43 
44     /////////////////////
45     // User structure and mappings
46     /////////////////////
47 
48     mapping(address => Util.User) public users;
49     mapping(uint256 => address) public userList;
50     uint256 public userIDCounter = 0;
51 
52     /////////////////////
53     // Code
54     /////////////////////
55     constructor() public {
56         wallet = 0x387db6A5a4854610faB136A40B9Fb5E4675d2A16;
57 
58         Util.User memory user;
59         userIDCounter++;
60 
61         user = Util.User({
62             isExist : true,
63             id : userIDCounter,
64             origRefID: 0,
65             referrerID : 0,
66             referral : new address[](0),
67             expiring : new uint256[](9)
68             });
69 
70         user.expiring[1] = 101010101010;
71         user.expiring[2] = 101010101010;
72         user.expiring[3] = 101010101010;
73         user.expiring[4] = 101010101010;
74         user.expiring[5] = 101010101010;
75         user.expiring[6] = 101010101010;
76         user.expiring[7] = 101010101010;
77         user.expiring[8] = 101010101010;
78 
79         userList[userIDCounter] = wallet;
80         users[wallet] = user;
81     }
82 
83     function() external payable {
84         uint256 level = getLevel(msg.value);
85 
86         if (users[msg.sender].isExist) {
87             buy(level);
88         } else if (level == 1) {
89             uint256 referrerID = 0;
90             address referrer = bytesToAddress(msg.data);
91 
92             if (users[referrer].isExist) {
93                 referrerID = users[referrer].id;
94             } else {
95                 revert('01 wrong referrer');
96             }
97 
98             register(referrerID);
99         } else {
100             revert("02 buy level 1 for 0.1 ETH");
101         }
102     }
103 
104     function register(uint256 referrerID) public payable {
105         require(!users[msg.sender].isExist, '03 user exist');
106         require(referrerID > 0 && referrerID <= userIDCounter, '0x04 wrong referrer ID');
107         require(getLevel(msg.value) == 1, '05 wrong value');
108 
109         uint origRefID = referrerID;
110         if (users[userList[referrerID]].referral.length >= MAX_REFERRERS)
111         {
112             referrerID = users[findReferrer(userList[referrerID])].id;
113         }
114 
115         Util.User memory user;
116         userIDCounter++;
117 
118         user = Util.User({
119             isExist : true,
120             id : userIDCounter,
121             origRefID : origRefID,
122             referrerID : referrerID,
123             referral : new address[](0),
124             expiring : new uint256[](9)
125             });
126 
127         user.expiring[1] = now + LEVEL_PERIOD;
128         user.expiring[2] = 0;
129         user.expiring[3] = 0;
130         user.expiring[4] = 0;
131         user.expiring[5] = 0;
132         user.expiring[6] = 0;
133         user.expiring[7] = 0;
134         user.expiring[8] = 0;
135 
136         userList[userIDCounter] = msg.sender;
137         users[msg.sender] = user;
138 
139         users[userList[referrerID]].referral.push(msg.sender);
140 
141         payForLevel(msg.sender, 1);
142 
143         emit registered(msg.sender, userList[referrerID]);
144     }
145 
146     function buy(uint256 level) public payable {
147         require(users[msg.sender].isExist, '06 user not exist');
148 
149         require(level > 0 && level <= 8, '07 wrong level');
150 
151         require(getLevel(msg.value) == level, '08 wrong value');
152 
153         for (uint256 l = level - 1; l > 0; l--) {
154              require(users[msg.sender].expiring[l] >= now, '09 buy level');
155         }
156 
157         if (users[msg.sender].expiring[level] == 0) {
158             users[msg.sender].expiring[level] = now + LEVEL_PERIOD;
159         } else {
160             users[msg.sender].expiring[level] += LEVEL_PERIOD;
161         }
162 
163         payForLevel(msg.sender, level);
164         emit levelBought(msg.sender, level);
165     }
166 
167     function payForLevel(address user, uint256 level) internal {
168         address referrer;
169         uint256 above = level > 4 ? level - 4 : level;
170         if (1 < level && level < 4) {
171             checkCanBuy(user, level);
172         }
173         if (above == 1) {
174             referrer = userList[users[user].referrerID];
175         } else if (above == 2) {
176             referrer = userList[users[user].referrerID];
177             referrer = userList[users[referrer].referrerID];
178         } else if (above == 3) {
179             referrer = userList[users[user].referrerID];
180             referrer = userList[users[referrer].referrerID];
181             referrer = userList[users[referrer].referrerID];
182         } else if (above == 4) {
183             referrer = userList[users[user].referrerID];
184             referrer = userList[users[referrer].referrerID];
185             referrer = userList[users[referrer].referrerID];
186             referrer = userList[users[referrer].referrerID];
187         }
188 
189         if (!users[referrer].isExist) {
190             referrer = userList[1];
191         }
192 
193         if (users[referrer].expiring[level] >= now) {
194             bool result;
195             result = address(uint160(referrer)).send(msg.value);
196             emit receivedEther(referrer, msg.sender, level);
197         } else {
198             emit lostEther(referrer, msg.sender, level);
199             payForLevel(referrer, level);
200         }
201     }
202 
203     function checkCanBuy(address user, uint256 level) private view {
204         if (level == 1) return;
205         address[] memory referral = users[user].referral;
206         require(referral.length == MAX_REFERRERS, '10 not enough referrals');
207 
208         if (level == 2) return;
209         checkCanBuy(referral[0], level - 1);
210         checkCanBuy(referral[1], level - 1);
211     }
212 
213     function findReferrer(address user) public view returns (address) {
214         address[] memory referral = users[user].referral;
215         if (referral.length < MAX_REFERRERS) {
216             return user;
217         }
218 
219         address[] memory referrals = new address[](1024);
220         referrals[0] = referral[0];
221         referrals[1] = referral[1];
222 
223         address freeReferrer;
224         bool hasFreeReferrer = false;
225 
226         for (uint256 i = 0; i < 1024; i++) {
227             referral = users[referrals[i]].referral;
228             if (referral.length == MAX_REFERRERS) {
229                 if (i < 512) {
230                     uint256 pos = (i + 1) * 2;
231                     referrals[pos] = referral[0];
232                     referrals[pos + 1] = referral[1];
233                 }
234             } else {
235                 hasFreeReferrer = true;
236                 freeReferrer = referrals[i];
237                 break;
238             }
239         }
240         require(hasFreeReferrer, '11 no free referrer');
241         return freeReferrer;
242     }
243 
244     function getLevel(uint256 price) public pure returns (uint8) {
245         if (price == 0.1 ether) {
246             return 1;
247         } else if (price == 0.15 ether) {
248             return 2;
249         } else if (price == 0.35 ether) {
250             return 3;
251         } else if (price == 2 ether) {
252             return 4;
253         } else if (price == 5 ether) {
254             return 5;
255         } else if (price == 9 ether) {
256             return 6;
257         } else if (price == 35 ether) {
258             return 7;
259         } else if (price == 100 ether) {
260             return 8;
261         } else {
262             revert('12 wrong value');
263         }
264     }
265 
266     function viewReferral(address user) public view returns (address[] memory) {
267         return users[user].referral;
268     }
269 
270     function viewLevelExpired(address user, uint256 level) public view returns (uint256) {
271         return users[user].expiring[level];
272     }
273 
274     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
275         assembly {
276             addr := mload(add(bys, 20))
277         }
278     }
279 }