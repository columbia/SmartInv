1 // File: contracts\library\SafeMath.sol
2 
3 pragma solidity 0.6.10;
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
174 pragma solidity 0.6.10;
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
286 // File: contracts\library\Ownable.sol
287 
288 pragma solidity 0.6.10;
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
335 // File: contracts\erc20\ERC20Lockable.sol
336 
337 pragma solidity 0.6.10;
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
404         onlyOwner
405         returns (bool success)
406     {
407         require(
408             recipient != address(0),
409             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
410         );
411         _transfer(msg.sender, recipient, amount);
412         _lock(recipient, amount, due);
413         success = true;
414     }
415 
416     function lockInfo(address locked, uint256 index)
417         external
418         view
419         returns (uint256 amount, uint256 due)
420     {
421         LockInfo memory lock = _locks[locked][index];
422         amount = lock.amount;
423         due = lock.due;
424     }
425 
426     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
427         amount = _totalLocked[locked];
428         length = _locks[locked].length;
429     }
430 }
431 
432 // File: contracts\library\Pausable.sol
433 
434 pragma solidity 0.6.10;
435 
436 
437 contract Pausable is Ownable {
438     bool internal _paused;
439 
440     event Paused();
441     event Unpaused();
442 
443     modifier whenPaused() {
444         require(_paused, "Paused : This function can only be called when paused");
445         _;
446     }
447 
448     modifier whenNotPaused() {
449         require(!_paused, "Paused : This function can only be called when not paused");
450         _;
451     }
452 
453     function pause() external onlyOwner whenNotPaused returns (bool success) {
454         _paused = true;
455         emit Paused();
456         success = true;
457     }
458 
459     function unPause() external onlyOwner whenPaused returns (bool success) {
460         _paused = false;
461         emit Unpaused();
462         success = true;
463     }
464 
465     function paused() external view returns (bool) {
466         return _paused;
467     }
468 }
469 
470 // File: contracts\library\Freezable.sol
471 
472 pragma solidity 0.6.10;
473 
474 
475 contract Freezable is Ownable {
476     mapping(address => bool) private _frozen;
477 
478     event Freeze(address indexed target);
479     event Unfreeze(address indexed target);
480 
481     modifier whenNotFrozen(address target) {
482         require(!_frozen[target], "Freezable : target is frozen");
483         _;
484     }
485 
486     function freeze(address target) external onlyOwner returns (bool success) {
487         _frozen[target] = true;
488         emit Freeze(target);
489         success = true;
490     }
491 
492     function unFreeze(address target)
493         external
494         onlyOwner
495         returns (bool success)
496     {
497         _frozen[target] = false;
498         emit Unfreeze(target);
499         success = true;
500     }
501 
502     function isFrozen(address target)
503         external
504         view
505         returns (bool frozen)
506     {
507         return _frozen[target];
508     }
509 }
510 
511 // File: contracts\MileVerseToken.sol
512 
513 pragma solidity 0.6.10;
514 
515 
516 
517 
518 contract MileVerseToken is
519     ERC20Lockable,
520     Pausable,
521     Freezable
522 {
523     string constant private _name = "MileVerse";
524     string constant private _symbol = "MVC";
525     uint8 constant private _decimals = 18;
526     uint256 constant private _initial_supply = 3_000_000_000;
527 
528     constructor() public Ownable() {
529         _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
530     }
531 
532     function transfer(address to, uint256 amount)
533         override
534         external
535         whenNotFrozen(msg.sender)
536         whenNotPaused
537         checkLock(msg.sender, amount)
538         returns (bool success)
539     {
540         require(
541             to != address(0),
542             "SAM/transfer : Should not send to zero address"
543         );
544         _transfer(msg.sender, to, amount);
545         success = true;
546     }
547 
548     function transferFrom(address from, address to, uint256 amount)
549         override
550         external
551         whenNotFrozen(from)
552         whenNotPaused
553         checkLock(from, amount)
554         returns (bool success)
555     {
556         require(
557             to != address(0),
558             "SAM/transferFrom : Should not send to zero address"
559         );
560         _transfer(from, to, amount);
561         _approve(
562             from,
563             msg.sender,
564             _allowances[from][msg.sender].sub(
565                 amount,
566                 "SAM/transferFrom : Cannot send more than allowance"
567             )
568         );
569         success = true;
570     }
571 
572     function approve(address spender, uint256 amount)
573         override
574         external
575         returns (bool success)
576     {
577         require(
578             spender != address(0),
579             "SAM/approve : Should not approve zero address"
580         );
581         _approve(msg.sender, spender, amount);
582         success = true;
583     }
584 
585     function name() override external view returns (string memory tokenName) {
586         tokenName = _name;
587     }
588 
589     function symbol() override external view returns (string memory tokenSymbol) {
590         tokenSymbol = _symbol;
591     }
592 
593     function decimals() override external view returns (uint8 tokenDecimals) {
594         tokenDecimals = _decimals;
595     }
596 }