1 /**
2  * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 
8 
9 interface IWeth {
10     function deposit() external payable;
11     function withdraw(uint256 wad) external;
12 }
13 
14 contract IERC20 {
15     string public name;
16     uint8 public decimals;
17     string public symbol;
18     function totalSupply() public view returns (uint256);
19     function balanceOf(address _who) public view returns (uint256);
20     function allowance(address _owner, address _spender) public view returns (uint256);
21     function approve(address _spender, uint256 _value) public returns (bool);
22     function transfer(address _to, uint256 _value) public returns (bool);
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 contract IWethERC20 is IWeth, IERC20 {}
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations with added overflow
32  * checks.
33  *
34  * Arithmetic operations in Solidity wrap on overflow. This can easily result
35  * in bugs, because programmers usually assume that an overflow raises an
36  * error, which is the standard behavior in high level programming languages.
37  * `SafeMath` restores this intuition by reverting the transaction when an
38  * operation overflows.
39  *
40  * Using this library instead of the unchecked operations eliminates an entire
41  * class of bugs, so it's recommended to use it always.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting on
46      * overflow.
47      *
48      * Counterpart to Solidity's `+` operator.
49      *
50      * Requirements:
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      * - Subtraction cannot overflow.
81      *
82      * _Available since v2.4.0._
83      */
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      *
140      * _Available since v2.4.0._
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b != 0, errorMessage);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 
151     /**
152     * @dev Integer division of two numbers, rounding up and truncating the quotient
153     */
154     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
155         return divCeil(a, b, "SafeMath: division by zero");
156     }
157 
158     /**
159     * @dev Integer division of two numbers, rounding up and truncating the quotient
160     */
161     function divCeil(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b != 0, errorMessage);
164 
165         if (a == 0) {
166             return 0;
167         }
168         uint256 c = ((a - 1) / b) + 1;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         return mod(a, b, "SafeMath: modulo by zero");
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
190      * Reverts with custom message when dividing by zero.
191      *
192      * Counterpart to Solidity's `%` operator. This function uses a `revert`
193      * opcode (which leaves remaining gas untouched) while Solidity uses an
194      * invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      *
199      * _Available since v2.4.0._
200      */
201     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b != 0, errorMessage);
203         return a % b;
204     }
205 
206     function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
207         return _a < _b ? _a : _b;
208     }
209 }
210 
211 /**
212  * @title SignedSafeMath
213  * @dev Signed math operations with safety checks that revert on error.
214  */
215 library SignedSafeMath {
216     int256 constant private _INT256_MIN = -2**255;
217 
218         /**
219      * @dev Returns the multiplication of two signed integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `*` operator.
223      *
224      * Requirements:
225      *
226      * - Multiplication cannot overflow.
227      */
228     function mul(int256 a, int256 b) internal pure returns (int256) {
229         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
230         // benefit is lost if 'b' is also tested.
231         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
232         if (a == 0) {
233             return 0;
234         }
235 
236         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
237 
238         int256 c = a * b;
239         require(c / a == b, "SignedSafeMath: multiplication overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the integer division of two signed integers. Reverts on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(int256 a, int256 b) internal pure returns (int256) {
257         require(b != 0, "SignedSafeMath: division by zero");
258         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
259 
260         int256 c = a / b;
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two signed integers, reverting on
267      * overflow.
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(int256 a, int256 b) internal pure returns (int256) {
276         int256 c = a - b;
277         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the addition of two signed integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `+` operator.
287      *
288      * Requirements:
289      *
290      * - Addition cannot overflow.
291      */
292     function add(int256 a, int256 b) internal pure returns (int256) {
293         int256 c = a + b;
294         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
295 
296         return c;
297     }
298 }
299 
300 /**
301  * @title Helps contracts guard against reentrancy attacks.
302  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
303  * @dev If you mark a function `nonReentrant`, you should also
304  * mark it `external`.
305  */
306 contract ReentrancyGuard {
307 
308     /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
309     /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
310     uint256 internal constant REENTRANCY_GUARD_FREE = 1;
311 
312     /// @dev Constant for locked guard state
313     uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;
314 
315     /**
316     * @dev We use a single lock for the whole contract.
317     */
318     uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;
319 
320     /**
321     * @dev Prevents a contract from calling itself, directly or indirectly.
322     * If you mark a function `nonReentrant`, you should also
323     * mark it `external`. Calling one `nonReentrant` function from
324     * another is not supported. Instead, you can implement a
325     * `private` function doing the actual work, and an `external`
326     * wrapper marked as `nonReentrant`.
327     */
328     modifier nonReentrant() {
329         require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");
330         reentrancyLock = REENTRANCY_GUARD_LOCKED;
331         _;
332         reentrancyLock = REENTRANCY_GUARD_FREE;
333     }
334 }
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following 
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
359         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
360         // for accounts without code, i.e. `keccak256('')`
361         bytes32 codehash;
362         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
363         // solhint-disable-next-line no-inline-assembly
364         assembly { codehash := extcodehash(account) }
365         return (codehash != accountHash && codehash != 0x0);
366     }
367 
368     /**
369      * @dev Converts an `address` into `address payable`. Note that this is
370      * simply a type cast: the actual underlying value is not changed.
371      *
372      * _Available since v2.4.0._
373      */
374     function toPayable(address account) internal pure returns (address payable) {
375         return address(uint160(account));
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      *
394      * _Available since v2.4.0._
395      */
396     function sendValue(address recipient, uint256 amount) internal {
397         require(address(this).balance >= amount, "Address: insufficient balance");
398 
399         // solhint-disable-next-line avoid-call-value
400         (bool success, ) = recipient.call.value(amount)("");
401         require(success, "Address: unable to send value, recipient may have reverted");
402     }
403 }
404 
405 /*
406  * @dev Provides information about the current execution context, including the
407  * sender of the transaction and its data. While these are generally available
408  * via msg.sender and msg.data, they should not be accessed in such a direct
409  * manner, since when dealing with GSN meta-transactions the account sending and
410  * paying for execution may not be the actual sender (as far as an application
411  * is concerned).
412  *
413  * This contract is only required for intermediate, library-like contracts.
414  */
415 contract Context {
416     // Empty internal constructor, to prevent people from mistakenly deploying
417     // an instance of this contract, which should be used via inheritance.
418     constructor () internal { }
419     // solhint-disable-previous-line no-empty-blocks
420 
421     function _msgSender() internal view returns (address payable) {
422         return msg.sender;
423     }
424 
425     function _msgData() internal view returns (bytes memory) {
426         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
427         return msg.data;
428     }
429 }
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * This module is used through inheritance. It will make available the modifier
437  * `onlyOwner`, which can be applied to your functions to restrict their use to
438  * the owner.
439  */
440 contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
444 
445     /**
446      * @dev Initializes the contract setting the deployer as the initial owner.
447      */
448     constructor () internal {
449         address msgSender = _msgSender();
450         _owner = msgSender;
451         emit OwnershipTransferred(address(0), msgSender);
452     }
453 
454     /**
455      * @dev Returns the address of the current owner.
456      */
457     function owner() public view returns (address) {
458         return _owner;
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         require(isOwner(), "unauthorized");
466         _;
467     }
468 
469     /**
470      * @dev Returns true if the caller is the current owner.
471      */
472     function isOwner() public view returns (bool) {
473         return _msgSender() == _owner;
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public onlyOwner {
481         _transferOwnership(newOwner);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      */
487     function _transferOwnership(address newOwner) internal {
488         require(newOwner != address(0), "Ownable: new owner is the zero address");
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 contract Pausable {
495 
496     // keccak256("Pausable_FunctionPause")
497     bytes32 internal constant Pausable_FunctionPause = 0xa7143c84d793a15503da6f19bf9119a2dac94448ca45d77c8bf08f57b2e91047;
498 
499     modifier pausable(bytes4 sig) {
500         require(!_isPaused(sig), "unauthorized");
501         _;
502     }
503 
504     function _isPaused(
505         bytes4 sig)
506         internal
507         view
508         returns (bool isPaused)
509     {
510         bytes32 slot = keccak256(abi.encodePacked(sig, Pausable_FunctionPause));
511         assembly {
512             isPaused := sload(slot)
513         }
514     }
515 }
516 
517 contract LoanTokenBase is ReentrancyGuard, Ownable, Pausable {
518 
519     uint256 internal constant WEI_PRECISION = 10**18;
520     uint256 internal constant WEI_PERCENT_PRECISION = 10**20;
521 
522     int256 internal constant sWEI_PRECISION = 10**18;
523 
524     string public name;
525     string public symbol;
526     uint8 public decimals;
527 
528     // uint88 for tight packing -> 8 + 88 + 160 = 256
529     uint88 internal lastSettleTime_;
530 
531     address public loanTokenAddress;
532 
533     uint256 public baseRate;
534     uint256 public rateMultiplier;
535     uint256 public lowUtilBaseRate;
536     uint256 public lowUtilRateMultiplier;
537 
538     uint256 public targetLevel;
539     uint256 public kinkLevel;
540     uint256 public maxScaleRate;
541 
542     uint256 internal _flTotalAssetSupply;
543     uint256 public checkpointSupply;
544     uint256 public initialPrice;
545 
546     mapping (uint256 => bytes32) public loanParamsIds; // mapping of keccak256(collateralToken, isTorqueLoan) to loanParamsId
547     mapping (address => uint256) internal checkpointPrices_; // price of token at last user checkpoint
548 }
549 
550 contract AdvancedTokenStorage is LoanTokenBase {
551     using SafeMath for uint256;
552 
553     event Transfer(
554         address indexed from,
555         address indexed to,
556         uint256 value
557     );
558 
559     event Approval(
560         address indexed owner,
561         address indexed spender,
562         uint256 value
563     );
564 
565     event Mint(
566         address indexed minter,
567         uint256 tokenAmount,
568         uint256 assetAmount,
569         uint256 price
570     );
571 
572     event Burn(
573         address indexed burner,
574         uint256 tokenAmount,
575         uint256 assetAmount,
576         uint256 price
577     );
578 
579     mapping(address => uint256) internal balances;
580     mapping (address => mapping (address => uint256)) internal allowed;
581     uint256 internal totalSupply_;
582 
583     function totalSupply()
584         public
585         view
586         returns (uint256)
587     {
588         return totalSupply_;
589     }
590 
591     function balanceOf(
592         address _owner)
593         public
594         view
595         returns (uint256)
596     {
597         return balances[_owner];
598     }
599 
600     function allowance(
601         address _owner,
602         address _spender)
603         public
604         view
605         returns (uint256)
606     {
607         return allowed[_owner][_spender];
608     }
609 }
610 
611 contract LoanToken is AdvancedTokenStorage {
612 
613     address internal target_;
614 
615     constructor(
616         address _newOwner,
617         address _newTarget)
618         public
619     {
620         transferOwnership(_newOwner);
621         _setTarget(_newTarget);
622     }
623 
624     function()
625         external
626         payable
627     {
628         if (gasleft() <= 2300) {
629             return;
630         }
631 
632         address target = target_;
633         bytes memory data = msg.data;
634         assembly {
635             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
636             let size := returndatasize
637             let ptr := mload(0x40)
638             returndatacopy(ptr, 0, size)
639             switch result
640             case 0 { revert(ptr, size) }
641             default { return(ptr, size) }
642         }
643     }
644 
645     function setTarget(
646         address _newTarget)
647         public
648         onlyOwner
649     {
650         _setTarget(_newTarget);
651     }
652 
653     function _setTarget(
654         address _newTarget)
655         internal
656     {
657         require(Address.isContract(_newTarget), "target not a contract");
658         target_ = _newTarget;
659     }
660 }