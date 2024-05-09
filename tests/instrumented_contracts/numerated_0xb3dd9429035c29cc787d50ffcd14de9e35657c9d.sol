1 pragma solidity  >= 0.6.3 < 0.7.0;
2 
3 contract EthernityMoney {
4 	address public creator;
5 	uint MAX_LEVEL = 9;
6 	uint REFERRALS_LIMIT = 2;
7 	uint LEVEL_EXPIRE_TIME = 111 days;
8 	uint LEVEL_HIGHER_FOUR_EXPIRE_TIME = 10000 days;
9 	mapping (address => User) public users;
10 	mapping (uint => address) public userAddresses;
11 	uint public last_uid;
12 	mapping (uint => uint) public levelPrice;
13 	mapping (uint => uint) public uplinesToRcvEth;
14 	mapping (address => ProfitsRcvd) public rcvdProfits;
15 	mapping (address => ProfitsGiven) public givenProfits;
16 	mapping (address => LostProfits) public lostProfits;
17 
18 	struct User {
19 		uint id;
20 		uint referrerID;
21 		address[] referrals;
22 		mapping (uint => uint) levelExpiresAt;
23 	}
24 
25 	struct ProfitsRcvd {
26 		uint uid;
27 		uint[] fromId;
28 		address[] fromAddr;
29 		uint[] amount;
30 	}
31 
32 	struct LostProfits {
33 		uint uid;
34 		uint[] toId;
35 		address[] toAddr;
36 		uint[] amount;
37 		uint[] level;
38 	}
39 
40 	struct ProfitsGiven {
41 		uint uid;
42 		uint[] toId;
43 		address[] toAddr;
44 		uint[] amount;
45 		uint[] level;
46 		uint[] line;
47 	}
48 
49 	modifier validLevelAmount(uint _level) {
50 		require(msg.value == levelPrice[_level], 'Invalid level amount sent');
51 		_;
52 	}
53 
54 	modifier userRegistered() {
55 		require(users[msg.sender].id != 0, 'User does not exist');
56 		_;
57 	}
58 
59 	modifier validReferrerID(uint _referrerID) {
60 		require(_referrerID > 0 && _referrerID <= last_uid, 'Invalid referrer ID');
61 		_;
62 	}
63 
64 	modifier userNotRegistered() {
65 		require(users[msg.sender].id == 0, 'User is already registered');
66 		_;
67 	}
68 
69 	modifier validLevel(uint _level) {
70 		require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level entered');
71 		_;
72 	}
73 
74 	event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
75 	event BuyLevelEvent(address indexed user, uint indexed level, uint time);
76 	event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
77 	event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
78 
79 	constructor() public {
80 		last_uid++;
81 		creator = msg.sender;
82 		levelPrice[1] = 0.30 ether;
83 		levelPrice[2] = 0.72 ether;
84 		levelPrice[3] = 1.96 ether;
85 		levelPrice[4] = 4.00 ether;
86 		levelPrice[5] = 8.10 ether;
87 		levelPrice[6] = 15.00 ether;
88 		levelPrice[7] = 20.90 ether;
89 		levelPrice[8] = 35.40 ether;
90 		levelPrice[9] = 50.70 ether;
91 		uplinesToRcvEth[1] = 5;
92 		uplinesToRcvEth[2] = 6;
93 		uplinesToRcvEth[3] = 7;
94 		uplinesToRcvEth[4] = 8;
95 		uplinesToRcvEth[5] = 9;
96 		uplinesToRcvEth[6] = 10;
97 		uplinesToRcvEth[7] = 11;
98 		uplinesToRcvEth[8] = 12;
99 		uplinesToRcvEth[9] = 13;
100 
101 		users[creator] = User({
102 			id: last_uid,
103 			referrerID: 0,
104 			referrals: new address[](0)
105 		});
106 		userAddresses[last_uid] = creator;
107 
108 		for (uint i = 1; i <= MAX_LEVEL; i++) {
109 			users[creator].levelExpiresAt[i] = 1 << 37;
110 		}
111 	}
112 
113 	function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1) {
114 		uint _level = 1;
115 
116 		if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
117 			_referrerID = users[findReferrer(userAddresses[_referrerID])].id;
118 		}
119 		last_uid++;
120 		users[msg.sender] = User({
121 			id: last_uid,
122 			referrerID: _referrerID,
123 			referrals: new address[](0)
124 		});
125 		userAddresses[last_uid] = msg.sender;
126 		users[msg.sender].levelExpiresAt[_level] = now + getLevelExpireTime(_level);
127 		users[userAddresses[_referrerID]].referrals.push(msg.sender);
128 
129 		transferLevelPayment(_level, msg.sender);
130 		emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
131 	}
132 
133 	function buyLevel(uint _level) public payable userRegistered() validLevel(_level) validLevelAmount(_level) {
134 		for (uint l = _level - 1; l > 0; l--) {
135 			require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy previous level first');
136 		}
137 
138 		if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
139 			users[msg.sender].levelExpiresAt[_level] = now + getLevelExpireTime(_level);
140 		} else {
141 			users[msg.sender].levelExpiresAt[_level] += getLevelExpireTime(_level);
142 		}
143 
144 		transferLevelPayment(_level, msg.sender);
145 		emit BuyLevelEvent(msg.sender, _level, now);
146 	}
147 
148 	function getLevelExpireTime(uint _level) public view returns (uint) {
149 		if (_level < 5) {
150 			return LEVEL_EXPIRE_TIME;
151 		} else {
152 			return LEVEL_HIGHER_FOUR_EXPIRE_TIME;
153 		}
154 	}
155 
156 	function findReferrer(address _user) public view returns (address) {
157 		if (users[_user].referrals.length < REFERRALS_LIMIT) {
158 			return _user;
159 		}
160 
161 		address[1632] memory referrals;
162 		referrals[0] = users[_user].referrals[0];
163 		referrals[1] = users[_user].referrals[1];
164 
165 		address referrer;
166 
167 		for (uint i = 0; i < 16382; i++) {
168 			if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
169 				referrer = referrals[i];
170 				break;
171 			}
172 
173 			if (i >= 8191) {
174 				continue;
175 			}
176 
177 			referrals[(i+1)*2] = users[referrals[i]].referrals[0];
178 			referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
179 		}
180 
181 		require(referrer != address(0), 'Referrer not found');
182 		return referrer;
183 	}
184 
185 	function transferLevelPayment(uint _level, address _user) internal {
186 		uint height = _level;
187 		address referrer = getUserUpline(_user, height);
188 
189 		if (referrer == address(0)) {
190 			referrer = creator; 
191 		}
192 
193 		uint uplines = uplinesToRcvEth[_level];
194 		bool chkLostProfit = false;
195 		address lostAddr;
196 		for (uint i = 1; i <= uplines; i++) {
197 			referrer = getUserUpline(_user, i);
198 
199 			if(chkLostProfit){
200 				lostProfits[lostAddr].uid = users[referrer].id;
201 				lostProfits[lostAddr].toId.push(users[referrer].id);
202 				lostProfits[lostAddr].toAddr.push(referrer);
203 				lostProfits[lostAddr].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
204 				lostProfits[lostAddr].level.push(getUserLevel(referrer));
205 				chkLostProfit = false;
206 
207 				emit LostLevelProfitEvent(referrer, msg.sender, _level, 0);
208 			}
209 
210 			if (referrer != address(0) && (users[_user].levelExpiresAt[_level] == 0 || getUserLevelExpiresAt(referrer, _level) < now)) {
211 				chkLostProfit = true;
212 				uplines++;
213 				lostAddr = referrer;
214 				continue;
215 			} else {
216 				chkLostProfit = false;
217 			}
218 
219 			if (referrer == address(0)) {
220 				referrer = creator; 
221 			}
222 
223 			if (address(uint160(referrer)).send( msg.value / uplinesToRcvEth[_level] )) {
224 				rcvdProfits[referrer].uid = users[referrer].id;
225 				rcvdProfits[referrer].fromId.push(users[msg.sender].id);
226 				rcvdProfits[referrer].fromAddr.push(msg.sender);
227 				rcvdProfits[referrer].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
228 
229 				givenProfits[msg.sender].uid = users[msg.sender].id;
230 				givenProfits[msg.sender].toId.push(users[referrer].id);
231 				givenProfits[msg.sender].toAddr.push(referrer);
232 				givenProfits[msg.sender].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
233 				givenProfits[msg.sender].level.push(getUserLevel(referrer));
234 				givenProfits[msg.sender].line.push(i);
235 
236 				emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
237 			}
238 		}
239 	}
240 
241 	function getUserUpline(address _user, uint height) public view returns (address) {
242 		if (height <= 0 || _user == address(0)) {
243 			return _user;
244 		}
245 
246 		return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
247 	}
248 
249 	function getUserReferrals(address _user) public view returns (address[] memory) {
250 		return users[_user].referrals;
251 	}
252 
253 	function getUserProfitsFromId(address _user) public view returns (uint[] memory) {
254 		return rcvdProfits[_user].fromId;
255 	}
256 
257 	function getUserProfitsFromAddr(address _user) public view returns (address[] memory) {
258 		return rcvdProfits[_user].fromAddr;
259 	}
260 
261 	function getUserProfitsAmount(address _user) public view returns (uint256[] memory) {
262 		return rcvdProfits[_user].amount;
263 	}
264 
265 	function getUserProfitsGivenToId(address _user) public view returns (uint[] memory) {
266 		return givenProfits[_user].toId;
267 	}
268 
269 	function getUserProfitsGivenToAddr(address _user) public view returns (address[] memory) {
270 		return givenProfits[_user].toAddr;
271 	}
272 
273 	function getUserProfitsGivenToAmount(address _user) public view returns (uint[] memory) {
274 		return givenProfits[_user].amount;
275 	}
276 
277 	function getUserProfitsGivenToLevel(address _user) public view returns (uint[] memory) {
278 		return givenProfits[_user].level;
279 	}
280 
281 	function getUserProfitsGivenToLine(address _user) public view returns (uint[] memory) {
282 		return givenProfits[_user].line;
283 	}
284 
285 	function getUserLostsToId(address _user) public view returns (uint[] memory) {
286 		return (lostProfits[_user].toId);
287 	}
288 
289 	function getUserLostsToAddr(address _user) public view returns (address[] memory) {
290 		return (lostProfits[_user].toAddr);
291 	}
292 
293 	function getUserLostsAmount(address _user) public view returns (uint[] memory) {
294 		return (lostProfits[_user].amount);
295 	}
296 
297 	function getUserLostsLevel(address _user) public view returns (uint[] memory) {
298 		return (lostProfits[_user].level);
299 	}
300 
301 	function getUserLevelExpiresAt(address _user, uint _level) public view returns (uint) {
302 		return users[_user].levelExpiresAt[_level];
303 	}
304 
305 	function getUserLevel (address _user) public view returns (uint) {
306 		if (getUserLevelExpiresAt(_user, 1) < now) {
307 			return (0);
308 		} else if (getUserLevelExpiresAt(_user, 2) < now) {
309 			return (1);
310 		} else if (getUserLevelExpiresAt(_user, 3) < now) {
311 			return (2);
312 		} else if (getUserLevelExpiresAt(_user, 4) < now) {
313 			return (3);
314 		} else if (getUserLevelExpiresAt(_user, 5) < now) {
315 			return (4);
316 		} else if (getUserLevelExpiresAt(_user, 6) < now) {
317 			return (5);
318 		} else if (getUserLevelExpiresAt(_user, 7) < now) {
319 			return (6);
320 		} else if (getUserLevelExpiresAt(_user, 8) < now) {
321 			return (7);
322 		} else if (getUserLevelExpiresAt(_user, 9) < now) {
323 			return (8);
324 		} else if (getUserLevelExpiresAt(_user, 10) < now) {
325 			return (9);
326 		}
327 	}
328 
329 	function getUserDetails (address _user) public view returns (uint, uint) {
330 		if (getUserLevelExpiresAt(_user, 1) < now) {
331 			return (1, users[_user].id);
332 		} else if (getUserLevelExpiresAt(_user, 2) < now) {
333 			return (2, users[_user].id);
334 		} else if (getUserLevelExpiresAt(_user, 3) < now) {
335 			return (3, users[_user].id);
336 		} else if (getUserLevelExpiresAt(_user, 4) < now) {
337 			return (4, users[_user].id);
338 		} else if (getUserLevelExpiresAt(_user, 5) < now) {
339 			return (5, users[_user].id);
340 		} else if (getUserLevelExpiresAt(_user, 6) < now) {
341 			return (6, users[_user].id);
342 		} else if (getUserLevelExpiresAt(_user, 7) < now) {
343 			return (7, users[_user].id);
344 		} else if (getUserLevelExpiresAt(_user, 8) < now) {
345 			return (8, users[_user].id);
346 		} else if (getUserLevelExpiresAt(_user, 9) < now) {
347 			return (9, users[_user].id);
348 		}
349 	}
350 
351 	receive() external payable {
352 		revert();
353 	}
354 }