1 /*
2 * 
3 ShibaHood
4 
5 Supply: 100 000 000 
6 Max Wallet: 500 000 to start then 2 000 000
7 Max TX: 250 000 to start then 1 000 000
8 
9 Tax: 7%
10 
11 1% LP
12 4% Buybacks/Marketing/Dev
13 2% Charity Wallet
14 
15 DO NOT BUY UNTIL CONTRACT ADDRESS IS POSTED IN TELEGRAM
16 
17 https://t.me/shibahoodportal
18 
19 *
20 */
21 
22 pragma solidity =0.8.9;
23 
24 // SPDX-License-Identifier: UNLICENSED
25 
26 interface IBEP20 {
27   function totalSupply() external view returns (uint256);
28   function decimals() external view returns (uint8);
29   function symbol() external view returns (string memory);
30   function name() external view returns (string memory);
31   function getOwner() external view returns (address);
32   function balanceOf(address account) external view returns (uint256);
33   function transfer(address recipient, uint256 amount) external returns (bool);
34   function allowance(address _owner, address spender) external view returns (uint256);
35   function approve(address spender, uint256 amount) external returns (bool);
36   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 
42 interface IuniswapV2ERC20 {
43     event Approval(address indexed owner, address indexed spender, uint value);
44     event Transfer(address indexed from, address indexed to, uint value);
45 
46     function name() external pure returns (string memory);
47     function symbol() external pure returns (string memory);
48     function decimals() external pure returns (uint8);
49     function totalSupply() external view returns (uint);
50     function balanceOf(address owner) external view returns (uint);
51     function allowance(address owner, address spender) external view returns (uint);
52     function approve(address spender, uint value) external returns (bool);
53     function transfer(address to, uint value) external returns (bool);
54     function transferFrom(address from, address to, uint value) external returns (bool);
55     function DOMAIN_SEPARATOR() external view returns (bytes32);
56     function PERMIT_TYPEHASH() external pure returns (bytes32);
57     function nonces(address owner) external view returns (uint);
58     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
59 }
60 
61 interface IuniswapV2Factory {
62     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
63 
64     function feeTo() external view returns (address);
65     function feeToSetter() external view returns (address);
66     function getPair(address tokenA, address tokenB) external view returns (address pair);
67     function allPairs(uint) external view returns (address pair);
68     function allPairsLength() external view returns (uint);
69     function createPair(address tokenA, address tokenB) external returns (address pair);
70     function setFeeTo(address) external;
71     function setFeeToSetter(address) external;
72 }
73 
74 interface IuniswapV2Router01 {
75     function addLiquidity(
76         address tokenA,
77         address tokenB,
78         uint amountADesired,
79         uint amountBDesired,
80         uint amountAMin,
81         uint amountBMin,
82         address to,
83         uint deadline
84     ) external returns (uint amountA, uint amountB, uint liquidity);
85     function addLiquidityETH(
86         address token,
87         uint amountTokenDesired,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
93     function removeLiquidity(
94         address tokenA,
95         address tokenB,
96         uint liquidity,
97         uint amountAMin,
98         uint amountBMin,
99         address to,
100         uint deadline
101     ) external returns (uint amountA, uint amountB);
102     function removeLiquidityETH(
103         address token,
104         uint liquidity,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external returns (uint amountToken, uint amountETH);
110     function removeLiquidityWithPermit(
111         address tokenA,
112         address tokenB,
113         uint liquidity,
114         uint amountAMin,
115         uint amountBMin,
116         address to,
117         uint deadline,
118         bool approveMax, uint8 v, bytes32 r, bytes32 s
119     ) external returns (uint amountA, uint amountB);
120     function removeLiquidityETHWithPermit(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountToken, uint amountETH);
129     function swapExactTokensForTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external returns (uint[] memory amounts);
136     function swapTokensForExactTokens(
137         uint amountOut,
138         uint amountInMax,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external returns (uint[] memory amounts);
143     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
144         external
145         payable
146         returns (uint[] memory amounts);
147     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
148         external
149         returns (uint[] memory amounts);
150     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
151         external
152         returns (uint[] memory amounts);
153     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
154         external
155         payable
156         returns (uint[] memory amounts);
157 
158     function factory() external pure returns (address);
159     function WETH() external pure returns (address);
160     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
161     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
162     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
163     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
164     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
165 }
166 
167 interface IuniswapV2Router02 is IuniswapV2Router01 {
168     function removeLiquidityETHSupportingFeeOnTransferTokens(
169         address token,
170         uint liquidity,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external returns (uint amountETH);
176     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline,
183         bool approveMax, uint8 v, bytes32 r, bytes32 s
184     ) external returns (uint amountETH);
185     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
186         uint amountIn,
187         uint amountOutMin,
188         address[] calldata path,
189         address to,
190         uint deadline
191     ) external;
192     function swapExactETHForTokensSupportingFeeOnTransferTokens(
193         uint amountOutMin,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external payable;
198     function swapExactTokensForETHSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205 }
206 
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor () {
230         address msgSender = msg.sender;
231         _owner = msgSender;
232         emit OwnershipTransferred(address(0), msgSender);
233     }
234 
235     /**
236      * @dev Returns the address of the current owner.
237      */
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier onlyOwner() {
246         require(owner() == msg.sender, "Ownable: caller is not the owner");
247         _;
248     }
249 
250     /**
251      * @dev Leaves the contract without owner. It will not be possible to call
252      * `onlyOwner` functions anymore. Can only be called by the current owner.
253      *
254      * NOTE: Renouncing ownership will leave the contract without an owner,
255      * thereby removing any functionality that is only available to the owner.
256      */
257     function renounceOwnership() external onlyOwner {
258         emit OwnershipTransferred(_owner, address(0));
259         _owner = address(0);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Can only be called by the current owner.
265      */
266     function transferOwnership(address newOwner) external onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         emit OwnershipTransferred(_owner, newOwner);
269         _owner = newOwner;
270     }
271 }
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { size := extcodesize(account) }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: value }(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.delegatecall(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 // solhint-disable-next-line no-inline-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 /**
460  * @dev Library for managing
461  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
462  * types.
463  *
464  * Sets have the following properties:
465  *
466  * - Elements are added, removed, and checked for existence in constant time
467  * (O(1)).
468  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
469  *
470  * ```
471  * contract Example {
472  *     // Add the library methods
473  *     using EnumerableSet for EnumerableSet.AddressSet;
474  *
475  *     // Declare a set state variable
476  *     EnumerableSet.AddressSet private mySet;
477  * }
478  * ```
479  *
480  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
481  * and `uint256` (`UintSet`) are supported.
482  */
483 library EnumerableSet {
484     // To implement this library for multiple types with as little code
485     // repetition as possible, we write it in terms of a generic Set type with
486     // bytes32 values.
487     // The Set implementation uses private functions, and user-facing
488     // implementations (such as AddressSet) are just wrappers around the
489     // underlying Set.
490     // This means that we can only create new EnumerableSets for types that fit
491     // in bytes32.
492 
493     struct Set {
494         // Storage of set values
495         bytes32[] _values;
496 
497         // Position of the value in the `values` array, plus 1 because index 0
498         // means a value is not in the set.
499         mapping (bytes32 => uint256) _indexes;
500     }
501 
502     /**
503      * @dev Add a value to a set. O(1).
504      *
505      * Returns true if the value was added to the set, that is if it was not
506      * already present.
507      */
508     function _add(Set storage set, bytes32 value) private returns (bool) {
509         if (!_contains(set, value)) {
510             set._values.push(value);
511             // The value is stored at length-1, but we add 1 to all indexes
512             // and use 0 as a sentinel value
513             set._indexes[value] = set._values.length;
514             return true;
515         } else {
516             return false;
517         }
518     }
519 
520     /**
521      * @dev Removes a value from a set. O(1).
522      *
523      * Returns true if the value was removed from the set, that is if it was
524      * present.
525      */
526     function _remove(Set storage set, bytes32 value) private returns (bool) {
527         // We read and store the value's index to prevent multiple reads from the same storage slot
528         uint256 valueIndex = set._indexes[value];
529 
530         if (valueIndex != 0) { // Equivalent to contains(set, value)
531             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
532             // the array, and then remove the last element (sometimes called as 'swap and pop').
533             // This modifies the order of the array, as noted in {at}.
534 
535             uint256 toDeleteIndex = valueIndex - 1;
536             uint256 lastIndex = set._values.length - 1;
537 
538             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
539             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
540 
541             bytes32 lastvalue = set._values[lastIndex];
542 
543             // Move the last value to the index where the value to delete is
544             set._values[toDeleteIndex] = lastvalue;
545             // Update the index for the moved value
546             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
547 
548             // Delete the slot where the moved value was stored
549             set._values.pop();
550 
551             // Delete the index for the deleted slot
552             delete set._indexes[value];
553 
554             return true;
555         } else {
556             return false;
557         }
558     }
559 
560     /**
561      * @dev Returns true if the value is in the set. O(1).
562      */
563     function _contains(Set storage set, bytes32 value) private view returns (bool) {
564         return set._indexes[value] != 0;
565     }
566 
567     /**
568      * @dev Returns the number of values on the set. O(1).
569      */
570     function _length(Set storage set) private view returns (uint256) {
571         return set._values.length;
572     }
573 
574    /**
575     * @dev Returns the value stored at position `index` in the set. O(1).
576     *
577     * Note that there are no guarantees on the ordering of values inside the
578     * array, and it may change when more values are added or removed.
579     *
580     * Requirements:
581     *
582     * - `index` must be strictly less than {length}.
583     */
584     function _at(Set storage set, uint256 index) private view returns (bytes32) {
585         require(set._values.length > index, "EnumerableSet: index out of bounds");
586         return set._values[index];
587     }
588 
589     // Bytes32Set
590 
591     struct Bytes32Set {
592         Set _inner;
593     }
594 
595     /**
596      * @dev Add a value to a set. O(1).
597      *
598      * Returns true if the value was added to the set, that is if it was not
599      * already present.
600      */
601     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
602         return _add(set._inner, value);
603     }
604 
605     /**
606      * @dev Removes a value from a set. O(1).
607      *
608      * Returns true if the value was removed from the set, that is if it was
609      * present.
610      */
611     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
612         return _remove(set._inner, value);
613     }
614 
615     /**
616      * @dev Returns true if the value is in the set. O(1).
617      */
618     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
619         return _contains(set._inner, value);
620     }
621 
622     /**
623      * @dev Returns the number of values in the set. O(1).
624      */
625     function length(Bytes32Set storage set) internal view returns (uint256) {
626         return _length(set._inner);
627     }
628 
629    /**
630     * @dev Returns the value stored at position `index` in the set. O(1).
631     *
632     * Note that there are no guarantees on the ordering of values inside the
633     * array, and it may change when more values are added or removed.
634     *
635     * Requirements:
636     *
637     * - `index` must be strictly less than {length}.
638     */
639     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
640         return _at(set._inner, index);
641     }
642 
643     // AddressSet
644 
645     struct AddressSet {
646         Set _inner;
647     }
648 
649     /**
650      * @dev Add a value to a set. O(1).
651      *
652      * Returns true if the value was added to the set, that is if it was not
653      * already present.
654      */
655     function add(AddressSet storage set, address value) internal returns (bool) {
656         return _add(set._inner, bytes32(uint256(uint160(value))));
657     }
658 
659     /**
660      * @dev Removes a value from a set. O(1).
661      *
662      * Returns true if the value was removed from the set, that is if it was
663      * present.
664      */
665     function remove(AddressSet storage set, address value) internal returns (bool) {
666         return _remove(set._inner, bytes32(uint256(uint160(value))));
667     }
668 
669     /**
670      * @dev Returns true if the value is in the set. O(1).
671      */
672     function contains(AddressSet storage set, address value) internal view returns (bool) {
673         return _contains(set._inner, bytes32(uint256(uint160(value))));
674     }
675 
676     /**
677      * @dev Returns the number of values in the set. O(1).
678      */
679     function length(AddressSet storage set) internal view returns (uint256) {
680         return _length(set._inner);
681     }
682 
683    /**
684     * @dev Returns the value stored at position `index` in the set. O(1).
685     *
686     * Note that there are no guarantees on the ordering of values inside the
687     * array, and it may change when more values are added or removed.
688     *
689     * Requirements:
690     *
691     * - `index` must be strictly less than {length}.
692     */
693     function at(AddressSet storage set, uint256 index) internal view returns (address) {
694         return address(uint160(uint256(_at(set._inner, index))));
695     }
696 
697     // UintSet
698 
699     struct UintSet {
700         Set _inner;
701     }
702 
703     /**
704      * @dev Add a value to a set. O(1).
705      *
706      * Returns true if the value was added to the set, that is if it was not
707      * already present.
708      */
709     function add(UintSet storage set, uint256 value) internal returns (bool) {
710         return _add(set._inner, bytes32(value));
711     }
712 
713     /**
714      * @dev Removes a value from a set. O(1).
715      *
716      * Returns true if the value was removed from the set, that is if it was
717      * present.
718      */
719     function remove(UintSet storage set, uint256 value) internal returns (bool) {
720         return _remove(set._inner, bytes32(value));
721     }
722 
723     /**
724      * @dev Returns true if the value is in the set. O(1).
725      */
726     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
727         return _contains(set._inner, bytes32(value));
728     }
729 
730     /**
731      * @dev Returns the number of values on the set. O(1).
732      */
733     function length(UintSet storage set) internal view returns (uint256) {
734         return _length(set._inner);
735     }
736 
737    /**
738     * @dev Returns the value stored at position `index` in the set. O(1).
739     *
740     * Note that there are no guarantees on the ordering of values inside the
741     * array, and it may change when more values are added or removed.
742     *
743     * Requirements:
744     *
745     * - `index` must be strictly less than {length}.
746     */
747     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
748         return uint256(_at(set._inner, index));
749     }
750 }
751 
752 //ShibaHood Contract /////////////
753 
754 contract ShibaHood is IBEP20, Ownable
755 {
756     using Address for address;
757     using EnumerableSet for EnumerableSet.AddressSet;
758 
759     event ContractChanged(uint256 indexed value);
760     event ContractChangedBool(bool indexed value);
761     event ContractChangedAddress(address indexed value);
762     event antiBotBan(address indexed value);
763     
764     
765     mapping (address => uint256) private _balances;
766     mapping (address => mapping (address => uint256)) private _allowances;
767     mapping (address => uint256) private _buyLock;
768 
769     EnumerableSet.AddressSet private _excluded;
770     EnumerableSet.AddressSet private _isBlacklisted;
771 
772     //Token Info
773     string private constant _name = 'ShibaHood';
774     string private constant _symbol = 'SHOOD';
775     uint8 private constant _decimals = 9;
776     uint256 public constant InitialSupply= 100000000 * 10**_decimals;
777 
778     //Amount to Swap variable
779     uint256 currentAmountToSwap = 1500000 * 10**_decimals;
780     //Divider for the MaxBalance based on circulating Supply (2%)
781     uint8 public constant BalanceLimitDivider=50;
782     //Divider for sellLimit based on circulating Supply (0.25%)
783     uint16 public constant SellLimitDivider=400;
784 	//Buyers get locked for MaxBuyLockTime (put in seconds, works better especially if changing later) so they can't buy repeatedly
785     uint16 public constant MaxBuyLockTime= 15 seconds;
786     //The time Liquidity gets locked at start and prolonged once it gets released
787     uint256 private constant DefaultLiquidityLockTime= 1800;
788     //DevWallets
789     address public TeamWallet=payable(0x974F7a3eCD3fDE631e603891d0F5Ee5c3E60C30f);
790     address public CharityWallet=payable(0x86feA555875Cd9820626c3dFd831adf9Cb35545b);
791     //Uniswap router (Main & Testnet)
792     address private uniswapV2Router=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
793 
794 
795     //variables that track balanceLimit and sellLimit,
796     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
797     uint256 private _circulatingSupply =InitialSupply;
798     uint256 public  balanceLimit = _circulatingSupply;
799     uint256 public  sellLimit = _circulatingSupply;
800 	uint256 private antiWhale = 250000 * 10**_decimals;
801 
802     //Used for anti-bot autoblacklist
803     uint256 private tradingEnabledAt; //DO NOT CHANGE, THIS IS FOR HOLDING A TIMESTAMP
804 	uint256 private autoBanTime = 30; // Set to the amount of time in seconds after enable trading you want addresses to be auto blacklisted if they buy/sell/transfer in this time.
805 	uint256 private enableAutoBlacklist = 1; //Leave 1 if using, set to 0 if not using.
806     
807     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
808     uint8 private _buyTax;
809     uint8 private _sellTax;
810     uint8 private _transferTax;
811 
812     uint8 private _burnTax;
813     uint8 private _liquidityTax;
814     uint8 private _marketingTax;
815        
816     address private _uniswapV2PairAddress; 
817     IuniswapV2Router02 private _uniswapV2Router;
818 
819     //Constructor///////////
820 
821     constructor () {
822         //contract creator gets 90% of the token to create LP-Pair
823         uint256 deployerBalance=_circulatingSupply;
824         _balances[msg.sender] = deployerBalance;
825         emit Transfer(address(0), msg.sender, deployerBalance);
826         // Uniswap Router
827         _uniswapV2Router = IuniswapV2Router02(uniswapV2Router);
828         //Creates a Uniswap Pair
829         _uniswapV2PairAddress = IuniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
830         
831         //Sets Buy/Sell limits
832         balanceLimit=InitialSupply/BalanceLimitDivider;
833         sellLimit=InitialSupply/SellLimitDivider;
834 		
835 		//Sets buyLockTime
836         buyLockTime=0;
837 
838         //Set Starting Taxes 
839         
840         _buyTax=7;
841         _sellTax=7;
842         _transferTax=7;
843 
844         _burnTax=0;
845         _liquidityTax=10;
846         _marketingTax=90;
847 
848         //Team wallets and deployer are excluded from Taxes
849         _excluded.add(TeamWallet);
850         _excluded.add(CharityWallet);
851         _excluded.add(msg.sender);
852     
853     }
854 
855     //Transfer functionality///
856 
857     //transfer function, every transfer runs through this function
858     function _transfer(address sender, address recipient, uint256 amount) private{
859         require(sender != address(0), "Transfer from zero");
860         require(recipient != address(0), "Transfer to zero");
861         
862         //Manually Excluded adresses are transfering tax and lock free
863         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
864         
865         //Transactions from and to the contract are always tax and lock free
866         bool isContractTransfer=(sender==address(this) || recipient==address(this));
867         
868         //transfers between UniswapRouter and UniswapPair are tax and lock free
869         address uniswapV2Router=address(_uniswapV2Router);
870         bool isLiquidityTransfer = ((sender == _uniswapV2PairAddress && recipient == uniswapV2Router) 
871         || (recipient == _uniswapV2PairAddress && sender == uniswapV2Router));
872 
873         //differentiate between buy/sell/transfer to apply different taxes/restrictions
874         bool isBuy=sender==_uniswapV2PairAddress|| sender == uniswapV2Router;
875         bool isSell=recipient==_uniswapV2PairAddress|| recipient == uniswapV2Router;
876 
877         //Pick transfer
878         if(isContractTransfer || isLiquidityTransfer || isExcluded){
879             _feelessTransfer(sender, recipient, amount);
880         }
881         else{ 
882             //once trading is enabled, it can't be turned off again
883             require(tradingEnabled,"trading not yet enabled");
884             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
885         }
886     }
887     //applies taxes, checks for limits, locks generates autoLP
888     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
889         uint256 recipientBalance = _balances[recipient];
890         uint256 senderBalance = _balances[sender];
891         require(senderBalance >= amount, "Transfer exceeds balance");
892 
893         uint8 tax;
894         if(isSell){
895             //Sells can't exceed the sell limit
896             require(amount<=sellLimit,"Dump protection");
897             require(_isBlacklisted.contains(sender) == false, "Address blacklisted!");
898             if (block.timestamp <= tradingEnabledAt + autoBanTime && enableAutoBlacklist == 1) {
899                 _isBlacklisted.add(sender);
900                 emit antiBotBan(sender);
901             }
902             tax=_sellTax;
903 
904 
905         } else if(isBuy){
906             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
907             require(recipientBalance+amount<=balanceLimit,"whale protection");
908 			require(amount <= antiWhale,"Tx amount exceeding max buy amount");
909             require(_isBlacklisted.contains(recipient) == false, "Address blacklisted!");
910             if (block.timestamp <= tradingEnabledAt + autoBanTime && enableAutoBlacklist == 1) {
911                 _isBlacklisted.add(recipient);
912                 emit antiBotBan(recipient);
913             }
914             tax=_buyTax;
915 
916         } else {//Transfer
917             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
918             require(_isBlacklisted.contains(sender) == false, "Sender address blacklisted!");
919             require(_isBlacklisted.contains(recipient) == false, "Recipient address blacklisted!");
920             require(recipientBalance+amount<=balanceLimit,"whale protection");
921             if (block.timestamp <= tradingEnabledAt + autoBanTime && enableAutoBlacklist == 1) {
922                 _isBlacklisted.add(sender);
923                 emit antiBotBan(sender);
924             }
925             tax=_transferTax;
926 
927 
928         }     
929         //Swapping AutoLP and MarketingETH is only possible if sender is not uniswapV2 pair, 
930         //if its not manually disabled, if its not already swapping and if its a Sell to avoid
931         // people from causing a large price impact from repeatedly transfering when theres a large backlog of Tokens
932         if((sender!=_uniswapV2PairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier)&&isSell)
933             _swapContractToken();
934         //Calculates the exact token amount for each tax
935         uint256 tokensToBeBurnt=_calculateFee(amount, tax, _burnTax);
936         uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax);
937         //Subtract the Taxed Tokens from the amount
938         uint256 taxedAmount=amount-(tokensToBeBurnt + contractToken);
939 
940         //Removes token
941         _removeToken(sender,amount);
942         
943         //Adds the taxed tokens to the contract wallet
944         _balances[address(this)] += contractToken;
945         //Burns tokens
946         _circulatingSupply-=tokensToBeBurnt;
947 
948         //Adds token
949         _addToken(recipient, taxedAmount);
950         
951         emit Transfer(sender,recipient,taxedAmount);
952 
953     }
954 
955     //Feeless transfer only transfers
956     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
957         uint256 senderBalance = _balances[sender];
958         require(senderBalance >= amount, "Transfer exceeds balance");
959         //Removes token
960         _removeToken(sender,amount);
961         //Adds token
962         _addToken(recipient, amount);
963         
964         emit Transfer(sender,recipient,amount);
965 
966     }
967     //Calculates the token that should be taxed
968     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
969         return (amount*tax*taxPercent) / 10000;
970     }
971   
972     //balance that is claimable by the team
973     uint256 public marketingBalance;
974 
975     //adds Token to balances
976     function _addToken(address addr, uint256 amount) private {
977         //the amount of token after transfer
978         uint256 newAmount=_balances[addr]+amount;
979         //sets newBalance
980         _balances[addr]=newAmount;
981     }
982     
983     
984     //removes Token
985     function _removeToken(address addr, uint256 amount) private {
986         //the amount of token after transfer
987         uint256 newAmount=_balances[addr]-amount;
988         //sets newBalance
989         _balances[addr]=newAmount;
990     }
991 
992     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
993 
994     //tracks auto generated ETH, useful for ticker etc
995     uint256 public totalLPETH;
996     //Locks the swap if already swapping
997     bool private _isSwappingContractModifier;
998     modifier lockTheSwap {
999         _isSwappingContractModifier = true;
1000         _;
1001         _isSwappingContractModifier = false;
1002     }
1003 
1004     //swaps the token on the contract for Marketing ETH and LP Token.
1005     //always swaps the sellLimit of token to avoid a large price impact
1006     function _swapContractToken() private lockTheSwap{
1007         uint256 contractBalance=_balances[address(this)];
1008         uint16 totalTax=_marketingTax+_liquidityTax;
1009         uint256 tokenToSwap = currentAmountToSwap;
1010         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
1011         if(contractBalance<tokenToSwap||totalTax==0){
1012             return;
1013         }
1014         //splits the token in TokenForLiquidity and tokenForMarketing
1015         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
1016         uint256 tokenForMarketing= tokenToSwap-tokenForLiquidity;
1017 
1018         //splits tokenForLiquidity in 2 halves
1019         uint256 liqToken=tokenForLiquidity/2;
1020         uint256 liqETHToken=tokenForLiquidity-liqToken;
1021 
1022         //swaps marktetingToken and the liquidity token half for ETH
1023         uint256 swapToken=liqETHToken+tokenForMarketing;
1024         //Gets the initial ETH balance
1025         uint256 initialETHBalance = address(this).balance;
1026         _swapTokenForETH(swapToken);
1027         uint256 newETH=(address(this).balance - initialETHBalance);
1028         //calculates the amount of ETH belonging to the LP-Pair and converts them to LP
1029         uint256 liqETH = (newETH*liqETHToken)/swapToken;
1030         _addLiquidity(liqToken, liqETH);
1031         //Get the ETH balance after LP generation to get the
1032         //exact amount of token left for marketing
1033         uint256 distributeETH=(address(this).balance - initialETHBalance);
1034         //distributes remaining BETHNB to Marketing
1035         marketingBalance+=distributeETH;
1036     }
1037     //swaps tokens on the contract for ETH
1038     function _swapTokenForETH(uint256 amount) private {
1039         _approve(address(this), address(_uniswapV2Router), amount);
1040         address[] memory path = new address[](2);
1041         path[0] = address(this);
1042         path[1] = _uniswapV2Router.WETH();
1043 
1044         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1045             amount,
1046             0,
1047             path,
1048             address(this),
1049             block.timestamp
1050         );
1051     }
1052     //Adds Liquidity directly to the contract where LP are locked(unlike safemoon forks, that transfer it to the owner)
1053     function _addLiquidity(uint256 tokenamount, uint256 ethamount) private returns (uint256 tAmountSent, uint256 ethAmountSent) {
1054         totalLPETH+=ethamount;
1055         uint256 minETH = (ethamount*75) / 100;
1056         uint256 minTokens = (tokenamount*75) / 100;
1057         _approve(address(this), address(_uniswapV2Router), tokenamount);
1058         _uniswapV2Router.addLiquidityETH{value: ethamount}(
1059             address(this),
1060             tokenamount,
1061             minTokens,
1062             minETH,
1063             address(this),
1064             block.timestamp
1065         );
1066         tAmountSent = tokenamount;
1067         ethAmountSent = ethamount;
1068         return (tAmountSent, ethAmountSent);
1069     }
1070 
1071     //public functions /////////////////////////////////////////////////////////////////////////////////////
1072 
1073     function getLiquidityReleaseTimeInSeconds() external view returns (uint256){
1074         if(block.timestamp<_liquidityUnlockTime){
1075             return _liquidityUnlockTime-block.timestamp;
1076         }
1077         return 0;
1078     }
1079 
1080     function getBurnedTokens() external view returns(uint256){
1081         return (InitialSupply-_circulatingSupply)/10**_decimals;
1082     }
1083 
1084     function getLimits() external view returns(uint256 balance, uint256 sell){
1085         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
1086     }
1087 
1088     function getTaxes() external view returns(uint256 burnTax,uint256 liquidityTax, uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
1089         return (_burnTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
1090     }
1091 	
1092     //How long is a given address still locked from buying
1093 	function getAddressBuyLockTimeInSeconds(address AddressToCheck) external view returns (uint256){
1094        uint256 lockTime=_buyLock[AddressToCheck];
1095        if(lockTime<=block.timestamp)
1096        {
1097            return 0;
1098        }
1099        return lockTime-block.timestamp;
1100     }
1101     function getBuyLockTimeInSeconds() external view returns(uint256){
1102         return buyLockTime;
1103     }
1104     
1105     //Functions every wallet can call
1106 	
1107 	//Resets buy lock of caller to the default buyLockTime should something go very wrong
1108     function AddressResetBuyLock() external{
1109         _buyLock[msg.sender]=block.timestamp+buyLockTime;
1110 	
1111     }
1112 
1113     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
1114  
1115 	bool public buyLockDisabled;
1116     uint256 public buyLockTime;
1117     bool public manualConversion; 
1118 
1119     function TeamWithdrawALLMarketingETH() external onlyOwner{
1120         uint256 amount=marketingBalance;
1121         marketingBalance=0;
1122         payable(TeamWallet).transfer((amount*66) / 100);
1123         payable(CharityWallet).transfer((amount-(amount*66) / 100));
1124         emit Transfer(address(this), TeamWallet, (amount*66) / 100);
1125         emit Transfer(address(this), CharityWallet, (amount-(amount*66) / 100));
1126     } 
1127     function TeamWithdrawXMarketingETH(uint256 amount) external onlyOwner{
1128         require(amount<=marketingBalance,
1129         "Error: Amount greater than available balance.");
1130         marketingBalance-=amount;
1131         payable(TeamWallet).transfer((amount*66) / 100);
1132         payable(CharityWallet).transfer((amount-(amount*66) / 100));
1133         emit Transfer(address(this), TeamWallet, (amount*66) / 100);
1134         emit Transfer(address(this), CharityWallet, (amount-(amount*66) / 100));
1135     } 
1136 
1137     //switches autoLiquidity and marketing ETH generation during transfers
1138     function TeamSwitchManualETHConversion(bool manual) external onlyOwner{
1139         manualConversion=manual;
1140         emit ContractChangedBool(manualConversion);
1141     }
1142 	
1143 	function TeamChangeAntiWhale(uint256 newAntiWhale) external onlyOwner{
1144       antiWhale=newAntiWhale * 10**_decimals;
1145       emit ContractChanged(antiWhale);
1146     }
1147     
1148     function TeamChangeTeamWallet(address newTeamWallet) external onlyOwner{
1149       require(newTeamWallet != address(0),
1150       "Error: Cannot be 0 address.");
1151       TeamWallet=payable(newTeamWallet);
1152       emit ContractChangedAddress(TeamWallet);
1153     }
1154     
1155     function TeamChangeCharityWallet(address newCharityWallet) external onlyOwner{
1156       require(newCharityWallet != address(0),
1157       "Error: Cannot be 0 address.");
1158       CharityWallet=payable(newCharityWallet);
1159       emit ContractChangedAddress(CharityWallet);
1160     }
1161 	
1162 	//Disables the timeLock after buying for everyone
1163     function TeamDisableBuyLock(bool disabled) external onlyOwner{
1164         buyLockDisabled=disabled;
1165         emit ContractChangedBool(buyLockDisabled);
1166     }
1167 	
1168 	//Sets BuyLockTime, needs to be lower than MaxBuyLockTime
1169     function TeamSetBuyLockTime(uint256 buyLockSeconds) external onlyOwner{
1170             require(buyLockSeconds<=MaxBuyLockTime,"Buy Lock time too high");
1171             buyLockTime=buyLockSeconds;
1172             emit ContractChanged(buyLockTime);
1173     } 
1174 
1175     //Allows CA owner to change how much the contract sells to prevent massive contract sells as the token grows.
1176     function TeamUpdateAmountToSwap(uint256 newSwapAmount) external onlyOwner{
1177         currentAmountToSwap = newSwapAmount;
1178         emit ContractChanged(currentAmountToSwap);
1179     }
1180     
1181     //Allows wallet exclusion to be added after launch
1182     function addWalletExclusion(address exclusionAdd) external onlyOwner{
1183         _excluded.add(exclusionAdd);
1184         emit ContractChangedAddress(exclusionAdd);
1185     }
1186 
1187     //Allows you to remove wallet exclusions after launch
1188     function removeWalletExclusion(address exclusionRemove) external onlyOwner{
1189         _excluded.remove(exclusionRemove);
1190         emit ContractChangedAddress(exclusionRemove);
1191     }
1192 
1193     //Adds address to blacklist and prevents sells, buys or transfers.
1194     function addAddressToBlacklist(address blacklistedAddress) external onlyOwner {
1195         _isBlacklisted.add(blacklistedAddress);
1196         emit ContractChangedAddress(blacklistedAddress);
1197     }
1198 
1199     //Remove address from blacklist and allow sells, buys or transfers.
1200     function removeAddressFromBlacklist(address blacklistedAddress) external onlyOwner {
1201         _isBlacklisted.remove(blacklistedAddress);
1202         emit ContractChangedAddress(blacklistedAddress);
1203     }
1204     
1205     //Sets Taxes, is limited by MaxTax(20%) to make it impossible to create honeypot
1206     function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 marketingTaxes, uint8 buyTax, uint8 sellTax, uint8 transferTax) external onlyOwner{
1207         uint8 totalTax=burnTaxes+liquidityTaxes+marketingTaxes;
1208         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
1209         require(buyTax <= 20,
1210         "Error: Honeypot prevention prevents buyTax from exceeding 20.");
1211         require(sellTax <= 20,
1212         "Error: Honeypot prevention prevents sellTax from exceeding 20.");
1213         require(transferTax <= 20,
1214         "Error: Honeypot prevention prevents transferTax from exceeding 20.");
1215 
1216         _burnTax=burnTaxes;
1217         _liquidityTax=liquidityTaxes;
1218         _marketingTax=marketingTaxes;
1219         
1220         _buyTax=buyTax;
1221         _sellTax=sellTax;
1222         _transferTax=transferTax;
1223 
1224         emit ContractChanged(_burnTax);
1225         emit ContractChanged(_liquidityTax);
1226         emit ContractChanged(_buyTax);
1227         emit ContractChanged(_sellTax);
1228         emit ContractChanged(_transferTax);
1229     }
1230 
1231     //manually converts contract token to LP
1232     function TeamCreateLPandETH() external onlyOwner{
1233     _swapContractToken();
1234     }
1235     
1236     function teamUpdateUniswapRouter(address newRouter) external onlyOwner {
1237         require(newRouter != address(0),
1238         "Error: Cannot be 0 address.");
1239         uniswapV2Router=newRouter;
1240         emit ContractChangedAddress(newRouter);
1241     }
1242      //Limits need to be at least target, to avoid setting value to 0(avoid potential Honeypot)
1243     function TeamUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) external onlyOwner{
1244         //SellLimit needs to be below 1% to avoid a Large Price impact when generating auto LP
1245         require(newSellLimit<_circulatingSupply/100,
1246         "Error: New sell limit above 1% of circulating supply.");
1247         //Adds decimals to limits
1248         newBalanceLimit=newBalanceLimit*10**_decimals;
1249         newSellLimit=newSellLimit*10**_decimals;
1250         //Calculates the target Limits based on supply
1251         uint256 targetBalanceLimit=_circulatingSupply/BalanceLimitDivider;
1252         uint256 targetSellLimit=_circulatingSupply/SellLimitDivider;
1253 
1254         require((newBalanceLimit>=targetBalanceLimit), 
1255         "newBalanceLimit needs to be at least target");
1256         require((newSellLimit>=targetSellLimit), 
1257         "newSellLimit needs to be at least target");
1258 
1259         balanceLimit = newBalanceLimit;
1260         sellLimit = newSellLimit;
1261         emit ContractChanged(balanceLimit);
1262         emit ContractChanged(sellLimit);
1263     }
1264 
1265     
1266     //Setup Functions///////////////////////////////////////////////////////////////////////////////////////
1267     
1268     bool public tradingEnabled;
1269     address private _liquidityTokenAddress;
1270     //Enables trading for everyone
1271     function SetupEnableTrading() external onlyOwner{
1272         tradingEnabled=true;
1273         tradingEnabledAt=block.timestamp;
1274     }
1275     //Sets up the LP-Token Address required for LP Release
1276     function SetupLiquidityTokenAddress(address liquidityTokenAddress) external onlyOwner{
1277         require(liquidityTokenAddress != address(0),
1278         "Error: Cannot be 0 address.");
1279         _liquidityTokenAddress=liquidityTokenAddress;
1280     }
1281 
1282     //Liquidity Lock////////////////////////////////////////////////////////////////////////////////////////
1283     //the timestamp when Liquidity unlocks
1284     uint256 private _liquidityUnlockTime;
1285 
1286     //Adds time to LP lock in seconds.
1287     function TeamProlongLiquidityLockInSeconds(uint256 secondsUntilUnlock) external onlyOwner{
1288         _prolongLiquidityLock(secondsUntilUnlock+block.timestamp);
1289         emit ContractChanged(secondsUntilUnlock+block.timestamp);
1290     }
1291     //Adds time to LP lock based on set time.
1292     function _prolongLiquidityLock(uint256 newUnlockTime) private{
1293         // require new unlock time to be longer than old one
1294         require(newUnlockTime>_liquidityUnlockTime,
1295         "Error: New unlock time is shorter than old one.");
1296         _liquidityUnlockTime=newUnlockTime;
1297         emit ContractChanged(_liquidityUnlockTime);
1298     }
1299 
1300     //Release Liquidity Tokens once unlock time is over
1301     function TeamReleaseLiquidity() external onlyOwner returns (address tWAddress, uint256 amountSent) {
1302         //Only callable if liquidity Unlock time is over
1303         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1304         
1305         IuniswapV2ERC20 liquidityToken = IuniswapV2ERC20(_liquidityTokenAddress);
1306         uint256 amount = liquidityToken.balanceOf(address(this));
1307 
1308         //Liquidity release if something goes wrong at start
1309         liquidityToken.transfer(TeamWallet, amount);
1310         emit Transfer(address(this), TeamWallet, amount);
1311         tWAddress = TeamWallet;
1312         amountSent = amount;
1313         return (tWAddress, amountSent);
1314         
1315     }
1316     //Removes Liquidity once unlock Time is over, 
1317     function TeamRemoveLiquidity() external onlyOwner returns (uint256 newBalance) {
1318         //Only callable if liquidity Unlock time is over
1319         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1320         IuniswapV2ERC20 liquidityToken = IuniswapV2ERC20(_liquidityTokenAddress);
1321         uint256 amount = liquidityToken.balanceOf(address(this));
1322 
1323         liquidityToken.approve(address(_uniswapV2Router),amount);
1324         //Removes Liquidity and adds it to marketing Balance
1325         uint256 initialETHBalance = address(this).balance;
1326         
1327         _uniswapV2Router.removeLiquidityETHSupportingFeeOnTransferTokens(
1328             address(this),
1329             amount,
1330             (amount*75) / 100,
1331             (amount*75) / 100,
1332             address(this),
1333             block.timestamp
1334             );
1335         uint256 newETHBalance = address(this).balance-initialETHBalance;
1336         marketingBalance+=newETHBalance;
1337         newBalance=newETHBalance;
1338         return newBalance;
1339     }
1340     //Releases all remaining ETH on the contract wallet, so ETH wont be burned
1341     function TeamRemoveRemainingETH() external onlyOwner{
1342         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1343         (bool sent,) =TeamWallet.call{value: (address(this).balance)}("");
1344         require(sent,
1345         "Error: Not sent.");
1346     }
1347 
1348     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1349     //external//////////////////////////////////////////////////////////////////////////////////////////////
1350     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1351 
1352     receive() external payable {}
1353     fallback() external payable {}
1354     // IBEP20
1355 
1356     function getOwner() external view override returns (address) {
1357         return owner();
1358     }
1359 
1360     function name() external pure override returns (string memory) {
1361         return _name;
1362     }
1363 
1364     function symbol() external pure override returns (string memory) {
1365         return _symbol;
1366     }
1367 
1368     function decimals() external pure override returns (uint8) {
1369         return _decimals;
1370     }
1371 
1372     function totalSupply() external view override returns (uint256) {
1373         return _circulatingSupply;
1374     }
1375 
1376     function balanceOf(address account) external view override returns (uint256) {
1377         return _balances[account];
1378     }
1379 
1380     function transfer(address recipient, uint256 amount) external override returns (bool) {
1381         _transfer(msg.sender, recipient, amount);
1382         return true;
1383     }
1384 
1385     function allowance(address _owner, address spender) external view override returns (uint256) {
1386         return _allowances[_owner][spender];
1387     }
1388 
1389     function approve(address spender, uint256 amount) external override returns (bool) {
1390         _approve(msg.sender, spender, amount);
1391         return true;
1392     }
1393     function _approve(address owner, address spender, uint256 amount) private {
1394         require(owner != address(0), "Approve from zero");
1395         require(spender != address(0), "Approve to zero");
1396 
1397         _allowances[owner][spender] = amount;
1398         emit Approval(owner, spender, amount);
1399     }
1400 
1401     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1402         _transfer(sender, recipient, amount);
1403 
1404         uint256 currentAllowance = _allowances[sender][msg.sender];
1405         require(currentAllowance >= amount, "Transfer > allowance");
1406 
1407         _approve(sender, msg.sender, currentAllowance - amount);
1408         return true;
1409     }
1410 
1411     // IBEP20 - Helpers
1412 
1413     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1414         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1415         return true;
1416     }
1417 
1418     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1419         uint256 currentAllowance = _allowances[msg.sender][spender];
1420         require(currentAllowance >= subtractedValue, "<0 allowance");
1421 
1422         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1423         return true;
1424     }
1425 
1426 }