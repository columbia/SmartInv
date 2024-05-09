1 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
85  * the optional functions; to access them see `ERC20Detailed`.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a `Transfer` event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through `transferFrom`. This is
110      * zero by default.
111      *
112      * This value changes when `approve` or `transferFrom` are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * > Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an `Approval` event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a `Transfer` event.
140      */
141     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to `approve`. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
159 
160 pragma solidity ^0.5.0;
161 
162 /**
163  * @dev Wrappers over Solidity's arithmetic operations with added overflow
164  * checks.
165  *
166  * Arithmetic operations in Solidity wrap on overflow. This can easily result
167  * in bugs, because programmers usually assume that an overflow raises an
168  * error, which is the standard behavior in high level programming languages.
169  * `SafeMath` restores this intuition by reverting the transaction when an
170  * operation overflows.
171  *
172  * Using this library instead of the unchecked operations eliminates an entire
173  * class of bugs, so it's recommended to use it always.
174  */
175 library SafeMath {
176     /**
177      * @dev Returns the addition of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `+` operator.
181      *
182      * Requirements:
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         require(c >= a, "SafeMath: addition overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting on
194      * overflow (when the result is negative).
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b <= a, "SafeMath: subtraction overflow");
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0, "SafeMath: division by zero");
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b != 0, "SafeMath: modulo by zero");
264         return a % b;
265     }
266 }
267 
268 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20.sol
269 
270 pragma solidity ^0.5.0;
271 
272 
273 
274 /**
275  * @dev Implementation of the `IERC20` interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using `_mint`.
279  * For a generic mechanism see `ERC20Mintable`.
280  *
281  * *For a detailed writeup see our guide [How to implement supply
282  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
283  *
284  * We have followed general OpenZeppelin guidelines: functions revert instead
285  * of returning `false` on failure. This behavior is nonetheless conventional
286  * and does not conflict with the expectations of ERC20 applications.
287  *
288  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
289  * This allows applications to reconstruct the allowance for all accounts just
290  * by listening to said events. Other implementations of the EIP may not emit
291  * these events, as it isn't required by the specification.
292  *
293  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
294  * functions have been added to mitigate the well-known issues around setting
295  * allowances. See `IERC20.approve`.
296  */
297 contract ERC20 is IERC20 {
298     using SafeMath for uint256;
299 
300     mapping (address => uint256) private _balances;
301 
302     mapping (address => mapping (address => uint256)) private _allowances;
303 
304     uint256 private _totalSupply;
305 
306     /**
307      * @dev See `IERC20.totalSupply`.
308      */
309     function totalSupply() public view returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See `IERC20.balanceOf`.
315      */
316     function balanceOf(address account) public view returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See `IERC20.transfer`.
322      *
323      * Requirements:
324      *
325      * - `recipient` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address recipient, uint256 amount) public returns (bool) {
329         _transfer(msg.sender, recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See `IERC20.allowance`.
335      */
336     function allowance(address owner, address spender) public view returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     /**
341      * @dev See `IERC20.approve`.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function approve(address spender, uint256 value) public returns (bool) {
348         _approve(msg.sender, spender, value);
349         return true;
350     }
351 
352     /**
353      * @dev See `IERC20.transferFrom`.
354      *
355      * Emits an `Approval` event indicating the updated allowance. This is not
356      * required by the EIP. See the note at the beginning of `ERC20`;
357      *
358      * Requirements:
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `value`.
361      * - the caller must have allowance for `sender`'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
365         _transfer(sender, recipient, amount);
366         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
367         return true;
368     }
369 
370     /**
371      * @dev Atomically increases the allowance granted to `spender` by the caller.
372      *
373      * This is an alternative to `approve` that can be used as a mitigation for
374      * problems described in `IERC20.approve`.
375      *
376      * Emits an `Approval` event indicating the updated allowance.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
383         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
384         return true;
385     }
386 
387     /**
388      * @dev Atomically decreases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to `approve` that can be used as a mitigation for
391      * problems described in `IERC20.approve`.
392      *
393      * Emits an `Approval` event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      * - `spender` must have allowance for the caller of at least
399      * `subtractedValue`.
400      */
401     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
402         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
403         return true;
404     }
405 
406     /**
407      * @dev Moves tokens `amount` from `sender` to `recipient`.
408      *
409      * This is internal function is equivalent to `transfer`, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a `Transfer` event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(address sender, address recipient, uint256 amount) internal {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _balances[sender] = _balances[sender].sub(amount);
425         _balances[recipient] = _balances[recipient].add(amount);
426         emit Transfer(sender, recipient, amount);
427     }
428 
429     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
430      * the total supply.
431      *
432      * Emits a `Transfer` event with `from` set to the zero address.
433      *
434      * Requirements
435      *
436      * - `to` cannot be the zero address.
437      */
438     function _mint(address account, uint256 amount) internal {
439         require(account != address(0), "ERC20: mint to the zero address");
440 
441         _totalSupply = _totalSupply.add(amount);
442         _balances[account] = _balances[account].add(amount);
443         emit Transfer(address(0), account, amount);
444     }
445 
446      /**
447      * @dev Destoys `amount` tokens from `account`, reducing the
448      * total supply.
449      *
450      * Emits a `Transfer` event with `to` set to the zero address.
451      *
452      * Requirements
453      *
454      * - `account` cannot be the zero address.
455      * - `account` must have at least `amount` tokens.
456      */
457     function _burn(address account, uint256 value) internal {
458         require(account != address(0), "ERC20: burn from the zero address");
459 
460         _totalSupply = _totalSupply.sub(value);
461         _balances[account] = _balances[account].sub(value);
462         emit Transfer(account, address(0), value);
463     }
464 
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
467      *
468      * This is internal function is equivalent to `approve`, and can be used to
469      * e.g. set automatic allowances for certain subsystems, etc.
470      *
471      * Emits an `Approval` event.
472      *
473      * Requirements:
474      *
475      * - `owner` cannot be the zero address.
476      * - `spender` cannot be the zero address.
477      */
478     function _approve(address owner, address spender, uint256 value) internal {
479         require(owner != address(0), "ERC20: approve from the zero address");
480         require(spender != address(0), "ERC20: approve to the zero address");
481 
482         _allowances[owner][spender] = value;
483         emit Approval(owner, spender, value);
484     }
485 
486     /**
487      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
488      * from the caller's allowance.
489      *
490      * See `_burn` and `_approve`.
491      */
492     function _burnFrom(address account, uint256 amount) internal {
493         _burn(account, amount);
494         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
495     }
496 }
497 
498 // File: openzeppelin-solidity-2.3.0/contracts/math/Math.sol
499 
500 pragma solidity ^0.5.0;
501 
502 /**
503  * @dev Standard math utilities missing in the Solidity language.
504  */
505 library Math {
506     /**
507      * @dev Returns the largest of two numbers.
508      */
509     function max(uint256 a, uint256 b) internal pure returns (uint256) {
510         return a >= b ? a : b;
511     }
512 
513     /**
514      * @dev Returns the smallest of two numbers.
515      */
516     function min(uint256 a, uint256 b) internal pure returns (uint256) {
517         return a < b ? a : b;
518     }
519 
520     /**
521      * @dev Returns the average of two numbers. The result is rounded towards
522      * zero.
523      */
524     function average(uint256 a, uint256 b) internal pure returns (uint256) {
525         // (a + b) / 2 can overflow, so we distribute
526         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
527     }
528 }
529 
530 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
531 
532 pragma solidity ^0.5.0;
533 
534 /**
535  * @dev Contract module that helps prevent reentrant calls to a function.
536  *
537  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
538  * available, which can be aplied to functions to make sure there are no nested
539  * (reentrant) calls to them.
540  *
541  * Note that because there is a single `nonReentrant` guard, functions marked as
542  * `nonReentrant` may not call one another. This can be worked around by making
543  * those functions `private`, and then adding `external` `nonReentrant` entry
544  * points to them.
545  */
546 contract ReentrancyGuard {
547     /// @dev counter to allow mutex lock with only one SSTORE operation
548     uint256 private _guardCounter;
549 
550     constructor () internal {
551         // The counter starts at one to prevent changing it from zero to a non-zero
552         // value, which is a more expensive operation.
553         _guardCounter = 1;
554     }
555 
556     /**
557      * @dev Prevents a contract from calling itself, directly or indirectly.
558      * Calling a `nonReentrant` function from another `nonReentrant`
559      * function is not supported. It is possible to prevent this from happening
560      * by making the `nonReentrant` function external, and make it call a
561      * `private` function that does the actual work.
562      */
563     modifier nonReentrant() {
564         _guardCounter += 1;
565         uint256 localCounter = _guardCounter;
566         _;
567         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
568     }
569 }
570 
571 // File: contracts/BankConfig.sol
572 
573 pragma solidity 0.5.16;
574 
575 interface BankConfig {
576     /// @dev Return minimum ETH debt size per position.
577     function minDebtSize() external view returns (uint256);
578 
579     /// @dev Return the interest rate per second, using 1e18 as denom.
580     function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);
581 
582     /// @dev Return the bps rate for reserve pool.
583     function getReservePoolBps() external view returns (uint256);
584 
585     /// @dev Return the bps rate for Avada Kill caster.
586     function getKillBps() external view returns (uint256);
587 
588     /// @dev Return whether the given address is a goblin.
589     function isGoblin(address goblin) external view returns (bool);
590 
591     /// @dev Return whether the given goblin accepts more debt. Revert on non-goblin.
592     function acceptDebt(address goblin) external view returns (bool);
593 
594     /// @dev Return the work factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.
595     function workFactor(address goblin, uint256 debt) external view returns (uint256);
596 
597     /// @dev Return the kill factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.
598     function killFactor(address goblin, uint256 debt) external view returns (uint256);
599 }
600 
601 // File: contracts/Goblin.sol
602 
603 pragma solidity 0.5.16;
604 
605 interface Goblin {
606     /// @dev Work on a (potentially new) position. Optionally send ETH back to Bank.
607     function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;
608 
609     /// @dev Re-invest whatever the goblin is working on.
610     function reinvest() external;
611 
612     /// @dev Return the amount of ETH wei to get back if we are to liquidate the position.
613     function health(uint256 id) external view returns (uint256);
614 
615     /// @dev Liquidate the given position to ETH. Send all ETH back to Bank.
616     function liquidate(uint256 id) external;
617 }
618 
619 // File: contracts/SafeToken.sol
620 
621 pragma solidity 0.5.16;
622 
623 interface ERC20Interface {
624     function balanceOf(address user) external view returns (uint256);
625 }
626 
627 library SafeToken {
628     function myBalance(address token) internal view returns (uint256) {
629         return ERC20Interface(token).balanceOf(address(this));
630     }
631 
632     function balanceOf(address token, address user) internal view returns (uint256) {
633         return ERC20Interface(token).balanceOf(user);
634     }
635 
636     function safeApprove(address token, address to, uint256 value) internal {
637         // bytes4(keccak256(bytes('approve(address,uint256)')));
638         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
639         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
640     }
641 
642     function safeTransfer(address token, address to, uint256 value) internal {
643         // bytes4(keccak256(bytes('transfer(address,uint256)')));
644         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
645         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
646     }
647 
648     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
649         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
650         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
651         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
652     }
653 
654     function safeTransferETH(address to, uint256 value) internal {
655         (bool success, ) = to.call.value(value)(new bytes(0));
656         require(success, "!safeTransferETH");
657     }
658 }
659 
660 // File: contracts/Bank.sol
661 
662 pragma solidity 0.5.16;
663 
664 
665 
666 
667 
668 
669 
670 
671 
672 contract Bank is ERC20, ReentrancyGuard, Ownable {
673     /// @notice Libraries
674     using SafeToken for address;
675     using SafeMath for uint256;
676 
677     /// @notice Events
678     event AddDebt(uint256 indexed id, uint256 debtShare);
679     event RemoveDebt(uint256 indexed id, uint256 debtShare);
680     event Work(uint256 indexed id, uint256 loan);
681     event Kill(uint256 indexed id, address indexed killer, uint256 prize, uint256 left);
682 
683     string public name = "Interest Bearing ETH";
684     string public symbol = "ibETH";
685     uint8 public decimals = 18;
686 
687     struct Position {
688         address goblin;
689         address owner;
690         uint256 debtShare;
691     }
692 
693     BankConfig public config;
694     mapping (uint256 => Position) public positions;
695     uint256 public nextPositionID = 1;
696 
697     uint256 public glbDebtShare;
698     uint256 public glbDebtVal;
699     uint256 public lastAccrueTime;
700     uint256 public reservePool;
701 
702     /// @dev Require that the caller must be an EOA account to avoid flash loans.
703     modifier onlyEOA() {
704         require(msg.sender == tx.origin, "not eoa");
705         _;
706     }
707 
708     /// @dev Add more debt to the global debt pool.
709     modifier accrue(uint256 msgValue) {
710         if (now > lastAccrueTime) {
711             uint256 interest = pendingInterest(msgValue);
712             uint256 toReserve = interest.mul(config.getReservePoolBps()).div(10000);
713             reservePool = reservePool.add(toReserve);
714             glbDebtVal = glbDebtVal.add(interest);
715             lastAccrueTime = now;
716         }
717         _;
718     }
719 
720     constructor(BankConfig _config) public {
721         config = _config;
722         lastAccrueTime = now;
723     }
724 
725     /// @dev Return the pending interest that will be accrued in the next call.
726     /// @param msgValue Balance value to subtract off address(this).balance when called from payable functions.
727     function pendingInterest(uint256 msgValue) public view returns (uint256) {
728         if (now > lastAccrueTime) {
729             uint256 timePast = now.sub(lastAccrueTime);
730             uint256 balance = address(this).balance.sub(msgValue);
731             uint256 ratePerSec = config.getInterestRate(glbDebtVal, balance);
732             return ratePerSec.mul(glbDebtVal).mul(timePast).div(1e18);
733         } else {
734             return 0;
735         }
736     }
737 
738     /// @dev Return the ETH debt value given the debt share. Be careful of unaccrued interests.
739     /// @param debtShare The debt share to be converted.
740     function debtShareToVal(uint256 debtShare) public view returns (uint256) {
741         if (glbDebtShare == 0) return debtShare; // When there's no share, 1 share = 1 val.
742         return debtShare.mul(glbDebtVal).div(glbDebtShare);
743     }
744 
745     /// @dev Return the debt share for the given debt value. Be careful of unaccrued interests.
746     /// @param debtVal The debt value to be converted.
747     function debtValToShare(uint256 debtVal) public view returns (uint256) {
748         if (glbDebtShare == 0) return debtVal; // When there's no share, 1 share = 1 val.
749         return debtVal.mul(glbDebtShare).div(glbDebtVal);
750     }
751 
752     /// @dev Return ETH value and debt of the given position. Be careful of unaccrued interests.
753     /// @param id The position ID to query.
754     function positionInfo(uint256 id) public view returns (uint256, uint256) {
755         Position storage pos = positions[id];
756         return (Goblin(pos.goblin).health(id), debtShareToVal(pos.debtShare));
757     }
758 
759     /// @dev Return the total ETH entitled to the token holders. Be careful of unaccrued interests.
760     function totalETH() public view returns (uint256) {
761         return address(this).balance.add(glbDebtVal).sub(reservePool);
762     }
763 
764     /// @dev Add more ETH to the bank. Hope to get some good returns.
765     function deposit() external payable accrue(msg.value) nonReentrant {
766         uint256 total = totalETH().sub(msg.value);
767         uint256 share = total == 0 ? msg.value : msg.value.mul(totalSupply()).div(total);
768         _mint(msg.sender, share);
769     }
770 
771     /// @dev Withdraw ETH from the bank by burning the share tokens.
772     function withdraw(uint256 share) external accrue(0) nonReentrant {
773         uint256 amount = share.mul(totalETH()).div(totalSupply());
774         _burn(msg.sender, share);
775         SafeToken.safeTransferETH(msg.sender, amount);
776     }
777 
778     /// @dev Create a new farming position to unlock your yield farming potential.
779     /// @param id The ID of the position to unlock the earning. Use ZERO for new position.
780     /// @param goblin The address of the authorized goblin to work for this position.
781     /// @param loan The amount of ETH to borrow from the pool.
782     /// @param maxReturn The max amount of ETH to return to the pool.
783     /// @param data The calldata to pass along to the goblin for more working context.
784     function work(uint256 id, address goblin, uint256 loan, uint256 maxReturn, bytes calldata data)
785         external payable
786         onlyEOA accrue(msg.value) nonReentrant
787     {
788         // 1. Sanity check the input position, or add a new position of ID is 0.
789         if (id == 0) {
790             id = nextPositionID++;
791             positions[id].goblin = goblin;
792             positions[id].owner = msg.sender;
793         } else {
794             require(id < nextPositionID, "bad position id");
795             require(positions[id].goblin == goblin, "bad position goblin");
796             require(positions[id].owner == msg.sender, "not position owner");
797         }
798         emit Work(id, loan);
799         // 2. Make sure the goblin can accept more debt and remove the existing debt.
800         require(config.isGoblin(goblin), "not a goblin");
801         require(loan == 0 || config.acceptDebt(goblin), "goblin not accept more debt");
802         uint256 debt = _removeDebt(id).add(loan);
803         // 3. Perform the actual work, using a new scope to avoid stack-too-deep errors.
804         uint256 back;
805         {
806             uint256 sendETH = msg.value.add(loan);
807             require(sendETH <= address(this).balance, "insufficient ETH in the bank");
808             uint256 beforeETH = address(this).balance.sub(sendETH);
809             Goblin(goblin).work.value(sendETH)(id, msg.sender, debt, data);
810             back = address(this).balance.sub(beforeETH);
811         }
812         // 4. Check and update position debt.
813         uint256 lessDebt = Math.min(debt, Math.min(back, maxReturn));
814         debt = debt.sub(lessDebt);
815         if (debt > 0) {
816             require(debt >= config.minDebtSize(), "too small debt size");
817             uint256 health = Goblin(goblin).health(id);
818             uint256 workFactor = config.workFactor(goblin, debt);
819             require(health.mul(workFactor) >= debt.mul(10000), "bad work factor");
820             _addDebt(id, debt);
821         }
822         // 5. Return excess ETH back.
823         if (back > lessDebt) SafeToken.safeTransferETH(msg.sender, back - lessDebt);
824     }
825 
826     /// @dev Kill the given to the position. Liquidate it immediately if killFactor condition is met.
827     /// @param id The position ID to be killed.
828     function kill(uint256 id) external onlyEOA accrue(0) nonReentrant {
829         // 1. Verify that the position is eligible for liquidation.
830         Position storage pos = positions[id];
831         require(pos.debtShare > 0, "no debt");
832         uint256 debt = _removeDebt(id);
833         uint256 health = Goblin(pos.goblin).health(id);
834         uint256 killFactor = config.killFactor(pos.goblin, debt);
835         require(health.mul(killFactor) < debt.mul(10000), "can't liquidate");
836         // 2. Perform liquidation and compute the amount of ETH received.
837         uint256 beforeETH = address(this).balance;
838         Goblin(pos.goblin).liquidate(id);
839         uint256 back = address(this).balance.sub(beforeETH);
840         uint256 prize = back.mul(config.getKillBps()).div(10000);
841         uint256 rest = back.sub(prize);
842         // 3. Clear position debt and return funds to liquidator and position owner.
843         if (prize > 0) SafeToken.safeTransferETH(msg.sender, prize);
844         uint256 left = rest > debt ? rest - debt : 0;
845         if (left > 0) SafeToken.safeTransferETH(pos.owner, left);
846         emit Kill(id, msg.sender, prize, left);
847     }
848 
849     /// @dev Internal function to add the given debt value to the given position.
850     function _addDebt(uint256 id, uint256 debtVal) internal {
851         Position storage pos = positions[id];
852         uint256 debtShare = debtValToShare(debtVal);
853         pos.debtShare = pos.debtShare.add(debtShare);
854         glbDebtShare = glbDebtShare.add(debtShare);
855         glbDebtVal = glbDebtVal.add(debtVal);
856         emit AddDebt(id, debtShare);
857     }
858 
859     /// @dev Internal function to clear the debt of the given position. Return the debt value.
860     function _removeDebt(uint256 id) internal returns (uint256) {
861         Position storage pos = positions[id];
862         uint256 debtShare = pos.debtShare;
863         if (debtShare > 0) {
864             uint256 debtVal = debtShareToVal(debtShare);
865             pos.debtShare = 0;
866             glbDebtShare = glbDebtShare.sub(debtShare);
867             glbDebtVal = glbDebtVal.sub(debtVal);
868             emit RemoveDebt(id, debtShare);
869             return debtVal;
870         } else {
871             return 0;
872         }
873     }
874 
875     /// @dev Update bank configuration to a new address. Must only be called by owner.
876     /// @param _config The new configurator address.
877     function updateConfig(BankConfig _config) external onlyOwner {
878         config = _config;
879     }
880 
881     /// @dev Withdraw ETH reserve for underwater positions to the given address.
882     /// @param to The address to transfer ETH to.
883     /// @param value The number of ETH tokens to withdraw. Must not exceed `reservePool`.
884     function withdrawReserve(address to, uint256 value) external onlyOwner nonReentrant {
885         reservePool = reservePool.sub(value);
886         SafeToken.safeTransferETH(to, value);
887     }
888 
889     /// @dev Reduce ETH reserve, effectively giving them to the depositors.
890     /// @param value The number of ETH reserve to reduce.
891     function reduceReserve(uint256 value) external onlyOwner {
892         reservePool = reservePool.sub(value);
893     }
894 
895     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
896     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
897     /// @param to The address to send the tokens to.
898     /// @param value The number of tokens to transfer to `to`.
899     function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {
900         token.safeTransfer(to, value);
901     }
902 
903     /// @dev Fallback function to accept ETH. Goblins will send ETH back the pool.
904     function() external payable {}
905 }