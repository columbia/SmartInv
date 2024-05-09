1 /**
2  * CryptoWeek
3  */
4 
5 pragma solidity ^0.5.11;
6 
7 contract CryptoWeek {
8   address public creator;
9   uint public currentUserID;
10 
11   mapping (uint => uint) public levelPrice;
12   mapping (address => User) public users;
13   mapping (uint => address) public userAddresses;
14 
15   uint MAX_LEVEL = 3;
16   uint REFERRALS_LIMIT = 2;
17   uint LEVEL_DURATION = 15 days;
18 
19   struct User {
20     uint id;
21     uint referrerID;
22     address[] referrals;
23     mapping (uint => uint) levelExpiresAt;
24   }
25 
26   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
27   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
28   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
29   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
30 
31   modifier userNotRegistered() {
32     require(users[msg.sender].id == 0, 'User is already registered');
33     _;
34   }
35 
36   modifier userRegistered() {
37     require(users[msg.sender].id != 0, 'User does not exist');
38     _;
39   }
40 
41   modifier validReferrerID(uint _referrerID) {
42     require(_referrerID > 0 && _referrerID <= currentUserID, 'Invalid referrer ID');
43     _;
44   }
45 
46   modifier validLevel(uint _level) {
47     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level');
48     _;
49   }
50 
51   modifier validLevelAmount(uint _level) {
52     require(msg.value == levelPrice[_level], 'Invalid level amount');
53     _;
54   }
55 
56   constructor() public {
57     levelPrice[1] = 0.1 ether;
58     levelPrice[2] = 0.15 ether;
59     levelPrice[3] = 0.3 ether;
60 
61     currentUserID++;
62 
63     creator = msg.sender;
64 
65     users[creator] = createNewUser(0);
66     userAddresses[currentUserID] = creator;
67 
68     for (uint i = 1; i <= MAX_LEVEL; i++) {
69       users[creator].levelExpiresAt[i] = 1 << 37;
70     }
71   }
72 
73   function () external payable {
74     uint level;
75 
76     for (uint i = 1; i <= MAX_LEVEL; i++) {
77       if (msg.value == levelPrice[i]) {
78         level = i;
79         break;
80       }
81     }
82 
83     require(level > 0, 'Invalid amount has sent');
84 
85     if (users[msg.sender].id != 0) {
86       buyLevel(level);
87       return;
88     }
89 
90     if (level != 1) {
91       revert('Buy first level for 0.1 ETH');
92     }
93 
94     address referrer = bytesToAddress(msg.data);
95     registerUser(users[referrer].id);
96   }
97 
98   function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1) {
99     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
100       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
101     }
102 
103     currentUserID++;
104 
105     users[msg.sender] = createNewUser(_referrerID);
106     userAddresses[currentUserID] = msg.sender;
107     users[msg.sender].levelExpiresAt[1] = now + LEVEL_DURATION;
108 
109     users[userAddresses[_referrerID]].referrals.push(msg.sender);
110 
111     transferLevelPayment(1, msg.sender);
112     emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
113   }
114 
115   function buyLevel(uint _level) public payable userRegistered() validLevel(_level) validLevelAmount(_level) {
116     for (uint l = _level - 1; l > 0; l--) {
117       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy the previous level');
118     }
119 
120     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
121       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_DURATION;
122     } else {
123       users[msg.sender].levelExpiresAt[_level] += LEVEL_DURATION;
124     }
125 
126     transferLevelPayment(_level, msg.sender);
127     emit BuyLevelEvent(msg.sender, _level, now);
128   }
129 
130   function findReferrer(address _user) public view returns (address) {
131     if (users[_user].referrals.length < REFERRALS_LIMIT) {
132       return _user;
133     }
134 
135     address[1024] memory referrals;
136     referrals[0] = users[_user].referrals[0];
137     referrals[1] = users[_user].referrals[1];
138 
139     address referrer;
140 
141     for (uint i = 0; i < 1024; i++) {
142       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
143         referrer = referrals[i];
144         break;
145       }
146 
147       if (i >= 512) {
148         continue;
149       }
150 
151       referrals[(i+1)*2] = users[referrals[i]].referrals[0];
152       referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
153     }
154 
155     require(referrer != address(0), 'Referrer was not found');
156 
157     return referrer;
158   }
159 
160   function transferLevelPayment(uint _level, address _user) internal {
161     uint height = _level;
162     address referrer = getUserUpline(_user, height);
163 
164     if (referrer == address(0)) {
165       referrer = creator;
166     }
167 
168     if (getUserLevelExpiresAt(referrer, _level) < now) {
169       emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
170       transferLevelPayment(_level, referrer);
171       return;
172     }
173 
174     if (addressToPayable(referrer).send(msg.value)) {
175       emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
176     }
177   }
178 
179 
180   function getUserUpline(address _user, uint height) public view returns (address) {
181     if (height <= 0 || _user == address(0)) {
182       return _user;
183     }
184 
185     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
186   }
187 
188   function getUserReferrals(address _user) public view returns (address[] memory) {
189     return users[_user].referrals;
190   }
191 
192   function getUserLevelExpiresAt(address _user, uint _level) public view returns (uint) {
193     return users[_user].levelExpiresAt[_level];
194   }
195 
196 
197   function createNewUser(uint _referrerID) private view returns (User memory) {
198     return User({ id: currentUserID, referrerID: _referrerID, referrals: new address[](0) });
199   }
200 
201   function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
202     assembly {
203       addr := mload(add(_addr, 20))
204     }
205   }
206 
207   function addressToPayable(address _addr) private pure returns (address payable) {
208     return address(uint160(_addr));
209   }
210 }