1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-07
3 */
4 
5 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Contract module which provides a basic access control mechanism, where
11  * there is an account (an owner) that can be granted exclusive access to
12  * specific functions.
13  *
14  * This module is used through inheritance. It will make available the modifier
15  * `onlyOwner`, which can be aplied to your functions to restrict their use to
16  * the owner.
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor () internal {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(isOwner(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Returns true if the caller is the current owner.
48      */
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     /**
54      * @dev Leaves the contract without owner. It will not be possible to call
55      * `onlyOwner` functions anymore. Can only be called by the current owner.
56      *
57      * > Note: Renouncing ownership will leave the contract without an owner,
58      * thereby removing any functionality that is only available to the owner.
59      */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Can only be called by the current owner.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      */
76     function _transferOwnership(address newOwner) internal {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
84 
85 pragma solidity ^0.5.0;
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
89  * the optional functions; to access them see `ERC20Detailed`.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a `Transfer` event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through `transferFrom`. This is
114      * zero by default.
115      *
116      * This value changes when `approve` or `transferFrom` are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * > Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an `Approval` event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a `Transfer` event.
144      */
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to `approve`. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
163 
164 pragma solidity ^0.5.0;
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b <= a, "SafeMath: subtraction overflow");
207         uint256 c = a - b;
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the multiplication of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `*` operator.
217      *
218      * Requirements:
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
225         if (a == 0) {
226             return 0;
227         }
228 
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Solidity only automatically asserts when dividing by 0
248         require(b > 0, "SafeMath: division by zero");
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         require(b != 0, "SafeMath: modulo by zero");
268         return a % b;
269     }
270 }
271 
272 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20.sol
273 
274 pragma solidity ^0.5.0;
275 
276 
277 
278 /**
279  * @dev Implementation of the `IERC20` interface.
280  *
281  * This implementation is agnostic to the way tokens are created. This means
282  * that a supply mechanism has to be added in a derived contract using `_mint`.
283  * For a generic mechanism see `ERC20Mintable`.
284  *
285  * *For a detailed writeup see our guide [How to implement supply
286  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
287  *
288  * We have followed general OpenZeppelin guidelines: functions revert instead
289  * of returning `false` on failure. This behavior is nonetheless conventional
290  * and does not conflict with the expectations of ERC20 applications.
291  *
292  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
293  * This allows applications to reconstruct the allowance for all accounts just
294  * by listening to said events. Other implementations of the EIP may not emit
295  * these events, as it isn't required by the specification.
296  *
297  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
298  * functions have been added to mitigate the well-known issues around setting
299  * allowances. See `IERC20.approve`.
300  */
301 contract ERC20 is IERC20 {
302     using SafeMath for uint256;
303 
304     mapping (address => uint256) private _balances;
305 
306     mapping (address => mapping (address => uint256)) private _allowances;
307 
308     uint256 private _totalSupply;
309 
310     /**
311      * @dev See `IERC20.totalSupply`.
312      */
313     function totalSupply() public view returns (uint256) {
314         return _totalSupply;
315     }
316 
317     /**
318      * @dev See `IERC20.balanceOf`.
319      */
320     function balanceOf(address account) public view returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See `IERC20.transfer`.
326      *
327      * Requirements:
328      *
329      * - `recipient` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(address recipient, uint256 amount) public returns (bool) {
333         _transfer(msg.sender, recipient, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See `IERC20.allowance`.
339      */
340     function allowance(address owner, address spender) public view returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See `IERC20.approve`.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 value) public returns (bool) {
352         _approve(msg.sender, spender, value);
353         return true;
354     }
355 
356     /**
357      * @dev See `IERC20.transferFrom`.
358      *
359      * Emits an `Approval` event indicating the updated allowance. This is not
360      * required by the EIP. See the note at the beginning of `ERC20`;
361      *
362      * Requirements:
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `value`.
365      * - the caller must have allowance for `sender`'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
369         _transfer(sender, recipient, amount);
370         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to `approve` that can be used as a mitigation for
378      * problems described in `IERC20.approve`.
379      *
380      * Emits an `Approval` event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
387         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to `approve` that can be used as a mitigation for
395      * problems described in `IERC20.approve`.
396      *
397      * Emits an `Approval` event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
406         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
407         return true;
408     }
409 
410     /**
411      * @dev Moves tokens `amount` from `sender` to `recipient`.
412      *
413      * This is internal function is equivalent to `transfer`, and can be used to
414      * e.g. implement automatic token fees, slashing mechanisms, etc.
415      *
416      * Emits a `Transfer` event.
417      *
418      * Requirements:
419      *
420      * - `sender` cannot be the zero address.
421      * - `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      */
424     function _transfer(address sender, address recipient, uint256 amount) internal {
425         require(sender != address(0), "ERC20: transfer from the zero address");
426         require(recipient != address(0), "ERC20: transfer to the zero address");
427 
428         _balances[sender] = _balances[sender].sub(amount);
429         _balances[recipient] = _balances[recipient].add(amount);
430         emit Transfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a `Transfer` event with `from` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `to` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _totalSupply = _totalSupply.add(amount);
446         _balances[account] = _balances[account].add(amount);
447         emit Transfer(address(0), account, amount);
448     }
449 
450      /**
451      * @dev Destoys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a `Transfer` event with `to` set to the zero address.
455      *
456      * Requirements
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 value) internal {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _totalSupply = _totalSupply.sub(value);
465         _balances[account] = _balances[account].sub(value);
466         emit Transfer(account, address(0), value);
467     }
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
471      *
472      * This is internal function is equivalent to `approve`, and can be used to
473      * e.g. set automatic allowances for certain subsystems, etc.
474      *
475      * Emits an `Approval` event.
476      *
477      * Requirements:
478      *
479      * - `owner` cannot be the zero address.
480      * - `spender` cannot be the zero address.
481      */
482     function _approve(address owner, address spender, uint256 value) internal {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485 
486         _allowances[owner][spender] = value;
487         emit Approval(owner, spender, value);
488     }
489 
490     /**
491      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
492      * from the caller's allowance.
493      *
494      * See `_burn` and `_approve`.
495      */
496     function _burnFrom(address account, uint256 amount) internal {
497         _burn(account, amount);
498         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
499     }
500 }
501 
502 // File: openzeppelin-solidity-2.3.0/contracts/math/Math.sol
503 
504 pragma solidity ^0.5.0;
505 
506 /**
507  * @dev Standard math utilities missing in the Solidity language.
508  */
509 library Math {
510     /**
511      * @dev Returns the largest of two numbers.
512      */
513     function max(uint256 a, uint256 b) internal pure returns (uint256) {
514         return a >= b ? a : b;
515     }
516 
517     /**
518      * @dev Returns the smallest of two numbers.
519      */
520     function min(uint256 a, uint256 b) internal pure returns (uint256) {
521         return a < b ? a : b;
522     }
523 
524     /**
525      * @dev Returns the average of two numbers. The result is rounded towards
526      * zero.
527      */
528     function average(uint256 a, uint256 b) internal pure returns (uint256) {
529         // (a + b) / 2 can overflow, so we distribute
530         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
531     }
532 }
533 
534 // File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol
535 
536 pragma solidity ^0.5.0;
537 
538 /**
539  * @dev Contract module that helps prevent reentrant calls to a function.
540  *
541  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
542  * available, which can be aplied to functions to make sure there are no nested
543  * (reentrant) calls to them.
544  *
545  * Note that because there is a single `nonReentrant` guard, functions marked as
546  * `nonReentrant` may not call one another. This can be worked around by making
547  * those functions `private`, and then adding `external` `nonReentrant` entry
548  * points to them.
549  */
550 contract ReentrancyGuard {
551     /// @dev counter to allow mutex lock with only one SSTORE operation
552     uint256 private _guardCounter;
553 
554     constructor () internal {
555         // The counter starts at one to prevent changing it from zero to a non-zero
556         // value, which is a more expensive operation.
557         _guardCounter = 1;
558     }
559 
560     /**
561      * @dev Prevents a contract from calling itself, directly or indirectly.
562      * Calling a `nonReentrant` function from another `nonReentrant`
563      * function is not supported. It is possible to prevent this from happening
564      * by making the `nonReentrant` function external, and make it call a
565      * `private` function that does the actual work.
566      */
567     modifier nonReentrant() {
568         _guardCounter += 1;
569         uint256 localCounter = _guardCounter;
570         _;
571         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
572     }
573 }
574 
575 // File: contracts/BankConfig.sol
576 
577 pragma solidity 0.5.16;
578 
579 interface BankConfig {
580     /// @dev Return minimum ETH debt size per position.
581     function minDebtSize() external view returns (uint256);
582 
583     /// @dev Return the interest rate per second, using 1e18 as denom.
584     function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);
585 
586     /// @dev Return the bps rate for reserve pool.
587     function getReservePoolBps() external view returns (uint256);
588 
589     /// @dev Return the bps rate for Avada Kill caster.
590     function getKillBps() external view returns (uint256);
591 
592     /// @dev Return whether the given address is a goblin.
593     function isGoblin(address goblin) external view returns (bool);
594 
595     /// @dev Return whether the given goblin accepts more debt. Revert on non-goblin.
596     function acceptDebt(address goblin) external view returns (bool);
597 
598     /// @dev Return the work factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.
599     function workFactor(address goblin, uint256 debt) external view returns (uint256);
600 
601     /// @dev Return the kill factor for the goblin + ETH debt, using 1e4 as denom. Revert on non-goblin.
602     function killFactor(address goblin, uint256 debt) external view returns (uint256);
603 }
604 
605 // File: contracts/Goblin.sol
606 
607 pragma solidity 0.5.16;
608 
609 interface Goblin {
610     /// @dev Work on a (potentially new) position. Optionally send ETH back to Bank.
611     function work(uint256 id, address user, uint256 debt, bytes calldata data) external payable;
612 
613     /// @dev Re-invest whatever the goblin is working on.
614     function reinvest() external;
615 
616     /// @dev Return the amount of ETH wei to get back if we are to liquidate the position.
617     function health(uint256 id) external view returns (uint256);
618 
619     /// @dev Liquidate the given position to ETH. Send all ETH back to Bank.
620     function liquidate(uint256 id) external;
621 }
622 
623 // File: contracts/SafeToken.sol
624 
625 pragma solidity 0.5.16;
626 
627 interface ERC20Interface {
628     function balanceOf(address user) external view returns (uint256);
629 }
630 
631 library SafeToken {
632     function myBalance(address token) internal view returns (uint256) {
633         return ERC20Interface(token).balanceOf(address(this));
634     }
635 
636     function balanceOf(address token, address user) internal view returns (uint256) {
637         return ERC20Interface(token).balanceOf(user);
638     }
639 
640     function safeApprove(address token, address to, uint256 value) internal {
641         // bytes4(keccak256(bytes('approve(address,uint256)')));
642         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
643         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
644     }
645 
646     function safeTransfer(address token, address to, uint256 value) internal {
647         // bytes4(keccak256(bytes('transfer(address,uint256)')));
648         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
649         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
650     }
651 
652     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
653         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
654         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
655         require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
656     }
657 
658     function safeTransferETH(address to, uint256 value) internal {
659         (bool success, ) = to.call.value(value)(new bytes(0));
660         require(success, "!safeTransferETH");
661     }
662 }
663 
664 // File: contracts/Bank.sol
665 
666 pragma solidity 0.5.16;
667 
668 
669 
670 
671 
672 
673 
674 
675 
676 contract Bank is ERC20, ReentrancyGuard, Ownable {
677     /// @notice Libraries
678     using SafeToken for address;
679     using SafeMath for uint256;
680 
681     /// @notice Events
682     event AddDebt(uint256 indexed id, uint256 debtShare);
683     event RemoveDebt(uint256 indexed id, uint256 debtShare);
684     event Work(uint256 indexed id, uint256 loan);
685     event Kill(uint256 indexed id, address indexed killer, uint256 prize, uint256 left);
686 
687     string public name = "Interest Bearing ETH";
688     string public symbol = "ibETH";
689     uint8 public decimals = 18;
690 
691     struct Position {
692         address goblin;
693         address owner;
694         uint256 debtShare;
695     }
696 
697     BankConfig public config;
698     mapping (uint256 => Position) public positions;
699     uint256 public nextPositionID = 1;
700 
701     uint256 public glbDebtShare;
702     uint256 public glbDebtVal;
703     uint256 public lastAccrueTime;
704     uint256 public reservePool;
705 
706     /// @dev Require that the caller must be an EOA account to avoid flash loans.
707     modifier onlyEOA() {
708         require(msg.sender == tx.origin, "not eoa");
709         _;
710     }
711 
712     /// @dev Add more debt to the global debt pool.
713     modifier accrue(uint256 msgValue) {
714         if (now > lastAccrueTime) {
715             uint256 interest = pendingInterest(msgValue);
716             uint256 toReserve = interest.mul(config.getReservePoolBps()).div(10000);
717             reservePool = reservePool.add(toReserve);
718             glbDebtVal = glbDebtVal.add(interest);
719             lastAccrueTime = now;
720         }
721         _;
722     }
723 
724     constructor(BankConfig _config) public {
725         config = _config;
726         lastAccrueTime = now;
727     }
728 
729     /// @dev Return the pending interest that will be accrued in the next call.
730     /// @param msgValue Balance value to subtract off address(this).balance when called from payable functions.
731     function pendingInterest(uint256 msgValue) public view returns (uint256) {
732         if (now > lastAccrueTime) {
733             uint256 timePast = now.sub(lastAccrueTime);
734             uint256 balance = address(this).balance.sub(msgValue);
735             uint256 ratePerSec = config.getInterestRate(glbDebtVal, balance);
736             return ratePerSec.mul(glbDebtVal).mul(timePast).div(1e18);
737         } else {
738             return 0;
739         }
740     }
741 
742     /// @dev Return the ETH debt value given the debt share. Be careful of unaccrued interests.
743     /// @param debtShare The debt share to be converted.
744     function debtShareToVal(uint256 debtShare) public view returns (uint256) {
745         if (glbDebtShare == 0) return debtShare; // When there's no share, 1 share = 1 val.
746         return debtShare.mul(glbDebtVal).div(glbDebtShare);
747     }
748 
749     /// @dev Return the debt share for the given debt value. Be careful of unaccrued interests.
750     /// @param debtVal The debt value to be converted.
751     function debtValToShare(uint256 debtVal) public view returns (uint256) {
752         if (glbDebtShare == 0) return debtVal; // When there's no share, 1 share = 1 val.
753         return debtVal.mul(glbDebtShare).div(glbDebtVal);
754     }
755 
756     /// @dev Return ETH value and debt of the given position. Be careful of unaccrued interests.
757     /// @param id The position ID to query.
758     function positionInfo(uint256 id) public view returns (uint256, uint256) {
759         Position storage pos = positions[id];
760         return (Goblin(pos.goblin).health(id), debtShareToVal(pos.debtShare));
761     }
762 
763     /// @dev Return the total ETH entitled to the token holders. Be careful of unaccrued interests.
764     function totalETH() public view returns (uint256) {
765         return address(this).balance.add(glbDebtVal).sub(reservePool);
766     }
767 
768     /// @dev Add more ETH to the bank. Hope to get some good returns.
769     function deposit() external payable accrue(msg.value) nonReentrant {
770         uint256 total = totalETH().sub(msg.value);
771         uint256 share = total == 0 ? msg.value : msg.value.mul(totalSupply()).div(total);
772         _mint(msg.sender, share);
773     }
774 
775     /// @dev Withdraw ETH from the bank by burning the share tokens.
776     function withdraw(uint256 share) external accrue(0) nonReentrant {
777         uint256 amount = share.mul(totalETH()).div(totalSupply());
778         _burn(msg.sender, share);
779         SafeToken.safeTransferETH(msg.sender, amount);
780     }
781 
782     /// @dev Create a new farming position to unlock your yield farming potential.
783     /// @param id The ID of the position to unlock the earning. Use ZERO for new position.
784     /// @param goblin The address of the authorized goblin to work for this position.
785     /// @param loan The amount of ETH to borrow from the pool.
786     /// @param maxReturn The max amount of ETH to return to the pool.
787     /// @param data The calldata to pass along to the goblin for more working context.
788     function work(uint256 id, address goblin, uint256 loan, uint256 maxReturn, bytes calldata data)
789         external payable{
790         // 1. Sanity check the input position, or add a new position of ID is 0.
791         if (id == 0) {
792             id = nextPositionID++;
793             positions[id].goblin = goblin;
794             positions[id].owner = msg.sender;
795         } else {
796             require(id < nextPositionID, "bad position id");
797             require(positions[id].goblin == goblin, "bad position goblin");
798             require(positions[id].owner == msg.sender, "not position owner");
799         }
800         emit Work(id, loan);
801         // 2. Make sure the goblin can accept more debt and remove the existing debt.
802         require(config.isGoblin(goblin), "not a goblin");
803         require(loan == 0 || config.acceptDebt(goblin), "goblin not accept more debt");
804         uint256 debt = _removeDebt(id).add(loan);
805         // 3. Perform the actual work, using a new scope to avoid stack-too-deep errors.
806         uint256 back;
807         {
808             uint256 sendETH = msg.value.add(loan);
809             require(sendETH <= address(this).balance, "insufficient ETH in the bank");
810             uint256 beforeETH = address(this).balance.sub(sendETH);
811             Goblin(goblin).work.value(sendETH)(id, msg.sender, debt, data);
812             back = address(this).balance.sub(beforeETH);
813         }
814         // 4. Check and update position debt.
815         uint256 lessDebt = Math.min(debt, Math.min(back, maxReturn));
816         debt = debt.sub(lessDebt);
817         if (debt > 0) {
818             require(debt >= config.minDebtSize(), "too small debt size");
819             uint256 health = Goblin(goblin).health(id);
820             uint256 workFactor = config.workFactor(goblin, debt);
821             require(health.mul(workFactor) >= debt.mul(10000), "bad work factor");
822             _addDebt(id, debt);
823         }
824         // 5. Return excess ETH back.
825         if (back > lessDebt) SafeToken.safeTransferETH(msg.sender, back - lessDebt);
826     }
827 
828     /// @dev Kill the given to the position. Liquidate it immediately if killFactor condition is met.
829     /// @param id The position ID to be killed.
830     function kill(uint256 id) external onlyEOA accrue(0) nonReentrant {
831         // 1. Verify that the position is eligible for liquidation.
832         Position storage pos = positions[id];
833         require(pos.debtShare > 0, "no debt");
834         uint256 debt = _removeDebt(id);
835         uint256 health = Goblin(pos.goblin).health(id);
836         uint256 killFactor = config.killFactor(pos.goblin, debt);
837         require(health.mul(killFactor) < debt.mul(10000), "can't liquidate");
838         // 2. Perform liquidation and compute the amount of ETH received.
839         uint256 beforeETH = address(this).balance;
840         Goblin(pos.goblin).liquidate(id);
841         uint256 back = address(this).balance.sub(beforeETH);
842         uint256 prize = back.mul(config.getKillBps()).div(10000);
843         uint256 rest = back.sub(prize);
844         // 3. Clear position debt and return funds to liquidator and position owner.
845         if (prize > 0) SafeToken.safeTransferETH(msg.sender, prize);
846         uint256 left = rest > debt ? rest - debt : 0;
847         if (left > 0) SafeToken.safeTransferETH(pos.owner, left);
848         emit Kill(id, msg.sender, prize, left);
849     }
850 
851     /// @dev Internal function to add the given debt value to the given position.
852     function _addDebt(uint256 id, uint256 debtVal) internal {
853         Position storage pos = positions[id];
854         uint256 debtShare = debtValToShare(debtVal);
855         pos.debtShare = pos.debtShare.add(debtShare);
856         glbDebtShare = glbDebtShare.add(debtShare);
857         glbDebtVal = glbDebtVal.add(debtVal);
858         emit AddDebt(id, debtShare);
859     }
860 
861     /// @dev Internal function to clear the debt of the given position. Return the debt value.
862     function _removeDebt(uint256 id) internal returns (uint256) {
863         Position storage pos = positions[id];
864         uint256 debtShare = pos.debtShare;
865         if (debtShare > 0) {
866             uint256 debtVal = debtShareToVal(debtShare);
867             pos.debtShare = 0;
868             glbDebtShare = glbDebtShare.sub(debtShare);
869             glbDebtVal = glbDebtVal.sub(debtVal);
870             emit RemoveDebt(id, debtShare);
871             return debtVal;
872         } else {
873             return 0;
874         }
875     }
876 
877     /// @dev Update bank configuration to a new address. Must only be called by owner.
878     /// @param _config The new configurator address.
879     function updateConfig(BankConfig _config) external onlyOwner {
880         config = _config;
881     }
882 
883     /// @dev Withdraw ETH reserve for underwater positions to the given address.
884     /// @param to The address to transfer ETH to.
885     /// @param value The number of ETH tokens to withdraw. Must not exceed `reservePool`.
886     function withdrawReserve(address to, uint256 value) external onlyOwner nonReentrant {
887         reservePool = reservePool.sub(value);
888         SafeToken.safeTransferETH(to, value);
889     }
890 
891     /// @dev Reduce ETH reserve, effectively giving them to the depositors.
892     /// @param value The number of ETH reserve to reduce.
893     function reduceReserve(uint256 value) external onlyOwner {
894         reservePool = reservePool.sub(value);
895     }
896 
897     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
898     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
899     /// @param to The address to send the tokens to.
900     /// @param value The number of tokens to transfer to `to`.
901     function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {
902         token.safeTransfer(to, value);
903     }
904 
905     /// @dev Fallback function to accept ETH. Goblins will send ETH back the pool.
906     function() external payable {}
907 }