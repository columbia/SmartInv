1 // File: contracts/library/SafeMath.sol
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
172 // File: contracts/erc20/ERC20.sol
173 
174 pragma solidity 0.7.1;
175 
176 
177 abstract contract ERC20 {
178     using SafeMath for uint256;
179 
180     uint256 private _totalSupply;
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
335 // File: contracts/erc20/ERC20Lockable.sol
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
387         success = true;
388     }
389 
390     function unlockAll(address from) external returns (bool success) {
391         for(uint256 i = 0; i < _locks[from].length; i++){
392             if(_locks[from][i].due < block.timestamp){
393                 _unlock(from, i);
394                 i--;
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
406             _unlock(from, i);
407             i--;
408         }
409         success = true;
410     }
411 
412     function transferWithLockUp(address recipient, uint256 amount, uint256 due)
413     external
414     onlyOwner
415     returns (bool success)
416     {
417         require(
418             recipient != address(0),
419             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
420         );
421         _transfer(msg.sender, recipient, amount);
422         _lock(recipient, amount, due);
423         success = true;
424     }
425 
426     function lockInfo(address locked, uint256 index)
427     external
428     view
429     returns (uint256 amount, uint256 due)
430     {
431         LockInfo memory lock = _locks[locked][index];
432         amount = lock.amount;
433         due = lock.due;
434     }
435 
436     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
437         amount = _totalLocked[locked];
438         length = _locks[locked].length;
439     }
440 }
441 
442 // File: contracts/library/Pausable.sol
443 
444 pragma solidity 0.7.1;
445 
446 
447 contract Pausable is Ownable {
448     bool internal _paused;
449 
450     event Paused();
451     event Unpaused();
452 
453     modifier whenPaused() {
454         require(_paused, "Paused : This function can only be called when paused");
455         _;
456     }
457 
458     modifier whenNotPaused() {
459         require(!_paused, "Paused : This function can only be called when not paused");
460         _;
461     }
462 
463     function pause() external onlyOwner whenNotPaused returns (bool success) {
464         _paused = true;
465         emit Paused();
466         success = true;
467     }
468 
469     function unPause() external onlyOwner whenPaused returns (bool success) {
470         _paused = false;
471         emit Unpaused();
472         success = true;
473     }
474 
475     function paused() external view returns (bool) {
476         return _paused;
477     }
478 }
479 
480 // File: contracts/erc20/ERC20Burnable.sol
481 
482 pragma solidity 0.7.1;
483 
484 
485 
486 abstract contract ERC20Burnable is ERC20, Pausable {
487     using SafeMath for uint256;
488 
489     event Burn(address indexed burned, uint256 amount);
490 
491     function burn(uint256 amount)
492         external
493         whenNotPaused
494         returns (bool success)
495     {
496         success = _burn(msg.sender, amount);
497         emit Burn(msg.sender, amount);
498         success = true;
499     }
500 
501     function burnFrom(address burned, uint256 amount)
502         external
503         whenNotPaused
504         returns (bool success)
505     {
506         _burn(burned, amount);
507         emit Burn(burned, amount);
508         success = _approve(
509             burned,
510             msg.sender,
511             _allowances[burned][msg.sender].sub(
512                 amount,
513                 "ERC20Burnable/burnFrom : Cannot burn more than allowance"
514             )
515         );
516     }
517 }
518 
519 // File: contracts/library/Freezable.sol
520 
521 pragma solidity 0.7.1;
522 
523 
524 contract Freezable is Ownable {
525     mapping(address => bool) private _frozen;
526 
527     event Freeze(address indexed target);
528     event Unfreeze(address indexed target);
529 
530     modifier whenNotFrozen(address target) {
531         require(!_frozen[target], "Freezable : target is frozen");
532         _;
533     }
534 
535     function freeze(address target) external onlyOwner returns (bool success) {
536         _frozen[target] = true;
537         emit Freeze(target);
538         success = true;
539     }
540 
541     function unFreeze(address target)
542         external
543         onlyOwner
544         returns (bool success)
545     {
546         _frozen[target] = false;
547         emit Unfreeze(target);
548         success = true;
549     }
550 
551     function isFrozen(address target)
552         external
553         view
554         returns (bool frozen)
555     {
556         return _frozen[target];
557     }
558 }
559 
560 // File: contracts/ANCToken.sol
561 
562 pragma solidity 0.7.1;
563 
564 
565 
566 
567 
568 contract ANCToken is
569     ERC20Lockable,
570     ERC20Burnable,
571     Freezable
572 {
573     using SafeMath for uint256;
574     string constant private _name = "ANC";
575     string constant private _symbol = "ANC";
576     uint8 constant private _decimals = 18;
577     uint256 constant private _initial_supply = 3000000000;
578 
579     constructor() Ownable() {
580         _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
581     }
582 
583     function transfer(address to, uint256 amount)
584         override
585         external
586         whenNotFrozen(msg.sender)
587         whenNotPaused
588         checkLock(msg.sender, amount)
589         returns (bool success)
590     {
591         require(
592             to != address(0),
593             "ANC/transfer : Should not send to zero address"
594         );
595         _transfer(msg.sender, to, amount);
596         success = true;
597     }
598 
599     function transferFrom(address from, address to, uint256 amount)
600         override
601         external
602         whenNotFrozen(from)
603         whenNotPaused
604         checkLock(from, amount)
605         returns (bool success)
606     {
607         require(
608             to != address(0),
609             "ANC/transferFrom : Should not send to zero address"
610         );
611         _transfer(from, to, amount);
612         _approve(
613             from,
614             msg.sender,
615             _allowances[from][msg.sender].sub(
616                 amount,
617                 "ANC/transferFrom : Cannot send more than allowance"
618             )
619         );
620         success = true;
621     }
622 
623     function approve(address spender, uint256 amount)
624         override
625         external
626         returns (bool success)
627     {
628         require(
629             spender != address(0),
630             "ANC/approve : Should not approve zero address"
631         );
632         _approve(msg.sender, spender, amount);
633         success = true;
634     }
635 
636     function name() override external pure returns (string memory tokenName) {
637         tokenName = _name;
638     }
639 
640     function symbol() override external pure returns (string memory tokenSymbol) {
641         tokenSymbol = _symbol;
642     }
643 
644     function decimals() override external pure returns (uint8 tokenDecimals) {
645         tokenDecimals = _decimals;
646     }
647 }