1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6 	function mul (uint256 a, uint256 b) internal pure returns (uint256) {
7 		if (a == 0) {
8 			return 0;
9 		}
10 		uint256 c = a * b;
11 		assert(c / a == b);
12 		return c;
13 	}
14 
15 
16 	function div (uint256 a, uint256 b) internal pure returns (uint256) {
17 
18 		return a / b;
19 	}
20 
21 
22 	function sub (uint256 a, uint256 b) internal pure returns (uint256) {
23 		assert(b <= a);
24 		return a - b;
25 	}
26 
27 
28 	function add (uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 }
34 
35 
36 contract ERCBasic {
37 	event Transfer(address indexed from, address indexed to, uint256 value);
38 
39 	function totalSupply () public view returns (uint256);
40 	function balanceOf (address who) public view returns (uint256);
41 	function transfer (address to, uint256 value) public returns (bool);
42 }
43 
44 
45 contract ERC is ERCBasic {
46 	event Approval(address indexed owner, address indexed spender, uint256 value);
47 
48 	function transferFrom (address from, address to, uint256 value) public returns (bool);
49 	function allowance (address owner, address spender) public view returns (uint256);
50 	function approve (address spender, uint256 value) public returns (bool);
51 }
52 
53 
54 contract Ownable {
55 	event OwnershipTransferred(address indexed oldone, address indexed newone);
56 
57 	address public owner;
58 
59 	constructor () public {
60 		owner = msg.sender;
61 	}
62 
63 
64 	modifier onlyOwner () {
65 		require(msg.sender == owner);
66 		_;
67 	}
68 
69 
70 	function transferOwnership (address newOwner) public onlyOwner {
71 		require(newOwner != address(0));
72 		require(newOwner != owner);
73 		address oldOwner = owner;
74 		owner = newOwner;
75 		emit OwnershipTransferred(oldOwner, newOwner);
76 	}
77 }
78 
79 
80 contract Pausable is Ownable {
81 	event ContractPause();
82 	event ContractResume();
83 
84 	bool public paused = false;
85 
86 	modifier whenRunning () {
87 		require(!paused);
88 		_;
89 	}
90 
91 	modifier whenPaused () {
92 		require(paused);
93 		_;
94 	}
95 
96 
97 	function pause () public onlyOwner whenRunning {
98 		paused = true;
99 		emit ContractPause();
100 	}
101 
102 
103 	function resume () public onlyOwner whenPaused {
104 		paused = false;
105 		emit ContractResume();
106 	}
107 }
108 
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
126 
127 	function startForge () public onlyOwner cannotForge returns (bool) {
128 		forge_running = true;
129 		emit ForgeStart();
130 		return true;
131 	}
132 
133 
134 	function stopForge () public onlyOwner canForge returns (bool) {
135 		forge_running = false;
136 		emit ForgeStop();
137 		return true;
138 	}
139 }
140 
141 
142 contract CappedToken is Ownable {
143 	using SafeMath for uint256;
144 
145 	uint256 public token_cap;
146 	uint256 public token_created;
147 
148 	constructor (uint256 _cap) public {
149 		token_cap = _cap;
150 	}
151 
152 	function changeCap (uint256 _cap) public onlyOwner returns (bool) {
153 		if (_cap < token_created && _cap > 0) return false;
154 		token_cap = _cap;
155 		return true;
156 	}
157 
158 	function canMint (uint256 amount) public view returns (bool) {
159 		return (token_cap == 0) || (token_created.add(amount) <= token_cap);
160 	}
161 }
162 
163 
164 contract BasicToken is ERCBasic, Pausable {
165 	using SafeMath for uint256;
166 
167 	mapping(address => uint256) public wallets;
168 
169 	modifier canTransfer (address _from, address _to, uint256 amount) {
170 		require((_from != address(0)) && (_to != address(0)));
171 		require(_from != _to);
172 		require(amount > 0);
173 		_;
174 	}
175 
176 
177 	function balanceOf (address user) public view returns (uint256) {
178 		return wallets[user];
179 	}
180 }
181 
182 
183 contract DelegatableToken is ERC, BasicToken {
184 	using SafeMath for uint256;
185 
186 	mapping(address => mapping(address => uint256)) public warrants;
187 
188 
189 	function allowance (address owner, address delegator) public view returns (uint256) {
190 		return warrants[owner][delegator];
191 	}
192 
193 
194 	function approve (address delegator, uint256 value) public whenRunning returns (bool) {
195 		if (delegator == msg.sender) return true;
196 		warrants[msg.sender][delegator] = value;
197 		emit Approval(msg.sender, delegator, value);
198 		return true;
199 	}
200 
201 
202 	function increaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
203 		if (delegator == msg.sender) return true;
204 		uint256 value = warrants[msg.sender][delegator].add(delta);
205 		warrants[msg.sender][delegator] = value;
206 		emit Approval(msg.sender, delegator, value);
207 		return true;
208 	}
209 
210 
211 	function decreaseApproval (address delegator, uint256 delta) public whenRunning returns (bool) {
212 		if (delegator == msg.sender) return true;
213 		uint256 value = warrants[msg.sender][delegator];
214 		if (value < delta) {
215 			value = 0;
216 		}
217 		else {
218 			value = value.sub(delta);
219 		}
220 		warrants[msg.sender][delegator] = value;
221 		emit Approval(msg.sender, delegator, value);
222 		return true;
223 	}
224 }
225 
226 
227 contract LockableProtocol is BasicToken {
228 	function invest (address investor, uint256 amount) public returns (bool);
229 	function getInvestedToken (address investor) public view returns (uint256);
230 	function getReleasedToken (address investor) public view returns (uint256);
231 	function getLockedToken (address investor) public view returns (uint256);
232 
233 
234 	function availableWallet (address user) public view returns (uint256) {
235 		return wallets[user].sub(getLockedToken(user));
236 	}
237 }
238 
239 
240 contract MintAndBurnToken is BasicToken, TokenForge, CappedToken, LockableProtocol {
241 	using SafeMath for uint256;
242 
243 	event Mint(address indexed user, uint256 amount);
244 	event Burn(address indexed user, uint256 amount);
245 
246 	constructor (uint256 _initial, uint256 _cap) public CappedToken(_cap) {
247 		token_created = _initial;
248 		wallets[msg.sender] = _initial;
249 
250 		emit Mint(msg.sender, _initial);
251 		emit Transfer(address(0), msg.sender, _initial);
252 	}
253 
254 
255 	function totalSupply () public view returns (uint256) {
256 		return token_created;
257 	}
258 
259 
260 	function mint (address target, uint256 amount) public onlyOwner whenRunning canForge returns (bool) {
261 		if (!canMint(amount)) return false;
262 
263 		token_created = token_created.add(amount);
264 		wallets[target] = wallets[target].add(amount);
265 
266 		emit Mint(target, amount);
267 		emit Transfer(address(0), target, amount);
268 		return true;
269 	}
270 
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
284 
285 
286 	function burnByOwner (address target, uint256 amount) public onlyOwner whenRunning canForge returns (bool) {
287 		uint256 balance = availableWallet(target);
288 		require(amount <= balance);
289 
290 		token_created = token_created.sub(amount);
291 		wallets[target] -= amount;
292 
293 		emit Burn(target, amount);
294 		emit Transfer(target, address(0), amount);
295 
296 		return true;
297 	}
298 }
299 
300 
301 contract LockableToken is MintAndBurnToken, DelegatableToken {
302 	using SafeMath for uint256;
303 
304 	struct LockBin {
305 		uint256 start;
306 		uint256 finish;
307 		uint256 duration;
308 		uint256 amount;
309 	}
310 
311 	event InvestStart();
312 	event InvestStop();
313 	event NewInvest(uint256 invest_start, uint256 invest_finish, uint256 release_start, uint256 release_duration);
314 
315 	uint256 public investStart;
316 	uint256 public investFinish;
317 	uint256 public releaseStart;
318 	uint256 public releaseDuration;
319 	bool public forceStopInvest;
320 	mapping(address => mapping(uint => LockBin)) public lockbins;
321 
322 	modifier canInvest () {
323 		require(!forceStopInvest);
324 		require(now >= investStart && now <= investFinish);
325 		_;
326 	}
327 
328 	constructor (uint256 _initial, uint256 _cap) public MintAndBurnToken(_initial, _cap) {
329 		forceStopInvest = true;
330 		investStart = now;
331 		investFinish = now;
332 	}
333 
334 
335 	function pauseInvest () public onlyOwner whenRunning returns (bool) {
336 		if (now < investStart || now > investFinish) return false;
337 		if (forceStopInvest) return false;
338 		forceStopInvest = true;
339 		emit InvestStop();
340 		return true;
341 	}
342 
343 
344 	function resumeInvest () public onlyOwner whenRunning returns (bool) {
345 		if (now < investStart || now > investFinish) return false;
346 		if (!forceStopInvest) return false;
347 		forceStopInvest = false;
348 		emit InvestStart();
349 		return true;
350 	}
351 
352 
353 	function setInvest (uint256 invest_start, uint256 invest_finish, uint256 release_start, uint256 release_duration) public onlyOwner whenRunning returns (bool) {
354 		require(now > investFinish);
355 		require(invest_start > now);
356 
357 		investStart = invest_start;
358 		investFinish = invest_finish;
359 		releaseStart = release_start;
360 		releaseDuration = release_duration;
361 		forceStopInvest = false;
362 
363 		emit NewInvest(invest_start, invest_finish, release_start, release_duration);
364 		return true;
365 	}
366 
367 
368 	function invest (address investor, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
369 		require(investor != address(0));
370 		require(amount > 0);
371 		require(canMint(amount));
372 
373 		token_created = token_created.add(amount);
374 		wallets[investor] = wallets[investor].add(amount);
375 		emit Mint(investor, amount);
376 		emit Transfer(address(0), investor, amount);
377 
378 		mapping(uint => LockBin) locks = lockbins[investor];
379 		LockBin storage info = locks[0];
380 		uint index = info.amount + 1;
381 		locks[index] = LockBin({
382 			start: releaseStart,
383 			finish: releaseStart + releaseDuration,
384 			duration: releaseDuration / (1 days),
385 			amount: amount
386 		});
387 		info.amount = index;
388 
389 		return true;
390 	}
391 
392 
393 	function batchInvest (address[] investors, uint256 amount) public onlyOwner whenRunning canInvest returns (bool) {
394 		require(amount > 0);
395 
396 		uint investorsLength = investors.length;
397 		uint investorsCount = 0;
398 		uint i;
399 		address r;
400 		for (i = 0; i < investorsLength; i ++) {
401 			r = investors[i];
402 			if (r != address(0)) investorsCount ++;
403 		}
404 		require(investorsCount > 0);
405 
406 		uint256 totalAmount = amount.mul(uint256(investorsCount));
407 		require(canMint(totalAmount));
408 
409 		token_created = token_created.add(totalAmount);
410 
411 		for (i = 0; i < investorsLength; i ++) {
412 			r = investors[i];
413 			if (r == address(0)) continue;
414 			wallets[r] = wallets[r].add(amount);
415 			emit Mint(r, amount);
416 			emit Transfer(address(0), r, amount);
417 
418 			mapping(uint => LockBin) locks = lockbins[r];
419 			LockBin storage info = locks[0];
420 			uint index = info.amount + 1;
421 			locks[index] = LockBin({
422 				start: releaseStart,
423 				finish: releaseStart + releaseDuration,
424 				duration: releaseDuration / (1 days),
425 				amount: amount
426 			});
427 			info.amount = index;
428 		}
429 
430 		return true;
431 	}
432 
433 
434 	function batchInvests (address[] investors, uint256[] amounts) public onlyOwner whenRunning canInvest returns (bool) {
435 		uint investorsLength = investors.length;
436 		require(investorsLength == amounts.length);
437 
438 		uint investorsCount = 0;
439 		uint256 totalAmount = 0;
440 		uint i;
441 		address r;
442 		for (i = 0; i < investorsLength; i ++) {
443 			r = investors[i];
444 			if (r == address(0)) continue;
445 			investorsCount ++;
446 			totalAmount += amounts[i];
447 		}
448 		require(totalAmount > 0);
449 		require(canMint(totalAmount));
450 
451 		uint256 amount;
452 		token_created = token_created.add(totalAmount);
453 		for (i = 0; i < investorsLength; i ++) {
454 			r = investors[i];
455 			if (r == address(0)) continue;
456 			amount = amounts[i];
457 			wallets[r] = wallets[r].add(amount);
458 			emit Mint(r, amount);
459 			emit Transfer(address(0), r, amount);
460 
461 			mapping(uint => LockBin) locks = lockbins[r];
462 			LockBin storage info = locks[0];
463 			uint index = info.amount + 1;
464 			locks[index] = LockBin({
465 				start: releaseStart,
466 				finish: releaseStart + releaseDuration,
467 				duration: releaseDuration / (1 days),
468 				amount: amount
469 			});
470 			info.amount = index;
471 		}
472 
473 		return true;
474 	}
475 
476 
477 	function getInvestedToken (address investor) public view returns (uint256) {
478 		mapping(uint => LockBin) locks = lockbins[investor];
479 		uint256 balance = 0;
480 		uint l = locks[0].amount;
481 
482 		for (uint i = 1; i <= l; i ++) {
483 			LockBin memory bin = locks[i];
484 			balance = balance.add(bin.amount);
485 		}
486 		return balance;
487 	}
488 
489 
490 	function getLockedToken (address investor) public view returns (uint256) {
491 		mapping(uint => LockBin) locks = lockbins[investor];
492 		uint256 balance = 0;
493 		uint256 d = 1;
494 		uint l = locks[0].amount;
495 
496 		for (uint i = 1; i <= l; i ++) {
497 			LockBin memory bin = locks[i];
498 			if (now <= bin.start) {
499 				balance = balance.add(bin.amount);
500 			}
501 			else if (now < bin.finish) {
502 				d = (now - bin.start) / (1 days);
503 				balance = balance.add(bin.amount - bin.amount * d / bin.duration);
504 			}
505 		}
506 		return balance;
507 	}
508 
509 
510 	function getReleasedToken (address investor) public view returns (uint256) {
511 		mapping(uint => LockBin) locks = lockbins[investor];
512 		uint256 balance = 0;
513 		uint256 d = 1;
514 		uint l = locks[0].amount;
515 
516 		for (uint i = 1; i <= l; i ++) {
517 			LockBin memory bin = locks[i];
518 			if (now >= bin.finish) {
519 				balance = balance.add(bin.amount);
520 			}
521 			else if (now > bin.start) {
522 				d = (now - bin.start) / (1 days);
523 				balance = balance.add(bin.amount * d / bin.duration);
524 			}
525 		}
526 		return balance;
527 	}
528 
529 
530 	function canPay (address user, uint256 amount) internal view returns (bool) {
531 		uint256 balance = availableWallet(user);
532 		return amount <= balance;
533 	}
534 
535 
536 	function transfer (address target, uint256 value) public whenRunning canTransfer(msg.sender, target, value) returns (bool) {
537 		require(canPay(msg.sender, value));
538 
539 		wallets[msg.sender] = wallets[msg.sender].sub(value);
540 		wallets[target] = wallets[target].add(value);
541 		emit Transfer(msg.sender, target, value);
542 		return true;
543 	}
544 
545 
546 	function batchTransfer (address[] receivers, uint256 amount) public whenRunning returns (bool) {
547 		require(amount > 0);
548 
549 		uint receiveLength = receivers.length;
550 		uint receiverCount = 0;
551 		uint i;
552 		address r;
553 		for (i = 0; i < receiveLength; i ++) {
554 			r = receivers[i];
555 			if (r != address(0) && r != msg.sender) receiverCount ++;
556 		}
557 		require(receiverCount > 0);
558 
559 		uint256 totalAmount = amount.mul(uint256(receiverCount));
560 		require(canPay(msg.sender, totalAmount));
561 
562 		for (i = 0; i < receiveLength; i++) {
563 			r = receivers[i];
564 			if (r == address(0) || r == msg.sender) continue;
565 			wallets[r] = wallets[r].add(amount);
566 			emit Transfer(msg.sender, r, amount);
567 		}
568 		wallets[msg.sender] -= totalAmount;
569 		return true;
570 	}
571 
572 
573 	function batchTransfers (address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
574 		uint receiveLength = receivers.length;
575 		require(receiveLength == amounts.length);
576 
577 		uint receiverCount = 0;
578 		uint256 totalAmount = 0;
579 		uint i;
580 		address r;
581 		for (i = 0; i < receiveLength; i ++) {
582 			r = receivers[i];
583 			if (r == address(0) || r == msg.sender) continue;
584 			receiverCount ++;
585 			totalAmount += amounts[i];
586 		}
587 		require(totalAmount > 0);
588 		require(canPay(msg.sender, totalAmount));
589 
590 		uint256 amount;
591 		for (i = 0; i < receiveLength; i++) {
592 			r = receivers[i];
593 			if (r == address(0) || r == msg.sender) continue;
594 			amount = amounts[i];
595 			wallets[r] = wallets[r].add(amount);
596 			emit Transfer(msg.sender, r, amount);
597 		}
598 		wallets[msg.sender] -= totalAmount;
599 		return true;
600 	}
601 
602 
603 	function transferFrom (address from, address to, uint256 value) public whenRunning canTransfer(from, to, value) returns (bool) {
604 		uint256 warrant;
605 		if (msg.sender != from) {
606 			warrant = warrants[from][msg.sender];
607 			require(value <= warrant);
608 		}
609 
610 		require(canPay(from, value));
611 
612 		if (msg.sender != from) warrants[from][msg.sender] = warrant.sub(value);
613 		wallets[from] = wallets[from].sub(value);
614 		wallets[to] = wallets[to].add(value);
615 		emit Transfer(from, to, value);
616 		return true;
617 	}
618 
619 
620 	function batchTransferFrom (address from, address[] receivers, uint256 amount) public whenRunning returns (bool) {
621 		require(amount > 0);
622 
623 		uint receiveLength = receivers.length;
624 		uint receiverCount = 0;
625 		uint i;
626 		address r;
627 		for (i = 0; i < receiveLength; i ++) {
628 			r = receivers[i];
629 			if (r != address(0) && r != from) receiverCount ++;
630 		}
631 		require(receiverCount > 0);
632 
633 		uint256 totalAmount = amount.mul(uint256(receiverCount));
634 		require(canPay(from, totalAmount));
635 
636 		uint256 warrant;
637 		if (msg.sender != from) {
638 			warrant = warrants[from][msg.sender];
639 			require(totalAmount <= warrant);
640 		}
641 
642 		for (i = 0; i < receiveLength; i++) {
643 			r = receivers[i];
644 			if (r == address(0) || r == from) continue;
645 			wallets[r] = wallets[r].add(amount);
646 			emit Transfer(from, r, amount);
647 		}
648 		wallets[from] -= totalAmount;
649 		if (msg.sender != from) warrants[from][msg.sender] = warrant.sub(totalAmount);
650 		return true;
651 	}
652 
653 
654 	function batchTransferFroms (address from, address[] receivers, uint256[] amounts) public whenRunning returns (bool) {
655 		uint receiveLength = receivers.length;
656 		require(receiveLength == amounts.length);
657 
658 		uint receiverCount = 0;
659 		uint256 totalAmount = 0;
660 		uint i;
661 		address r;
662 		for (i = 0; i < receiveLength; i ++) {
663 			r = receivers[i];
664 			if (r == address(0) || r == from) continue;
665 			receiverCount ++;
666 			totalAmount += amounts[i];
667 		}
668 		require(totalAmount > 0);
669 		require(canPay(from, totalAmount));
670 
671 		uint256 warrant;
672 		if (msg.sender != from) {
673 			warrant = warrants[from][msg.sender];
674 			require(totalAmount <= warrant);
675 		}
676 
677 		uint256 amount;
678 		for (i = 0; i < receiveLength; i++) {
679 			r = receivers[i];
680 			if (r == address(0) || r == from) continue;
681 			amount = amounts[i];
682 			wallets[r] = wallets[r].add(amount);
683 			emit Transfer(from, r, amount);
684 		}
685 		wallets[from] -= totalAmount;
686 		if (msg.sender != from) warrants[from][msg.sender] = warrant.sub(totalAmount);
687 		return true;
688 	}
689 }
690 
691 
692 contract FountainToken is LockableToken {
693 	string  public constant name     = "Fountain";
694 	string  public constant symbol   = "FTN";
695 	uint8   public constant decimals = 18;
696 
697 	uint256 private constant TOKEN_CAP     = 10000000000 * 10 ** uint256(decimals);
698 	uint256 private constant TOKEN_INITIAL = 300000000  * 10 ** uint256(decimals);
699 
700 	constructor () public LockableToken(TOKEN_INITIAL, TOKEN_CAP) {
701 		
702 	}
703 }