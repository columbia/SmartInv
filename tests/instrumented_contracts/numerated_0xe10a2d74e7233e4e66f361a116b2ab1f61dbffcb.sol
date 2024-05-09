1 pragma solidity ^0.5.17;
2 
3 /* https://elgame.cc */
4 contract Context {
5 	// Empty internal constructor, to prevent people from mistakenly deploying
6 	// an instance of this contract, which should be used via inheritance.
7 	constructor() internal {}
8 	// solhint-disable-previous-line no-empty-blocks
9 
10 	function _msgSender() internal view returns (address) {
11 		return msg.sender;
12 	}
13 }
14 
15 /**
16  * @dev Contract module which provides a basic access control mechanism, where
17  * there is an account (an owner) that can be granted exclusive access to
18  * specific functions.
19  *
20  * This module is used through inheritance. It will make available the modifier
21  * `onlyOwner`, which can be applied to your functions to restrict their use to
22  * the owner.
23  */
24 contract Ownable is Context {
25 	/* https://elgame.cc */
26 	address private _owner;
27 	address private nextOwner;
28 
29 	/**
30 	 * @dev Initializes the contract setting the deployer as the initial owner.
31 	 */
32 	constructor () internal {
33 		_owner = _msgSender();
34 	}
35 
36 	/**
37 	 * @dev Throws if called by any account other than the owner.
38 	 */
39 	modifier onlyOwner() {
40 		require(isOwner(), "Ownable: caller is not the owner");
41 		_;
42 	}
43 
44 	/**
45 	 * @dev Returns true if the caller is the current owner.
46 	 */
47 	function isOwner() public view returns (bool) {
48 		return _msgSender() == _owner;
49 	}
50 
51 	// Standard contract ownership transfer implementation,
52 	function approveNextOwner(address _nextOwner) external onlyOwner {
53 		require(_nextOwner != _owner, "Cannot approve current owner.");
54 		nextOwner = _nextOwner;
55 	}
56 
57 	function acceptNextOwner() external {
58 		require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
59 		_owner = nextOwner;
60 	}
61 }
62 
63 /**
64  * @title Roles
65  * @dev Library for managing addresses assigned to a Role.
66  */
67 library Roles {
68 	struct Role {
69 		mapping(address => bool) bearer;
70 	}
71 
72 	/**
73 	 * @dev Give an account access to this role.
74 	 */
75 	function add(Role storage role, address account) internal {
76 		require(!has(role, account), "Roles: account already has role");
77 		role.bearer[account] = true;
78 	}
79 
80 	/**
81 	 * @dev Remove an account's access to this role.
82 	 */
83 	function remove(Role storage role, address account) internal {
84 		require(has(role, account), "Roles: account does not have role");
85 		role.bearer[account] = false;
86 	}
87 
88 	/**
89 	 * @dev Check if an account has this role.
90 	 * @return bool
91 	 */
92 	function has(Role storage role, address account) internal view returns (bool) {
93 		require(account != address(0), "Roles: account is the zero address");
94 		return role.bearer[account];
95 	}
96 }
97 
98 /**
99  * @title WhitelistAdminRole
100  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
101  */
102 contract WhitelistAdminRole is Context, Ownable {
103 	/* https://elgame.cc */
104 	using Roles for Roles.Role;
105 
106 	Roles.Role private _whitelistAdmins;
107 
108 	constructor () internal {
109 	}
110 
111 	modifier onlyWhitelistAdmin() {
112 		require(isWhitelistAdmin(_msgSender()) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
113 		_;
114 	}
115 
116 	function isWhitelistAdmin(address account) public view returns (bool) {
117 		return _whitelistAdmins.has(account) || isOwner();
118 	}
119 
120 	function addWhitelistAdmin(address account) public onlyOwner {
121 		_whitelistAdmins.add(account);
122 	}
123 
124 	function removeWhitelistAdmin(address account) public onlyOwner {
125 		_whitelistAdmins.remove(account);
126 	}
127 }
128 
129 contract ELG is WhitelistAdminRole {
130 	/* https://elgame.cc */
131 	using SafeMath for *;
132 	uint ethWei = 1 ether;
133 
134 	address payable private devAddr = address(0x1dACD4B4837Fa90b343F6fe97BB87Fa7b21C034C);
135 
136 	address payable private comfortAddr = address(0xC0b314fd11F79fEDfDE8318686034ed60AD309a3);
137 
138 	struct User {
139 		uint id;
140 		address userAddress;
141 		uint userType;
142 		uint freezeAmount;
143 		uint freeAmount;
144 		uint inviteAmonut;
145 		uint shareAmount;
146 		uint bonusAmount;
147 		uint dayBonAmount;
148 		uint dayInvAmount;
149 		uint level;
150 		uint resTime;
151 		string inviteCode;
152 		string beCode;
153 		uint allAward;
154 		uint lastRwTime;
155 		uint investTimes;
156 		uint[] branchUid;
157 		uint staticTims;
158 	}
159 
160 	struct UserGlobal {
161 		uint id;
162 		address userAddress;
163 		string inviteCode;
164 		string beCode;
165 		uint status;
166 	}
167 
168 	uint startTime;
169 	mapping(uint => uint) rInvestCount;
170 	mapping(uint => uint) rInvestMoney;
171 	uint period = 1 days;
172 	uint uid = 0;
173 	uint rid = 1;
174 	mapping(uint => mapping(address => User)) userRoundMapping;
175 	mapping(address => UserGlobal) userMapping;
176 	mapping(string => address) addressMapping;
177 	mapping(uint => address) indexMapping;
178 	uint bonuslimit = 30 ether;
179 	uint sendLimit = 100 ether;
180 	uint withdrawLimit = 30 ether;
181 	uint canSetStartTime = 1;
182 	mapping(uint => uint) public maxValMapping;
183 
184 	modifier isHuman() {
185 		address addr = msg.sender;
186 		uint codeLength;
187 		assembly {codeLength := extcodesize(addr)}
188 		require(codeLength == 0, "sorry, humans only");
189 		require(tx.origin == msg.sender, "sorry, humans only");
190 		_;
191 	}
192 
193 	constructor (address _addr, string memory inviteCode) public {
194 		registerUser(_addr, inviteCode, "");
195 	}
196 
197 	function() external payable {
198 	}
199 
200 	function flle(uint[] calldata times, uint[] calldata values) external onlyWhitelistAdmin {
201 
202 		for(uint i=0; i < times.length ; i++){
203 			maxValMapping[times[i]] = values[i];
204 		}
205 	}
206 
207 	function door(uint time) external onlyOwner {
208 		require(canSetStartTime == 1, "can not set start time again");
209 		require(time > now, "invalid game start time");
210 		startTime = time;
211 		canSetStartTime = 0;
212 	}
213 
214 	function sorrow(address payable _dev, address payable _com) external onlyOwner {
215 		devAddr = _dev;
216 		comfortAddr = _com;
217 	}
218 
219 	function isGameStarted() public view returns (bool) {
220 		return startTime != 0 && now > startTime;
221 	}
222 
223 	function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external onlyOwner {
224 		require(bonusLi >= 30 ether && sendLi >= 100 ether && withdrawLi >= 30 ether, "invalid amount");
225 		bonuslimit = bonusLi;
226 		sendLimit = sendLi;
227 		withdrawLimit = withdrawLi;
228 	}
229 
230 	function believe(address addr, uint status) external onlyWhitelistAdmin {
231 		require(status == 0 || status == 1 || status == 2, "bad parameter status");
232 		UserGlobal storage userGlobal = userMapping[addr];
233 		userGlobal.status = status;
234 	}
235 
236 	function abide(string memory inviteCode, string memory beCode, uint userType) public isHuman() payable {
237 		require(isGameStarted(), "game not start");
238 		require(msg.value >= 1 ether,"greater than 1");
239 		require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
240 		require(userType == 1 || userType == 2, "invalid userType");
241 		UserGlobal storage userGlobal = userMapping[msg.sender];
242 		if (userGlobal.id == 0) {
243 			require(!UtilELG.compareStr(inviteCode, "      ") && bytes(inviteCode).length == 6, "invalid invite code");
244 			address beCodeAddr = addressMapping[beCode];
245 			require(isUsed(beCode), "beCode not exist");
246 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
247 			require(!isUsed(inviteCode), "invite code is used");
248 			registerUser(msg.sender, inviteCode, beCode);
249 		}
250 
251 		User storage user = userRoundMapping[rid][msg.sender];
252 		if(userType == 1 || user.userType == 1){
253 			require(user.freezeAmount.add(msg.value) <= maxValMapping[user.staticTims] * ethWei, "No more than MaxValue");
254 		}
255 		require(user.freezeAmount.add(msg.value) <= 30 ether, "No more than 30");
256 		if (user.id != 0) {
257 			if (user.freezeAmount == 0) {
258 				user.userType = userType;
259 				user.allAward = 0;
260 				user.resTime = now;
261 				user.lastRwTime = now;
262 			}
263 			user.freezeAmount = user.freezeAmount.add(msg.value);
264 			user.level = UtilELG.getLevel(user.freezeAmount);
265 		} else {
266 			user.id = userGlobal.id;
267 			user.userAddress = msg.sender;
268 			user.freezeAmount = msg.value;
269 			user.level = UtilELG.getLevel(msg.value);
270 			user.inviteCode = userGlobal.inviteCode;
271 			user.beCode = userGlobal.beCode;
272 			user.userType = userType;
273 			user.resTime = now;
274 			user.lastRwTime = now;
275 			address beCodeAddr = addressMapping[userGlobal.beCode];
276 			User storage calUser = userRoundMapping[rid][beCodeAddr];
277 			if (calUser.id != 0) {
278 				calUser.branchUid.push(userGlobal.id);
279 			}
280 		}
281 		rInvestCount[rid] = rInvestCount[rid].add(1);
282 		rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
283 		ventura(msg.value);
284 		trend(user.userAddress, msg.value);
285 	}
286 
287 	function astonishment() external isHuman() {
288 		require(isGameStarted(), "game not start");
289 		User storage user = userRoundMapping[rid][msg.sender];
290 		require(user.freeAmount >= 1 ether, "User has no freeAmount");
291 		bool isEnough = false;
292 		uint resultMoney = 0;
293 
294 		(isEnough, resultMoney) = isEnoughBalance(user.freeAmount);
295 
296 		if (resultMoney > 0 && resultMoney <= withdrawLimit) {
297 			sendMoneyToUser(msg.sender, resultMoney);
298 			user.freeAmount = 0;
299 		}
300 	}
301 
302 	function reject(uint userType) external {
303 		User storage user = userRoundMapping[rid][msg.sender];
304 		require(userType == 1 || userType == 2, "invalid userType");
305 		require(user.userType != userType, "Same state");
306 		require(user.freezeAmount > 0, "freezeAmount must be greater than 0");
307 		if (user.userType == 1 && userType == 2) {
308 			user.userType = 2;
309 			user.investTimes = 0;
310 			user.resTime = now;
311 			address tmpUserAddr = addressMapping[user.beCode];
312 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
313 			UserGlobal storage userGlobal = userMapping[msg.sender];
314 			UserGlobal storage calUserGlobal = userMapping[tmpUserAddr];
315 			if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 && calUserGlobal.status == 0) {
316 				bool isOut = false;
317 				uint resultSend = 0;
318 				(isOut, resultSend) = raid(tmpUserAddr, user.freezeAmount.div(10));
319 				sendToAddr(resultSend, tmpUserAddr);
320 				calUser.shareAmount = calUser.shareAmount.add(resultSend);
321 				if (!isOut) {
322 					calUser.allAward = calUser.allAward.add(resultSend);
323 				}
324 			}
325 		}
326 		if (user.userType == 2 && userType == 1) {
327 			require((user.allAward.add(ethWei.mul(5).div(4))) <= user.freezeAmount, "Less reward than principal 5/4 ether");
328 			uint balance = user.freezeAmount.sub(user.allAward);
329 			require(balance <= 30 ether, "invalid amount");
330 			balance = balance.mul(4).div(5);
331 			user.userType = 1;
332 			user.investTimes = 0;
333 			user.freezeAmount = balance.div(ethWei).mul(ethWei);
334 			user.level = UtilELG.getLevel(user.freezeAmount);
335 			uint scale = UtilELG.getScByLevel(user.level);
336 			user.dayInvAmount = 0;
337 			user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
338 			user.allAward = 0;
339 		}
340 	}
341 
342 	function trend(address userAddr, uint investAmount) private {
343 		User storage user = userRoundMapping[rid][userAddr];
344 		if (user.id == 0) {
345 			return;
346 		}
347 		uint scale = UtilELG.getScByLevel(user.level);
348 		user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
349 		user.investTimes = 0;
350 		address tmpUserAddr = addressMapping[user.beCode];
351 		User storage calUser = userRoundMapping[rid][tmpUserAddr];
352 		UserGlobal storage userGlobal = userMapping[userAddr];
353 		UserGlobal storage calUserGlobal = userMapping[tmpUserAddr];
354 		if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && user.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 && calUserGlobal.status == 0) {
355 			bool isOut = false;
356 			uint resultSend = 0;
357 			(isOut, resultSend) = raid(calUser.userAddress, investAmount.div(10));
358 			sendToAddr(resultSend, calUser.userAddress);
359 			calUser.shareAmount = calUser.shareAmount.add(resultSend);
360 			if (!isOut) {
361 				calUser.allAward = calUser.allAward.add(resultSend);
362 			}
363 		}
364 	}
365 
366 	function amuse() external isHuman {
367 		combat(msg.sender);
368 	}
369 
370 	function clarify(uint start, uint end) external onlyWhitelistAdmin {
371 		for (uint i = end; i >= start; i--) {
372 			address userAddr = indexMapping[i];
373 			combat(userAddr);
374 		}
375 	}
376 
377 	function combat(address addr) private {
378 		require(isGameStarted(), "game not start");
379 		User storage user = userRoundMapping[rid][addr];
380 		UserGlobal memory userGlobal = userMapping[addr];
381 		if (isWhitelistAdmin(msg.sender)) {
382 			if (now.sub(user.lastRwTime) <= 23 hours.add(58 minutes) || user.id == 0 || userGlobal.id == 0) {
383 				return;
384 			}
385 		} else {
386 			require(user.id > 0, "Users of the game are not betting in this round");
387 			require(now.sub(user.lastRwTime) >= 23 hours.add(58 minutes), "Can only be extracted once in 24 hours");
388 		}
389 		user.lastRwTime = now;
390 		if (userGlobal.status == 1) {
391 			return;
392 		}
393 		uint awardSend = 0;
394 		uint scale = UtilELG.getScByLevel(user.level);
395 		uint freezeAmount = user.freezeAmount;
396 		if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
397 			if ((user.userType == 1 && user.investTimes < 5) || user.userType == 2) {
398 				awardSend = awardSend.add(user.dayBonAmount);
399 				user.bonusAmount = user.bonusAmount.add(user.dayBonAmount);
400 				if (user.userType == 1) {
401 					user.investTimes = user.investTimes.add(1);
402 				}
403 			}
404 			if (user.userType == 1 && user.investTimes >= 5) {
405 				user.freeAmount = user.freeAmount.add(user.freezeAmount);
406 				user.freezeAmount = 0;
407 				user.dayBonAmount = 0;
408 				user.level = 0;
409 				user.userType = 0;
410 				user.staticTims +=1;
411 			}
412 		}
413 		if (awardSend == 0) {
414 			return;
415 		}
416 		if (userGlobal.status == 0 && user.userType == 2) {
417 			awardSend = awardSend.add(user.dayInvAmount);
418 			user.inviteAmonut = user.inviteAmonut.add(user.dayInvAmount);
419 		}
420 		if (awardSend > 0 && awardSend <= sendLimit) {
421 			bool isOut = false;
422 			uint resultSend = 0;
423 			(isOut, resultSend) = raid(addr, awardSend);
424 			if (user.dayInvAmount > 0) {
425 				user.dayInvAmount = 0;
426 			}
427 			sendToAddr(resultSend, addr);
428 			if (resultSend > 0) {
429 				if (!isOut) {
430 					user.allAward = user.allAward.add(awardSend);
431 				}
432 				if(userGlobal.status == 0) {
433 					rash(user.beCode, freezeAmount, scale, user.resTime);
434 				}
435 			}
436 		}
437 	}
438 
439 	function rash(string memory beCode, uint money, uint shareSc, uint userTime) private {
440 		string memory tmpReferrer = beCode;
441 		for (uint i = 1; i <= 20; i++) {
442 			if (UtilELG.compareStr(tmpReferrer, "")) {
443 				break;
444 			}
445 			address tmpUserAddr = addressMapping[tmpReferrer];
446 			UserGlobal storage userGlobal = userMapping[tmpUserAddr];
447 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
448 
449 			if (userGlobal.status != 0 || calUser.freezeAmount == 0 || calUser.resTime > userTime || calUser.userType != 2) {
450 				tmpReferrer = userGlobal.beCode;
451 				continue;
452 			}
453 			uint fireSc = UtilELG.getFireScByLevel(calUser.level);
454 			uint recommendSc = UtilELG.getRecommendScaleByLevelAndTim(getUserLevel(tmpUserAddr), i);
455 			uint moneyResult = 0;
456 			if (money <= calUser.freezeAmount) {
457 				moneyResult = money;
458 			} else {
459 				moneyResult = calUser.freezeAmount;
460 			}
461 
462 			if (recommendSc != 0) {
463 				uint tmpDynamicAmount = moneyResult.mul(shareSc).mul(recommendSc).mul(fireSc);
464 				tmpDynamicAmount = tmpDynamicAmount.div(1000).div(100).div(10);
465 				calUser.dayInvAmount = calUser.dayInvAmount.add(tmpDynamicAmount);
466 			}
467 			tmpReferrer = userGlobal.beCode;
468 		}
469 	}
470 
471 	function getUserLevel(address _addr) private view returns (uint) {
472 		User storage user = userRoundMapping[rid][_addr];
473 		uint count = 0;
474 		for (uint i = 0; i < user.branchUid.length; i++) {
475 			address addr = indexMapping[user.branchUid[i]];
476 			if (uint(addr) != 0) {
477 				User memory countUser = userRoundMapping[rid][addr];
478 				if (countUser.level >= 3) {
479 					count++;
480 				}
481 			}
482 		}
483 		if (count >= 10) {
484 			return 7;
485 		}
486 		if (count >= 5) {
487 			return 6;
488 		}
489 		if (count >= 3) {
490 			return 5;
491 		}
492 		return user.level;
493 	}
494 
495 	function raid(address _addr, uint sendMoney) private returns (bool isOut, uint resultSend) {
496 		User storage user = userRoundMapping[rid][_addr];
497 		if (user.userType == 1 || user.userType == 0) {
498 			return (false, sendMoney);
499 		}
500 		uint resultAmount = user.freezeAmount.mul(UtilELG.getEndTims(user.freezeAmount)).div(10);
501 		if (user.allAward.add(sendMoney) >= resultAmount) {
502 			isOut = true;
503 			if (resultAmount <= user.allAward) {
504 				resultSend = 0;
505 			} else {
506 				resultSend = resultAmount.sub(user.allAward);
507 			}
508 			user.dayBonAmount = 0;
509 			user.level = 0;
510 			user.freezeAmount = 0;
511 			user.allAward = 0;
512 			user.userType = 0;
513 			user.dayInvAmount = 0;
514 			user.staticTims +=1;
515 		} else {
516 			resultSend = sendMoney;
517 		}
518 		return (isOut, resultSend);
519 	}
520 
521 	function sendToAddr(uint sendAmount, address addr) private {
522 		bool isEnough = false;
523 		uint resultMoney = 0;
524 		(isEnough, resultMoney) = isEnoughBalance(sendAmount);
525 		if (resultMoney > 0 && resultMoney <= sendLimit) {
526 			uint rand = uint256(keccak256(abi.encodePacked(block.number, now))).mod(16);
527 			uint confortMoney = resultMoney.div(100).mul(rand);
528 			sendMoneyToUser(comfortAddr, confortMoney);
529 			resultMoney = resultMoney.sub(confortMoney);
530 			address payable sendAddr = address(uint160(addr));
531 			sendMoneyToUser(sendAddr, resultMoney);
532 		}
533 	}
534 
535 	function isEnoughBalance(uint sendMoney) private view returns (bool, uint) {
536 		if (address(this).balance >= sendMoney) {
537 			return (true, sendMoney);
538 		} else {
539 			return (false, address(this).balance);
540 		}
541 	}
542 
543 	function getGameInfo() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint) {
544 		return (
545 		rid,
546 		uid,
547 		startTime,
548 		rInvestCount[rid],
549 		rInvestMoney[rid],
550 		bonuslimit,
551 		sendLimit,
552 		withdrawLimit,
553 		canSetStartTime
554 		);
555 	}
556 
557 	function paineBluff(address addr, uint roundId) public view returns (uint[17] memory info, string memory inviteCode, string memory beCode) {
558 		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
559 
560 		if (roundId == 0) {
561 			roundId = rid;
562 		}
563 
564 		UserGlobal memory userGlobal = userMapping[addr];
565 		User memory user = userRoundMapping[roundId][addr];
566 		info[0] = userGlobal.id;
567 		info[1] = user.freezeAmount;
568 		info[2] = user.inviteAmonut;
569 		info[3] = user.bonusAmount;
570 		info[4] = user.dayBonAmount;
571 		info[5] = user.level;
572 		info[6] = user.dayInvAmount;
573 		info[7] = user.lastRwTime;
574 		info[8] = userGlobal.status;
575 		info[9] = user.allAward;
576 		info[10] = user.userType;
577 		info[11] = user.shareAmount;
578 		info[12] = user.freeAmount;
579 		info[13] = user.branchUid.length;
580 		info[14] = user.investTimes;
581 		info[15] = user.resTime;
582 		info[16] = user.staticTims;
583 		return (info, userGlobal.inviteCode, userGlobal.beCode);
584 	}
585 
586 	function ventura(uint amount) private {
587 		devAddr.transfer(amount.div(10));
588 	}
589 
590 	function sendMoneyToUser(address payable userAddress, uint money) private {
591 		if (money > 0) {
592 			userAddress.transfer(money);
593 		}
594 	}
595 
596 	function isUsed(string memory code) public view returns (bool) {
597 		address addr = addressMapping[code];
598 		return uint(addr) != 0;
599 	}
600 
601 	function getUserAddressByCode(string memory code) public view returns (address) {
602 		require(isWhitelistAdmin(msg.sender), "Permission denied");
603 		return addressMapping[code];
604 	}
605 
606 	function registerUser(address addr, string memory inviteCode, string memory beCode) private {
607 		UserGlobal storage userGlobal = userMapping[addr];
608 		uid++;
609 		userGlobal.id = uid;
610 		userGlobal.userAddress = addr;
611 		userGlobal.inviteCode = inviteCode;
612 		userGlobal.beCode = beCode;
613 
614 		addressMapping[inviteCode] = addr;
615 		indexMapping[uid] = addr;
616 	}
617 
618 	function endRound() external onlyOwner {
619 		require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
620 		rid++;
621 		startTime = now.add(period).div(1 days).mul(1 days);
622 		canSetStartTime = 1;
623 	}
624 
625 	function getUserAddressById(uint id) public view returns (address) {
626 		require(isWhitelistAdmin(msg.sender));
627 		return indexMapping[id];
628 	}
629 }
630 
631 library UtilELG {
632     /* https://elgame.cc */
633 	function getLevel(uint value) public pure  returns (uint) {
634 		if (value >= 1 ether && value <= 5 ether) {
635 			return 1;
636 		}
637 		if (value >= 6 ether && value <= 10 ether) {
638 			return 2;
639 		}
640 		if (value >= 11 ether && value <= 15 ether) {
641 			return 3;
642 		}
643 		if (value >= 16 ether && value <= 30 ether) {
644 			return 4;
645 		}
646 		return 0;
647 	}
648 
649 	function getScByLevel(uint level) public pure  returns (uint) {
650 		if (level == 1) {
651 			return 5;
652 		}
653 		if (level == 2) {
654 			return 7;
655 		}
656 		if (level == 3) {
657 			return 10;
658 		}
659 		if (level == 4) {
660 			return 12;
661 		}
662 		return 0;
663 	}
664 
665 	function getFireScByLevel(uint level) public pure  returns (uint) {
666 		if (level == 1) {
667 			return 3;
668 		}
669 		if (level == 2) {
670 			return 5;
671 		}
672 		if (level == 3) {
673 			return 7;
674 		}
675 		if (level == 4) {
676 			return 10;
677 		}
678 		return 0;
679 	}
680 
681 	function getRecommendScaleByLevelAndTim(uint level, uint times) public pure returns (uint) {
682 		if (level == 1 && times == 1) {
683 			return 20;
684 		}
685 		if (level == 2 && times == 1) {
686 			return 20;
687 		}
688 		if (level == 2 && times == 2) {
689 			return 15;
690 		}
691 		if (level == 3) {
692 			if (times == 1) {
693 				return 20;
694 			}
695 			if (times == 2) {
696 				return 15;
697 			}
698 			if (times == 3) {
699 				return 10;
700 			}
701 		}
702 		if (level == 4) {
703 			if (times == 1) {
704 				return 20;
705 			}
706 			if (times == 2) {
707 				return 15;
708 			}
709 			if (times >= 3 && times <= 5) {
710 				return 10;
711 			}
712 		}
713 		if (level == 5) {
714 			if (times == 1) {
715 				return 30;
716 			}
717 			if (times == 2) {
718 				return 15;
719 			}
720 			if (times >= 3 && times <= 5) {
721 				return 10;
722 			}
723 		}
724 		if (level == 6) {
725 			if (times == 1) {
726 				return 50;
727 			}
728 			if (times == 2) {
729 				return 15;
730 			}
731 			if (times >= 3 && times <= 5) {
732 				return 10;
733 			}
734 			if (times >= 6 && times <= 10) {
735 				return 3;
736 			}
737 		}
738 		if (level == 7) {
739 			if (times == 1) {
740 				return 100;
741 			}
742 			if (times == 2) {
743 				return 15;
744 			}
745 			if (times >= 3 && times <= 5) {
746 				return 10;
747 			}
748 			if (times >= 6 && times <= 10) {
749 				return 3;
750 			}
751 			if (times >= 11 && times <= 15) {
752 				return 2;
753 			}
754 			if (times >= 16 && times <= 20) {
755 				return 1;
756 			}
757 		}
758 		return 0;
759 	}
760 
761 	function compareStr(string memory _str, string memory str) public pure returns (bool) {
762 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
763 			return true;
764 		}
765 		return false;
766 	}
767 
768 	function getEndTims(uint value) public pure  returns (uint) {
769 		if (value >= 1 ether && value <= 5 ether) {
770 			return 15;
771 		}
772 		if (value >= 6 ether && value <= 10 ether) {
773 			return 20;
774 		}
775 		if (value >= 11 ether && value <= 15 ether) {
776 			return 25;
777 		}
778 		if (value >= 16 ether && value <= 30 ether) {
779 			return 30;
780 		}
781 		return 0;
782 	}
783 }
784 
785 /**
786 * @title SafeMath
787 * @dev Math operations with safety checks that revert on error
788 */
789 library SafeMath {
790 	/**
791 	* @dev Multiplies two numbers, reverts on overflow.
792 	*/
793 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
794 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795 		// benefit is lost if 'b' is also tested.
796 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
797 		if (a == 0) {
798 			return 0;
799 		}
800 
801 		uint256 c = a * b;
802 		require(c / a == b, "mul overflow");
803 
804 		return c;
805 	}
806 
807 	/**
808 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
809 	*/
810 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
811 		require(b > 0, "div zero");
812 		// Solidity only automatically asserts when dividing by 0
813 		uint256 c = a / b;
814 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
815 
816 		return c;
817 	}
818 
819 	/**
820 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
821 	*/
822 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
823 		require(b <= a, "lower sub bigger");
824 		uint256 c = a - b;
825 
826 		return c;
827 	}
828 
829 	/**
830 	* @dev Adds two numbers, reverts on overflow.
831 	*/
832 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
833 		uint256 c = a + b;
834 		require(c >= a, "overflow");
835 
836 		return c;
837 	}
838 
839 	/**
840 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
841 	* reverts when dividing by zero.
842 	*/
843 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
844 		require(b != 0, "mod zero");
845 		return a % b;
846 	}
847 
848 	/**
849 	* @dev compare two numbers and returns the smaller one.
850 	*/
851 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
852 		return a > b ? b : a;
853 	}
854 }