1 // File: contracts\library\SafeMath.sol
2 
3 pragma solidity 0.7.1;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage)
60         internal
61         pure
62         returns (uint256)
63     {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      *
119      * _Available since v2.4.0._
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage)
122         internal
123         pure
124         returns (uint256)
125     {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts with custom message when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      *
160      * _Available since v2.4.0._
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage)
163         internal
164         pure
165         returns (uint256)
166     {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 // File: contracts\erc20\ERC20.sol
173 
174 pragma solidity 0.7.1;
175 
176 
177 abstract contract ERC20 {
178     using SafeMath for uint256;
179 
180     uint256 internal _totalSupply;
181     mapping(address => uint256) internal _balances;
182     mapping(address => mapping(address => uint256)) internal _allowances;
183 
184     event Transfer(address indexed from, address indexed to, uint256 amount);
185     event Approval(
186         address indexed owner,
187         address indexed spender,
188         uint256 amount
189     );
190 
191     /*
192    * Internal Functions for ERC20 standard logics
193    */
194 
195     function _transfer(address from, address to, uint256 amount)
196         internal
197         returns (bool success)
198     {
199         _balances[from] = _balances[from].sub(
200             amount,
201             "ERC20/transfer : cannot transfer more than token owner balance"
202         );
203         _balances[to] = _balances[to].add(amount);
204         emit Transfer(from, to, amount);
205         success = true;
206     }
207 
208     function _approve(address owner, address spender, uint256 amount)
209         internal
210         returns (bool success)
211     {
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214         success = true;
215     }
216 
217     function _mint(address recipient, uint256 amount)
218         internal
219         returns (bool success)
220     {
221         _totalSupply = _totalSupply.add(amount);
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(address(0), recipient, amount);
224         success = true;
225     }
226 
227     function _burn(address burned, uint256 amount)
228         internal
229         returns (bool success)
230     {
231         _balances[burned] = _balances[burned].sub(
232             amount,
233             "ERC20Burnable/burn : Cannot burn more than user's balance"
234         );
235         _totalSupply = _totalSupply.sub(
236             amount,
237             "ERC20Burnable/burn : Cannot burn more than totalSupply"
238         );
239         emit Transfer(burned, address(0), amount);
240         success = true;
241     }
242 
243     /*
244    * public view functions to view common data
245    */
246 
247     function totalSupply() external view returns (uint256 total) {
248         total = _totalSupply;
249     }
250     function balanceOf(address owner) external view returns (uint256 balance) {
251         balance = _balances[owner];
252     }
253 
254     function allowance(address owner, address spender)
255         external
256         view
257         returns (uint256 remaining)
258     {
259         remaining = _allowances[owner][spender];
260     }
261 
262     /*
263    * External view Function Interface to implement on final contract
264    */
265     function name() virtual external view returns (string memory tokenName);
266     function symbol() virtual external view returns (string memory tokenSymbol);
267     function decimals() virtual external view returns (uint8 tokenDecimals);
268 
269     /*
270    * External Function Interface to implement on final contract
271    */
272     function transfer(address to, uint256 amount)
273         virtual
274         external
275         returns (bool success);
276     function transferFrom(address from, address to, uint256 amount)
277         virtual
278         external
279         returns (bool success);
280     function approve(address spender, uint256 amount)
281         virtual
282         external
283         returns (bool success);
284 }
285 
286 // File: contracts\library\Ownable.sol
287 
288 pragma solidity 0.7.1;
289 
290 abstract contract Ownable {
291     address internal _owner;
292 
293     event OwnershipTransferred(
294         address indexed currentOwner,
295         address indexed newOwner
296     );
297 
298     constructor() {
299         _owner = msg.sender;
300         emit OwnershipTransferred(address(0), msg.sender);
301     }
302 
303     modifier onlyOwner() {
304         require(
305             msg.sender == _owner,
306             "Ownable : Function called by unauthorized user."
307         );
308         _;
309     }
310 
311     function owner() external view returns (address ownerAddress) {
312         ownerAddress = _owner;
313     }
314 
315     function transferOwnership(address newOwner)
316         public
317         onlyOwner
318         returns (bool success)
319     {
320         require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
321         success = _transferOwnership(newOwner);
322     }
323 
324     function renounceOwnership() external onlyOwner returns (bool success) {
325         success = _transferOwnership(address(0));
326     }
327 
328     function _transferOwnership(address newOwner) internal returns (bool success) {
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331         success = true;
332     }
333 }
334 
335 // File: contracts\erc20\ERC20Lockable.sol
336 
337 pragma solidity 0.7.1;
338 
339 
340 
341 abstract contract ERC20Lockable is ERC20, Ownable {
342     using SafeMath for uint256;
343 
344     struct LockInfo {
345         uint256 amount;
346         uint256 due;
347     }
348 
349     mapping(address => LockInfo[]) internal _locks;
350     mapping(address => uint256) internal _totalLocked;
351 
352     event Lock(address indexed from, uint256 amount, uint256 due);
353     event Unlock(address indexed from, uint256 amount);
354 
355     modifier checkLock(address from, uint256 amount) {
356         require(_balances[from] >= _totalLocked[from].add(amount), "ERC20Lockable/Cannot send more than unlocked amount");
357         _;
358     }
359 
360     function _lock(address from, uint256 amount, uint256 due)
361     internal
362     returns (bool success)
363     {
364         require(due > block.timestamp, "ERC20Lockable/lock : Cannot set due to past");
365         require(
366             _balances[from] >= amount.add(_totalLocked[from]),
367             "ERC20Lockable/lock : locked total should be smaller than balance"
368         );
369         _totalLocked[from] = _totalLocked[from].add(amount);
370         _locks[from].push(LockInfo(amount, due));
371         emit Lock(from, amount, due);
372         success = true;
373     }
374 
375     function _unlock(address from, uint256 index) internal returns (bool success) {
376         LockInfo storage lock = _locks[from][index];
377         _totalLocked[from] = _totalLocked[from].sub(lock.amount);
378         emit Unlock(from, lock.amount);
379         _locks[from][index] = _locks[from][_locks[from].length - 1];
380         _locks[from].pop();
381         success = true;
382     }
383 
384     function unlock(address from, uint256 idx) external returns(bool success){
385         require(_locks[from][idx].due < block.timestamp,"ERC20Lockable/unlock: cannot unlock before due");
386         _unlock(from, idx);
387     }
388 
389     function unlockAll(address from) external returns (bool success) {
390         for(uint256 i = 0; i < _locks[from].length; i++){
391             if(_locks[from][i].due < block.timestamp){
392                 if(_unlock(from, i)){
393                     i--;
394                 }
395             }
396         }
397         success = true;
398     }
399 
400     function releaseLock(address from)
401     external
402     onlyOwner
403     returns (bool success)
404     {
405         for(uint256 i = 0; i < _locks[from].length; i++){
406             if(_unlock(from, i)){
407                 i--;
408             }
409         }
410         success = true;
411     }
412 
413     function transferWithLockUp(address recipient, uint256 amount, uint256 due)
414     external
415     onlyOwner
416     returns (bool success)
417     {
418         require(
419             recipient != address(0),
420             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
421         );
422         _transfer(msg.sender, recipient, amount);
423         _lock(recipient, amount, due);
424         success = true;
425     }
426 
427     function lockInfo(address locked, uint256 index)
428     external
429     view
430     returns (uint256 amount, uint256 due)
431     {
432         LockInfo memory lock = _locks[locked][index];
433         amount = lock.amount;
434         due = lock.due;
435     }
436 
437     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
438         amount = _totalLocked[locked];
439         length = _locks[locked].length;
440     }
441 }
442 
443 // File: contracts\library\Pausable.sol
444 
445 pragma solidity 0.7.1;
446 
447 
448 contract Pausable is Ownable {
449     bool internal _paused;
450 
451     event Paused();
452     event Unpaused();
453 
454     modifier whenPaused() {
455         require(_paused, "Paused : This function can only be called when paused");
456         _;
457     }
458 
459     modifier whenNotPaused() {
460         require(!_paused, "Paused : This function can only be called when not paused");
461         _;
462     }
463 
464     function pause() external onlyOwner whenNotPaused returns (bool success) {
465         _paused = true;
466         emit Paused();
467         success = true;
468     }
469 
470     function unPause() external onlyOwner whenPaused returns (bool success) {
471         _paused = false;
472         emit Unpaused();
473         success = true;
474     }
475 
476     function paused() external view returns (bool) {
477         return _paused;
478     }
479 }
480 
481 // File: contracts\erc20\ERC20Burnable.sol
482 
483 pragma solidity 0.7.1;
484 
485 
486 
487 abstract contract ERC20Burnable is ERC20, Pausable {
488     using SafeMath for uint256;
489 
490     event Burn(address indexed burned, uint256 amount);
491 
492     function burn(uint256 amount)
493         external
494         whenNotPaused
495         returns (bool success)
496     {
497         success = _burn(msg.sender, amount);
498         emit Burn(msg.sender, amount);
499         success = true;
500     }
501 
502     function burnFrom(address burned, uint256 amount)
503         external
504         whenNotPaused
505         returns (bool success)
506     {
507         _burn(burned, amount);
508         emit Burn(burned, amount);
509         success = _approve(
510             burned,
511             msg.sender,
512             _allowances[burned][msg.sender].sub(
513                 amount,
514                 "ERC20Burnable/burnFrom : Cannot burn more than allowance"
515             )
516         );
517     }
518 }
519 
520 // File: contracts\erc20\ERC20Mintable.sol
521 
522 pragma solidity 0.7.1;
523 
524 
525 
526 abstract contract ERC20Mintable is ERC20, Pausable {
527     event Mint(address indexed receiver, uint256 amount);
528     event MintFinished();
529 
530     bool internal _mintingFinished;
531     ///@notice mint token
532     ///@dev only owner can call this function
533     function mint(address receiver, uint256 amount)
534         virtual
535         external
536         returns (bool success);
537 
538     ///@notice finish minting, cannot mint after calling this function
539     ///@dev only owner can call this function
540     function finishMint()
541         external
542         onlyOwner
543         returns (bool success)
544     {
545         require(
546             !_mintingFinished,
547             "ERC20Mintable/finishMinting : Already finished"
548         );
549         _mintingFinished = true;
550         emit MintFinished();
551         return true;
552     }
553 
554     function isFinished() external view returns(bool finished) {
555         finished = _mintingFinished;
556     }
557 }
558 
559 // File: contracts\library\Freezable.sol
560 
561 pragma solidity 0.7.1;
562 
563 
564 contract Freezable is Ownable {
565     mapping(address => bool) private _frozen;
566 
567     event Freeze(address indexed target);
568     event Unfreeze(address indexed target);
569 
570     modifier whenNotFrozen(address target) {
571         require(!_frozen[target], "Freezable : target is frozen");
572         _;
573     }
574 
575     function freeze(address target) external onlyOwner returns (bool success) {
576         _frozen[target] = true;
577         emit Freeze(target);
578         success = true;
579     }
580 
581     function unFreeze(address target)
582         external
583         onlyOwner
584         returns (bool success)
585     {
586         _frozen[target] = false;
587         emit Unfreeze(target);
588         success = true;
589     }
590 
591     function isFrozen(address target)
592         external
593         view
594         returns (bool frozen)
595     {
596         return _frozen[target];
597     }
598 }
599 
600 // File: contracts\Talken.sol
601 
602 pragma solidity 0.7.1;
603 
604 
605 
606 
607 
608 
609 contract Talken is
610     ERC20Lockable,
611     ERC20Burnable,
612     ERC20Mintable,
613     Freezable
614 {
615     using SafeMath for uint256;
616     string constant private _name = "Talken";
617     string constant private _symbol = "TALK";
618     uint8 constant private _decimals = 18;
619     uint256 constant private _initial_supply = 0;
620 
621     constructor() Ownable() {
622     }
623 
624     function mint(address receiver, uint256 amount)
625         override
626         external
627         onlyOwner
628         whenNotPaused
629         returns (bool success)
630     {
631         require(
632             receiver != address(0),
633             "ERC20Mintable/mint : Should not mint to zero address"
634         );
635         require(
636             !_mintingFinished,
637             "ERC20Mintable/mint : Cannot mint after finished"
638         );
639         require(
640             _totalSupply.add(amount) <= (500_000_000 * (10 ** uint256(18))),
641             "ERC20Mintable/mint  : Cannot mint more than cap" 
642         );
643         _mint(receiver, amount);
644         emit Mint(receiver, amount);
645         success = true;
646     }
647 
648     function transfer(address to, uint256 amount)
649         override
650         external
651         whenNotFrozen(msg.sender)
652         whenNotPaused
653         checkLock(msg.sender, amount)
654         returns (bool success) {
655            require(
656             to != address(0),
657             "TALK/transfer : Should not send to zero address"
658         );
659         _transfer(msg.sender, to, amount);
660         success = true;
661     }
662 
663     function transferFrom(address from, address to, uint256 amount)
664         override
665         external
666         whenNotFrozen(from)
667         whenNotPaused
668         checkLock(from, amount)
669         returns (bool success)
670     {
671         require(
672             to != address(0),
673             "TALK/transferFrom : Should not send to zero address"
674         );
675         _transfer(from, to, amount);
676         _approve(
677             from,
678             msg.sender,
679             _allowances[from][msg.sender].sub(
680                 amount,
681                 "TALK/transferFrom : Cannot send more than allowance"
682             )
683         );
684         success = true;
685     }
686 
687     function approve(address spender, uint256 amount)
688         override
689         external
690         returns (bool success)
691     {
692         require(
693             spender != address(0),
694             "SAM/approve : Should not approve zero address"
695         );
696         _approve(msg.sender, spender, amount);
697         success = true;
698     }
699 
700     function name() override external pure returns (string memory tokenName) {
701         tokenName = _name;
702     }
703 
704     function symbol() override external pure returns (string memory tokenSymbol) {
705         tokenSymbol = _symbol;
706     }
707 
708     function decimals() override external pure returns (uint8 tokenDecimals) {
709         tokenDecimals = _decimals;
710     }
711 }