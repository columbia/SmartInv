1 pragma solidity ^0.5.16;
2 
3 contract UtilECG {
4 	/* https://ecg.club */
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
17 		if (value >= 16 * ethWei && value <= 30 * ethWei) {
18 			return 4;
19 		}
20 		return 0;
21 	}
22 
23 	function getScByLevel(uint level) public pure returns (uint) {
24 		if (level == 1) {
25 			return 5;
26 		}
27 		if (level == 2) {
28 			return 7;
29 		}
30 		if (level == 3) {
31 			return 10;
32 		}
33 		if (level == 4) {
34 			return 12;
35 		}
36 		return 0;
37 	}
38 
39 	function getFireScByLevel(uint level) public pure returns (uint) {
40 		if (level == 1) {
41 			return 3;
42 		}
43 		if (level == 2) {
44 			return 5;
45 		}
46 		if (level == 3) {
47 			return 7;
48 		}
49 		if (level == 4) {
50 			return 10;
51 		}
52 		return 0;
53 	}
54 
55 	function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint) {
56 		if (level == 1 && times == 1) {
57 			return 20;
58 		}
59 		if (level == 2 && times == 1) {
60 			return 20;
61 		}
62 		if (level == 2 && times == 2) {
63 			return 15;
64 		}
65 		if (level == 3) {
66 			if (times == 1) {
67 				return 20;
68 			}
69 			if (times == 2) {
70 				return 15;
71 			}
72 			if (times == 3) {
73 				return 10;
74 			}
75 		}
76 		if (level == 4) {
77 			if (times == 1) {
78 				return 20;
79 			}
80 			if (times == 2) {
81 				return 15;
82 			}
83 			if (times >= 3 && times <= 5) {
84 				return 10;
85 			}
86 		}
87 		if (level == 5) {
88 			if (times == 1) {
89 				return 30;
90 			}
91 			if (times == 2) {
92 				return 15;
93 			}
94 			if (times >= 3 && times <= 5) {
95 				return 10;
96 			}
97 		}
98 		if (level == 6) {
99 			if (times == 1) {
100 				return 50;
101 			}
102 			if (times == 2) {
103 				return 15;
104 			}
105 			if (times >= 3 && times <= 5) {
106 				return 10;
107 			}
108 			if (times >= 6 && times <= 10) {
109 				return 3;
110 			}
111 		}
112 		if (level == 7) {
113 			if (times == 1) {
114 				return 100;
115 			}
116 			if (times == 2) {
117 				return 15;
118 			}
119 			if (times >= 3 && times <= 5) {
120 				return 10;
121 			}
122 			if (times >= 6 && times <= 10) {
123 				return 3;
124 			}
125 			if (times >= 11 && times <= 15) {
126 				return 2;
127 			}
128 			if (times >= 16 && times <= 20) {
129 				return 1;
130 			}
131 		}
132 		return 0;
133 	}
134 
135 	function compareStr(string memory _str, string memory str) public pure returns (bool) {
136 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
137 			return true;
138 		}
139 		return false;
140 	}
141 
142 	function getEndTims(uint value) public view returns (uint) {
143 		if (value >= 1 * ethWei && value <= 5 * ethWei) {
144 			return 15;
145 		}
146 		if (value >= 6 * ethWei && value <= 10 * ethWei) {
147 			return 20;
148 		}
149 		if (value >= 11 * ethWei && value <= 15 * ethWei) {
150 			return 25;
151 		}
152 		if (value >= 16 * ethWei && value <= 30 * ethWei) {
153 			return 30;
154 		}
155 		return 0;
156 	}
157 }
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 contract Context {
170 	// Empty internal constructor, to prevent people from mistakenly deploying
171 	// an instance of this contract, which should be used via inheritance.
172 	constructor() internal {}
173 	// solhint-disable-previous-line no-empty-blocks
174 
175 	function _msgSender() internal view returns (address) {
176 		return msg.sender;
177 	}
178 }
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * This module is used through inheritance. It will make available the modifier
186  * `onlyOwner`, which can be applied to your functions to restrict their use to
187  * the owner.
188  */
189 contract Ownable is Context {
190 	/* https://ecg.club */
191 	address private _owner;
192 	address private nextOwner;
193 
194 	/**
195 	 * @dev Initializes the contract setting the deployer as the initial owner.
196 	 */
197 	constructor () internal {
198 		_owner = _msgSender();
199 	}
200 
201 	/**
202 	 * @dev Throws if called by any account other than the owner.
203 	 */
204 	modifier onlyOwner() {
205 		require(isOwner(), "Ownable: caller is not the owner");
206 		_;
207 	}
208 
209 	/**
210 	 * @dev Returns true if the caller is the current owner.
211 	 */
212 	function isOwner() public view returns (bool) {
213 		return _msgSender() == _owner;
214 	}
215 
216 	// Standard contract ownership transfer implementation,
217 	function approveNextOwner(address _nextOwner) external onlyOwner {
218 		require(_nextOwner != _owner, "Cannot approve current owner.");
219 		nextOwner = _nextOwner;
220 	}
221 
222 	function acceptNextOwner() external {
223 		require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
224 		_owner = nextOwner;
225 	}
226 }
227 
228 /**
229  * @title Roles
230  * @dev Library for managing addresses assigned to a Role.
231  */
232 library Roles {
233 	struct Role {
234 		mapping(address => bool) bearer;
235 	}
236 
237 	/**
238 	 * @dev Give an account access to this role.
239 	 */
240 	function add(Role storage role, address account) internal {
241 		require(!has(role, account), "Roles: account already has role");
242 		role.bearer[account] = true;
243 	}
244 
245 	/**
246 	 * @dev Remove an account's access to this role.
247 	 */
248 	function remove(Role storage role, address account) internal {
249 		require(has(role, account), "Roles: account does not have role");
250 		role.bearer[account] = false;
251 	}
252 
253 	/**
254 	 * @dev Check if an account has this role.
255 	 * @return bool
256 	 */
257 	function has(Role storage role, address account) internal view returns (bool) {
258 		require(account != address(0), "Roles: account is the zero address");
259 		return role.bearer[account];
260 	}
261 }
262 
263 /**
264  * @title WhitelistAdminRole
265  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
266  */
267 contract WhitelistAdminRole is Context, Ownable {
268 	/* https://ecg.club */
269 	using Roles for Roles.Role;
270 
271 	Roles.Role private _whitelistAdmins;
272 
273 	constructor () internal {
274 	}
275 
276 	modifier onlyWhitelistAdmin() {
277 		require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
278 		_;
279 	}
280 
281 	function isWhitelistAdmin(address account) public view returns (bool) {
282 		return _whitelistAdmins.has(account) || isOwner();
283 	}
284 
285 	function addWhitelistAdmin(address account) public onlyOwner {
286 		_whitelistAdmins.add(account);
287 	}
288 
289 	function removeWhitelistAdmin(address account) public onlyOwner {
290 		_whitelistAdmins.remove(account);
291 	}
292 }
293 
294 contract ECG is UtilECG, WhitelistAdminRole {
295 	/* https://ecg.club */
296 	using SafeMath for *;
297 
298 	uint ethWei = 1 ether;
299 
300 	address payable private devAddr = address(0xFbfE04C8aB7F64854122a9Aa4671e7f8C6409992);
301 
302 	address payable private comfortAddr = address(0xB3601e883F90F823ae1486178c7a8467993Cb9c6);
303 
304 	struct User {
305 		uint id;
306 		address userAddress;
307 		uint userType;
308 		uint freezeAmount;
309 		uint freeAmount;
310 		uint inviteAmonut;
311 		uint shareAmount;
312 		uint bonusAmount;
313 		uint dayBonAmount;
314 		uint dayInvAmount;
315 		uint level;
316 		uint resTime;
317 		string inviteCode;
318 		string beCode;
319 		uint allAward;
320 		uint lastRwTime;
321 		uint investTimes;
322 		uint[] branchUid;
323 	}
324 
325 	struct UserGlobal {
326 		uint id;
327 		address userAddress;
328 		string inviteCode;
329 		string beCode;
330 		uint status;
331 	}
332 
333 	uint startTime;
334 	mapping(uint => uint) rInvestCount;
335 	mapping(uint => uint) rInvestMoney;
336 	uint period = 1 days;
337 	uint uid = 0;
338 	uint rid = 1;
339 	mapping(uint => mapping(address => User)) userRoundMapping;
340 	mapping(address => UserGlobal) userMapping;
341 	mapping(string => address) addressMapping;
342 	mapping(uint => address) indexMapping;
343 	uint bonuslimit = 30 ether;
344 	uint sendLimit = 100 ether;
345 	uint withdrawLimit = 30 ether;
346 	uint canSetStartTime = 1;
347 
348 	modifier isHuman() {
349 		address addr = msg.sender;
350 		uint codeLength;
351 		assembly {codeLength := extcodesize(addr)}
352 		require(codeLength == 0, "sorry, humans only");
353 		require(tx.origin == msg.sender, "sorry, humans only");
354 		_;
355 	}
356 
357 	constructor (address _addr, string memory inviteCode) public {
358 		registerUser(_addr, inviteCode, "");
359 	}
360 
361 	function() external payable {
362 	}
363 
364 	function door(uint time) external onlyOwner {
365 		require(canSetStartTime == 1, "can not set start time again");
366 		require(time > now, "invalid game start time");
367 		startTime = time;
368 		canSetStartTime = 0;
369 	}
370 
371 	function sorrow(address payable _dev, address payable _com) external onlyOwner {
372 		devAddr = _dev;
373 		comfortAddr = _com;
374 	}
375 
376 	function isGameStarted() public view returns (bool) {
377 		return startTime != 0 && now > startTime;
378 	}
379 
380 	function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external onlyOwner {
381 		require(bonusLi >= 30 ether && sendLi >= 100 ether && withdrawLi >= 30 ether, "invalid amount");
382 		bonuslimit = bonusLi;
383 		sendLimit = sendLi;
384 		withdrawLimit = withdrawLi;
385 	}
386 
387 	function believe(address addr, uint status) external onlyWhitelistAdmin {
388 		require(status == 0 || status == 1 || status == 2, "bad parameter status");
389 		UserGlobal storage userGlobal = userMapping[addr];
390 		userGlobal.status = status;
391 	}
392 
393 	function quit(string memory inviteCode, string memory beCode, uint userType) public isHuman() payable {
394 		require(isGameStarted(), "game not start");
395 		require(msg.value >= 1 * ethWei && msg.value <= 30 * ethWei, "between 1 and 30");
396 		require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
397 		require(userType == 1 || userType == 2, "invalid userType");
398 		UserGlobal storage userGlobal = userMapping[msg.sender];
399 		if (userGlobal.id == 0) {
400 			require(!compareStr(inviteCode, "      ") && bytes(inviteCode).length == 6, "invalid invite code");
401 			address beCodeAddr = addressMapping[beCode];
402 			require(isUsed(beCode), "beCode not exist");
403 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
404 			require(!isUsed(inviteCode), "invite code is used");
405 			registerUser(msg.sender, inviteCode, beCode);
406 		}
407 
408 		User storage user = userRoundMapping[rid][msg.sender];
409 		if (user.id != 0) {
410 			require(user.freezeAmount.add(msg.value) <= 30 ether, "No more than 30");
411 			if (user.freezeAmount == 0) {
412 				user.userType = userType;
413 				user.allAward = 0;
414 				user.resTime = now;
415 				user.lastRwTime = now;
416 			}
417 			user.freezeAmount = user.freezeAmount.add(msg.value);
418 			user.level = getLevel(user.freezeAmount);
419 		} else {
420 			user.id = userGlobal.id;
421 			user.userAddress = msg.sender;
422 			user.freezeAmount = msg.value;
423 			user.level = getLevel(msg.value);
424 			user.inviteCode = userGlobal.inviteCode;
425 			user.beCode = userGlobal.beCode;
426 			user.userType = userType;
427 			user.resTime = now;
428 			user.lastRwTime = now;
429 			address beCodeAddr = addressMapping[userGlobal.beCode];
430 			User storage calUser = userRoundMapping[rid][beCodeAddr];
431 			if (calUser.id != 0) {
432 				calUser.branchUid.push(userGlobal.id);
433 			}
434 		}
435 		rInvestCount[rid] = rInvestCount[rid].add(1);
436 		rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
437 		express(msg.value);
438 		mix(user.userAddress, msg.value);
439 	}
440 
441 	function appreciate() external isHuman() {
442 		require(isGameStarted(), "game not start");
443 		User storage user = userRoundMapping[rid][msg.sender];
444 		require(user.id != 0 && user.freeAmount >= 1 ether, "user not exist && User has no freeAmount");
445 		bool isEnough = false;
446 		uint resultMoney = 0;
447 
448 		(isEnough, resultMoney) = isEnoughBalance(user.freeAmount);
449 
450 		if (resultMoney > 0 && resultMoney <= withdrawLimit) {
451 			sendMoneyToUser(msg.sender, resultMoney);
452 			user.freeAmount = 0;
453 		}
454 	}
455 
456 	function snowman(uint userType) external {
457 		User storage user = userRoundMapping[rid][msg.sender];
458 		require(user.id != 0, "user does not exist");
459 		require(userType == 1 || userType == 2, "invalid userType");
460 		require(user.userType != userType, "Same state");
461 		require(user.freezeAmount > 0, "freezeAmount must be greater than 0");
462 		if (user.userType == 1 && userType == 2) {
463 			user.userType = 2;
464 			user.investTimes = 0;
465 			user.resTime = now;
466 			address tmpUserAddr = addressMapping[user.beCode];
467 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
468 			UserGlobal storage userGlobal = userMapping[msg.sender];
469 			UserGlobal storage calUserGlobal = userMapping[tmpUserAddr];
470 			if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 && calUserGlobal.status == 0) {
471 				bool isOut = false;
472 				uint resultSend = 0;
473 				(isOut, resultSend) = longfellow(tmpUserAddr, user.freezeAmount.div(10));
474 				sendToAddr(resultSend, tmpUserAddr);
475 				calUser.shareAmount = calUser.shareAmount.add(resultSend);
476 				if (!isOut) {
477 					calUser.allAward = calUser.allAward.add(resultSend);
478 				}
479 			}
480 		}
481 		if (user.userType == 2 && userType == 1) {
482 			require((user.allAward.add(ethWei.mul(5).div(4))) <= user.freezeAmount, "Less reward than principal 5/4 ether");
483 			uint balance = user.freezeAmount.sub(user.allAward);
484 			require(balance <= 30 ether, "invalid amount");
485 			balance = balance.mul(4).div(5);
486 			user.userType = 1;
487 			user.investTimes = 0;
488 			user.freezeAmount = balance.div(ethWei).mul(ethWei);
489 			user.level = getLevel(user.freezeAmount);
490 			uint scale = getScByLevel(user.level);
491 			user.dayInvAmount = 0;
492 			user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
493 			user.allAward = 0;
494 		}
495 	}
496 
497 	function mix(address userAddr, uint investAmount) private {
498 		User storage user = userRoundMapping[rid][userAddr];
499 		if (user.id == 0) {
500 			return;
501 		}
502 		uint scale = getScByLevel(user.level);
503 		user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
504 		user.investTimes = 0;
505 		address tmpUserAddr = addressMapping[user.beCode];
506 		User storage calUser = userRoundMapping[rid][tmpUserAddr];
507 		UserGlobal storage userGlobal = userMapping[userAddr];
508 		UserGlobal storage calUserGlobal = userMapping[tmpUserAddr];
509 		if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && user.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 && calUserGlobal.status == 0) {
510 			bool isOut = false;
511 			uint resultSend = 0;
512 			(isOut, resultSend) = longfellow(calUser.userAddress, investAmount.div(10));
513 			sendToAddr(resultSend, calUser.userAddress);
514 			calUser.shareAmount = calUser.shareAmount.add(resultSend);
515 			if (!isOut) {
516 				calUser.allAward = calUser.allAward.add(resultSend);
517 			}
518 		}
519 	}
520 
521 	function donate() external isHuman {
522 		contribute(msg.sender);
523 	}
524 
525 	function road(uint start, uint end) external onlyWhitelistAdmin {
526 		for (uint i = end; i >= start; i--) {
527 			address userAddr = indexMapping[i];
528 			contribute(userAddr);
529 		}
530 	}
531 
532 	function contribute(address addr) private {
533 		require(isGameStarted(), "game not start");
534 		User storage user = userRoundMapping[rid][addr];
535 		UserGlobal memory userGlobal = userMapping[addr];
536 		if (isWhitelistAdmin(msg.sender)) {
537 			if (now.sub(user.lastRwTime) <= 23 hours.add(58 minutes) || user.id == 0 || userGlobal.id == 0) {
538 				return;
539 			}
540 		} else {
541 			require(user.id > 0, "Users of the game are not betting in this round");
542 			require(now.sub(user.lastRwTime) >= 23 hours.add(58 minutes), "Can only be extracted once in 24 hours");
543 		}
544 		user.lastRwTime = now;
545 		if (userGlobal.status == 1) {
546 			return;
547 		}
548 		uint awardSend = 0;
549 		uint scale = getScByLevel(user.level);
550 		uint freezeAmount = user.freezeAmount;
551 		if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
552 			if ((user.userType == 1 && user.investTimes < 5) || user.userType == 2) {
553 				awardSend = awardSend.add(user.dayBonAmount);
554 				user.bonusAmount = user.bonusAmount.add(user.dayBonAmount);
555 				if (user.userType == 1) {
556 					user.investTimes = user.investTimes.add(1);
557 				}
558 			}
559 			if (user.userType == 1 && user.investTimes >= 5) {
560 				user.freeAmount = user.freeAmount.add(user.freezeAmount);
561 				user.freezeAmount = 0;
562 				user.dayBonAmount = 0;
563 				user.level = 0;
564 				user.userType = 0;
565 			}
566 		}
567 		if (awardSend == 0) {
568 			return;
569 		}
570 		if (userGlobal.status == 0 && user.userType == 2) {
571 			awardSend = awardSend.add(user.dayInvAmount);
572 			user.inviteAmonut = user.inviteAmonut.add(user.dayInvAmount);
573 		}
574 		if (awardSend > 0 && awardSend <= sendLimit) {
575 			bool isOut = false;
576 			uint resultSend = 0;
577 			(isOut, resultSend) = longfellow(addr, awardSend);
578 			if (user.dayInvAmount > 0) {
579 				user.dayInvAmount = 0;
580 			}
581 			sendToAddr(resultSend, addr);
582 			if (resultSend > 0) {
583 				if (!isOut) {
584 					user.allAward = user.allAward.add(awardSend);
585 				}
586 				if(userGlobal.status == 0) {
587 					over(user.beCode, freezeAmount, scale, user.resTime);
588 				}
589 			}
590 		}
591 	}
592 
593 	function over(string memory beCode, uint money, uint shareSc, uint userTime) private {
594 		string memory tmpReferrer = beCode;
595 		for (uint i = 1; i <= 20; i++) {
596 			if (compareStr(tmpReferrer, "")) {
597 				break;
598 			}
599 			address tmpUserAddr = addressMapping[tmpReferrer];
600 			UserGlobal storage userGlobal = userMapping[tmpUserAddr];
601 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
602 
603 			if (userGlobal.status != 0 || calUser.freezeAmount == 0 || calUser.resTime > userTime || calUser.userType != 2) {
604 				tmpReferrer = userGlobal.beCode;
605 				continue;
606 			}
607 			uint fireSc = getFireScByLevel(calUser.level);
608 			uint recommendSc = getRecommendScaleByLevelAndTim(getUserLevel(tmpUserAddr), i);
609 			uint moneyResult = 0;
610 			if (money <= calUser.freezeAmount) {
611 				moneyResult = money;
612 			} else {
613 				moneyResult = calUser.freezeAmount;
614 			}
615 
616 			if (recommendSc != 0) {
617 				uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(recommendSc).mul(fireSc);
618 				tmpDynamicAmount = tmpDynamicAmount.div(1000).div(100).div(10);
619 				calUser.dayInvAmount = calUser.dayInvAmount.add(tmpDynamicAmount);
620 			}
621 			tmpReferrer = userGlobal.beCode;
622 		}
623 	}
624 
625 	function getUserLevel(address _addr) private view returns (uint) {
626 		User storage user = userRoundMapping[rid][_addr];
627 		uint count = 0;
628 		for (uint i = 0; i < user.branchUid.length; i++) {
629 			address addr = indexMapping[user.branchUid[i]];
630 			if (uint(addr) != 0) {
631 				User memory countUser = userRoundMapping[rid][addr];
632 				if (countUser.level >= 3) {
633 					count++;
634 				}
635 			}
636 		}
637 		if (count >= 10) {
638 			return 7;
639 		}
640 		if (count >= 5) {
641 			return 6;
642 		}
643 		if (count >= 3) {
644 			return 5;
645 		}
646 		return user.level;
647 	}
648 
649 	function longfellow(address _addr, uint sendMoney) private returns (bool isOut, uint resultSend) {
650 		User storage user = userRoundMapping[rid][_addr];
651 		if (user.userType == 1 || user.userType == 0) {
652 			return (false, sendMoney);
653 		}
654 		uint resultAmount = user.freezeAmount.mul(getEndTims(user.freezeAmount)).div(10);
655 		if (user.allAward.add(sendMoney) >= resultAmount) {
656 			isOut = true;
657 			if (resultAmount <= user.allAward) {
658 				resultSend = 0;
659 			} else {
660 				resultSend = resultAmount.sub(user.allAward);
661 			}
662 			user.dayBonAmount = 0;
663 			user.level = 0;
664 			user.freezeAmount = 0;
665 			user.allAward = 0;
666 			user.userType = 0;
667 			user.dayInvAmount = 0;
668 		} else {
669 			resultSend = sendMoney;
670 		}
671 		return (isOut, resultSend);
672 	}
673 
674 	function sendToAddr(uint sendAmount, address addr) private {
675 		bool isEnough = false;
676 		uint resultMoney = 0;
677 		(isEnough, resultMoney) = isEnoughBalance(sendAmount);
678 		if (resultMoney > 0 && resultMoney <= sendLimit) {
679 			uint rand = uint256(keccak256(abi.encodePacked(block.number, now))).mod(16);
680 			uint confortMoney = resultMoney.div(100).mul(rand);
681 			sendMoneyToUser(comfortAddr, confortMoney);
682 			resultMoney = resultMoney.sub(confortMoney);
683 			address payable sendAddr = address(uint160(addr));
684 			sendMoneyToUser(sendAddr, resultMoney);
685 		}
686 	}
687 
688 	function isEnoughBalance(uint sendMoney) private view returns (bool, uint) {
689 		if (address(this).balance >= sendMoney) {
690 			return (true, sendMoney);
691 		} else {
692 			return (false, address(this).balance);
693 		}
694 	}
695 
696 	function getGameInfo() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint) {
697 		return (
698 		rid,
699 		uid,
700 		startTime,
701 		rInvestCount[rid],
702 		rInvestMoney[rid],
703 		bonuslimit,
704 		sendLimit,
705 		withdrawLimit,
706 		canSetStartTime
707 		);
708 	}
709 
710 	function griffith(address addr, uint roundId) public view returns (uint[16] memory info, string memory inviteCode, string memory beCode) {
711 		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
712 
713 		if (roundId == 0) {
714 			roundId = rid;
715 		}
716 
717 		UserGlobal memory userGlobal = userMapping[addr];
718 		User memory user = userRoundMapping[roundId][addr];
719 		info[0] = userGlobal.id;
720 		info[1] = user.freezeAmount;
721 		info[2] = user.inviteAmonut;
722 		info[3] = user.bonusAmount;
723 		info[4] = user.dayBonAmount;
724 		info[5] = user.level;
725 		info[6] = user.dayInvAmount;
726 		info[7] = user.lastRwTime;
727 		info[8] = userGlobal.status;
728 		info[9] = user.allAward;
729 		info[10] = user.userType;
730 		info[11] = user.shareAmount;
731 		info[12] = user.freeAmount;
732 		info[13] = user.branchUid.length;
733 		info[14] = user.investTimes;
734 		info[15] = user.resTime;
735 		return (info, userGlobal.inviteCode, userGlobal.beCode);
736 	}
737 
738 	function express(uint amount) private {
739 		devAddr.transfer(amount.div(10));
740 	}
741 
742 	function sendMoneyToUser(address payable userAddress, uint money) private {
743 		if (money > 0) {
744 			userAddress.transfer(money);
745 		}
746 	}
747 
748 	function isUsed(string memory code) public view returns (bool) {
749 		address addr = addressMapping[code];
750 		return uint(addr) != 0;
751 	}
752 
753 	function getUserAddressByCode(string memory code) public view returns (address) {
754 		require(isWhitelistAdmin(msg.sender), "Permission denied");
755 		return addressMapping[code];
756 	}
757 
758 	function registerUser(address addr, string memory inviteCode, string memory beCode) private {
759 		UserGlobal storage userGlobal = userMapping[addr];
760 		uid++;
761 		userGlobal.id = uid;
762 		userGlobal.userAddress = addr;
763 		userGlobal.inviteCode = inviteCode;
764 		userGlobal.beCode = beCode;
765 
766 		addressMapping[inviteCode] = addr;
767 		indexMapping[uid] = addr;
768 	}
769 
770 	function endRound() external onlyOwner {
771 		require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
772 		rid++;
773 		startTime = now.add(period).div(1 days).mul(1 days);
774 		canSetStartTime = 1;
775 	}
776 
777 	function getUserAddressById(uint id) public view returns (address) {
778 		require(isWhitelistAdmin(msg.sender));
779 		return indexMapping[id];
780 	}
781 }
782 
783 /**
784 * @title SafeMath
785 * @dev Math operations with safety checks that revert on error
786 */
787 library SafeMath {
788 	/**
789 	* @dev Multiplies two numbers, reverts on overflow.
790 	*/
791 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
792 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
793 		// benefit is lost if 'b' is also tested.
794 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
795 		if (a == 0) {
796 			return 0;
797 		}
798 
799 		uint256 c = a * b;
800 		require(c / a == b, "mul overflow");
801 
802 		return c;
803 	}
804 
805 	/**
806 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
807 	*/
808 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
809 		require(b > 0, "div zero");
810 		// Solidity only automatically asserts when dividing by 0
811 		uint256 c = a / b;
812 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
813 
814 		return c;
815 	}
816 
817 	/**
818 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
819 	*/
820 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
821 		require(b <= a, "lower sub bigger");
822 		uint256 c = a - b;
823 
824 		return c;
825 	}
826 
827 	/**
828 	* @dev Adds two numbers, reverts on overflow.
829 	*/
830 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
831 		uint256 c = a + b;
832 		require(c >= a, "overflow");
833 
834 		return c;
835 	}
836 
837 	/**
838 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
839 	* reverts when dividing by zero.
840 	*/
841 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
842 		require(b != 0, "mod zero");
843 		return a % b;
844 	}
845 
846 	/**
847 	* @dev compare two numbers and returns the smaller one.
848 	*/
849 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
850 		return a > b ? b : a;
851 	}
852 }