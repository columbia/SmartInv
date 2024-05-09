1 pragma solidity ^0.4.25;
2 
3 //LIBRARIES
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9           return 0;
10         }
11         uint256 c = a * b;
12         require(c / a == b, "the SafeMath multiplication check failed");
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     	require(b > 0, "the SafeMath division check failed");
18         uint256 c = a / b;
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "the SafeMath subtraction check failed");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "the SafeMath addition check failed");
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34 	    require(b != 0, "the SafeMath modulo check failed");
35 	    return a % b;
36 	 }
37 }
38 
39 //CONTRACT INTERFACE
40 
41 contract OneHundredthMonkey {
42  	function adminWithdraw() public {}	
43 }
44 
45 //MAIN CONTRACT
46 
47 contract AdminBank {
48 
49 	using SafeMath for uint256;
50 
51 	//CONSTANTS
52 
53 	uint256 public fundsReceived;
54 	address public masterAdmin;
55 	address public mainContract;
56 	bool public mainContractSet = false;
57 
58 	address public teamMemberA = 0x2597afE84661669E590016E51f8FB0059D1Ad63e; 
59 	address public teamMemberB = 0x2E6C1b2B4F7307dc588c289C9150deEB1A66b73d; 
60 	address public teamMemberC = 0xB3CaC7157d772A7685824309Dc1eB79497839795; 
61 	address public teamMemberD = 0x87395d203B35834F79B46cd16313E6027AE4c9D4; 
62 	address public teamMemberE = 0x2c3e0d5cbb08e0892f16bf06c724ccce6a757b1c; 
63 	address public teamMemberF = 0xd68af19b51c41a69e121fb5fb4d77768711c4979; 
64 	address public teamMemberG = 0x8c992840Bc4BA758018106e4ea9E7a1d6F0F11e5; 
65 	address public teamMemberH = 0xd83FAf0D707616752c4AbA00f799566f45D4400A; 
66 	address public teamMemberI = 0xca4a41Fc611e62E3cAc10aB1FE9879faF5012687; 
67 
68 	uint256 public teamMemberArate = 20; //20%
69 	uint256 public teamMemberBrate = 20; //20%
70 	uint256 public teamMemberCrate = 15; //15%
71 	uint256 public teamMemberDrate = 15; //15%
72 	uint256 public teamMemberErate = 7; //7%
73 	uint256 public teamMemberFrate = 4; //4%
74 	uint256 public teamMemberGrate = 4; //4%
75 	uint256 public teamMemberHrate = 5; //5%
76 	uint256 public teamMemberIrate = 10; //10%
77 
78 	mapping (address => uint256) public teamMemberTotal;
79 	mapping (address => uint256) public teamMemberUnclaimed;
80 	mapping (address => uint256) public teamMemberClaimed;
81 	mapping (address => bool) public validTeamMember;
82 	mapping (address => bool) public isProposedAddress;
83 	mapping (address => bool) public isProposing;
84 	mapping (address => uint256) public proposingAddressIndex;
85 
86 	//CONSTRUCTOR
87 
88 	constructor() public {
89 		masterAdmin = msg.sender;
90 		validTeamMember[teamMemberA] = true;
91 		validTeamMember[teamMemberB] = true;
92 		validTeamMember[teamMemberC] = true;
93 		validTeamMember[teamMemberD] = true;
94 		validTeamMember[teamMemberE] = true;
95 		validTeamMember[teamMemberF] = true;
96 		validTeamMember[teamMemberG] = true;
97 		validTeamMember[teamMemberH] = true;
98 		validTeamMember[teamMemberI] = true;
99 	}
100 
101 	//MODIFIERS
102 	
103 	modifier isTeamMember() { 
104 		require (validTeamMember[msg.sender] == true, "you are not a team member"); 
105 		_; 
106 	}
107 
108 	modifier isMainContractSet() { 
109 		require (mainContractSet == true, "the main contract is not yet set"); 
110 		_; 
111 	}
112 
113 	modifier onlyHumans() { 
114         require (msg.sender == tx.origin, "no contracts allowed"); 
115         _; 
116     }
117 
118 	//EVENTS
119 	event fundsIn(
120 		uint256 _amount,
121 		address _sender,
122 		uint256 _totalFundsReceived
123 	);
124 
125 	event fundsOut(
126 		uint256 _amount,
127 		address _receiver
128 	);
129 
130 	event addressChangeProposed(
131 		address _old,
132 		address _new
133 	);
134 
135 	event addressChangeRemoved(
136 		address _old,
137 		address _new
138 	);
139 
140 	event addressChanged(
141 		address _old,
142 		address _new
143 	);
144 
145 	//FUNCTIONS
146 
147 	//add main contract address 
148 	function setContractAddress(address _address) external onlyHumans() {
149 		require (msg.sender == masterAdmin);
150 		require (mainContractSet == false);
151 		mainContract = _address;
152 		mainContractSet = true;
153 	}
154 
155 	//withdrawProxy
156 	function withdrawProxy() external isTeamMember() isMainContractSet() onlyHumans() {
157 		OneHundredthMonkey o = OneHundredthMonkey(mainContract);
158 		o.adminWithdraw();
159 	}
160 
161 	//team member withdraw
162 	function teamWithdraw() external isTeamMember() isMainContractSet() onlyHumans() {
163 	
164 		//set up for msg.sender
165 		address user;
166 		uint256 rate;
167 		if (msg.sender == teamMemberA) {
168 			user = teamMemberA;
169 			rate = teamMemberArate;
170 		} else if (msg.sender == teamMemberB) {
171 			user = teamMemberB;
172 			rate = teamMemberBrate;
173 		} else if (msg.sender == teamMemberC) {
174 			user = teamMemberC;
175 			rate = teamMemberCrate;
176 		} else if (msg.sender == teamMemberD) {
177 			user = teamMemberD;
178 			rate = teamMemberDrate;
179 		} else if (msg.sender == teamMemberE) {
180 			user = teamMemberE;
181 			rate = teamMemberErate;
182 		} else if (msg.sender == teamMemberF) {
183 			user = teamMemberF;
184 			rate = teamMemberFrate;
185 		} else if (msg.sender == teamMemberG) {
186 			user = teamMemberG;
187 			rate = teamMemberGrate;
188 		} else if (msg.sender == teamMemberH) {
189 			user = teamMemberH;
190 			rate = teamMemberHrate;
191 		} else if (msg.sender == teamMemberI) {
192 			user = teamMemberI;
193 			rate = teamMemberIrate;
194 		}
195 		
196 		//update accounting 
197 		uint256 teamMemberShare = fundsReceived.mul(rate).div(100);
198 		teamMemberTotal[user] = teamMemberShare;
199 		teamMemberUnclaimed[user] = teamMemberTotal[user].sub(teamMemberClaimed[user]);
200 		
201 		//safe transfer 
202 		uint256 toTransfer = teamMemberUnclaimed[user];
203 		teamMemberUnclaimed[user] = 0;
204 		teamMemberClaimed[user] = teamMemberTotal[user];
205 		user.transfer(toTransfer);
206 
207 		emit fundsOut(toTransfer, user);
208 	}
209 
210 	function proposeNewAddress(address _new) external isTeamMember() onlyHumans() {
211 		require (isProposedAddress[_new] == false, "this address cannot be proposed more than once");
212 		require (isProposing[msg.sender] == false, "you can only propose one address at a time");
213 
214 		isProposing[msg.sender] = true;
215 		isProposedAddress[_new] = true;
216 
217 		if (msg.sender == teamMemberA) {
218 			proposingAddressIndex[_new] = 0;
219 		} else if (msg.sender == teamMemberB) {
220 			proposingAddressIndex[_new] = 1;
221 		} else if (msg.sender == teamMemberC) {
222 			proposingAddressIndex[_new] = 2;
223 		} else if (msg.sender == teamMemberD) {
224 			proposingAddressIndex[_new] = 3;
225 		} else if (msg.sender == teamMemberE) {
226 			proposingAddressIndex[_new] = 4;
227 		} else if (msg.sender == teamMemberF) {
228 			proposingAddressIndex[_new] = 5;
229 		} else if (msg.sender == teamMemberG) {
230 			proposingAddressIndex[_new] = 6;
231 		} else if (msg.sender == teamMemberH) {
232 			proposingAddressIndex[_new] = 7;
233 		} else if (msg.sender == teamMemberI) {
234 			proposingAddressIndex[_new] = 8;
235 		}
236 
237 		emit addressChangeProposed(msg.sender, _new);
238 	}
239 
240 	function removeProposal(address _new) external isTeamMember() onlyHumans() {
241 		require (isProposedAddress[_new] == true, "this address must be proposed but not yet accepted");
242 		require (isProposing[msg.sender] == true, "your address must be actively proposing");
243 
244 		if (proposingAddressIndex[_new] == 0 && msg.sender == teamMemberA) {
245 			isProposedAddress[_new] = false;
246 			isProposing[msg.sender] = false;
247 		} else if (proposingAddressIndex[_new] == 1 && msg.sender == teamMemberB) {
248 			isProposedAddress[_new] = false;
249 			isProposing[msg.sender] = false;
250 		} else if (proposingAddressIndex[_new] == 2 && msg.sender == teamMemberC) {
251 			isProposedAddress[_new] = false;
252 			isProposing[msg.sender] = false;
253 		} else if (proposingAddressIndex[_new] == 3 && msg.sender == teamMemberD) {
254 			isProposedAddress[_new] = false;
255 			isProposing[msg.sender] = false;
256 		} else if (proposingAddressIndex[_new] == 4 && msg.sender == teamMemberE) {
257 			isProposedAddress[_new] = false;
258 			isProposing[msg.sender] = false;
259 		} else if (proposingAddressIndex[_new] == 5 && msg.sender == teamMemberF) {
260 			isProposedAddress[_new] = false;
261 			isProposing[msg.sender] = false;
262 		} else if (proposingAddressIndex[_new] == 6 && msg.sender == teamMemberG) {
263 			isProposedAddress[_new] = false;
264 			isProposing[msg.sender] = false;
265 		} else if (proposingAddressIndex[_new] == 7 && msg.sender == teamMemberH) {
266 			isProposedAddress[_new] = false;
267 			isProposing[msg.sender] = false;
268 		} else if (proposingAddressIndex[_new] == 8 && msg.sender == teamMemberI) {
269 			isProposedAddress[_new] = false;
270 			isProposing[msg.sender] = false;
271 		} 
272 
273 		emit addressChangeRemoved(msg.sender, _new);
274 	}
275 
276 	function acceptProposal() external onlyHumans() {
277 		require (isProposedAddress[msg.sender] == true, "your address must be proposed");
278 		
279 		if (proposingAddressIndex[msg.sender] == 0) {
280 			address old = teamMemberA;
281 			validTeamMember[old] = false;
282 			isProposing[old] = false;
283 			teamMemberA = msg.sender;
284 			validTeamMember[teamMemberA] = true;
285 		} else if (proposingAddressIndex[msg.sender] == 1) {
286 			old = teamMemberB;
287 			validTeamMember[old] = false;
288 			isProposing[old] = false;
289 			teamMemberB = msg.sender;
290 			validTeamMember[teamMemberB] = true;
291 		} else if (proposingAddressIndex[msg.sender] == 2) {
292 			old = teamMemberC;
293 			validTeamMember[old] = false;
294 			isProposing[old] = false;
295 			teamMemberC = msg.sender;
296 			validTeamMember[teamMemberC] = true;
297 		} else if (proposingAddressIndex[msg.sender] == 3) {
298 			old = teamMemberD;
299 			validTeamMember[old] = false;
300 			isProposing[old] = false;
301 			teamMemberD = msg.sender;
302 			validTeamMember[teamMemberD] = true;
303 		} else if (proposingAddressIndex[msg.sender] == 4) {
304 			old = teamMemberE;
305 			validTeamMember[old] = false;
306 			isProposing[old] = false;
307 			teamMemberE = msg.sender;
308 			validTeamMember[teamMemberE] = true;
309 		} else if (proposingAddressIndex[msg.sender] == 5) {
310 			old = teamMemberF;
311 			validTeamMember[old] = false;
312 			isProposing[old] = false;
313 			teamMemberF = msg.sender;
314 			validTeamMember[teamMemberF] = true;
315 		} else if (proposingAddressIndex[msg.sender] == 6) {
316 			old = teamMemberG;
317 			validTeamMember[old] = false;
318 			isProposing[old] = false;
319 			teamMemberG = msg.sender;
320 			validTeamMember[teamMemberG] = true;
321 		} else if (proposingAddressIndex[msg.sender] == 7) {
322 			old = teamMemberH;
323 			validTeamMember[old] = false;
324 			isProposing[old] = false;
325 			teamMemberH = msg.sender;
326 			validTeamMember[teamMemberH] = true;
327 		} else if (proposingAddressIndex[msg.sender] == 8) {
328 			old = teamMemberI;
329 			validTeamMember[old] = false;
330 			isProposing[old] = false;
331 			teamMemberI = msg.sender;
332 			validTeamMember[teamMemberI] = true;
333 		} 
334 
335 		isProposedAddress[msg.sender] = false;
336 
337 		emit addressChanged(old, msg.sender);
338 	}
339 
340 	//VIEW FUNCTIONS
341 
342 	function balanceOf(address _user) public view returns(uint256 _balance) {
343 		address user;
344 		uint256 rate;
345 		if (_user == teamMemberA) {
346 			user = teamMemberA;
347 			rate = teamMemberArate;
348 		} else if (_user == teamMemberB) {
349 			user = teamMemberB;
350 			rate = teamMemberBrate;
351 		} else if (_user == teamMemberC) {
352 			user = teamMemberC;
353 			rate = teamMemberCrate;
354 		} else if (_user == teamMemberD) {
355 			user = teamMemberD;
356 			rate = teamMemberDrate;
357 		} else if (_user == teamMemberE) {
358 			user = teamMemberE;
359 			rate = teamMemberErate;
360 		} else if (_user == teamMemberF) {
361 			user = teamMemberF;
362 			rate = teamMemberFrate;
363 		} else if (_user == teamMemberG) {
364 			user = teamMemberG;
365 			rate = teamMemberGrate;
366 		} else if (_user == teamMemberH) {
367 			user = teamMemberH;
368 			rate = teamMemberHrate;
369 		} else if (_user == teamMemberI) {
370 			user = teamMemberI;
371 			rate = teamMemberIrate;
372 		} else {
373 			return 0;
374 		}
375 
376 		uint256 teamMemberShare = fundsReceived.mul(rate).div(100);
377 		uint256 unclaimed = teamMemberShare.sub(teamMemberClaimed[_user]); 
378 
379 		return unclaimed;
380 	}
381 
382 	function contractBalance() public view returns(uint256 _contractBalance) {
383 	    return address(this).balance;
384 	}
385 
386 	//FALLBACK
387 
388 	function () public payable {
389 		fundsReceived += msg.value;
390 		emit fundsIn(msg.value, msg.sender, fundsReceived); 
391 	}
392 }