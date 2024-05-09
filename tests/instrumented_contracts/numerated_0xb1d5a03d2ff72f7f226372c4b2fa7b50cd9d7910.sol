1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 	function mul (uint256 a, uint256 b) internal pure returns (uint256) {
5 		if (a == 0) {
6 			return 0;
7 		}
8 		uint256 c = a * b;
9 		assert(c / a == b);
10 		return c;
11 	}
12 
13 	function div (uint256 a, uint256 b) internal pure returns (uint256) {
14 		return a / b;
15 	}
16 
17 	function sub (uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add (uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract ERCBasic {
30 	event Transfer(address indexed from, address indexed to, uint256 value);
31 
32 	function totalSupply () public view returns (uint256);
33 	function balanceOf (address who) public view returns (uint256);
34 	function transfer (address to, uint256 value) public returns (bool);
35 }
36 
37 contract ERC is ERCBasic {
38 	event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40 	function transferFrom (address from, address to, uint256 value) public returns (bool);
41 	function allowance (address owner, address spender) public view returns (uint256);
42 	function approve (address spender, uint256 value) public returns (bool);
43 }
44 
45 contract Ownable {
46 	event OwnershipTransferred(address indexed oldone, address indexed newone);
47 	event FoundationOwnershipTransferred(address indexed oldFoundationOwner, address indexed newFoundationOwner);
48 
49 	address internal owner;
50 	address internal foundationOwner;
51 
52 	constructor () public {
53 		owner = msg.sender;
54 		foundationOwner = owner;
55 	}
56 
57 	modifier onlyOwner () {
58 		require(msg.sender == owner);
59 		_;
60 	}
61 
62 	modifier hasMintability () {
63 		require(msg.sender == owner || msg.sender == foundationOwner);
64 		_;
65 	}
66 
67 	function transferOwnership (address newOwner) public returns (bool);
68 	
69 	function setFountainFoundationOwner (address foundation) public returns (bool);
70 }
71 
72 contract Pausable is Ownable {
73 	event ContractPause();
74 	event ContractResume();
75 	event ContractPauseSchedule(uint256 from, uint256 to);
76 
77 	uint256 internal pauseFrom;
78 	uint256 internal pauseTo;
79 
80 	modifier whenRunning () {
81 		require(now < pauseFrom || now > pauseTo);
82 		_;
83 	}
84 
85 	modifier whenPaused () {
86 		require(now >= pauseFrom && now <= pauseTo);
87 		_;
88 	}
89 
90 	function pause () public onlyOwner {
91 		pauseFrom = now - 1;
92 		pauseTo = now + 30000 days;
93 		emit ContractPause();
94 	}
95 
96 	function pause (uint256 from, uint256 to) public onlyOwner {
97 		require(to > from);
98 		pauseFrom = from;
99 		pauseTo = to;
100 		emit ContractPauseSchedule(from, to);
101 	}
102 
103 	function resume () public onlyOwner {
104 		pauseFrom = now - 2;
105 		pauseTo = now - 1;
106 		emit ContractResume();
107 	}
108 }
109 
110 contract TokenForge is Ownable {
111 	event ForgeStart();
112 	event ForgeStop();
113 
114 	bool public forge_running = true;
115 
116 	modifier canForge () {
117 		require(forge_running);
118 		_;
119 	}
120 
121 	modifier cannotForge () {
122 		require(!forge_running);
123 		_;
124 	}
125 
126 	function startForge () public onlyOwner cannotForge returns (bool) {
127 		forge_running = true;
128 		emit ForgeStart();
129 		return true;
130 	}
131 
132 	function stopForge () public onlyOwner canForge returns (bool) {
133 		forge_running = false;
134 		emit ForgeStop();
135 		return true;
136 	}
137 }
138 
139 
140 
141 
142 
143 contract CappedToken is Ownable {
144 	using SafeMath for uint256;
145 
146 	uint256 public token_cap;
147 	uint256 public token_created;
148 	uint256 public token_foundation_cap;
149 	uint256 public token_foundation_created;
150 
151 
152 	constructor (uint256 _cap, uint256 _foundationCap) public {
153 		token_cap = _cap;
154 		token_foundation_cap = _foundationCap;
155 	}
156 
157 	function changeCap (uint256 _cap) public onlyOwner returns (bool) {
158 		if (_cap < token_created && _cap > 0) return false;
159 		token_cap = _cap;
160 		return true;
161 	}
162 
163 	function canMint (uint256 amount) public view returns (bool) {
164 		return (token_cap == 0) || (token_created.add(amount) <= token_cap);
165 	}
166 	
167 	function canMintFoundation(uint256 amount) internal view returns(bool) {
168 		return(token_foundation_created.add(amount) <= token_foundation_cap);
169 	}
170 }
171 
172 contract BasicToken is ERCBasic, Pausable {
173 	using SafeMath for uint256;
174 
175 	mapping(address => uint256) public wallets;
176 
177 	modifier canTransfer (address _from, address _to, uint256 amount) {
178 		require((_from != address(0)) && (_to != address(0)));
179 		require(_from != _to);
180 		require(amount > 0);
181 		_;
182 	}
183 
184 	function balanceOf (address user) public view returns (uint256) {
185 		return wallets[user];
186 	}
187 }
188 
189 contract DelegatableToken is ERC, BasicToken {
190 	using SafeMath for uint256;
191 
192 	mapping(address => mapping(address => uint256)) public warrants;
193 
194 	function allowance (address owner, address delegator) public view returns (uint256) {
195 		return warrants[owner][delegator];
196 	}
197 
198 	function approve (address delegator, uint256 value) public whenRunning returns (bool) {
199 		if (delegator == msg.sender) return true;
200 		warrants[msg.sender][delegator] = value;
201 		emit Approval(msg.sender, delegator, value);
202 		return true;
203 	}
204 
205 	function increaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
206 		if (delegator == msg.sender) return true;
207 		uint256 value = warrants[msg.sender][delegator].add(delta);
208 		warrants[msg.sender][delegator] = value;
209 		emit Approval(msg.sender, delegator, value);
210 		return true;
211 	}
212 
213 	function decreaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
214 		if (delegator == msg.sender) return true;
215 		uint256 value = warrants[msg.sender][delegator];
216 		if (value < delta) {
217 			value = 0;
218 		}
219 		else {
220 			value = value.sub(delta);
221 		}
222 		warrants[msg.sender][delegator] = value;
223 		emit Approval(msg.sender, delegator, value);
224 		return true;
225 	}
226 }
227 
228 contract LockableProtocol is BasicToken {
229 	function invest (address investor, uint256 amount) public returns (bool);
230 	function getInvestedToken (address investor) public view returns (uint256);
231 	function getLockedToken (address investor) public view returns (uint256);
232 	function availableWallet (address user) public view returns (uint256) {
233 		return wallets[user].sub(getLockedToken(user));
234 	}
235 }
236 
237 contract MintAndBurnToken is TokenForge, CappedToken, LockableProtocol {
238 	using SafeMath for uint256;
239 	
240 	event Mint(address indexed user, uint256 amount);
241 	event Burn(address indexed user, uint256 amount);
242 
243 	constructor (uint256 _initial, uint256 _cap, uint256 _fountainCap) public CappedToken(_cap, _fountainCap) {
244 		token_created = _initial;
245 		wallets[msg.sender] = _initial;
246 
247 		emit Mint(msg.sender, _initial);
248 		emit Transfer(address(0), msg.sender, _initial);
249 	}
250 
251 	function totalSupply () public view returns (uint256) {
252 		return token_created;
253 	}
254 
255 	function totalFountainSupply() public view returns(uint256) {
256 		return token_foundation_created;
257 	}
258 
259 	function mint (address target, uint256 amount) public hasMintability whenRunning canForge returns (bool) {
260 		require(target != owner && target != foundationOwner);
261 		require(canMint(amount));
262 
263 		if (msg.sender == foundationOwner) {
264 			require(canMintFoundation(amount));
265 			token_foundation_created = token_foundation_created.add(amount);
266 		}
267 		
268 		token_created = token_created.add(amount);
269 		wallets[target] = wallets[target].add(amount);
270 
271 		emit Mint(target, amount);
272 		emit Transfer(address(0), target, amount);
273 		return true;
274 	}
275 
276 	function burn (uint256 amount) public whenRunning canForge returns (bool) {
277 		uint256 balance = availableWallet(msg.sender);
278 		require(amount <= balance);
279 
280 		token_created = token_created.sub(amount);
281 		wallets[msg.sender] = wallets[msg.sender].sub(amount);
282 
283 		emit Burn(msg.sender, amount);
284 		emit Transfer(msg.sender, address(0), amount);
285 
286 		return true;
287 	}
288 }
289 
290 contract LockableToken is MintAndBurnToken, DelegatableToken {
291 	using SafeMath for uint256;
292 
293 	struct LockBin {
294 		uint256 start;
295 		uint256 finish;
296 		uint256 duration;
297 		uint256 amount;
298 	}
299 
300 	event InvestStart();
301 	event InvestStop();
302 	event NewInvest(uint256 release_start, uint256 release_duration);
303 
304 	uint256 public releaseStart;
305 	uint256 public releaseDuration;
306 	bool public forceStopInvest;
307 	mapping(address => mapping(uint => LockBin)) public lockbins;
308 
309 	modifier canInvest () {
310 		require(!forceStopInvest);
311 		_;
312 	}
313 
314 	constructor (uint256 _initial, uint256 _cap, uint256 _fountainCap) public MintAndBurnToken(_initial, _cap, _fountainCap) {
315 		forceStopInvest = true;
316 	}
317 
318 	function pauseInvest () public onlyOwner whenRunning returns (bool) {
319 		require(!forceStopInvest);
320 		forceStopInvest = true;
321 		emit InvestStop();
322 		return true;
323 	}
324 
325 	function resumeInvest () public onlyOwner whenRunning returns (bool) {
326 		require(forceStopInvest);
327 		forceStopInvest = false;
328 		emit InvestStart();
329 		return true;
330 	}
331 
332 	function setInvest (uint256 release_start, uint256 release_duration) public onlyOwner whenRunning returns (bool) {
333 		releaseStart = release_start;
334 		releaseDuration = release_duration;
335 		require(releaseStart + releaseDuration > releaseStart);
336 		forceStopInvest = false;
337 
338 		emit NewInvest(release_start, release_duration);
339 		return true;
340 	}
341 
342 	function invest (address investor, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
343 		require(investor != address(0));
344 		require(investor != owner);
345 		require(investor != foundationOwner);
346 		require(amount > 0);
347 		require(canMint(amount));
348 
349 		mapping(uint => LockBin) locks = lockbins[investor];
350 		LockBin storage info = locks[0];
351 		uint index = info.amount + 1;
352 		locks[index] = LockBin({
353 			start: releaseStart,
354 			finish: releaseStart + releaseDuration,
355 			duration: releaseDuration / (1 days),
356 			amount: amount
357 		});
358 		info.amount = index;
359 
360 		token_created = token_created.add(amount);
361 		wallets[investor] = wallets[investor].add(amount);
362 		emit Mint(investor, amount);
363 		emit Transfer(address(0), investor, amount);
364 
365 		return true;
366 	}
367 
368 	function batchInvest (address[] investors, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
369 		require(amount > 0);
370 
371 		uint investorsLength = investors.length;
372 		uint investorsCount = 0;
373 		uint i;
374 		address r;
375 		for (i = 0; i < investorsLength; i ++) {
376 			r = investors[i];
377 			if (r == address(0) || r == owner || r == foundationOwner) continue;
378 			investorsCount ++;
379 		}
380 		require(investorsCount > 0);
381 
382 		uint256 totalAmount = amount.mul(uint256(investorsCount));
383 		require(canMint(totalAmount));
384 
385 		token_created = token_created.add(totalAmount);
386 
387 		for (i = 0; i < investorsLength; i ++) {
388 			r = investors[i];
389 			if (r == address(0) || r == owner || r == foundationOwner) continue;
390 
391 			mapping(uint => LockBin) locks = lockbins[r];
392 			LockBin storage info = locks[0];
393 			uint index = info.amount + 1;
394 			locks[index] = LockBin({
395 				start: releaseStart,
396 				finish: releaseStart + releaseDuration,
397 				duration: releaseDuration / (1 days),
398 				amount: amount
399 			});
400 			info.amount = index;
401 
402 			wallets[r] = wallets[r].add(amount);
403 			emit Mint(r, amount);
404 			emit Transfer(address(0), r, amount);
405 		}
406 
407 		return true;
408 	}
409 
410 	function batchInvests (address[] investors, uint256[] amounts) public onlyOwner whenRunning canInvest returns (bool) {
411 		uint investorsLength = investors.length;
412 		require(investorsLength == amounts.length);
413 
414 		uint investorsCount = 0;
415 		uint256 totalAmount = 0;
416 		uint i;
417 		address r;
418 		for (i = 0; i < investorsLength; i ++) {
419 			r = investors[i];
420 			if (r == address(0) || r == owner || r == foundationOwner) continue;
421 			investorsCount ++;
422 			totalAmount = totalAmount.add(amounts[i]);
423 		}
424 		require(totalAmount > 0);
425 		require(canMint(totalAmount));
426 
427 		uint256 amount;
428 		token_created = token_created.add(totalAmount);
429 		for (i = 0; i < investorsLength; i ++) {
430 			r = investors[i];
431 			if (r == address(0) || r == owner || r == foundationOwner) continue;
432 			amount = amounts[i];
433 			if (amount == 0) continue;
434 			wallets[r] = wallets[r].add(amount);
435 			emit Mint(r, amount);
436 			emit Transfer(address(0), r, amount);
437 
438 			mapping(uint => LockBin) locks = lockbins[r];
439 			LockBin storage info = locks[0];
440 			uint index = info.amount + 1;
441 			locks[index] = LockBin({
442 				start: releaseStart,
443 				finish: releaseStart + releaseDuration,
444 				duration: releaseDuration / (1 days),
445 				amount: amount
446 			});
447 			info.amount = index;
448 		}
449 
450 		return true;
451 	}
452 
453 	function getInvestedToken (address investor) public view returns (uint256) {
454 		require(investor != address(0) && investor != owner && investor != foundationOwner);
455 
456 		mapping(uint => LockBin) locks = lockbins[investor];
457 		uint256 balance = 0;
458 		uint l = locks[0].amount;
459 		for (uint i = 1; i <= l; i ++) {
460 			LockBin memory bin = locks[i];
461 			balance = balance.add(bin.amount);
462 		}
463 		return balance;
464 	}
465 
466 	function getLockedToken (address investor) public view returns (uint256) {
467 		require(investor != address(0) && investor != owner && investor != foundationOwner);
468 
469 		mapping(uint => LockBin) locks = lockbins[investor];
470 		uint256 balance = 0;
471 		uint256 d = 1;
472 		uint l = locks[0].amount;
473 		for (uint i = 1; i <= l; i ++) {
474 			LockBin memory bin = locks[i];
475 			if (now <= bin.start) {
476 				balance = balance.add(bin.amount);
477 			}
478 			else if (now < bin.finish) {
479 				d = (now - bin.start) / (1 days);
480 				balance = balance.add(bin.amount - bin.amount * d / bin.duration);
481 			}
482 		}
483 		return balance;
484 	}
485 
486 	function canPay (address user, uint256 amount) internal view returns (bool) {
487 		uint256 balance = availableWallet(user);
488 		return amount <= balance;
489 	}
490 
491 	function transfer (address target, uint256 value) public whenRunning canTransfer(msg.sender, target, value) returns (bool) {
492 		require(target != owner);
493 		require(canPay(msg.sender, value));
494 
495 		wallets[msg.sender] = wallets[msg.sender].sub(value);
496 		wallets[target] = wallets[target].add(value);
497 		emit Transfer(msg.sender, target, value);
498 		return true;
499 	}
500 
501 
502 	function batchTransfer (address[] receivers, uint256 amount) public whenRunning returns (bool) {
503 		require(amount > 0);
504 
505 		uint receiveLength = receivers.length;
506 		uint receiverCount = 0;
507 		uint i;
508 		address r;
509 		for (i = 0; i < receiveLength; i ++) {
510 			r = receivers[i];
511 			if (r == address(0) || r == owner) continue;
512 			receiverCount ++;
513 		}
514 		require(receiverCount > 0);
515 
516 		uint256 totalAmount = amount.mul(uint256(receiverCount));
517 		require(canPay(msg.sender, totalAmount));
518 
519 		wallets[msg.sender] = wallets[msg.sender].sub(totalAmount);
520 		for (i = 0; i < receiveLength; i++) {
521 			r = receivers[i];
522 			if (r == address(0) || r == owner) continue;
523 			wallets[r] = wallets[r].add(amount);
524 			emit Transfer(msg.sender, r, amount);
525 		}
526 		return true;
527 	}
528 
529 	function batchTransfers (address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
530 		uint receiveLength = receivers.length;
531 		require(receiveLength == amounts.length);
532 
533 		uint receiverCount = 0;
534 		uint256 totalAmount = 0;
535 		uint i;
536 		address r;
537 		for (i = 0; i < receiveLength; i ++) {
538 			r = receivers[i];
539 			if (r == address(0) || r == owner) continue;
540 			receiverCount ++;
541 			totalAmount = totalAmount.add(amounts[i]);
542 		}
543 		require(totalAmount > 0);
544 		require(canPay(msg.sender, totalAmount));
545 
546 		wallets[msg.sender] = wallets[msg.sender].sub(totalAmount);
547 		uint256 amount;
548 		for (i = 0; i < receiveLength; i++) {
549 			r = receivers[i];
550 			if (r == address(0) || r == owner) continue;
551 			amount = amounts[i];
552 			if (amount == 0) continue;
553 			wallets[r] = wallets[r].add(amount);
554 			emit Transfer(msg.sender, r, amount);
555 		}
556 		return true;
557 	}
558 
559 	function transferFrom (address from, address to, uint256 value) public whenRunning canTransfer(from, to, value) returns (bool) {
560 		require(from != owner);
561 		require(to != owner);
562 		require(canPay(from, value));
563 
564 		uint256 warrant;
565 		if (msg.sender != from) {
566 			warrant = warrants[from][msg.sender];
567 			require(value <= warrant);
568 			warrants[from][msg.sender] = warrant.sub(value);
569 		}
570 
571 		wallets[from] = wallets[from].sub(value);
572 		wallets[to] = wallets[to].add(value);
573 		emit Transfer(from, to, value);
574 		return true;
575 	}
576 
577 	function batchTransferFrom (address from, address[] receivers, uint256 amount) public whenRunning returns (bool) {
578 		require(from != address(0) && from != owner);
579 		require(amount > 0);
580 
581 		uint receiveLength = receivers.length;
582 		uint receiverCount = 0;
583 		uint i;
584 		address r;
585 		for (i = 0; i < receiveLength; i ++) {
586 			r = receivers[i];
587 			if (r == address(0) || r == owner) continue;
588 			receiverCount ++;
589 		}
590 		require(receiverCount > 0);
591 
592 		uint256 totalAmount = amount.mul(uint256(receiverCount));
593 		require(canPay(from, totalAmount));
594 
595 		uint256 warrant;
596 		if (msg.sender != from) {
597 			warrant = warrants[from][msg.sender];
598 			require(totalAmount <= warrant);
599 			warrants[from][msg.sender] = warrant.sub(totalAmount);
600 		}
601 
602 		wallets[from] = wallets[from].sub(totalAmount);
603 		for (i = 0; i < receiveLength; i++) {
604 			r = receivers[i];
605 			if (r == address(0) || r == owner) continue;
606 			wallets[r] = wallets[r].add(amount);
607 			emit Transfer(from, r, amount);
608 		}
609 		return true;
610 	}
611 
612 	function batchTransferFroms (address from, address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
613 		require(from != address(0) && from != owner);
614 
615 		uint receiveLength = receivers.length;
616 		require(receiveLength == amounts.length);
617 
618 		uint receiverCount = 0;
619 		uint256 totalAmount = 0;
620 		uint i;
621 		address r;
622 		for (i = 0; i < receiveLength; i ++) {
623 			r = receivers[i];
624 			if (r == address(0) || r == owner) continue;
625 			receiverCount ++;
626 			totalAmount = totalAmount.add(amounts[i]);
627 		}
628 		require(totalAmount > 0);
629 		require(canPay(from, totalAmount));
630 
631 		uint256 warrant;
632 		if (msg.sender != from) {
633 			warrant = warrants[from][msg.sender];
634 			require(totalAmount <= warrant);
635 			warrants[from][msg.sender] = warrant.sub(totalAmount);
636 		}
637 
638 		wallets[from] = wallets[from].sub(totalAmount);
639 		uint256 amount;
640 		for (i = 0; i < receiveLength; i++) {
641 			r = receivers[i];
642 			if (r == address(0) || r == owner) continue;
643 			amount = amounts[i];
644 			if (amount == 0) continue;
645 			wallets[r] = wallets[r].add(amount);
646 			emit Transfer(from, r, amount);
647 		}
648 		return true;
649 	}
650 }
651 
652 contract PunchableToken is LockableToken {
653     using SafeMath for uint256;
654 	
655 	function punch (address addr, uint256 amount) public onlyOwner whenPaused returns (bool) {
656 	    require(addr != address(0) && addr != owner);
657 		require(amount > 0);
658 	    uint256 accountAmount = availableWallet(addr);
659 	    uint256 burnAmount = amount;
660 	    if (amount > accountAmount) {
661 	        burnAmount = accountAmount;
662 	    }
663 	    token_created = token_created.sub(burnAmount);
664 		wallets[addr] = wallets[addr].sub(burnAmount);
665 		emit Burn(addr, burnAmount);
666 		emit Transfer(addr, address(0), burnAmount);
667 	    
668 	    return true;
669 	}
670 	
671 	function batchPunchKO (address[] addrs) public onlyOwner whenPaused returns (bool) {
672 	    uint len = addrs.length;
673 	    require (len > 0);
674 	    address addr;
675 	    
676 	    for (uint i = 0; i < len; i++) {
677 	        addr = addrs[i];
678 	        if (addr == address(0) || addr == owner) continue;
679 	        uint256 amount = availableWallet(addr);
680 	        token_created = token_created.sub(amount);
681 		    wallets[addr] = wallets[addr].sub(amount);
682 		    emit Burn(addr, amount);
683 		    emit Transfer(addr, address(0), amount);
684 	    }
685 		return true;
686 	}
687 	
688 	
689 	function batchPunchs (address[] addrs, uint256[] amounts) public onlyOwner whenPaused returns (bool) {
690 	    uint len = addrs.length;
691 	    require (len > 0);
692 	    require (addrs.length == amounts.length);
693 
694 	    address addr;
695 	    uint256 amount;
696 	    uint256 availableAmount;
697 	    
698 	    for (uint i = 0; i < len; i++) {
699 	        addr = addrs[i];
700 	        if (addr == address(0) || addr == owner) continue;
701 	        amount = amounts[i];
702 	        availableAmount = availableWallet(addr);
703 	        if (amount > availableAmount) {
704 	            amount = availableAmount;
705 	        }
706 	        token_created = token_created.sub(amount);
707 		    wallets[addr] = wallets[addr].sub(amount);
708 		    emit Burn(addr, amount);
709 		    emit Transfer(addr, address(0), amount);
710 	    }
711 		return true;
712 	}
713 	
714     
715 }
716 
717 contract FountainToken is PunchableToken {
718 	string  public constant name     = "Fountain";
719 	string  public constant symbol   = "FTN";
720 	uint8   public constant decimals = 18;
721 
722 	uint256 private constant TOKEN_CAP     = 10000000000 * 10 ** uint256(decimals);
723 	uint256 private constant TOKEN_FOUNDATION_CAP = 300000000   * 10 ** uint256(decimals);
724 	uint256 private constant TOKEN_INITIAL = 0   * 10 ** uint256(decimals);
725 
726 	constructor () public LockableToken(TOKEN_INITIAL, TOKEN_CAP, TOKEN_FOUNDATION_CAP) {
727 	}
728 
729 	function suicide () public onlyOwner {
730 		selfdestruct(owner);
731 	}
732 
733 	function transferOwnership (address newOwner) public onlyOwner returns (bool) {
734 		require(newOwner != address(0));
735 		require(newOwner != owner);
736 		require(newOwner != foundationOwner);
737 		require(wallets[owner] == 0);
738 		require(wallets[newOwner] == 0);
739 
740 		address oldOwner = owner;
741 		owner = newOwner;
742 		emit OwnershipTransferred(oldOwner, newOwner);
743 		
744 		return true;
745 	}
746 	
747 	function setFountainFoundationOwner (address newFoundationOwner) public onlyOwner returns (bool) {
748 		require(newFoundationOwner != address(0));
749 		require(newFoundationOwner != foundationOwner);
750 		require(newFoundationOwner != owner);
751 		require(wallets[newFoundationOwner] == 0);
752 
753 		address oldFoundation = foundationOwner;
754 		foundationOwner = newFoundationOwner;
755 
756 		emit FoundationOwnershipTransferred(oldFoundation, foundationOwner);
757 
758 		uint256 all = wallets[oldFoundation];
759 		wallets[oldFoundation] -= all;
760 		wallets[newFoundationOwner] = all;
761 		emit Transfer(oldFoundation, newFoundationOwner, all);
762 
763 		return true;
764 	}
765 	
766 }
767 
768 
769 
770 contract FountainTokenUpgrade is FountainToken {
771 	event UpgradeStart();
772 	event UpgradeStop();
773 	event SetRefund(address, uint);
774 	event Refund(address, uint);
775 	event SetFoundation(uint);
776 	event FinishUpgrade();
777 	
778 	bool public upgrade_running;
779 
780 	bool public upgrade_finish;
781 	
782 	FountainToken ftn;
783 	
784 	address public oldContract;
785 	
786 	mapping(address=>bool) public upgraded;
787 	mapping(address=>bool) public skiplist;
788 
789 	mapping(address=>uint) public refundlist;
790 
791 
792 	constructor(address old){
793 		oldContract = old;
794 		ftn = FountainToken(old);
795 	}
796 
797 	modifier canUpgrade(){
798 		require(!upgrade_finish);
799 		_;
800 	}
801 
802 	modifier whenUpgrading() {
803 		require(upgrade_running);
804 		_;
805 	}
806 
807 	modifier whenNotUpgrading() {
808 		require(!upgrade_running);
809 		_;
810 	}
811 
812 	function finishUpgrade() public whenNotUpgrading canUpgrade onlyOwner{
813 		upgrade_finish = true;
814 		emit FinishUpgrade();
815 	}
816 
817 	function setFoundation(uint amount) public whenUpgrading whenPaused canUpgrade onlyOwner {
818 		token_foundation_created = amount;
819 		emit SetFoundation(amount);
820 	}
821 
822 	function setRefund(address addr, uint amount) public whenUpgrading canUpgrade onlyOwner {
823 		require(addr != address(0));
824 		require(addr != foundationOwner);
825 		require(addr != owner);
826 		refundlist[addr] = amount;
827 		emit SetRefund(addr, amount);
828 	}
829 
830 	function batchSetRefund(address[] addrs, uint[] amounts) public whenUpgrading canUpgrade onlyOwner {
831 		uint l1 = addrs.length;
832 		uint l2 = amounts.length;
833 		address addr;
834 		uint amount;
835 		require(l1 > 0 && l1 == l2);
836 		for (uint i = 0; i < l1; i++){
837 			addr = addrs[i];
838 			amount = amounts[i];
839 			if (addr == address(0) || addr == foundationOwner || addr == owner) continue;
840 			refundlist[addr] = amount;
841 			emit SetRefund(addr, amount);
842 		}
843 	}
844 
845 
846 	function runRefund(address addr) public whenUpgrading canUpgrade onlyOwner {
847 		uint amount = refundlist[addr];
848 		wallets[addr] = wallets[addr].add(amount); 
849 		token_created = token_created.add(amount);
850 		refundlist[addr] = 0;
851 		emit Refund(addr, amount);
852 		emit Mint(addr, amount);
853 		emit Transfer(address(0), addr, amount);
854 	}
855 
856 	function batchRunRefund(address[] addrs) public whenUpgrading canUpgrade onlyOwner {
857 		uint l = addrs.length;
858 		address addr;
859 		uint amount;
860 		require(l > 0);
861 		for (uint i = 0; i < l; i++){
862 			addr = addrs[i];
863 			amount = refundlist[addr];
864 			wallets[addr] = wallets[addr].add(amount); 
865 			token_created = token_created.add(amount);
866 			refundlist[addr] = 0;
867 			emit Refund(addr, amount);
868 			emit Mint(addr, amount);
869 			emit Transfer(address(0), addr, amount);
870 		}
871 	}
872 
873 	function startUpgrade() public whenNotUpgrading canUpgrade onlyOwner {
874 		upgrade_running = true;
875 		emit UpgradeStart();
876 	}
877 
878 	function stopUpgrade() public whenUpgrading canUpgrade onlyOwner {
879 		upgrade_running = false;
880 		emit UpgradeStop();
881 	}
882 
883 	function setSkiplist(address[] addrs) public whenUpgrading whenPaused canUpgrade onlyOwner {
884 		uint len = addrs.length;
885 		if (len>0){
886 			for (uint i = 0; i < len; i++){
887 				skiplist[addrs[i]] = true;
888 			}
889 		}
890 	}
891 
892 	function upgrade(address addr) whenUpgrading whenPaused canUpgrade onlyOwner{
893 		uint amount = ftn.balanceOf(addr);
894 		require(!upgraded[addr] && amount>0 && !skiplist[addr]);
895 
896 		upgraded[addr] = true;
897 		wallets[addr] = amount;
898 
899 		(uint a, uint b, uint c, uint d) = ftn.lockbins(addr,0);
900 		uint len = d;
901 		if (len > 0){
902 			lockbins[addr][0].amount = len; 
903 			for (uint i=1; i <= len; i++){
904 				(a, b, c, d) = ftn.lockbins(addr,i);
905 				lockbins[addr][i] = LockBin({
906 					start: a,
907 					finish: b,
908 					duration: c,
909 					amount: d
910 				});
911 			}
912 		}
913 
914 		token_created = token_created.add(amount);
915 		emit Mint(addr, amount);
916 		emit Transfer(address(0), addr, amount);
917 	}
918 	
919 	
920 	function batchUpgrade(address[] addrs) whenUpgrading whenPaused canUpgrade onlyOwner{
921 		uint l = addrs.length;
922 		require(l > 0);
923 		uint a;
924 		uint b; 
925 		uint c; 
926 		uint d;
927 		for (uint i = 0; i < l; i++){
928 
929 			address addr = addrs[i];
930 			uint amount = ftn.balanceOf(addr);
931 			if (upgraded[addr] || amount == 0 || skiplist[addr]){
932 				continue;
933 			}
934 
935 			upgraded[addr] = true;
936 			wallets[addr] = amount;
937 	
938 			(a, b, c, d) = ftn.lockbins(addr,0);
939 			uint len = d;
940 			if (len > 0){
941 				lockbins[addr][0].amount = len; 
942 				for (uint j=1; j <= len; j++){
943 					(a, b, c, d) = ftn.lockbins(addr, j);
944 					lockbins[addr][j] = LockBin({
945 						start: a,
946 						finish: b,
947 						duration: c,
948 						amount: d
949 					});
950 				}
951 			}
952 
953 			token_created = token_created.add(amount);
954 			emit Mint(addr, amount);
955 			emit Transfer(address(0), addr, amount);
956 
957 		} 
958 		
959 	}
960 
961 }