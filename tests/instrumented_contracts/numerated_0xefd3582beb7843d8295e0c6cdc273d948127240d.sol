1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /*
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with GSN meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address payable) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes memory) {
102         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/Ownable.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () internal {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 
179 pragma solidity >=0.6.0 <0.8.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, with an overflow flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         uint256 c = a + b;
202         if (c < a) return (false, 0);
203         return (true, c);
204     }
205 
206     /**
207      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         if (b > a) return (false, 0);
213         return (true, a - b);
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225         if (a == 0) return (true, 0);
226         uint256 c = a * b;
227         if (c / a != b) return (false, 0);
228         return (true, c);
229     }
230 
231     /**
232      * @dev Returns the division of two unsigned integers, with a division by zero flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         if (b == 0) return (false, 0);
238         return (true, a / b);
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
243      *
244      * _Available since v3.4._
245      */
246     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         if (b == 0) return (false, 0);
248         return (true, a % b);
249     }
250 
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      *
259      * - Addition cannot overflow.
260      */
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a + b;
263         require(c >= a, "SafeMath: addition overflow");
264         return c;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting on
269      * overflow (when the result is negative).
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      *
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         require(b <= a, "SafeMath: subtraction overflow");
279         return a - b;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      *
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         if (a == 0) return 0;
294         uint256 c = a * b;
295         require(c / a == b, "SafeMath: multiplication overflow");
296         return c;
297     }
298 
299     /**
300      * @dev Returns the integer division of two unsigned integers, reverting on
301      * division by zero. The result is rounded towards zero.
302      *
303      * Counterpart to Solidity's `/` operator. Note: this function uses a
304      * `revert` opcode (which leaves remaining gas untouched) while Solidity
305      * uses an invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         require(b > 0, "SafeMath: division by zero");
313         return a / b;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         require(b > 0, "SafeMath: modulo by zero");
330         return a % b;
331     }
332 
333     /**
334      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
335      * overflow (when the result is negative).
336      *
337      * CAUTION: This function is deprecated because it requires allocating memory for the error
338      * message unnecessarily. For custom revert reasons use {trySub}.
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
347         require(b <= a, errorMessage);
348         return a - b;
349     }
350 
351     /**
352      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
353      * division by zero. The result is rounded towards zero.
354      *
355      * CAUTION: This function is deprecated because it requires allocating memory for the error
356      * message unnecessarily. For custom revert reasons use {tryDiv}.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b > 0, errorMessage);
368         return a / b;
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * reverting with custom message when dividing by zero.
374      *
375      * CAUTION: This function is deprecated because it requires allocating memory for the error
376      * message unnecessarily. For custom revert reasons use {tryMod}.
377      *
378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
379      * opcode (which leaves remaining gas untouched) while Solidity uses an
380      * invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         return a % b;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/Pausable.sol
393 
394 
395 pragma solidity >=0.6.0 <0.8.0;
396 
397 
398 /**
399  * @dev Contract module which allows children to implement an emergency stop
400  * mechanism that can be triggered by an authorized account.
401  *
402  * This module is used through inheritance. It will make available the
403  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
404  * the functions of your contract. Note that they will not be pausable by
405  * simply including this module, only once the modifiers are put in place.
406  */
407 abstract contract Pausable is Context {
408     /**
409      * @dev Emitted when the pause is triggered by `account`.
410      */
411     event Paused(address account);
412 
413     /**
414      * @dev Emitted when the pause is lifted by `account`.
415      */
416     event Unpaused(address account);
417 
418     bool private _paused;
419 
420     /**
421      * @dev Initializes the contract in unpaused state.
422      */
423     constructor () internal {
424         _paused = false;
425     }
426 
427     /**
428      * @dev Returns true if the contract is paused, and false otherwise.
429      */
430     function paused() public view virtual returns (bool) {
431         return _paused;
432     }
433 
434     /**
435      * @dev Modifier to make a function callable only when the contract is not paused.
436      *
437      * Requirements:
438      *
439      * - The contract must not be paused.
440      */
441     modifier whenNotPaused() {
442         require(!paused(), "Pausable: paused");
443         _;
444     }
445 
446     /**
447      * @dev Modifier to make a function callable only when the contract is paused.
448      *
449      * Requirements:
450      *
451      * - The contract must be paused.
452      */
453     modifier whenPaused() {
454         require(paused(), "Pausable: not paused");
455         _;
456     }
457 
458     /**
459      * @dev Triggers stopped state.
460      *
461      * Requirements:
462      *
463      * - The contract must not be paused.
464      */
465     function _pause() internal virtual whenNotPaused {
466         _paused = true;
467         emit Paused(_msgSender());
468     }
469 
470     /**
471      * @dev Returns to normal state.
472      *
473      * Requirements:
474      *
475      * - The contract must be paused.
476      */
477     function _unpause() internal virtual whenPaused {
478         _paused = false;
479         emit Unpaused(_msgSender());
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
484 
485 
486 pragma solidity >=0.6.0 <0.8.0;
487 
488 /**
489  * @dev Contract module that helps prevent reentrant calls to a function.
490  *
491  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
492  * available, which can be applied to functions to make sure there are no nested
493  * (reentrant) calls to them.
494  *
495  * Note that because there is a single `nonReentrant` guard, functions marked as
496  * `nonReentrant` may not call one another. This can be worked around by making
497  * those functions `private`, and then adding `external` `nonReentrant` entry
498  * points to them.
499  *
500  * TIP: If you would like to learn more about reentrancy and alternative ways
501  * to protect against it, check out our blog post
502  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
503  */
504 abstract contract ReentrancyGuard {
505     // Booleans are more expensive than uint256 or any type that takes up a full
506     // word because each write operation emits an extra SLOAD to first read the
507     // slot's contents, replace the bits taken up by the boolean, and then write
508     // back. This is the compiler's defense against contract upgrades and
509     // pointer aliasing, and it cannot be disabled.
510 
511     // The values being non-zero value makes deployment a bit more expensive,
512     // but in exchange the refund on every call to nonReentrant will be lower in
513     // amount. Since refunds are capped to a percentage of the total
514     // transaction's gas, it is best to keep them low in cases like this one, to
515     // increase the likelihood of the full refund coming into effect.
516     uint256 private constant _NOT_ENTERED = 1;
517     uint256 private constant _ENTERED = 2;
518 
519     uint256 private _status;
520 
521     constructor () internal {
522         _status = _NOT_ENTERED;
523     }
524 
525     /**
526      * @dev Prevents a contract from calling itself, directly or indirectly.
527      * Calling a `nonReentrant` function from another `nonReentrant`
528      * function is not supported. It is possible to prevent this from happening
529      * by making the `nonReentrant` function external, and make it call a
530      * `private` function that does the actual work.
531      */
532     modifier nonReentrant() {
533         // On the first call to nonReentrant, _notEntered will be true
534         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
535 
536         // Any calls to nonReentrant after this point will fail
537         _status = _ENTERED;
538 
539         _;
540 
541         // By storing the original value once again, a refund is triggered (see
542         // https://eips.ethereum.org/EIPS/eip-2200)
543         _status = _NOT_ENTERED;
544     }
545 }
546 
547 // File: contracts/TimeLockedTokenDistribute.sol
548 
549 pragma solidity ^0.6.0;
550 
551 
552 
553 
554 
555 
556 contract TimeLockedTokenDistribute is Ownable, ReentrancyGuard, Pausable {
557     using SafeMath for uint256;
558 
559     // represents total distribution for locked balances
560     mapping(address => uint256) public distribution;
561 
562     // represents first unlock
563     mapping(address => uint256) public firstunlock;
564 
565     // blocklist
566     mapping(address => uint8) public blocklist;
567 
568     // Token Address
569     IERC20 token;
570 
571     // Claimed Token
572     mapping(address => uint256) public ClaimedBalances;
573 
574     // start of the lockup period
575     // Wednesday, April 21, 2021 02:00:00 AM UTC +0
576     // uint256 constant LOCK_START = 1618970400;
577     uint256 constant LOCK_START = 1620784800;
578     // length of time to delay first epoch
579     // uint256 constant FIRST_EPOCH_DELAY = 21 days;
580     uint256 constant FIRST_EPOCH_DELAY = 9 days;
581     // how long does an epoch last
582     uint256 constant EPOCH_DURATION = 1 days;
583     // number of epochs
584     uint256 constant TOTAL_EPOCHS = 365;
585 
586     // // Friday, July 24, 2021 4:58:31 PM GMT
587     // uint256 constant LOCK_START = 1618840800;
588     // // length of time to delay first epoch
589     // uint256 constant FIRST_EPOCH_DELAY = 0 minutes;
590     // // how long does an epoch last
591     // uint256 constant EPOCH_DURATION = 5 minutes;
592     // // number of epochs
593     // uint256 constant TOTAL_EPOCHS = 20000;
594 
595     // registry of locked addresses
596     address public timeLockRegistry;
597 
598     modifier onlyTimeLockRegistry() {
599         require(msg.sender == timeLockRegistry, "only TimeLockRegistry");
600         _;
601     }
602 
603     constructor(address _TimeLockRegistry, IERC20 _token) public {
604         require(_TimeLockRegistry != address(0), "cannot be zero address");
605 
606         token = _token;
607         timeLockRegistry = _TimeLockRegistry;
608     }
609 
610     function setToken(IERC20 _token) external onlyOwner {
611         require(address(token) != address(0), "cannot be zero address");
612         require(_token != token, "must be new token");
613         token = _token;
614     }
615 
616     function setTimeLockRegistry(address newTimeLockRegistry)
617         external
618         onlyOwner
619     {
620         require(newTimeLockRegistry != address(0), "cannot be zero address");
621         require(
622             newTimeLockRegistry != timeLockRegistry,
623             "must be new TimeLockRegistry"
624         );
625         timeLockRegistry = newTimeLockRegistry;
626     }
627 
628     function claim() public nonReentrant() whenNotPaused() {
629         require(blocklist[msg.sender] == 0, "Sender has been blocked!");
630         uint256 tokenCanClaimed =
631             unlockedBalance(msg.sender).sub(ClaimedBalances[msg.sender]);
632         require(tokenCanClaimed > 0, "Sender has 0 unclaimed tokens");
633         //Log
634         ClaimedBalances[msg.sender] = unlockedBalance(msg.sender);
635         require(
636             token.balanceOf(address(this)) >= tokenCanClaimed,
637             "insufficient balance"
638         );
639         token.transfer(msg.sender, tokenCanClaimed);
640     }
641 
642     function registerLockupByArr(
643         address[] memory _receivers,
644         uint256[] memory _amounts,
645         uint256[] memory _unlocks
646     ) external onlyTimeLockRegistry {
647         uint256 totalAmount;
648         for (uint256 i = 0; i < _receivers.length; i++) {
649             require(distribution[_receivers[i]] == 0, "Only add once.");
650             require(firstunlock[_receivers[i]] == 0, "Only add once.");
651             require(_unlocks[i] <= _amounts[i], "invalid first unlock amount.");
652 
653             // add amount to locked distribution
654             distribution[_receivers[i]] = distribution[_receivers[i]].add(
655                 _amounts[i]
656             );
657 
658             // add firstunlock
659             firstunlock[_receivers[i]] = firstunlock[_receivers[i]].add(
660                 _unlocks[i]
661             );
662 
663             totalAmount = totalAmount.add(_amounts[i]);
664         }
665 
666         // transfer to LockContract
667         // require(
668         //     token.balanceOf(msg.sender) >= totalAmount,
669         //     "insufficient balance"
670         // );
671         // token.transferFrom(msg.sender, address(this), totalAmount);
672     }
673 
674     /**
675      * @dev Transfer tokens to another account under the lockup schedule
676      * Emits a transfer event showing a transfer to the recipient
677      * Only the registry can call this function
678      * @param receiver Address to receive the tokens
679      * @param amount Tokens to be transferred
680      */
681     function registerLockup(
682         address receiver,
683         uint256 amount,
684         uint256 unlock
685     ) external onlyTimeLockRegistry {
686         require(token.balanceOf(msg.sender) >= amount, "insufficient balance");
687 
688         require(distribution[receiver] == 0, "Only add once.");
689         require(firstunlock[receiver] == 0, "Only add once.");
690         require(unlock <= amount, "invalid first unlock amount.");
691 
692         // add amount to locked distribution
693         distribution[receiver] = distribution[receiver].add(amount);
694 
695         // add firstunlock
696         firstunlock[receiver] = firstunlock[receiver].add(unlock);
697 
698         // transfer to LockContract
699         // token.transferFrom(msg.sender, address(this), amount);
700     }
701 
702     function deposit(uint256 amount) external onlyTimeLockRegistry {
703         require(token.balanceOf(msg.sender) >= amount, "insufficient balance");
704         // transfer to LockContract
705         token.transferFrom(msg.sender, address(this), amount);
706     }
707 
708     function withdraw(address receiver, uint256 amount)
709         external
710         onlyTimeLockRegistry
711     {
712         require(
713             token.balanceOf(address(this)) >= amount,
714             "insufficient balance"
715         );
716         token.transfer(receiver, amount);
717     }
718 
719     function balance() public view returns (uint256) {
720         return token.balanceOf(address(this));
721     }
722 
723     function cleanDistribution(address account) external onlyTimeLockRegistry {
724         distribution[account] = 0;
725     }
726 
727     function cleanFirstUnlock(address account) external onlyTimeLockRegistry {
728         firstunlock[account] = 0;
729     }
730 
731     function addToBlockList(address account) external onlyTimeLockRegistry {
732         blocklist[account] = 1;
733     }
734 
735     function removeFromBlockList(address account)
736         external
737         onlyTimeLockRegistry
738     {
739         blocklist[account] = 0;
740     }
741 
742     function lockedBalance(address account) public view returns (uint256) {
743         // distribution * 0.7 * (epochsLeft / totalEpochs)
744         // return distribution[account].mul(100 - FIRST_UNLOCK).div(100).mul(epochsLeft()).div(TOTAL_EPOCHS);
745 
746         // (distribution - firstunlock) * (epochsLeft / totalEpochs)
747         return
748             distribution[account]
749                 .sub(firstunlock[account])
750                 .mul(epochsLeft())
751                 .div(TOTAL_EPOCHS);
752     }
753 
754     function unlockedBalance(address account) public view returns (uint256) {
755         // totalBalance - lockedBalance
756         return distribution[account].sub(lockedBalance(account));
757     }
758 
759     function claimedBalance(address account) public view returns (uint256) {
760         return ClaimedBalances[account];
761     }
762 
763     function epochsPassed() public view returns (uint256) {
764         // return 0 if timestamp is lower than start time
765         if (block.timestamp < LOCK_START) {
766             return 0;
767         }
768 
769         // how long it has been since the beginning of lockup period
770         uint256 timePassed = block.timestamp.sub(LOCK_START);
771 
772         // 1st epoch is FIRST_EPOCH_DELAY longer; we check to prevent subtraction underflow
773         if (timePassed < FIRST_EPOCH_DELAY) {
774             return 0;
775         }
776 
777         // subtract the FIRST_EPOCH_DELAY, so that we can count all epochs as lasting EPOCH_DURATION
778         uint256 totalEpochsPassed =
779             timePassed.sub(FIRST_EPOCH_DELAY).div(EPOCH_DURATION);
780 
781         // epochs don't count over TOTAL_EPOCHS
782         if (totalEpochsPassed > TOTAL_EPOCHS) {
783             return TOTAL_EPOCHS;
784         }
785 
786         return totalEpochsPassed;
787     }
788 
789     function epochsLeft() public view returns (uint256) {
790         return TOTAL_EPOCHS.sub(epochsPassed());
791     }
792 
793     function nextEpoch() public view returns (uint256) {
794         // get number of epochs passed
795         uint256 passed = epochsPassed();
796 
797         // if all epochs passed, return
798         if (passed == TOTAL_EPOCHS) {
799             // return INT_MAX
800             return uint256(-1);
801         }
802 
803         // if no epochs passed, return latest epoch + delay + standard duration
804         if (passed == 0) {
805             return latestEpoch().add(FIRST_EPOCH_DELAY).add(EPOCH_DURATION);
806         }
807 
808         // otherwise return latest epoch + epoch duration
809         return latestEpoch().add(EPOCH_DURATION);
810     }
811 
812     function latestEpoch() public view returns (uint256) {
813         // get number of epochs passed
814         uint256 passed = epochsPassed();
815 
816         // if no epochs passed, return lock start time
817         if (passed == 0) {
818             return LOCK_START;
819         }
820 
821         // accounts for first epoch being longer
822         // lockStart + firstEpochDelay + (epochsPassed * epochDuration)
823         return
824             LOCK_START.add(FIRST_EPOCH_DELAY).add(passed.mul(EPOCH_DURATION));
825     }
826 
827     function finalEpoch() public pure returns (uint256) {
828         // lockStart + firstEpochDelay + (epochDuration * totalEpochs)
829         return
830             LOCK_START.add(FIRST_EPOCH_DELAY).add(
831                 EPOCH_DURATION.mul(TOTAL_EPOCHS)
832             );
833     }
834 
835     function lockStart() public pure returns (uint256) {
836         return LOCK_START;
837     }
838 }