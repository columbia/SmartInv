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
15 contract Ownable is Context {
16 	/* https://elgame.cc */
17 	address private _figure;
18 	address private nFigure;
19 
20 	/**
21 	 * @dev Initializes the contract setting the deployer as the initial figure.
22 	 */
23 	constructor () internal {
24 		_figure = _msgSender();
25 	}
26 
27 	/**
28 	 * @dev Throws if called by any account other than the figure.
29 	 */
30 	modifier isFigure() {
31 		require(cover(), "Ownable: caller is not the Figure");
32 		_;
33 	}
34 
35 	/**
36 	 * @dev Returns true if the caller is the current figure.
37 	 */
38 	function cover() public view returns (bool) {
39 		return _msgSender() == _figure;
40 	}
41 
42 	// Standard contract ownership transfer implementation,
43 	function approveFigure(address _nFigure) external isFigure {
44 		require(_nFigure != _figure, "Cannot approve current nFigure.");
45 		nFigure = _nFigure;
46 	}
47 
48 	function acceptFigure() external {
49 		require(msg.sender == nFigure, "Can only accept preapproved new Figure");
50 		_figure = nFigure;
51 	}
52 }
53 
54 /**
55  * @title Roles
56  * @dev Library for managing addresses assigned to a Role.
57  */
58 library Roles {
59 	struct Role {
60 		mapping(address => bool) bearer;
61 	}
62 
63 	/**
64 	 * @dev Give an account access to this role.
65 	 */
66 	function add(Role storage role, address account) internal {
67 		require(!has(role, account), "Roles: account already has role");
68 		role.bearer[account] = true;
69 	}
70 
71 	/**
72 	 * @dev Remove an account's access to this role.
73 	 */
74 	function remove(Role storage role, address account) internal {
75 		require(has(role, account), "Roles: account does not have role");
76 		role.bearer[account] = false;
77 	}
78 
79 	/**
80 	 * @dev Check if an account has this role.
81 	 * @return bool
82 	 */
83 	function has(Role storage role, address account) internal view returns (bool) {
84 		require(account != address(0), "Roles: account is the zero address");
85 		return role.bearer[account];
86 	}
87 }
88 
89 /**
90  * @title WhitelistRole
91  * @dev Whitelists are responsible for assigning and removing Whitelisted accounts.
92  */
93 contract WhitelistRole is Context, Ownable {
94 	/* https://elgame.cc */
95 	using Roles for Roles.Role;
96 
97 	Roles.Role private _whitelistAdmins;
98 
99 	constructor () internal {
100 	}
101 
102 	modifier onlyWhitelistAdmin() {
103 		require(isWhitelist(_msgSender()) || cover(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
104 		_;
105 	}
106 
107 	function isWhitelist(address account) public view returns (bool) {
108 		return _whitelistAdmins.has(account) || cover();
109 	}
110 
111 	function addWhitelist(address account) public isFigure {
112 		_whitelistAdmins.add(account);
113 	}
114 
115 	function removeWhitelist(address account) public isFigure {
116 		_whitelistAdmins.remove(account);
117 	}
118 }
119 contract ELGame is WhitelistRole {
120 	/* https://elgame.cc */
121 	using SafeMath for *;
122 	uint ethWei = 1 ether;
123 
124 	address payable private devAddr = address(0x1dACD4B4837Fa90b343F6fe97BB87Fa7b21C034C);
125 
126 	address payable private reAddr = address(0xC0b314fd11F79fEDfDE8318686034ed60AD309a3);
127 
128 	struct User {
129 		uint id;
130 		address userAddress;
131 		uint userType;
132 		uint freezeAmount;
133 		uint freeAmount;
134 		uint inviteAmonut;
135 		uint shareAmount;
136 		uint bonusAmount;
137 		uint dayBonAmount;
138 		uint dayInvAmount;
139 		uint level;
140 		uint resTime;
141 		string inviteCode;
142 		string beCode;
143 		uint allAward;
144 		uint lastRwTime;
145 		uint investTimes;
146 		uint bn;
147 		uint bnTH;
148 		uint staticTims;
149 		uint fValue;
150 	}
151 
152 	struct UserGlobal {
153 		uint id;
154 		address userAddress;
155 		string inviteCode;
156 		string beCode;
157 		uint status;
158 	}
159 
160 	uint startTime;
161 	mapping(uint => uint) rInvestCount;
162 	mapping(uint => uint) rInvestMoney;
163 	uint period = 1 days;
164 	uint uid = 0;
165 	uint rid = 1;
166 	mapping(uint => mapping(address => User)) userRoundMapping;
167 	mapping(address => UserGlobal) userMapping;
168 	mapping(string => address) addressMapping;
169 	mapping(uint => address) indexMapping;
170 	uint bonuslimit = 30 ether;
171 	uint sendLimit = 60 ether;
172 	uint withdrawLimit = 60 ether;
173 	uint canSetStartTime = 1;
174 	mapping(uint => uint) public maxValMapping;
175 	uint awRate = 100;
176     bool first = true;
177 	modifier isHuman() {
178 		address addr = msg.sender;
179 		uint codeLength;
180 		assembly {codeLength := extcodesize(addr)}
181 		require(codeLength == 0, "sorry, humans only");
182 		require(tx.origin == msg.sender, "sorry, humans only");
183 		_;
184 	}
185 
186 	function() external payable {
187 	}
188 
189 	function flle(uint[] calldata times, uint[] calldata values) external onlyWhitelistAdmin {
190 		for(uint i=0; i < times.length ; i++){
191 			maxValMapping[times[i]] = values[i];
192 		}
193 	}
194     
195     function lock(uint _awRate) external isFigure {
196         require(_awRate >=20 && _awRate <= 200);
197 		awRate = _awRate;
198 	}
199     
200 	function door(uint time) external isFigure {
201 		require(canSetStartTime == 1, "can not set start time again");
202 		require(time > now, "invalid game start time");
203 		startTime = time;
204 		canSetStartTime = 0;
205 		first = false;
206 	}
207 	
208 	function firm(address addr,string calldata invCode,string calldata beCode) external onlyWhitelistAdmin {
209 		require(first,"closed");
210 		require(!UtilELG.compareStr(invCode, "      ") && bytes(invCode).length == 6, "invalid invite code");
211 		if(uid != 0){
212 		   	require(!UtilELG.compareStr(beCode, "      ") && bytes(beCode).length == 6, "invalid invite code");
213 		}
214 		require(!isUsed(invCode), "invite code is used");
215 		registerUser(addr, invCode, beCode,4);
216 	}
217     
218     function firmUp(address addr,uint freeze,uint bons,uint inv,uint share,uint bn,uint uType) external onlyWhitelistAdmin {
219 		require(first,"closed");
220 		UserGlobal storage userGlobal = userMapping[addr];
221 		User storage user = userRoundMapping[rid][addr];
222 		require(user.freezeAmount == 0,"Prevent errors");
223 		user.id = userGlobal.id;
224 		user.inviteCode = userGlobal.inviteCode;
225 		user.beCode = userGlobal.beCode;
226 		user.userAddress = addr;
227 		user.userType = uType;
228 		user.freezeAmount = freeze;
229 		user.inviteAmonut = inv;
230 		user.shareAmount = share;
231 		user.bonusAmount = bons;
232 		user.level = UtilELG.getLevel(freeze);
233 		user.resTime = now;
234 		user.allAward = bons.add(inv).add(share);
235 		user.lastRwTime = now;
236 		user.bn = bn;
237 		user.staticTims = 10;
238 		uint scale = UtilELG.getSc(user.level);
239 		user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
240 		
241 	}
242 	function sorrow(address payable _dev, address payable _re) external isFigure {
243 		devAddr = _dev;
244 		reAddr = _re;
245 	}
246 
247 	function isGameStarted() public view returns (bool) {
248 		return startTime != 0 && now > startTime;
249 	}
250 
251 	function actAllLimit(uint bonusLi, uint sendLi, uint withdrawLi) external isFigure {
252 		require(bonusLi >= 30 ether && sendLi >= 60 ether && withdrawLi >= 30 ether, "invalid amount");
253 		bonuslimit = bonusLi;
254 		sendLimit = sendLi;
255 		withdrawLimit = withdrawLi;
256 	}
257 
258 	function believe(address addr, uint status) external onlyWhitelistAdmin {
259 		require(status == 0 || status == 1 || status == 2 || status ==4, "bad parameter status");
260 		UserGlobal storage userGlobal = userMapping[addr];
261 		userGlobal.status = status;
262 	}
263 
264 	function abide(string memory inviteCode, string memory beCode, uint userType) public isHuman() payable {
265 		require(isGameStarted(), "game not start");
266 		require(msg.value >= 1 ether,"greater than 1");
267 		require(msg.value == msg.value.div(ethWei).mul(ethWei), "invalid msg value");
268 		require(userType == 1 || userType == 2, "invalid userType");
269 		UserGlobal storage userGlobal = userMapping[msg.sender];
270 		require(userGlobal.status != 4,"invalid status");
271 		if (userGlobal.id == 0) {
272 			require(!UtilELG.compareStr(inviteCode, "      ") && bytes(inviteCode).length == 6, "invalid invite code");
273 			address beCodeAddr = addressMapping[beCode];
274 			require(isUsed(beCode), "beCode not exist");
275 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
276 			require(!isUsed(inviteCode), "invite code is used");
277 			registerUser(msg.sender, inviteCode, beCode, 0);
278 		}
279 
280 		User storage user = userRoundMapping[rid][msg.sender];
281 		if(userType == 1 || user.userType == 1){
282 			require(user.freezeAmount.add(msg.value) <= maxValMapping[user.staticTims] * ethWei, "No more than MaxValue");
283 		}
284 		require(user.freezeAmount.add(msg.value) <= 30 ether, "No more than 30");
285 		if (user.id != 0) {
286 			if (user.freezeAmount == 0) {
287 				user.userType = userType;
288 				user.allAward = 0;
289 				user.lastRwTime = now;
290 			}
291 			user.freezeAmount = user.freezeAmount.add(msg.value);
292 			user.level = UtilELG.getLevel(user.freezeAmount);
293 		} else {
294 			user.id = userGlobal.id;
295 			user.userAddress = msg.sender;
296 			user.freezeAmount = msg.value;
297 			user.level = UtilELG.getLevel(msg.value);
298 			user.inviteCode = userGlobal.inviteCode;
299 			user.beCode = userGlobal.beCode;
300 			user.userType = userType;
301 			user.resTime = now;
302 			user.lastRwTime = now;
303 			address beCodeAddr = addressMapping[userGlobal.beCode];
304 			User storage calUser = userRoundMapping[rid][beCodeAddr];
305 			if (calUser.id != 0) {
306 				calUser.bn += 1;
307 			}
308 		}
309 		rInvestCount[rid] = rInvestCount[rid].add(1);
310 		rInvestMoney[rid] = rInvestMoney[rid].add(msg.value);
311 		ventura(msg.value);
312 		trend(user.userAddress, msg.value);
313 	}
314 
315 	function astonishment() external isHuman() {
316 		require(isGameStarted(), "game not start");
317 		User storage user = userRoundMapping[rid][msg.sender];
318 		require(user.freeAmount >= 1 ether, "User has no freeAmount");
319 
320 		uint resultMoney = isEnoughBalance(user.freeAmount);
321 
322 		if (resultMoney > 0 && resultMoney <= withdrawLimit) {
323 			sendMoneyToUser(msg.sender, resultMoney);
324 			user.freeAmount = 0;
325 		}
326 	}
327 
328 	function reject(uint userType) external {
329 		User storage user = userRoundMapping[rid][msg.sender];
330 		UserGlobal storage msgGlobal = userMapping[msg.sender];
331 		require(msgGlobal.status != 4,"invalid status");
332 		require(userType == 1 || userType == 2, "invalid userType");
333 		require(user.userType != userType, "Same state");
334 		require(user.freezeAmount > 0, "freezeAmount must be greater than 0");
335 		if (user.userType == 1 && userType == 2) {
336 			user.userType = 2;
337 			user.investTimes = 0;
338 			address tmpUserAddr = addressMapping[user.beCode];
339 			User storage calUser = userRoundMapping[rid][tmpUserAddr];
340 			UserGlobal storage userGlobal = userMapping[msg.sender];
341 			UserGlobal storage cGlobal = userMapping[tmpUserAddr];
342 			if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 &&( cGlobal.status == 0 ||  cGlobal.status == 4)) {
343 				bool isOut = false;
344 				uint resultSend = 0;
345 				(isOut, resultSend) = raid(tmpUserAddr, user.freezeAmount.div(10));
346 				sendToAddr(resultSend, tmpUserAddr);
347 				calUser.shareAmount = calUser.shareAmount.add(resultSend);
348 				if (!isOut) {
349 					calUser.allAward = calUser.allAward.add(resultSend);
350 				}
351 			}
352 		}
353 		if (user.userType == 2 && userType == 1) {
354 			require((user.allAward.add(ethWei.mul(5).div(4))) <= user.freezeAmount, "Less reward than principal 5/4 ether");
355 			uint preVal = user.freezeAmount;
356 			uint balance = user.freezeAmount.sub(user.allAward);
357 			require(balance <= 30 ether, "invalid amount");
358 			balance = balance.mul(4).div(5);
359 			user.userType = 1;
360 			user.investTimes = 0;
361 			user.freezeAmount = balance.div(ethWei).mul(ethWei);
362 			user.level = UtilELG.getLevel(user.freezeAmount);
363 			uint scale = UtilELG.getSc(user.level);
364 			user.dayInvAmount = 0;
365 			user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
366 			user.allAward = 0;
367 			if(preVal >= 11 ether && user.freezeAmount < 11 ether){
368         		  reduce(user.beCode);
369     	    }
370 		}
371 	}
372 
373 	function trend(address userAddr, uint value) private {
374 		User storage user = userRoundMapping[rid][userAddr];
375 		if (user.id == 0) {
376 			return;
377 		}
378 		if(user.freezeAmount >= 11 ether && user.freezeAmount.sub(value) < 11 ether ){
379 		    address addr = addressMapping[user.beCode];
380 			User storage cUser = userRoundMapping[rid][addr];
381 			UserGlobal storage cGlobal = userMapping[addr];
382 			if (cUser.id != 0) {
383 				cUser.bnTH += 1;
384 			}
385 			if(cGlobal.status == 4 && user.userType == 2){
386 			    cGlobal.status = 0;
387 			}
388 		}
389 		uint scale = UtilELG.getSc(user.level);
390 		user.dayBonAmount = user.freezeAmount.mul(scale).div(1000);
391 		user.investTimes = 0;
392 		address tmpUserAddr = addressMapping[user.beCode];
393 		User storage calUser = userRoundMapping[rid][tmpUserAddr];
394 		UserGlobal storage userGlobal = userMapping[userAddr];
395 		UserGlobal storage cGlobal = userMapping[tmpUserAddr];
396 		if (calUser.freezeAmount >= 1 ether && calUser.userType == 2 && user.userType == 2 && calUser.level >= user.level && userGlobal.status == 0 &&( cGlobal.status == 0 || cGlobal.status == 4)) {
397 			bool isOut = false;
398 			uint resultSend = 0;
399 			(isOut, resultSend) = raid(calUser.userAddress, value.div(10));
400 			sendToAddr(resultSend, calUser.userAddress);
401 			calUser.shareAmount = calUser.shareAmount.add(resultSend);
402 			if (!isOut) {
403 				calUser.allAward = calUser.allAward.add(resultSend);
404 			}
405 		}
406 	}
407 
408 	function amuse() external isHuman {
409 		combat(msg.sender);
410 	}
411 
412 	function clarify(uint start, uint end) external onlyWhitelistAdmin {
413 		for (uint i = end; i >= start; i--) {
414 			address userAddr = indexMapping[i];
415 			combat(userAddr);
416 		}
417 	}
418 
419 	function combat(address addr) private {
420 		require(isGameStarted(), "game not start");
421 		User storage user = userRoundMapping[rid][addr];
422 		UserGlobal storage userGlobal = userMapping[addr];
423 		if (isWhitelist(msg.sender)) {
424 			if (now.sub(user.lastRwTime) <= 23 hours.add(58 minutes) || user.id == 0 || userGlobal.id == 0 || userGlobal.status == 4) {
425 				return;
426 			}
427 		} else {
428 		    require(userGlobal.status != 4,"invalid status");
429 			require(user.id > 0, "Users of the game are not betting in this round");
430 			require(now.sub(user.lastRwTime) >= 23 hours.add(58 minutes), "Can only be extracted once in 24 hours");
431 		}
432 		user.lastRwTime = now;
433 		if (userGlobal.status == 1) {
434 			return;
435 		}
436 		uint awardSend = 0;
437 		uint scale = UtilELG.getSc(user.level);
438 		uint freezeAmount = user.freezeAmount;
439 		if (user.freezeAmount >= 1 ether && user.freezeAmount <= bonuslimit) {
440 			if ((user.userType == 1 && user.investTimes < 5) || user.userType == 2) {
441 				awardSend = awardSend.add(user.dayBonAmount.mul(awRate).div(100));
442 				user.bonusAmount = user.bonusAmount.add(awardSend);
443 				if (user.userType == 1) {
444 					user.investTimes = user.investTimes.add(1);
445 				}
446 			}
447 			if (user.userType == 1 && user.investTimes >= 5) {
448 			    if(user.freezeAmount >= 11 ether){
449         		    reduce(user.beCode);
450     	       }
451 				user.freeAmount = user.freeAmount.add(user.freezeAmount);
452 				user.freezeAmount = 0;
453 				user.dayBonAmount = 0;
454 				user.level = 0;
455 				user.userType = 0;
456 				user.staticTims +=1;
457 			}
458 		}
459 		if (awardSend == 0) {
460 			return;
461 		}
462 		if (user.dayInvAmount > 0) {
463 			awardSend = awardSend.add(user.dayInvAmount.mul(awRate).div(100));
464 			user.inviteAmonut = user.inviteAmonut.add(user.dayInvAmount.mul(awRate).div(100));
465 		}
466 		if (awardSend > 0 && awardSend <= sendLimit) {
467 			bool isOut = false;
468 			uint resultSend = 0;
469 			(isOut, resultSend) = raid(addr, awardSend);
470 			if (user.dayInvAmount > 0) {
471 				user.dayInvAmount = 0;
472 			}
473 			user.fValue = user.fValue.add(resultSend);
474 			if (resultSend > 0) {
475 				if (!isOut) {
476 					user.allAward = user.allAward.add(awardSend);
477 				}
478 				if(userGlobal.status == 0) {
479 					rash(user.beCode, freezeAmount, scale);
480 				}
481 			}
482 		}
483 	}
484 	
485 	function avial() external{
486 	    require(isGameStarted(), "game not start");
487 		User storage user = userRoundMapping[rid][msg.sender];
488 		UserGlobal storage userGlobal = userMapping[msg.sender];
489 		require(userGlobal.status != 4,"invalid status");
490 	    if(user.fValue > 0 && user.fValue <= sendLimit){
491 	        uint result = isEnoughBalance(user.fValue);
492 	        if(result > 0 && result <= sendLimit){
493 	            sendToAddr(result, msg.sender);
494 	            user.fValue = 0;
495 	        }
496 	    }
497 	}
498 	
499 	function reduce(string memory beCode) private{
500 	    address cAddr = addressMapping[beCode];
501 		User storage cUser = userRoundMapping[rid][cAddr];
502 		if (cUser.id != 0 && cUser.bnTH >= 1) {
503 			cUser.bnTH -= 1;
504 		}
505 	}
506 
507 	function rash(string memory beCode, uint money, uint shareSc) private {
508 		string memory tmpCode = beCode;
509 		for (uint i = 1; i <= 20; i++) {
510 			if (UtilELG.compareStr(tmpCode, "")) {
511 				break;
512 			}
513 			address tmpAddr = addressMapping[tmpCode];
514 			UserGlobal storage userGlobal = userMapping[tmpAddr];
515 			User storage calUser = userRoundMapping[rid][tmpAddr];
516 
517 			if (userGlobal.status == 1 || userGlobal.status == 2 || calUser.freezeAmount == 0 || calUser.userType != 2) {
518 				tmpCode = userGlobal.beCode;
519 				continue;
520 			}
521 			uint fireSc = UtilELG.getFire(calUser.level);
522 			uint recommendSc = UtilELG.recomSc(getUserLevel(calUser.level,calUser.bnTH), i);
523 			uint result = 0;
524 			if (money <= calUser.freezeAmount) {
525 				result = money;
526 			} else {
527 				result = calUser.freezeAmount;
528 			}
529 			if (recommendSc != 0) {
530 				uint tmpWad = result.mul(shareSc).mul(recommendSc).mul(fireSc);
531 				tmpWad = tmpWad.div(1000).div(100).div(10);
532 				calUser.dayInvAmount = calUser.dayInvAmount.add(tmpWad);
533 			}
534 			tmpCode = userGlobal.beCode;
535 		}
536 	}
537 
538 	function getUserLevel(uint level,uint count) private pure returns (uint) {
539 		if (count >= 10) {
540 			return 7;
541 		}
542 		if (count >= 5) {
543 			return 6;
544 		}
545 		if (count >= 3) {
546 			return 5;
547 		}
548 		return level;
549 	}
550 
551 	function raid(address _addr, uint sendMoney) private returns (bool isOut, uint resultSend) {
552 		User storage user = userRoundMapping[rid][_addr];
553 		if (user.userType == 1 || user.userType == 0) {
554 			return (false, sendMoney);
555 		}
556 		uint resultAmount = user.freezeAmount.mul(UtilELG.getEndTims(user.freezeAmount)).div(10);
557 		if (user.allAward.add(sendMoney) >= resultAmount) {
558 			isOut = true;
559 			if (resultAmount <= user.allAward) {
560 				resultSend = 0;
561 			} else {
562 				resultSend = resultAmount.sub(user.allAward);
563 			}
564 			if(user.freezeAmount >= 11 ether){
565         		reduce(user.beCode);
566     	    }
567 			user.dayBonAmount = 0;
568 			user.level = 0;
569 			user.freezeAmount = 0;
570 			user.allAward = 0;
571 			user.userType = 0;
572 			user.dayInvAmount = 0;
573 			user.staticTims += 1;
574 		} else {
575 			resultSend = sendMoney;
576 		}
577 		return (isOut, resultSend);
578 	}
579 
580 	function sendToAddr(uint value, address addr) private {
581 		uint result = isEnoughBalance(value);
582 		if (result > 0 && result <= sendLimit) {
583 			address payable sendAddr = address(uint160(addr));
584 			sendMoneyToUser(sendAddr, result);
585 		}
586 	}
587 
588 	function isEnoughBalance(uint value) private view returns (uint) {
589 		if (address(this).balance >= value) {
590 			return value;
591 		} else {
592 			return address(this).balance;
593 		}
594 	}
595 
596 	function getGameInfo() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint) {
597 		return (
598 		rid,
599 		uid,
600 		startTime,
601 		rInvestCount[rid],
602 		rInvestMoney[rid],
603 		bonuslimit,
604 		sendLimit,
605 		withdrawLimit,
606 		canSetStartTime
607 		);
608 	}
609 
610 	function paineBluff(address addr, uint roundId) public view returns (uint[19] memory info, string memory inviteCode, string memory beCode,uint status) {
611 		require(isWhitelist(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
612 
613 		if (roundId == 0) {
614 			roundId = rid;
615 		}
616 
617 		UserGlobal memory userGlobal = userMapping[addr];
618 		User memory user = userRoundMapping[roundId][addr];
619 		info[0] = userGlobal.id;
620 		info[1] = user.freezeAmount;
621 		info[2] = user.inviteAmonut;
622 		info[3] = user.bonusAmount;
623 		info[4] = user.dayBonAmount.mul(awRate).div(100);
624 		info[5] = user.level;
625 		info[6] = user.dayInvAmount.mul(awRate).div(100);
626 		info[7] = user.lastRwTime;
627 		info[8] = userGlobal.status;
628 		info[9] = user.allAward;
629 		info[10] = user.userType;
630 		info[11] = user.shareAmount;
631 		info[12] = user.freeAmount;
632 		info[13] = user.bn;
633 		info[14] = user.investTimes;
634 		info[15] = user.resTime;
635 		info[16] = user.staticTims;
636 	    info[17] = user.fValue;
637 	    info[18] = user.bnTH;
638 		return (info, userGlobal.inviteCode, userGlobal.beCode,userGlobal.status);
639 	}
640 
641 	function ventura(uint amount) private {
642 		devAddr.transfer(amount.div(10));
643 		reAddr.transfer(amount.div(100));
644 	}
645 
646 	function sendMoneyToUser(address payable addr, uint money) private {
647 		if (money > 0) {
648 			addr.transfer(money);
649 		}
650 	}
651 
652 	function isUsed(string memory code) public view returns (bool) {
653 		address addr = addressMapping[code];
654 		return uint(addr) != 0;
655 	}
656 
657 	function getUserAddressByCode(string memory code) public view returns (address) {
658 		require(isWhitelist(msg.sender), "Permission denied");
659 		return addressMapping[code];
660 	}
661 
662 	function registerUser(address addr, string memory inviteCode, string memory beCode,uint status) private {
663 		UserGlobal storage userGlobal = userMapping[addr];
664 		uid++;
665 		userGlobal.id = uid;
666 		userGlobal.userAddress = addr;
667 		userGlobal.inviteCode = inviteCode;
668 		userGlobal.beCode = beCode;
669         userGlobal.status = status;
670 		addressMapping[inviteCode] = addr;
671 		indexMapping[uid] = addr;
672 	}
673 
674 	function endRound() external isFigure {
675 		require(address(this).balance < 1 ether, "contract balance must be lower than 1 ether");
676 		rid++;
677 		startTime = now.add(period).div(1 days).mul(1 days);
678 		canSetStartTime = 1;
679 	}
680 
681 	function getUserAddressById(uint id) public view returns (address) {
682 		require(isWhitelist(msg.sender));
683 		return indexMapping[id];
684 	}
685 }
686 
687 library UtilELG {
688     /* https://elgame.cc */
689 	function getLevel(uint value) public pure  returns (uint) {
690 		if (value >= 1 ether && value <= 5 ether) {
691 			return 1;
692 		}
693 		if (value >= 6 ether && value <= 10 ether) {
694 			return 2;
695 		}
696 		if (value >= 11 ether && value <= 15 ether) {
697 			return 3;
698 		}
699 		if (value >= 16 ether && value <= 30 ether) {
700 			return 4;
701 		}
702 		return 0;
703 	}
704 
705 	function getSc(uint level) public pure  returns (uint) {
706 		if (level == 1) {
707 			return 5;
708 		}
709 		if (level == 2) {
710 			return 7;
711 		}
712 		if (level == 3) {
713 			return 10;
714 		}
715 		if (level == 4) {
716 			return 12;
717 		}
718 		return 0;
719 	}
720 
721 	function getFire(uint level) public pure  returns (uint) {
722 		if (level == 1) {
723 			return 3;
724 		}
725 		if (level == 2) {
726 			return 5;
727 		}
728 		if (level == 3) {
729 			return 7;
730 		}
731 		if (level == 4) {
732 			return 10;
733 		}
734 		return 0;
735 	}
736 
737 	function recomSc(uint level, uint times) public pure returns (uint) {
738 		if (level == 1 && times == 1) {
739 			return 20;
740 		}
741 		if (level == 2 && times == 1) {
742 			return 20;
743 		}
744 		if (level == 2 && times == 2) {
745 			return 15;
746 		}
747 		if (level == 3) {
748 			if (times == 1) {
749 				return 20;
750 			}
751 			if (times == 2) {
752 				return 15;
753 			}
754 			if (times == 3) {
755 				return 10;
756 			}
757 		}
758 		if (level == 4) {
759 			if (times == 1) {
760 				return 20;
761 			}
762 			if (times == 2) {
763 				return 15;
764 			}
765 			if (times >= 3 && times <= 5) {
766 				return 10;
767 			}
768 		}
769 		if (level == 5) {
770 			if (times == 1) {
771 				return 30;
772 			}
773 			if (times == 2) {
774 				return 15;
775 			}
776 			if (times >= 3 && times <= 5) {
777 				return 10;
778 			}
779 		}
780 		if (level == 6) {
781 			if (times == 1) {
782 				return 50;
783 			}
784 			if (times == 2) {
785 				return 15;
786 			}
787 			if (times >= 3 && times <= 5) {
788 				return 10;
789 			}
790 			if (times >= 6 && times <= 10) {
791 				return 3;
792 			}
793 		}
794 		if (level == 7) {
795 			if (times == 1) {
796 				return 100;
797 			}
798 			if (times == 2) {
799 				return 15;
800 			}
801 			if (times >= 3 && times <= 5) {
802 				return 10;
803 			}
804 			if (times >= 6 && times <= 10) {
805 				return 3;
806 			}
807 			if (times >= 11 && times <= 15) {
808 				return 2;
809 			}
810 			if (times >= 16 && times <= 20) {
811 				return 1;
812 			}
813 		}
814 		return 0;
815 	}
816 
817 	function compareStr(string memory _str, string memory str) public pure returns (bool) {
818 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
819 			return true;
820 		}
821 		return false;
822 	}
823 
824 	function getEndTims(uint value) public pure  returns (uint) {
825 		if (value >= 1 ether && value <= 5 ether) {
826 			return 15;
827 		}
828 		if (value >= 6 ether && value <= 10 ether) {
829 			return 20;
830 		}
831 		if (value >= 11 ether && value <= 15 ether) {
832 			return 25;
833 		}
834 		if (value >= 16 ether && value <= 30 ether) {
835 			return 30;
836 		}
837 		return 0;
838 	}
839 }
840 
841 /**
842 * @title SafeMath
843 * @dev Math operations with safety checks that revert on error
844 */
845 library SafeMath {
846 	/**
847 	* @dev Multiplies two numbers, reverts on overflow.
848 	*/
849 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
850 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
851 		// benefit is lost if 'b' is also tested.
852 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
853 		if (a == 0) {
854 			return 0;
855 		}
856 
857 		uint256 c = a * b;
858 		require(c / a == b, "mul overflow");
859 
860 		return c;
861 	}
862 
863 	/**
864 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
865 	*/
866 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
867 		require(b > 0, "div zero");
868 		// Solidity only automatically asserts when dividing by 0
869 		uint256 c = a / b;
870 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
871 
872 		return c;
873 	}
874 
875 	/**
876 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
877 	*/
878 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
879 		require(b <= a, "lower sub bigger");
880 		uint256 c = a - b;
881 
882 		return c;
883 	}
884 
885 	/**
886 	* @dev Adds two numbers, reverts on overflow.
887 	*/
888 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
889 		uint256 c = a + b;
890 		require(c >= a, "overflow");
891 
892 		return c;
893 	}
894 
895 	/**
896 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
897 	* reverts when dividing by zero.
898 	*/
899 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
900 		require(b != 0, "mod zero");
901 		return a % b;
902 	}
903 
904 	/**
905 	* @dev compare two numbers and returns the smaller one.
906 	*/
907 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
908 		return a > b ? b : a;
909 	}
910 }