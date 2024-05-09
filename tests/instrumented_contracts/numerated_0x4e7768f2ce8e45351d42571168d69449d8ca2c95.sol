1 pragma solidity ^0.5.17;
2 //https://gfc.asia/
3 contract Ownable {
4 	address private _owner;
5 	address private nextOwner;
6 
7 	constructor () internal {
8 		_owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(isOwner(), "Ownable: caller is not the owner");
13 		_;
14 	}
15 
16 	function isOwner() public view returns (bool) {
17 		return msg.sender == _owner;
18 	}
19 
20 	function approveNextOwner(address _nextOwner) external onlyOwner {
21 		require(_nextOwner != _owner, "Cannot approve current owner.");
22 		nextOwner = _nextOwner;
23 	}
24 
25 	function acceptNextOwner() external {
26 		require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
27 		_owner = nextOwner;
28 	}
29 }
30 
31 library Roles {
32 	struct Role {
33 		mapping(address => bool) bearer;
34 	}
35 
36 	function add(Role storage role, address account) internal {
37 		require(!has(role, account), "Roles: account already has role.");
38 		role.bearer[account] = true;
39 	}
40 
41 	function remove(Role storage role, address account) internal {
42 		require(has(role, account), "Roles: account does not have role.");
43 		role.bearer[account] = false;
44 	}
45 
46 	function has(Role storage role, address account) internal view returns (bool) {
47 		require(account != address(0), "Roles: account is the zero address.");
48 		return role.bearer[account];
49 	}
50 }
51 
52 contract WhitelistAdminRole is Ownable {
53 	using Roles for Roles.Role;
54 
55 	Roles.Role private _whitelistAdmins;
56 
57 	constructor () internal {
58 	}
59 	modifier onlyWhitelistAdmin() {
60 		require(isWhitelistAdmin(msg.sender) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
61 		_;
62 	}
63 
64 	function isWhitelistAdmin(address account) public view returns (bool) {
65 		return _whitelistAdmins.has(account) || isOwner();
66 	}
67 
68 	function addWhitelistAdmin(address account) public onlyOwner {
69 		_whitelistAdmins.add(account);
70 	}
71 
72 	function removeWhitelistAdmin(address account) public onlyOwner {
73 		_whitelistAdmins.remove(account);
74 	}
75 }
76 
77 contract GFC is WhitelistAdminRole {
78 	using SafeMath for *;
79 	
80 	address  private devAddr = address(0xd67318a2022796eB685aFc84A68EAD8577d65a22);
81 	address  private devCon  = address(0xab6C0807b522d5196027fa89Af1980d490D622A7);   
82 	address  private comfort = address(0x98043DE2ACb248D768885C681373129b4e7eBA46);
83 	address  private luck    = address(0x51227Bc3fbaad4e3af3926D7A76EE3Cc9769ABEF);
84 	address  private cream   = address(0x0D65611F211cBeC27acff8EcfBA248b3c4c85441);
85 
86 	struct User {
87 		uint id;
88 		address userAddress;
89 		uint frozenAmount;
90 		uint freezeAmount;
91 		uint freeAmount;
92 		uint inviteAmonut;
93 		uint bonusAmount;
94 		uint dayBonAmount;
95 		uint dayInvAmount;
96 		uint level;
97 		uint resTime;
98 		string inviteCode;
99 		string beCode;
100 		uint lastRwTime;
101 		uint investTimes;
102 		uint lineAll;
103 		uint cn;
104 		uint cn500;
105 		uint cn5;
106 	}
107 
108 	struct UserGlobal {
109 		uint id;
110 		address userAddress;
111 		string inviteCode;
112 		string beCode;
113 		uint status;
114 	}
115     ILock _iLock = ILock(0x41645D2E0778C7A9B27B7d7F3887e5e92532c32d);
116     IUSD  usdT = IUSD(0xdAC17F958D2ee523a2206206994597C13D831ec7);
117 	uint startTime;
118 	mapping(uint => uint) rInvestCount;
119 	mapping(uint => uint) rInvestMoney;
120 	uint period = 1 days;
121 	uint uid;
122 	uint rid = 1;
123 	mapping(uint => mapping(address => User)) userRoundMapping;
124 	mapping(address => UserGlobal) userMapping;
125 	mapping(string => address) addressMapping;
126 	mapping(uint => address) indexMapping;
127 	uint bonuslimit = 3000*10**6;
128 	uint sendLimit = 20000*10**6;
129 	uint withdrawLimit = 3000*10**6;
130 	uint canSetStartTime = 1;
131 	uint maxAmount = 1900*10**6;
132 	uint public erc20BeginTime;
133 
134 	modifier isHuman() {
135 		address addr = msg.sender;
136 		uint codeLength;
137 		assembly {codeLength := extcodesize(addr)}
138 		require(codeLength == 0, "sorry, humans only");
139 		require(tx.origin == msg.sender, "sorry, humans only");
140 		_;
141 	}
142 
143 	constructor (address _addr, string memory inviteCode) public {
144 		plant(_addr, inviteCode, "");
145 	}
146 
147 	function() external payable {
148 	}
149 
150 	function cause(uint time) external onlyOwner {
151 		require(canSetStartTime == 1, "can not set start time again");
152 		require(time > now, "invalid game start time");
153 		startTime = time;
154 		canSetStartTime = 0;
155 	}
156 
157 	function version(address _dev,address _devT,address _com,address _comT,address _cream) external onlyOwner {
158 		devAddr = _dev; devCon  = _devT; comfort = _com; luck = _comT; cream = _cream;
159 	}
160     
161     function review(address _lock) external onlyOwner {
162         _iLock = ILock(_lock);
163 	}
164     
165 	function dispose() public view returns (bool) {
166 		return startTime != 0 && now > startTime;
167 	}
168 
169 	function follow(uint bonus, uint send, uint withdraw,uint maxWad) external onlyOwner {
170 		require(bonus >= 3000*10**6 && send >= 10000*10**6 && withdraw >= 3000*10**6 && maxWad>= 1900*10**6, "invalid amount");
171 		bonuslimit = bonus;
172 		sendLimit = send;
173 		withdrawLimit = withdraw;
174 		maxAmount = maxWad;
175 	}
176 
177 	function attitude(address addr, uint status) external onlyWhitelistAdmin {
178 		require(status == 0 || status == 1 || status == 2, "bad parameter status");
179 		UserGlobal storage userGlobal = userMapping[addr];
180 		userGlobal.status = status;
181 	}
182     
183 	function gain(string calldata inviteCode, string calldata beCode,uint _value) external isHuman() {
184 		require(dispose(), "game is not start");
185 		require(usdT.balanceOf(msg.sender) >= _value,"insufficient balance");
186 		usdT.transferFrom(msg.sender, address(this), _value);
187 		UserGlobal storage userGlobal = userMapping[msg.sender];
188 		if (userGlobal.id == 0) {
189 			require(!UtilGFC.rely(inviteCode, "      ") && bytes(inviteCode).length == 6, "invalid invite code");
190 			address beCodeAddr = addressMapping[beCode];
191 			require(revenue(beCode), "beCode not exist");
192 			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
193 			require(!revenue(inviteCode), "invite code is used");
194 			plant(msg.sender, inviteCode, beCode);
195 		}
196 		User storage user = userRoundMapping[rid][msg.sender];
197 		uint allWad = user.freezeAmount.add(_value).add(user.frozenAmount);
198 		require(allWad <= maxAmount && allWad >= 100*10**6, "value is larger than max");
199 		require(allWad == allWad.div(10**8).mul(10**8), "invalid msg value");
200 		uint feeAmount = _value;
201 		if (user.id != 0) {
202 			if (user.freezeAmount == 0) {
203 				user.lastRwTime = now;
204 				feeAmount = _value.add(user.frozenAmount);
205 			}
206 			if(allWad.mul(3).div(10) > user.frozenAmount){
207 			    user.freezeAmount=allWad.mul(7).div(10);
208 			    user.frozenAmount = allWad.mul(3).div(10);
209 			}else{
210 			    user.freezeAmount = user.freezeAmount.add(_value);
211 			}
212 			user.level = UtilGFC.science(allWad);
213 		} else {
214 			user.id = userGlobal.id;
215 			user.userAddress = msg.sender;
216 			user.freezeAmount = _value.mul(7).div(10);
217 			user.frozenAmount = _value.mul(3).div(10);
218 			user.level = UtilGFC.science(_value);
219 			user.inviteCode = userGlobal.inviteCode;
220 			user.beCode = userGlobal.beCode;
221 			user.resTime = now;
222 			user.lastRwTime = now;
223 			address beCodeAddr = addressMapping[userGlobal.beCode];
224 			User storage calUser = userRoundMapping[rid][beCodeAddr];
225 			if (calUser.id != 0) {
226 				calUser.cn += 1;
227 			}
228 		}
229 		rInvestCount[rid] = rInvestCount[rid].add(1);
230 		rInvestMoney[rid] = rInvestMoney[rid].add(_value);
231 		green(feeAmount);
232 		sweden(user.userAddress,_value); 
233 		uint ercWad = loss(feeAmount,msg.sender);
234 		_iLock.conTransfer(msg.sender,ercWad);
235 	}
236     function loss(uint allAmount,address _addr) private view returns(uint ercWad)  {
237         uint times = now.sub(erc20BeginTime).div(2 days);
238         uint result = 1*10**6;
239         if(times < 800){
240             for(uint i=0; i < times; i++){
241                 result = result.mul(99).div(100);
242              }
243         }else{
244             result = 0;
245         }
246         User storage user = userRoundMapping[rid][_addr];
247         ercWad = allAmount.div(10**6).div(20).mul(result).mul(1.add(user.cn5.mul(1).div(10)));
248     }
249     
250     function sweden(address _userAddr,uint wad) private {
251 		User storage user = userRoundMapping[rid][_userAddr];
252 		if (user.id == 0) {
253 			return;
254 		}
255 		user.dayBonAmount = user.freezeAmount.add(user.frozenAmount).div(100);
256 		user.investTimes = 0;
257 		string memory tem = user.beCode;
258 		uint allWad = user.freezeAmount.add(user.frozenAmount);
259 		uint myWad = user.freeAmount.add(allWad).add(user.lineAll);
260 		for (uint i = 1; i <= 30; i++) {
261 			if (UtilGFC.rely(tem, "")) {
262 				break;
263 			}
264 			address tmpAddr = addressMapping[tem];
265 			User storage cUser = userRoundMapping[rid][tmpAddr];
266 			if(cUser.id == 0){
267 			    break;
268 			}
269 			uint cAllWad = cUser.freeAmount.add(cUser.freezeAmount).add(cUser.frozenAmount).add(cUser.lineAll);
270 			cUser.lineAll = cUser.lineAll.add(wad);
271 		    if(cAllWad.add(wad) >= 10**11 && cAllWad < 10**11){
272 		        address nAddr = addressMapping[cUser.beCode];
273     			User storage nUser = userRoundMapping[rid][nAddr];
274     			if (nUser.id != 0) {
275     				nUser.cn500 += 1;
276     			}
277 			}
278 			tem = cUser.beCode;
279 		}
280 		if(allWad >= 1000*10**6 && allWad.sub(wad) < 1000*10**6 ){
281 		    address cAddr = addressMapping[user.beCode];
282 			User storage cUser = userRoundMapping[rid][cAddr];
283 			if (cUser.id != 0) {
284 				cUser.cn5 += 1;
285 			}
286 		}
287 		if(myWad >= 10**11 && myWad.sub(wad) < 10**11 ){
288 		    address cAddr = addressMapping[user.beCode];
289 			User storage cUser = userRoundMapping[rid][cAddr];
290 			if (cUser.id != 0) {
291     			cUser.cn500 += 1;
292     		}
293 		}
294 		
295 	}
296 	function course() external isHuman() {
297 		require(dispose(), "game is not start");
298 		User storage user = userRoundMapping[rid][msg.sender];
299 		require(user.freeAmount >= 60*10**6, "user has no freeAmount");
300 		uint resWad = reform(user.freeAmount);
301 
302 		if (resWad > 0 && resWad <= withdrawLimit) {
303 			stalks(msg.sender, resWad);
304 			uint allWad = user.freezeAmount.add(user.frozenAmount).add(user.freeAmount);
305 			uint myWad = allWad.add(user.lineAll);
306 			uint wad = user.freeAmount;
307 			user.freeAmount = 0;
308 			string memory tem = user.beCode;
309     		for (uint i = 1; i <= 30; i++) {
310     			address tmpAddr = addressMapping[tem];
311     			User storage cUser = userRoundMapping[rid][tmpAddr];
312     			if(cUser.id == 0){
313     			    break;
314     			}
315     			uint cAllWad = cUser.freeAmount.add(cUser.freezeAmount).add(cUser.frozenAmount).add(cUser.lineAll);
316     			if(cUser.lineAll >= wad){
317     			   cUser.lineAll = cUser.lineAll.sub(wad); 
318     			}
319 			    if(cAllWad >= 10**11 && cAllWad.sub(wad) < 10**11){
320     		        address nAddr = addressMapping[cUser.beCode];
321         			User storage nUser = userRoundMapping[rid][nAddr];
322         			if (nUser.id != 0 && nUser.cn500 >= 1) {
323         			    nUser.cn500 -= 1;
324         		    }
325 		    	}
326     			tem = cUser.beCode;
327     		}
328     		if(allWad >= 1000*10**6 && allWad.sub(wad) < 1000*10**6 ){
329     		    address cAddr = addressMapping[user.beCode];
330     			User storage cUser = userRoundMapping[rid][cAddr];
331     			if (cUser.id != 0 && cUser.cn5 >= 1) {
332     				cUser.cn5 -= 1;
333     		   	}
334     	    }
335     	    if(myWad >= 10**11 && myWad.sub(wad) < 10**11 ){
336     		    address cAddr = addressMapping[user.beCode];
337     			User storage cUser = userRoundMapping[rid][cAddr];
338     			if (cUser.id != 0 && cUser.cn500 >= 1) {
339     				cUser.cn500 -= 1;
340     		   	}
341     	    }
342 		}
343 	}
344 
345 	function watch() external isHuman {
346 		rapid(msg.sender);
347 	}
348 
349 	function merchandise(uint start, uint end) external onlyWhitelistAdmin {
350 		for (uint i = end; i >= start; i--) {
351 			address userAddr = indexMapping[i];
352 			rapid(userAddr);
353 		}
354 	}
355 
356 	function rapid(address addr) private {
357 		require(dispose(), "game is not start");
358 		User storage user = userRoundMapping[rid][addr];
359 		UserGlobal memory userGlobal = userMapping[addr];
360 		if (isWhitelistAdmin(msg.sender)) {
361 			if (now.sub(user.lastRwTime) <= 23 hours.add(58 minutes) || user.id == 0 || userGlobal.id == 0) {
362 				return;
363 			}
364 		} else {
365 			require(user.id > 0, "Users of the game are not betting in this round");
366 			require(now.sub(user.lastRwTime) >= 23 hours.add(58 minutes), "Can only be extracted once in 24 hours");
367 		}
368 		user.lastRwTime = now;
369 		if (userGlobal.status == 1) {
370 			return;
371 		}
372 		uint awardSend = 0;
373 		uint freezeAmount = user.freezeAmount.add(user.frozenAmount);
374 		uint dayBon = 0;
375 		if (user.freezeAmount >= 60*10**6 && freezeAmount >= 100*10**6 && freezeAmount <= bonuslimit) {
376 			if (user.investTimes < 5) {
377 				awardSend = awardSend.add(user.dayBonAmount);
378 				dayBon = user.dayBonAmount;
379 				user.bonusAmount = user.bonusAmount.add(user.dayBonAmount);
380 				user.investTimes = user.investTimes.add(1);
381 			}
382 			if (user.investTimes >= 5) {
383 				user.freeAmount = user.freeAmount.add(user.freezeAmount);
384 				user.freezeAmount = 0;
385 				user.dayBonAmount = 0;
386 				user.level = 0;
387 			}
388 		}
389 		if (awardSend == 0) {
390 			return;
391 		}
392 		if (userGlobal.status == 0) {
393 			awardSend = awardSend.add(user.dayInvAmount);
394 			user.inviteAmonut = user.inviteAmonut.add(user.dayInvAmount);
395 		}
396 		if (awardSend > 0 && awardSend <= sendLimit) {
397 			care(awardSend,dayBon,addr);
398 			if (user.dayInvAmount > 0) {
399 				user.dayInvAmount = 0;
400 			}
401 			if(userGlobal.status == 0) {
402 				solve(user.beCode, freezeAmount);
403 			}
404 		}
405 	}
406 
407 	function solve(string memory beCode, uint money) private {
408 		string memory tmp = beCode;
409 		for (uint i = 1; i <= 30; i++) {
410 			if (UtilGFC.rely(tmp, "")) {
411 				break;
412 			}
413 			address tmpaddr = addressMapping[tmp];
414 			UserGlobal storage global = userMapping[tmpaddr];
415 			User storage cUser = userRoundMapping[rid][tmpaddr];
416 
417 			if (global.status != 0 || cUser.freezeAmount == 0) {
418 				tmp = global.beCode;
419 				continue;
420 			}
421 			uint recommendSc = aerial(cUser.level,cUser.cn500,cUser.cn5,cUser.cn,i);
422 			uint moneyResult = 0;
423 			if (money <= cUser.freezeAmount.add(cUser.frozenAmount)) {
424 				moneyResult = money;
425 			} else {
426 				moneyResult = cUser.freezeAmount.add(cUser.frozenAmount);
427 			}
428 			if (recommendSc != 0) {
429 				uint dynamic = moneyResult.mul(recommendSc).div(10000);
430 				cUser.dayInvAmount = cUser.dayInvAmount.add(dynamic);
431 			}
432 			tmp = global.beCode;
433 		}
434 	}
435 	function aerial(uint level,uint sn500,uint sn5,uint sn,uint index) private pure returns (uint){
436 		if(level == 3 && sn5 >= 6){
437 		    if (sn500 >= 3) {
438 		    	level = 6;
439     		}else if (sn500 >= 2) {
440     			level = 5;
441     		}else if (sn500 >= 1) {
442     			level = 4;
443     		}
444 		}
445 		return UtilGFC.rather(level,sn5,sn, index);
446 	}
447     
448 	function care(uint _send,uint dayBon,address addr) private {
449 		uint result = reform(_send);
450 		if (result > 0 && result <= sendLimit) {
451 			if(result > dayBon){
452 			    uint rand = uint256(keccak256(abi.encodePacked(block.number, now))).mod(10).add(1);
453 			   	uint confort = result.sub(dayBon).div(100).mul(rand); 
454     			stalks(comfort, confort.mul(3).div(5));
455     			stalks(luck, confort.mul(1).div(5));
456     			stalks(cream, confort.mul(1).div(5));
457     			result = result.sub(confort);
458 			}
459 			stalks(addr, result);
460 		}
461 	}
462 
463 	function reform(uint sendMoney) private view returns (uint) {
464 		if ( usdT.balanceOf(address(this)) >= sendMoney) {
465 			return sendMoney;
466 		} else {
467 			return usdT.balanceOf(address(this));
468 		}
469 	}
470 
471 	function green(uint amount) private {
472 		usdT.transfer(devAddr,amount.div(50));
473 		usdT.transfer(devCon,amount.div(50));
474 	}
475     
476 	function stalks(address userAddress, uint money) private {
477 		if (money > 0) {
478 			usdT.transfer(userAddress,money);
479 		}
480 	}
481     
482     function plant(address addr, string memory inviteCode, string memory beCode) private {
483         if(uid == 1){
484             erc20BeginTime = now;
485         }
486 		UserGlobal storage userGlobal = userMapping[addr];
487 		uid++;
488 		userGlobal.id = uid;
489 		userGlobal.userAddress = addr;
490 		userGlobal.inviteCode = inviteCode;
491 		userGlobal.beCode = beCode;
492 
493 		addressMapping[inviteCode] = addr;
494 		indexMapping[uid] = addr;
495 	}
496 
497 	function against() external onlyOwner {
498 		require(usdT.balanceOf(address(this)) < 100*10**6, "contract balance must be lower than 100*10**6");
499 		rid++;
500 		startTime = now.add(period).div(1 days).mul(1 days);
501 		canSetStartTime = 1;
502 	}
503         
504 	function circuit() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint,uint) {
505 		return (
506 		rid,
507 		uid,
508 		startTime,
509 		rInvestCount[rid],
510 		rInvestMoney[rid],
511 		bonuslimit,
512 		sendLimit,
513 		withdrawLimit,
514 		canSetStartTime,
515 		maxAmount
516 		);
517 	}
518         
519 	function chip(address addr, uint roundId) public view returns (uint[17] memory info, string memory inviteCode, string memory beCode) {
520 		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");
521 
522 		if (roundId == 0) {
523 			roundId = rid;
524 		}
525 
526 		UserGlobal memory userGlobal = userMapping[addr];
527 		User memory user = userRoundMapping[roundId][addr];
528 		info[0] = userGlobal.id;
529 		info[1] = user.freezeAmount;
530 		info[2] = user.inviteAmonut;
531 		info[3] = user.bonusAmount;
532 		info[4] = user.dayBonAmount;
533 		info[5] = user.level;
534 		info[6] = user.dayInvAmount;
535 		info[7] = user.lastRwTime;
536 		info[8] = userGlobal.status;
537 		info[9] = user.freeAmount;
538 		info[10] = user.cn;
539 		info[11] = user.investTimes;
540 		info[12] = user.resTime;
541 		info[13] = user.lineAll;
542 		info[14] = user.frozenAmount;
543 		info[15] = user.cn500;
544 		info[16] = user.cn5;
545 		return (info, userGlobal.inviteCode, userGlobal.beCode);
546 	}
547 
548 	function revenue(string memory code) public view returns (bool) {
549 		address addr = addressMapping[code];
550 		return uint(addr) != 0;
551 	}
552 
553 	function material(string memory code) public view returns (address) {
554 		require(isWhitelistAdmin(msg.sender), "Permission denied");
555 		return addressMapping[code];
556 	}
557 
558 	function loopback(uint id) public view returns (address) {
559 		require(isWhitelistAdmin(msg.sender));
560 		return indexMapping[id];
561 	}
562 }
563 
564 library UtilGFC {
565 	function science(uint value) public pure  returns (uint) {
566 		if (value >= 100*10**6 && value < 1000*10**6) {
567 			return 1;
568 		}
569 		if (value >= 1000*10**6 && value < 2000*10**6) {
570 			return 2;
571 		}
572 		if (value >= 2000*10**6 && value <= 3000*10**6) {
573 			return 3;
574 		}
575 		return 0;
576 	}
577 	function rather(uint level,uint sn5, uint sn,uint times) public pure returns (uint) {
578 		if(level >= 1){
579 		    if(times == 1){
580 		        return 100;
581 		    }
582 		    if(sn >= 2 && times == 2){
583 		        return 50;
584 		    }
585 		    if(sn >= 3 && times == 3){
586 		        return 30;
587 		    }
588 		}
589 		if(level >= 2){
590 		    if(sn5 >= 3 && times >= 4 && times <= 10){
591 		        return 10;
592 		    }
593 		}
594 		if(level >= 3){
595 		    if(sn5 >= 6 && times >= 11 && times <= 20){
596 		        return 5;
597 		    }
598 		}
599 		if(level >= 4){
600 		    if( times >= 21 && times <= 30){
601 		        return 1;
602 		    }
603 		}
604 	    if(level >= 5){
605 		    if(times >= 21 && times <= 30){
606 		        return 2;
607 		    }
608 		}
609 		if(level >= 6){
610 		    if(times >= 21 && times <= 30){
611 		        return 3;
612 		    }
613 		}
614 		return 0;
615 	}
616 	function rely(string memory _str, string memory str) public pure returns (bool) {
617 		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
618 			return true;
619 		}
620 		return false;
621 	}
622 }
623 
624 library SafeMath {
625 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
626 		if (a == 0) {
627 			return 0;
628 		}
629 
630 		uint256 c = a * b;
631 		require(c / a == b, "mul overflow");
632 
633 		return c;
634 	}
635 
636 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
637 		require(b > 0, "div zero");
638 		uint256 c = a / b;
639 		return c;
640 	}
641 
642 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
643 		require(b <= a, "lower sub bigger");
644 		uint256 c = a - b;
645 
646 		return c;
647 	}
648 
649 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
650 		uint256 c = a + b;
651 		require(c >= a, "overflow");
652 
653 		return c;
654 	}
655 
656 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
657 		require(b != 0, "mod zero");
658 		return a % b;
659 	}
660 
661 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
662 		return a > b ? b : a;
663 	}
664 }
665 interface ILock {
666     function conTransfer(address _addr,uint wad) external;
667     function transfer(address recipient, uint256 amount) external returns (bool);
668 }
669 interface IUSD {
670     function transfer(address recipient, uint256 amount) external;
671     function transferFrom(address sender, address recipient, uint256 amount) external;
672     function balanceOf(address account) external view returns (uint256);
673 }