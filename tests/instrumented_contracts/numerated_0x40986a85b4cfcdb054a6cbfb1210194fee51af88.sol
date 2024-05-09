1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File contracts/interfaces/IERC20.sol
4 
5 // SPDX-License-Identifier: MIT;
6 
7 pragma solidity ^0.7.6;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13   /**
14    * @dev Returns the amount of tokens in existence.
15    */
16   function totalSupply() external view returns (uint256);
17 
18   /**
19    * @dev Returns the amount of tokens owned by `account`.
20    */
21   function balanceOf(address account) external view returns (uint256);
22 
23   /**
24    * @dev Moves `amount` tokens from the caller's account to `recipient`.
25    *
26    * Returns a boolean value indicating whether the operation succeeded.
27    *
28    * Emits a {Transfer} event.
29    */
30   function transfer(address recipient, uint256 amount) external returns (bool);
31 
32   /**
33    * @dev Returns the remaining number of tokens that `spender` will be
34    * allowed to spend on behalf of `owner` through {transferFrom}. This is
35    * zero by default.
36    *
37    * This value changes when {approve} or {transferFrom} are called.
38    */
39   function allowance(address owner, address spender) external view returns (uint256);
40 
41   /**
42    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43    *
44    * Returns a boolean value indicating whether the operation succeeded.
45    *
46    * IMPORTANT: Beware that changing an allowance with this method brings the risk
47    * that someone may use both the old and the new allowance by unfortunate
48    * transaction ordering. One possible solution to mitigate this race
49    * condition is to first reduce the spender's allowance to 0 and set the
50    * desired value afterwards:
51    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52    *
53    * Emits an {Approval} event.
54    */
55   function approve(address spender, uint256 amount) external returns (bool);
56 
57   /**
58    * @dev Moves `amount` tokens from `sender` to `recipient` using the
59    * allowance mechanism. `amount` is then deducted from the caller's
60    * allowance.
61    *
62    * Returns a boolean value indicating whether the operation succeeded.
63    *
64    * Emits a {Transfer} event.
65    */
66   function transferFrom(
67     address sender,
68     address recipient,
69     uint256 amount
70   ) external returns (bool);
71 
72   /**
73    * @dev Emitted when `value` tokens are moved from one account (`from`) to
74    * another (`to`).
75    *
76    * Note that `value` may be zero.
77    */
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 
80   /**
81    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82    * a call to {approve}. `value` is the new allowance.
83    */
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File contracts/libraries/SafeMath.sol
88 
89 pragma solidity ^0.7.6;
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105   /**
106    * @dev Returns the addition of two unsigned integers, with an overflow flag.
107    *
108    * _Available since v3.4._
109    */
110   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111     uint256 c = a + b;
112     if (c < a) return (false, 0);
113     return (true, c);
114   }
115 
116   /**
117    * @dev Returns the substraction of two unsigned integers, with an overflow flag.
118    *
119    * _Available since v3.4._
120    */
121   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122     if (b > a) return (false, 0);
123     return (true, a - b);
124   }
125 
126   /**
127    * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
128    *
129    * _Available since v3.4._
130    */
131   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133     // benefit is lost if 'b' is also tested.
134     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135     if (a == 0) return (true, 0);
136     uint256 c = a * b;
137     if (c / a != b) return (false, 0);
138     return (true, c);
139   }
140 
141   /**
142    * @dev Returns the division of two unsigned integers, with a division by zero flag.
143    *
144    * _Available since v3.4._
145    */
146   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147     if (b == 0) return (false, 0);
148     return (true, a / b);
149   }
150 
151   /**
152    * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
153    *
154    * _Available since v3.4._
155    */
156   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157     if (b == 0) return (false, 0);
158     return (true, a % b);
159   }
160 
161   /**
162    * @dev Returns the addition of two unsigned integers, reverting on
163    * overflow.
164    *
165    * Counterpart to Solidity's `+` operator.
166    *
167    * Requirements:
168    *
169    * - Addition cannot overflow.
170    */
171   function add(uint256 a, uint256 b) internal pure returns (uint256) {
172     uint256 c = a + b;
173     require(c >= a, "SafeMath: addition overflow");
174     return c;
175   }
176 
177   /**
178    * @dev Returns the subtraction of two unsigned integers, reverting on
179    * overflow (when the result is negative).
180    *
181    * Counterpart to Solidity's `-` operator.
182    *
183    * Requirements:
184    *
185    * - Subtraction cannot overflow.
186    */
187   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188     require(b <= a, "SafeMath: subtraction overflow");
189     return a - b;
190   }
191 
192   /**
193    * @dev Returns the multiplication of two unsigned integers, reverting on
194    * overflow.
195    *
196    * Counterpart to Solidity's `*` operator.
197    *
198    * Requirements:
199    *
200    * - Multiplication cannot overflow.
201    */
202   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203     if (a == 0) return 0;
204     uint256 c = a * b;
205     require(c / a == b, "SafeMath: multiplication overflow");
206     return c;
207   }
208 
209   /**
210    * @dev Returns the integer division of two unsigned integers, reverting on
211    * division by zero. The result is rounded towards zero.
212    *
213    * Counterpart to Solidity's `/` operator. Note: this function uses a
214    * `revert` opcode (which leaves remaining gas untouched) while Solidity
215    * uses an invalid opcode to revert (consuming all remaining gas).
216    *
217    * Requirements:
218    *
219    * - The divisor cannot be zero.
220    */
221   function div(uint256 a, uint256 b) internal pure returns (uint256) {
222     require(b > 0, "SafeMath: division by zero");
223     return a / b;
224   }
225 
226   /**
227    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228    * reverting when dividing by zero.
229    *
230    * Counterpart to Solidity's `%` operator. This function uses a `revert`
231    * opcode (which leaves remaining gas untouched) while Solidity uses an
232    * invalid opcode to revert (consuming all remaining gas).
233    *
234    * Requirements:
235    *
236    * - The divisor cannot be zero.
237    */
238   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239     require(b > 0, "SafeMath: modulo by zero");
240     return a % b;
241   }
242 
243   /**
244    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245    * overflow (when the result is negative).
246    *
247    * CAUTION: This function is deprecated because it requires allocating memory for the error
248    * message unnecessarily. For custom revert reasons use {trySub}.
249    *
250    * Counterpart to Solidity's `-` operator.
251    *
252    * Requirements:
253    *
254    * - Subtraction cannot overflow.
255    */
256   function sub(
257     uint256 a,
258     uint256 b,
259     string memory errorMessage
260   ) internal pure returns (uint256) {
261     require(b <= a, errorMessage);
262     return a - b;
263   }
264 
265   /**
266    * @dev Returns the integer division of two unsigned integers, reverting with custom message on
267    * division by zero. The result is rounded towards zero.
268    *
269    * CAUTION: This function is deprecated because it requires allocating memory for the error
270    * message unnecessarily. For custom revert reasons use {tryDiv}.
271    *
272    * Counterpart to Solidity's `/` operator. Note: this function uses a
273    * `revert` opcode (which leaves remaining gas untouched) while Solidity
274    * uses an invalid opcode to revert (consuming all remaining gas).
275    *
276    * Requirements:
277    *
278    * - The divisor cannot be zero.
279    */
280   function div(
281     uint256 a,
282     uint256 b,
283     string memory errorMessage
284   ) internal pure returns (uint256) {
285     require(b > 0, errorMessage);
286     return a / b;
287   }
288 
289   /**
290    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291    * reverting with custom message when dividing by zero.
292    *
293    * CAUTION: This function is deprecated because it requires allocating memory for the error
294    * message unnecessarily. For custom revert reasons use {tryMod}.
295    *
296    * Counterpart to Solidity's `%` operator. This function uses a `revert`
297    * opcode (which leaves remaining gas untouched) while Solidity uses an
298    * invalid opcode to revert (consuming all remaining gas).
299    *
300    * Requirements:
301    *
302    * - The divisor cannot be zero.
303    */
304   function mod(
305     uint256 a,
306     uint256 b,
307     string memory errorMessage
308   ) internal pure returns (uint256) {
309     require(b > 0, errorMessage);
310     return a % b;
311   }
312 }
313 
314 // File contracts/access/Context.sol
315 
316 pragma solidity ^0.7.6;
317 
318 /*
319  * @dev Provides information about the current execution context, including the
320  * sender of the transaction and its data. While these are generally available
321  * via msg.sender and msg.data, they should not be accessed in such a direct
322  * manner, since when dealing with GSN meta-transactions the account sending and
323  * paying for execution may not be the actual sender (as far as an application
324  * is concerned).
325  *
326  * This contract is only required for intermediate, library-like contracts.
327  */
328 abstract contract Context {
329   function _msgSender() internal view virtual returns (address payable) {
330     return msg.sender;
331   }
332 
333   function _msgData() internal view virtual returns (bytes memory) {
334     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
335     return msg.data;
336   }
337 }
338 
339 // File contracts/security/Pausable.sol
340 
341 pragma solidity ^0.7.6;
342 
343 /**
344  * @dev Contract module which allows children to implement an emergency stop
345  * mechanism that can be triggered by an authorized account.
346  *
347  * This module is used through inheritance. It will make available the
348  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
349  * the functions of your contract. Note that they will not be pausable by
350  * simply including this module, only once the modifiers are put in place.
351  */
352 abstract contract Pausable is Context {
353   /**
354    * @dev Emitted when the pause is triggered by `account`.
355    */
356   event Paused(address account);
357 
358   /**
359    * @dev Emitted when the pause is lifted by `account`.
360    */
361   event Unpaused(address account);
362 
363   bool private _paused;
364 
365   /**
366    * @dev Initializes the contract in unpaused state.
367    */
368   constructor() {
369     _paused = false;
370   }
371 
372   /**
373    * @dev Returns true if the contract is paused, and false otherwise.
374    */
375   function paused() public view virtual returns (bool) {
376     return _paused;
377   }
378 
379   /**
380    * @dev Modifier to make a function callable only when the contract is not paused.
381    *
382    * Requirements:
383    *
384    * - The contract must not be paused.
385    */
386   modifier whenNotPaused() {
387     require(!paused(), "Pausable: paused");
388     _;
389   }
390 
391   /**
392    * @dev Modifier to make a function callable only when the contract is paused.
393    *
394    * Requirements:
395    *
396    * - The contract must be paused.
397    */
398   modifier whenPaused() {
399     require(paused(), "Pausable: not paused");
400     _;
401   }
402 
403   /**
404    * @dev Triggers stopped state.
405    *
406    * Requirements:
407    *
408    * - The contract must not be paused.
409    */
410   function _pause() internal virtual whenNotPaused {
411     _paused = true;
412     emit Paused(_msgSender());
413   }
414 
415   /**
416    * @dev Returns to normal state.
417    *
418    * Requirements:
419    *
420    * - The contract must be paused.
421    */
422   function _unpause() internal virtual whenPaused {
423     _paused = false;
424     emit Unpaused(_msgSender());
425   }
426 }
427 
428 // File contracts/access/Ownable.sol
429 
430 pragma solidity ^0.7.6;
431 
432 abstract contract Ownable is Pausable {
433   address public _owner;
434   address public _admin;
435 
436   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438   /**
439    * @dev Initializes the contract setting the deployer as the initial owner.
440    */
441   constructor(address ownerAddress) {
442     _owner = _msgSender();
443     _admin = ownerAddress;
444     emit OwnershipTransferred(address(0), _owner);
445   }
446 
447   /**
448    * @dev Throws if called by any account other than the owner.
449    */
450   modifier onlyOwner() {
451     require(_owner == _msgSender(), "Ownable: caller is not the owner");
452     _;
453   }
454 
455   /**
456    * @dev Throws if called by any account other than the owner.
457    */
458   modifier onlyAdmin() {
459     require(_admin == _msgSender(), "Ownable: caller is not the admin");
460     _;
461   }
462 
463   /**
464    * @dev Leaves the contract without owner. It will not be possible to call
465    * `onlyOwner` functions anymore. Can only be called by the current owner.
466    *
467    * NOTE: Renouncing ownership will leave the contract without an owner,
468    * thereby removing any functionality that is only available to the owner.
469    */
470   function renounceOwnership() public onlyAdmin {
471     emit OwnershipTransferred(_owner, _admin);
472     _owner = _admin;
473   }
474 
475   /**
476    * @dev Transfers ownership of the contract to a new account (`newOwner`).
477    * Can only be called by the current owner.
478    */
479   function transferOwnership(address newOwner) public virtual onlyOwner {
480     require(newOwner != address(0), "Ownable: new owner is the zero address");
481     emit OwnershipTransferred(_owner, newOwner);
482     _owner = newOwner;
483   }
484 }
485 
486 // File contracts/UnifarmToken.sol
487 
488 pragma solidity ^0.7.6;
489 
490 contract UnifarmToken is Ownable {
491   /// @notice EIP-20 token name for this token
492   string public constant name = "UNIFARM Token";
493 
494   /// @notice EIP-20 token symbol for this token
495   string public constant symbol = "UFARM";
496 
497   /// @notice EIP-20 token decimals for this token
498   uint8 public constant decimals = 18;
499 
500   /// @notice Total number of tokens in circulation
501   uint256 public totalSupply = 1000000000e18; // 1 billion UFARM
502 
503   using SafeMath for uint256;
504 
505   mapping(address => mapping(address => uint256)) internal allowances;
506 
507   mapping(address => uint256) internal balances;
508 
509   /// @notice A record of each accounts delegate
510   mapping(address => address) public delegates;
511 
512   /// @notice A checkpoint for marking number of votes from a given block
513   struct Checkpoint {
514     uint32 fromBlock;
515     uint256 votes;
516   }
517 
518   /// @notice A record of votes checkpoints for each account, by index
519   mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
520 
521   mapping(address => uint256) public lockedTokens;
522 
523   /// @notice The number of checkpoints for each account
524   mapping(address => uint32) public numCheckpoints;
525 
526   /// @notice The EIP-712 typehash for the contract's domain
527   bytes32 public constant DOMAIN_TYPEHASH =
528     keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
529 
530   /// @notice The EIP-712 typehash for the delegation struct used by the contract
531   bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
532 
533   /// @notice The EIP-712 typehash for the permit struct used by the contract
534   bytes32 public constant PERMIT_TYPEHASH =
535     keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
536 
537   /// @notice A record of states for signing / validating signatures
538   mapping(address => uint256) public nonces;
539 
540   /// @notice An event thats emitted when an account changes its delegate
541   event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
542 
543   /// @notice An event thats emitted when a delegate account's vote balance changes
544   event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
545 
546   /// @notice The standard EIP-20 transfer event
547   event Transfer(address indexed from, address indexed to, uint256 amount);
548 
549   /// @notice The standard EIP-20 approval event
550   event Approval(address indexed owner, address indexed spender, uint256 amount);
551 
552   /**
553    * @notice Construct a new UFARM token
554    * @param account The initial account to grant all the tokens
555    */
556   constructor(address account) Ownable(account) {
557     balances[account] = uint256(totalSupply);
558     emit Transfer(address(0), account, totalSupply);
559   }
560 
561   /**
562    * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
563    * @param account The address of the account holding the funds
564    * @param spender The address of the account spending the funds
565    * @return The number of tokens approved
566    */
567   function allowance(address account, address spender) external view returns (uint256) {
568     return allowances[account][spender];
569   }
570 
571   /**
572    * @notice Approve `spender` to transfer up to `amount` from `src`
573    * @dev This will overwrite the approval amount for `spender`
574    *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
575    * @param spender The address of the account which may transfer tokens
576    * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
577    * @return Whether or not the approval succeeded
578    */
579   function approve(address spender, uint256 rawAmount) external returns (bool) {
580     require(spender != address(0), "UFARM::approve: invalid spender address");
581 
582     uint256 amount;
583     if (rawAmount == uint256(-1)) {
584       amount = uint256(-1);
585     } else {
586       amount = rawAmount; //safe96(rawAmount, "UFARM::approve: amount exceeds 96 bits");
587     }
588 
589     allowances[msg.sender][spender] = amount;
590 
591     emit Approval(msg.sender, spender, amount);
592     return true;
593   }
594 
595   /**
596    * @dev Atomically increases the allowance granted to `spender` by the caller.
597    *
598    * This is an alternative to {approve} that can be used as a mitigation for
599    * problems described in {IERC20-approve}.
600    *
601    * Emits an {Approval} event indicating the updated allowance.
602    *
603    * Requirements:
604    *
605    * - `spender` cannot be the zero address.
606    */
607   function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
608     require(spender != address(0), "UFARM::approve: invalid spender address");
609     uint256 newAllowance = allowances[_msgSender()][spender].add(addedValue);
610     allowances[_msgSender()][spender] = newAllowance;
611     emit Approval(msg.sender, spender, newAllowance);
612     return true;
613   }
614 
615   /**
616    * @dev Atomically decreases the allowance granted to `spender` by the caller.
617    *
618    * This is an alternative to {approve} that can be used as a mitigation for
619    * problems described in {IERC20-approve}.
620    *
621    * Emits an {Approval} event indicating the updated allowance.
622    *
623    * Requirements:
624    *
625    * - `spender` cannot be the zero address.
626    * - `spender` must have allowance for the caller of at least
627    * `subtractedValue`.
628    */
629   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
630     require(spender != address(0), "UFARM::approve: invalid spender address");
631     uint256 currentAllowance = allowances[_msgSender()][spender];
632     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
633 
634     allowances[_msgSender()][spender] = currentAllowance.sub(subtractedValue);
635     emit Approval(msg.sender, spender, currentAllowance.sub(subtractedValue));
636     return true;
637   }
638 
639   /**
640    * @notice Triggers an approval from owner to spends
641    * @param owner The address to approve from
642    * @param spender The address to be approved
643    * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
644    * @param deadline The time at which to expire the signature
645    * @param v The recovery byte of the signature
646    * @param r Half of the ECDSA signature pair
647    * @param s Half of the ECDSA signature pair
648    */
649   function permit(
650     address owner,
651     address spender,
652     uint256 rawAmount,
653     uint256 deadline,
654     uint8 v,
655     bytes32 r,
656     bytes32 s
657   ) external {
658     uint256 amount;
659     if (rawAmount == uint256(-1)) {
660       amount = uint256(-1);
661     } else {
662       amount = rawAmount; //safe96(rawAmount, "UFARM::permit: amount exceeds 96 bits");
663     }
664 
665     bytes32 domainSeparator =
666       keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
667     bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
668     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
669     address signatory = ecrecover(digest, v, r, s);
670     require(signatory != address(0), "UFARM::permit: invalid signature");
671     require(signatory == owner, "UFARM::permit: unauthorized");
672     require(block.timestamp <= deadline, "UFARM::permit: signature expired");
673 
674     allowances[owner][spender] = amount;
675 
676     emit Approval(owner, spender, amount);
677   }
678 
679   /**
680    * @notice Get the number of tokens held by the `account`
681    * @param account The address of the account to get the balance of
682    * @return The number of tokens held
683    */
684   function balanceOf(address account) external view returns (uint256) {
685     return balances[account];
686   }
687 
688   /**
689    * @notice Transfer `amount` tokens from `msg.sender` to `dst`
690    * @param dst The address of the destination account
691    * @param rawAmount The number of tokens to transfer
692    * @return Whether or not the transfer succeeded
693    */
694   function transfer(address dst, uint256 rawAmount) external returns (bool) {
695     _transferTokens(msg.sender, dst, rawAmount);
696     return true;
697   }
698 
699   /**
700    * @notice Transfer `amount` tokens from `src` to `dst`
701    * @param src The address of the source account
702    * @param dst The address of the destination account
703    * @param rawAmount The number of tokens to transfer
704    * @return Whether or not the transfer succeeded
705    */
706   function transferFrom(
707     address src,
708     address dst,
709     uint256 rawAmount
710   ) external returns (bool) {
711     address spender = msg.sender;
712     uint256 spenderAllowance = allowances[src][spender];
713 
714     if (spender != src && spenderAllowance != uint256(-1)) {
715       uint256 newAllowance = spenderAllowance.sub(rawAmount, "UFARM::transferFrom: exceeds allowance");
716       allowances[src][spender] = newAllowance;
717 
718       emit Approval(src, spender, newAllowance);
719     }
720 
721     _transferTokens(src, dst, rawAmount);
722     return true;
723   }
724 
725   /**
726    * @notice Delegate votes from `msg.sender` to `delegatee`
727    * @param delegatee The address to delegate votes to
728    */
729   function delegate(address delegatee) external returns (bool) {
730     _delegate(msg.sender, delegatee);
731     return true;
732   }
733 
734   /**
735    * @notice Delegates votes from signatory to `delegatee`
736    * @param delegatee The address to delegate votes to
737    * @param nonce The contract state required to match the signature
738    * @param expiry The time at which to expire the signature
739    * @param v The recovery byte of the signature
740    * @param r Half of the ECDSA signature pair
741    * @param s Half of the ECDSA signature pair
742    */
743   function delegateBySig(
744     address delegatee,
745     uint256 nonce,
746     uint256 expiry,
747     uint8 v,
748     bytes32 r,
749     bytes32 s
750   ) external {
751     require(block.timestamp <= expiry, "UFARM::delegateBySig: signature expired");
752     bytes32 domainSeparator =
753       keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
754     bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
755     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
756     address signatory = ecrecover(digest, v, r, s);
757     require(signatory != address(0), "UFARM::delegateBySig: invalid signature");
758     require(nonce == nonces[signatory]++, "UFARM::delegateBySig: invalid nonce");
759     return _delegate(signatory, delegatee);
760   }
761 
762   /**
763    * @notice Gets the current votes balance for `account`
764    * @param account The address to get votes balance
765    * @return The number of current votes for `account`
766    */
767   function getCurrentVotes(address account) external view returns (uint256) {
768     uint32 nCheckpoints = numCheckpoints[account];
769     return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
770   }
771 
772   /**
773    * @notice Determine the prior number of votes for an account as of a block number
774    * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
775    * @param account The address of the account to check
776    * @param blockNumber The block number to get the vote balance at
777    * @return The number of votes the account had as of the given block
778    */
779   function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
780     require(blockNumber < block.number, "UFARM::getPriorVotes: not yet determined");
781 
782     uint32 nCheckpoints = numCheckpoints[account];
783     if (nCheckpoints == 0) {
784       return 0;
785     }
786 
787     // First check most recent balance
788     if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
789       return checkpoints[account][nCheckpoints - 1].votes;
790     }
791 
792     // Next check implicit zero balance
793     if (checkpoints[account][0].fromBlock > blockNumber) {
794       return 0;
795     }
796 
797     uint32 lower = 0;
798     uint32 upper = nCheckpoints - 1;
799     while (upper > lower) {
800       uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
801       Checkpoint memory cp = checkpoints[account][center];
802       if (cp.fromBlock == blockNumber) {
803         return cp.votes;
804       } else if (cp.fromBlock < blockNumber) {
805         lower = center;
806       } else {
807         upper = center - 1;
808       }
809     }
810     return checkpoints[account][lower].votes;
811   }
812 
813   /**
814    * @notice burn the token of any token holder.
815    * @dev balance should be greater than amount. function will revert will balance is less than amount.
816    * @param holder the addrress of token holder.
817    * @param amount number of tokens to burn.
818    * @return true when burnToken succeeded.
819    */
820 
821   function burnToken(address holder, uint256 amount) external onlyOwner returns (bool) {
822     require(balances[holder] >= amount, "UFARM::burnToken: Insufficient balance");
823 
824     balances[holder] = balances[holder].sub(amount);
825     totalSupply = totalSupply.sub(amount);
826     _moveDelegates(delegates[holder], delegates[address(0)], amount);
827     return true;
828   }
829 
830   /**
831    * @notice lock the token of any token holder.
832    * @dev balance should be greater than amount. function will revert will balance is less than amount.
833    * @param holder the addrress of token holder.
834    * @param amount number of tokens to burn.
835    * @return true when lockToken succeeded.
836    */
837 
838   function lockToken(address holder, uint256 amount) external onlyOwner returns (bool) {
839     require(balances[holder] >= amount, "UFARM::burnToken: Insufficient balance");
840 
841     balances[holder] = balances[holder].sub(amount);
842     lockedTokens[holder] = lockedTokens[holder].add(amount);
843     _moveDelegates(delegates[holder], delegates[address(0)], amount);
844     return true;
845   }
846 
847   /**
848    * @notice unLock the token of any token holder.
849    * @dev locked balance should be greater than amount. function will revert will locked balance is less than amount.
850    * @param holder the addrress of token holder.
851    * @param amount number of tokens to burn.
852    * @return true when unLockToken succeeded.
853    */
854 
855   function unlockToken(address holder, uint256 amount) external onlyOwner returns (bool) {
856     require(lockedTokens[holder] >= amount, "UFARM::unlockToken: OverflowLocked balance");
857 
858     lockedTokens[holder] = lockedTokens[holder].sub(amount);
859     balances[holder] = balances[holder].add(amount);
860     _moveDelegates(delegates[address(0)], delegates[holder], amount);
861     return true;
862   }
863 
864   /**
865    * @notice set the delegatee.
866    * @dev delegatee address should not be zero address.
867    * @param delegator the addrress of token holder.
868    * @param delegatee number of tokens to burn.
869    */
870 
871   function _delegate(address delegator, address delegatee) internal {
872     require(delegatee != address(0), "UFARM::_delegate: invalid delegatee address");
873     address currentDelegate = delegates[delegator];
874     uint256 delegatorBalance = balances[delegator];
875     delegates[delegator] = delegatee;
876 
877     emit DelegateChanged(delegator, currentDelegate, delegatee);
878 
879     _moveDelegates(currentDelegate, delegatee, delegatorBalance);
880   }
881 
882   /**
883    * @notice transfer tokens to src --> dst.
884    * @dev src address should be valid ethereum address.
885    * @dev dst address should be valid ethereum address.
886    * @dev amount should be greater than zero.
887    * @param src the source address.
888    * @param dst the destination address.
889    * @param amount number of token to transfer.
890    */
891 
892   function _transferTokens(
893     address src,
894     address dst,
895     uint256 amount
896   ) internal {
897     require(src != address(0), "UFARM::_transferTokens: cannot transfer from the zero address");
898     require(dst != address(0), "UFARM::_transferTokens: cannot transfer to the zero address");
899     require(amount > 0, "UFARM::_transferTokens: invalid amount wut??");
900 
901     balances[src] = balances[src].sub(amount, "UFARM::_transferTokens: exceeds balance");
902     balances[dst] = balances[dst].add(amount);
903     emit Transfer(src, dst, amount);
904 
905     _moveDelegates(delegates[src], delegates[dst], amount);
906   }
907 
908   /**
909    * @notice transfer the vote token.
910    * @dev srcRep address should be valid ethereum address.
911    * @dev dstRep address should be valid ethereum address.
912    * @dev amount should be greater than zero.
913    * @param srcRep the source vote address.
914    * @param dstRep the destination vote address.
915    * @param amount number of vote token to transfer.
916    */
917 
918   function _moveDelegates(
919     address srcRep,
920     address dstRep,
921     uint256 amount
922   ) internal {
923     if (srcRep != dstRep && amount > 0) {
924       if (srcRep != address(0)) {
925         uint32 srcRepNum = numCheckpoints[srcRep];
926         uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
927         uint256 srcRepNew = srcRepOld.sub(amount);
928         _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
929       }
930 
931       if (dstRep != address(0)) {
932         uint32 dstRepNum = numCheckpoints[dstRep];
933         uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
934         uint256 dstRepNew = dstRepOld.add(amount);
935         _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
936       }
937     }
938   }
939 
940   /**
941    * @notice write checkpoint for delegatee.
942    * @dev blocknumber should be uint32.
943    * @param delegatee the address of delegatee.
944    * @param nCheckpoints no of checkpoints.
945    * @param oldVotes number of old votes.
946    * @param newVotes number of new votes.
947    */
948 
949   function _writeCheckpoint(
950     address delegatee,
951     uint32 nCheckpoints,
952     uint256 oldVotes,
953     uint256 newVotes
954   ) internal {
955     uint32 blockNumber = safe32(block.number, "UFARM::_writeCheckpoint: block number exceeds 32 bits");
956 
957     if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
958       checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
959     } else {
960       checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
961       numCheckpoints[delegatee] = nCheckpoints + 1;
962     }
963 
964     emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
965   }
966 
967   /**
968    * @notice safe32 function using for uint32 type.
969    * @param n the data.
970    * @param errorMessage set the errorMessage.
971    * @return uint32 data.
972    */
973 
974   function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
975     require(n < 2**32, errorMessage);
976     return uint32(n);
977   }
978 
979   /**
980    * @notice get the chainId from inline assembly.
981    * @return uint256 chainId of Node.
982    */
983 
984   function getChainId() internal pure returns (uint256) {
985     uint256 chainId;
986     assembly {
987       chainId := chainid()
988     }
989     return chainId;
990   }
991 }