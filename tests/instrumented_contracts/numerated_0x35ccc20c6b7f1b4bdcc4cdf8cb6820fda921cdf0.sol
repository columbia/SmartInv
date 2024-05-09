1 // MarketPay-System-1.2.sol
2 
3 /*
4 MarketPay Solidity Libraries
5 developed by:
6 	MarketPay.io , 2018
7 	https://marketpay.io/
8 	https://goo.gl/kdECQu
9 
10 v1.2 
11 	+ Haltable by SC owner
12 	+ Constructors upgraded to new syntax
13 	
14 v1.1 
15 	+ Upgraded to Solidity 0.4.22
16 	
17 v1.0
18 	+ System functions
19 
20 */
21 
22 pragma solidity ^0.4.22;
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30 		uint256 c = a * b;
31 		assert(a == 0 || c / a == b);
32 		return c;
33 	}
34 
35 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
36 		// assert(b > 0); // Solidity automatically throws when dividing by 0
37 		uint256 c = a / b;
38 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 		return c;
40 	}
41 
42 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43 		assert(b <= a);
44 		return a - b;
45 	}
46 
47 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
48 		uint256 c = a + b;
49 		assert(c >= a);
50 		return c;
51 	}
52 }
53 
54 /**
55  * @title System
56  * @dev Abstract contract that includes some useful generic functions.
57  */
58 contract System {
59 	using SafeMath for uint256;
60 	
61 	address owner;
62 	
63 	// **** MODIFIERS
64 
65 	// @notice To limit functions usage to contract owner
66 	modifier onlyOwner() {
67 		if (msg.sender != owner) {
68 			error('System: onlyOwner function called by user that is not owner');
69 		} else {
70 			_;
71 		}
72 	}
73 
74 	// @notice To limit functions usage to contract owner, directly or indirectly (through another contract call)
75 	modifier onlyOwnerOrigin() {
76 		if (msg.sender != owner && tx.origin != owner) {
77 			error('System: onlyOwnerOrigin function called by user that is not owner nor a contract called by owner at origin');
78 		} else {
79 			_;
80 		}
81 	}
82 	
83 	
84 	// **** FUNCTIONS
85 	
86 	// @notice Calls whenever an error occurs, logs it or reverts transaction
87 	function error(string _error) internal {
88 		// revert(_error);
89 		// in case revert with error msg is not yet fully supported
90 			emit Error(_error);
91 			// throw;
92 	}
93 
94 	// @notice For debugging purposes when using solidity online browser, remix and sandboxes
95 	function whoAmI() public constant returns (address) {
96 		return msg.sender;
97 	}
98 	
99 	// @notice Get the current timestamp from last mined block
100 	function timestamp() public constant returns (uint256) {
101 		return block.timestamp;
102 	}
103 	
104 	// @notice Get the balance in weis of this contract
105 	function contractBalance() public constant returns (uint256) {
106 		return address(this).balance;
107 	}
108 	
109 	// @notice System constructor, defines owner
110 	constructor() public {
111 		// This is the constructor, so owner should be equal to msg.sender, and this method should be called just once
112 		owner = msg.sender;
113 		
114 		// make sure owner address is configured
115 		if(owner == 0x0) error('System constructor: Owner address is 0x0'); // Never should happen, but just in case...
116 	}
117 	
118 	// **** EVENTS
119 
120 	// @notice A generic error log
121 	event Error(string _error);
122 
123 	// @notice For debug purposes
124 	event DebugUint256(uint256 _data);
125 
126 }
127 
128 /**
129  * @title Haltable
130  * @dev Abstract contract that allows children to implement an emergency stop mechanism.
131  */
132 contract Haltable is System {
133 	bool public halted;
134 	
135 	// **** MODIFIERS
136 
137 	modifier stopInEmergency {
138 		if (halted) {
139 			error('Haltable: stopInEmergency function called and contract is halted');
140 		} else {
141 			_;
142 		}
143 	}
144 
145 	modifier onlyInEmergency {
146 		if (!halted) {
147 			error('Haltable: onlyInEmergency function called and contract is not halted');
148 		} {
149 			_;
150 		}
151 	}
152 
153 	// **** FUNCTIONS
154 	
155 	// called by the owner on emergency, triggers stopped state
156 	function halt() external onlyOwner {
157 		halted = true;
158 		emit Halt(true, msg.sender, timestamp()); // Event log
159 	}
160 
161 	// called by the owner on end of emergency, returns to normal state
162 	function unhalt() external onlyOwner onlyInEmergency {
163 		halted = false;
164 		emit Halt(false, msg.sender, timestamp()); // Event log
165 	}
166 	
167 	// **** EVENTS
168 	// @notice Triggered when owner halts contract
169 	event Halt(bool _switch, address _halter, uint256 _timestamp);
170 }
171  // Voting-1.4.sol
172 
173 /*
174 Voting Smart Contracts v1.4
175 developed by:
176 	MarketPay.io , 2017-2018
177 	https://marketpay.io/
178 	https://goo.gl/kdECQu
179 
180 v1.5 https://gitlab.com/lemonandmarket/third.io.marketpay.alcobendas/blob/master/contracts/Voting.sol
181 	+ new eVotingStatus
182 	+ Teller can endTesting() and reset all test votes
183 	+ Added full scan of tellers endpoint
184 
185 v1.4 https://gist.github.com/computerphysicslab/7a92baf53a66e6b6f104b9daf19ab33a
186 	+ grantTeller should call grantOracle
187 	+ remove constrain on voter being registered to vote (teller should check that a posteriori)
188 	+ store voter pubkey when registered and endpoint to query it, getVoterPubKey()
189 	+ System library
190 	+ function isACitizen() to public
191 	
192 v1.3 https://gist.github.com/computerphysicslab/106a25a062cb611685b5f36abf1a3eea
193 	+ Tellers contract records public key of tellers, in order to voters send their votes ciphered for the tellers
194 
195 v1.2 https://gist.github.com/computerphysicslab/057c10515b38f0dcacdbd5d3cb6e9d61
196 	+ Tellers contract is actually another instance of Oracle contract
197 	+ Tellers only can close the poll
198 	+ SC Owner defines tellers
199 
200 v1.1 https://gist.github.com/computerphysicslab/c592bbe6d4ad56a11b39bae31852f17c
201 	+ Oracles contract
202 	+ Oracles only are allowed to grantVote
203 	+ SC Owner defines oracles
204 
205 v1.0 https://gist.github.com/computerphysicslab/39a7a8bc2c364d4a17c5ef0362904aeb
206 	+ Storage of votes
207 	+ Poll closes on deadline
208 	+ Forbid double vote
209 	+ Oracle grants whitelist of addresses to vote
210 	+ Full scan query of votes
211 */
212 
213 
214 /**
215  * @title Oracles
216  * @dev This contract is used to validate Oracles
217  */
218 contract Oracles is Haltable {
219 	// **** DATA
220 	struct oracle {
221 		uint256 oracleId;
222 		bool oracleAuth;
223 		address oracleAddress;
224 	}
225 	mapping (address => oracle) oracleData;
226 	mapping (uint256 => address) oracleAddressById; // indexed oracles so as to be fully scannable
227 	uint256 lastId;
228 
229 
230 	// **** METHODS
231 
232 	// Checks whether a given user is an authorized oracle
233 	function isOracle(address _oracle) public constant returns (bool) {
234 		return (oracleData[_oracle].oracleAuth);
235 	}
236 
237 	function newOracle(address _oracle) internal onlyOwner returns (uint256 id) {
238 		// Update Index
239 		id = ++lastId;
240 		oracleData[_oracle].oracleId = id;
241 		oracleData[_oracle].oracleAuth = false;
242 		oracleData[_oracle].oracleAddress = _oracle;
243 		oracleAddressById[id] = _oracle;
244 
245 		emit NewOracle(_oracle, id, timestamp()); // Event log
246 	}
247 
248 	function grantOracle(address _oracle) public onlyOwner {
249 		// Checks whether this user has been previously added as an oracle
250 		uint256 id;
251 		if (oracleData[_oracle].oracleId > 0) {
252 			id = oracleData[_oracle].oracleId;
253 		} else {
254 			id = newOracle(_oracle);
255 		}
256 
257 		oracleData[_oracle].oracleAuth = true;
258 
259 		emit GrantOracle(_oracle, id, timestamp()); // Event log
260 	}
261 
262 	function revokeOracle(address _oracle) external onlyOwner {
263 		oracleData[_oracle].oracleAuth = false;
264 
265 		emit RevokeOracle(_oracle, timestamp()); // Event log
266 	}
267 
268 	// Queries the oracle, knowing the address
269 	function getOracleByAddress(address _oracle) public constant returns (uint256 _oracleId, bool _oracleAuth, address _oracleAddress) {
270 		return (oracleData[_oracle].oracleId, oracleData[_oracle].oracleAuth, oracleData[_oracle].oracleAddress);
271 	}
272 
273 	// Queries the oracle, knowing the id
274 	function getOracleById(uint256 id) public constant returns (uint256 _oracleId, bool _oracleAuth, address _oracleAddress) {
275 		return (getOracleByAddress(oracleAddressById[id]));
276 	}
277 
278 
279 	// **** EVENTS
280 
281 	// Triggered when a new oracle is created
282 	event NewOracle(address indexed _who, uint256 indexed _id, uint256 _timestamp);
283 
284 	// Triggered when a user is granted to become an oracle
285 	event GrantOracle(address indexed _who, uint256 indexed _id, uint256 _timestamp);
286 
287 	// Triggered when a user is revoked for being an oracle
288 	event RevokeOracle(address indexed _who, uint256 _timestamp);
289 }
290 
291   // Voting-1.4.sol
292 
293 /*
294 Voting Smart Contracts v1.4
295 developed by:
296 	MarketPay.io , 2017-2018
297 	https://marketpay.io/
298 	https://goo.gl/kdECQu
299 
300 v1.5 https://gitlab.com/lemonandmarket/third.io.marketpay.alcobendas/blob/master/contracts/Voting.sol
301 	+ new eVotingStatus
302 	+ Teller can endTesting() and reset all test votes
303 	+ Added full scan of tellers endpoint
304 
305 v1.4 https://gist.github.com/computerphysicslab/7a92baf53a66e6b6f104b9daf19ab33a
306 	+ grantTeller should call grantOracle
307 	+ remove constrain on voter being registered to vote (teller should check that a posteriori)
308 	+ store voter pubkey when registered and endpoint to query it, getVoterPubKey()
309 	+ System library
310 	+ function isACitizen() to public
311 	
312 v1.3 https://gist.github.com/computerphysicslab/106a25a062cb611685b5f36abf1a3eea
313 	+ Tellers contract records public key of tellers, in order to voters send their votes ciphered for the tellers
314 
315 v1.2 https://gist.github.com/computerphysicslab/057c10515b38f0dcacdbd5d3cb6e9d61
316 	+ Tellers contract is actually another instance of Oracle contract
317 	+ Tellers only can close the poll
318 	+ SC Owner defines tellers
319 
320 v1.1 https://gist.github.com/computerphysicslab/c592bbe6d4ad56a11b39bae31852f17c
321 	+ Oracles contract
322 	+ Oracles only are allowed to grantVote
323 	+ SC Owner defines oracles
324 
325 v1.0 https://gist.github.com/computerphysicslab/39a7a8bc2c364d4a17c5ef0362904aeb
326 	+ Storage of votes
327 	+ Poll closes on deadline
328 	+ Forbid double vote
329 	+ Oracle grants whitelist of addresses to vote
330 	+ Full scan query of votes
331 */
332 
333 
334 
335 
336 
337 /**
338  * @title Tellers
339  * @dev This contract is used to validate Tellers that can read ciphered votes and close the voting process
340  */
341 contract Tellers is Oracles {
342 	// **** DATA
343 	address[] public tellersArray; // full scan of tellers
344 	mapping (address => bytes) public pubKeys;
345 	bytes[] public pubKeysArray; // full scan of tellers' pubkeys
346 
347 	function grantTeller(address _teller, bytes _pubKey) external onlyOwner {
348 		// Checks whether this user has been previously added as a teller
349 		if (keccak256(pubKeys[_teller]) != keccak256("")) { // A workaround to bytes comparison: if (pubKeys[_teller] != '') ...
350 			error('grantTeller: This teller is already granted');
351 		}
352 
353 		tellersArray.push(_teller);
354 		pubKeys[_teller] = _pubKey;
355 		pubKeysArray.push(_pubKey);
356 
357 		grantOracle(_teller); // A teller inherits oracle behaviour
358 
359 		emit GrantTeller(_teller, _pubKey, timestamp()); // Event log
360 	}
361 
362 	// Triggered when a user is granted to become a teller
363 	event GrantTeller(address indexed _who, bytes _pubKey, uint256 _timestamp);
364 }
365 
366 
367   // Voting-1.4.sol
368 
369 /*
370 Voting Smart Contracts v1.4
371 developed by:
372 	MarketPay.io , 2017-2018
373 	https://marketpay.io/
374 	https://goo.gl/kdECQu
375 
376 v1.5 https://gitlab.com/lemonandmarket/third.io.marketpay.alcobendas/blob/master/contracts/Voting.sol
377 	+ new eVotingStatus
378 	+ Teller can endTesting() and reset all test votes
379 	+ Added full scan of tellers endpoint
380 
381 v1.4 https://gist.github.com/computerphysicslab/7a92baf53a66e6b6f104b9daf19ab33a
382 	+ grantTeller should call grantOracle
383 	+ remove constrain on voter being registered to vote (teller should check that a posteriori)
384 	+ store voter pubkey when registered and endpoint to query it, getVoterPubKey()
385 	+ System library
386 	+ function isACitizen() to public
387 	
388 v1.3 https://gist.github.com/computerphysicslab/106a25a062cb611685b5f36abf1a3eea
389 	+ Tellers contract records public key of tellers, in order to voters send their votes ciphered for the tellers
390 
391 v1.2 https://gist.github.com/computerphysicslab/057c10515b38f0dcacdbd5d3cb6e9d61
392 	+ Tellers contract is actually another instance of Oracle contract
393 	+ Tellers only can close the poll
394 	+ SC Owner defines tellers
395 
396 v1.1 https://gist.github.com/computerphysicslab/c592bbe6d4ad56a11b39bae31852f17c
397 	+ Oracles contract
398 	+ Oracles only are allowed to grantVote
399 	+ SC Owner defines oracles
400 
401 v1.0 https://gist.github.com/computerphysicslab/39a7a8bc2c364d4a17c5ef0362904aeb
402 	+ Storage of votes
403 	+ Poll closes on deadline
404 	+ Forbid double vote
405 	+ Oracle grants whitelist of addresses to vote
406 	+ Full scan query of votes
407 */
408 
409 
410 
411 
412 /**
413  * @title Voting
414  * @dev This contract is used to store votes
415  */
416 contract Voting is Haltable {
417 	// **** DATA
418 	mapping (address => string) votes;
419 	uint256 public numVotes;
420 
421 	mapping (address => bool) allowed; // Only granted addresses are allowed to issue a vote in the poll
422 	address[] votersArray;
423 	uint256 public numVoters;
424 
425 	uint256 public deadline;
426 	eVotingStatus public VotingStatus; // Tellers are allowed to close the poll
427 	enum eVotingStatus { Test, Voting, Closed }
428 
429 
430 	Oracles public SCOracles; // Contract that defines who is an oracle. Oracles allow wallets to vote
431 	Tellers public SCTellers; // Contract that defines who is a teller. Tellers are allowed to close the poll and have an associated pubKey stored on contract
432 
433 	mapping (address => bytes) public pubKeys; // Voters' pubkeys
434 
435 
436 	// **** MODIFIERS
437 	modifier votingClosed() { if (now >= deadline || VotingStatus == eVotingStatus.Closed) _; }
438 	modifier votingActive() { if (now < deadline && VotingStatus != eVotingStatus.Closed) _; }
439 
440 	// To limit voteGranting function just to authorized oracles
441 	modifier onlyOracle() {
442 		if (!SCOracles.isOracle(msg.sender)) {
443 			error('onlyOracle function called by user that is not an authorized oracle');
444 		} else {
445 			_;
446 		}
447 	}
448 
449 	// To limit closeVoting function just to authorized tellers
450 	modifier onlyTeller() {
451 		if (!SCTellers.isOracle(msg.sender)) {
452 			error('onlyTeller function called by user that is not an authorized teller');
453 		} else {
454 			_;
455 		}
456 	}
457 
458 
459 	// **** METHODS
460 	constructor(address _SCOracles, address _SCTellers) public {
461 		SCOracles = Oracles(_SCOracles);
462 		SCTellers = Tellers(_SCTellers);
463 		deadline = now + 60 days;
464 		VotingStatus = eVotingStatus.Test;
465 	}
466 
467 	function pollStatus() public constant returns (eVotingStatus) {
468 		if (now >= deadline) {
469 			return eVotingStatus.Closed;
470 		}
471 		return VotingStatus;
472 	}
473 
474 	function isACitizen(address _voter) public constant returns (bool) {
475 		if (allowed[_voter]) {
476 			return true;
477 		} else {
478 			return false;
479 		}
480 	}
481 
482 	function amIACitizen() public constant returns (bool) {
483 		return (isACitizen(msg.sender));
484 	}
485 
486 	function canItVote(address _voter) internal constant returns (bool) {
487 		if (bytes(votes[_voter]).length == 0) {
488 			return true;
489 		} else {
490 			return false;
491 		}
492 	}
493 
494 	function canIVote() public constant returns (bool) {
495 		return (canItVote(msg.sender));
496 	}
497 
498 	function sendVote(string _vote) votingActive public returns (bool) {
499 		// Check whether voter has not previously casted a vote
500 		if (!canIVote()) {
501 			error('sendVote: sender cannot vote because it has previously casted another vote');
502 			return false;
503 		}
504 
505 		// Check whether vote is not empty
506 		if (bytes(_vote).length < 1) {
507 			error('sendVote: vote is empty');
508 			return false;
509 		}
510 
511 		// Cast the vote
512 		votes[msg.sender] = _vote;
513 		numVotes ++;
514 
515 		emit SendVote(msg.sender, _vote); // Event log
516 
517 		return true;
518 	}
519 
520 	function getVoter(uint256 _idVoter) /* votingClosed */ public constant returns (address) {
521 		return (votersArray[_idVoter]);
522 	}
523 
524 	function readVote(address _voter) /* votingClosed */ public constant returns (string) {
525 		return (votes[_voter]);
526 	}
527 
528 	// Low level grantVoter w/o pubKey, avoid adding the same voter twice
529 	function _grantVoter(address _voter) onlyOracle public {
530 		if(!allowed[_voter]) {
531 			allowed[_voter] = true;
532 			votersArray.push(_voter);
533 			numVoters ++;
534 
535 			emit GrantVoter(_voter); // Event log
536 		}
537 	}
538 
539 	// New endpoint that sets pubKey as well
540 	function grantVoter(address _voter, bytes _pubKey) onlyOracle public {
541 		_grantVoter(_voter);
542 
543 		pubKeys[_voter] = _pubKey;
544 	}
545 
546 	function getVoterPubKey(address _voter) public constant returns (bytes) {
547 		return (pubKeys[_voter]);
548 	}
549 
550 	function closeVoting() onlyTeller public {
551 		VotingStatus = eVotingStatus.Closed;
552 
553 		emit CloseVoting(true); // Event log
554 	}
555 
556 	function endTesting() onlyTeller public {
557 		numVotes = 0;
558 		uint256 l = votersArray.length;
559 		for(uint256 i = 0;i<l;i++) {
560 			delete votes[votersArray[i]];
561 		}
562 		VotingStatus = eVotingStatus.Voting;
563 	}
564 
565 	// fallback function. This SC doesn't accept any Ether
566 	function () payable public {
567 		revert();
568 	}
569 
570 
571 	// **** EVENTS
572 	// Triggered when a voter issues a vote
573 	event SendVote(address indexed _from, string _vote);
574 
575 	// Triggered when a voter is granted by the Oracle
576 	event GrantVoter(address indexed _voter);
577 
578 	// Triggered when Contract Owner closes the voting
579 	event CloseVoting(bool _VotingClosed);
580 }