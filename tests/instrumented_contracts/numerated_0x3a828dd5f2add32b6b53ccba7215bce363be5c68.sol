1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-03
3 */
4 pragma solidity ^0.5.0;
5 
6 contract UtilGmGm {
7 	/* https://gmgm.me */
8 	uint ethWei = 1 ether;
9 
10 	function getLevel(uint value) public view returns (uint) {
11 		if (value >= 1 * ethWei && value <= 5 * ethWei) {
12 			return 1;
13 		}
14 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
15 			return 2;
16 		}
17 		if (value >= 11 * ethWei && value <= 15 * ethWei) {
18 			return 3;
19 		}
20 		return 0;
21 	}
22 
23 	function getNodeLevel(uint value) public view returns (uint) {
24 		if (value >= 1 * ethWei && value <= 5 * ethWei) {
25 			return 1;
26 		}
27 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
28 			return 2;
29 		}
30 		if (value >= 11 * ethWei) {
31 			return 3;
32 		}
33 		return 0;
34 	}
35 
36 	function getScByLevel(uint level) public pure returns (uint) {
37 		if (level == 1) {
38 			return 5;
39 		}
40 		if (level == 2) {
41 			return 7;
42 		}
43 		if (level == 3) {
44 			return 10;
45 		}
46 		return 0;
47 	}
48 
49 	function getFireScByLevel(uint level) public pure returns (uint) {
50 		if (level == 1) {
51 			return 3;
52 		}
53 		if (level == 2) {
54 			return 6;
55 		}
56 		if (level == 3) {
57 			return 10;
58 		}
59 		return 0;
60 	}
61 
62 	function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint){
63 		if (level == 1 && times == 1) {
64 			return 50;
65 		}
66 		if (level == 2 && times == 1) {
67 			return 70;
68 		}
69 		if (level == 2 && times == 2) {
70 			return 50;
71 		}
72 		if (level == 3) {
73 			if (times == 1) {
74 				return 100;
75 			}
76 			if (times == 2) {
77 				return 70;
78 			}
79 			if (times == 3) {
80 				return 50;
81 			}
82 			if (times >= 4 && times <= 10) {
83 				return 10;
84 			}
85 			if (times >= 11 && times <= 20) {
86 				return 5;
87 			}
88 			if (times >= 21) {
89 				return 1;
90 			}
91 		}
92 		return 0;
93 	}
94 
95 	function compareStr(string memory _str, string memory str) public pure returns (bool) {
96 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
97 			return true;
98 		}
99 		return false;
100 	}
101 }
102 
103 /*
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with GSN meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 contract Context {
114 	/* https://gmgm.me */
115 	// Empty internal constructor, to prevent people from mistakenly deploying
116 	// an instance of this contract, which should be used via inheritance.
117 	constructor() internal {}
118 	// solhint-disable-previous-line no-empty-blocks
119 
120 	function _msgSender() internal view returns (address) {
121 		return msg.sender;
122 	}
123 }
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 contract Ownable is Context {
135 	/* https://gmgm.me */
136 	address private _owner;
137 
138 	/**
139 	 * @dev Initializes the contract setting the deployer as the initial owner.
140 	 */
141 	constructor () internal {
142 		_owner = _msgSender();
143 	}
144 
145 	/**
146 	 * @dev Throws if called by any account other than the owner.
147 	 */
148 	modifier onlyOwner() {
149 		require(isOwner(), "Ownable: caller is not the owner");
150 		_;
151 	}
152 
153 	/**
154 	 * @dev Returns true if the caller is the current owner.
155 	 */
156 	function isOwner() public view returns (bool) {
157 		return _msgSender() == _owner;
158 	}
159 
160 	/**
161 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
162 	 * Can only be called by the current owner.
163 	 */
164 	function transferOwnership(address newOwner) public onlyOwner {
165 		require(newOwner != address(0), "Ownable: new owner is the zero address");
166 		_owner = newOwner;
167 	}
168 }
169 
170 /**
171  * @title Roles
172  * @dev Library for managing addresses assigned to a Role.
173  */
174 library Roles {
175 	/* https://gmgm.me */
176 	struct Role {
177 		mapping(address => bool) bearer;
178 	}
179 
180 	/**
181 	 * @dev Give an account access to this role.
182 	 */
183 	function add(Role storage role, address account) internal {
184 		require(!has(role, account), "Roles: account already has role");
185 		role.bearer[account] = true;
186 	}
187 
188 	/**
189 	 * @dev Remove an account's access to this role.
190 	 */
191 	function remove(Role storage role, address account) internal {
192 		require(has(role, account), "Roles: account does not have role");
193 		role.bearer[account] = false;
194 	}
195 
196 	/**
197 	 * @dev Check if an account has this role.
198 	 * @return bool
199 	 */
200 	function has(Role storage role, address account) internal view returns (bool) {
201 		require(account != address(0), "Roles: account is the zero address");
202 		return role.bearer[account];
203 	}
204 }
205 
206 /**
207  * @title WhitelistAdminRole
208  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
209  */
210 contract WhitelistAdminRole is Context, Ownable {
211 	/* https://gmgm.me */
212 	using Roles for Roles.Role;
213 
214 	Roles.Role private _whitelistAdmins;
215 
216 	constructor () internal {
217 	}
218 
219 	modifier onlyWhitelistAdmin() {
220 		require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
221 		_;
222 	}
223 
224 	function isWhitelistAdmin(address account) public view returns (bool) {
225 		return _whitelistAdmins.has(account) || isOwner();
226 	}
227 
228 	function addWhitelistAdmin(address account) public onlyOwner {
229 		_whitelistAdmins.add(account);
230 	}
231 
232 	function removeWhitelistAdmin(address account) public onlyOwner {
233 		_whitelistAdmins.remove(account);
234 	}
235 }
236 
237 contract GmGm is UtilGmGm, WhitelistAdminRole {
238 	/* https://gmgm.me */
239 	using SafeMath for *;
240 	uint ethWei = 1 ether;
241 	address payable private devAddr = address(0x2C0C7A6F10EfD5d3f95f4552F37a4588042FEf2C);
242 	address payable private comfortAddr = address(0x56aBA59b8d532d24F6b5Ee10E9B9d4dD7162b42a);
243 
244 	struct User {
245 		uint id;
246 		address userAddress;
247 		uint freeAmount;
248 		uint freezeAmount;
249 		uint lineAmount;
250 		uint inviteAmonut;
251 		uint dayBonusAmount;
252 		uint bonusAmount;
253 		uint level;
254 		uint lineLevel;
255 		uint resTime;
256 		uint investTimes;
257 		string inviteCode;
258 		string beCode;
259 		uint rewardIndex;
260 		uint lastRwTime;
261 	}
262 
263 	struct UserGlobal {
264 		uint id;
265 		address userAddress;
266 		string inviteCode;
267 		string beCode;
268 		uint status;
269 	}
270 
271 	struct AwardData {
272 		uint oneInvAmount;
273 		uint twoInvAmount;
274 		uint threeInvAmount;
275 	}
276 
277 	uint startTime;
278 	uint lineStatus = 0;
279 	mapping(uint => uint) rInvestCount;
280 	mapping(uint => uint) rInvestMoney;
281 	uint period = 1 days;
282 	uint uid = 0;
283 	uint rid = 1;
284 	mapping(uint => uint[]) lineArrayMapping;
285 	mapping(uint => mapping(address => User)) userRoundMapping;
286 	mapping(address => UserGlobal) userMapping;
287 	mapping(string => address) addressMapping;
288 	mapping(uint => address) indexMapping;
289 	mapping(uint => mapping(address => mapping(uint => AwardData))) userAwardDataMapping;
290 	uint bonuslimit = 15 ether;
291 	uint sendLimit = 100 ether;
292 	uint withdrawLimit = 15 ether;
293 	uint canImport = 1;
294 	uint canSetStartTime = 1;
295 
296 	modifier isHuman() {
297 		address addr = msg.sender;
298 		uint codeLength;
299 		assembly {codeLength := extcodesize(addr)}
300 		require(codeLength == 0, "sorry humans only");
301 		require(tx.origin == msg.sender, "sorry, humans only");
302 		_;
303 	}
304 
305 	constructor () public {
306 	}
307 
308 	function() external payable {
309 	}
310 
311 	function verydangerous(uint time) external onlyOwner {
312 		require(canSetStartTime == 1, "verydangerous, limited!");
313 		require(time > now, "no, verydangerous");
314 		startTime = time;
315 		canSetStartTime = 0;
316 	}
317 
318 	function donnotimitate() public view returns (bool) {
319 		return startTime != 0 && now > startTime;
320 	}
321 
322 	function updateLine(uint line) external onlyWhitelistAdmin {
323 		lineStatus = line;
324 	}
325 
326 	function isLine() private view returns (bool) {
327 		return lineStatus != 0;
328 	}
329 
330 	function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external onlyOwner {
331 		require(bonusLi >= 15 ether && sendLi >= 100 ether && withdrawLi >= 15 ether, "invalid amount");
332 		bonuslimit = bonusLi;
333 		sendLimit = sendLi;
334 		withdrawLimit = withdrawLi;
335 	}
336 
337 	function stopImport() external onlyOwner {
338 		canImport = 0;
339 	}
340 
341 	function actUserStatus(address addr, uint status) external onlyWhitelistAdmin {
342 		require(status == 0 || status == 1 || status == 2, "bad parameter status");
343 		UserGlobal storage userGlobal = userMapping[addr];
344 		userGlobal.status = status;
345 	}
346 
347 	function exit(string memory inviteCode, string memory beCode) public isHuman() payable {
348 		require(donnotimitate(), "no, donnotimitate");
349 		require(msg.value >= 1 * ethWei && msg.value <= 15 * ethWei, "between 1 and 15");
350 		require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
351 
352 		UserGlobal storage userGlobal = userMapping[msg.sender];
353 		if (userGlobal.id == 0) {
354 			require(!compareStr(inviteCode, "") && bytes(inviteCode).length == 6, "invalid invite code");
355 			address beCodeAddr = addressMapping[beCode];
356 			require(isUsed(beCode), "beCode not exist");
357 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
358 			require(!isUsed(inviteCode), "invite code is used");
359 			registerUser(msg.sender, inviteCode, beCode);
360 		}
361 		uint investAmout;
362 		uint lineAmount;
363 		if (isLine()) {
364 			lineAmount = msg.value;
365 		} else {
366 			investAmout = msg.value;
367 		}
368 		User storage user = userRoundMapping[rid][msg.sender];
369 		if (user.id != 0) {
370 			require(user.freezeAmount.add(user.lineAmount) == 0, "only once invest");
371 			user.freezeAmount = investAmout;
372 			user.lineAmount = lineAmount;
373 			user.level = getLevel(user.freezeAmount);
374 			user.lineLevel = getNodeLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount));
375 		} else {
376 			user.id = userGlobal.id;
377 			user.userAddress = msg.sender;
378 			user.freezeAmount = investAmout;
379 			user.level = getLevel(investAmout);
380 			user.lineAmount = lineAmount;
381 			user.lineLevel = getNodeLevel(user.freezeAmount.add(user.freeAmount).add(user.lineAmount));
382 			user.inviteCode = userGlobal.inviteCode;
383 			user.beCode = userGlobal.beCode;
384 		}
385 
386 		rInvestCount[rid] = rInvestCount[rid].add(1);
387 		rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
388 		if (!isLine()) {
389 			sendFeetoAdmin(msg.value);
390 			countBonus(user.userAddress);
391 		} else {
392 			lineArrayMapping[rid].push(user.id);
393 		}
394 	}
395 
396 	function importGlobal(address addr, string calldata inviteCode, string calldata beCode) external onlyWhitelistAdmin {
397 		require(canImport == 1, "import stopped");
398 		UserGlobal storage user = userMapping[addr];
399 		require(user.id == 0, "user already exists");
400 		require(!compareStr(inviteCode, ""), "empty invite code");
401 		if (uid != 0) {
402 			require(!compareStr(beCode, ""), "empty beCode");
403 		}
404 		address beCodeAddr = addressMapping[beCode];
405 		require(beCodeAddr != addr, "beCodeAddr can't be self");
406 		require(!isUsed(inviteCode), "invite code is used");
407 
408 		registerUser(addr, inviteCode, beCode);
409 	}
410 
411 	function helloworld(uint start, uint end, uint isUser) external onlyWhitelistAdmin {
412 		for (uint i = start; i <= end; i++) {
413 			uint userId = 0;
414 			if (isUser == 0) {
415 				userId = lineArrayMapping[rid][i];
416 			} else {
417 				userId = i;
418 			}
419 			address userAddr = indexMapping[userId];
420 			User storage user = userRoundMapping[rid][userAddr];
421 			if (user.freezeAmount == 0 && user.lineAmount >= 1 ether && user.lineAmount <= 15 ether) {
422 				user.freezeAmount = user.lineAmount;
423 				user.level = getLevel(user.freezeAmount);
424 				user.lineAmount = 0;
425 				sendFeetoAdmin(user.freezeAmount);
426 				countBonus(user.userAddress);
427 			}
428 		}
429 	}
430 
431 	function countBonus(address userAddr) private {
432 		User storage user = userRoundMapping[rid][userAddr];
433 		if (user.id == 0) {
434 			return;
435 		}
436 		uint scale = getScByLevel(user.level);
437 		user.dayBonusAmount = user.freezeAmount.mul(scale).div(1000);
438 		user.investTimes = 0;
439 		UserGlobal memory userGlobal = userMapping[userAddr];
440 		if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && userGlobal.status == 0) {
441 			getaway(user.beCode, user.freezeAmount, scale);
442 		}
443 	}
444 
445 	function getaway(string memory beCode, uint money, uint shareSc) private {
446 		string memory tmpReferrer = beCode;
447 
448 		for (uint i = 1; i <= 25; i++) {
449 			if (compareStr(tmpReferrer, "")) {
450 				break;
451 			}
452 			address tmpUserAddr = addressMapping[tmpReferrer];
453 			UserGlobal storage userGlobal = userMapping[tmpUserAddr];
454 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
455 
456 			if (calUser.freezeAmount.add(calUser.freeAmount).add(calUser.lineAmount) == 0) {
457 				tmpReferrer = userGlobal.beCode;
458 				continue;
459 			}
460 
461 			uint recommendSc = getRecommendScaleByLevelAndTim(3, i);
462 			uint moneyResult = 0;
463 			if (money <= 15 ether) {
464 				moneyResult = money;
465 			} else {
466 				moneyResult = 15 ether;
467 			}
468 
469 			if (recommendSc != 0) {
470 				uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(recommendSc);
471 				tmpDynamicAmount = tmpDynamicAmount.div(1000).div(100);
472 				earneth(userGlobal.userAddress, tmpDynamicAmount, calUser.rewardIndex, i);
473 			}
474 			tmpReferrer = userGlobal.beCode;
475 		}
476 	}
477 
478 	function earneth(address userAddr, uint dayInvAmount, uint rewardIndex, uint times) private {
479 		for (uint i = 0; i < 5; i++) {
480 			AwardData storage awData = userAwardDataMapping[rid][userAddr][rewardIndex.add(i)];
481 			if (times == 1) {
482 				awData.oneInvAmount += dayInvAmount;
483 			}
484 			if (times == 2) {
485 				awData.twoInvAmount += dayInvAmount;
486 			}
487 			awData.threeInvAmount += dayInvAmount;
488 		}
489 	}
490 
491 	function happy() public isHuman() {
492 		require(donnotimitate(), "no donnotimitate");
493 		User storage user = userRoundMapping[rid][msg.sender];
494 		require(user.id != 0, "user not exist");
495 		uint sendMoney = user.freeAmount + user.lineAmount;
496 		bool isEnough = false;
497 		uint resultMoney = 0;
498 
499 		(isEnough, resultMoney) = isEnoughBalance(sendMoney);
500 
501 		if (resultMoney > 0 && resultMoney <= withdrawLimit) {
502 			sendMoneyToUser(msg.sender, resultMoney);
503 			user.freeAmount = 0;
504 			user.lineAmount = 0;
505 			user.lineLevel = getNodeLevel(user.freezeAmount);
506 		}
507 	}
508 
509 	function christmas(uint start, uint end) external onlyWhitelistAdmin {
510 		for (uint i = start; i <= end; i++) {
511 			address userAddr = indexMapping[i];
512 			User storage user = userRoundMapping[rid][userAddr];
513 			UserGlobal memory userGlobal = userMapping[userAddr];
514 			if (now.sub(user.lastRwTime) <= 12 hours) {
515 				continue;
516 			}
517 			user.lastRwTime = now;
518 			if (userGlobal.status == 1) {
519 				user.rewardIndex = user.rewardIndex.add(1);
520 				continue;
521 			}
522 			uint bonusSend = 0;
523 			if (user.id != 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
524 				if (user.investTimes < 5) {
525 					bonusSend += user.dayBonusAmount;
526 					user.bonusAmount = user.bonusAmount.add(bonusSend);
527 					user.investTimes = user.investTimes.add(1);
528 				} else {
529 					user.freeAmount = user.freeAmount.add(user.freezeAmount);
530 					user.freezeAmount = 0;
531 					user.dayBonusAmount = 0;
532 					user.level = 0;
533 				}
534 			}
535 			uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
536 			if (lineAmount < 1 ether || lineAmount > withdrawLimit) {
537 				user.rewardIndex = user.rewardIndex.add(1);
538 				continue;
539 			}
540 			uint inviteSend = 0;
541 			if (userGlobal.status == 0) {
542 				AwardData memory awData = userAwardDataMapping[rid][userAddr][user.rewardIndex];
543 				user.rewardIndex = user.rewardIndex.add(1);
544 				uint lineValue = lineAmount.div(ethWei);
545 				if (lineValue >= 15) {
546 					inviteSend += awData.threeInvAmount;
547 				} else {
548 					if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) {
549 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
550 					}
551 					if (user.lineLevel == 2 && lineAmount >= 6 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
552 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
553 						inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
554 					}
555 					if (user.lineLevel == 3 && lineAmount >= 11 ether && awData.threeInvAmount > 0) {
556 						inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
557 					}
558 					if (user.lineLevel < 3) {
559 						uint fireSc = getFireScByLevel(user.lineLevel);
560 						inviteSend = inviteSend.mul(fireSc).div(10);
561 					}
562 				}
563 			} else if (userGlobal.status == 2) {
564 				user.rewardIndex = user.rewardIndex.add(1);
565 			}
566 
567 			if (bonusSend.add(inviteSend) <= sendLimit) {
568 				user.inviteAmonut = user.inviteAmonut.add(inviteSend);
569 				bool isEnough = false;
570 				uint resultMoney = 0;
571 				(isEnough, resultMoney) = isEnoughBalance(bonusSend.add(inviteSend));
572 				if (resultMoney > 0) {
573 					uint confortMoney = resultMoney.div(10);
574 					sendMoneyToUser(comfortAddr, confortMoney);
575 					resultMoney = resultMoney.sub(confortMoney);
576 					address payable sendAddr = address(uint160(userAddr));
577 					sendMoneyToUser(sendAddr, resultMoney);
578 				}
579 			}
580 		}
581 	}
582 
583 	function isEnoughBalance(uint sendMoney) private view returns (bool, uint){
584 		if (sendMoney >= address(this).balance) {
585 			return (false, address(this).balance);
586 		} else {
587 			return (true, sendMoney);
588 		}
589 	}
590 
591 	function sendFeetoAdmin(uint amount) private {
592 		devAddr.transfer(amount.div(25));
593 	}
594 
595 	function sendMoneyToUser(address payable userAddress, uint money) private {
596 		if (money > 0) {
597 			userAddress.transfer(money);
598 		}
599 	}
600 
601 	function isUsed(string memory code) public view returns (bool) {
602 		address addr = addressMapping[code];
603 		return uint(addr) != 0;
604 	}
605 
606 	function getUserAddressByCode(string memory code) public view returns (address) {
607 		require(isWhitelistAdmin(msg.sender), "Permission denied");
608 		return addressMapping[code];
609 	}
610 
611 	function registerUser(address addr, string memory inviteCode, string memory beCode) private {
612 		UserGlobal storage userGlobal = userMapping[addr];
613 		uid++;
614 		userGlobal.id = uid;
615 		userGlobal.userAddress = addr;
616 		userGlobal.inviteCode = inviteCode;
617 		userGlobal.beCode = beCode;
618 
619 		addressMapping[inviteCode] = addr;
620 		indexMapping[uid] = addr;
621 	}
622 
623 	function endRound() external onlyOwner {
624 		require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
625 		rid++;
626 		startTime = now.add(period).div(1 days).mul(1 days);
627 		canSetStartTime = 1;
628 	}
629 
630 	function donnottouch() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint, uint) {
631 		return (
632 		rid,
633 		uid,
634 		startTime,
635 		rInvestCount[rid],
636 		rInvestMoney[rid],
637 		bonuslimit,
638 		sendLimit,
639 		withdrawLimit,
640 		canImport,
641 		lineStatus,
642 		lineArrayMapping[rid].length,
643 		canSetStartTime
644 		);
645 	}
646 
647 	function getUserByAddress(address addr, uint roundId) public view returns (uint[14] memory info, string memory inviteCode, string memory beCode) {
648 		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
649 
650 		if (roundId == 0) {
651 			roundId = rid;
652 		}
653 
654 		UserGlobal memory userGlobal = userMapping[addr];
655 		User memory user = userRoundMapping[roundId][addr];
656 		info[0] = userGlobal.id;
657 		info[1] = user.lineAmount;
658 		info[2] = user.freeAmount;
659 		info[3] = user.freezeAmount;
660 		info[4] = user.inviteAmonut;
661 		info[5] = user.bonusAmount;
662 		info[6] = user.lineLevel;
663 		info[7] = user.dayBonusAmount;
664 		info[8] = user.rewardIndex;
665 		info[9] = user.investTimes;
666 		info[10] = user.level;
667 		uint grantAmount = 0;
668 		if (user.id > 0 && user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit && user.investTimes < 5 && userGlobal.status != 1) {
669 			grantAmount += user.dayBonusAmount;
670 		}
671 		if (userGlobal.status == 0) {
672 			uint inviteSend = 0;
673 			AwardData memory awData = userAwardDataMapping[rid][user.userAddress][user.rewardIndex];
674 			uint lineAmount = user.freezeAmount.add(user.freeAmount).add(user.lineAmount);
675 			if (lineAmount >= 1 ether) {
676 				uint lineValue = lineAmount.div(ethWei);
677 				if (lineValue >= 15) {
678 					inviteSend += awData.threeInvAmount;
679 				} else {
680 					if (user.lineLevel == 1 && lineAmount >= 1 ether && awData.oneInvAmount > 0) {
681 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).div(2);
682 					}
683 					if (user.lineLevel == 2 && lineAmount >= 1 ether && (awData.oneInvAmount > 0 || awData.twoInvAmount > 0)) {
684 						inviteSend += awData.oneInvAmount.div(15).mul(lineValue).mul(7).div(10);
685 						inviteSend += awData.twoInvAmount.div(15).mul(lineValue).mul(5).div(7);
686 					}
687 					if (user.lineLevel == 3 && lineAmount >= 1 ether && awData.threeInvAmount > 0) {
688 						inviteSend += awData.threeInvAmount.div(15).mul(lineValue);
689 					}
690 					if (user.lineLevel < 3) {
691 						uint fireSc = getFireScByLevel(user.lineLevel);
692 						inviteSend = inviteSend.mul(fireSc).div(10);
693 					}
694 				}
695 				grantAmount += inviteSend;
696 			}
697 		}
698 		info[11] = grantAmount;
699 		info[12] = user.lastRwTime;
700 		info[13] = userGlobal.status;
701 
702 		return (info, userGlobal.inviteCode, userGlobal.beCode);
703 	}
704 
705 	function getUserAddressById(uint id) public view returns (address) {
706 		require(isWhitelistAdmin(msg.sender), "Permission denied");
707 		return indexMapping[id];
708 	}
709 
710 	function getLineUserId(uint index, uint rouId) public view returns (uint) {
711 		require(isWhitelistAdmin(msg.sender), "Permission denied");
712 		if (rouId == 0) {
713 			rouId = rid;
714 		}
715 		return lineArrayMapping[rid][index];
716 	}
717 }
718 
719 /**
720 * @title SafeMath
721 * @dev Math operations with safety checks that revert on error
722 */
723 library SafeMath {
724 	/* https://gmgm.me */
725 	/**
726 	* @dev Multiplies two numbers, reverts on overflow.
727 	*/
728 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
729 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
730 		// benefit is lost if 'b' is also tested.
731 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
732 		if (a == 0) {
733 			return 0;
734 		}
735 
736 		uint256 c = a * b;
737 		require(c / a == b, "mul overflow");
738 
739 		return c;
740 	}
741 
742 	/**
743 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
744 	*/
745 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
746 		require(b > 0, "div zero");
747 		// Solidity only automatically asserts when dividing by 0
748 		uint256 c = a / b;
749 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
750 
751 		return c;
752 	}
753 
754 	/**
755 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
756 	*/
757 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
758 		require(b <= a, "lower sub bigger");
759 		uint256 c = a - b;
760 
761 		return c;
762 	}
763 
764 	/**
765 	* @dev Adds two numbers, reverts on overflow.
766 	*/
767 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
768 		uint256 c = a + b;
769 		require(c >= a, "overflow");
770 
771 		return c;
772 	}
773 
774 	/**
775 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
776 	* reverts when dividing by zero.
777 	*/
778 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
779 		require(b != 0, "mod zero");
780 		return a % b;
781 	}
782 
783 	/**
784 	* @dev compare two numbers and returns the smaller one.
785 	*/
786 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
787 		return a > b ? b : a;
788 	}
789 }