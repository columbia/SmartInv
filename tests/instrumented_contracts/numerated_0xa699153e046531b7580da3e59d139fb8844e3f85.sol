1 pragma solidity ^0.5.0;
2 
3 contract UtilFairWin {
4 	/* https://fairwin.me */
5 	uint ethWei = 1 ether;
6 
7 	function getLevel(uint value) public view returns (uint) {
8 		if (value >= 1 * ethWei && value <= 5 * ethWei) {
9 			return 1;
10 		}
11 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
12 			return 2;
13 		}
14 		if (value >= 11 * ethWei && value <= 15 * ethWei) {
15 			return 3;
16 		}
17 		return 0;
18 	}
19 
20 	function getNodeLevel(uint value) public view returns (uint) {
21 		if (value >= 1 * ethWei && value <= 5 * ethWei) {
22 			return 1;
23 		}
24 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
25 			return 2;
26 		}
27 		if (value >= 11 * ethWei) {
28 			return 3;
29 		}
30 		return 0;
31 	}
32 
33 	function getScByLevel(uint level) public pure returns (uint) {
34 		if (level == 1) {
35 			return 5;
36 		}
37 		if (level == 2) {
38 			return 7;
39 		}
40 		if (level == 3) {
41 			return 10;
42 		}
43 		return 0;
44 	}
45 
46 	function getFireScByLevel(uint level) public pure returns (uint) {
47 		if (level == 1) {
48 			return 3;
49 		}
50 		if (level == 2) {
51 			return 6;
52 		}
53 		if (level == 3) {
54 			return 10;
55 		}
56 		return 0;
57 	}
58 
59 	function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint){
60 		if (level == 1 && times == 1) {
61 			return 50;
62 		}
63 		if (level == 2 && times == 1) {
64 			return 70;
65 		}
66 		if (level == 2 && times == 2) {
67 			return 50;
68 		}
69 		if (level == 3) {
70 			if (times == 1) {
71 				return 100;
72 			}
73 			if (times == 2) {
74 				return 70;
75 			}
76 			if (times == 3) {
77 				return 50;
78 			}
79 			if (times >= 4 && times <= 10) {
80 				return 10;
81 			}
82 			if (times >= 11 && times <= 20) {
83 				return 5;
84 			}
85 			if (times >= 21) {
86 				return 1;
87 			}
88 		}
89 		return 0;
90 	}
91 
92 	function compareStr(string memory _str, string memory str) public pure returns (bool) {
93 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
94 			return true;
95 		}
96 		return false;
97 	}
98 }
99 
100 /*
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with GSN meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 contract Context {
111 	/* https://fairwin.me */
112 	// Empty internal constructor, to prevent people from mistakenly deploying
113 	// an instance of this contract, which should be used via inheritance.
114 	constructor() internal {}
115 	// solhint-disable-previous-line no-empty-blocks
116 
117 	function _msgSender() internal view returns (address) {
118 		return msg.sender;
119 	}
120 }
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 contract Ownable is Context {
132 	/* https://fairwin.me */
133 	address private _owner;
134 
135 	/**
136 	 * @dev Initializes the contract setting the deployer as the initial owner.
137 	 */
138 	constructor () internal {
139 		_owner = _msgSender();
140 	}
141 
142 	/**
143 	 * @dev Throws if called by any account other than the owner.
144 	 */
145 	modifier onlyOwner() {
146 		require(isOwner(), "Ownable: caller is not the owner");
147 		_;
148 	}
149 
150 	/**
151 	 * @dev Returns true if the caller is the current owner.
152 	 */
153 	function isOwner() public view returns (bool) {
154 		return _msgSender() == _owner;
155 	}
156 
157 	/**
158 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
159 	 * Can only be called by the current owner.
160 	 */
161 	function transferOwnership(address newOwner) public onlyOwner {
162 		require(newOwner != address(0), "Ownable: new owner is the zero address");
163 		_owner = newOwner;
164 	}
165 }
166 
167 /**
168  * @title Roles
169  * @dev Library for managing addresses assigned to a Role.
170  */
171 library Roles {
172 	/* https://fairwin.me */
173 	struct Role {
174 		mapping(address => bool) bearer;
175 	}
176 
177 	/**
178 	 * @dev Give an account access to this role.
179 	 */
180 	function add(Role storage role, address account) internal {
181 		require(!has(role, account), "Roles: account already has role");
182 		role.bearer[account] = true;
183 	}
184 
185 	/**
186 	 * @dev Remove an account's access to this role.
187 	 */
188 	function remove(Role storage role, address account) internal {
189 		require(has(role, account), "Roles: account does not have role");
190 		role.bearer[account] = false;
191 	}
192 
193 	/**
194 	 * @dev Check if an account has this role.
195 	 * @return bool
196 	 */
197 	function has(Role storage role, address account) internal view returns (bool) {
198 		require(account != address(0), "Roles: account is the zero address");
199 		return role.bearer[account];
200 	}
201 }
202 
203 /**
204  * @title WhitelistAdminRole
205  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
206  */
207 contract WhitelistAdminRole is Context, Ownable {
208 	/* https://fairwin.me */
209 	using Roles for Roles.Role;
210 
211 	Roles.Role private _whitelistAdmins;
212 
213 	constructor () internal {
214 	}
215 
216 	modifier onlyWhitelistAdmin() {
217 		require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
218 		_;
219 	}
220 
221 	function isWhitelistAdmin(address account) public view returns (bool) {
222 		return _whitelistAdmins.has(account) || isOwner();
223 	}
224 
225 	function addWhitelistAdmin(address account) public onlyOwner {
226 		_whitelistAdmins.add(account);
227 	}
228 
229 	function removeWhitelistAdmin(address account) public onlyOwner {
230 		_whitelistAdmins.remove(account);
231 	}
232 }
233 
234 contract FairWin is UtilFairWin, WhitelistAdminRole {
235 	/* https://fairwin.me */
236 	using SafeMath for *;
237 	uint ethWei = 1 ether;
238 	address payable private devAddr = address(0x854D359A586244c9E02B57a3770a4dC21Ffcaa8d);
239 	address payable private comfortAddr = address(0x22068CCB03108E505b27222e18a5D7d51279D10c);
240 
241 	struct User {
242 		uint id;
243 		address userAddress;
244 		uint freeAmount;
245 		uint freezeAmount;
246 		uint lineAmount;
247 		uint inviteAmonut;
248 		uint dayBonusAmount;
249 		uint bonusAmount;
250 		uint level;
251 		uint lineLevel;
252 		uint resTime;
253 		uint investTimes;
254 		string inviteCode;
255 		string beCode;
256 		uint rewardIndex;
257 		uint lastRwTime;
258 	}
259 
260 	struct UserGlobal {
261 		uint id;
262 		address userAddress;
263 		string inviteCode;
264 		string beCode;
265 		uint status;
266 	}
267 
268 	struct AwardData {
269 		uint oneInvAmount;
270 		uint twoInvAmount;
271 		uint threeInvAmount;
272 	}
273 
274 	uint startTime;
275 	uint lineStatus = 0;
276 	mapping(uint => uint) rInvestCount;
277 	mapping(uint => uint) rInvestMoney;
278 	uint period = 1 days;
279 	uint uid = 0;
280 	uint rid = 1;
281 	mapping(uint => uint[]) lineArrayMapping;
282 	mapping(uint => mapping(address => User)) userRoundMapping;
283 	mapping(address => UserGlobal) userMapping;
284 	mapping(string => address) addressMapping;
285 	mapping(uint => address) indexMapping;
286 	mapping(uint => mapping(address => mapping(uint => AwardData))) userAwardDataMapping;
287 	uint bonuslimit = 15 ether;
288 	uint sendLimit = 100 ether;
289 	uint withdrawLimit = 15 ether;
290 	uint canImport = 1;
291 	uint canSetStartTime = 1;
292 
293 	modifier isHuman() {
294 		address addr = msg.sender;
295 		uint codeLength;
296 		assembly {codeLength := extcodesize(addr)}
297 		require(codeLength == 0, "sorry humans only");
298 		require(tx.origin == msg.sender, "sorry, humans only");
299 		_;
300 	}
301 
302 	constructor () public {
303 	}
304 
305 	function() external payable {
306 	}
307 
308 	function verydangerous(uint time) external onlyOwner {
309 		require(canSetStartTime == 1, "verydangerous, limited!");
310 		require(time > now, "no, verydangerous");
311 		startTime = time;
312 		canSetStartTime = 0;
313 	}
314 
315 	function donnotimitate() public view returns (bool) {
316 		return startTime != 0 && now > startTime;
317 	}
318 
319 	function updateLine(uint line) external onlyWhitelistAdmin {
320 		lineStatus = line;
321 	}
322 
323 	function isLine() private view returns (bool) {
324 		return lineStatus != 0;
325 	}
326 
327 	function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external onlyOwner {
328 		require(bonusLi >= 15 ether && sendLi >= 100 ether && withdrawLi >= 15 ether, "invalid amount");
329 		bonuslimit = bonusLi;
330 		sendLimit = sendLi;
331 		withdrawLimit = withdrawLi;
332 	}
333 
334 	function stopImport() external onlyOwner {
335 		canImport = 0;
336 	}
337 
338 	function actUserStatus(address addr, uint status) external onlyWhitelistAdmin {
339 		require(status == 0 || status == 1 || status == 2, "bad parameter status");
340 		UserGlobal storage userGlobal = userMapping[addr];
341 		userGlobal.status = status;
342 	}
343 
344 	function exit(string memory inviteCode, string memory beCode) public isHuman() payable {
345 		require(donnotimitate(), "no, donnotimitate");
346 		require(msg.value >= 1 * ethWei && msg.value <= 15 * ethWei, "between 1 and 15");
347 		require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
348 
349 		UserGlobal storage userGlobal = userMapping[msg.sender];
350 		if (userGlobal.id == 0) {
351 			require(!compareStr(inviteCode, "") && bytes(inviteCode).length == 6, "invalid invite code");
352 			address beCodeAddr = addressMapping[beCode];
353 			require(isUsed(beCode), "beCode not exist");
354 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
355 			require(!isUsed(inviteCode), "invite code is used");
356 			registerUser(msg.sender, inviteCode, beCode);
357 		}
358 		uint investAmout;
359 		uint lineAmount;
360 		if (isLine()) {
361 			lineAmount = msg.value;
362 		} else {
363 			investAmout = msg.value;
364 		}
365 		User storage user = userRoundMapping[rid][msg.sender];
366 		if (user.id != 0) {
367 			require(user.freezeAmount.add(user.lineAmount) == 0, "only once invest");
368 			user.freezeAmount = investAmout;
369 			user.lineAmount = lineAmount;
370 			user.level = getLevel(user.freezeAmount);
371 			user.lineLevel = getNodeLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount));
372 		} else {
373 			user.id = userGlobal.id;
374 			user.userAddress = msg.sender;
375 			user.freezeAmount = investAmout;
376 			user.level = getLevel(investAmout);
377 			user.lineAmount = lineAmount;
378 			user.lineLevel = getNodeLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount));
379 			user.inviteCode = userGlobal.inviteCode;
380 			user.beCode = userGlobal.beCode;
381 		}
382 
383 		rInvestCount[rid] = rInvestCount[rid].add(1);
384 		rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
385 		if (!isLine()) {
386 			sendFeetoAdmin(msg.value);
387 			countBonus(user.userAddress);
388 		} else {
389 			lineArrayMapping[rid].push(user.id);
390 		}
391 	}
392 
393 	function importGlobal(address addr, string calldata inviteCode, string calldata beCode) external onlyWhitelistAdmin {
394 		require(canImport == 1, "import stopped");
395 		UserGlobal storage user = userMapping[addr];
396 		require(user.id == 0, "user already exists");
397 		require(!compareStr(inviteCode, ""), "empty invite code");
398 		if (uid != 0) {
399 			require(!compareStr(beCode, ""), "empty beCode");
400 		}
401 		address beCodeAddr = addressMapping[beCode];
402 		require(beCodeAddr != addr, "beCodeAddr can't be self");
403 		require(!isUsed(inviteCode), "invite code is used");
404 
405 		registerUser(addr, inviteCode, beCode);
406 	}
407 
408 	function helloworld(uint start, uint end, uint isUser) external onlyWhitelistAdmin {
409 		for (uint i = start; i <= end; i++) {
410 			uint userId = 0;
411 			if (isUser == 0) {
412 				userId = lineArrayMapping[rid][i];
413 			} else {
414 				userId = i;
415 			}
416 			address userAddr = indexMapping[userId];
417 			User storage user = userRoundMapping[rid][userAddr];
418 			if (user.freezeAmount == 0 && user.lineAmount >= 1 ether && user.lineAmount <= 15 ether) {
419 				user.freezeAmount = user.lineAmount;
420 				user.level = getLevel(user.freezeAmount);
421 				user.lineAmount = 0;
422 				sendFeetoAdmin(user.freezeAmount);
423 				countBonus(user.userAddress);
424 			}
425 		}
426 	}
427 
428 	function countBonus(address userAddr) private {
429 		User storage user = userRoundMapping[rid][userAddr];
430 		if (user.id == 0) {
431 			return;
432 		}
433 		uint scale = getScByLevel(user.level);
434 		user.dayBonusAmount = user.freezeAmount.mul(scale).div(1000);
435 		user.investTimes = 0;
436 		UserGlobal memory userGlobal = userMapping[userAddr];
437 		if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && userGlobal.status == 0) {
438 			getaway(user.beCode, user.freezeAmount, scale);
439 		}
440 	}
441 
442 	function getaway(string memory beCode, uint money, uint shareSc) private {
443 		string memory tmpReferrer = beCode;
444 
445 		for (uint i = 1; i <= 25; i++) {
446 			if (compareStr(tmpReferrer, "")) {
447 				break;
448 			}
449 			address tmpUserAddr = addressMapping[tmpReferrer];
450 			UserGlobal storage userGlobal = userMapping[tmpUserAddr];
451 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
452 
453 			if (calUser.freezeAmount.add(calUser.freeAmount).add(calUser.lineAmount) == 0) {
454 				tmpReferrer = userGlobal.beCode;
455 				continue;
456 			}
457 
458 			uint recommendSc = getRecommendScaleByLevelAndTim(3, i);
459 			uint moneyResult = 0;
460 			if (money <= 15 ether) {
461 				moneyResult = money;
462 			} else {
463 				moneyResult = 15 ether;
464 			}
465 
466 			if (recommendSc != 0) {
467 				uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(recommendSc);
468 				tmpDynamicAmount = tmpDynamicAmount.div(1000).div(100);
469 				earneth(userGlobal.userAddress, tmpDynamicAmount, calUser.rewardIndex, i);
470 			}
471 			tmpReferrer = userGlobal.beCode;
472 		}
473 	}
474 
475 	function earneth(address userAddr, uint dayInvAmount, uint rewardIndex, uint times) private {
476 		for (uint i = 0; i < 5; i++) {
477 			AwardData storage awData = userAwardDataMapping[rid][userAddr][rewardIndex.add(i)];
478 			if (times == 1) {
479 				awData.oneInvAmount += dayInvAmount;
480 			}
481 			if (times == 2) {
482 				awData.twoInvAmount += dayInvAmount;
483 			}
484 			awData.threeInvAmount += dayInvAmount;
485 		}
486 	}
487 
488 	function happy() public isHuman() {
489 		require(donnotimitate(), "no donnotimitate");
490 		User storage user = userRoundMapping[rid][msg.sender];
491 		require(user.id != 0, "user not exist");
492 		uint sendMoney = user.freeAmount + user.lineAmount;
493 		bool isEnough = false;
494 		uint resultMoney = 0;
495 
496 		(isEnough, resultMoney) = isEnoughBalance(sendMoney);
497 
498 		if (resultMoney > 0 && resultMoney <= withdrawLimit) {
499 			sendMoneyToUser(msg.sender, resultMoney);
500 			user.freeAmount = 0;
501 			user.lineAmount = 0;
502 			user.lineLevel = getNodeLevel(user.freezeAmount);
503 		}
504 	}
505 
506 	function christmas(uint start, uint end) external onlyWhitelistAdmin {
507 		for (uint i = start; i <= end; i++) {
508 			address userAddr = indexMapping[i];
509 			User storage user = userRoundMapping[rid][userAddr];
510 			UserGlobal memory userGlobal = userMapping[userAddr];
511 			if (now.sub(user.lastRwTime) <= 12 hours) {
512 				continue;
513 			}
514 			user.lastRwTime = now;
515 			if (userGlobal.status == 1) {
516 				user.rewardIndex = user.rewardIndex.add(1);
517 				continue;
518 			}
519 			uint bonusSend = 0;
520 			if (user.id != 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
521 				if (user.investTimes < 5) {
522 					bonusSend += user.dayBonusAmount;
523 					user.bonusAmount = user.bonusAmount.add(bonusSend);
524 					user.investTimes = user.investTimes.add(1);
525 				} else {
526 					user.freeAmount = user.freeAmount.add(user.freezeAmount);
527 					user.freezeAmount = 0;
528 					user.dayBonusAmount = 0;
529 					user.level = 0;
530 				}
531 			}
532 			uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
533 			if (lineAmount < 1 ether || lineAmount > withdrawLimit) {
534 				user.rewardIndex = user.rewardIndex.add(1);
535 				continue;
536 			}
537 			uint inviteSend = 0;
538 			if (userGlobal.status == 0) {
539 				AwardData memory awData = userAwardDataMapping[rid][userAddr][user.rewardIndex];
540 				user.rewardIndex = user.rewardIndex.add(1);
541 				uint lineValue = lineAmount.div(ethWei);
542 				if (lineValue >= 15) {
543 					inviteSend += awData.threeInvAmount;
544 				} else {
545 					if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) {
546 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
547 					}
548 					if (user.lineLevel == 2 && lineAmount >= 6 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
549 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
550 						inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
551 					}
552 					if (user.lineLevel == 3 && lineAmount >= 11 ether && awData.threeInvAmount > 0) {
553 						inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
554 					}
555 					if (user.lineLevel < 3) {
556 						uint fireSc = getFireScByLevel(user.lineLevel);
557 						inviteSend = inviteSend.mul(fireSc).div(10);
558 					}
559 				}
560 			} else if (userGlobal.status == 2) {
561 				user.rewardIndex = user.rewardIndex.add(1);
562 			}
563 
564 			if (bonusSend.add(inviteSend) <= sendLimit) {
565 				user.inviteAmonut = user.inviteAmonut.add(inviteSend);
566 				bool isEnough = false;
567 				uint resultMoney = 0;
568 				(isEnough, resultMoney) = isEnoughBalance(bonusSend.add(inviteSend));
569 				if (resultMoney > 0) {
570 					uint confortMoney = resultMoney.div(10);
571 					sendMoneyToUser(comfortAddr, confortMoney);
572 					resultMoney = resultMoney.sub(confortMoney);
573 					address payable sendAddr = address(uint160(userAddr));
574 					sendMoneyToUser(sendAddr, resultMoney);
575 				}
576 			}
577 		}
578 	}
579 
580 	function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
581 		if (sendMoney >= address(this).balance) {
582 			return (false, address(this).balance);
583 		} else {
584 			return (true, sendMoney);
585 		}
586 	}
587 
588 	function sendFeetoAdmin(uint amount) private {
589 		devAddr.transfer(amount.div(25));
590 	}
591 
592 	function sendMoneyToUser(address payable userAddress, uint money) private {
593 		if (money > 0) {
594 			userAddress.transfer(money);
595 		}
596 	}
597 
598 	function isUsed(string memory code) public view returns (bool) {
599 		address addr = addressMapping[code];
600 		return uint(addr) != 0;
601 	}
602 
603 	function getUserAddressByCode(string memory code) public view returns (address) {
604 		require(isWhitelistAdmin(msg.sender), "Permission denied");
605 		return addressMapping[code];
606 	}
607 
608 	function registerUser(address addr, string memory inviteCode, string memory beCode) private {
609 		UserGlobal storage userGlobal = userMapping[addr];
610 		uid++;
611 		userGlobal.id = uid;
612 		userGlobal.userAddress = addr;
613 		userGlobal.inviteCode = inviteCode;
614 		userGlobal.beCode = beCode;
615 
616 		addressMapping[inviteCode] = addr;
617 		indexMapping[uid] = addr;
618 	}
619 
620 	function endRound() external onlyOwner {
621 		require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
622 		rid++;
623 		startTime = now.add(period).div(1 days).mul(1 days);
624 		canSetStartTime = 1;
625 	}
626 
627 	function donnottouch() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
628 		return (
629 		rid,
630 		uid,
631 		startTime,
632 		rInvestCount[rid],
633 		rInvestMoney[rid],
634 		bonuslimit,
635 		sendLimit,
636 		withdrawLimit,
637 		canImport,
638 		lineStatus,
639 		lineArrayMapping[rid].length,
640 		canSetStartTime
641 		);
642 	}
643 
644 	function getUserByAddress(address addr, uint roundId) public view returns (uint[14] memory info, string memory inviteCode, string memory beCode) {
645 		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
646 
647 		if (roundId == 0) {
648 			roundId = rid;
649 		}
650 
651 		UserGlobal memory userGlobal = userMapping[addr];
652 		User memory user = userRoundMapping[roundId][addr];
653 		info[0] = userGlobal.id;
654 		info[1] = user.lineAmount;
655 		info[2] = user.freeAmount;
656 		info[3] = user.freezeAmount;
657 		info[4] = user.inviteAmonut;
658 		info[5] = user.bonusAmount;
659 		info[6] = user.lineLevel;
660 		info[7] = user.dayBonusAmount;
661 		info[8] = user.rewardIndex;
662 		info[9] = user.investTimes;
663 		info[10] = user.level;
664 		uint grantAmount = 0;
665 		if (user.id > 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && user.investTimes < 5 && userGlobal.status != 1) {
666 			grantAmount += user.dayBonusAmount;
667 		}
668 		if (userGlobal.status == 0) {
669 			uint inviteSend = 0;
670 			AwardData memory awData = userAwardDataMapping[rid][user.userAddress][user.rewardIndex];
671 			uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
672 			if (lineAmount >= 1 ether) {
673 				uint lineValue = lineAmount.div(ethWei);
674 				if (lineValue >= 15) {
675 					inviteSend += awData.threeInvAmount;
676 				} else {
677 					if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) {
678 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
679 					}
680 					if (user.lineLevel == 2 && lineAmount >= 1 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
681 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
682 						inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
683 					}
684 					if (user.lineLevel == 3 && lineAmount >= 1 ether && awData.threeInvAmount > 0) {
685 						inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
686 					}
687 					if (user.lineLevel < 3) {
688 						uint fireSc = getFireScByLevel(user.lineLevel);
689 						inviteSend = inviteSend.mul(fireSc).div(10);
690 					}
691 				}
692 				grantAmount += inviteSend;
693 			}
694 		}
695 		info[11] = grantAmount;
696 		info[12] = user.lastRwTime;
697 		info[13] = userGlobal.status;
698 
699 		return (info, userGlobal.inviteCode, userGlobal.beCode);
700 	}
701 
702 	function getUserAddressById(uint id) public view returns (address) {
703 		require(isWhitelistAdmin(msg.sender), "Permission denied");
704 		return indexMapping[id];
705 	}
706 
707 	function getLineUserId(uint index, uint rouId) public view returns (uint) {
708 		require(isWhitelistAdmin(msg.sender), "Permission denied");
709 		if (rouId == 0) {
710 			rouId = rid;
711 		}
712 		return lineArrayMapping[rid][index];
713 	}
714 }
715 
716 /**
717 * @title SafeMath
718 * @dev Math operations with safety checks that revert on error
719 */
720 library SafeMath {
721 	/* https://fairwin.me */
722 	/**
723 	* @dev Multiplies two numbers, reverts on overflow.
724 	*/
725 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
726 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
727 		// benefit is lost if 'b' is also tested.
728 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
729 		if (a == 0) {
730 			return 0;
731 		}
732 
733 		uint256 c = a * b;
734 		require(c / a == b, "mul overflow");
735 
736 		return c;
737 	}
738 
739 	/**
740 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
741 	*/
742 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
743 		require(b > 0, "div zero");
744 		// Solidity only automatically asserts when dividing by 0
745 		uint256 c = a / b;
746 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
747 
748 		return c;
749 	}
750 
751 	/**
752 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
753 	*/
754 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
755 		require(b <= a, "lower sub bigger");
756 		uint256 c = a - b;
757 
758 		return c;
759 	}
760 
761 	/**
762 	* @dev Adds two numbers, reverts on overflow.
763 	*/
764 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
765 		uint256 c = a + b;
766 		require(c >= a, "overflow");
767 
768 		return c;
769 	}
770 
771 	/**
772 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
773 	* reverts when dividing by zero.
774 	*/
775 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
776 		require(b != 0, "mod zero");
777 		return a % b;
778 	}
779 
780 	/**
781 	* @dev compare two numbers and returns the smaller one.
782 	*/
783 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
784 		return a > b ? b : a;
785 	}
786 }