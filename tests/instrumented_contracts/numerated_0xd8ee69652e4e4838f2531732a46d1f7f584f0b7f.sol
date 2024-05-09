1 /**
2  * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 pragma experimental ABIEncoderV2;
8 
9 
10 interface IWeth {
11     function deposit() external payable;
12     function withdraw(uint256 wad) external;
13 }
14 
15 contract IERC20 {
16     string public name;
17     uint8 public decimals;
18     string public symbol;
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address _who) public view returns (uint256);
21     function allowance(address _owner, address _spender) public view returns (uint256);
22     function approve(address _spender, uint256 _value) public returns (bool);
23     function transfer(address _to, uint256 _value) public returns (bool);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 contract IWethERC20 is IWeth, IERC20 {}
30 
31 contract Constants {
32 
33     uint256 internal constant WEI_PRECISION = 10**18;
34     uint256 internal constant WEI_PERCENT_PRECISION = 10**20;
35 
36     uint256 internal constant DAYS_IN_A_YEAR = 365;
37     uint256 internal constant ONE_MONTH = 2628000; // approx. seconds in a month
38 
39     IWethERC20 public constant wethToken = IWethERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
40     address public constant bzrxTokenAddress = 0x56d811088235F11C8920698a204A5010a788f4b3;
41     address public constant vbzrxTokenAddress = 0xB72B31907C1C95F3650b64b2469e08EdACeE5e8F;
42 }
43 
44 /**
45  * @dev Library for managing loan sets
46  *
47  * Sets have the following properties:
48  *
49  * - Elements are added, removed, and checked for existence in constant time
50  * (O(1)).
51  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
52  *
53  * Include with `using EnumerableBytes32Set for EnumerableBytes32Set.Bytes32Set;`.
54  *
55  */
56 library EnumerableBytes32Set {
57 
58     struct Bytes32Set {
59         // Position of the value in the `values` array, plus 1 because index 0
60         // means a value is not in the set.
61         mapping (bytes32 => uint256) index;
62         bytes32[] values;
63     }
64 
65     /**
66      * @dev Add an address value to a set. O(1).
67      * Returns false if the value was already in the set.
68      */
69     function addAddress(Bytes32Set storage set, address addrvalue)
70         internal
71         returns (bool)
72     {
73         bytes32 value;
74         assembly {
75             value := addrvalue
76         }
77         return addBytes32(set, value);
78     }
79 
80     /**
81      * @dev Add a value to a set. O(1).
82      * Returns false if the value was already in the set.
83      */
84     function addBytes32(Bytes32Set storage set, bytes32 value)
85         internal
86         returns (bool)
87     {
88         if (!contains(set, value)){
89             set.index[value] = set.values.push(value);
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     /**
97      * @dev Removes an address value from a set. O(1).
98      * Returns false if the value was not present in the set.
99      */
100     function removeAddress(Bytes32Set storage set, address addrvalue)
101         internal
102         returns (bool)
103     {
104         bytes32 value;
105         assembly {
106             value := addrvalue
107         }
108         return removeBytes32(set, value);
109     }
110 
111     /**
112      * @dev Removes a value from a set. O(1).
113      * Returns false if the value was not present in the set.
114      */
115     function removeBytes32(Bytes32Set storage set, bytes32 value)
116         internal
117         returns (bool)
118     {
119         if (contains(set, value)){
120             uint256 toDeleteIndex = set.index[value] - 1;
121             uint256 lastIndex = set.values.length - 1;
122 
123             // If the element we're deleting is the last one, we can just remove it without doing a swap
124             if (lastIndex != toDeleteIndex) {
125                 bytes32 lastValue = set.values[lastIndex];
126 
127                 // Move the last value to the index where the deleted value is
128                 set.values[toDeleteIndex] = lastValue;
129                 // Update the index for the moved value
130                 set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based
131             }
132 
133             // Delete the index entry for the deleted value
134             delete set.index[value];
135 
136             // Delete the old entry for the moved value
137             set.values.pop();
138 
139             return true;
140         } else {
141             return false;
142         }
143     }
144 
145     /**
146      * @dev Returns true if the value is in the set. O(1).
147      */
148     function contains(Bytes32Set storage set, bytes32 value)
149         internal
150         view
151         returns (bool)
152     {
153         return set.index[value] != 0;
154     }
155 
156     /**
157      * @dev Returns true if the value is in the set. O(1).
158      */
159     function containsAddress(Bytes32Set storage set, address addrvalue)
160         internal
161         view
162         returns (bool)
163     {
164         bytes32 value;
165         assembly {
166             value := addrvalue
167         }
168         return set.index[value] != 0;
169     }
170 
171     /**
172      * @dev Returns an array with all values in the set. O(N).
173      * Note that there are no guarantees on the ordering of values inside the
174      * array, and it may change when more values are added or removed.
175 
176      * WARNING: This function may run out of gas on large sets: use {length} and
177      * {get} instead in these cases.
178      */
179     function enumerate(Bytes32Set storage set, uint256 start, uint256 count)
180         internal
181         view
182         returns (bytes32[] memory output)
183     {
184         uint256 end = start + count;
185         require(end >= start, "addition overflow");
186         end = set.values.length < end ? set.values.length : end;
187         if (end == 0 || start >= end) {
188             return output;
189         }
190 
191         output = new bytes32[](end-start);
192         for (uint256 i = start; i < end; i++) {
193             output[i-start] = set.values[i];
194         }
195         return output;
196     }
197 
198     /**
199      * @dev Returns the number of elements on the set. O(1).
200      */
201     function length(Bytes32Set storage set)
202         internal
203         view
204         returns (uint256)
205     {
206         return set.values.length;
207     }
208 
209    /** @dev Returns the element stored at position `index` in the set. O(1).
210     * Note that there are no guarantees on the ordering of values inside the
211     * array, and it may change when more values are added or removed.
212     *
213     * Requirements:
214     *
215     * - `index` must be strictly less than {length}.
216     */
217     function get(Bytes32Set storage set, uint256 index)
218         internal
219         view
220         returns (bytes32)
221     {
222         return set.values[index];
223     }
224 
225    /** @dev Returns the element stored at position `index` in the set. O(1).
226     * Note that there are no guarantees on the ordering of values inside the
227     * array, and it may change when more values are added or removed.
228     *
229     * Requirements:
230     *
231     * - `index` must be strictly less than {length}.
232     */
233     function getAddress(Bytes32Set storage set, uint256 index)
234         internal
235         view
236         returns (address)
237     {
238         bytes32 value = set.values[index];
239         address addrvalue;
240         assembly {
241             addrvalue := value
242         }
243         return addrvalue;
244     }
245 }
246 
247 /**
248  * @title Helps contracts guard against reentrancy attacks.
249  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
250  * @dev If you mark a function `nonReentrant`, you should also
251  * mark it `external`.
252  */
253 contract ReentrancyGuard {
254 
255     /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
256     /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
257     uint256 internal constant REENTRANCY_GUARD_FREE = 1;
258 
259     /// @dev Constant for locked guard state
260     uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;
261 
262     /**
263     * @dev We use a single lock for the whole contract.
264     */
265     uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;
266 
267     /**
268     * @dev Prevents a contract from calling itself, directly or indirectly.
269     * If you mark a function `nonReentrant`, you should also
270     * mark it `external`. Calling one `nonReentrant` function from
271     * another is not supported. Instead, you can implement a
272     * `private` function doing the actual work, and an `external`
273     * wrapper marked as `nonReentrant`.
274     */
275     modifier nonReentrant() {
276         require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");
277         reentrancyLock = REENTRANCY_GUARD_LOCKED;
278         _;
279         reentrancyLock = REENTRANCY_GUARD_FREE;
280     }
281 }
282 
283 /*
284  * @dev Provides information about the current execution context, including the
285  * sender of the transaction and its data. While these are generally available
286  * via msg.sender and msg.data, they should not be accessed in such a direct
287  * manner, since when dealing with GSN meta-transactions the account sending and
288  * paying for execution may not be the actual sender (as far as an application
289  * is concerned).
290  *
291  * This contract is only required for intermediate, library-like contracts.
292  */
293 contract Context {
294     // Empty internal constructor, to prevent people from mistakenly deploying
295     // an instance of this contract, which should be used via inheritance.
296     constructor () internal { }
297     // solhint-disable-previous-line no-empty-blocks
298 
299     function _msgSender() internal view returns (address payable) {
300         return msg.sender;
301     }
302 
303     function _msgData() internal view returns (bytes memory) {
304         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
305         return msg.data;
306     }
307 }
308 
309 /**
310  * @dev Contract module which provides a basic access control mechanism, where
311  * there is an account (an owner) that can be granted exclusive access to
312  * specific functions.
313  *
314  * This module is used through inheritance. It will make available the modifier
315  * `onlyOwner`, which can be applied to your functions to restrict their use to
316  * the owner.
317  */
318 contract Ownable is Context {
319     address private _owner;
320 
321     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
322 
323     /**
324      * @dev Initializes the contract setting the deployer as the initial owner.
325      */
326     constructor () internal {
327         address msgSender = _msgSender();
328         _owner = msgSender;
329         emit OwnershipTransferred(address(0), msgSender);
330     }
331 
332     /**
333      * @dev Returns the address of the current owner.
334      */
335     function owner() public view returns (address) {
336         return _owner;
337     }
338 
339     /**
340      * @dev Throws if called by any account other than the owner.
341      */
342     modifier onlyOwner() {
343         require(isOwner(), "unauthorized");
344         _;
345     }
346 
347     /**
348      * @dev Returns true if the caller is the current owner.
349      */
350     function isOwner() public view returns (bool) {
351         return _msgSender() == _owner;
352     }
353 
354     /**
355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
356      * Can only be called by the current owner.
357      */
358     function transferOwnership(address newOwner) public onlyOwner {
359         _transferOwnership(newOwner);
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      */
365     function _transferOwnership(address newOwner) internal {
366         require(newOwner != address(0), "Ownable: new owner is the zero address");
367         emit OwnershipTransferred(_owner, newOwner);
368         _owner = newOwner;
369     }
370 }
371 
372 /**
373  * @dev Wrappers over Solidity's arithmetic operations with added overflow
374  * checks.
375  *
376  * Arithmetic operations in Solidity wrap on overflow. This can easily result
377  * in bugs, because programmers usually assume that an overflow raises an
378  * error, which is the standard behavior in high level programming languages.
379  * `SafeMath` restores this intuition by reverting the transaction when an
380  * operation overflows.
381  *
382  * Using this library instead of the unchecked operations eliminates an entire
383  * class of bugs, so it's recommended to use it always.
384  */
385 library SafeMath {
386     /**
387      * @dev Returns the addition of two unsigned integers, reverting on
388      * overflow.
389      *
390      * Counterpart to Solidity's `+` operator.
391      *
392      * Requirements:
393      * - Addition cannot overflow.
394      */
395     function add(uint256 a, uint256 b) internal pure returns (uint256) {
396         uint256 c = a + b;
397         require(c >= a, "SafeMath: addition overflow");
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the subtraction of two unsigned integers, reverting on
404      * overflow (when the result is negative).
405      *
406      * Counterpart to Solidity's `-` operator.
407      *
408      * Requirements:
409      * - Subtraction cannot overflow.
410      */
411     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
412         return sub(a, b, "SafeMath: subtraction overflow");
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
417      * overflow (when the result is negative).
418      *
419      * Counterpart to Solidity's `-` operator.
420      *
421      * Requirements:
422      * - Subtraction cannot overflow.
423      *
424      * _Available since v2.4.0._
425      */
426     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         require(b <= a, errorMessage);
428         uint256 c = a - b;
429 
430         return c;
431     }
432 
433     /**
434      * @dev Returns the multiplication of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `*` operator.
438      *
439      * Requirements:
440      * - Multiplication cannot overflow.
441      */
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
444         // benefit is lost if 'b' is also tested.
445         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
446         if (a == 0) {
447             return 0;
448         }
449 
450         uint256 c = a * b;
451         require(c / a == b, "SafeMath: multiplication overflow");
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers. Reverts on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      * - The divisor cannot be zero.
466      */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         return div(a, b, "SafeMath: division by zero");
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
473      * division by zero. The result is rounded towards zero.
474      *
475      * Counterpart to Solidity's `/` operator. Note: this function uses a
476      * `revert` opcode (which leaves remaining gas untouched) while Solidity
477      * uses an invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      * - The divisor cannot be zero.
481      *
482      * _Available since v2.4.0._
483      */
484     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         // Solidity only automatically asserts when dividing by 0
486         require(b != 0, errorMessage);
487         uint256 c = a / b;
488         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
489 
490         return c;
491     }
492 
493     /**
494     * @dev Integer division of two numbers, rounding up and truncating the quotient
495     */
496     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
497         return divCeil(a, b, "SafeMath: division by zero");
498     }
499 
500     /**
501     * @dev Integer division of two numbers, rounding up and truncating the quotient
502     */
503     function divCeil(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         // Solidity only automatically asserts when dividing by 0
505         require(b != 0, errorMessage);
506 
507         if (a == 0) {
508             return 0;
509         }
510         uint256 c = ((a - 1) / b) + 1;
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * Reverts when dividing by zero.
518      *
519      * Counterpart to Solidity's `%` operator. This function uses a `revert`
520      * opcode (which leaves remaining gas untouched) while Solidity uses an
521      * invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         return mod(a, b, "SafeMath: modulo by zero");
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * Reverts with custom message when dividing by zero.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      * - The divisor cannot be zero.
540      *
541      * _Available since v2.4.0._
542      */
543     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         require(b != 0, errorMessage);
545         return a % b;
546     }
547 
548     function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
549         return _a < _b ? _a : _b;
550     }
551 }
552 
553 /**
554  * @dev Collection of functions related to the address type
555  */
556 library Address {
557     /**
558      * @dev Returns true if `account` is a contract.
559      *
560      * [IMPORTANT]
561      * ====
562      * It is unsafe to assume that an address for which this function returns
563      * false is an externally-owned account (EOA) and not a contract.
564      *
565      * Among others, `isContract` will return false for the following 
566      * types of addresses:
567      *
568      *  - an externally-owned account
569      *  - a contract in construction
570      *  - an address where a contract will be created
571      *  - an address where a contract lived, but was destroyed
572      * ====
573      */
574     function isContract(address account) internal view returns (bool) {
575         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
576         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
577         // for accounts without code, i.e. `keccak256('')`
578         bytes32 codehash;
579         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
580         // solhint-disable-next-line no-inline-assembly
581         assembly { codehash := extcodehash(account) }
582         return (codehash != accountHash && codehash != 0x0);
583     }
584 
585     /**
586      * @dev Converts an `address` into `address payable`. Note that this is
587      * simply a type cast: the actual underlying value is not changed.
588      *
589      * _Available since v2.4.0._
590      */
591     function toPayable(address account) internal pure returns (address payable) {
592         return address(uint160(account));
593     }
594 
595     /**
596      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
597      * `recipient`, forwarding all available gas and reverting on errors.
598      *
599      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
600      * of certain opcodes, possibly making contracts go over the 2300 gas limit
601      * imposed by `transfer`, making them unable to receive funds via
602      * `transfer`. {sendValue} removes this limitation.
603      *
604      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
605      *
606      * IMPORTANT: because control is transferred to `recipient`, care must be
607      * taken to not create reentrancy vulnerabilities. Consider using
608      * {ReentrancyGuard} or the
609      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
610      *
611      * _Available since v2.4.0._
612      */
613     function sendValue(address recipient, uint256 amount) internal {
614         require(address(this).balance >= amount, "Address: insufficient balance");
615 
616         // solhint-disable-next-line avoid-call-value
617         (bool success, ) = recipient.call.value(amount)("");
618         require(success, "Address: unable to send value, recipient may have reverted");
619     }
620 }
621 
622 /**
623  * @title SafeERC20
624  * @dev Wrappers around ERC20 operations that throw on failure (when the token
625  * contract returns false). Tokens that return no value (and instead revert or
626  * throw on failure) are also supported, non-reverting calls are assumed to be
627  * successful.
628  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
629  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
630  */
631 library SafeERC20 {
632     using SafeMath for uint256;
633     using Address for address;
634 
635     function safeTransfer(IERC20 token, address to, uint256 value) internal {
636         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
637     }
638 
639     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
640         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
641     }
642 
643     function safeApprove(IERC20 token, address spender, uint256 value) internal {
644         // safeApprove should only be called when setting an initial allowance,
645         // or when resetting it to zero. To increase and decrease it, use
646         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
647         // solhint-disable-next-line max-line-length
648         require((value == 0) || (token.allowance(address(this), spender) == 0),
649             "SafeERC20: approve from non-zero to non-zero allowance"
650         );
651         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
652     }
653 
654     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
655         uint256 newAllowance = token.allowance(address(this), spender).add(value);
656         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
657     }
658 
659     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
660         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
661         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
662     }
663 
664     /**
665      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
666      * on the return value: the return value is optional (but if data is returned, it must not be false).
667      * @param token The token targeted by the call.
668      * @param data The call data (encoded using abi.encode or one of its variants).
669      */
670     function callOptionalReturn(IERC20 token, bytes memory data) private {
671         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
672         // we're implementing it ourselves.
673 
674         // A Solidity high level call has three parts:
675         //  1. The target address is checked to verify it contains contract code
676         //  2. The call itself is made, and success asserted
677         //  3. The return value is decoded, which in turn checks the size of the returned data.
678         // solhint-disable-next-line max-line-length
679         require(address(token).isContract(), "SafeERC20: call to non-contract");
680 
681         // solhint-disable-next-line avoid-low-level-calls
682         (bool success, bytes memory returndata) = address(token).call(data);
683         require(success, "SafeERC20: low-level call failed");
684 
685         if (returndata.length > 0) { // Return data is optional
686             // solhint-disable-next-line max-line-length
687             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
688         }
689     }
690 }
691 
692 contract LoanStruct {
693     struct Loan {
694         bytes32 id;                 // id of the loan
695         bytes32 loanParamsId;       // the linked loan params id
696         bytes32 pendingTradesId;    // the linked pending trades id
697         uint256 principal;          // total borrowed amount outstanding
698         uint256 collateral;         // total collateral escrowed for the loan
699         uint256 startTimestamp;     // loan start time
700         uint256 endTimestamp;       // for active loans, this is the expected loan end time, for in-active loans, is the actual (past) end time
701         uint256 startMargin;        // initial margin when the loan opened
702         uint256 startRate;          // reference rate when the loan opened for converting collateralToken to loanToken
703         address borrower;           // borrower of this loan
704         address lender;             // lender of this loan
705         bool active;                // if false, the loan has been fully closed
706     }
707 }
708 
709 contract LoanParamsStruct {
710     struct LoanParams {
711         bytes32 id;                 // id of loan params object
712         bool active;                // if false, this object has been disabled by the owner and can't be used for future loans
713         address owner;              // owner of this object
714         address loanToken;          // the token being loaned
715         address collateralToken;    // the required collateral token
716         uint256 minInitialMargin;   // the minimum allowed initial margin
717         uint256 maintenanceMargin;  // an unhealthy loan when current margin is at or below this value
718         uint256 maxLoanTerm;        // the maximum term for new loans (0 means there's no max term)
719     }
720 }
721 
722 contract OrderStruct {
723     struct Order {
724         uint256 lockedAmount;           // escrowed amount waiting for a counterparty
725         uint256 interestRate;           // interest rate defined by the creator of this order
726         uint256 minLoanTerm;            // minimum loan term allowed
727         uint256 maxLoanTerm;            // maximum loan term allowed
728         uint256 createdTimestamp;       // timestamp when this order was created
729         uint256 expirationTimestamp;    // timestamp when this order expires
730     }
731 }
732 
733 contract LenderInterestStruct {
734     struct LenderInterest {
735         uint256 principalTotal;     // total borrowed amount outstanding of asset
736         uint256 owedPerDay;         // interest owed per day for all loans of asset
737         uint256 owedTotal;          // total interest owed for all loans of asset (assuming they go to full term)
738         uint256 paidTotal;          // total interest paid so far for asset
739         uint256 updatedTimestamp;   // last update
740     }
741 }
742 
743 contract LoanInterestStruct {
744     struct LoanInterest {
745         uint256 owedPerDay;         // interest owed per day for loan
746         uint256 depositTotal;       // total escrowed interest for loan
747         uint256 updatedTimestamp;   // last update
748     }
749 }
750 
751 contract Objects is
752     LoanStruct,
753     LoanParamsStruct,
754     OrderStruct,
755     LenderInterestStruct,
756     LoanInterestStruct
757 {}
758 
759 contract State is Constants, Objects, ReentrancyGuard, Ownable {
760     using SafeMath for uint256;
761     using EnumerableBytes32Set for EnumerableBytes32Set.Bytes32Set;
762 
763     address public priceFeeds;                                                          // handles asset reference price lookups
764     address public swapsImpl;                                                           // handles asset swaps using dex liquidity
765 
766     mapping (bytes4 => address) public logicTargets;                                    // implementations of protocol functions
767 
768     mapping (bytes32 => Loan) public loans;                                             // loanId => Loan
769     mapping (bytes32 => LoanParams) public loanParams;                                  // loanParamsId => LoanParams
770 
771     mapping (address => mapping (bytes32 => Order)) public lenderOrders;                // lender => orderParamsId => Order
772     mapping (address => mapping (bytes32 => Order)) public borrowerOrders;              // borrower => orderParamsId => Order
773 
774     mapping (bytes32 => mapping (address => bool)) public delegatedManagers;            // loanId => delegated => approved
775 
776     // Interest
777     mapping (address => mapping (address => LenderInterest)) public lenderInterest;     // lender => loanToken => LenderInterest object
778     mapping (bytes32 => LoanInterest) public loanInterest;                              // loanId => LoanInterest object
779 
780     // Internals
781     EnumerableBytes32Set.Bytes32Set internal logicTargetsSet;                           // implementations set
782     EnumerableBytes32Set.Bytes32Set internal activeLoansSet;                            // active loans set
783 
784     mapping (address => EnumerableBytes32Set.Bytes32Set) internal lenderLoanSets;       // lender loans set
785     mapping (address => EnumerableBytes32Set.Bytes32Set) internal borrowerLoanSets;     // borrow loans set
786     mapping (address => EnumerableBytes32Set.Bytes32Set) internal userLoanParamSets;    // user loan params set
787 
788     address public feesController;                                                      // address controlling fee withdrawals
789 
790     uint256 public lendingFeePercent = 10 ether; // 10% fee                             // fee taken from lender interest payments
791     mapping (address => uint256) public lendingFeeTokensHeld;                           // total interest fees received and not withdrawn per asset
792     mapping (address => uint256) public lendingFeeTokensPaid;                           // total interest fees withdraw per asset (lifetime fees = lendingFeeTokensHeld + lendingFeeTokensPaid)
793 
794     uint256 public tradingFeePercent = 0.15 ether; // 0.15% fee                         // fee paid for each trade
795     mapping (address => uint256) public tradingFeeTokensHeld;                           // total trading fees received and not withdrawn per asset
796     mapping (address => uint256) public tradingFeeTokensPaid;                           // total trading fees withdraw per asset (lifetime fees = tradingFeeTokensHeld + tradingFeeTokensPaid)
797 
798     uint256 public borrowingFeePercent = 0.09 ether; // 0.09% fee                       // origination fee paid for each loan
799     mapping (address => uint256) public borrowingFeeTokensHeld;                         // total borrowing fees received and not withdrawn per asset
800     mapping (address => uint256) public borrowingFeeTokensPaid;                         // total borrowing fees withdraw per asset (lifetime fees = borrowingFeeTokensHeld + borrowingFeeTokensPaid)
801 
802     uint256 public protocolTokenHeld;                                                   // current protocol token deposit balance
803     uint256 public protocolTokenPaid;                                                   // lifetime total payout of protocol token
804 
805     uint256 public affiliateFeePercent = 30 ether; // 30% fee share                     // fee share for affiliate program
806 
807     mapping (address => uint256) public liquidationIncentivePercent;                    // percent discount on collateral for liquidators per collateral asset
808 
809     mapping (address => address) public loanPoolToUnderlying;                           // loanPool => underlying
810     mapping (address => address) public underlyingToLoanPool;                           // underlying => loanPool
811     EnumerableBytes32Set.Bytes32Set internal loanPoolsSet;                              // loan pools set
812 
813     mapping (address => bool) public supportedTokens;                                   // supported tokens for swaps
814 
815     uint256 public maxDisagreement = 5 ether;                                           // % disagreement between swap rate and reference rate
816 
817     uint256 public sourceBufferPercent = 5 ether;                                       // used to estimate kyber swap source amount
818 
819     uint256 public maxSwapSize = 1500 ether;                                            // maximum supported swap size in ETH
820 
821 
822     function _setTarget(
823         bytes4 sig,
824         address target)
825         internal
826     {
827         logicTargets[sig] = target;
828 
829         if (target != address(0)) {
830             logicTargetsSet.addBytes32(bytes32(sig));
831         } else {
832             logicTargetsSet.removeBytes32(bytes32(sig));
833         }
834     }
835 }
836 
837 contract bZxProtocol is State {
838 
839     function()
840         external
841         payable
842     {
843         if (gasleft() <= 2300) {
844             return;
845         }
846 
847         address target = logicTargets[msg.sig];
848         require(target != address(0), "target not active");
849 
850         bytes memory data = msg.data;
851         assembly {
852             let result := delegatecall(gas, target, add(data, 0x20), mload(data), 0, 0)
853             let size := returndatasize
854             let ptr := mload(0x40)
855             returndatacopy(ptr, 0, size)
856             switch result
857             case 0 { revert(ptr, size) }
858             default { return(ptr, size) }
859         }
860     }
861 
862     function replaceContract(
863         address target)
864         external
865         onlyOwner
866     {
867         (bool success,) = target.delegatecall(abi.encodeWithSignature("initialize(address)", target));
868         require(success, "setup failed");
869     }
870 
871     function setTargets(
872         string[] calldata sigsArr,
873         address[] calldata targetsArr)
874         external
875         onlyOwner
876     {
877         require(sigsArr.length == targetsArr.length, "count mismatch");
878 
879         for (uint256 i = 0; i < sigsArr.length; i++) {
880             _setTarget(bytes4(keccak256(abi.encodePacked(sigsArr[i]))), targetsArr[i]);
881         }
882     }
883 
884     function getTarget(
885         string calldata sig)
886         external
887         view
888         returns (address)
889     {
890         return logicTargets[bytes4(keccak256(abi.encodePacked(sig)))];
891     }
892 }