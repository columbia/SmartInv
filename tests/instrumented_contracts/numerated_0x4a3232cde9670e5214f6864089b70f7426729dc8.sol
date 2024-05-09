1 pragma solidity 0.4.25;
2 
3 contract Auth {
4 
5   address internal mainAdmin;
6   address internal backupAdmin;
7 
8   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
9 
10   constructor(
11     address _mainAdmin,
12     address _backupAdmin
13   ) internal {
14     mainAdmin = _mainAdmin;
15     backupAdmin = _backupAdmin;
16   }
17 
18   modifier onlyMainAdmin() {
19     require(isMainAdmin(), "onlyMainAdmin");
20     _;
21   }
22 
23   modifier onlyBackupAdmin() {
24     require(isBackupAdmin(), "onlyBackupAdmin");
25     _;
26   }
27 
28   function transferOwnership(address _newOwner) onlyBackupAdmin internal {
29     require(_newOwner != address(0x0));
30     mainAdmin = _newOwner;
31     emit OwnershipTransferred(msg.sender, _newOwner);
32   }
33 
34   function isMainAdmin() public view returns (bool) {
35     return msg.sender == mainAdmin;
36   }
37 
38   function isBackupAdmin() public view returns (bool) {
39     return msg.sender == backupAdmin;
40   }
41 }
42 
43 contract Fomo5k is Auth {
44 
45   struct User {
46     bool isExist;
47     uint id;
48     uint referrerID;
49     address[] referral;
50     mapping(uint => uint) levelExpired;
51     uint level;
52   }
53 
54   uint REFERRER_1_LEVEL_LIMIT = 2;
55   uint PERIOD_LENGTH = 100 days;
56   uint public totalUser = 1;
57 
58   mapping(uint => uint) public LEVEL_PRICE;
59 
60   mapping (address => User) public users;
61   mapping (uint => address) public userLists;
62   uint public userIdCounter = 0;
63   address cAccount;
64 
65   event Registered(address indexed user, address indexed inviter, uint id, uint time);
66   event LevelBought(address indexed user, uint indexed id, uint level, uint time);
67   event MoneyReceived(address indexed user, uint indexed id, address indexed from, uint level, uint amount, uint time);
68   event MoneyMissed(address indexed user, uint indexed id, address indexed from, uint level, uint amount, uint time);
69 
70   constructor(
71     address _rootAccount,
72     address _cAccount,
73     address _backupAdmin
74   )
75   public
76   Auth(msg.sender, _backupAdmin)
77   {
78     LEVEL_PRICE[1] = 0.1 ether;
79     LEVEL_PRICE[2] = 0.16 ether;
80     LEVEL_PRICE[3] = 0.3 ether;
81     LEVEL_PRICE[4] = 1 ether;
82     LEVEL_PRICE[5] = 3 ether;
83     LEVEL_PRICE[6] = 8 ether;
84     LEVEL_PRICE[7] = 16 ether;
85     LEVEL_PRICE[8] = 31 ether;
86     LEVEL_PRICE[9] = 60 ether;
87     LEVEL_PRICE[10] = 120 ether;
88 
89     User memory user;
90 
91     user = User({
92       isExist: true,
93       id: userIdCounter,
94       referrerID: 0,
95       referral: new address[](0),
96       level: 1
97     });
98     users[_rootAccount] = user;
99     userLists[userIdCounter] = _rootAccount;
100     cAccount = _cAccount;
101   }
102 
103   function updateMainAdmin(address _admin) public {
104     transferOwnership(_admin);
105   }
106 
107   function updateCAccount(address _cAccount) onlyMainAdmin public {
108     cAccount = _cAccount;
109   }
110 
111   function () external payable {
112     uint level;
113 
114     if(msg.value == LEVEL_PRICE[1]) level = 1;
115     else if(msg.value == LEVEL_PRICE[2]) level = 2;
116     else if(msg.value == LEVEL_PRICE[3]) level = 3;
117     else if(msg.value == LEVEL_PRICE[4]) level = 4;
118     else if(msg.value == LEVEL_PRICE[5]) level = 5;
119     else if(msg.value == LEVEL_PRICE[6]) level = 6;
120     else if(msg.value == LEVEL_PRICE[7]) level = 7;
121     else if(msg.value == LEVEL_PRICE[8]) level = 8;
122     else if(msg.value == LEVEL_PRICE[9]) level = 9;
123     else if(msg.value == LEVEL_PRICE[10]) level = 10;
124     else revert('Incorrect Value send');
125 
126     if(users[msg.sender].isExist) buyLevel(level);
127     else if(level == 1) {
128       uint refId = 0;
129       address referrer = bytesToAddress(msg.data);
130 
131       if(users[referrer].isExist) refId = users[referrer].id;
132       else revert('Incorrect referrer');
133 
134       regUser(refId);
135     }
136     else revert('Please buy first level for 0.1 ETH');
137   }
138 
139   function regUser(uint _referrerID) public payable {
140     require(!users[msg.sender].isExist, 'User exist');
141     require(_referrerID >= 0 && _referrerID <= userIdCounter, 'Incorrect referrer Id');
142     require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
143 
144     if(users[userLists[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userLists[_referrerID])].id;
145 
146     User memory user;
147     userIdCounter++;
148 
149     user = User({
150       isExist: true,
151       id: userIdCounter,
152       referrerID: _referrerID,
153       referral: new address[](0),
154       level: 1
155     });
156 
157     users[msg.sender] = user;
158     userLists[userIdCounter] = msg.sender;
159 
160     users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
161 
162     users[userLists[_referrerID]].referral.push(msg.sender);
163     totalUser += 1;
164     emit Registered(msg.sender, userLists[_referrerID], userIdCounter, now);
165 
166     payForLevel(1, msg.sender);
167   }
168 
169   function buyLevel(uint _level) public payable {
170     require(users[msg.sender].isExist, 'User not exist');
171     require(_level > 0 && _level <= 10, 'Incorrect level');
172 
173     if(_level == 1) {
174       require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
175       users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
176     }
177     else {
178       require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
179 
180       for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
181 
182       if(users[msg.sender].levelExpired[_level] == 0 || users[msg.sender].levelExpired[_level] < now) {
183         users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
184       } else {
185         users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
186       }
187     }
188     users[msg.sender].level = _level;
189     emit LevelBought(msg.sender, users[msg.sender].id, _level, now);
190 
191     payForLevel(_level, msg.sender);
192   }
193 
194   function payForLevel(uint _level, address _user) internal {
195     address referer;
196     address referer1;
197     address referer2;
198     address referer3;
199     address referer4;
200 
201     if(_level == 1 || _level == 6) {
202       referer = userLists[users[_user].referrerID];
203     }
204     else if(_level == 2 || _level == 7) {
205       referer1 = userLists[users[_user].referrerID];
206       referer = userLists[users[referer1].referrerID];
207     }
208     else if(_level == 3 || _level == 8) {
209       referer1 = userLists[users[_user].referrerID];
210       referer2 = userLists[users[referer1].referrerID];
211       referer = userLists[users[referer2].referrerID];
212     }
213     else if(_level == 4 || _level == 9) {
214       referer1 = userLists[users[_user].referrerID];
215       referer2 = userLists[users[referer1].referrerID];
216       referer3 = userLists[users[referer2].referrerID];
217       referer = userLists[users[referer3].referrerID];
218     }
219     else if(_level == 5 || _level == 10) {
220       referer1 = userLists[users[_user].referrerID];
221       referer2 = userLists[users[referer1].referrerID];
222       referer3 = userLists[users[referer2].referrerID];
223       referer4 = userLists[users[referer3].referrerID];
224       referer = userLists[users[referer4].referrerID];
225     }
226 
227     if(users[referer].isExist && users[referer].id > 0) {
228       bool sent = false;
229       if(users[referer].levelExpired[_level] >= now && users[referer].level == _level) {
230         sent = address(uint160(referer)).send(LEVEL_PRICE[_level]);
231 
232         if (sent) {
233           emit MoneyReceived(referer, users[referer].id, msg.sender, _level, LEVEL_PRICE[_level], now);
234         }
235       }
236       if(!sent) {
237         emit MoneyMissed(referer, users[referer].id, msg.sender, _level, LEVEL_PRICE[_level], now);
238 
239         payForLevel(_level, referer);
240       }
241     } else {
242       cAccount.transfer(LEVEL_PRICE[_level]);
243     }
244   }
245 
246   function findFreeReferrer(address _user) public view returns(address) {
247     if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
248 
249     address[] memory referrals = new address[](126);
250     referrals[0] = users[_user].referral[0];
251     referrals[1] = users[_user].referral[1];
252 
253     address freeReferrer;
254     bool noFreeReferrer = true;
255 
256     for(uint i = 0; i < 126; i++) {
257       if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
258         if(i < 62) {
259           referrals[(i+1)*2] = users[referrals[i]].referral[0];
260           referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
261         }
262       }
263       else {
264         noFreeReferrer = false;
265         freeReferrer = referrals[i];
266         break;
267       }
268     }
269 
270     require(!noFreeReferrer, 'No Free Referrer');
271 
272     return freeReferrer;
273   }
274 
275   function viewUserReferral(address _user) public view returns(address[] memory) {
276     return users[_user].referral;
277   }
278 
279   function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
280     return users[_user].levelExpired[_level];
281   }
282 
283   function showMe() public view returns (bool, uint, uint) {
284     User storage user = users[msg.sender];
285     return (user.isExist, user.id, user.level);
286   }
287 
288   function levelData() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
289     return (
290       users[msg.sender].levelExpired[1],
291       users[msg.sender].levelExpired[2],
292       users[msg.sender].levelExpired[3],
293       users[msg.sender].levelExpired[4],
294       users[msg.sender].levelExpired[5],
295       users[msg.sender].levelExpired[6],
296       users[msg.sender].levelExpired[7],
297       users[msg.sender].levelExpired[8],
298       users[msg.sender].levelExpired[9],
299       users[msg.sender].levelExpired[10]
300     );
301   }
302 
303   function bytesToAddress(bytes memory bys) private pure returns (address addr) {
304     assembly {
305       addr := mload(add(bys, 20))
306     }
307   }
308 }