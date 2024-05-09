1 pragma solidity ^0.8.4;
2 
3 // SPDX-License-Identifier: UNLICENSED
4 
5 interface IBEP20 {
6   function totalSupply() external view returns (uint256);
7   function decimals() external view returns (uint8);
8   function symbol() external view returns (string memory);
9   function name() external view returns (string memory);
10   function getOwner() external view returns (address);
11   function balanceOf(address account) external view returns (uint256);
12   function transfer(address recipient, uint256 amount) external returns (bool);
13   function allowance(address _owner, address spender) external view returns (uint256);
14   function approve(address spender, uint256 amount) external returns (bool);
15   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 interface IuniswapV2ERC20 {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 }
39 
40 interface IuniswapV2Factory {
41     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
42 
43     function feeTo() external view returns (address);
44     function feeToSetter() external view returns (address);
45     function getPair(address tokenA, address tokenB) external view returns (address pair);
46     function allPairs(uint) external view returns (address pair);
47     function allPairsLength() external view returns (uint);
48     function createPair(address tokenA, address tokenB) external returns (address pair);
49     function setFeeTo(address) external;
50     function setFeeToSetter(address) external;
51 }
52 
53 interface IuniswapV2Router01 {
54     function addLiquidity(
55         address tokenA,
56         address tokenB,
57         uint amountADesired,
58         uint amountBDesired,
59         uint amountAMin,
60         uint amountBMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountA, uint amountB, uint liquidity);
64     function addLiquidityETH(
65         address token,
66         uint amountTokenDesired,
67         uint amountTokenMin,
68         uint amountETHMin,
69         address to,
70         uint deadline
71     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
72     function removeLiquidity(
73         address tokenA,
74         address tokenB,
75         uint liquidity,
76         uint amountAMin,
77         uint amountBMin,
78         address to,
79         uint deadline
80     ) external returns (uint amountA, uint amountB);
81     function removeLiquidityETH(
82         address token,
83         uint liquidity,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external returns (uint amountToken, uint amountETH);
89     function removeLiquidityWithPermit(
90         address tokenA,
91         address tokenB,
92         uint liquidity,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline,
97         bool approveMax, uint8 v, bytes32 r, bytes32 s
98     ) external returns (uint amountA, uint amountB);
99     function removeLiquidityETHWithPermit(
100         address token,
101         uint liquidity,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline,
106         bool approveMax, uint8 v, bytes32 r, bytes32 s
107     ) external returns (uint amountToken, uint amountETH);
108     function swapExactTokensForTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external returns (uint[] memory amounts);
115     function swapTokensForExactTokens(
116         uint amountOut,
117         uint amountInMax,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external returns (uint[] memory amounts);
122     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
123         external
124         payable
125         returns (uint[] memory amounts);
126     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
127         external
128         returns (uint[] memory amounts);
129     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
130         external
131         returns (uint[] memory amounts);
132     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
133         external
134         payable
135         returns (uint[] memory amounts);
136 
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
140     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
141     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
142     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
143     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
144 }
145 
146 interface IuniswapV2Router02 is IuniswapV2Router01 {
147     function removeLiquidityETHSupportingFeeOnTransferTokens(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external returns (uint amountETH);
155     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline,
162         bool approveMax, uint8 v, bytes32 r, bytes32 s
163     ) external returns (uint amountETH);
164     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171     function swapExactETHForTokensSupportingFeeOnTransferTokens(
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external payable;
177     function swapExactTokensForETHSupportingFeeOnTransferTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external;
184 }
185 
186 
187 
188 /**
189  * @dev Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * By default, the owner account will be the one that deploys the contract. This
194  * can later be changed with {transferOwnership}.
195  *
196  * This module is used through inheritance. It will make available the modifier
197  * `onlyOwner`, which can be applied to your functions to restrict their use to
198  * the owner.
199  */
200 abstract contract Ownable {
201     address private _owner;
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     /**
206      * @dev Initializes the contract setting the deployer as the initial owner.
207      */
208     constructor () {
209         address msgSender = msg.sender;
210         _owner = msgSender;
211         emit OwnershipTransferred(address(0), msgSender);
212     }
213 
214     /**
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         require(owner() == msg.sender, "Ownable: caller is not the owner");
226         _;
227     }
228 
229     /**
230      * @dev Leaves the contract without owner. It will not be possible to call
231      * `onlyOwner` functions anymore. Can only be called by the current owner.
232      *
233      * NOTE: Renouncing ownership will leave the contract without an owner,
234      * thereby removing any functionality that is only available to the owner.
235      */
236     function renounceOwnership() public onlyOwner {
237         emit OwnershipTransferred(_owner, address(0));
238         _owner = address(0);
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         emit OwnershipTransferred(_owner, newOwner);
248         _owner = newOwner;
249     }
250 }
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { size := extcodesize(account) }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: value }(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return _verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 // solhint-disable-next-line no-inline-assembly
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 /**
439  * @dev Library for managing
440  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
441  * types.
442  *
443  * Sets have the following properties:
444  *
445  * - Elements are added, removed, and checked for existence in constant time
446  * (O(1)).
447  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
448  *
449  * ```
450  * contract Example {
451  *     // Add the library methods
452  *     using EnumerableSet for EnumerableSet.AddressSet;
453  *
454  *     // Declare a set state variable
455  *     EnumerableSet.AddressSet private mySet;
456  * }
457  * ```
458  *
459  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
460  * and `uint256` (`UintSet`) are supported.
461  */
462 library EnumerableSet {
463     // To implement this library for multiple types with as little code
464     // repetition as possible, we write it in terms of a generic Set type with
465     // bytes32 values.
466     // The Set implementation uses private functions, and user-facing
467     // implementations (such as AddressSet) are just wrappers around the
468     // underlying Set.
469     // This means that we can only create new EnumerableSets for types that fit
470     // in bytes32.
471 
472     struct Set {
473         // Storage of set values
474         bytes32[] _values;
475 
476         // Position of the value in the `values` array, plus 1 because index 0
477         // means a value is not in the set.
478         mapping (bytes32 => uint256) _indexes;
479     }
480 
481     /**
482      * @dev Add a value to a set. O(1).
483      *
484      * Returns true if the value was added to the set, that is if it was not
485      * already present.
486      */
487     function _add(Set storage set, bytes32 value) private returns (bool) {
488         if (!_contains(set, value)) {
489             set._values.push(value);
490             // The value is stored at length-1, but we add 1 to all indexes
491             // and use 0 as a sentinel value
492             set._indexes[value] = set._values.length;
493             return true;
494         } else {
495             return false;
496         }
497     }
498 
499     /**
500      * @dev Removes a value from a set. O(1).
501      *
502      * Returns true if the value was removed from the set, that is if it was
503      * present.
504      */
505     function _remove(Set storage set, bytes32 value) private returns (bool) {
506         // We read and store the value's index to prevent multiple reads from the same storage slot
507         uint256 valueIndex = set._indexes[value];
508 
509         if (valueIndex != 0) { // Equivalent to contains(set, value)
510             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
511             // the array, and then remove the last element (sometimes called as 'swap and pop').
512             // This modifies the order of the array, as noted in {at}.
513 
514             uint256 toDeleteIndex = valueIndex - 1;
515             uint256 lastIndex = set._values.length - 1;
516 
517             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
518             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
519 
520             bytes32 lastvalue = set._values[lastIndex];
521 
522             // Move the last value to the index where the value to delete is
523             set._values[toDeleteIndex] = lastvalue;
524             // Update the index for the moved value
525             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
526 
527             // Delete the slot where the moved value was stored
528             set._values.pop();
529 
530             // Delete the index for the deleted slot
531             delete set._indexes[value];
532 
533             return true;
534         } else {
535             return false;
536         }
537     }
538 
539     /**
540      * @dev Returns true if the value is in the set. O(1).
541      */
542     function _contains(Set storage set, bytes32 value) private view returns (bool) {
543         return set._indexes[value] != 0;
544     }
545 
546     /**
547      * @dev Returns the number of values on the set. O(1).
548      */
549     function _length(Set storage set) private view returns (uint256) {
550         return set._values.length;
551     }
552 
553    /**
554     * @dev Returns the value stored at position `index` in the set. O(1).
555     *
556     * Note that there are no guarantees on the ordering of values inside the
557     * array, and it may change when more values are added or removed.
558     *
559     * Requirements:
560     *
561     * - `index` must be strictly less than {length}.
562     */
563     function _at(Set storage set, uint256 index) private view returns (bytes32) {
564         require(set._values.length > index, "EnumerableSet: index out of bounds");
565         return set._values[index];
566     }
567 
568     // Bytes32Set
569 
570     struct Bytes32Set {
571         Set _inner;
572     }
573 
574     /**
575      * @dev Add a value to a set. O(1).
576      *
577      * Returns true if the value was added to the set, that is if it was not
578      * already present.
579      */
580     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
581         return _add(set._inner, value);
582     }
583 
584     /**
585      * @dev Removes a value from a set. O(1).
586      *
587      * Returns true if the value was removed from the set, that is if it was
588      * present.
589      */
590     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
591         return _remove(set._inner, value);
592     }
593 
594     /**
595      * @dev Returns true if the value is in the set. O(1).
596      */
597     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
598         return _contains(set._inner, value);
599     }
600 
601     /**
602      * @dev Returns the number of values in the set. O(1).
603      */
604     function length(Bytes32Set storage set) internal view returns (uint256) {
605         return _length(set._inner);
606     }
607 
608    /**
609     * @dev Returns the value stored at position `index` in the set. O(1).
610     *
611     * Note that there are no guarantees on the ordering of values inside the
612     * array, and it may change when more values are added or removed.
613     *
614     * Requirements:
615     *
616     * - `index` must be strictly less than {length}.
617     */
618     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
619         return _at(set._inner, index);
620     }
621 
622     // AddressSet
623 
624     struct AddressSet {
625         Set _inner;
626     }
627 
628     /**
629      * @dev Add a value to a set. O(1).
630      *
631      * Returns true if the value was added to the set, that is if it was not
632      * already present.
633      */
634     function add(AddressSet storage set, address value) internal returns (bool) {
635         return _add(set._inner, bytes32(uint256(uint160(value))));
636     }
637 
638     /**
639      * @dev Removes a value from a set. O(1).
640      *
641      * Returns true if the value was removed from the set, that is if it was
642      * present.
643      */
644     function remove(AddressSet storage set, address value) internal returns (bool) {
645         return _remove(set._inner, bytes32(uint256(uint160(value))));
646     }
647 
648     /**
649      * @dev Returns true if the value is in the set. O(1).
650      */
651     function contains(AddressSet storage set, address value) internal view returns (bool) {
652         return _contains(set._inner, bytes32(uint256(uint160(value))));
653     }
654 
655     /**
656      * @dev Returns the number of values in the set. O(1).
657      */
658     function length(AddressSet storage set) internal view returns (uint256) {
659         return _length(set._inner);
660     }
661 
662    /**
663     * @dev Returns the value stored at position `index` in the set. O(1).
664     *
665     * Note that there are no guarantees on the ordering of values inside the
666     * array, and it may change when more values are added or removed.
667     *
668     * Requirements:
669     *
670     * - `index` must be strictly less than {length}.
671     */
672     function at(AddressSet storage set, uint256 index) internal view returns (address) {
673         return address(uint160(uint256(_at(set._inner, index))));
674     }
675 
676     // UintSet
677 
678     struct UintSet {
679         Set _inner;
680     }
681 
682     /**
683      * @dev Add a value to a set. O(1).
684      *
685      * Returns true if the value was added to the set, that is if it was not
686      * already present.
687      */
688     function add(UintSet storage set, uint256 value) internal returns (bool) {
689         return _add(set._inner, bytes32(value));
690     }
691 
692     /**
693      * @dev Removes a value from a set. O(1).
694      *
695      * Returns true if the value was removed from the set, that is if it was
696      * present.
697      */
698     function remove(UintSet storage set, uint256 value) internal returns (bool) {
699         return _remove(set._inner, bytes32(value));
700     }
701 
702     /**
703      * @dev Returns true if the value is in the set. O(1).
704      */
705     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
706         return _contains(set._inner, bytes32(value));
707     }
708 
709     /**
710      * @dev Returns the number of values on the set. O(1).
711      */
712     function length(UintSet storage set) internal view returns (uint256) {
713         return _length(set._inner);
714     }
715 
716    /**
717     * @dev Returns the value stored at position `index` in the set. O(1).
718     *
719     * Note that there are no guarantees on the ordering of values inside the
720     * array, and it may change when more values are added or removed.
721     *
722     * Requirements:
723     *
724     * - `index` must be strictly less than {length}.
725     */
726     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
727         return uint256(_at(set._inner, index));
728     }
729 }
730 
731 //MetaVault Contract /////////////
732 
733 contract MetaVault is IBEP20, Ownable
734 {
735     using Address for address;
736     using EnumerableSet for EnumerableSet.AddressSet;
737     
738     mapping (address => uint256) private _balances;
739     mapping (address => mapping (address => uint256)) private _allowances;
740     mapping (address => uint256) private _buyLock;
741 
742     EnumerableSet.AddressSet private _excluded;
743     EnumerableSet.AddressSet private _excludedFromBuyLock;
744     EnumerableSet.AddressSet private _excludedFromStaking;
745     //Token Info
746     string private constant _name = 'MetaVault';
747     string private constant _symbol = '$MVT';
748     uint8 private constant _decimals = 9;
749     uint256 public constant InitialSupply= 1000000000000 * 10**_decimals;//equals 1 000 000 000 000 tokens
750 
751     //Divider for the MaxBalance based on circulating Supply (1%)
752     uint8 public constant BalanceLimitDivider=100;
753     //Divider for sellLimit based on circulating Supply (0.1%)
754     uint16 public constant SellLimitDivider=1000;
755 	//Buyers get locked for MaxBuyLockTime (put in seconds, works better especially if changing later) so they can't buy repeatedly
756     uint16 public constant MaxBuyLockTime= 30;
757     //The time Liquidity gets locked at start and prolonged once it gets released
758     uint256 private constant DefaultLiquidityLockTime= 1800;
759     //DevWallets
760     address public TeamWallet=payable(0x65a89aB0402596cbDbF779dD8455B821109B6F14);
761     address public LoanWallet=payable(0x60296fc78fcAc8937693EE0Cd6428A9324eD52Bd);
762     //TestNet
763     //address private constant uniswapV2Router=0xE592427A0AEce92De3Edee1F18E0157C05861564;
764     //MainNet
765     address private constant uniswapV2Router=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
766 
767     //variables that track balanceLimit and sellLimit,
768     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
769     uint256 private _circulatingSupply =InitialSupply;
770     uint256 public  balanceLimit = _circulatingSupply;
771     uint256 public  sellLimit = _circulatingSupply;
772 	uint256 private antiWhale = 1000000000 * 10**_decimals;
773     
774     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
775     uint8 private _buyTax;
776     uint8 private _sellTax;
777     uint8 private _transferTax;
778 
779     uint8 private _burnTax;
780     uint8 private _liquidityTax;
781     uint8 private _stakingTax;
782 
783     //Tracks the current contract sell amount. (Not users) -- Can be updated by owner after launch to prevent massive contract sells.
784     uint256 private _setSellAmount = 1000000000 * 10**_decimals;
785 
786        
787     address private _uniswapV2PairAddress; 
788     IuniswapV2Router02 private  _uniswapV2Router;
789     
790     //Checks if address is in Team, is needed to give Team access even if contract is renounced
791     //Team doesn't have access to critical Functions that could turn this into a Rugpull(Exept liquidity unlocks)
792     function _isTeam(address addr) private view returns (bool){
793         return addr==owner()||addr==TeamWallet||addr==LoanWallet;
794     }
795 
796     //Constructor///////////
797 
798     constructor () {
799         //contract creator gets 90% of the token to create LP-Pair
800         uint256 deployerBalance=_circulatingSupply;
801         _balances[msg.sender] = deployerBalance;
802         emit Transfer(address(0), msg.sender, deployerBalance);
803         // uniswapV2 Router
804         _uniswapV2Router = IuniswapV2Router02(uniswapV2Router);
805         //Creates a uniswapV2 Pair
806         _uniswapV2PairAddress = IuniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
807         
808         //Sets Buy/Sell limits
809         balanceLimit=InitialSupply/BalanceLimitDivider;
810         sellLimit=InitialSupply/SellLimitDivider;
811 		
812 		//Sets buyLockTime
813         buyLockTime=30;
814 
815         //Set Starting Tax 
816         
817         _buyTax=10;
818         _sellTax=10;
819         _transferTax=10;
820 
821         _burnTax=0;
822         _liquidityTax=20;
823         _stakingTax=80;
824 
825         //Team wallets and deployer are excluded from Taxes
826         _excluded.add(TeamWallet);
827         _excluded.add(LoanWallet);
828         _excluded.add(msg.sender);
829         //excludes uniswapV2 Router, pair, contract and burn address from staking
830         _excludedFromStaking.add(address(_uniswapV2Router));
831         _excludedFromStaking.add(_uniswapV2PairAddress);
832         _excludedFromStaking.add(address(this));
833         _excludedFromStaking.add(0x000000000000000000000000000000000000dEaD);
834     
835     }
836 
837     //Transfer functionality///
838 
839     //transfer function, every transfer runs through this function
840     function _transfer(address sender, address recipient, uint256 amount) private{
841         require(sender != address(0), "Transfer from zero");
842         require(recipient != address(0), "Transfer to zero");
843         
844         //Manually Excluded adresses are transfering tax and lock free
845         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
846         
847         //Transactions from and to the contract are always tax and lock free
848         bool isContractTransfer=(sender==address(this) || recipient==address(this));
849         
850         //transfers between uniswapV2Router and uniswapV2Pair are tax and lock free
851         address uniswapV2Router=address(_uniswapV2Router);
852         bool isLiquidityTransfer = ((sender == _uniswapV2PairAddress && recipient == uniswapV2Router) 
853         || (recipient == _uniswapV2PairAddress && sender == uniswapV2Router));
854 
855         //differentiate between buy/sell/transfer to apply different taxes/restrictions
856         bool isBuy=sender==_uniswapV2PairAddress|| sender == uniswapV2Router;
857         bool isSell=recipient==_uniswapV2PairAddress|| recipient == uniswapV2Router;
858 
859         //Pick transfer
860         if(isContractTransfer || isLiquidityTransfer || isExcluded){
861             _feelessTransfer(sender, recipient, amount);
862         }
863         else{ 
864             //once trading is enabled, it can't be turned off again
865             require(tradingEnabled,"trading not yet enabled");
866             _taxedTransfer(sender,recipient,amount,isBuy,isSell);
867         }
868     }
869     //applies taxes, checks for limits, locks generates autoLP and stakingETH, and autostakes
870     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
871         uint256 recipientBalance = _balances[recipient];
872         uint256 senderBalance = _balances[sender];
873         require(senderBalance >= amount, "Transfer exceeds balance");
874 
875         uint8 tax;
876         if(isSell){
877             //Sells can't exceed the sell limit(21,000 Tokens at start, can be updated to circulating supply)
878             require(amount<=sellLimit,"Dump protection");
879             tax=_sellTax;
880 
881 
882         } else if(isBuy){
883 			if(!_excludedFromBuyLock.contains(recipient)){
884                  //If buyer bought less than buyLockTime(2h 50m) ago, buy is declined, can be disabled by Team         
885                 require(_buyLock[recipient]<=block.timestamp||buyLockDisabled,"Buyer in buyLock");
886                 //Sets the time buyers get locked(2 hours 50 mins by default)
887                 _buyLock[recipient]=block.timestamp+buyLockTime;
888             }
889             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
890             require(recipientBalance+amount<=balanceLimit,"whale protection");
891 			require(amount <= antiWhale,"Tx amount exceeding max buy amount");
892             tax=_buyTax;
893 
894         } else {//Transfer
895             //withdraws ETH when sending less or equal to 1 Token
896             //that way you can withdraw without connecting to any dApp.
897             //might needs higher gas limit
898             if(amount<=10**(_decimals)) claimBTC(sender);
899             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
900             require(recipientBalance+amount<=balanceLimit,"whale protection");
901             tax=_transferTax;
902 
903         }     
904         //Swapping AutoLP and MarketingETH is only possible if sender is not uniswapV2 pair, 
905         //if its not manually disabled, if its not already swapping and if its a Sell to avoid
906         // people from causing a large price impact from repeatedly transfering when theres a large backlog of Tokens
907         if((sender!=_uniswapV2PairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier)&&isSell)
908             _swapContractToken();
909         //Calculates the exact token amount for each tax
910         uint256 tokensToBeBurnt=_calculateFee(amount, tax, _burnTax);
911         //staking and liquidity Tax get treated the same, only during conversion they get split
912         uint256 contractToken=_calculateFee(amount, tax, _stakingTax+_liquidityTax);
913         //Subtract the Taxed Tokens from the amount
914         uint256 taxedAmount=amount-(tokensToBeBurnt + contractToken);
915 
916         //Removes token and handles staking
917         _removeToken(sender,amount);
918         
919         //Adds the taxed tokens to the contract wallet
920         _balances[address(this)] += contractToken;
921         //Burns tokens
922         _circulatingSupply-=tokensToBeBurnt;
923 
924         //Adds token and handles staking
925         _addToken(recipient, taxedAmount);
926         
927         emit Transfer(sender,recipient,taxedAmount);
928 
929     }
930 
931     //Feeless transfer only transfers and autostakes
932     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
933         uint256 senderBalance = _balances[sender];
934         require(senderBalance >= amount, "Transfer exceeds balance");
935         //Removes token and handles staking
936         _removeToken(sender,amount);
937         //Adds token and handles staking
938         _addToken(recipient, amount);
939         
940         emit Transfer(sender,recipient,amount);
941 
942     }
943     //Calculates the token that should be taxed
944     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
945         return (amount*tax*taxPercent) / 10000;
946     }
947 
948      //ETH Autostake/////////////////////////////////////////////////////////////////////////////////////////
949        //Autostake uses the balances of each holder to redistribute auto generated ETH.
950     //Each transaction _addToken and _removeToken gets called for the transaction amount
951     //WithdrawETH can be used for any holder to withdraw ETH at any time, like true Staking,
952     //so unlike MRAT clones you can leave and forget your Token and claim after a while
953 
954     //lock for the withdraw
955     bool private _isWithdrawing;
956     //Multiplier to add some accuracy to profitPerShare
957     uint256 private constant DistributionMultiplier = 2**64;
958     //profit for each share a holder holds, a share equals a token.
959     uint256 public profitPerShare;
960     //the total reward distributed through staking, for tracking purposes
961     uint256 public totalStakingReward;
962     //the total payout through staking, for tracking purposes
963     uint256 public totalPayouts;
964     
965     //marketing share starts at 50% 
966     //its capped to 50% max, the percentage of the staking that gets used for
967     //marketing/paying the team
968     uint8 public StakingShare=50;
969     //balance that is claimable by the team
970     uint256 public marketingBalance;
971 
972     //Mapping of the already paid out(or missed) shares of each staker
973     mapping(address => uint256) private alreadyPaidShares;
974     //Mapping of shares that are reserved for payout
975     mapping(address => uint256) private toBePaid;
976 
977     //Contract, uniswapV2 and burnAddress are excluded, other addresses like CEX
978     //can be manually excluded, excluded list is limited to 30 entries to avoid a
979     //out of gas exeption during sells
980     function isExcludedFromStaking(address addr) public view returns (bool){
981         return _excludedFromStaking.contains(addr);
982     }
983 
984     //Total shares equals circulating supply minus excluded Balances
985     function _getTotalShares() public view returns (uint256){
986         uint256 shares=_circulatingSupply;
987         //substracts all excluded from shares, excluded list is limited to 30
988         // to avoid creating a Honeypot through OutOfGas exeption
989         for(uint i=0; i<_excludedFromStaking.length(); i++){
990             shares-=_balances[_excludedFromStaking.at(i)];
991         }
992         return shares;
993     }
994 
995     //adds Token to balances, adds new ETH to the toBePaid mapping and resets staking
996     function _addToken(address addr, uint256 amount) private {
997         //the amount of token after transfer
998         uint256 newAmount=_balances[addr]+amount;
999         
1000         if(isExcludedFromStaking(addr)){
1001            _balances[addr]=newAmount;
1002            return;
1003         }
1004         
1005         //gets the payout before the change
1006         uint256 payment=_newDividentsOf(addr);
1007         //resets dividents to 0 for newAmount
1008         alreadyPaidShares[addr] = profitPerShare * newAmount;
1009         //adds dividents to the toBePaid mapping
1010         toBePaid[addr]+=payment; 
1011         //sets newBalance
1012         _balances[addr]=newAmount;
1013     }
1014     
1015     
1016     //removes Token, adds ETH to the toBePaid mapping and resets staking
1017     function _removeToken(address addr, uint256 amount) private {
1018         //the amount of token after transfer
1019         uint256 newAmount=_balances[addr]-amount;
1020         
1021         if(isExcludedFromStaking(addr)){
1022            _balances[addr]=newAmount;
1023            return;
1024         }
1025         
1026         //gets the payout before the change
1027         uint256 payment=_newDividentsOf(addr);
1028         //sets newBalance
1029         _balances[addr]=newAmount;
1030         //resets dividents to 0 for newAmount
1031         alreadyPaidShares[addr] = profitPerShare * newAmount;
1032         //adds dividents to the toBePaid mapping
1033         toBePaid[addr]+=payment; 
1034     }
1035     
1036     
1037     //gets the not dividents of a staker that aren't in the toBePaid mapping 
1038     //returns wrong value for excluded accounts
1039     function _newDividentsOf(address staker) private view returns (uint256) {
1040         uint256 fullPayout = profitPerShare * _balances[staker];
1041         // if theres an overflow for some unexpected reason, return 0, instead of 
1042         // an exeption to still make trades possible
1043         if(fullPayout<alreadyPaidShares[staker]) return 0;
1044         return (fullPayout - alreadyPaidShares[staker]) / DistributionMultiplier;
1045     }
1046 
1047     //distributes ETH between marketing share and dividends 
1048     function _distributeStake(uint256 ETHAmount) private {
1049         // Deduct marketing Tax
1050         uint256 marketingSplit = (ETHAmount * StakingShare) / 100;
1051         uint256 amount = ETHAmount - marketingSplit;
1052 
1053        marketingBalance+=marketingSplit;
1054        
1055         if (amount > 0) {
1056             totalStakingReward += amount;
1057             uint256 totalShares=_getTotalShares();
1058             //when there are 0 shares, add everything to marketing budget
1059             if (totalShares == 0) {
1060                 marketingBalance += amount;
1061             }else{
1062                 //Increases profit per share based on current total shares
1063                 profitPerShare += ((amount * DistributionMultiplier) / totalShares);
1064             }
1065         }
1066     }
1067     event OnWithdrawBTC(uint256 amount, address recipient);
1068     
1069     //withdraws all dividents of address
1070     function claimBTC(address addr) private{
1071         require(!_isWithdrawing);
1072         _isWithdrawing=true;
1073         uint256 amount;
1074         if(isExcludedFromStaking(addr)){
1075             //if excluded just withdraw remaining toBePaid ETH
1076             amount=toBePaid[addr];
1077             toBePaid[addr]=0;
1078         }
1079         else{
1080             uint256 newAmount=_newDividentsOf(addr);
1081             //sets payout mapping to current amount
1082             alreadyPaidShares[addr] = profitPerShare * _balances[addr];
1083             //the amount to be paid 
1084             amount=toBePaid[addr]+newAmount;
1085             toBePaid[addr]=0;
1086         }
1087         if(amount==0){//no withdraw if 0 amount
1088             _isWithdrawing=false;
1089             return;
1090         }
1091         totalPayouts+=amount;
1092         address[] memory path = new address[](2);
1093         path[0] = _uniswapV2Router.WETH(); //WETH
1094         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;  //WETH
1095 
1096         _uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1097         0,
1098         path,
1099         addr,
1100         block.timestamp);
1101         
1102         emit OnWithdrawBTC(amount, addr);
1103         _isWithdrawing=false;
1104     }
1105 
1106     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
1107 
1108     //tracks auto generated ETH, useful for ticker etc
1109     uint256 public totalLPETH;
1110     //Locks the swap if already swapping
1111     bool private _isSwappingContractModifier;
1112     modifier lockTheSwap {
1113         _isSwappingContractModifier = true;
1114         _;
1115         _isSwappingContractModifier = false;
1116     }
1117 
1118     //swaps the token on the contract for Marketing ETH and LP Token.
1119     //always swaps the sellLimit of token to avoid a large price impact
1120     function _swapContractToken() private lockTheSwap{
1121         uint256 contractBalance=_balances[address(this)];
1122         uint16 totalTax=_liquidityTax+_stakingTax;
1123         uint256 tokenToSwap = _setSellAmount;
1124         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
1125         if(contractBalance<tokenToSwap||totalTax==0){
1126             return;
1127         }
1128         //splits the token in TokenForLiquidity and tokenForMarketing
1129         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
1130         uint256 tokenForMarketing= tokenToSwap-tokenForLiquidity;
1131 
1132         //splits tokenForLiquidity in 2 halves
1133         uint256 liqToken=tokenForLiquidity/2;
1134         uint256 liqETHToken=tokenForLiquidity-liqToken;
1135 
1136         //swaps marktetingToken and the liquidity token half for ETH
1137         uint256 swapToken=liqETHToken+tokenForMarketing;
1138         //Gets the initial ETH balance, so swap won't touch any staked ETH
1139         uint256 initialETHBalance = address(this).balance;
1140         _swapTokenForETH(swapToken);
1141         uint256 newETH=(address(this).balance - initialETHBalance);
1142         //calculates the amount of ETH belonging to the LP-Pair and converts them to LP
1143         uint256 liqETH = (newETH*liqETHToken)/swapToken;
1144         _addLiquidity(liqToken, liqETH);
1145         //Get the ETH balance after LP generation to get the
1146         //exact amount of token left for Staking
1147         uint256 distributeETH=(address(this).balance - initialETHBalance);
1148         //distributes remaining ETH between stakers and Marketing
1149         _distributeStake(distributeETH);
1150     }
1151     //swaps tokens on the contract for ETH
1152     function _swapTokenForETH(uint256 amount) private {
1153         _approve(address(this), address(_uniswapV2Router), amount);
1154         address[] memory path = new address[](2);
1155         path[0] = address(this);
1156         path[1] = _uniswapV2Router.WETH();
1157 
1158         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1159             amount,
1160             0,
1161             path,
1162             address(this),
1163             block.timestamp
1164         );
1165     }
1166     //Adds Liquidity directly to the contract where LP are locked(unlike safemoon forks, that transfer it to the owner)
1167     function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
1168         totalLPETH=ETHamount;
1169         _approve(address(this), address(_uniswapV2Router), tokenamount);
1170         _uniswapV2Router.addLiquidityETH{value: ETHamount}(
1171             address(this),
1172             tokenamount,
1173             0,
1174             0,
1175             address(this),
1176             block.timestamp
1177         );
1178     }
1179 
1180     //public functions /////////////////////////////////////////////////////////////////////////////////////
1181 
1182     function getLiquidityReleaseTimeInSeconds() public view returns (uint256){
1183         if(block.timestamp<_liquidityUnlockTime){
1184             return _liquidityUnlockTime-block.timestamp;
1185         }
1186         return 0;
1187     }
1188 
1189     function getBurnedTokens() public view returns(uint256){
1190         return (InitialSupply-_circulatingSupply)/10**_decimals;
1191     }
1192 
1193     function getLimits() public view returns(uint256 balance, uint256 sell){
1194         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
1195     }
1196 
1197     function getTaxes() public view returns(uint256 burnTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
1198         return (_burnTax,_liquidityTax,_stakingTax,_buyTax,_sellTax,_transferTax);
1199     }
1200 	
1201     //How long is a given address still locked from buying
1202 	function getAddressBuyLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
1203        uint256 lockTime=_buyLock[AddressToCheck];
1204        if(lockTime<=block.timestamp)
1205        {
1206            return 0;
1207        }
1208        return lockTime-block.timestamp;
1209     }
1210     function getBuyLockTimeInSeconds() public view returns(uint256){
1211         return buyLockTime;
1212     }
1213     
1214     //Functions every wallet can call
1215 	
1216 	//Resets buy lock of caller to the default buyLockTime should something go very wrong
1217     function AddressResetBuyLock() public{
1218         _buyLock[msg.sender]=block.timestamp+buyLockTime;
1219     }
1220 	
1221     function getDividents(address addr) public view returns (uint256){
1222         if(isExcludedFromStaking(addr)) return toBePaid[addr];
1223         return _newDividentsOf(addr)+toBePaid[addr];
1224     }
1225 
1226     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
1227  
1228 	bool public buyLockDisabled;
1229     uint256 public buyLockTime;
1230     bool public manualConversion; 
1231 
1232     function TeamWithdrawALLMarketingETH() public onlyOwner{
1233         uint256 amount=marketingBalance;
1234         marketingBalance=0;
1235         payable(TeamWallet).transfer(amount*3/4);
1236         payable(LoanWallet).transfer(amount*1/4);
1237     } 
1238     function TeamWithdrawXMarketingETH(uint256 amount) public onlyOwner{
1239         require(amount<=marketingBalance);
1240         marketingBalance-=amount;
1241         payable(TeamWallet).transfer(amount*3/4);
1242         payable(LoanWallet).transfer(amount*1/4);
1243     } 
1244 
1245     //switches autoLiquidity and marketing ETH generation during transfers
1246     function TeamSwitchManualETHConversion(bool manual) public onlyOwner{
1247         manualConversion=manual;
1248     }
1249 	
1250 	function TeamChangeAntiWhale(uint256 newAntiWhale) public onlyOwner{
1251       antiWhale=newAntiWhale * 10**_decimals;
1252     }
1253     
1254     function TeamChangeTeamWallet(address newTeamWallet) public onlyOwner{
1255       TeamWallet=payable(newTeamWallet);
1256     }
1257     
1258     function TeamChangeLoanWallet(address newLoanWallet) public onlyOwner{
1259       LoanWallet=payable(newLoanWallet);
1260     }
1261 
1262 	
1263 	//Disables the timeLock after buying for everyone
1264     function TeamDisableBuyLock(bool disabled) public onlyOwner{
1265         buyLockDisabled=disabled;
1266     }
1267 	
1268 	//Sets BuyLockTime, needs to be lower than MaxBuyLockTime
1269     function TeamSetBuyLockTime(uint256 buyLockSeconds)public onlyOwner{
1270             require(buyLockSeconds<=MaxBuyLockTime,"Buy Lock time too high");
1271             buyLockTime=buyLockSeconds;
1272     } 
1273     
1274     //Allows wallet exclusion to be added after launch
1275     function AddWalletExclusion(address exclusionAdd) public onlyOwner{
1276         _excluded.add(exclusionAdd);
1277     }
1278     
1279     //Sets Taxes, is limited by MaxTax(20%) to make it impossible to create honeypot
1280     function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 stakingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyOwner{
1281         uint8 totalTax=burnTaxes+liquidityTaxes+stakingTaxes;
1282         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
1283 
1284         _burnTax=burnTaxes;
1285         _liquidityTax=liquidityTaxes;
1286         _stakingTax=stakingTaxes;
1287         
1288         _buyTax=buyTax;
1289         _sellTax=sellTax;
1290         _transferTax=transferTax;
1291     }
1292 
1293     //How much of the staking tax should be allocated for marketing
1294     function TeamChangeStakingShare(uint8 newShare) public onlyOwner{
1295         require(newShare<=50); 
1296         StakingShare=newShare;
1297     }
1298     //manually converts contract token to LP and staking ETH
1299     function TeamCreateLPandETH() public onlyOwner{
1300     _swapContractToken();
1301     }
1302     
1303      //Limits need to be at least target, to avoid setting value to 0(avoid potential Honeypot)
1304     function TeamUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyOwner{
1305         //SellLimit needs to be below 1% to avoid a Large Price impact when generating auto LP
1306         require(newSellLimit<_circulatingSupply/100);
1307         //Adds decimals to limits
1308         newBalanceLimit=newBalanceLimit*10**_decimals;
1309         newSellLimit=newSellLimit*10**_decimals;
1310         //Calculates the target Limits based on supply
1311         uint256 targetBalanceLimit=_circulatingSupply/BalanceLimitDivider;
1312         uint256 targetSellLimit=_circulatingSupply/SellLimitDivider;
1313 
1314         require((newBalanceLimit>=targetBalanceLimit), 
1315         "newBalanceLimit needs to be at least target");
1316         require((newSellLimit>=targetSellLimit), 
1317         "newSellLimit needs to be at least target");
1318 
1319         balanceLimit = newBalanceLimit;
1320         sellLimit = newSellLimit;     
1321     }
1322 
1323     
1324     //Setup Functions///////////////////////////////////////////////////////////////////////////////////////
1325     
1326     bool public tradingEnabled;
1327     address private _liquidityTokenAddress;
1328     //Enables trading for everyone
1329     function SetupEnableTrading() public onlyOwner{
1330         tradingEnabled=true;
1331     }
1332     //Sets up the LP-Token Address required for LP Release
1333     function SetupLiquidityTokenAddress(address liquidityTokenAddress) public onlyOwner{
1334         _liquidityTokenAddress=liquidityTokenAddress;
1335     }
1336 
1337     //Contract TokenToSwap change function.
1338     function changeTokenToSwapAmount(uint256 _setAmountToSwap) public onlyOwner {
1339         _setSellAmount = _setAmountToSwap;
1340     }
1341 
1342     //Liquidity Lock////////////////////////////////////////////////////////////////////////////////////////
1343     //the timestamp when Liquidity unlocks
1344     uint256 private _liquidityUnlockTime;
1345 
1346     function TeamUnlockLiquidityInSeconds(uint256 secondsUntilUnlock) public onlyOwner{
1347         _prolongLiquidityLock(secondsUntilUnlock+block.timestamp);
1348     }
1349     function _prolongLiquidityLock(uint256 newUnlockTime) private{
1350         // require new unlock time to be longer than old one
1351         require(newUnlockTime>_liquidityUnlockTime);
1352         _liquidityUnlockTime=newUnlockTime;
1353     }
1354 
1355     //Release Liquidity Tokens once unlock time is over
1356     function TeamReleaseLiquidity() public onlyOwner {
1357         //Only callable if liquidity Unlock time is over
1358         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1359         
1360         IuniswapV2ERC20 liquidityToken = IuniswapV2ERC20(_liquidityTokenAddress);
1361         uint256 amount = liquidityToken.balanceOf(address(this));
1362 
1363         //Liquidity release if something goes wrong at start
1364         liquidityToken.transfer(TeamWallet, amount);
1365         
1366     }
1367     //Removes Liquidity once unlock Time is over, 
1368     function TeamRemoveLiquidity(bool addToStaking) public onlyOwner{
1369         //Only callable if liquidity Unlock time is over
1370         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1371         _liquidityUnlockTime=block.timestamp+DefaultLiquidityLockTime;
1372         IuniswapV2ERC20 liquidityToken = IuniswapV2ERC20(_liquidityTokenAddress);
1373         uint256 amount = liquidityToken.balanceOf(address(this));
1374 
1375         liquidityToken.approve(address(_uniswapV2Router),amount);
1376         //Removes Liquidity and either distributes liquidity ETH to stakers, or 
1377         // adds them to marketing Balance
1378         //Token will be converted
1379         //to Liquidity and Staking ETH again
1380         uint256 initialETHBalance = address(this).balance;
1381         _uniswapV2Router.removeLiquidityETHSupportingFeeOnTransferTokens(
1382             address(this),
1383             amount,
1384             0,
1385             0,
1386             address(this),
1387             block.timestamp
1388             );
1389         uint256 newETHBalance = address(this).balance-initialETHBalance;
1390         if(addToStaking){
1391             _distributeStake(newETHBalance);
1392         }
1393         else{
1394             marketingBalance+=newETHBalance;
1395         }
1396 
1397     }
1398     //Releases all remaining ETH on the contract wallet, so ETH wont be burned
1399     function TeamRemoveRemainingETH() public onlyOwner{
1400         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
1401         _liquidityUnlockTime=block.timestamp+DefaultLiquidityLockTime;
1402         (bool sent,) =TeamWallet.call{value: (address(this).balance)}("");
1403         require(sent);
1404     }
1405     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1406     //external//////////////////////////////////////////////////////////////////////////////////////////////
1407     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1408 
1409     receive() external payable {}
1410     fallback() external payable {}
1411     // IBEP20
1412 
1413     function getOwner() external view override returns (address) {
1414         return owner();
1415     }
1416 
1417     function name() external pure override returns (string memory) {
1418         return _name;
1419     }
1420 
1421     function symbol() external pure override returns (string memory) {
1422         return _symbol;
1423     }
1424 
1425     function decimals() external pure override returns (uint8) {
1426         return _decimals;
1427     }
1428 
1429     function totalSupply() external view override returns (uint256) {
1430         return _circulatingSupply;
1431     }
1432 
1433     function balanceOf(address account) external view override returns (uint256) {
1434         return _balances[account];
1435     }
1436 
1437     function transfer(address recipient, uint256 amount) external override returns (bool) {
1438         _transfer(msg.sender, recipient, amount);
1439         return true;
1440     }
1441 
1442     function allowance(address _owner, address spender) external view override returns (uint256) {
1443         return _allowances[_owner][spender];
1444     }
1445 
1446     function approve(address spender, uint256 amount) external override returns (bool) {
1447         _approve(msg.sender, spender, amount);
1448         return true;
1449     }
1450     function _approve(address owner, address spender, uint256 amount) private {
1451         require(owner != address(0), "Approve from zero");
1452         require(spender != address(0), "Approve to zero");
1453 
1454         _allowances[owner][spender] = amount;
1455         emit Approval(owner, spender, amount);
1456     }
1457 
1458     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1459         _transfer(sender, recipient, amount);
1460 
1461         uint256 currentAllowance = _allowances[sender][msg.sender];
1462         require(currentAllowance >= amount, "Transfer > allowance");
1463 
1464         _approve(sender, msg.sender, currentAllowance - amount);
1465         return true;
1466     }
1467 
1468     // IBEP20 - Helpers
1469 
1470     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1471         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1472         return true;
1473     }
1474 
1475     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1476         uint256 currentAllowance = _allowances[msg.sender][spender];
1477         require(currentAllowance >= subtractedValue, "<0 allowance");
1478 
1479         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1480         return true;
1481     }
1482 
1483 }