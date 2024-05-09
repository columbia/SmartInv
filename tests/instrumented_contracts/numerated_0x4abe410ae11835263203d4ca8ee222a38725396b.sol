1 /**
2  * Smartex
3  *
4  * Website: https://smartex.network
5  * Email: admin@smartex.network
6  */
7 
8 pragma solidity ^0.5.11;
9 
10 contract Smartex {
11   address public creator;
12   uint public currentUserID;
13 
14   mapping (uint => uint) public levelPrice;
15   mapping (address => User) public users;
16   mapping (uint => address) public userAddresses;
17 
18   uint MAX_LEVEL = 6;
19   uint REFERRALS_LIMIT = 2;
20   uint LEVEL_DURATION = 36 days;
21 
22   struct User {
23     uint id;
24     uint referrerID;
25     address[] referrals;
26     mapping (uint => uint) levelExpiresAt;
27   }
28 
29   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
30   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
31   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
32   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
33 
34   modifier userNotRegistered() {
35     require(users[msg.sender].id == 0, 'User is already registered');
36     _;
37   }
38 
39   modifier userRegistered() {
40     require(users[msg.sender].id != 0, 'User does not exist');
41     _;
42   }
43 
44   modifier validReferrerID(uint _referrerID) {
45     require(_referrerID > 0 && _referrerID <= currentUserID, 'Invalid referrer ID');
46     _;
47   }
48 
49   modifier validLevel(uint _level) {
50     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level');
51     _;
52   }
53 
54   modifier validLevelAmount(uint _level) {
55     require(msg.value == levelPrice[_level], 'Invalid level amount');
56     _;
57   }
58 
59   constructor() public {
60     levelPrice[1] = 0.5 ether;
61     levelPrice[2] = 1 ether;
62     levelPrice[3] = 2 ether;
63     levelPrice[4] = 4 ether;
64     levelPrice[5] = 8 ether;
65     levelPrice[6] = 16 ether;
66 
67     currentUserID++;
68 
69     creator = msg.sender;
70 
71     users[creator] = createNewUser(0);
72     userAddresses[currentUserID] = creator;
73 
74     for (uint i = 1; i <= MAX_LEVEL; i++) {
75       users[creator].levelExpiresAt[i] = 1 << 37;
76     }
77   }
78 
79   function () external payable {
80     uint level;
81 
82     for (uint i = 1; i <= MAX_LEVEL; i++) {
83       if (msg.value == levelPrice[i]) {
84         level = i;
85         break;
86       }
87     }
88 
89     require(level > 0, 'Invalid amount has sent');
90 
91     if (users[msg.sender].id != 0) {
92       buyLevel(level);
93       return;
94     }
95 
96     if (level != 1) {
97       revert('Buy first level for 0.5 ETH');
98     }
99 
100     address referrer = bytesToAddress(msg.data);
101     registerUser(users[referrer].id);
102   }
103 
104   function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1) {
105     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
106       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
107     }
108 
109     currentUserID++;
110 
111     users[msg.sender] = createNewUser(_referrerID);
112     userAddresses[currentUserID] = msg.sender;
113     users[msg.sender].levelExpiresAt[1] = now + LEVEL_DURATION;
114 
115     users[userAddresses[_referrerID]].referrals.push(msg.sender);
116 
117     transferLevelPayment(1, msg.sender);
118     emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
119   }
120 
121   function buyLevel(uint _level) public payable userRegistered() validLevel(_level) validLevelAmount(_level) {
122     for (uint l = _level - 1; l > 0; l--) {
123       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy the previous level');
124     }
125 
126     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
127       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_DURATION;
128     } else {
129       users[msg.sender].levelExpiresAt[_level] += LEVEL_DURATION;
130     }
131 
132     transferLevelPayment(_level, msg.sender);
133     emit BuyLevelEvent(msg.sender, _level, now);
134   }
135 
136   function findReferrer(address _user) public view returns (address) {
137     if (users[_user].referrals.length < REFERRALS_LIMIT) {
138       return _user;
139     }
140 
141     address[1024] memory referrals;
142     referrals[0] = users[_user].referrals[0];
143     referrals[1] = users[_user].referrals[1];
144 
145     address referrer;
146 
147     for (uint i = 0; i < 1024; i++) {
148       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
149         referrer = referrals[i];
150         break;
151       }
152 
153       if (i >= 512) {
154         continue;
155       }
156 
157       referrals[(i+1)*2] = users[referrals[i]].referrals[0];
158       referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
159     }
160 
161     require(referrer != address(0), 'Referrer was not found');
162 
163     return referrer;
164   }
165 
166   function transferLevelPayment(uint _level, address _user) internal {
167     uint height = _level > 3 ? _level - 3 : _level;
168     address referrer = getUserUpline(_user, height);
169 
170     if (referrer == address(0)) {
171       referrer = creator;
172     }
173 
174     if (getUserLevelExpiresAt(referrer, _level) < now) {
175       emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
176       transferLevelPayment(_level, referrer);
177       return;
178     }
179 
180     if (addressToPayable(referrer).send(msg.value)) {
181       emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
182     }
183   }
184 
185 
186   function getUserUpline(address _user, uint height) public view returns (address) {
187     if (height <= 0 || _user == address(0)) {
188       return _user;
189     }
190 
191     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
192   }
193 
194   function getUserReferrals(address _user) public view returns (address[] memory) {
195     return users[_user].referrals;
196   }
197 
198   function getUserLevelExpiresAt(address _user, uint _level) public view returns (uint) {
199     return users[_user].levelExpiresAt[_level];
200   }
201 
202 
203   function createNewUser(uint _referrerID) private view returns (User memory) {
204     return User({ id: currentUserID, referrerID: _referrerID, referrals: new address[](0) });
205   }
206 
207   function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
208     assembly {
209       addr := mload(add(_addr, 20))
210     }
211   }
212 
213   function addressToPayable(address _addr) private pure returns (address payable) {
214     return address(uint160(_addr));
215   }
216 }