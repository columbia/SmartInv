1 //
2 //                               __     __               __
3 //    _________ ___  ____ ______/ /_   / /__ _   _____  / /
4 //   / ___/ __ `__ \/ __ `/ ___/ __/  / / _ \ | / / _ \/ / 
5 //  (__  ) / / / / / /_/ / /  / /_   / /  __/ |/ /  __/ /  
6 // /____/_/ /_/ /_/\__,_/_/   \__/  /_/\___/|___/\___/_/   
7 //
8 //
9 // Telegram: @smartlvl
10 // hashtag: #smartlvl
11 
12 
13 pragma solidity ^0.5.11;
14 
15 contract Smartlevel {
16 	address public creator;
17 	uint public currentUserID;
18 
19 	mapping(uint => uint) public levelPrice;
20 	mapping(address => User) public users;
21 	mapping(uint => address) public userAddresses;
22 
23 	uint MAX_LEVEL = 10;
24 	uint REFERRALS_LIMIT = 3;
25 	uint LEVEL_DURATION = 15 days;
26 
27 	struct User {
28 		uint id;
29 		uint referrerID;
30 		address[] referrals;
31 		mapping (uint => uint) levelExpiresAt;
32 	}
33 
34 	event RegisterUserEvent(address indexed user, address indexed referrer, uint time, uint id, uint expires);
35 	event BuyLevelEvent(address indexed user, uint indexed level, uint time, uint expires);
36 	event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
37 	event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
38 
39 	modifier userNotRegistered() {
40 		require(users[msg.sender].id == 0, 'User is already registered');
41 		_;
42 	}
43 
44 	modifier userRegistered() {
45 		require(users[msg.sender].id != 0, 'User does not exist');
46 		_;
47 	}
48 
49 	modifier validReferrerID(uint _referrerID) {
50 		require(_referrerID > 0 && _referrerID <= currentUserID, 'Invalid referrer ID');
51 		_;
52 	}
53 
54 	modifier validLevel(uint _level) {
55 		require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level');
56 		_;
57 	}
58 
59 	modifier validLevelAmount(uint _level) {
60 		require(msg.value == levelPrice[_level], 'Invalid level amount');
61 		_;
62 	}
63 
64 	constructor() public {
65 		levelPrice[1] = 0.03 ether;
66 		levelPrice[2] = 0.09 ether;
67 		levelPrice[3] = 0.15 ether;
68 		levelPrice[4] = 0.3 ether;
69 		levelPrice[5] = 0.35 ether;
70 		levelPrice[6] = 0.6 ether;
71 		levelPrice[7] = 1 ether;
72 		levelPrice[8] = 2 ether;
73 		levelPrice[9] = 5 ether;
74 		levelPrice[10] = 10 ether;
75 
76 		currentUserID++;
77 
78 		creator = 0x91c59276d6f1360BEB35e7e5105FE6A0BD26df2c;
79 
80 		users[creator] = createNewUser(0);
81 		userAddresses[currentUserID] = creator;
82 
83 		for(uint i = 1; i <= MAX_LEVEL; i++) {
84 			users[creator].levelExpiresAt[i] = 113131641600;
85 		}
86 	}
87 
88 	function() external payable {
89 		uint level;
90 
91 		for(uint i = 1; i <= MAX_LEVEL; i++) {
92 			if(msg.value == levelPrice[i]) {
93 				level = i;
94 				break;
95 			}
96 		}
97 
98 		require(level > 0, 'Invalid amount has sent');
99 
100 		if(users[msg.sender].id != 0) {
101 			buyLevel(level);
102 			return;
103 		}
104 
105 		if(level != 1) {
106 			revert('Buy first level for 0.03 ETH');
107 		}
108 
109 		address referrer = bytesToAddress(msg.data);
110 		registerUser(users[referrer].id);
111 	}
112 	
113 	function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1) {
114 		if(users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
115 			_referrerID = users[findReferrer(userAddresses[_referrerID])].id;
116 		}
117 
118 		currentUserID++;
119 
120 		users[msg.sender] = createNewUser(_referrerID);
121 		userAddresses[currentUserID] = msg.sender;
122 		users[msg.sender].levelExpiresAt[1] = now + LEVEL_DURATION;
123 
124 		users[userAddresses[_referrerID]].referrals.push(msg.sender);
125 
126 		transferLevelPayment(1, msg.sender);
127 		emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now, currentUserID, users[msg.sender].levelExpiresAt[1]);
128 	}
129 
130 	function buyLevel(uint _level) public payable userRegistered() validLevel(_level) validLevelAmount(_level) {
131 		for(uint l = _level - 1; l > 0; l--) {
132 			require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy the previous level');
133 		}
134 
135 		if(getUserLevelExpiresAt(msg.sender, _level) < now) {
136 			users[msg.sender].levelExpiresAt[_level] = now + LEVEL_DURATION;
137 		} else {
138 			users[msg.sender].levelExpiresAt[_level] += LEVEL_DURATION;
139 		}
140 
141 		transferLevelPayment(_level, msg.sender);
142 		emit BuyLevelEvent(msg.sender, _level, now, users[msg.sender].levelExpiresAt[_level]);
143 	}
144 
145 	function findReferrer(address _user) public view returns(address) {
146 		if(users[_user].referrals.length < REFERRALS_LIMIT) {
147 			return _user;
148 		}
149 
150 		address[1200] memory referrals;
151 		referrals[0] = users[_user].referrals[0];
152 		referrals[1] = users[_user].referrals[1];
153 		referrals[2] = users[_user].referrals[2];
154 
155 		address referrer;
156 
157 		for(uint i = 0; i < 1200; i++) {
158 			if(users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
159 				referrer = referrals[i];
160 				break;
161 			}
162 
163 			if(i >= 400) {
164 				continue;
165 			}
166 
167 			referrals[(i + 1) * 3] = users[referrals[i]].referrals[0];
168 			referrals[(i + 1) * 3 + 1] = users[referrals[i]].referrals[1];
169 			referrals[(i + 1) * 3 + 2] = users[referrals[i]].referrals[2];
170 		}
171 
172 		require(referrer != address(0), 'Referrer was not found');
173 
174 		return referrer;
175 	}
176 
177 	function transferLevelPayment(uint _level, address _user) internal {
178 		uint height = _level % 2 == 0 ? 2 : 1;
179 		address referrer = getUserUpline(_user, height);
180 
181 		if(referrer == address(0)) {
182 			referrer = creator;
183 		}
184 
185 		if(getUserLevelExpiresAt(referrer, _level) < now) {
186 			emit LostLevelProfitEvent(referrer, msg.sender, _level, now);
187 			transferLevelPayment(_level, referrer);
188 			return;
189 		}
190 
191 		if(addressToPayable(referrer).send(msg.value)) {
192 			emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
193 		}
194 	}
195 
196 
197 	function getUserUpline(address _user, uint height) public view returns(address) {
198 		if(height <= 0 || _user == address(0)) {
199 			return _user;
200 		}
201 
202 		return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
203 	}
204 
205 	function getUserReferrals(address _user) public view returns(address[] memory) {
206 		return users[_user].referrals;
207 	}
208 
209 	function getUserLevelExpiresAt(address _user, uint _level) public view returns(uint) {
210 		return users[_user].levelExpiresAt[_level];
211 	}
212 
213 
214 	function createNewUser(uint _referrerID) private view returns(User memory) {
215 		return User({ id: currentUserID, referrerID: _referrerID, referrals: new address[](0) });
216 	}
217 
218 	function bytesToAddress(bytes memory _addr) private pure returns(address addr) {
219 		assembly {
220 			addr := mload(add(_addr, 20))
221 		}
222 	}
223 
224 	function addressToPayable(address _addr) private pure returns(address payable) {
225 		return address(uint160(_addr));
226 	}
227 }