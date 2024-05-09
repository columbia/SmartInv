1 /**
2  *  
3  *  __                      _   __    __                               
4  * / _\_ __ ___   __ _ _ __| |_/ / /\ \ \__ _ _   _   _ __ _   _ _ __  
5  * \ \| '_ ` _ \ / _` | '__| __\ \/  \/ / _` | | | | | '__| | | | '_ \ 
6  * _\ \ | | | | | (_| | |  | |_ \  /\  / (_| | |_| |_| |  | |_| | | | |
7  * \__/_| |_| |_|\__,_|_|   \__| \/  \/ \__,_|\__, (_)_|   \__,_|_| |_|
8  *                                            |___/                    
9  * Version 2.3
10  * https://smartway.run/
11  * 
12 **/
13 
14 pragma solidity 0.5.15;
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
25     bool public sync = false;
26 
27     uint8 public constant REFERRER_1_LEVEL_LIMIT = 2;
28     uint64 public constant PERIOD_LENGTH = 30 days;
29 
30     address payable public ownerWallet;
31     uint64 public lastUserId;
32     
33     mapping(uint8 => uint) public levelPrice;
34     mapping(uint => uint8) public priceLevel;
35     
36     mapping(address => User) public users;
37     mapping(uint64 => address payable) public userList;
38     
39     event Registration(address indexed user, address referrer);
40     event LevelBought(address indexed user, uint8 level);
41     event GetMoneyForLevel(address indexed user, address indexed referral, uint8 level);
42     event SendMoneyError(address indexed user, address indexed referral, uint8 level);
43     event LostMoneyForLevel(address indexed user, address indexed referral, uint8 level);
44 
45     constructor(address payable owner) public {
46         _initData();
47         ownerWallet = msg.sender;
48         
49         lastUserId++;
50         
51         userList[lastUserId] = owner;
52         users[owner].id = lastUserId;
53         
54         for(uint8 i = 1; i <= 12; i++) {
55             users[owner].levelExpired[i] = 77777777777;
56         }
57     }
58 
59     function () external payable {
60         uint8 level = priceLevel[msg.value];
61         require(level != 0, 'Incorrect value sent');
62         
63         if(users[msg.sender].id != 0)
64             return buyLevel(level);
65         
66         require(level == 1, 'Please buy level 1 for 0.2 ETH');
67         
68         address referrer = bytesToAddress(msg.data);
69 
70         require(referrer != address(0), 'must be a referrer in extra data');
71         regUser(users[referrer].id);
72     }
73 
74     function regUser(uint64 referrerId) public payable {
75         require(sync, 'Initialize not finished');
76         require(users[msg.sender].id == 0, 'User exist');
77         require(referrerId > 0 && referrerId <= lastUserId, 'Incorrect referrer Id');
78         require(msg.value == levelPrice[1], 'Incorrect Value');
79 
80         if(users[userList[referrerId]].referrals.length >= REFERRER_1_LEVEL_LIMIT) {
81             address freeReferrer = findFreeReferrer(userList[referrerId]);
82             referrerId = users[freeReferrer].id;
83         }
84             
85         lastUserId++;
86 
87         users[msg.sender] = User({
88             id: lastUserId,
89             referrerId: referrerId,
90             referrals: new address payable[](0) 
91         });
92         
93         userList[lastUserId] = msg.sender;
94 
95         users[msg.sender].levelExpired[1] = uint64(now + PERIOD_LENGTH);
96 
97         users[userList[referrerId]].referrals.push(msg.sender);
98 
99         payForLevel(1, msg.sender);
100 
101         emit Registration(msg.sender, userList[referrerId]);
102     }
103 
104     function buyLevel(uint8 level) public payable {
105         require(users[msg.sender].id != 0, 'User is not exists'); 
106         require(level > 0 && level <= 12, 'Incorrect level');
107         require(msg.value == levelPrice[level], 'Incorrect Value');
108     
109         
110         for(uint8 i = level - 1; i > 0; i--) {
111             require(users[msg.sender].levelExpired[i] >= now, 'Buy the previous level');
112         }
113         
114         if(users[msg.sender].levelExpired[level] == 0 || users[msg.sender].levelExpired[level] < now) {
115             users[msg.sender].levelExpired[level] = uint64(now + PERIOD_LENGTH);
116         } else {
117             users[msg.sender].levelExpired[level] += PERIOD_LENGTH;
118         }
119         
120         payForLevel(level, msg.sender);
121 
122         emit LevelBought(msg.sender, level);
123     }
124     
125 
126     function payForLevel(uint8 level, address user) private {
127         address payable referrer;
128 
129         if (level%2 == 0) {
130             referrer = userList[users[userList[users[user].referrerId]].referrerId]; //extra variable will decrease aroud 50 recursion levels
131         } else {
132             referrer = userList[users[user].referrerId];
133         }
134 
135         if(users[referrer].id == 0) {
136             referrer = userList[1];
137         } 
138 
139         if(users[referrer].levelExpired[level] >= now) {
140             if (referrer.send(levelPrice[level])) {
141                 emit GetMoneyForLevel(referrer, msg.sender, level);
142             } else {
143                 emit SendMoneyError(referrer, msg.sender, level);
144             }
145         } else {
146             emit LostMoneyForLevel(referrer, msg.sender, level);
147 
148             payForLevel(level, referrer);
149         }
150     }
151 
152     function _initData() private {
153         levelPrice[1] = 0.2 ether;
154         levelPrice[2] = 0.22 ether;
155         levelPrice[3] = 0.4 ether;
156         levelPrice[4] = 0.44 ether;
157         levelPrice[5] = 0.7 ether;
158         levelPrice[6] = 0.77 ether;
159         levelPrice[7] = 1.2 ether;
160         levelPrice[8] = 1.3 ether;
161         levelPrice[9] = 2 ether;
162         levelPrice[10] = 2.2 ether;
163         levelPrice[11] = 3 ether;
164         levelPrice[12] = 3.3 ether;
165 
166         priceLevel[0.2 ether] = 1;
167         priceLevel[0.22 ether] = 2;
168         priceLevel[0.4 ether] = 3;
169         priceLevel[0.44 ether] = 4;
170         priceLevel[0.7 ether] = 5;
171         priceLevel[0.77 ether] = 6;
172         priceLevel[1.2 ether] = 7;
173         priceLevel[1.3 ether] = 8;
174         priceLevel[2 ether] = 9;
175         priceLevel[2.2 ether] = 10;
176         priceLevel[3 ether] = 11;
177         priceLevel[3.3 ether] = 12;
178     }
179 
180     function findFreeReferrer(address _user) public view returns(address) {
181         if(users[_user].referrals.length < REFERRER_1_LEVEL_LIMIT) 
182             return _user;
183 
184         address[] memory referrals = new address[](256);
185         address[] memory referralsBuf = new address[](256);
186 
187         referrals[0] = users[_user].referrals[0];
188         referrals[1] = users[_user].referrals[1];
189 
190         uint32 j = 2;
191         
192         while(true) {
193             for(uint32 i = 0; i < j; i++) {
194                 if(users[referrals[i]].referrals.length < 1) {
195                     return referrals[i];
196                 }
197             }
198             
199             for(uint32 i = 0; i < j; i++) {
200                 if (users[referrals[i]].referrals.length < REFERRER_1_LEVEL_LIMIT) {
201                     return referrals[i];
202                 }
203             }
204 
205             for(uint32 i = 0; i < j; i++) {
206                 referralsBuf[i] = users[referrals[i]].referrals[0];
207                 referralsBuf[j+i] = users[referrals[i]].referrals[1];
208             }
209 
210             j = j*2;
211 
212             for(uint32 i = 0; i < j; i++) {
213                 referrals[i] = referralsBuf[i];
214             }
215         }
216     }
217     
218     function recoveryUsers(address payable[] calldata _users, uint64[] calldata _referrerIds) external {
219         require(!sync, 'Initialize already closed');
220         require(msg.sender == ownerWallet, 'Access denied');
221         
222         for(uint64 i = 0; i < _users.length; i++) {
223             userList[lastUserId+i+1] = _users[i];
224             users[_users[i]].id = lastUserId+i+1;
225             users[_users[i]].referrerId = _referrerIds[i];
226             
227             users[userList[_referrerIds[i]]].referrals.push(_users[i]);
228         }
229         
230         lastUserId += uint64(_users.length);
231     }
232     
233     function recoveryLevel(uint8 _level, address payable[] calldata _users, uint64[] calldata _timestamps) external {
234         require(!sync, 'Initialize already closed');
235         require(msg.sender == ownerWallet, 'Access denied');
236         
237         for(uint64 i = 0; i < _users.length; i++) {
238             users[_users[i]].levelExpired[_level] = _timestamps[i];
239         }
240     }
241 
242     function syncClose() external {
243         require(!sync, 'Initialize already closed');
244         require(msg.sender == ownerWallet, 'Access denied');
245 
246         sync = true;
247     }
248 
249     function viewUserReferral(address user) public view returns(address payable[] memory) {
250         return users[user].referrals;
251     }
252 
253     function viewUserLevelExpired(address user, uint8 level) public view returns(uint) {
254         return users[user].levelExpired[level];
255     }
256 
257     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
258         assembly {
259             addr := mload(add(bys, 20))
260         }
261     }
262 }