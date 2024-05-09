1 pragma solidity ^0.5.0;
2 
3 interface ICustodian {
4 	function users(uint) external returns(address);
5 	function totalUsers() external returns (uint);
6 	function totalSupplyA() external returns (uint);
7 	function totalSupplyB() external returns (uint);
8 	function balanceOf(uint, address) external returns (uint);
9 	function allowance(uint, address, address) external returns (uint);
10 	function transfer(uint, address, address, uint) external returns (bool);
11 	function transferFrom(uint, address, address, address, uint) external returns (bool);
12 	function approve(uint, address, address, uint) external returns (bool);
13 }
14 
15 /// @title Esplanade - coordinate multiple custodians, oracles and other contracts.
16 /// @author duo.network
17 contract Esplanade {
18 
19 	/*
20      * Constants
21      */
22 	uint constant WEI_DENOMINATOR = 1000000000000000000;
23 	uint constant BP_DENOMINATOR = 10000;
24 	uint constant MIN_POOL_SIZE = 5;
25 	uint constant VOTE_TIME_OUT = 2 hours;
26 	uint constant COLD_POOL_IDX = 0;
27 	uint constant HOT_POOL_IDX = 1;
28 	uint constant NEW_STATUS = 0;
29 	uint constant IN_COLD_POOL_STATUS = 1;
30 	uint constant IN_HOT_POOL_STATUS = 2;
31 	uint constant USED_STATUS = 3;
32 	enum VotingStage {
33         NotStarted,
34 		Moderator,
35 		Contract
36     }
37 	/*
38      * Storage
39      */
40 	VotingStage public votingStage;
41 	address public moderator;
42 	// 0 is cold
43 	// 1 is hot
44 	address [][] public addrPool =[   
45 		[
46 			0xAc31E7Bc5F730E460C6B2b50617F421050265ece,
47             0x39426997B2B5f0c8cad0C6e571a2c02A6510d67b,
48             0x292B0E0060adBa58cCA9148029a79D5496950c9D,
49             0x835B8D6b7b62240000491f7f0B319204BD5dDB25,
50             0x8E0E4DE505ee21ECA63fAF762B48D774E8BB8f51,
51             0x8750A35A4FB67EE5dE3c02ec35d5eA59193034f5,
52             0x8849eD77E94B075D89bB67D8ef98D80A8761d913,
53             0x2454Da2d95FBA41C3a901D8ce69D0fdC8dA8274e,
54             0x56F08EE15a4CBB8d35F82a44d288D08F8b924c8b
55 		],
56 		[
57             0x709494F5766a7e280A24cF15e7feBA9fbadBe7F5,
58             0xF7029296a1dA0388b0b637127F241DD11901f2af,
59             0xE266581CDe8468915D9c9F42Be3DcEd51db000E0,
60             0x37c521F852dbeFf9eC93991fFcE91b2b836Ad549,
61             0x2fEF2469937EeA7B126bC888D8e02d762D8c7e16,
62             0x249c1daD9c31475739fBF08C95C2DCB137135957,
63             0x8442Dda926BFb4Aeba526D4d1e8448c762cf4A0c,
64             0xe71DA90BC3cb2dBa52bacfBbA7b973260AAAFc05,
65             0xd3FA38302b0458Bf4E1405D209F30db891eBE038
66 		]
67 	];
68 	// 0 is new address
69 	// 1 in cold pool
70 	// 2 in hot pool
71 	// 3 is used
72 	mapping(address => uint) public addrStatus; 
73 	address[] public custodianPool;
74 	mapping(address => bool) public existingCustodians;
75 	address[] public otherContractPool;
76 	mapping(address => bool) public existingOtherContracts;
77 	uint public operatorCoolDown = 1 hours;
78 	uint public lastOperationTime;
79 	bool public started;
80 
81 	address public candidate;
82 	mapping(address => bool) public passedContract;
83 	mapping(address => bool) public voted;
84 	uint public votedFor;
85 	uint public votedAgainst;
86 	uint public voteStartTimestamp;
87 
88 	/*
89      *  Modifiers
90      */
91 	modifier only(address addr) {
92 		require(msg.sender == addr);
93 		_;
94 	}
95 
96 	modifier inColdAddrPool() {
97 		require(addrStatus[msg.sender] == IN_COLD_POOL_STATUS);
98 		_;
99 	}
100 
101 	modifier inHotAddrPool() {
102 		require(addrStatus[msg.sender] == IN_HOT_POOL_STATUS);
103 		_;
104 	}
105 
106 	modifier isValidRequestor(address origin) {
107 		address requestorAddr = msg.sender;
108 		require((existingCustodians[requestorAddr] 
109 		|| existingOtherContracts[requestorAddr]) 
110 		&& addrStatus[origin] == IN_COLD_POOL_STATUS);
111 		_;
112 	}
113 
114 	modifier inUpdateWindow() {
115 		uint currentTime = getNowTimestamp();
116 		if (started)
117 			require(currentTime - lastOperationTime >= operatorCoolDown);
118 		_;
119 		lastOperationTime = currentTime;
120 	}
121 
122 	modifier inVotingStage(VotingStage _stage) {
123 		require(votingStage == _stage);
124 		_;
125 	}
126 
127 	modifier allowedToVote() {
128 		address voterAddr = msg.sender;
129 		require(!voted[voterAddr] && addrStatus[voterAddr] == 1);
130 		_;
131 	}
132 
133 	/*
134      *  Events
135      */
136 	event AddAddress(uint poolIndex, address added1, address added2);
137 	event RemoveAddress(uint poolIndex, address addr);
138 	event ProvideAddress(uint poolIndex, address requestor, address origin, address addr);
139 	event AddCustodian(address newCustodianAddr);
140 	event AddOtherContract(address newContractAddr);
141 	event StartContractVoting(address proposer, address newContractAddr);
142 	event TerminateContractVoting(address terminator, address currentCandidate);
143 	event StartModeratorVoting(address proposer);
144 	event TerminateByTimeOut(address candidate);
145 	event Vote(address voter, address candidate, bool voteFor, uint votedFor, uint votedAgainst);
146 	event CompleteVoting(bool isContractVoting, address newAddress);
147 	event ReplaceModerator(address oldModerator, address newModerator);
148 
149 	/*
150      * Constructor
151      */
152 	/// @dev Contract constructor sets operation cool down and set address pool status.
153 	/// @param optCoolDown operation cool down time.
154 	constructor(uint optCoolDown) public 
155 	{	
156 		votingStage = VotingStage.NotStarted;
157 		moderator = msg.sender;
158 		addrStatus[moderator] = USED_STATUS;
159 		for (uint i = 0; i < addrPool[COLD_POOL_IDX].length; i++) 
160 			addrStatus[addrPool[COLD_POOL_IDX][i]] = IN_COLD_POOL_STATUS;
161 		for (uint j = 0; j < addrPool[HOT_POOL_IDX].length; j++) 
162 			addrStatus[addrPool[HOT_POOL_IDX][j]] = IN_HOT_POOL_STATUS;
163 		operatorCoolDown = optCoolDown;
164 	}
165 
166 	/*
167      * MultiSig Management
168      */
169 	/// @dev proposeNewManagerContract function.
170 	/// @param addr new manager contract address proposed.
171 	function startContractVoting(address addr) 
172 		public 
173 		only(moderator) 
174 		inVotingStage(VotingStage.NotStarted) 
175 	returns (bool) {
176 		require(addrStatus[addr] == NEW_STATUS);
177 		candidate = addr;
178 		addrStatus[addr] = USED_STATUS;
179 		votingStage = VotingStage.Contract;
180 		replaceModerator();
181 		startVoting();
182 		emit StartContractVoting(moderator, addr);
183 		return true;
184 	}
185 
186 	/// @dev terminateVoting function.
187 	function terminateContractVoting() 
188 		public 
189 		only(moderator) 
190 		inVotingStage(VotingStage.Contract) 
191 	returns (bool) {
192 		votingStage = VotingStage.NotStarted;
193 		emit TerminateContractVoting(moderator, candidate);
194 		replaceModerator();
195 		return true;
196 	}
197 
198 	/// @dev terminateVoting voting if timeout
199 	function terminateByTimeout() public returns (bool) {
200 		require(votingStage != VotingStage.NotStarted);
201 		uint nowTimestamp = getNowTimestamp();
202 		if (nowTimestamp > voteStartTimestamp && nowTimestamp - voteStartTimestamp > VOTE_TIME_OUT) {
203 			votingStage = VotingStage.NotStarted;
204 			emit TerminateByTimeOut(candidate);
205 			return true;
206 		} else
207 			return false;
208 	}
209 
210 	/// @dev proposeNewModerator function.
211 	function startModeratorVoting() public inColdAddrPool() returns (bool) {
212 		candidate = msg.sender;
213 		votingStage = VotingStage.Moderator;
214 		removeFromPoolByAddr(COLD_POOL_IDX, candidate);
215 		startVoting();
216 		emit StartModeratorVoting(candidate);
217 		return true;
218 	}
219 
220 	/// @dev proposeNewModerator function.
221 	function vote(bool voteFor) 
222 		public 
223 		allowedToVote() 
224 	returns (bool) {
225 		address voter = msg.sender;
226 		if (voteFor)
227 			votedFor = votedFor + 1;
228 		else
229 			votedAgainst += 1;
230 		voted[voter] = true;
231 		uint threshold = addrPool[COLD_POOL_IDX].length / 2;
232 		emit Vote(voter, candidate, voteFor, votedFor, votedAgainst);
233 		if (votedFor > threshold || votedAgainst > threshold) {
234 			if (votingStage == VotingStage.Contract) {
235 				passedContract[candidate] = true;
236 				emit CompleteVoting(true, candidate);
237 			}
238 			else {
239 				emit CompleteVoting(false, candidate);
240 				moderator = candidate;
241 			}
242 			votingStage = VotingStage.NotStarted;
243 		}
244 		return true;
245 	}
246 
247 	/*
248      * Moderator Public functions
249      */
250 	/// @dev start roleManagerContract.
251 	function startManager() public only(moderator) returns (bool) {
252 		require(!started && custodianPool.length > 0);
253 		started = true;
254 		return true;
255 	}
256 
257 	/// @dev addCustodian function.
258 	/// @param custodianAddr custodian address to add.
259 	function addCustodian(address custodianAddr) 
260 		public 
261 		only(moderator) 
262 		inUpdateWindow() 
263 	returns (bool success) {
264 		require(!existingCustodians[custodianAddr] && !existingOtherContracts[custodianAddr]);
265 		ICustodian custodian = ICustodian(custodianAddr);
266 		require(custodian.totalUsers() >= 0);
267 		// custodian.users(0);
268 		uint custodianLength = custodianPool.length;
269 		if (custodianLength > 0) 
270 			replaceModerator();
271 		else if (!started) {
272 			uint index = getNextAddrIndex(COLD_POOL_IDX, custodianAddr);
273 			address oldModerator = moderator;
274 			moderator = addrPool[COLD_POOL_IDX][index];
275 			emit ReplaceModerator(oldModerator, moderator);
276 			removeFromPool(COLD_POOL_IDX, index);
277 		}
278 		existingCustodians[custodianAddr] = true;
279 		custodianPool.push(custodianAddr);
280 		addrStatus[custodianAddr] = USED_STATUS;
281 		emit AddCustodian(custodianAddr);
282 		return true;
283 	}
284 
285 	/// @dev addOtherContracts function.
286 	/// @param contractAddr other contract address to add.
287 	function addOtherContracts(address contractAddr) 
288 		public 
289 		only(moderator) 
290 		inUpdateWindow() 
291 	returns (bool success) {
292 		require(!existingCustodians[contractAddr] && !existingOtherContracts[contractAddr]);		
293 		existingOtherContracts[contractAddr] = true;
294 		otherContractPool.push(contractAddr);
295 		addrStatus[contractAddr] = USED_STATUS;
296 		replaceModerator();
297 		emit AddOtherContract(contractAddr);
298 		return true;
299 	}
300 
301 	/// @dev add two addreess into pool function.
302 	/// @param addr1 the first address
303 	/// @param addr2 the second address.
304 	/// @param poolIndex indicate adding to hot or cold.
305 	function addAddress(address addr1, address addr2, uint poolIndex) 
306 		public 
307 		only(moderator) 
308 		inUpdateWindow() 
309 	returns (bool success) {
310 		require(addrStatus[addr1] == NEW_STATUS 
311 			&& addrStatus[addr2] == NEW_STATUS 
312 			&& addr1 != addr2 
313 			&& poolIndex < 2);
314 		replaceModerator();
315 		addrPool[poolIndex].push(addr1);
316 		addrStatus[addr1] = poolIndex + 1;
317 		addrPool[poolIndex].push(addr2);
318 		addrStatus[addr2] = poolIndex + 1;
319 		emit AddAddress(poolIndex, addr1, addr2);
320 		return true;
321 	}
322 
323 	/// @dev removeAddress function.
324 	/// @param addr the address to remove from
325 	/// @param poolIndex the pool to remove from.
326 	function removeAddress(address addr, uint poolIndex) 
327 		public 
328 		only(moderator) 
329 		inUpdateWindow() 
330 	returns (bool success) {
331 		require(addrPool[poolIndex].length > MIN_POOL_SIZE 
332 			&& addrStatus[addr] == poolIndex + 1 
333 			&& poolIndex < 2);
334 		removeFromPoolByAddr(poolIndex, addr);
335 		replaceModerator();
336 		emit RemoveAddress(poolIndex, addr);
337 		return true;
338 	}
339 
340 	/// @dev provide address to other contracts, such as custodian, oracle and others.
341 	/// @param origin the origin who makes request
342 	/// @param poolIndex the pool to request address from.
343 	function provideAddress(address origin, uint poolIndex) 
344 		public 
345 		isValidRequestor(origin) 
346 		inUpdateWindow() 
347 	returns (address) {
348 		require(addrPool[poolIndex].length > MIN_POOL_SIZE 
349 			&& poolIndex < 2 
350 			&& custodianPool.length > 0);
351 		removeFromPoolByAddr(COLD_POOL_IDX, origin);
352 		address requestor = msg.sender;
353 		uint index = 0;
354 		// is custodian
355 		if (existingCustodians[requestor])
356 			index = getNextAddrIndex(poolIndex, requestor);
357 		else // is other contract;
358 			index = getNextAddrIndex(poolIndex, custodianPool[custodianPool.length - 1]);
359 		address addr = addrPool[poolIndex][index];
360 		removeFromPool(poolIndex, index);
361 
362 		emit ProvideAddress(poolIndex, requestor, origin, addr);
363 		return addr;
364 	}
365 
366 	/*
367      * Internal functions
368      */
369 	 
370 	function startVoting() internal {
371 		address[] memory coldPool = addrPool[COLD_POOL_IDX];
372 		for (uint i = 0; i < coldPool.length; i++) 
373 			voted[coldPool[i]] = false;
374 		votedFor = 0;
375 		votedAgainst = 0;
376 		voteStartTimestamp = getNowTimestamp();
377 	}
378 	
379 	function replaceModerator() internal {
380 		require(custodianPool.length > 0);
381 		uint index = getNextAddrIndex(COLD_POOL_IDX, custodianPool[custodianPool.length - 1]);
382 		address oldModerator = moderator;
383 		moderator = addrPool[COLD_POOL_IDX][index];
384 		emit ReplaceModerator(oldModerator, moderator);
385 		removeFromPool(COLD_POOL_IDX, index);
386 	}
387 
388 	/// @dev removeFromPool Function.
389 	/// @param poolIndex the pool to request from removal.
390 	/// @param addr the address to remove
391 	function removeFromPoolByAddr(uint poolIndex, address addr) internal {
392 	 	address[] memory subPool = addrPool[poolIndex];
393 		for (uint i = 0; i < subPool.length; i++) {
394 			if (subPool[i] == addr) {
395 				removeFromPool(poolIndex, i);
396 				break;
397             }
398 		}
399 	}
400 
401 	/// @dev removeFromPool Function.
402 	/// @param poolIndex the pool to request from removal.
403 	/// @param idx the index of address to remove
404 	function removeFromPool(uint poolIndex, uint idx) internal {
405 	 	address[] memory subPool = addrPool[poolIndex];
406 		addrStatus[subPool[idx]] = USED_STATUS;
407 		if (idx < subPool.length - 1)
408 			addrPool[poolIndex][idx] = addrPool[poolIndex][subPool.length-1];
409 		delete addrPool[poolIndex][subPool.length - 1];
410 		// emit RemoveFromPool(poolIndex, addrPool[poolIndex][idx]);
411 		addrPool[poolIndex].length--;
412 	}
413 
414 	/// @dev getNextAddrIndex Function.
415 	/// @param poolIndex the pool to request address from.
416 	/// @param custodianAddr the index of custodian contract address for randomeness generation
417 	function getNextAddrIndex(uint poolIndex, address custodianAddr) internal returns (uint) {
418 		uint prevHashNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))));
419 		ICustodian custodian = ICustodian(custodianAddr);
420 		uint userLength = custodian.totalUsers();
421 		if(userLength > 255) {
422 			address randomUserAddress = custodian.users(prevHashNumber % userLength);
423 			return uint256(keccak256(abi.encodePacked(randomUserAddress))) % addrPool[poolIndex].length;
424 		} else 
425 			return prevHashNumber % addrPool[poolIndex].length;
426 	}
427 
428 	/// @dev get Ethereum blockchain current timestamp
429 	function getNowTimestamp() internal view returns (uint) {
430 		return now;
431 	}
432 
433 	/// @dev get addressPool size
434 	function getAddressPoolSizes() public view returns (uint, uint) {
435 		return (addrPool[COLD_POOL_IDX].length, addrPool[HOT_POOL_IDX].length);
436 	}
437 
438 	/// @dev get contract pool size
439 	function getContractPoolSizes() public view returns (uint, uint) {
440 		return (custodianPool.length, otherContractPool.length);
441 	}
442 }