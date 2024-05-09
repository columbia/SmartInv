1 pragma solidity ^0.4.25;
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
139 contract CappedToken is Ownable {
140 	using SafeMath for uint256;
141 
142 	uint256 public token_cap;
143 	uint256 public token_created;
144 	uint256 public token_foundation_cap;
145 	uint256 public token_foundation_created;
146 
147 
148 	constructor (uint256 _cap, uint256 _foundationCap) public {
149 		token_cap = _cap;
150 		token_foundation_cap = _foundationCap;
151 	}
152 
153 	function changeCap (uint256 _cap) public onlyOwner returns (bool) {
154 		if (_cap < token_created && _cap > 0) return false;
155 		token_cap = _cap;
156 		return true;
157 	}
158 
159 	function canMint (uint256 amount) public view returns (bool) {
160 		return (token_cap == 0) || (token_created.add(amount) <= token_cap);
161 	}
162 	
163 	function canMintFoundation(uint256 amount) internal view returns(bool) {
164 		return(token_foundation_created.add(amount) <= token_foundation_cap);
165 	}
166 }
167 
168 contract BasicToken is ERCBasic, Pausable {
169 	using SafeMath for uint256;
170 
171 	mapping(address => uint256) public wallets;
172 
173 	modifier canTransfer (address _from, address _to, uint256 amount) {
174 		require((_from != address(0)) && (_to != address(0)));
175 		require(_from != _to);
176 		require(amount > 0);
177 		_;
178 	}
179 
180 	function balanceOf (address user) public view returns (uint256) {
181 		return wallets[user];
182 	}
183 }
184 
185 contract DelegatableToken is ERC, BasicToken {
186 	using SafeMath for uint256;
187 
188 	mapping(address => mapping(address => uint256)) public warrants;
189 
190 	function allowance (address owner, address delegator) public view returns (uint256) {
191 		return warrants[owner][delegator];
192 	}
193 
194 	function approve (address delegator, uint256 value) public whenRunning returns (bool) {
195 		if (delegator == msg.sender) return true;
196 		warrants[msg.sender][delegator] = value;
197 		emit Approval(msg.sender, delegator, value);
198 		return true;
199 	}
200 
201 	function increaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
202 		if (delegator == msg.sender) return true;
203 		uint256 value = warrants[msg.sender][delegator].add(delta);
204 		warrants[msg.sender][delegator] = value;
205 		emit Approval(msg.sender, delegator, value);
206 		return true;
207 	}
208 
209 	function decreaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
210 		if (delegator == msg.sender) return true;
211 		uint256 value = warrants[msg.sender][delegator];
212 		if (value < delta) {
213 			value = 0;
214 		}
215 		else {
216 			value = value.sub(delta);
217 		}
218 		warrants[msg.sender][delegator] = value;
219 		emit Approval(msg.sender, delegator, value);
220 		return true;
221 	}
222 }
223 
224 contract LockableProtocol is BasicToken {
225 	function invest (address investor, uint256 amount) public returns (bool);
226 	function getInvestedToken (address investor) public view returns (uint256);
227 	function getLockedToken (address investor) public view returns (uint256);
228 	function availableWallet (address user) public view returns (uint256) {
229 		return wallets[user].sub(getLockedToken(user));
230 	}
231 }
232 
233 contract MintAndBurnToken is TokenForge, CappedToken, LockableProtocol {
234 	using SafeMath for uint256;
235 	
236 	event Mint(address indexed user, uint256 amount);
237 	event Burn(address indexed user, uint256 amount);
238 
239 	constructor (uint256 _initial, uint256 _cap, uint256 _fountainCap) public CappedToken(_cap, _fountainCap) {
240 		token_created = _initial;
241 		wallets[msg.sender] = _initial;
242 
243 		emit Mint(msg.sender, _initial);
244 		emit Transfer(address(0), msg.sender, _initial);
245 	}
246 
247 	function totalSupply () public view returns (uint256) {
248 		return token_created;
249 	}
250 
251 	function totalFountainSupply() public view returns(uint256) {
252 		return token_foundation_created;
253 	}
254 
255 	function mint (address target, uint256 amount) public hasMintability whenRunning canForge returns (bool) {
256 		require(target != owner && target != foundationOwner); // Owner和FoundationOwner不能成为mint的对象
257 		require(canMint(amount));
258 
259 		if (msg.sender == foundationOwner) {
260 			require(canMintFoundation(amount));
261 			token_foundation_created = token_foundation_created.add(amount);
262 		}
263 		
264 		token_created = token_created.add(amount);
265 		wallets[target] = wallets[target].add(amount);
266 
267 		emit Mint(target, amount);
268 		emit Transfer(address(0), target, amount);
269 		return true;
270 	}
271 
272 	function burn (uint256 amount) public whenRunning canForge returns (bool) {
273 		uint256 balance = availableWallet(msg.sender);
274 		require(amount <= balance);
275 
276 		token_created = token_created.sub(amount);
277 		wallets[msg.sender] -= amount;
278 
279 		emit Burn(msg.sender, amount);
280 		emit Transfer(msg.sender, address(0), amount);
281 
282 		return true;
283 	}
284 }
285 
286 contract LockableToken is MintAndBurnToken, DelegatableToken {
287 	using SafeMath for uint256;
288 
289 	struct LockBin {
290 		uint256 start;
291 		uint256 finish;
292 		uint256 duration;
293 		uint256 amount;
294 	}
295 
296 	event InvestStart();
297 	event InvestStop();
298 	event NewInvest(uint256 release_start, uint256 release_duration);
299 
300 	uint256 public releaseStart;
301 	uint256 public releaseDuration;
302 	bool public forceStopInvest;
303 	mapping(address => mapping(uint => LockBin)) public lockbins;
304 
305 	modifier canInvest () {
306 		require(!forceStopInvest);
307 		_;
308 	}
309 
310 	constructor (uint256 _initial, uint256 _cap, uint256 _fountainCap) public MintAndBurnToken(_initial, _cap, _fountainCap) {
311 		forceStopInvest = true;
312 	}
313 
314 	function pauseInvest () public onlyOwner whenRunning returns (bool) {
315 		require(!forceStopInvest);
316 		forceStopInvest = true;
317 		emit InvestStop();
318 		return true;
319 	}
320 
321 	function resumeInvest () public onlyOwner whenRunning returns (bool) {
322 		require(forceStopInvest);
323 		forceStopInvest = false;
324 		emit InvestStart();
325 		return true;
326 	}
327 
328 	function setInvest (uint256 release_start, uint256 release_duration) public onlyOwner whenRunning returns (bool) {
329 		releaseStart = release_start;
330 		releaseDuration = release_duration;
331 		forceStopInvest = false;
332 
333 		emit NewInvest(release_start, release_duration);
334 		return true;
335 	}
336 
337 	function invest (address investor, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
338 		require(investor != address(0));
339 		require(investor != owner);
340 		require(investor != foundationOwner);
341 		require(amount > 0);
342 		require(canMint(amount));
343 
344 		mapping(uint => LockBin) locks = lockbins[investor];
345 		LockBin storage info = locks[0];
346 		uint index = info.amount + 1;
347 		locks[index] = LockBin({
348 			start: releaseStart,
349 			finish: releaseStart + releaseDuration,
350 			duration: releaseDuration / (1 days),
351 			amount: amount
352 		});
353 		info.amount = index;
354 
355 		token_created = token_created.add(amount);
356 		wallets[investor] = wallets[investor].add(amount);
357 		emit Mint(investor, amount);
358 		emit Transfer(address(0), investor, amount);
359 
360 		return true;
361 	}
362 
363 	function batchInvest (address[] investors, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
364 		require(amount > 0);
365 
366 		uint investorsLength = investors.length;
367 		uint investorsCount = 0;
368 		uint i;
369 		address r;
370 		for (i = 0; i < investorsLength; i ++) {
371 			r = investors[i];
372 			if (r == address(0) || r == owner || r == foundationOwner) continue;
373 			investorsCount ++;
374 		}
375 		require(investorsCount > 0);
376 
377 		uint256 totalAmount = amount.mul(uint256(investorsCount));
378 		require(canMint(totalAmount));
379 
380 		token_created = token_created.add(totalAmount);
381 
382 		for (i = 0; i < investorsLength; i ++) {
383 			r = investors[i];
384 			if (r == address(0) || r == owner || r == foundationOwner) continue;
385 
386 			mapping(uint => LockBin) locks = lockbins[r];
387 			LockBin storage info = locks[0];
388 			uint index = info.amount + 1;
389 			locks[index] = LockBin({
390 				start: releaseStart,
391 				finish: releaseStart + releaseDuration,
392 				duration: releaseDuration / (1 days),
393 				amount: amount
394 			});
395 			info.amount = index;
396 
397 			wallets[r] = wallets[r].add(amount);
398 			emit Mint(r, amount);
399 			emit Transfer(address(0), r, amount);
400 		}
401 
402 		return true;
403 	}
404 
405 	function batchInvests (address[] investors, uint256[] amounts) public onlyOwner whenRunning canInvest returns (bool) {
406 		uint investorsLength = investors.length;
407 		require(investorsLength == amounts.length);
408 
409 		uint investorsCount = 0;
410 		uint256 totalAmount = 0;
411 		uint i;
412 		address r;
413 		for (i = 0; i < investorsLength; i ++) {
414 			r = investors[i];
415 			if (r == address(0) || r == owner) continue;
416 			investorsCount ++;
417 			totalAmount += amounts[i];
418 		}
419 		require(totalAmount > 0);
420 		require(canMint(totalAmount));
421 
422 		uint256 amount;
423 		token_created = token_created.add(totalAmount);
424 		for (i = 0; i < investorsLength; i ++) {
425 			r = investors[i];
426 			if (r == address(0) || r == owner) continue;
427 			amount = amounts[i];
428 			wallets[r] = wallets[r].add(amount);
429 			emit Mint(r, amount);
430 			emit Transfer(address(0), r, amount);
431 
432 			mapping(uint => LockBin) locks = lockbins[r];
433 			LockBin storage info = locks[0];
434 			uint index = info.amount + 1;
435 			locks[index] = LockBin({
436 				start: releaseStart,
437 				finish: releaseStart + releaseDuration,
438 				duration: releaseDuration / (1 days),
439 				amount: amount
440 			});
441 			info.amount = index;
442 		}
443 
444 		return true;
445 	}
446 
447 	function getInvestedToken (address investor) public view returns (uint256) {
448 		require(investor != address(0) && investor != owner && investor != foundationOwner);
449 
450 		mapping(uint => LockBin) locks = lockbins[investor];
451 		uint256 balance = 0;
452 		uint l = locks[0].amount;
453 		for (uint i = 1; i <= l; i ++) {
454 			LockBin memory bin = locks[i];
455 			balance = balance.add(bin.amount);
456 		}
457 		return balance;
458 	}
459 
460 	function getLockedToken (address investor) public view returns (uint256) {
461 		require(investor != address(0) && investor != owner && investor != foundationOwner);
462 
463 		mapping(uint => LockBin) locks = lockbins[investor];
464 		uint256 balance = 0;
465 		uint256 d = 1;
466 		uint l = locks[0].amount;
467 		for (uint i = 1; i <= l; i ++) {
468 			LockBin memory bin = locks[i];
469 			if (now <= bin.start) {
470 				balance = balance.add(bin.amount);
471 			}
472 			else if (now < bin.finish) {
473 				d = (now - bin.start) / (1 days);
474 				balance = balance.add(bin.amount - bin.amount * d / bin.duration);
475 			}
476 		}
477 		return balance;
478 	}
479 
480 	function canPay (address user, uint256 amount) internal view returns (bool) {
481 		uint256 balance = availableWallet(user);
482 		return amount <= balance;
483 	}
484 
485 	function transfer (address target, uint256 value) public whenRunning canTransfer(msg.sender, target, value) returns (bool) {
486 		require(target != owner);
487 		require(canPay(msg.sender, value));
488 
489 		wallets[msg.sender] = wallets[msg.sender].sub(value);
490 		wallets[target] = wallets[target].add(value);
491 		emit Transfer(msg.sender, target, value);
492 		return true;
493 	}
494 
495 
496 	function batchTransfer (address[] receivers, uint256 amount) public whenRunning returns (bool) {
497 		require(amount > 0);
498 
499 		uint receiveLength = receivers.length;
500 		uint receiverCount = 0;
501 		uint i;
502 		address r;
503 		for (i = 0; i < receiveLength; i ++) {
504 			r = receivers[i];
505 			if (r == address(0) || r == owner) continue;
506 			receiverCount ++;
507 		}
508 		require(receiverCount > 0);
509 
510 		uint256 totalAmount = amount.mul(uint256(receiverCount));
511 		require(canPay(msg.sender, totalAmount));
512 
513 		wallets[msg.sender] -= totalAmount;
514 		for (i = 0; i < receiveLength; i++) {
515 			r = receivers[i];
516 			if (r == address(0) || r == owner) continue;
517 			wallets[r] = wallets[r].add(amount);
518 			emit Transfer(msg.sender, r, amount);
519 		}
520 		return true;
521 	}
522 
523 	function batchTransfers (address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
524 		uint receiveLength = receivers.length;
525 		require(receiveLength == amounts.length);
526 
527 		uint receiverCount = 0;
528 		uint256 totalAmount = 0;
529 		uint i;
530 		address r;
531 		for (i = 0; i < receiveLength; i ++) {
532 			r = receivers[i];
533 			if (r == address(0) || r == owner) continue;
534 			receiverCount ++;
535 			totalAmount += amounts[i];
536 		}
537 		require(totalAmount > 0);
538 		require(canPay(msg.sender, totalAmount));
539 
540 		wallets[msg.sender] -= totalAmount;
541 		uint256 amount;
542 		for (i = 0; i < receiveLength; i++) {
543 			r = receivers[i];
544 			if (r == address(0) || r == owner) continue;
545 			amount = amounts[i];
546 			if (amount == 0) continue;
547 			wallets[r] = wallets[r].add(amount);
548 			emit Transfer(msg.sender, r, amount);
549 		}
550 		return true;
551 	}
552 
553 	function transferFrom (address from, address to, uint256 value) public whenRunning canTransfer(from, to, value) returns (bool) {
554 		require(from != owner);
555 		require(to != owner);
556 		require(canPay(from, value));
557 
558 		uint256 warrant;
559 		if (msg.sender != from) {
560 			warrant = warrants[from][msg.sender];
561 			require(value <= warrant);
562 			warrants[from][msg.sender] = warrant.sub(value);
563 		}
564 
565 		wallets[from] = wallets[from].sub(value);
566 		wallets[to] = wallets[to].add(value);
567 		emit Transfer(from, to, value);
568 		return true;
569 	}
570 
571 	function batchTransferFrom (address from, address[] receivers, uint256 amount) public whenRunning returns (bool) {
572 		require(from != address(0) && from != owner);
573 		require(amount > 0);
574 
575 		uint receiveLength = receivers.length;
576 		uint receiverCount = 0;
577 		uint i;
578 		address r;
579 		for (i = 0; i < receiveLength; i ++) {
580 			r = receivers[i];
581 			if (r == address(0) || r == owner) continue;
582 			receiverCount ++;
583 		}
584 		require(receiverCount > 0);
585 
586 		uint256 totalAmount = amount.mul(uint256(receiverCount));
587 		require(canPay(from, totalAmount));
588 
589 		uint256 warrant;
590 		if (msg.sender != from) {
591 			warrant = warrants[from][msg.sender];
592 			require(totalAmount <= warrant);
593 			warrants[from][msg.sender] = warrant.sub(totalAmount);
594 		}
595 
596 		wallets[from] -= totalAmount;
597 		for (i = 0; i < receiveLength; i++) {
598 			r = receivers[i];
599 			if (r == address(0) || r == owner) continue;
600 			wallets[r] = wallets[r].add(amount);
601 			emit Transfer(from, r, amount);
602 		}
603 		return true;
604 	}
605 
606 	function batchTransferFroms (address from, address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
607 		require(from != address(0) && from != owner);
608 
609 		uint receiveLength = receivers.length;
610 		require(receiveLength == amounts.length);
611 
612 		uint receiverCount = 0;
613 		uint256 totalAmount = 0;
614 		uint i;
615 		address r;
616 		for (i = 0; i < receiveLength; i ++) {
617 			r = receivers[i];
618 			if (r == address(0) || r == owner) continue;
619 			receiverCount ++;
620 			totalAmount += amounts[i];
621 		}
622 		require(totalAmount > 0);
623 		require(canPay(from, totalAmount));
624 
625 		uint256 warrant;
626 		if (msg.sender != from) {
627 			warrant = warrants[from][msg.sender];
628 			require(totalAmount <= warrant);
629 			warrants[from][msg.sender] = warrant.sub(totalAmount);
630 		}
631 
632 		wallets[from] -= totalAmount;
633 		uint256 amount;
634 		for (i = 0; i < receiveLength; i++) {
635 			r = receivers[i];
636 			if (r == address(0) || r == owner) continue;
637 			amount = amounts[i];
638 			if (amount == 0) continue;
639 			wallets[r] = wallets[r].add(amount);
640 			emit Transfer(from, r, amount);
641 		}
642 		return true;
643 	}
644 }
645 
646 contract FountainToken is LockableToken {
647 	string  public constant name     = "Fountain";
648 	string  public constant symbol   = "FTN";
649 	uint8   public constant decimals = 18;
650 
651 	uint256 private constant TOKEN_CAP     = 10000000000 * 10 ** uint256(decimals);
652 	uint256 private constant TOKEN_FOUNDATION_CAP = 300000000   * 10 ** uint256(decimals);
653 	uint256 private constant TOKEN_INITIAL = 0   * 10 ** uint256(decimals);
654 
655 	constructor () public LockableToken(TOKEN_INITIAL, TOKEN_CAP, TOKEN_FOUNDATION_CAP) {
656 	}
657 
658 	function suicide () public onlyOwner {
659 		selfdestruct(owner);
660 	}
661 
662 	function transferOwnership (address newOwner) public onlyOwner returns (bool) {
663 		require(newOwner != address(0));
664 		require(newOwner != owner);
665 		require(newOwner != foundationOwner);
666 		require(wallets[owner] == 0);
667 		require(wallets[newOwner] == 0);
668 
669 		address oldOwner = owner;
670 		owner = newOwner;
671 		emit OwnershipTransferred(oldOwner, newOwner);
672 		
673 		return true;
674 	}
675 	
676 	function setFountainFoundationOwner (address newFoundationOwner) public onlyOwner returns (bool) {
677 		require(newFoundationOwner != address(0));
678 		require(newFoundationOwner != foundationOwner);
679 		require(newFoundationOwner != owner);
680 		require(wallets[newFoundationOwner] == 0);
681 
682 		address oldFoundation = foundationOwner;
683 		foundationOwner = newFoundationOwner;
684 
685 		emit FoundationOwnershipTransferred(oldFoundation, foundationOwner);
686 
687 		uint256 all = wallets[oldFoundation];
688 		wallets[oldFoundation] -= all;
689 		wallets[newFoundationOwner] = all;
690 		emit Transfer(oldFoundation, newFoundationOwner, all);
691 
692 		return true;
693 	}
694 	
695 }