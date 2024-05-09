1 pragma solidity 0.6.11;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * @dev Library for managing
37  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
38  * types.
39  *
40  * Sets have the following properties:
41  *
42  * - Elements are added, removed, and checked for existence in constant time
43  * (O(1)).
44  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
45  *
46  * ```
47  * contract Example {
48  *     // Add the library methods
49  *     using EnumerableSet for EnumerableSet.AddressSet;
50  *
51  *     // Declare a set state variable
52  *     EnumerableSet.AddressSet private mySet;
53  * }
54  * ```
55  *
56  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
57  * (`UintSet`) are supported.
58  */
59 library EnumerableSet {
60     // To implement this library for multiple types with as little code
61     // repetition as possible, we write it in terms of a generic Set type with
62     // bytes32 values.
63     // The Set implementation uses private functions, and user-facing
64     // implementations (such as AddressSet) are just wrappers around the
65     // underlying Set.
66     // This means that we can only create new EnumerableSets for types that fit
67     // in bytes32.
68 
69     struct Set {
70         // Storage of set values
71         bytes32[] _values;
72 
73         // Position of the value in the `values` array, plus 1 because index 0
74         // means a value is not in the set.
75         mapping (bytes32 => uint256) _indexes;
76     }
77 
78     /**
79      * @dev Add a value to a set. O(1).
80      *
81      * Returns true if the value was added to the set, that is if it was not
82      * already present.
83      */
84     function _add(Set storage set, bytes32 value) private returns (bool) {
85         if (!_contains(set, value)) {
86             set._values.push(value);
87             // The value is stored at length-1, but we add 1 to all indexes
88             // and use 0 as a sentinel value
89             set._indexes[value] = set._values.length;
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     /**
97      * @dev Removes a value from a set. O(1).
98      *
99      * Returns true if the value was removed from the set, that is if it was
100      * present.
101      */
102     function _remove(Set storage set, bytes32 value) private returns (bool) {
103         // We read and store the value's index to prevent multiple reads from the same storage slot
104         uint256 valueIndex = set._indexes[value];
105 
106         if (valueIndex != 0) { // Equivalent to contains(set, value)
107             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
108             // the array, and then remove the last element (sometimes called as 'swap and pop').
109             // This modifies the order of the array, as noted in {at}.
110 
111             uint256 toDeleteIndex = valueIndex - 1;
112             uint256 lastIndex = set._values.length - 1;
113 
114             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
115             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
116 
117             bytes32 lastvalue = set._values[lastIndex];
118 
119             // Move the last value to the index where the value to delete is
120             set._values[toDeleteIndex] = lastvalue;
121             // Update the index for the moved value
122             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
123 
124             // Delete the slot where the moved value was stored
125             set._values.pop();
126 
127             // Delete the index for the deleted slot
128             delete set._indexes[value];
129 
130             return true;
131         } else {
132             return false;
133         }
134     }
135 
136     /**
137      * @dev Returns true if the value is in the set. O(1).
138      */
139     function _contains(Set storage set, bytes32 value) private view returns (bool) {
140         return set._indexes[value] != 0;
141     }
142 
143     /**
144      * @dev Returns the number of values on the set. O(1).
145      */
146     function _length(Set storage set) private view returns (uint256) {
147         return set._values.length;
148     }
149 
150    /**
151     * @dev Returns the value stored at position `index` in the set. O(1).
152     *
153     * Note that there are no guarantees on the ordering of values inside the
154     * array, and it may change when more values are added or removed.
155     *
156     * Requirements:
157     *
158     * - `index` must be strictly less than {length}.
159     */
160     function _at(Set storage set, uint256 index) private view returns (bytes32) {
161         require(set._values.length > index, "EnumerableSet: index out of bounds");
162         return set._values[index];
163     }
164 
165     // AddressSet
166 
167     struct AddressSet {
168         Set _inner;
169     }
170 
171     /**
172      * @dev Add a value to a set. O(1).
173      *
174      * Returns true if the value was added to the set, that is if it was not
175      * already present.
176      */
177     function add(AddressSet storage set, address value) internal returns (bool) {
178         return _add(set._inner, bytes32(uint256(value)));
179     }
180 
181     /**
182      * @dev Removes a value from a set. O(1).
183      *
184      * Returns true if the value was removed from the set, that is if it was
185      * present.
186      */
187     function remove(AddressSet storage set, address value) internal returns (bool) {
188         return _remove(set._inner, bytes32(uint256(value)));
189     }
190 
191     /**
192      * @dev Returns true if the value is in the set. O(1).
193      */
194     function contains(AddressSet storage set, address value) internal view returns (bool) {
195         return _contains(set._inner, bytes32(uint256(value)));
196     }
197 
198     /**
199      * @dev Returns the number of values in the set. O(1).
200      */
201     function length(AddressSet storage set) internal view returns (uint256) {
202         return _length(set._inner);
203     }
204 
205    /**
206     * @dev Returns the value stored at position `index` in the set. O(1).
207     *
208     * Note that there are no guarantees on the ordering of values inside the
209     * array, and it may change when more values are added or removed.
210     *
211     * Requirements:
212     *
213     * - `index` must be strictly less than {length}.
214     */
215     function at(AddressSet storage set, uint256 index) internal view returns (address) {
216         return address(uint256(_at(set._inner, index)));
217     }
218 
219 
220     // UintSet
221 
222     struct UintSet {
223         Set _inner;
224     }
225 
226     /**
227      * @dev Add a value to a set. O(1).
228      *
229      * Returns true if the value was added to the set, that is if it was not
230      * already present.
231      */
232     function add(UintSet storage set, uint256 value) internal returns (bool) {
233         return _add(set._inner, bytes32(value));
234     }
235 
236     /**
237      * @dev Removes a value from a set. O(1).
238      *
239      * Returns true if the value was removed from the set, that is if it was
240      * present.
241      */
242     function remove(UintSet storage set, uint256 value) internal returns (bool) {
243         return _remove(set._inner, bytes32(value));
244     }
245 
246     /**
247      * @dev Returns true if the value is in the set. O(1).
248      */
249     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
250         return _contains(set._inner, bytes32(value));
251     }
252 
253     /**
254      * @dev Returns the number of values on the set. O(1).
255      */
256     function length(UintSet storage set) internal view returns (uint256) {
257         return _length(set._inner);
258     }
259 
260    /**
261     * @dev Returns the value stored at position `index` in the set. O(1).
262     *
263     * Note that there are no guarantees on the ordering of values inside the
264     * array, and it may change when more values are added or removed.
265     *
266     * Requirements:
267     *
268     * - `index` must be strictly less than {length}.
269     */
270     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
271         return uint256(_at(set._inner, index));
272     }
273 }
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { size := extcodesize(account) }
304         return size > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: value }(data);
390         return _verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
400         return functionStaticCall(target, data, "Address: low-level static call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.3._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.3._
432      */
433     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.delegatecall(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 /**
462  * @title Ownable
463  * @dev The Ownable contract has an owner address, and provides basic authorization control
464  * functions, this simplifies the implementation of "user permissions".
465  */
466 contract Ownable {
467   address public owner;
468 
469 
470   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472 
473   /**
474    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
475    * account.
476    */
477   constructor() public {
478     owner = msg.sender;
479   }
480 
481 
482   /**
483    * @dev Throws if called by any account other than the owner.
484    */
485   modifier onlyOwner() {
486     require(msg.sender == owner);
487     _;
488   }
489 
490 
491   /**
492    * @dev Allows the current owner to transfer control of the contract to a newOwner.
493    * @param newOwner The address to transfer ownership to.
494    */
495   function transferOwnership(address newOwner) onlyOwner public {
496     require(newOwner != address(0));
497     emit OwnershipTransferred(owner, newOwner);
498     owner = newOwner;
499   }
500 }
501 
502 interface Token {
503     function approve(address, uint) external returns (bool);
504     function balanceOf(address) external view returns (uint);
505     function transferFrom(address, address, uint) external returns (bool);
506     function transfer(address, uint) external returns (bool);
507 }
508 
509 interface OldIERC20 {
510     function transfer(address, uint) external;
511 }
512 
513 interface IUniswapV2Router01 {
514     function factory() external pure returns (address);
515     function WETH() external pure returns (address);
516 
517     function addLiquidity(
518         address tokenA,
519         address tokenB,
520         uint amountADesired,
521         uint amountBDesired,
522         uint amountAMin,
523         uint amountBMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountA, uint amountB, uint liquidity);
527     function addLiquidityETH(
528         address token,
529         uint amountTokenDesired,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
535     function removeLiquidity(
536         address tokenA,
537         address tokenB,
538         uint liquidity,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountA, uint amountB);
544     function removeLiquidityETH(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline
551     ) external returns (uint amountToken, uint amountETH);
552     function removeLiquidityWithPermit(
553         address tokenA,
554         address tokenB,
555         uint liquidity,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline,
560         bool approveMax, uint8 v, bytes32 r, bytes32 s
561     ) external returns (uint amountA, uint amountB);
562     function removeLiquidityETHWithPermit(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline,
569         bool approveMax, uint8 v, bytes32 r, bytes32 s
570     ) external returns (uint amountToken, uint amountETH);
571     function swapExactTokensForTokens(
572         uint amountIn,
573         uint amountOutMin,
574         address[] calldata path,
575         address to,
576         uint deadline
577     ) external returns (uint[] memory amounts);
578     function swapTokensForExactTokens(
579         uint amountOut,
580         uint amountInMax,
581         address[] calldata path,
582         address to,
583         uint deadline
584     ) external returns (uint[] memory amounts);
585     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
586         external
587         payable
588         returns (uint[] memory amounts);
589     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
590         external
591         returns (uint[] memory amounts);
592     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
593         external
594         returns (uint[] memory amounts);
595     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
596         external
597         payable
598         returns (uint[] memory amounts);
599 
600     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
601     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
602     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
603     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
604     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
605 }
606 
607 interface IUniswapV2Router02 is IUniswapV2Router01 {
608     function removeLiquidityETHSupportingFeeOnTransferTokens(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline
615     ) external returns (uint amountETH);
616     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
617         address token,
618         uint liquidity,
619         uint amountTokenMin,
620         uint amountETHMin,
621         address to,
622         uint deadline,
623         bool approveMax, uint8 v, bytes32 r, bytes32 s
624     ) external returns (uint amountETH);
625 
626     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external;
633     function swapExactETHForTokensSupportingFeeOnTransferTokens(
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external payable;
639     function swapExactTokensForETHSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646 }
647 
648 interface IUniswapV2Pair {
649   event Approval(address indexed owner, address indexed spender, uint value);
650   event Transfer(address indexed from, address indexed to, uint value);
651 
652   function name() external pure returns (string memory);
653   function symbol() external pure returns (string memory);
654   function decimals() external pure returns (uint8);
655   function totalSupply() external view returns (uint);
656   function balanceOf(address owner) external view returns (uint);
657   function allowance(address owner, address spender) external view returns (uint);
658 
659   function approve(address spender, uint value) external returns (bool);
660   function transfer(address to, uint value) external returns (bool);
661   function transferFrom(address from, address to, uint value) external returns (bool);
662 
663   function DOMAIN_SEPARATOR() external view returns (bytes32);
664   function PERMIT_TYPEHASH() external pure returns (bytes32);
665   function nonces(address owner) external view returns (uint);
666 
667   function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
668 
669   event Mint(address indexed sender, uint amount0, uint amount1);
670   event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
671   event Swap(
672       address indexed sender,
673       uint amount0In,
674       uint amount1In,
675       uint amount0Out,
676       uint amount1Out,
677       address indexed to
678   );
679   event Sync(uint112 reserve0, uint112 reserve1);
680 
681   function MINIMUM_LIQUIDITY() external pure returns (uint);
682   function factory() external view returns (address);
683   function token0() external view returns (address);
684   function token1() external view returns (address);
685   function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
686   function price0CumulativeLast() external view returns (uint);
687   function price1CumulativeLast() external view returns (uint);
688   function kLast() external view returns (uint);
689 
690   function mint(address to) external returns (uint liquidity);
691   function burn(address to) external returns (uint amount0, uint amount1);
692   function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
693   function skim(address to) external;
694   function sync() external;
695 }
696 
697 /**
698  * @dev Staking Smart Contract
699  * 
700  *  - Users stake Uniswap LP Tokens to receive WETH and DYP Tokens as Rewards
701  * 
702  *  - Reward Tokens (DYP) are added to contract balance upon deployment by deployer
703  * 
704  *  - After Adding the DYP rewards, admin is supposed to transfer ownership to Governance contract
705  * 
706  *  - Users deposit Set (Predecided) Uniswap LP Tokens and get a share of the farm
707  * 
708  *  - The smart contract disburses `disburseAmount` DYP as rewards over `disburseDuration`
709  * 
710  *  - A swap is attempted periodically at atleast a set delay from last swap
711  * 
712  *  - The swap is attempted according to SWAP_PATH for difference deployments of this contract
713  * 
714  *  - For 4 different deployments of this contract, the SWAP_PATH will be:
715  *      - DYP-WETH
716  *      - DYP-WBTC-WETH (assumes appropriate liquidity is available in WBTC-WETH pair)
717  *      - DYP-USDT-WETH (assumes appropriate liquidity is available in USDT-WETH pair)
718  *      - DYP-USDC-WETH (assumes appropriate liquidity is available in USDC-WETH pair)
719  * 
720  *  - Any swap may not have a price impact on DYP price of more than approx ~2.49% for the related DYP pair
721  *      DYP-WETH swap may not have a price impact of more than ~2.49% on DYP price in DYP-WETH pair
722  *      DYP-WBTC-WETH swap may not have a price impact of more than ~2.49% on DYP price in DYP-WBTC pair
723  *      DYP-USDT-WETH swap may not have a price impact of more than ~2.49% on DYP price in DYP-USDT pair
724  *      DYP-USDC-WETH swap may not have a price impact of more than ~2.49% on DYP price in DYP-USDC pair
725  * 
726  *  - After the swap,converted WETH is distributed to stakers at pro-rata basis, according to their share of the staking pool
727  *    on the moment when the WETH distribution is done. And remaining DYP is added to the amount to be distributed or burnt.
728  *    The remaining DYP are also attempted to be swapped to WETH in the next swap if the price impact is ~2.49% or less
729  * 
730  *  - At a set delay from last execution, Governance contract (owner) may execute disburse or burn features
731  * 
732  *  - Burn feature should send the DYP tokens to set BURN_ADDRESS
733  * 
734  *  - Disburse feature should disburse the DYP 
735  *    (which would have a max price impact ~2.49% if it were to be swapped, at disburse time 
736  *    - remaining DYP are sent to BURN_ADDRESS) 
737  *    to stakers at pro-rata basis according to their share of
738  *    the staking pool at the moment the disburse is done
739  * 
740  *  - Users may claim their pending WETH and DYP anytime
741  * 
742  *  - Pending rewards are auto-claimed on any deposit or withdraw
743  * 
744  *  - Users need to wait `cliffTime` duration since their last deposit before withdrawing any LP Tokens
745  * 
746  *  - Owner may not transfer out LP Tokens from this contract anytime
747  * 
748  *  - Owner may transfer out WETH and DYP Tokens from this contract once `adminClaimableTime` is reached
749  * 
750  *  - CONTRACT VARIABLES must be changed to appropriate values before live deployment
751  */
752 contract FarmProRata is Ownable {
753     using SafeMath for uint;
754     using EnumerableSet for EnumerableSet.AddressSet;
755     using Address for address;
756     
757     // Contracts are not allowed to deposit, claim or withdraw
758     modifier noContractsAllowed() {
759         require(!(address(msg.sender).isContract()) && tx.origin == msg.sender, "No Contracts Allowed!");
760         _;
761     }
762 
763     event RewardsTransferred(address holder, uint amount);
764     event EthRewardsTransferred(address holder, uint amount);
765     
766     event RewardsDisbursed(uint amount);
767     event EthRewardsDisbursed(uint amount);
768     
769     // ============ START CONTRACT VARIABLES ==========================
770 
771     // deposit token contract address and reward token contract address
772     // these contracts (and uniswap pair & router) are "trusted" 
773     // and checked to not contain re-entrancy pattern
774     // to safely avoid checks-effects-interactions where needed to simplify logic
775     address public constant trustedDepositTokenAddress = 0xBa7872534a6C9097d805d8BEE97e030f4e372e54;
776     address public constant trustedRewardTokenAddress = 0x961C8c0B1aaD0c0b10a51FeF6a867E3091BCef17; 
777     
778     // Make sure to double-check BURN_ADDRESS
779     address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
780     
781     // cliffTime - withdraw is not possible within cliffTime of deposit
782     uint public constant cliffTime = 60 days;
783 
784     // Amount of tokens
785     uint public constant disburseAmount = 900000e18;
786     // To be disbursed continuously over this duration
787     uint public constant disburseDuration = 365 days;
788     
789     // If there are any undistributed or unclaimed tokens left in contract after this time
790     // Admin can claim them
791     uint public constant adminCanClaimAfter = 395 days;
792     
793     // delays between attempted swaps
794     uint public constant swapAttemptPeriod = 1 days;
795     // delays between attempted burns or token disbursement
796     uint public constant burnOrDisburseTokensPeriod = 7 days;
797 
798     
799 
800     // do not change this => disburse 100% rewards over `disburseDuration`
801     uint public constant disbursePercentX100 = 100e2;
802     
803     uint public constant MAGIC_NUMBER = 6289308176100628;
804     
805     // slippage tolerance
806     uint public constant SLIPPAGE_TOLERANCE_X_100 = 100;
807     
808     //  ============ END CONTRACT VARIABLES ==========================
809 
810     uint public contractDeployTime;
811     uint public adminClaimableTime;
812     uint public lastDisburseTime;
813     uint public lastSwapExecutionTime;
814     uint public lastBurnOrTokenDistributeTime;
815     
816     IUniswapV2Router02 public uniswapRouterV2;
817     IUniswapV2Pair public uniswapV2Pair;
818     address[] public SWAP_PATH;
819     
820     constructor(address[] memory swapPath) public {
821         contractDeployTime = now;
822         adminClaimableTime = contractDeployTime.add(adminCanClaimAfter);
823         lastDisburseTime = contractDeployTime;
824         lastSwapExecutionTime = lastDisburseTime;
825         lastBurnOrTokenDistributeTime = lastDisburseTime;
826         
827         uniswapRouterV2 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
828         uniswapV2Pair = IUniswapV2Pair(trustedDepositTokenAddress);
829         SWAP_PATH = swapPath;
830     }
831 
832     uint public totalClaimedRewards = 0;
833     uint public totalClaimedRewardsEth = 0;
834 
835     EnumerableSet.AddressSet private holders;
836 
837     mapping (address => uint) public depositedTokens;
838     mapping (address => uint) public depositTime;
839     mapping (address => uint) public lastClaimedTime;
840     mapping (address => uint) public totalEarnedTokens;
841     mapping (address => uint) public totalEarnedEth;
842     mapping (address => uint) public lastDivPoints;
843     mapping (address => uint) public lastEthDivPoints;
844 
845     uint public contractBalance = 0;
846 
847     uint public totalDivPoints = 0;
848     uint public totalEthDivPoints = 0;
849     uint public totalTokens = 0;
850     
851     uint public tokensToBeDisbursedOrBurnt = 0;
852     uint public tokensToBeSwapped = 0;
853 
854     uint internal constant pointMultiplier = 1e18;
855 
856     // To be executed by admin after deployment to add DYP to contract
857     function addContractBalance(uint amount) public onlyOwner {
858         require(Token(trustedRewardTokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
859         contractBalance = contractBalance.add(amount);
860     }
861 
862     
863     // Private function to update account information and auto-claim pending rewards
864     function updateAccount(address account) private {
865         disburseTokens();
866         attemptSwap();
867         uint pendingDivs = getPendingDivs(account);
868         if (pendingDivs > 0) {
869             require(Token(trustedRewardTokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
870             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
871             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
872             emit RewardsTransferred(account, pendingDivs);
873         }
874         
875         uint pendingDivsEth = getPendingDivsEth(account);
876         if (pendingDivsEth > 0) {
877             require(Token(uniswapRouterV2.WETH()).transfer(account, pendingDivsEth), "Could not transfer WETH!");
878             totalEarnedEth[account] = totalEarnedEth[account].add(pendingDivsEth);
879             totalClaimedRewardsEth = totalClaimedRewardsEth.add(pendingDivsEth);
880             emit EthRewardsTransferred(account, pendingDivsEth);
881         }
882         
883         lastClaimedTime[account] = now;
884         lastDivPoints[account] = totalDivPoints;
885         lastEthDivPoints[account] = totalEthDivPoints;
886     }
887 
888     // view function to check last updated DYP pending rewards
889     function getPendingDivs(address _holder) public view returns (uint) {
890         if (!holders.contains(_holder)) return 0;
891         if (depositedTokens[_holder] == 0) return 0;
892 
893         uint newDivPoints = totalDivPoints.sub(lastDivPoints[_holder]);
894 
895         uint depositedAmount = depositedTokens[_holder];
896 
897         uint pendingDivs = depositedAmount.mul(newDivPoints).div(pointMultiplier);
898 
899         return pendingDivs;
900     }
901     
902     // view function to check last updated WETH pending rewards
903     function getPendingDivsEth(address _holder) public view returns (uint) {
904         if (!holders.contains(_holder)) return 0;
905         if (depositedTokens[_holder] == 0) return 0;
906 
907         uint newDivPoints = totalEthDivPoints.sub(lastEthDivPoints[_holder]);
908 
909         uint depositedAmount = depositedTokens[_holder];
910 
911         uint pendingDivs = depositedAmount.mul(newDivPoints).div(pointMultiplier);
912 
913         return pendingDivs;
914     }
915 
916     
917     // view functon to get number of stakers
918     function getNumberOfHolders() public view returns (uint) {
919         return holders.length();
920     }
921 
922 
923     // deposit function to stake LP Tokens
924     function deposit(uint amountToDeposit) public noContractsAllowed {
925         require(amountToDeposit > 0, "Cannot deposit 0 Tokens");
926 
927         updateAccount(msg.sender);
928 
929         require(Token(trustedDepositTokenAddress).transferFrom(msg.sender, address(this), amountToDeposit), "Insufficient Token Allowance");
930 
931         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToDeposit);
932         totalTokens = totalTokens.add(amountToDeposit);
933 
934         if (!holders.contains(msg.sender)) {
935             holders.add(msg.sender);
936         }
937         depositTime[msg.sender] = now;
938     }
939 
940     // withdraw function to unstake LP Tokens
941     function withdraw(uint amountToWithdraw) public noContractsAllowed {
942         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens!");
943 
944         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
945         require(now.sub(depositTime[msg.sender]) > cliffTime, "You recently deposited, please wait before withdrawing.");
946         
947         updateAccount(msg.sender);
948 
949         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
950 
951         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
952         totalTokens = totalTokens.sub(amountToWithdraw);
953 
954         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
955             holders.remove(msg.sender);
956         }
957     }
958 
959     // withdraw without caring about Rewards
960     function emergencyWithdraw(uint amountToWithdraw) public noContractsAllowed {
961         require(amountToWithdraw > 0, "Cannot withdraw 0 Tokens!");
962 
963         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
964         require(now.sub(depositTime[msg.sender]) > cliffTime, "You recently deposited, please wait before withdrawing.");
965         
966         // manual update account here without withdrawing pending rewards
967         disburseTokens();
968         // do not attempt swap here
969         lastClaimedTime[msg.sender] = now;
970         lastDivPoints[msg.sender] = totalDivPoints;
971         lastEthDivPoints[msg.sender] = totalEthDivPoints;
972 
973         require(Token(trustedDepositTokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
974 
975         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
976         totalTokens = totalTokens.sub(amountToWithdraw);
977 
978         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
979             holders.remove(msg.sender);
980         }
981     }
982     
983     // claim function to claim pending rewards
984     function claim() public noContractsAllowed {
985         updateAccount(msg.sender);
986     }
987     
988     // private function to distribute DYP rewards
989     function distributeDivs(uint amount) private {
990         require(amount > 0 && totalTokens > 0, "distributeDivs failed!");
991         totalDivPoints = totalDivPoints.add(amount.mul(pointMultiplier).div(totalTokens));
992         emit RewardsDisbursed(amount);
993     }
994     
995     // private function to distribute WETH rewards
996     function distributeDivsEth(uint amount) private {
997         require(amount > 0 && totalTokens > 0, "distributeDivsEth failed!");
998         totalEthDivPoints = totalEthDivPoints.add(amount.mul(pointMultiplier).div(totalTokens));
999         emit EthRewardsDisbursed(amount);
1000     }
1001 
1002     // private function to allocate DYP to be disbursed calculated according to time passed
1003     function disburseTokens() private {
1004         uint amount = getPendingDisbursement();
1005 
1006         if (contractBalance < amount) {
1007             amount = contractBalance;
1008         }
1009         if (amount == 0 || totalTokens == 0) return;
1010 
1011         tokensToBeSwapped = tokensToBeSwapped.add(amount);        
1012 
1013         contractBalance = contractBalance.sub(amount);
1014         lastDisburseTime = now;
1015     }
1016     
1017     function attemptSwap() private {
1018         doSwap();
1019     }
1020     
1021     function doSwap() private {
1022         // do not attemptSwap if no one has staked
1023         if (totalTokens == 0) {
1024             return;
1025         }
1026         
1027         // Cannot execute swap so quickly
1028         if (now.sub(lastSwapExecutionTime) < swapAttemptPeriod) {
1029             return;
1030         }
1031     
1032         // force reserves to match balances
1033         uniswapV2Pair.sync();
1034     
1035         uint _tokensToBeSwapped = tokensToBeSwapped.add(tokensToBeDisbursedOrBurnt);
1036         
1037         uint maxSwappableAmount = getMaxSwappableAmount();
1038         
1039         // don't proceed if no liquidity
1040         if (maxSwappableAmount == 0) return;
1041     
1042         if (maxSwappableAmount < tokensToBeSwapped) {
1043             
1044             uint diff = tokensToBeSwapped.sub(maxSwappableAmount);
1045             _tokensToBeSwapped = tokensToBeSwapped.sub(diff);
1046             tokensToBeDisbursedOrBurnt = tokensToBeDisbursedOrBurnt.add(diff);
1047             tokensToBeSwapped = 0;
1048     
1049         } else if (maxSwappableAmount < _tokensToBeSwapped) {
1050     
1051             uint diff = _tokensToBeSwapped.sub(maxSwappableAmount);
1052             _tokensToBeSwapped = _tokensToBeSwapped.sub(diff);
1053             tokensToBeDisbursedOrBurnt = diff;
1054             tokensToBeSwapped = 0;
1055     
1056         } else {
1057             tokensToBeSwapped = 0;
1058             tokensToBeDisbursedOrBurnt = 0;
1059         }
1060     
1061         // don't execute 0 swap tokens
1062         if (_tokensToBeSwapped == 0) {
1063             return;
1064         }
1065     
1066         // cannot execute swap at insufficient balance
1067         if (Token(trustedRewardTokenAddress).balanceOf(address(this)) < _tokensToBeSwapped) {
1068             return;
1069         }
1070     
1071         require(Token(trustedRewardTokenAddress).approve(address(uniswapRouterV2), _tokensToBeSwapped), 'approve failed!');
1072     
1073         uint oldWethBalance = Token(uniswapRouterV2.WETH()).balanceOf(address(this));
1074                 
1075         uint amountOutMin;
1076         
1077         uint estimatedAmountOut = uniswapRouterV2.getAmountsOut(_tokensToBeSwapped, SWAP_PATH)[SWAP_PATH.length.sub(1)];
1078         amountOutMin = estimatedAmountOut.mul(uint(100e2).sub(SLIPPAGE_TOLERANCE_X_100)).div(100e2);
1079         
1080         uniswapRouterV2.swapExactTokensForTokens(_tokensToBeSwapped, amountOutMin, SWAP_PATH, address(this), block.timestamp);
1081     
1082         uint newWethBalance = Token(uniswapRouterV2.WETH()).balanceOf(address(this));
1083         uint wethReceived = newWethBalance.sub(oldWethBalance);
1084         require(wethReceived >= amountOutMin, "Invalid SWAP!");
1085         
1086         if (wethReceived > 0) {
1087             distributeDivsEth(wethReceived);    
1088         }
1089 
1090         lastSwapExecutionTime = now;
1091     }
1092     
1093     // Owner is supposed to be a Governance Contract
1094     function disburseRewardTokens() public onlyOwner {
1095         require(now.sub(lastBurnOrTokenDistributeTime) > burnOrDisburseTokensPeriod, "Recently executed, Please wait!");
1096         
1097         // force reserves to match balances
1098         uniswapV2Pair.sync();
1099         
1100         uint maxSwappableAmount = getMaxSwappableAmount();
1101         
1102         uint _tokensToBeDisbursed = tokensToBeDisbursedOrBurnt;
1103         uint _tokensToBeBurnt;
1104         
1105         if (maxSwappableAmount < _tokensToBeDisbursed) {
1106             _tokensToBeBurnt = _tokensToBeDisbursed.sub(maxSwappableAmount);
1107             _tokensToBeDisbursed = maxSwappableAmount;
1108         }
1109         
1110         distributeDivs(_tokensToBeDisbursed);
1111         if (_tokensToBeBurnt > 0) {
1112             require(Token(trustedRewardTokenAddress).transfer(BURN_ADDRESS, _tokensToBeBurnt), "disburseRewardTokens: burn failed!");
1113         }
1114         tokensToBeDisbursedOrBurnt = 0;
1115         lastBurnOrTokenDistributeTime = now;
1116     }
1117     
1118     
1119     // Owner is suposed to be a Governance Contract
1120     function burnRewardTokens() public onlyOwner {
1121         require(now.sub(lastBurnOrTokenDistributeTime) > burnOrDisburseTokensPeriod, "Recently executed, Please wait!");
1122         require(Token(trustedRewardTokenAddress).transfer(BURN_ADDRESS, tokensToBeDisbursedOrBurnt), "burnRewardTokens failed!");
1123         tokensToBeDisbursedOrBurnt = 0;
1124         lastBurnOrTokenDistributeTime = now;
1125     }
1126     
1127     
1128     // get token amount which has a max price impact of 2.5% for sells
1129     // !!IMPORTANT!! => Any functions using return value from this
1130     // MUST call `sync` on the pair before calling this function!
1131     function getMaxSwappableAmount() public view returns (uint) {
1132         uint tokensAvailable = Token(trustedRewardTokenAddress).balanceOf(trustedDepositTokenAddress);
1133         uint maxSwappableAmount = tokensAvailable.mul(MAGIC_NUMBER).div(1e18);
1134         return maxSwappableAmount;
1135     }
1136 
1137     // view function to calculate amount of DYP pending to be allocated since `lastDisburseTime` 
1138     function getPendingDisbursement() public view returns (uint) {
1139         uint timeDiff;
1140         uint _now = now;
1141         uint _stakingEndTime = contractDeployTime.add(disburseDuration);
1142         if (_now > _stakingEndTime) {
1143             _now = _stakingEndTime;
1144         }
1145         if (lastDisburseTime >= _now) {
1146             timeDiff = 0;
1147         } else {
1148             timeDiff = _now.sub(lastDisburseTime);
1149         }
1150 
1151         uint pendingDisburse = disburseAmount
1152                                     .mul(disbursePercentX100)
1153                                     .mul(timeDiff)
1154                                     .div(disburseDuration)
1155                                     .div(10000);
1156         return pendingDisburse;
1157     }
1158 
1159     // view function to get depositors list
1160     function getDepositorsList(uint startIndex, uint endIndex)
1161         public
1162         view
1163         returns (address[] memory stakers,
1164             uint[] memory stakingTimestamps,
1165             uint[] memory lastClaimedTimeStamps,
1166             uint[] memory stakedTokens) {
1167         require (startIndex < endIndex);
1168 
1169         uint length = endIndex.sub(startIndex);
1170         address[] memory _stakers = new address[](length);
1171         uint[] memory _stakingTimestamps = new uint[](length);
1172         uint[] memory _lastClaimedTimeStamps = new uint[](length);
1173         uint[] memory _stakedTokens = new uint[](length);
1174 
1175         for (uint i = startIndex; i < endIndex; i = i.add(1)) {
1176             address staker = holders.at(i);
1177             uint listIndex = i.sub(startIndex);
1178             _stakers[listIndex] = staker;
1179             _stakingTimestamps[listIndex] = depositTime[staker];
1180             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
1181             _stakedTokens[listIndex] = depositedTokens[staker];
1182         }
1183 
1184         return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
1185     }
1186 
1187 
1188     // function to allow owner to claim *other* modern ERC20 tokens sent to this contract
1189     function transferAnyERC20Token(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1190         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out deposit tokens from this vault!");
1191         require((_tokenAddr != trustedRewardTokenAddress && _tokenAddr != uniswapRouterV2.WETH()) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens or WETH Yet!");
1192         require(Token(_tokenAddr).transfer(_to, _amount), "Could not transfer out tokens!");
1193     }
1194 
1195     // function to allow owner to claim *other* legacy ERC20 tokens sent to this contract
1196     function transferAnyOldERC20Token(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1197        
1198         require(_tokenAddr != trustedDepositTokenAddress, "Admin cannot transfer out deposit tokens from this vault!");
1199         require((_tokenAddr != trustedRewardTokenAddress && _tokenAddr != uniswapRouterV2.WETH()) || (now > adminClaimableTime), "Admin cannot Transfer out Reward Tokens or WETH Yet!");
1200 
1201         OldIERC20(_tokenAddr).transfer(_to, _amount);
1202     }
1203 }