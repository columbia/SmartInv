1 pragma solidity 0.6.12;
2 
3 
4 /**
5     helper methods for interacting with ERC20 tokens that do not consistently return true/false
6     with the addition of a transfer function to send eth or an erc20 token
7 */
8 library TransferHelper {
9     function safeApprove(address token, address to, uint value) internal {
10         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
11         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
12     }
13 
14     function safeTransfer(address token, address to, uint value) internal {
15         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
16         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
17     }
18 
19     function safeTransferFrom(address token, address from, address to, uint value) internal {
20         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
21         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
22     }
23     
24     // sends ETH or an erc20 token
25     function safeTransferBaseToken(address token, address payable to, uint value, bool isERC20) internal {
26         if (!isERC20) {
27             to.transfer(value);
28         } else {
29             (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
30             require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
31         }
32     }
33 }
34 
35 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol
36 // Subject to the MIT license.
37 /**
38  * @dev Library for managing
39  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
40  * types.
41  *
42  * Sets have the following properties:
43  *
44  * - Elements are added, removed, and checked for existence in constant time
45  * (O(1)).
46  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
47  *
48  * ```
49  * contract Example {
50  *     // Add the library methods
51  *     using EnumerableSet for EnumerableSet.AddressSet;
52  *
53  *     // Declare a set state variable
54  *     EnumerableSet.AddressSet private mySet;
55  * }
56  * ```
57  *
58  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
59  * and `uint256` (`UintSet`) are supported.
60  */
61 library EnumerableSet {
62     // To implement this library for multiple types with as little code
63     // repetition as possible, we write it in terms of a generic Set type with
64     // bytes32 values.
65     // The Set implementation uses private functions, and user-facing
66     // implementations (such as AddressSet) are just wrappers around the
67     // underlying Set.
68     // This means that we can only create new EnumerableSets for types that fit
69     // in bytes32.
70 
71     struct Set {
72         // Storage of set values
73         bytes32[] _values;
74 
75         // Position of the value in the `values` array, plus 1 because index 0
76         // means a value is not in the set.
77         mapping (bytes32 => uint256) _indexes;
78     }
79 
80     /**
81      * @dev Add a value to a set. O(1).
82      *
83      * Returns true if the value was added to the set, that is if it was not
84      * already present.
85      */
86     function _add(Set storage set, bytes32 value) private returns (bool) {
87         if (!_contains(set, value)) {
88             set._values.push(value);
89             // The value is stored at length-1, but we add 1 to all indexes
90             // and use 0 as a sentinel value
91             set._indexes[value] = set._values.length;
92             return true;
93         } else {
94             return false;
95         }
96     }
97 
98     /**
99      * @dev Removes a value from a set. O(1).
100      *
101      * Returns true if the value was removed from the set, that is if it was
102      * present.
103      */
104     function _remove(Set storage set, bytes32 value) private returns (bool) {
105         // We read and store the value's index to prevent multiple reads from the same storage slot
106         uint256 valueIndex = set._indexes[value];
107 
108         if (valueIndex != 0) { // Equivalent to contains(set, value)
109             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
110             // the array, and then remove the last element (sometimes called as 'swap and pop').
111             // This modifies the order of the array, as noted in {at}.
112 
113             uint256 toDeleteIndex = valueIndex - 1;
114             uint256 lastIndex = set._values.length - 1;
115 
116             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
117             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
118 
119             bytes32 lastvalue = set._values[lastIndex];
120 
121             // Move the last value to the index where the value to delete is
122             set._values[toDeleteIndex] = lastvalue;
123             // Update the index for the moved value
124             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
125 
126             // Delete the slot where the moved value was stored
127             set._values.pop();
128 
129             // Delete the index for the deleted slot
130             delete set._indexes[value];
131 
132             return true;
133         } else {
134             return false;
135         }
136     }
137 
138     /**
139      * @dev Returns true if the value is in the set. O(1).
140      */
141     function _contains(Set storage set, bytes32 value) private view returns (bool) {
142         return set._indexes[value] != 0;
143     }
144 
145     /**
146      * @dev Returns the number of values on the set. O(1).
147      */
148     function _length(Set storage set) private view returns (uint256) {
149         return set._values.length;
150     }
151 
152    /**
153     * @dev Returns the value stored at position `index` in the set. O(1).
154     *
155     * Note that there are no guarantees on the ordering of values inside the
156     * array, and it may change when more values are added or removed.
157     *
158     * Requirements:
159     *
160     * - `index` must be strictly less than {length}.
161     */
162     function _at(Set storage set, uint256 index) private view returns (bytes32) {
163         require(set._values.length > index, "EnumerableSet: index out of bounds");
164         return set._values[index];
165     }
166 
167     // Bytes32Set
168 
169     struct Bytes32Set {
170         Set _inner;
171     }
172 
173     /**
174      * @dev Add a value to a set. O(1).
175      *
176      * Returns true if the value was added to the set, that is if it was not
177      * already present.
178      */
179     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
180         return _add(set._inner, value);
181     }
182 
183     /**
184      * @dev Removes a value from a set. O(1).
185      *
186      * Returns true if the value was removed from the set, that is if it was
187      * present.
188      */
189     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
190         return _remove(set._inner, value);
191     }
192 
193     /**
194      * @dev Returns true if the value is in the set. O(1).
195      */
196     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
197         return _contains(set._inner, value);
198     }
199 
200     /**
201      * @dev Returns the number of values in the set. O(1).
202      */
203     function length(Bytes32Set storage set) internal view returns (uint256) {
204         return _length(set._inner);
205     }
206 
207    /**
208     * @dev Returns the value stored at position `index` in the set. O(1).
209     *
210     * Note that there are no guarantees on the ordering of values inside the
211     * array, and it may change when more values are added or removed.
212     *
213     * Requirements:
214     *
215     * - `index` must be strictly less than {length}.
216     */
217     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
218         return _at(set._inner, index);
219     }
220 
221     // AddressSet
222 
223     struct AddressSet {
224         Set _inner;
225     }
226 
227     /**
228      * @dev Add a value to a set. O(1).
229      *
230      * Returns true if the value was added to the set, that is if it was not
231      * already present.
232      */
233     function add(AddressSet storage set, address value) internal returns (bool) {
234         return _add(set._inner, bytes32(uint256(value)));
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the value was removed from the set, that is if it was
241      * present.
242      */
243     function remove(AddressSet storage set, address value) internal returns (bool) {
244         return _remove(set._inner, bytes32(uint256(value)));
245     }
246 
247     /**
248      * @dev Returns true if the value is in the set. O(1).
249      */
250     function contains(AddressSet storage set, address value) internal view returns (bool) {
251         return _contains(set._inner, bytes32(uint256(value)));
252     }
253 
254     /**
255      * @dev Returns the number of values in the set. O(1).
256      */
257     function length(AddressSet storage set) internal view returns (uint256) {
258         return _length(set._inner);
259     }
260 
261    /**
262     * @dev Returns the value stored at position `index` in the set. O(1).
263     *
264     * Note that there are no guarantees on the ordering of values inside the
265     * array, and it may change when more values are added or removed.
266     *
267     * Requirements:
268     *
269     * - `index` must be strictly less than {length}.
270     */
271     function at(AddressSet storage set, uint256 index) internal view returns (address) {
272         return address(uint256(_at(set._inner, index)));
273     }
274 
275 
276     // UintSet
277 
278     struct UintSet {
279         Set _inner;
280     }
281 
282     /**
283      * @dev Add a value to a set. O(1).
284      *
285      * Returns true if the value was added to the set, that is if it was not
286      * already present.
287      */
288     function add(UintSet storage set, uint256 value) internal returns (bool) {
289         return _add(set._inner, bytes32(value));
290     }
291 
292     /**
293      * @dev Removes a value from a set. O(1).
294      *
295      * Returns true if the value was removed from the set, that is if it was
296      * present.
297      */
298     function remove(UintSet storage set, uint256 value) internal returns (bool) {
299         return _remove(set._inner, bytes32(value));
300     }
301 
302     /**
303      * @dev Returns true if the value is in the set. O(1).
304      */
305     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
306         return _contains(set._inner, bytes32(value));
307     }
308 
309     /**
310      * @dev Returns the number of values on the set. O(1).
311      */
312     function length(UintSet storage set) internal view returns (uint256) {
313         return _length(set._inner);
314     }
315 
316    /**
317     * @dev Returns the value stored at position `index` in the set. O(1).
318     *
319     * Note that there are no guarantees on the ordering of values inside the
320     * array, and it may change when more values are added or removed.
321     *
322     * Requirements:
323     *
324     * - `index` must be strictly less than {length}.
325     */
326     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
327         return uint256(_at(set._inner, index));
328     }
329 }
330 
331 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
332 // Subject to the MIT license.
333 /**
334  * @dev Wrappers over Solidity's arithmetic operations with added overflow
335  * checks.
336  *
337  * Arithmetic operations in Solidity wrap on overflow. This can easily result
338  * in bugs, because programmers usually assume that an overflow raises an
339  * error, which is the standard behavior in high level programming languages.
340  * `SafeMath` restores this intuition by reverting the transaction when an
341  * operation overflows.
342  *
343  * Using this library instead of the unchecked operations eliminates an entire
344  * class of bugs, so it's recommended to use it always.
345  */
346 library SafeMath {
347     /**
348      * @dev Returns the addition of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `+` operator.
352      *
353      * Requirements:
354      *
355      * - Addition cannot overflow.
356      */
357     function add(uint256 a, uint256 b) internal pure returns (uint256) {
358         uint256 c = a + b;
359         require(c >= a, "SafeMath: addition overflow");
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the subtraction of two unsigned integers, reverting on
366      * overflow (when the result is negative).
367      *
368      * Counterpart to Solidity's `-` operator.
369      *
370      * Requirements:
371      *
372      * - Subtraction cannot overflow.
373      */
374     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375         return sub(a, b, "SafeMath: subtraction overflow");
376     }
377 
378     /**
379      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
380      * overflow (when the result is negative).
381      *
382      * Counterpart to Solidity's `-` operator.
383      *
384      * Requirements:
385      *
386      * - Subtraction cannot overflow.
387      */
388     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b <= a, errorMessage);
390         uint256 c = a - b;
391 
392         return c;
393     }
394 
395     /**
396      * @dev Returns the multiplication of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `*` operator.
400      *
401      * Requirements:
402      *
403      * - Multiplication cannot overflow.
404      */
405     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
407         // benefit is lost if 'b' is also tested.
408         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
409         if (a == 0) {
410             return 0;
411         }
412 
413         uint256 c = a * b;
414         require(c / a == b, "SafeMath: multiplication overflow");
415 
416         return c;
417     }
418 
419     /**
420      * @dev Returns the integer division of two unsigned integers. Reverts on
421      * division by zero. The result is rounded towards zero.
422      *
423      * Counterpart to Solidity's `/` operator. Note: this function uses a
424      * `revert` opcode (which leaves remaining gas untouched) while Solidity
425      * uses an invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function div(uint256 a, uint256 b) internal pure returns (uint256) {
432         return div(a, b, "SafeMath: division by zero");
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator. Note: this function uses a
440      * `revert` opcode (which leaves remaining gas untouched) while Solidity
441      * uses an invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
448         require(b > 0, errorMessage);
449         uint256 c = a / b;
450         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
451 
452         return c;
453     }
454 
455     /**
456      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
457      * Reverts when dividing by zero.
458      *
459      * Counterpart to Solidity's `%` operator. This function uses a `revert`
460      * opcode (which leaves remaining gas untouched) while Solidity uses an
461      * invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
468         return mod(a, b, "SafeMath: modulo by zero");
469     }
470 
471     /**
472      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
473      * Reverts with custom message when dividing by zero.
474      *
475      * Counterpart to Solidity's `%` operator. This function uses a `revert`
476      * opcode (which leaves remaining gas untouched) while Solidity uses an
477      * invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
484         require(b != 0, errorMessage);
485         return a % b;
486     }
487 }
488 
489 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
490 // Subject to the MIT license.
491 /**
492  * @dev Contract module that helps prevent reentrant calls to a function.
493  *
494  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
495  * available, which can be applied to functions to make sure there are no nested
496  * (reentrant) calls to them.
497  *
498  * Note that because there is a single `nonReentrant` guard, functions marked as
499  * `nonReentrant` may not call one another. This can be worked around by making
500  * those functions `private`, and then adding `external` `nonReentrant` entry
501  * points to them.
502  *
503  * TIP: If you would like to learn more about reentrancy and alternative ways
504  * to protect against it, check out our blog post
505  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
506  */
507 abstract contract ReentrancyGuard {
508     // Booleans are more expensive than uint256 or any type that takes up a full
509     // word because each write operation emits an extra SLOAD to first read the
510     // slot's contents, replace the bits taken up by the boolean, and then write
511     // back. This is the compiler's defense against contract upgrades and
512     // pointer aliasing, and it cannot be disabled.
513 
514     // The values being non-zero value makes deployment a bit more expensive,
515     // but in exchange the refund on every call to nonReentrant will be lower in
516     // amount. Since refunds are capped to a percentage of the total
517     // transaction's gas, it is best to keep them low in cases like this one, to
518     // increase the likelihood of the full refund coming into effect.
519     uint256 private constant _NOT_ENTERED = 1;
520     uint256 private constant _ENTERED = 2;
521 
522     uint256 private _status;
523 
524     constructor () internal {
525         _status = _NOT_ENTERED;
526     }
527 
528     /**
529      * @dev Prevents a contract from calling itself, directly or indirectly.
530      * Calling a `nonReentrant` function from another `nonReentrant`
531      * function is not supported. It is possible to prevent this from happening
532      * by making the `nonReentrant` function external, and make it call a
533      * `private` function that does the actual work.
534      */
535     modifier nonReentrant() {
536         // On the first call to nonReentrant, _notEntered will be true
537         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
538 
539         // Any calls to nonReentrant after this point will fail
540         _status = _ENTERED;
541 
542         _;
543 
544         // By storing the original value once again, a refund is triggered (see
545         // https://eips.ethereum.org/EIPS/eip-2200)
546         _status = _NOT_ENTERED;
547     }
548 }
549 
550 interface IERC20 {
551     event Approval(address indexed owner, address indexed spender, uint value);
552     event Transfer(address indexed from, address indexed to, uint value);
553 
554     function decimals() external view returns (uint8);
555     function totalSupply() external view returns (uint);
556     function balanceOf(address owner) external view returns (uint);
557     function allowance(address owner, address spender) external view returns (uint);
558 
559     function approve(address spender, uint value) external returns (bool);
560     function transfer(address to, uint value) external returns (bool);
561     function transferFrom(address from, address to, uint value) external returns (bool);
562 }
563 
564 // SpacePort v.1
565 interface IPlasmaswapFactory {
566     function getPair(address tokenA, address tokenB) external view returns (address pair);
567     function createPair(address tokenA, address tokenB) external returns (address pair);
568 }
569 
570 interface ISpaceportLockForwarder {
571     function lockLiquidity (IERC20 _baseToken, IERC20 _saleToken, uint256 _baseAmount, uint256 _saleAmount, uint256 _unlock_date, address payable _withdrawer) external;
572     function plasmaswapPairIsInitialised (address _token0, address _token1) external view returns (bool);
573 }
574 
575 interface IWETH {
576     function deposit() external payable;
577     function transfer(address to, uint value) external returns (bool);
578     function withdraw(uint) external;
579 }
580 
581 interface ISpaceportSettings {
582     function getMaxSpaceportLength () external view returns (uint256);
583     function getRound1Length () external view returns (uint256);
584     function userHoldsSufficientRound1Token (address _user) external view returns (bool);
585     function getBaseFee () external view returns (uint256);
586     function getTokenFee () external view returns (uint256);
587     function getEthAddress () external view returns (address payable);
588     function getTokenAddress () external view returns (address payable);
589     function getEthCreationFee () external view returns (uint256);
590 }
591 
592 contract Spaceportv1 is ReentrancyGuard {
593   using SafeMath for uint256;
594   using EnumerableSet for EnumerableSet.AddressSet;
595   
596   event spaceportUserDeposit(uint256 value);
597   event spaceportUserWithdrawTokens(uint256 value);
598   event spaceportUserWithdrawBaseTokens(uint256 value);
599   event spaceportOwnerWithdrawTokens();
600   event spaceportAddLiquidity();
601 
602   /// @notice Spaceport Contract Version, used to choose the correct ABI to decode the contract
603   uint256 public CONTRACT_VERSION = 1;
604   
605   struct SpaceportInfo {
606     address payable SPACEPORT_OWNER;
607     IERC20 S_TOKEN; // sale token
608     IERC20 B_TOKEN; // base token // usually WETH (ETH)
609     uint256 TOKEN_PRICE; // 1 base token = ? s_tokens, fixed price
610     uint256 MAX_SPEND_PER_BUYER; // maximum base token BUY amount per account
611     uint256 AMOUNT; // the amount of spaceport tokens up for presale
612     uint256 HARDCAP;
613     uint256 SOFTCAP;
614     uint256 LIQUIDITY_PERCENT; // divided by 1000 - to be locked !
615     uint256 LISTING_RATE; // fixed rate at which the token will list on plasmaswap - start rate
616     uint256 START_BLOCK;
617     uint256 END_BLOCK;
618     uint256 LOCK_PERIOD; // unix timestamp -> e.g. 2 weeks
619     bool SPACEPORT_IN_ETH; // if this flag is true the Spaceport is raising ETH, otherwise an ERC20 token such as DAI
620   }
621 
622   struct SpaceportVesting {
623     uint256 vestingCliff;
624     uint256 vestingEnd;
625   }
626 
627   struct SpaceportFeeInfo {
628     uint256 PLFI_BASE_FEE; // divided by 1000
629     uint256 PLFI_TOKEN_FEE; // divided by 1000
630     address payable BASE_FEE_ADDRESS;
631     address payable TOKEN_FEE_ADDRESS;
632   }
633   
634   struct SpaceportStatus {
635     bool WHITELIST_ONLY; // if set to true only whitelisted members may participate
636     bool LP_GENERATION_COMPLETE; // final flag required to end a Spaceport and enable withdrawls
637     bool FORCE_FAILED; // set this flag to force fail the Spaceport
638     uint256 TOTAL_BASE_COLLECTED; // total base currency raised (usually ETH)
639     uint256 TOTAL_TOKENS_SOLD; // total Spaceport tokens sold
640     uint256 TOTAL_TOKENS_WITHDRAWN; // total tokens withdrawn post successful Spaceport
641     uint256 TOTAL_BASE_WITHDRAWN; // total base tokens withdrawn on Spaceport failure
642     uint256 ROUND1_LENGTH; // in blocks
643     uint256 NUM_BUYERS; // number of unique participants
644     uint256 LP_GENERATION_COMPLETE_TIME;  //  the date when LP is done
645   }
646 
647   struct BuyerInfo {
648     uint256 baseDeposited; // total base token (usually ETH) deposited by user, can be withdrawn on presale failure
649     uint256 tokensOwed; // num Spaceport tokens a user is owed, can be withdrawn on presale success
650     uint256 lastUpdate;
651     uint256 vestingTokens;
652     uint256 vestingTokensOwed;
653     bool vestingRunning;
654   }
655   
656   SpaceportVesting public SPACEPORT_VESTING;
657   SpaceportInfo public SPACEPORT_INFO;
658   SpaceportFeeInfo public SPACEPORT_FEE_INFO;
659   SpaceportStatus public STATUS;
660   address public SPACEPORT_GENERATOR;
661   ISpaceportLockForwarder public SPACEPORT_LOCK_FORWARDER;
662   ISpaceportSettings public SPACEPORT_SETTINGS;
663   address PLFI_DEV_ADDRESS;
664   IPlasmaswapFactory public PLASMASWAP_FACTORY;
665   IWETH public WETH;
666   mapping(address => BuyerInfo) public BUYERS;
667   EnumerableSet.AddressSet private WHITELIST;
668 
669   constructor(address _spaceportGenerator) public {
670     SPACEPORT_GENERATOR = _spaceportGenerator;
671     PLASMASWAP_FACTORY = IPlasmaswapFactory(0xd87Ad19db2c4cCbf897106dE034D52e3DD90ea60);
672     WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
673     SPACEPORT_SETTINGS = ISpaceportSettings(0x90De443BDC372f9aA944cF18fb6c82980807Cb0a);
674     SPACEPORT_LOCK_FORWARDER = ISpaceportLockForwarder(0x5AD2A6181B1bc6aCAbd7bad268102d68DE54A4eE);
675     PLFI_DEV_ADDRESS = 0x37CB8941348f04E783f67E19AD937f48DD7355D9;
676   }
677   
678   function init1 (
679     address payable _spaceportOwner, 
680     uint256 _amount,
681     uint256 _tokenPrice, 
682     uint256 _maxEthPerBuyer, 
683     uint256 _hardcap, 
684     uint256 _softcap,
685     uint256 _liquidityPercent,
686     uint256 _listingRate,
687     uint256 _startblock,
688     uint256 _endblock,
689     uint256 _lockPeriod
690     ) external {
691           
692       require(msg.sender == SPACEPORT_GENERATOR, 'FORBIDDEN');
693       SPACEPORT_INFO.SPACEPORT_OWNER = _spaceportOwner;
694       SPACEPORT_INFO.AMOUNT = _amount;
695       SPACEPORT_INFO.TOKEN_PRICE = _tokenPrice;
696       SPACEPORT_INFO.MAX_SPEND_PER_BUYER = _maxEthPerBuyer;
697       SPACEPORT_INFO.HARDCAP = _hardcap;
698       SPACEPORT_INFO.SOFTCAP = _softcap;
699       SPACEPORT_INFO.LIQUIDITY_PERCENT = _liquidityPercent;
700       SPACEPORT_INFO.LISTING_RATE = _listingRate;
701       SPACEPORT_INFO.START_BLOCK = _startblock;
702       SPACEPORT_INFO.END_BLOCK = _endblock;
703       SPACEPORT_INFO.LOCK_PERIOD = _lockPeriod;
704   }
705   
706   function init2 (
707     IERC20 _baseToken,
708     IERC20 _spaceportToken,
709     uint256 _plfiBaseFee,
710     uint256 _plfiTokenFee,
711     address payable _baseFeeAddress,
712     address payable _tokenFeeAddress,
713     uint256 _vestingCliff,
714     uint256 _vestingEnd
715     ) external {
716           
717       require(msg.sender == SPACEPORT_GENERATOR, 'FORBIDDEN');
718       // require(!SPACEPORT_LOCK_FORWARDER.plasmaswapPairIsInitialised(address(_spaceportToken), address(_baseToken)), 'PAIR INITIALISED');
719       
720       SPACEPORT_INFO.SPACEPORT_IN_ETH = address(_baseToken) == address(WETH);
721       SPACEPORT_INFO.S_TOKEN = _spaceportToken;
722       SPACEPORT_INFO.B_TOKEN = _baseToken;
723       SPACEPORT_FEE_INFO.PLFI_BASE_FEE = _plfiBaseFee;
724       SPACEPORT_FEE_INFO.PLFI_TOKEN_FEE = _plfiTokenFee;
725       
726       SPACEPORT_FEE_INFO.BASE_FEE_ADDRESS = _baseFeeAddress;
727       SPACEPORT_FEE_INFO.TOKEN_FEE_ADDRESS = _tokenFeeAddress;
728       STATUS.ROUND1_LENGTH = SPACEPORT_SETTINGS.getRound1Length();
729 
730       SPACEPORT_VESTING.vestingCliff = _vestingCliff;
731       SPACEPORT_VESTING.vestingEnd = _vestingEnd;
732   }
733   
734   modifier onlySpaceportOwner() {
735     require(SPACEPORT_INFO.SPACEPORT_OWNER == msg.sender, "NOT SPACEPORT OWNER");
736     _;
737   }
738   
739   function spaceportStatus () public view returns (uint256) {
740     if (STATUS.FORCE_FAILED) {
741       return 3; // FAILED - force fail
742     }
743     if ((block.number > SPACEPORT_INFO.END_BLOCK) && (STATUS.TOTAL_BASE_COLLECTED < SPACEPORT_INFO.SOFTCAP)) {
744       return 3; // FAILED - softcap not met by end block
745     }
746     if (STATUS.TOTAL_BASE_COLLECTED >= SPACEPORT_INFO.HARDCAP) {
747       return 2; // SUCCESS - hardcap met
748     }
749     if ((block.number > SPACEPORT_INFO.END_BLOCK) && (STATUS.TOTAL_BASE_COLLECTED >= SPACEPORT_INFO.SOFTCAP)) {
750       return 2; // SUCCESS - endblock and soft cap reached
751     }
752     if ((block.number >= SPACEPORT_INFO.START_BLOCK) && (block.number <= SPACEPORT_INFO.END_BLOCK)) {
753       return 1; // ACTIVE - deposits enabled
754     }
755     return 0; // QUED - awaiting start block
756   }
757   
758   // accepts msg.value for eth or _amount for ERC20 tokens
759   function userDeposit (uint256 _amount) external payable nonReentrant {
760     require(spaceportStatus() == 1, 'NOT ACTIVE'); // ACTIVE
761     if (STATUS.WHITELIST_ONLY) {
762       require(WHITELIST.contains(msg.sender), 'NOT WHITELISTED');
763     }
764     // Spaceport Round 1 - require participant to hold a certain token and balance
765     if (block.number < SPACEPORT_INFO.START_BLOCK + STATUS.ROUND1_LENGTH) { // 276 blocks = 1 hour
766         require(SPACEPORT_SETTINGS.userHoldsSufficientRound1Token(msg.sender), 'INSUFFICENT ROUND 1 TOKEN BALANCE');
767     }
768     BuyerInfo storage buyer = BUYERS[msg.sender];
769     uint256 amount_in = SPACEPORT_INFO.SPACEPORT_IN_ETH ? msg.value : _amount;
770     uint256 allowance = SPACEPORT_INFO.MAX_SPEND_PER_BUYER.sub(buyer.baseDeposited);
771     uint256 remaining = SPACEPORT_INFO.HARDCAP - STATUS.TOTAL_BASE_COLLECTED;
772     allowance = allowance > remaining ? remaining : allowance;
773     if (amount_in > allowance) {
774       amount_in = allowance;
775     }
776     uint256 tokensSold = amount_in.mul(SPACEPORT_INFO.TOKEN_PRICE).div(10 ** uint256(SPACEPORT_INFO.B_TOKEN.decimals()));
777     require(tokensSold > 0, 'ZERO TOKENS');
778     if (buyer.baseDeposited == 0) {
779         STATUS.NUM_BUYERS++;
780     }
781 
782     buyer.baseDeposited = buyer.baseDeposited.add(amount_in);
783     buyer.tokensOwed = buyer.tokensOwed.add(tokensSold);
784     buyer.vestingRunning = false;
785 
786     STATUS.TOTAL_BASE_COLLECTED = STATUS.TOTAL_BASE_COLLECTED.add(amount_in);
787     STATUS.TOTAL_TOKENS_SOLD = STATUS.TOTAL_TOKENS_SOLD.add(tokensSold);
788     
789     // return unused ETH
790     if (SPACEPORT_INFO.SPACEPORT_IN_ETH && amount_in < msg.value) {
791       msg.sender.transfer(msg.value.sub(amount_in));
792     }
793     // deduct non ETH token from user
794     if (!SPACEPORT_INFO.SPACEPORT_IN_ETH) {
795       TransferHelper.safeTransferFrom(address(SPACEPORT_INFO.B_TOKEN), msg.sender, address(this), amount_in);
796     }
797     emit spaceportUserDeposit(amount_in);
798   }
799   
800   // withdraw spaceport tokens
801   // percentile withdrawls allows fee on transfer or rebasing tokens to still work
802   function userWithdrawTokens () external nonReentrant {
803     require(STATUS.LP_GENERATION_COMPLETE, 'AWAITING LP GENERATION');
804     BuyerInfo storage buyer = BUYERS[msg.sender];
805     require(STATUS.LP_GENERATION_COMPLETE_TIME + SPACEPORT_VESTING.vestingCliff < block.timestamp, "vesting cliff : not time yet");
806 
807     uint256 tokensRemainingDenominator = STATUS.TOTAL_TOKENS_SOLD.sub(STATUS.TOTAL_TOKENS_WITHDRAWN);
808     require(tokensRemainingDenominator > 0, 'NOTHING TO WITHDRAW');
809 
810     uint256 tokensOwed = SPACEPORT_INFO.S_TOKEN.balanceOf(address(this)).mul(buyer.tokensOwed).div(tokensRemainingDenominator);
811     require(tokensOwed > 0, 'OWED TOKENS NOT FOUND');
812     
813     if(!buyer.vestingRunning)
814     {
815       buyer.vestingTokens = tokensOwed;
816       buyer.vestingTokensOwed = buyer.tokensOwed;
817       buyer.lastUpdate = STATUS.LP_GENERATION_COMPLETE_TIME;
818       buyer.vestingRunning = true;
819     }
820 
821     if(STATUS.LP_GENERATION_COMPLETE_TIME + SPACEPORT_VESTING.vestingEnd < block.timestamp) {
822       STATUS.TOTAL_TOKENS_WITHDRAWN = STATUS.TOTAL_TOKENS_WITHDRAWN.add(buyer.tokensOwed);
823       buyer.tokensOwed = 0;
824     } 
825     else {
826       tokensOwed = buyer.vestingTokens.mul(block.timestamp - buyer.lastUpdate).div(SPACEPORT_VESTING.vestingEnd);
827       buyer.lastUpdate = block.timestamp;
828 
829       uint256 diff = tokensOwed.div(buyer.vestingTokens);
830       STATUS.TOTAL_TOKENS_WITHDRAWN = STATUS.TOTAL_TOKENS_WITHDRAWN.add(buyer.vestingTokensOwed.mul(diff));
831 
832       buyer.tokensOwed = buyer.tokensOwed.sub(buyer.vestingTokensOwed.mul(diff));
833       require(buyer.tokensOwed > 0, 'NOTHING TO CLAIM');
834     }
835 
836     TransferHelper.safeTransfer(address(SPACEPORT_INFO.S_TOKEN), msg.sender, tokensOwed);
837     emit spaceportUserWithdrawTokens(tokensOwed);
838   }
839   
840   // on spaceport failure
841   // percentile withdrawls allows fee on transfer or rebasing tokens to still work
842   function userWithdrawBaseTokens () external nonReentrant {
843     require(spaceportStatus() == 3, 'NOT FAILED'); // FAILED
844     BuyerInfo storage buyer = BUYERS[msg.sender];
845     uint256 baseRemainingDenominator = STATUS.TOTAL_BASE_COLLECTED.sub(STATUS.TOTAL_BASE_WITHDRAWN);
846     uint256 remainingBaseBalance = SPACEPORT_INFO.SPACEPORT_IN_ETH ? address(this).balance : SPACEPORT_INFO.B_TOKEN.balanceOf(address(this));
847     uint256 tokensOwed = remainingBaseBalance.mul(buyer.baseDeposited).div(baseRemainingDenominator);
848     require(tokensOwed > 0, 'NOTHING TO WITHDRAW');
849     STATUS.TOTAL_BASE_WITHDRAWN = STATUS.TOTAL_BASE_WITHDRAWN.add(buyer.baseDeposited);
850     buyer.baseDeposited = 0;
851     TransferHelper.safeTransferBaseToken(address(SPACEPORT_INFO.B_TOKEN), msg.sender, tokensOwed, !SPACEPORT_INFO.SPACEPORT_IN_ETH);
852     emit spaceportUserWithdrawBaseTokens(tokensOwed);
853   }
854   
855   // failure
856   // allows the owner to withdraw the tokens they sent for presale & initial liquidity
857   function ownerWithdrawTokens () external onlySpaceportOwner {
858     require(spaceportStatus() == 3); // FAILED
859     TransferHelper.safeTransfer(address(SPACEPORT_INFO.S_TOKEN), SPACEPORT_INFO.SPACEPORT_OWNER, SPACEPORT_INFO.S_TOKEN.balanceOf(address(this)));
860     emit spaceportOwnerWithdrawTokens();
861   }
862   
863 
864   // Can be called at any stage before or during the presale to cancel it before it ends.
865   // If the pair already exists on plasmaswap and it contains the presale token as liquidity 
866   // the final stage of the presale 'addLiquidity()' will fail. This function 
867   // allows anyone to end the presale prematurely to release funds in such a case.
868   function forceFailIfPairExists () external {
869     require(!STATUS.LP_GENERATION_COMPLETE && !STATUS.FORCE_FAILED);
870     if (SPACEPORT_LOCK_FORWARDER.plasmaswapPairIsInitialised(address(SPACEPORT_INFO.S_TOKEN), address(SPACEPORT_INFO.B_TOKEN))) {
871         STATUS.FORCE_FAILED = true;
872     }
873   }
874   
875   // if something goes wrong in LP generation
876   function forceFailByPlfi () external {
877       require(msg.sender == PLFI_DEV_ADDRESS);
878       STATUS.FORCE_FAILED = true;
879   }
880   
881   // on spaceport success, this is the final step to end the spaceport, lock liquidity and enable withdrawls of the sale token.
882   // This function does not use percentile distribution. Rebasing mechanisms, fee on transfers, or any deflationary logic
883   // are not taken into account at this stage to ensure stated liquidity is locked and the pool is initialised according to 
884   // the spaceport parameters and fixed prices.
885   function addLiquidity() external nonReentrant {
886     require(!STATUS.LP_GENERATION_COMPLETE, 'GENERATION COMPLETE');
887     require(spaceportStatus() == 2, 'NOT SUCCESS'); // SUCCESS
888     // Fail the spaceport if the pair exists and contains spaceport token liquidity
889     if (SPACEPORT_LOCK_FORWARDER.plasmaswapPairIsInitialised(address(SPACEPORT_INFO.S_TOKEN), address(SPACEPORT_INFO.B_TOKEN))) {
890         STATUS.FORCE_FAILED = true;
891         return;
892     }
893     
894     uint256 plfiBaseFee = STATUS.TOTAL_BASE_COLLECTED.mul(SPACEPORT_FEE_INFO.PLFI_BASE_FEE).div(1000);
895     
896     // base token liquidity
897     uint256 baseLiquidity = STATUS.TOTAL_BASE_COLLECTED.sub(plfiBaseFee).mul(SPACEPORT_INFO.LIQUIDITY_PERCENT).div(1000);
898     if (SPACEPORT_INFO.SPACEPORT_IN_ETH) {
899         WETH.deposit{value : baseLiquidity}();
900     }
901     TransferHelper.safeApprove(address(SPACEPORT_INFO.B_TOKEN), address(SPACEPORT_LOCK_FORWARDER), baseLiquidity);
902     
903     // sale token liquidity
904     uint256 tokenLiquidity = baseLiquidity.mul(SPACEPORT_INFO.LISTING_RATE).div(10 ** uint256(SPACEPORT_INFO.B_TOKEN.decimals()));
905     TransferHelper.safeApprove(address(SPACEPORT_INFO.S_TOKEN), address(SPACEPORT_LOCK_FORWARDER), tokenLiquidity);
906     
907     SPACEPORT_LOCK_FORWARDER.lockLiquidity(SPACEPORT_INFO.B_TOKEN, SPACEPORT_INFO.S_TOKEN, baseLiquidity, tokenLiquidity, block.timestamp + SPACEPORT_INFO.LOCK_PERIOD, SPACEPORT_INFO.SPACEPORT_OWNER);
908     
909     // transfer fees
910     uint256 plfiTokenFee = STATUS.TOTAL_TOKENS_SOLD.mul(SPACEPORT_FEE_INFO.PLFI_TOKEN_FEE).div(1000);
911     TransferHelper.safeTransferBaseToken(address(SPACEPORT_INFO.B_TOKEN), SPACEPORT_FEE_INFO.BASE_FEE_ADDRESS, plfiBaseFee, !SPACEPORT_INFO.SPACEPORT_IN_ETH);
912     TransferHelper.safeTransfer(address(SPACEPORT_INFO.S_TOKEN), SPACEPORT_FEE_INFO.TOKEN_FEE_ADDRESS, plfiTokenFee);
913     
914     // burn unsold tokens
915     uint256 remainingSBalance = SPACEPORT_INFO.S_TOKEN.balanceOf(address(this));
916     if (remainingSBalance > STATUS.TOTAL_TOKENS_SOLD) {
917         uint256 burnAmount = remainingSBalance.sub(STATUS.TOTAL_TOKENS_SOLD);
918         TransferHelper.safeTransfer(address(SPACEPORT_INFO.S_TOKEN), 0x6Ad6fd6282cCe6eBB65Ab8aBCBD1ae5057D4B1DB, burnAmount);
919     }
920     
921     // send remaining base tokens to spaceport owner
922     uint256 remainingBaseBalance = SPACEPORT_INFO.SPACEPORT_IN_ETH ? address(this).balance : SPACEPORT_INFO.B_TOKEN.balanceOf(address(this));
923     TransferHelper.safeTransferBaseToken(address(SPACEPORT_INFO.B_TOKEN), SPACEPORT_INFO.SPACEPORT_OWNER, remainingBaseBalance, !SPACEPORT_INFO.SPACEPORT_IN_ETH);
924     
925     STATUS.LP_GENERATION_COMPLETE = true;
926     STATUS.LP_GENERATION_COMPLETE_TIME = block.timestamp;
927     
928     emit spaceportAddLiquidity();
929   }
930   
931   function updateMaxSpendLimit(uint256 _maxSpend) external onlySpaceportOwner {
932     SPACEPORT_INFO.MAX_SPEND_PER_BUYER = _maxSpend;
933   }
934   
935   // postpone or bring a spaceport forward, this will only work when a presale is inactive.
936   function updateBlocks(uint256 _startBlock, uint256 _endBlock) external onlySpaceportOwner {
937     require(SPACEPORT_INFO.START_BLOCK > block.number);
938     require(_endBlock.sub(_startBlock) <= SPACEPORT_SETTINGS.getMaxSpaceportLength());
939     SPACEPORT_INFO.START_BLOCK = _startBlock;
940     SPACEPORT_INFO.END_BLOCK = _endBlock;
941   }
942 
943   // editable at any stage of the presale
944   function setWhitelistFlag(bool _flag) external onlySpaceportOwner {
945     STATUS.WHITELIST_ONLY = _flag;
946   }
947 
948   // editable at any stage of the presale
949   function editWhitelist(address[] memory _users, bool _add) external onlySpaceportOwner {
950     if (_add) {
951         for (uint i = 0; i < _users.length; i++) {
952           WHITELIST.add(_users[i]);
953         }
954     } else {
955         for (uint i = 0; i < _users.length; i++) {
956           WHITELIST.remove(_users[i]);
957         }
958     }
959   }
960 
961   // whitelist getters
962   function getWhitelistedUsersLength () external view returns (uint256) {
963     return WHITELIST.length();
964   }
965   
966   function getWhitelistedUserAtIndex (uint256 _index) external view returns (address) {
967     return WHITELIST.at(_index);
968   }
969   
970   function getUserWhitelistStatus (address _user) external view returns (bool) {
971     return WHITELIST.contains(_user);
972   }
973 }