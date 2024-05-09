1 pragma solidity ^ 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10 	/**
11 	 * @dev Multiplies two numbers, reverts on overflow.
12 	 */
13 	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
14 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15 		// benefit is lost if 'b' is also tested.
16 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17 		if (a == 0) {
18 			return 0;
19 		}
20 
21 		uint256 c = a * b;
22 		require(c / a == b);
23 
24 		return c;
25 	}
26 
27 	/**
28 	 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29 	 */
30 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
31 		require(b > 0); // Solidity only automatically asserts when dividing by 0
32 		uint256 c = a / b;
33 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35 		return c;
36 	}
37 
38 	/**
39 	 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40 	 */
41 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
42 		require(b <= a);
43 		uint256 c = a - b;
44 
45 		return c;
46 	}
47 
48 	/**
49 	 * @dev Adds two numbers, reverts on overflow.
50 	 */
51 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
52 		uint256 c = a + b;
53 		require(c >= a);
54 
55 		return c;
56 	}
57 
58 	/**
59 	 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60 	 * reverts when dividing by zero.
61 	 */
62 	function mod(uint256 a, uint256 b) internal pure returns(uint256) {
63 		require(b != 0);
64 		return a % b;
65 	}
66 }
67 
68 /**
69  * @title BaseAccessControl
70  * @dev Basic control permissions are setting here
71  */
72 contract BaseAccessControl {
73 
74 	address public ceo;
75 	address public coo;
76 	address public cfo;
77 
78 	constructor() public {
79 		ceo = msg.sender;
80 		coo = msg.sender;
81 		cfo = msg.sender;
82 	}
83 
84 	/** roles modifer */
85 	modifier onlyCEO() {
86 		require(msg.sender == ceo, "CEO Only");
87 		_;
88 	}
89 	modifier onlyCOO() {
90 		require(msg.sender == coo, "COO Only");
91 		_;
92 	}
93 	modifier onlyCFO() {
94 		require(msg.sender == cfo, "CFO Only");
95 		_;
96 	}
97 	modifier onlyCLevel() {
98 		require(msg.sender == ceo || msg.sender == coo || msg.sender == cfo, "CLevel Only");
99 		_;
100 	}
101 	/** end modifier */
102 
103 	/** util modifer */
104 	modifier required(address addr) {
105 		require(addr != address(0), "Address is required.");
106 		_;
107 	}
108 	modifier onlyHuman(address addr) {
109 		uint256 codeLength;
110 		assembly {
111 			codeLength: = extcodesize(addr)
112 		}
113 		require(codeLength == 0, "Humans only");
114 		_;
115 	}
116 	modifier onlyContract(address addr) {
117 		uint256 codeLength;
118 		assembly {
119 			codeLength: = extcodesize(addr)
120 		}
121 		require(codeLength > 0, "Contracts only");
122 		_;
123 	}
124 	/** end util modifier */
125 
126 	/** setter */
127 	function setCEO(address addr) external onlyCEO() required(addr) onlyHuman(addr) {
128 		ceo = addr;
129 	}
130 
131 	function setCOO(address addr) external onlyCEO() required(addr) onlyHuman(addr) {
132 		coo = addr;
133 	}
134 
135 	function setCFO(address addr) external onlyCEO() required(addr) onlyHuman(addr) {
136 		cfo = addr;
137 	}
138 	/** end setter */
139 }
140 
141 /**
142  * @title MinerAccessControl
143  * @dev Expanding the access control module for miner contract, especially for B1MP contract here
144  */
145 contract MinerAccessControl is BaseAccessControl {
146 
147 	address public companyWallet;
148 
149 	bool public paused = false;
150 
151 	/** modifer */
152 	modifier whenNotPaused() {
153 		require(!paused, "Paused");
154 		_;
155 	}
156 	modifier whenPaused() {
157 		require(paused, "Running");
158 		_;
159 	}
160 	/** end modifier */
161 
162 	/** setter */
163 	function setCompanyWallet(address newCompanyWallet) external onlyCEO() required(newCompanyWallet) {
164 		companyWallet = newCompanyWallet;
165 	}
166 
167 	function paused() public onlyCLevel() whenNotPaused() {
168 		paused = true;
169 	}
170 
171 	function unpaused() external onlyCEO() whenPaused() {
172 		paused = false;
173 	}
174 	/** end setter */
175 }
176 
177 /**
178  * @title B1MPToken
179  * @dev This contract is One-Minute Profit Option Contract.
180  * And all users can get their one-minute profit option as a ERC721 token through this contract.
181  * Even more, all users can exchange their one-minute profit option in the future.
182  */
183 interface B1MPToken {
184 	function mintByTokenId(address to, uint256 tokenId) external returns(bool);
185 }
186 
187 /**
188  * @title B1MP
189  * @dev This is the old B1MP contract.
190  * Because of some problem, we have decided to migrate all data and use a new one contract.
191  */
192 interface B1MP {
193 	function _global() external view returns(uint256 revenue, uint256 g_positionAmount, uint256 earlierPayoffPerPosition, uint256 totalRevenue);
194 	function _userAddrBook(uint256 index) external view returns(address addr);
195 	function _users(address addr) external view returns(uint256 id, uint256 positionAmount, uint256 earlierPayoffMask, uint256 lastRefId);
196 	function _invitations(address addr) external view returns(uint256 invitationAmount, uint256 invitationPayoff);
197 	function _positionBook(uint256 index1, uint256 index2) external view returns(uint256 minute);
198 	function _positionOnwers(uint256 minute) external view returns(address addr);
199 	function totalUsers() external view returns(uint256);
200 	function getUserPositionIds(address addr) external view returns(uint256[]);
201 }
202 
203 /**
204  * @title NewB1MP
205  * @dev Because the old one has some problem, we re-devise the whole contract.
206  * All actions, such as buying, withdrawing, and etc., are responding and recording by this contract.
207  */
208 contract NewB1MP is MinerAccessControl {
209 
210 	using SafeMath for * ;
211 
212 	// the activity configurations
213 	struct Config {
214 		uint256 start; // the activity's start-time
215 		uint256 end; // the activity's end-time
216 		uint256 price; // the price of any one-minute profit option
217 		uint256 withdrawFee; // the basic fee for withdrawal request
218 		uint8 earlierPayoffRate; // the proportion of dividends to early buyers
219 		uint8 invitationPayoffRate; // the proportion of dividends to inviters
220 		uint256 finalPrizeThreshold; // the threshold for opening the final prize
221 		uint8[10] finalPrizeRates; // a group proportions for the final prize, the final selected proportion will be decided by some parameters
222 	}
223 
224 	struct Global {
225 		uint256 revenue; // reserved revenue of the project holder
226 		uint256 positionAmount; // the total amount of minutes been sold
227 		uint256 earlierPayoffPerPosition; // the average dividends for every minute been sold before
228 		uint256 totalRevenue; // total amount of revenue
229 	}
230 
231 	struct User {
232 		uint256 id; // user's id, equal to user's index + 1, increment
233 		uint256 positionAmount; // the total amount of minutes bought by this user
234 		uint256 earlierPayoffMask; // the pre-purchaser dividend that the user should not receive
235 		uint256 lastRefId; // the inviter's user-id
236 		uint256[] positionIds; // all position ids hold by this user
237 	}
238 
239 	struct Invitation {
240 		uint256 amount; // how many people invited
241 		uint256 payoff; // how much payoff through invitation
242 	}
243 
244 	B1MP public oldB1MPContract; // the old B1MP contract, just for data migration
245 	B1MPToken public tokenContract; // the one-minute profit option contract
246 	Config public _config; // configurations
247 	Global public _global; // globa info
248 	address[] public _userAddrBook; // users' addresses list, for registration
249 	mapping(address => User) public _users; // all users' detail info
250 	mapping(address => Invitation) public _invitations; // the invitations info
251 
252 	uint256[2][] public _positionBook; // all positions list
253 	mapping(uint256 => address) public _positionOwners; // positionId (index + 1) => owner
254 	mapping(uint256 => address) public _positionMiners; // position minute => miner
255 
256 	uint256 public _prizePool; // the pool of final prize
257 	uint256 public _prizePoolWithdrawn; // how much money been withdrawn through final prize pool
258 	bool public _isPrizeActivated; // whether the final prize is activated
259 
260 	address[] public _winnerPurchaseListForAddr; // final prize winners list
261 	uint256[] public _winnerPurchaseListForPositionAmount; // the purchase history of final prize winners
262 	mapping(address => uint256) public _winnerPositionAmounts; // the total position amount of any final prize winner
263 	uint256 public _currentWinnerIndex; // the index of current winner, using for a looping array of all winners
264 	uint256 private _winnerCounter; // the total amount of final prize winners
265 	uint256 public _winnerTotalPositionAmount; // the total amount of positons bought by all final prize winners
266 
267 	bool private _isReady; // whether the data migration has been completed
268 	uint256 private _userMigrationCounter; // how many users have been migrated
269 
270 	/** modifer */
271 	modifier paymentLimit(uint256 ethVal) {
272 		require(ethVal > 0, "Too poor.");
273 		require(ethVal <= 100000 ether, "Too rich.");
274 		_;
275 	}
276 	modifier buyLimit(uint256 ethVal) {
277 		require(ethVal >= _config.price, 'Not enough.');
278 		_;
279 	}
280 	modifier withdrawLimit(uint256 ethVal) {
281 		require(ethVal == _config.withdrawFee, 'Not enough.');
282 		_;
283 	}
284 	modifier whenNotEnded() {
285 		require(_config.end == 0 || now < _config.end, 'Ended.');
286 		_;
287 	}
288 	modifier whenEnded() {
289 		require(_config.end != 0 && now >= _config.end, 'Not ended.');
290 		_;
291 	}
292 	modifier whenPrepare() {
293 		require(_config.end == 0, 'Started.');
294 		require(_isReady == false, 'Ready.');
295 		_;
296 	}
297 	modifier whenReady() {
298 		require(_isReady == true, 'Not ready.');
299 		_;
300 	}
301 	/** end modifier */
302 
303 	// initialize
304 	constructor(address tokenAddr, address oldB1MPContractAddr) onlyContract(tokenAddr) onlyContract(oldB1MPContractAddr) public {
305 		// ready for migration
306 		oldB1MPContract = B1MP(oldB1MPContractAddr);
307 		_isReady = false;
308 		_userMigrationCounter = 0;
309 		// initialize base info
310 		tokenContract = B1MPToken(tokenAddr);
311 		_config = Config(1541993890, 0, 90 finney, 5 finney, 10, 20, 20000 ether, [
312 			5, 6, 7, 8, 10, 13, 15, 17, 20, 25
313 		]);
314 		_global = Global(0, 0, 0, 0);
315 
316 		// ready for final prize
317 		_currentWinnerIndex = 0;
318 		_isPrizeActivated = false;
319 	}
320 
321 	function migrateUserData(uint256 n) whenPrepare() onlyCEO() public {
322 		// intialize _userAddrBook & _users
323 		uint256 userAmount = oldB1MPContract.totalUsers();
324 		_userAddrBook.length = userAmount;
325 		// migrate n users per time
326 		uint256 lastMigrationNumber = _userMigrationCounter;
327 		for (_userMigrationCounter; _userMigrationCounter < userAmount && _userMigrationCounter < lastMigrationNumber + n; _userMigrationCounter++) {
328 			// A. get user address
329 			address userAddr = oldB1MPContract._userAddrBook(_userMigrationCounter);
330 			/// save to _userAddrBook
331 			_userAddrBook[_userMigrationCounter] = userAddr;
332 			// B. get user info
333 			(uint256 id, uint256 positionAmount, uint256 earlierPayoffMask, uint256 lastRefId) = oldB1MPContract._users(userAddr);
334 			uint256[] memory positionIds = oldB1MPContract.getUserPositionIds(userAddr);
335 			/// save to _users
336 			_users[userAddr] = User(id, positionAmount, earlierPayoffMask, lastRefId, positionIds);
337 			// C. get invitation info
338 			(uint256 invitationAmount, uint256 invitationPayoff) = oldB1MPContract._invitations(userAddr);
339 			/// save to _invitations
340 			_invitations[userAddr] = Invitation(invitationAmount, invitationPayoff);
341 			// D. get & save position info
342 			for (uint256 i = 0; i < positionIds.length; i++) {
343 				uint256 pid = positionIds[i];
344 				if (pid > 0) {
345 					if (pid > _positionBook.length) {
346 						_positionBook.length = pid;
347 					}
348 					uint256 pIndex = pid.sub(1);
349 					_positionBook[pIndex] = [oldB1MPContract._positionBook(pIndex, 0), oldB1MPContract._positionBook(pIndex, 1)];
350 					_positionOwners[pIndex] = userAddr;
351 				}
352 			}
353 		}
354 	}
355 
356 	function migrateGlobalData() whenPrepare() onlyCEO() public {
357 		// intialize _global
358 		(uint256 revenue, uint256 g_positionAmount, uint256 earlierPayoffPerPosition, uint256 totalRevenue) = oldB1MPContract._global();
359 		_global = Global(revenue, g_positionAmount, earlierPayoffPerPosition, totalRevenue);
360 	}
361 
362 	function depositeForMigration() whenPrepare() onlyCEO() public payable {
363 		require(_userMigrationCounter == oldB1MPContract.totalUsers(), 'Continue to migrate.');
364 		require(msg.value >= address(oldB1MPContract).balance, 'Not enough.');
365 		// update revenue, but don't update totalRevenue
366 		// because it's the dust of deposit, but not the revenue of sales
367 		// it will be not used for final prize
368 		_global.revenue = _global.revenue.add(msg.value.sub(address(oldB1MPContract).balance));
369 		_isReady = true;
370 	}
371 
372 	function () whenReady() whenNotEnded() whenNotPaused() onlyHuman(msg.sender) paymentLimit(msg.value) buyLimit(msg.value) public payable {
373 		buyCore(msg.sender, msg.value, 0);
374 	}
375 
376 	function buy(uint256 refId) whenReady() whenNotEnded() whenNotPaused() onlyHuman(msg.sender) paymentLimit(msg.value) buyLimit(msg.value) public payable {
377 		buyCore(msg.sender, msg.value, refId);
378 	}
379 
380 	function buyCore(address addr_, uint256 revenue_, uint256 refId_) private {
381 		// 1. prepare some data
382 		uint256 _positionAmount_ = (revenue_).div(_config.price); // actual amount 
383 		uint256 _realCost_ = _positionAmount_.mul(_config.price);
384 		uint256 _invitationPayoffPart_ = _realCost_.mul(_config.invitationPayoffRate).div(100);
385 		uint256 _earlierPayoffPart_ = _realCost_.mul(_config.earlierPayoffRate).div(100);
386 		revenue_ = revenue_.sub(_invitationPayoffPart_).sub(_earlierPayoffPart_);
387 		uint256 _earlierPayoffMask_ = 0;
388 
389 		// 2. register a new user
390 		if (_users[addr_].id == 0) {
391 			_userAddrBook.push(addr_); // add to user address list
392 			_users[addr_].id = _userAddrBook.length; // assign the user id, especially id = userAddrBook.index + 1
393 		}
394 
395 		// 3. update global info
396 		if (_global.positionAmount > 0) {
397 			uint256 eppp = _earlierPayoffPart_.div(_global.positionAmount);
398 			_global.earlierPayoffPerPosition = eppp.add(_global.earlierPayoffPerPosition); // update global earlier payoff for per position
399 			revenue_ = revenue_.add(_earlierPayoffPart_.sub(eppp.mul(_global.positionAmount))); // the dust for this dividend
400 		} else {
401 			revenue_ = revenue_.add(_earlierPayoffPart_); // no need to dividend, especially for first one
402 		}
403 		// update the total position amount
404 		_global.positionAmount = _positionAmount_.add(_global.positionAmount);
405 		// calculate the current user's earlier payoff mask for this tx
406 		_earlierPayoffMask_ = _positionAmount_.mul(_global.earlierPayoffPerPosition);
407 
408 		// 4. update referral data
409 		if (refId_ <= 0 || refId_ > _userAddrBook.length || refId_ == _users[addr_].id) { // the referrer doesn't exist, or is clien self
410 			refId_ = _users[addr_].lastRefId;
411 		} else if (refId_ != _users[addr_].lastRefId) {
412 			_users[addr_].lastRefId = refId_;
413 		}
414 		// update referrer's invitation info if he exists
415 		if (refId_ != 0) {
416 			address refAddr = _userAddrBook[refId_.sub(1)];
417 			// modify old one or create a new on if it doesn't exist
418 			_invitations[refAddr].amount = (1).add(_invitations[refAddr].amount); // update invitation amount
419 			_invitations[refAddr].payoff = _invitationPayoffPart_.add(_invitations[refAddr].payoff); // update invitation payoff
420 		} else {
421 			revenue_ = revenue_.add(_invitationPayoffPart_); // no referrer
422 		}
423 
424 		// 5. update user info
425 		_users[addr_].positionAmount = _positionAmount_.add(_users[addr_].positionAmount);
426 		_users[addr_].earlierPayoffMask = _earlierPayoffMask_.add(_users[addr_].earlierPayoffMask);
427 		// update user's positions details, and record the position
428 		_positionBook.push([_global.positionAmount.sub(_positionAmount_).add(1), _global.positionAmount]);
429 		_positionOwners[_positionBook.length] = addr_;
430 		_users[addr_].positionIds.push(_positionBook.length);
431 
432 		// 6. archive revenue
433 		_global.revenue = revenue_.add(_global.revenue);
434 		_global.totalRevenue = revenue_.add(_global.totalRevenue);
435 
436 		// 7. select 1% user for final prize when the revenue is more than final prize threshold
437 		if (_global.totalRevenue > _config.finalPrizeThreshold) {
438 			uint256 maxWinnerAmount = countWinners(); // the max amount of winners, 1% of total users
439 			// activate final prize module at least there are more than 100 users
440 			if (maxWinnerAmount > 0) {
441 				if (maxWinnerAmount > _winnerPurchaseListForAddr.length) {
442 					_winnerPurchaseListForAddr.length = maxWinnerAmount;
443 					_winnerPurchaseListForPositionAmount.length = maxWinnerAmount;
444 				}
445 				// get the last winner's address
446 				address lwAddr = _winnerPurchaseListForAddr[_currentWinnerIndex];
447 				if (lwAddr != address(0)) { // deal the last winner's info
448 					// deduct this purchase record's positions amount from total amount
449 					_winnerTotalPositionAmount = _winnerTotalPositionAmount.sub(_winnerPurchaseListForPositionAmount[_currentWinnerIndex]);
450 					// deduct the winner's position amount from  this winner's amount
451 					_winnerPositionAmounts[lwAddr] = _winnerPositionAmounts[lwAddr].sub(_winnerPurchaseListForPositionAmount[_currentWinnerIndex]);
452 					// this is the winner's last record
453 					if (_winnerPositionAmounts[lwAddr] == 0) {
454 						// delete the winner's info
455 						_winnerCounter = _winnerCounter.sub(1);
456 						delete _winnerPositionAmounts[lwAddr];
457 					}
458 				}
459 				// set the new winner's info, or update old winner's info
460 				// register a new winner
461 				if (_winnerPositionAmounts[msg.sender] == 0) {
462 					// add a new winner
463 					_winnerCounter = _winnerCounter.add(1);
464 				}
465 				// update total amount of winner's positions bought finally
466 				_winnerTotalPositionAmount = _positionAmount_.add(_winnerTotalPositionAmount);
467 				// update winner's position amount
468 				_winnerPositionAmounts[msg.sender] = _positionAmount_.add(_winnerPositionAmounts[msg.sender]);
469 				// directly reset the winner list
470 				_winnerPurchaseListForAddr[_currentWinnerIndex] = msg.sender;
471 				_winnerPurchaseListForPositionAmount[_currentWinnerIndex] = _positionAmount_;
472 				// move the index to next
473 				_currentWinnerIndex = _currentWinnerIndex.add(1);
474 				if (_currentWinnerIndex >= maxWinnerAmount) { // the max index = total amount - 1
475 					_currentWinnerIndex = 0; // start a new loop when the number of winners exceed over the max amount allowed
476 				}
477 			}
478 		}
479 
480 		// 8. update end time
481 		_config.end = (now).add(2 days); // expand the end time for every tx
482 	}
483 
484 	function redeemOptionContract(uint256 positionId, uint256 minute) whenReady() whenNotPaused() onlyHuman(msg.sender) public {
485 		require(_users[msg.sender].id != 0, 'Unauthorized.');
486 		require(positionId <= _positionBook.length && positionId > 0, 'Position Id error.');
487 		require(_positionOwners[positionId] == msg.sender, 'No permission.');
488 		require(minute >= _positionBook[positionId - 1][0] && minute <= _positionBook[positionId - 1][1], 'Wrong interval.');
489 		require(_positionMiners[minute] == address(0), 'Minted.');
490 
491 		// record the miner
492 		_positionMiners[minute] = msg.sender;
493 
494 		// mint this minute's token
495 		require(tokenContract.mintByTokenId(msg.sender, minute), "Mining Error.");
496 	}
497 
498 	function activateFinalPrize() whenReady() whenEnded() whenNotPaused() onlyCOO() public {
499 		require(_isPrizeActivated == false, 'Activated.');
500 		// total revenue should be more than final prize threshold
501 		if (_global.totalRevenue > _config.finalPrizeThreshold) {
502 			// calculate the prize pool
503 			uint256 selectedfinalPrizeRatesIndex = _winnerCounter.mul(_winnerTotalPositionAmount).mul(_currentWinnerIndex).mod(_config.finalPrizeRates.length);
504 			_prizePool = _global.totalRevenue.mul(_config.finalPrizeRates[selectedfinalPrizeRatesIndex]).div(100);
505 			// deduct the final prize pool from the reserved revenue
506 			_global.revenue = _global.revenue.sub(_prizePool);
507 		}
508 		// maybe not enough to final prize
509 		_isPrizeActivated = true;
510 	}
511 
512 	function withdraw() whenReady() whenNotPaused() onlyHuman(msg.sender) withdrawLimit(msg.value) public payable {
513 		_global.revenue = _global.revenue.add(msg.value); // archive withdrawal fee to revenue, but not total revenue which is for final prize
514 
515 		// 1. deduct invitation payoff
516 		uint256 amount = _invitations[msg.sender].payoff;
517 		_invitations[msg.sender].payoff = 0; // clear the user's invitation payoff
518 
519 		// 2. deduct earlier payoff
520 		uint256 ep = (_global.earlierPayoffPerPosition).mul(_users[msg.sender].positionAmount);
521 		amount = amount.add(ep.sub(_users[msg.sender].earlierPayoffMask));
522 		_users[msg.sender].earlierPayoffMask = ep; // reset the user's earlier payoff mask which include this withdrawal part
523 
524 		// 3. get the user's final prize, and deduct it
525 		if (_isPrizeActivated == true && _winnerPositionAmounts[msg.sender] > 0 &&
526 			_winnerTotalPositionAmount > 0 && _winnerCounter > 0 && _prizePool > _prizePoolWithdrawn) {
527 			// calculate the user's prize amount
528 			uint256 prizeAmount = prize(msg.sender);
529 			// set the user withdrawal amount
530 			amount = amount.add(prizeAmount);
531 			// refresh withdrawal amount of prize pool
532 			_prizePoolWithdrawn = _prizePoolWithdrawn.add(prizeAmount);
533 			// clear the user's finally bought position amount, so clear the user's final prize
534 			clearPrize(msg.sender);
535 			_winnerCounter = _winnerCounter.sub(1);
536 		}
537 
538 		// 4. send eth
539 		(msg.sender).transfer(amount);
540 	}
541 
542 	function withdrawByCFO(uint256 amount) whenReady() whenNotPaused() onlyCFO() required(companyWallet) public {
543 		require(amount > 0, 'Payoff too samll.');
544 		uint256 max = _global.revenue;
545 		if (_isPrizeActivated == false) { // when haven't sent final prize
546 			// deduct the max final prize pool
547 			max = max.sub(_global.totalRevenue.mul(_config.finalPrizeRates[_config.finalPrizeRates.length.sub(1)]).div(100));
548 		}
549 		require(amount <= max, 'Payoff too big.');
550 
551 		// deduct the withdrawal amount
552 		_global.revenue = _global.revenue.sub(amount);
553 
554 		// send eth
555 		companyWallet.transfer(amount);
556 	}
557 
558 	function withdrawByCFO(address addr) whenReady() whenNotPaused() onlyCFO() onlyContract(addr) required(companyWallet) public {
559 		// send all erc20
560 		require(IERC20(addr).transfer(companyWallet, IERC20(addr).balanceOf(this)));
561 	}
562 
563 	function collectPrizePoolDust() whenReady() whenNotPaused() onlyCOO() public {
564 		// when final prize has been sent, and all winners have received prizes
565 		require(_isPrizeActivated == true, 'Not activited.');
566 		// collect the prize pool dust
567 		if (_winnerCounter == 0 || now > _config.end.add(180 days)) {
568 			_global.revenue = _global.revenue.add(_prizePool.sub(_prizePoolWithdrawn));
569 			_prizePoolWithdrawn = _prizePool;
570 		}
571 	}
572 
573 	function totalUsers() public view returns(uint256) {
574 		return _userAddrBook.length;
575 	}
576 
577 	function getUserAddress(uint256 id) public view returns(address userAddrRet) {
578 		if (id <= _userAddrBook.length && id > 0) {
579 			userAddrRet = _userAddrBook[id.sub(1)];
580 		}
581 	}
582 
583 	function getUserPositionIds(address addr) public view returns(uint256[]) {
584 		return _users[addr].positionIds;
585 	}
586 
587 	function countPositions() public view returns(uint256) {
588 		return _positionBook.length;
589 	}
590 
591 	function getPositions(uint256 id) public view returns(uint256[2] positionsRet) {
592 		if (id <= _positionBook.length && id > 0) {
593 			positionsRet = _positionBook[id.sub(1)];
594 		}
595 	}
596 
597 	function prize(address addr) public view returns(uint256) {
598 		if (_winnerTotalPositionAmount == 0 || _prizePool == 0) {
599 			return 0;
600 		}
601 		return _winnerPositionAmounts[addr].mul(_prizePool).div(_winnerTotalPositionAmount);
602 	}
603 
604 	function clearPrize(address addr) private {
605 		delete _winnerPositionAmounts[addr];
606 	}
607 
608 	function countWinners() public view returns(uint256) {
609 		return _userAddrBook.length.div(100);
610 	}
611 
612 	function allWinners() public view returns(address[]) {
613 		return _winnerPurchaseListForAddr;
614 	}
615 }
616 
617 
618 /**
619  * @title ERC20 interface
620  * @dev see https://github.com/ethereum/EIPs/issues/20
621  */
622 interface IERC20 {
623 	function totalSupply() external view returns(uint256);
624 
625 	function balanceOf(address who) external view returns(uint256);
626 
627 	function allowance(address owner, address spender)
628 	external view returns(uint256);
629 
630 	function transfer(address to, uint256 value) external returns(bool);
631 
632 	function approve(address spender, uint256 value)
633 	external returns(bool);
634 
635 	function transferFrom(address from, address to, uint256 value)
636 	external returns(bool);
637 
638 	event Transfer(
639 		address indexed from,
640 		address indexed to,
641 		uint256 value
642 	);
643 
644 	event Approval(
645 		address indexed owner,
646 		address indexed spender,
647 		uint256 value
648 	);
649 }