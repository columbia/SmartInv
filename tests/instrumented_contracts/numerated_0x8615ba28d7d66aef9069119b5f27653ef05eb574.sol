1 // File: contracts/library/SafeMath.sol
2 
3 pragma solidity 0.6.5;
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
172 // File: contracts/erc20/ERC20.sol
173 
174 pragma solidity 0.6.5;
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
286 // File: contracts/library/Ownable.sol
287 
288 pragma solidity 0.6.5;
289 
290 contract Ownable {
291     address internal _owner;
292 
293     event OwnershipTransferred(
294         address indexed currentOwner,
295         address indexed newOwner
296     );
297 
298     constructor() internal {
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
335 // File: contracts/erc20/ERC20Lockable.sol
336 
337 pragma solidity 0.6.5;
338 
339 
340 
341 abstract contract ERC20Lockable is ERC20, Ownable {
342     struct LockInfo {
343         uint256 amount;
344         uint256 due;
345     }
346 
347     mapping(address => LockInfo[]) internal _locks;
348     mapping(address => uint256) internal _totalLocked;
349 
350     event Lock(address indexed from, uint256 amount, uint256 due);
351     event Unlock(address indexed from, uint256 amount);
352 
353     modifier checkLock(address from, uint256 amount) {
354         require(_balances[from] >= _totalLocked[from].add(amount), "ERC20Lockable/Cannot send more than unlocked amount");
355         _;
356     }
357 
358     function _lock(address from, uint256 amount, uint256 due)
359         internal
360         returns (bool success)
361     {
362         require(due > now, "ERC20Lockable/lock : Cannot set due to past");
363         require(
364             _balances[from] >= amount.add(_totalLocked[from]),
365             "ERC20Lockable/lock : locked total should be smaller than balance"
366         );
367         _totalLocked[from] = _totalLocked[from].add(amount);
368         _locks[from].push(LockInfo(amount, due));
369         emit Lock(from, amount, due);
370         success = true;
371     }
372 
373     function _unlock(address from, uint256 index) internal returns (bool success) {
374         LockInfo storage lock = _locks[from][index];
375         _totalLocked[from] = _totalLocked[from].sub(lock.amount);
376         emit Unlock(from, lock.amount);
377         _locks[from][index] = _locks[from][_locks[from].length - 1];
378         _locks[from].pop();
379         success = true;
380     }
381 
382     function unlock(address from) external returns (bool success) {
383         for(uint256 i = 0; i < _locks[from].length; i++){
384             if(_locks[from][i].due < now){
385                 _unlock(from, i);
386             }
387         }
388         success = true;
389     }
390 
391     function releaseLock(address from)
392         external
393         onlyOwner
394         returns (bool success)
395     {
396         for(uint256 i = 0; i < _locks[from].length; i++){
397             _unlock(from, i);
398         }
399         success = true;
400     }
401 
402     function transferWithLockUp(address recipient, uint256 amount, uint256 due)
403         external
404         returns (bool success)
405     {
406         require(
407             recipient != address(0),
408             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
409         );
410         _transfer(msg.sender, recipient, amount);
411         _lock(recipient, amount, due);
412         success = true;
413     }
414 
415     function lockInfo(address locked, uint256 index)
416         external
417         view
418         returns (uint256 amount, uint256 due)
419     {
420         LockInfo memory lock = _locks[locked][index];
421         amount = lock.amount;
422         due = lock.due;
423     }
424 
425     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
426         amount = _totalLocked[locked];
427         length = _locks[locked].length;
428     }
429 }
430 
431 // File: contracts/library/Pausable.sol
432 
433 pragma solidity 0.6.5;
434 
435 
436 contract Pausable is Ownable {
437     bool internal _paused;
438 
439     event Paused();
440     event Unpaused();
441 
442     modifier whenPaused() {
443         require(_paused, "Paused : This function can only be called when paused");
444         _;
445     }
446 
447     modifier whenNotPaused() {
448         require(!_paused, "Paused : This function can only be called when not paused");
449         _;
450     }
451 
452     function pause() external onlyOwner whenNotPaused returns (bool success) {
453         _paused = true;
454         emit Paused();
455         success = true;
456     }
457 
458     function unPause() external onlyOwner whenPaused returns (bool success) {
459         _paused = false;
460         emit Unpaused();
461         success = true;
462     }
463 
464     function paused() external view returns (bool) {
465         return _paused;
466     }
467 }
468 
469 // File: contracts/erc20/ERC20Burnable.sol
470 
471 pragma solidity 0.6.5;
472 
473 
474 
475 abstract contract ERC20Burnable is ERC20, Pausable {
476     event Burn(address indexed burned, uint256 amount);
477 
478     function burn(uint256 amount)
479         external
480         whenNotPaused
481         returns (bool success)
482     {
483         success = _burn(msg.sender, amount);
484         emit Burn(msg.sender, amount);
485         success = true;
486     }
487 
488     function burnFrom(address burned, uint256 amount)
489         external
490         whenNotPaused
491         returns (bool success)
492     {
493         _burn(burned, amount);
494         emit Burn(burned, amount);
495         success = _approve(
496             burned,
497             msg.sender,
498             _allowances[burned][msg.sender].sub(
499                 amount,
500                 "ERC20Burnable/burnFrom : Cannot burn more than allowance"
501             )
502         );
503     }
504 }
505 
506 // File: contracts/erc20/ERC20Mintable.sol
507 
508 pragma solidity 0.6.5;
509 
510 
511 
512 abstract contract ERC20Mintable is ERC20, Pausable {
513     event Mint(address indexed receiver, uint256 amount);
514     event MintFinished();
515     uint256 internal _cap;
516     bool internal _mintingFinished;
517     ///@notice mint token
518     ///@dev only owner can call this function
519     function mint(address receiver, uint256 amount)
520         external
521         onlyOwner
522         whenNotPaused
523         returns (bool success)
524     {
525         require(
526             receiver != address(0),
527             "ERC20Mintable/mint : Should not mint to zero address"
528         );
529         require(
530             _totalSupply.add(amount) <= _cap,
531             "ERC20Mintable/mint : Cannot mint over cap"
532         );
533         require(
534             !_mintingFinished,
535             "ERC20Mintable/mint : Cannot mint after finished"
536         );
537         _mint(receiver, amount);
538         emit Mint(receiver, amount);
539         success = true;
540     }
541 
542     ///@notice finish minting, cannot mint after calling this function
543     ///@dev only owner can call this function
544     function finishMint()
545         external
546         onlyOwner
547         returns (bool success)
548     {
549         require(
550             !_mintingFinished,
551             "ERC20Mintable/finishMinting : Already finished"
552         );
553         _mintingFinished = true;
554         emit MintFinished();
555         return true;
556     }
557 
558     function cap()
559         external
560         view
561         returns (uint256)
562     {
563         return _cap;
564     }
565 
566     function isFinished() external view returns(bool finished) {
567         finished = _mintingFinished;
568     }
569 }
570 
571 // File: contracts/library/Freezable.sol
572 
573 pragma solidity 0.6.5;
574 
575 
576 contract Freezable is Ownable {
577     mapping(address => bool) private _frozen;
578 
579     event Freeze(address indexed target);
580     event Unfreeze(address indexed target);
581 
582     modifier whenNotFrozen(address target) {
583         require(!_frozen[target], "Freezable : target is frozen");
584         _;
585     }
586 
587     function freeze(address target) external onlyOwner returns (bool success) {
588         _frozen[target] = true;
589         emit Freeze(target);
590         success = true;
591     }
592 
593     function unFreeze(address target)
594         external
595         onlyOwner
596         returns (bool success)
597     {
598         _frozen[target] = false;
599         emit Unfreeze(target);
600         success = true;
601     }
602 
603     function isFrozen(address target)
604         external
605         view
606         returns (bool frozen)
607     {
608         return _frozen[target];
609     }
610 }
611 
612 // File: contracts/FrommCar.sol
613 
614 pragma solidity 0.6.5;
615 
616 
617 
618 
619 
620 
621 contract FrommCar is
622     ERC20Lockable,
623     ERC20Burnable,
624     ERC20Mintable,
625     Freezable
626 {
627     string constant private _name = "FrommCar";
628     string constant private _symbol = "FCR";
629     uint8 constant private _decimals = 18;
630     uint256 constant private _initial_supply = 3_000_000_000;
631 
632     constructor() public Ownable() {
633         _cap = 10_000_000_000 * (10**uint256(_decimals));
634         _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
635     }
636 
637     function transfer(address to, uint256 amount)
638         override
639         external
640         whenNotFrozen(msg.sender)
641         whenNotPaused
642         checkLock(msg.sender, amount)
643         returns (bool success)
644     {
645         require(
646             to != address(0),
647             "FCR/transfer : Should not send to zero address"
648         );
649         _transfer(msg.sender, to, amount);
650         success = true;
651     }
652 
653     function transferFrom(address from, address to, uint256 amount)
654         override
655         external
656         whenNotFrozen(from)
657         whenNotPaused
658         checkLock(from, amount)
659         returns (bool success)
660     {
661         require(
662             to != address(0),
663             "FCR/transferFrom : Should not send to zero address"
664         );
665         _transfer(from, to, amount);
666         _approve(
667             from,
668             msg.sender,
669             _allowances[from][msg.sender].sub(
670                 amount,
671                 "FCR/transferFrom : Cannot send more than allowance"
672             )
673         );
674         success = true;
675     }
676 
677     function approve(address spender, uint256 amount)
678         override
679         external
680         returns (bool success)
681     {
682         require(
683             spender != address(0),
684             "FCR/approve : Should not approve zero address"
685         );
686         _approve(msg.sender, spender, amount);
687         success = true;
688     }
689 
690     function name() override external view returns (string memory tokenName) {
691         tokenName = _name;
692     }
693 
694     function symbol() override external view returns (string memory tokenSymbol) {
695         tokenSymbol = _symbol;
696     }
697 
698     function decimals() override external view returns (uint8 tokenDecimals) {
699         tokenDecimals = _decimals;
700     }
701 }