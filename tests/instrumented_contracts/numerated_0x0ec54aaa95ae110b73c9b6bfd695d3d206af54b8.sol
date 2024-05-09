1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-14
3 */
4 
5 // File: contracts/library/SafeMath.sol
6 
7 pragma solidity 0.6.6;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot overflow.
60      *
61      * _Available since v2.4.0._
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage)
64         internal
65         pure
66         returns (uint256)
67     {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      *
123      * _Available since v2.4.0._
124      */
125     function div(uint256 a, uint256 b, string memory errorMessage)
126         internal
127         pure
128         returns (uint256)
129     {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      *
164      * _Available since v2.4.0._
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage)
167         internal
168         pure
169         returns (uint256)
170     {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 }
175 
176 // File: contracts/erc20/ERC20.sol
177 
178 pragma solidity 0.6.6;
179 
180 
181 abstract contract ERC20 {
182     using SafeMath for uint256;
183 
184     uint256 private _totalSupply;
185     mapping(address => uint256) internal _balances;
186     mapping(address => mapping(address => uint256)) internal _allowances;
187 
188     event Transfer(address indexed from, address indexed to, uint256 amount);
189     event Approval(
190         address indexed owner,
191         address indexed spender,
192         uint256 amount
193     );
194 
195     /*
196    * Internal Functions for ERC20 standard logics
197    */
198 
199     function _transfer(address from, address to, uint256 amount)
200         internal
201         returns (bool success)
202     {
203         _balances[from] = _balances[from].sub(
204             amount,
205             "ERC20/transfer : cannot transfer more than token owner balance"
206         );
207         _balances[to] = _balances[to].add(amount);
208         emit Transfer(from, to, amount);
209         success = true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount)
213         internal
214         returns (bool success)
215     {
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218         success = true;
219     }
220 
221     function _mint(address recipient, uint256 amount)
222         internal
223         returns (bool success)
224     {
225         _totalSupply = _totalSupply.add(amount);
226         _balances[recipient] = _balances[recipient].add(amount);
227         emit Transfer(address(0), recipient, amount);
228         success = true;
229     }
230 
231     function _burn(address burned, uint256 amount)
232         internal
233         returns (bool success)
234     {
235         _balances[burned] = _balances[burned].sub(
236             amount,
237             "ERC20Burnable/burn : Cannot burn more than user's balance"
238         );
239         _totalSupply = _totalSupply.sub(
240             amount,
241             "ERC20Burnable/burn : Cannot burn more than totalSupply"
242         );
243         emit Transfer(burned, address(0), amount);
244         success = true;
245     }
246 
247     /*
248    * public view functions to view common data
249    */
250 
251     function totalSupply() external view returns (uint256 total) {
252         total = _totalSupply;
253     }
254     function balanceOf(address owner) external view returns (uint256 balance) {
255         balance = _balances[owner];
256     }
257 
258     function allowance(address owner, address spender)
259         external
260         view
261         returns (uint256 remaining)
262     {
263         remaining = _allowances[owner][spender];
264     }
265 
266     /*
267    * External view Function Interface to implement on final contract
268    */
269     function name() virtual external view returns (string memory tokenName);
270     function symbol() virtual external view returns (string memory tokenSymbol);
271     function decimals() virtual external view returns (uint8 tokenDecimals);
272 
273     /*
274    * External Function Interface to implement on final contract
275    */
276     function transfer(address to, uint256 amount)
277         virtual
278         external
279         returns (bool success);
280     function transferFrom(address from, address to, uint256 amount)
281         virtual
282         external
283         returns (bool success);
284     function approve(address spender, uint256 amount)
285         virtual
286         external
287         returns (bool success);
288 }
289 
290 // File: contracts/library/Ownable.sol
291 
292 pragma solidity 0.6.6;
293 
294 contract Ownable {
295     address internal _owner;
296 
297     event OwnershipTransferred(
298         address indexed currentOwner,
299         address indexed newOwner
300     );
301 
302     constructor() internal {
303         _owner = msg.sender;
304         emit OwnershipTransferred(address(0), msg.sender);
305     }
306 
307     modifier onlyOwner() {
308         require(
309             msg.sender == _owner,
310             "Ownable : Function called by unauthorized user."
311         );
312         _;
313     }
314 
315     function owner() external view returns (address ownerAddress) {
316         ownerAddress = _owner;
317     }
318 
319     function transferOwnership(address newOwner)
320         public
321         onlyOwner
322         returns (bool success)
323     {
324         require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
325         success = _transferOwnership(newOwner);
326     }
327 
328     function renounceOwnership() external onlyOwner returns (bool success) {
329         success = _transferOwnership(address(0));
330     }
331 
332     function _transferOwnership(address newOwner) internal returns (bool success) {
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335         success = true;
336     }
337 }
338 
339 // File: contracts/erc20/ERC20Lockable.sol
340 
341 pragma solidity 0.6.6;
342 
343 
344 
345 abstract contract ERC20Lockable is ERC20, Ownable {
346     struct LockInfo {
347         uint256 amount;
348         uint256 due;
349     }
350 
351     mapping(address => LockInfo[]) internal _locks;
352     mapping(address => uint256) internal _totalLocked;
353 
354     event Lock(address indexed from, uint256 amount, uint256 due);
355     event Unlock(address indexed from, uint256 amount);
356 
357     modifier checkLock(address from, uint256 amount) {
358         require(_balances[from] >= _totalLocked[from].add(amount), "ERC20Lockable/Cannot send more than unlocked amount");
359         _;
360     }
361 
362     function _lock(address from, uint256 amount, uint256 due)
363         internal
364         returns (bool success)
365     {
366         require(due > now, "ERC20Lockable/lock : Cannot set due to past");
367         require(
368             _balances[from] >= amount.add(_totalLocked[from]),
369             "ERC20Lockable/lock : locked total should be smaller than balance"
370         );
371         _totalLocked[from] = _totalLocked[from].add(amount);
372         _locks[from].push(LockInfo(amount, due));
373         emit Lock(from, amount, due);
374         success = true;
375     }
376 
377     function _unlock(address from, uint256 index) internal returns (bool success) {
378         LockInfo storage lock = _locks[from][index];
379         _totalLocked[from] = _totalLocked[from].sub(lock.amount);
380         emit Unlock(from, lock.amount);
381         _locks[from][index] = _locks[from][_locks[from].length - 1];
382         _locks[from].pop();
383         success = true;
384     }
385 
386     function unlock(address from) external returns (bool success) {
387         for(uint256 i = 0; i < _locks[from].length; i++){
388             if(_locks[from][i].due < now){
389                 _unlock(from, i);
390             }
391         }
392         success = true;
393     }
394 
395     function releaseLock(address from)
396         external
397         onlyOwner
398         returns (bool success)
399     {
400         for(uint256 i = 0; i < _locks[from].length; i++){
401             _unlock(from, i);
402         }
403         success = true;
404     }
405 
406     function lockInfo(address locked, uint256 index)
407         external
408         view
409         returns (uint256 amount, uint256 due)
410     {
411         LockInfo memory lock = _locks[locked][index];
412         amount = lock.amount;
413         due = lock.due;
414     }
415 
416     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
417         amount = _totalLocked[locked];
418         length = _locks[locked].length;
419     }
420 }
421 
422 // File: contracts/library/Pausable.sol
423 
424 pragma solidity 0.6.6;
425 
426 
427 contract Pausable is Ownable {
428     bool internal _paused;
429 
430     event Paused();
431     event Unpaused();
432 
433     modifier whenPaused() {
434         require(_paused, "Paused : This function can only be called when paused");
435         _;
436     }
437 
438     modifier whenNotPaused() {
439         require(!_paused, "Paused : This function can only be called when not paused");
440         _;
441     }
442 
443     function pause() external onlyOwner whenNotPaused returns (bool success) {
444         _paused = true;
445         emit Paused();
446         success = true;
447     }
448 
449     function unPause() external onlyOwner whenPaused returns (bool success) {
450         _paused = false;
451         emit Unpaused();
452         success = true;
453     }
454 
455     function paused() external view returns (bool) {
456         return _paused;
457     }
458 }
459 
460 // File: contracts/erc20/ERC20Burnable.sol
461 
462 pragma solidity 0.6.6;
463 
464 
465 
466 abstract contract ERC20Burnable is ERC20, Pausable {
467     event Burn(address indexed burned, uint256 amount);
468 
469     function burn(uint256 amount)
470         external
471         whenNotPaused
472         returns (bool success)
473     {
474         success = _burn(msg.sender, amount);
475         emit Burn(msg.sender, amount);
476         success = true;
477     }
478 
479     function burnFrom(address burned, uint256 amount)
480         external
481         whenNotPaused
482         returns (bool success)
483     {
484         _burn(burned, amount);
485         emit Burn(burned, amount);
486         success = _approve(
487             burned,
488             msg.sender,
489             _allowances[burned][msg.sender].sub(
490                 amount,
491                 "ERC20Burnable/burnFrom : Cannot burn more than allowance"
492             )
493         );
494     }
495 }
496 
497 // File: contracts/erc20/ERC20Mintable.sol
498 
499 pragma solidity 0.6.6;
500 
501 
502 
503 abstract contract ERC20Mintable is ERC20, Pausable {
504     event Mint(address indexed receiver, uint256 amount);
505     event MintFinished();
506 
507     bool internal _mintingFinished;
508     ///@notice mint token
509     ///@dev only owner can call this function
510     function mint(address receiver, uint256 amount)
511         external
512         onlyOwner
513         whenNotPaused
514         returns (bool success)
515     {
516         require(
517             receiver != address(0),
518             "ERC20Mintable/mint : Should not mint to zero address"
519         );
520         require(
521             !_mintingFinished,
522             "ERC20Mintable/mint : Cannot mint after finished"
523         );
524         _mint(receiver, amount);
525         emit Mint(receiver, amount);
526         success = true;
527     }
528 
529     ///@notice finish minting, cannot mint after calling this function
530     ///@dev only owner can call this function
531     function finishMint()
532         external
533         onlyOwner
534         returns (bool success)
535     {
536         require(
537             !_mintingFinished,
538             "ERC20Mintable/finishMinting : Already finished"
539         );
540         _mintingFinished = true;
541         emit MintFinished();
542         return true;
543     }
544 
545     function isFinished() external view returns(bool finished) {
546         finished = _mintingFinished;
547     }
548 }
549 
550 // File: contracts/library/Freezable.sol
551 
552 pragma solidity 0.6.6;
553 
554 
555 contract Freezable is Ownable {
556     mapping(address => bool) private _frozen;
557 
558     event Freeze(address indexed target);
559     event Unfreeze(address indexed target);
560 
561     modifier whenNotFrozen(address target) {
562         require(!_frozen[target], "Freezable : target is frozen");
563         _;
564     }
565 
566     function freeze(address target) external onlyOwner returns (bool success) {
567         _frozen[target] = true;
568         emit Freeze(target);
569         success = true;
570     }
571 
572     function unFreeze(address target)
573         external
574         onlyOwner
575         returns (bool success)
576     {
577         _frozen[target] = false;
578         emit Unfreeze(target);
579         success = true;
580     }
581 
582     function isFrozen(address target)
583         external
584         view
585         returns (bool frozen)
586     {
587         return _frozen[target];
588     }
589 }
590 
591 // File: contracts/Ontact Protocol.sol
592 
593 pragma solidity 0.6.6;
594 
595 
596 
597 
598 
599 
600 contract CROS is
601     ERC20Lockable,
602     ERC20Burnable,
603     ERC20Mintable,
604     Freezable
605 {
606     string constant private _name = "TUTOR Token";
607     string constant private _symbol = "TUR";
608     uint8 constant private _decimals = 18;
609     uint256 constant private _initial_supply = 1_000_000_000;
610 
611     constructor() public Ownable() {
612         _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
613     }
614 
615     function transfer(address to, uint256 amount)
616         override
617         external
618         whenNotFrozen(msg.sender)
619         whenNotPaused
620         checkLock(msg.sender, amount)
621         returns (bool success)
622     {
623         require(
624             to != address(0),
625             "GRBT/transfer : Should not send to zero address"
626         );
627         _transfer(msg.sender, to, amount);
628         success = true;
629     }
630 
631     function transferFrom(address from, address to, uint256 amount)
632         override
633         external
634         whenNotFrozen(from)
635         whenNotPaused
636         checkLock(from, amount)
637         returns (bool success)
638     {
639         require(
640             to != address(0),
641             "CROS/transferFrom : Should not send to zero address"
642         );
643         _transfer(from, to, amount);
644         _approve(
645             from,
646             msg.sender,
647             _allowances[from][msg.sender].sub(
648                 amount,
649                 "CROS/transferFrom : Cannot send more than allowance"
650             )
651         );
652         success = true;
653     }
654 
655     function approve(address spender, uint256 amount)
656         override
657         external
658         returns (bool success)
659     {
660         require(
661             spender != address(0),
662             "CROS/approve : Should not approve zero address"
663         );
664         _approve(msg.sender, spender, amount);
665         success = true;
666     }
667 
668     function name() override external view returns (string memory tokenName) {
669         tokenName = _name;
670     }
671 
672     function symbol() override external view returns (string memory tokenSymbol) {
673         tokenSymbol = _symbol;
674     }
675 
676     function decimals() override external view returns (uint8 tokenDecimals) {
677         tokenDecimals = _decimals;
678     }
679 }