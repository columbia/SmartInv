1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
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
21 interface IPancakeERC20 {
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
40 interface IPancakeFactory {
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
53 interface IPancakeRouter01 {
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
146 interface IPancakeRouter02 is IPancakeRouter01 {
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
731 
732 
733 
734 ////////////////////////////////////////////////////////////////////////////////////////////////////////
735 //KaibaInu Contract ////////////////////////////////////////////////////////////////////////////////
736 ////////////////////////////////////////////////////////////////////////////////////////////////////////
737 contract KaibaInu is IBEP20, Ownable
738 {
739     using Address for address;
740     using EnumerableSet for EnumerableSet.AddressSet;
741     
742     mapping (address => uint256) private _balances;
743     mapping (address => mapping (address => uint256)) private _allowances;
744     mapping (address => uint256) private _sellLock;
745 	mapping (address => bool) public wListed;
746 	
747 
748     EnumerableSet.AddressSet private _excluded;
749     EnumerableSet.AddressSet private _whiteList;
750     EnumerableSet.AddressSet private _excludedFromSellLock;
751     EnumerableSet.AddressSet private _excludedFromRaffle;
752     
753     mapping (address => bool) public _blacklist;
754     bool isBlacklist = true;
755     
756     //Token Info 
757     string private constant _name = 'Kaiba Inu';
758     string private constant _symbol = 'KAIBA';
759     uint8 private constant _decimals = 9;
760     uint256 public constant InitialSupply= 100 * 10**6 * 10**_decimals;//equals 100.000.000 token
761 
762     uint256 swapLimit = 1 * 10**5 * 10**_decimals;
763     bool isSwapPegged = true;
764     
765     //Divider for the buyLimit based on circulating Supply (1%)
766     uint16 public constant BuyLimitDivider=100;
767     //Divider for the MaxBalance based on circulating Supply (1.5%)
768     uint8 public constant BalanceLimitDivider=65;
769     //Divider for the Whitelist MaxBalance based on initial Supply(1.5%)
770     uint16 public constant WhiteListBalanceLimitDivider=65;
771     //Divider for sellLimit based on circulating Supply (1%)
772     uint16 public constant SellLimitDivider=100;
773     //Sellers get locked for MaxSellLockTime so they can't dump repeatedly
774     uint16 public constant MaxSellLockTime= 1 seconds;
775     // Team wallets
776     address public constant TeamWallet=0xDdeb06c15A7bd863bc38c9c071E0D13355476c48;
777     address public constant SecondTeamWallet=0x9e25C82A0d297D009A28f0d9418b0F28e14920be;
778     //TODO: Change to Mainnet
779     //TestNet
780     //address private constant PancakeRouter=0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
781     //MainNet
782     // 0x10ED43C718714eb63d5aA57B78B54704E256024E
783     address private constant PancakeRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
784 
785     //variables that track balanceLimit and sellLimit,
786     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
787     uint256 private _circulatingSupply =InitialSupply;
788     uint256 public  balanceLimit = _circulatingSupply;
789     uint256 public  sellLimit = _circulatingSupply;
790     uint256 public  buyLimit = _circulatingSupply;
791     address[] public triedToDump;
792 
793     //Limits max tax, only gets applied for tax changes, doesn't affect inital Tax
794     uint8 public constant MaxTax=95;
795     
796     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
797     uint8 private _buyTax;
798     uint8 private _sellTax;
799     uint8 private _transferTax;
800     bool botRekt = false;
801     uint8 private _burnTax;
802     uint8 private _liquidityTax;
803     uint8 private _marketingTax;
804     
805     bool isTokenSwapManual = true;
806 
807        
808     address private _pancakePairAddress; 
809     IPancakeRouter02 private  _pancakeRouter;
810     
811     //modifier for functions only the team can call
812     modifier onlyTeam() {
813         require(_isTeam(msg.sender), "Caller not in Team");
814         _;
815     }
816     //Checks if address is in Team, is needed to give Team access even if contract is renounced
817     //Team doesn't have access to critical Functions that could turn this into a Rugpull(Exept liquidity unlocks)
818     function _isTeam(address addr) private view returns (bool){
819         return addr==owner()||addr==TeamWallet||addr==SecondTeamWallet;
820     }
821 
822 
823     ////////////////////////////////////////////////////////////////////////////////////////////////////////
824     //Constructor///////////////////////////////////////////////////////////////////////////////////////////
825     ////////////////////////////////////////////////////////////////////////////////////////////////////////
826     constructor () {
827         //contract creator gets 90% of the token to create LP-Pair
828         uint256 deployerBalance=_circulatingSupply*9/10;
829         _balances[msg.sender] = deployerBalance;
830         emit Transfer(address(0), msg.sender, deployerBalance);
831         //contract gets 10% of the token to generate LP token and Marketing Budget fase
832         //contract will sell token over the first 200 sells to generate maximum LP and BNB
833         uint256 injectBalance=_circulatingSupply-deployerBalance;
834         _balances[address(this)]=injectBalance;
835        emit Transfer(address(0), address(this),injectBalance);
836 
837         // Pancake Router
838         _pancakeRouter = IPancakeRouter02(PancakeRouter);
839         //Creates a Pancake Pair
840         _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
841         
842         //Sets Buy/Sell limits
843         balanceLimit=InitialSupply/BalanceLimitDivider;
844         sellLimit=InitialSupply/SellLimitDivider;
845         buyLimit=InitialSupply/BuyLimitDivider;
846 
847        //Sets sellLockTime to be 2 seconds by default
848         sellLockTime=2 seconds;
849 
850         //Set Starting Tax to very high percentage(36%) to achieve maximum burn in the beginning
851         //as in the beginning there is the highest token volume
852         //any change in tax rate needs to be below maxTax(20%)
853         _buyTax=6;
854         _sellTax=6;//Sell Tax is lower, as otherwise slippage would be too high to sell
855         _transferTax=6;
856         //a small percentage gets added to the Contract token as 10% of token are already injected to 
857         //be converted to LP and MarketingBNB
858         _liquidityTax=65;
859         _marketingTax=35;
860         //Team wallet and deployer are excluded from Taxes
861         _excluded.add(TeamWallet);
862         _excluded.add(SecondTeamWallet);
863         _excluded.add(msg.sender);
864         //excludes Pancake Router, pair, contract and burn address from staking
865         _excludedFromRaffle.add(address(_pancakeRouter));
866         _excludedFromRaffle.add(_pancakePairAddress);
867         _excludedFromRaffle.add(address(this));
868         _excludedFromRaffle.add(0x000000000000000000000000000000000000dEaD);
869         _excludedFromSellLock.add(address(_pancakeRouter));
870         _excludedFromSellLock.add(_pancakePairAddress);
871         _excludedFromSellLock.add(address(this));
872     }
873 
874     ////////////////////////////////////////////////////////////////////////////////////////////////////////
875     //Transfer functionality////////////////////////////////////////////////////////////////////////////////
876     ////////////////////////////////////////////////////////////////////////////////////////////////////////
877 
878     //transfer function, every transfer runs through this function
879     function _transfer(address sender, address recipient, uint256 amount) private{
880         require(sender != address(0), "Transfer from zero");
881         require(recipient != address(0), "Transfer to zero");
882         
883         
884         //Manually Excluded adresses are transfering tax and lock free
885         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
886         
887         //Transactions from and to the contract are always tax and lock free
888         bool isContractTransfer=(sender==address(this) || recipient==address(this));
889         
890         //transfers between PancakeRouter and PancakePair are tax and lock free
891         address pancakeRouter=address(_pancakeRouter);
892         bool isLiquidityTransfer = ((sender == _pancakePairAddress && recipient == pancakeRouter) 
893         || (recipient == _pancakePairAddress && sender == pancakeRouter));
894 
895         //differentiate between buy/sell/transfer to apply different taxes/restrictions
896         bool isBuy=sender==_pancakePairAddress|| sender == pancakeRouter;
897         bool isSell=recipient==_pancakePairAddress|| recipient == pancakeRouter;
898 
899         //Pick transfer
900         if(isContractTransfer || isLiquidityTransfer || isExcluded){
901             _feelessTransfer(sender, recipient, amount);
902         }
903         else{ 
904             //once trading is enabled, it can't be turned off again
905             if (!tradingEnabled) {
906                 if (sender != owner() && recipient != owner()) {
907                     if (!wListed[sender] && !wListed[recipient]) {
908                         if (botRekt) {
909                            emit Transfer(sender,recipient,0);
910                            return;
911                         }
912                         else {
913                             require(tradingEnabled,"trading not yet enabled");
914                         }
915                     }
916                 }
917             }
918             if(whiteListTrading){
919                 _whiteListTransfer(sender,recipient,amount,isBuy,isSell);
920             }
921             else{
922                 _taxedTransfer(sender,recipient,amount,isBuy,isSell);                  
923             }
924         }
925     }
926     //if whitelist is active, all taxed transfers run through this
927     function _whiteListTransfer(address sender, address recipient,uint256 amount,bool isBuy,bool isSell) private{
928         //only apply whitelist restrictions during buys and transfers
929         if(!isSell){
930             //the recipient needs to be on Whitelist. Works for both buys and transfers.
931             //transfers to other whitelisted addresses are allowed.
932             require(_whiteList.contains(recipient),"recipient not on whitelist");
933             //Limit is 1/500 of initialSupply during whitelist, to allow for a large whitelist without causing a massive
934             //price impact of the whitelist
935             require((_balances[recipient]+amount<=InitialSupply/WhiteListBalanceLimitDivider),"amount exceeds whitelist max");    
936         }
937         _taxedTransfer(sender,recipient,amount,isBuy,isSell);
938 
939     }  
940     //applies taxes, checks for limits, locks generates autoLP and stakingBNB, and autostakes
941     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
942         uint256 recipientBalance = _balances[recipient];
943         uint256 senderBalance = _balances[sender];
944         require(senderBalance >= amount, "Transfer exceeds balance");
945 
946 
947         swapLimit = sellLimit/2;
948         
949         uint8 tax;
950         if(isSell){
951             if(isBlacklist) {
952                 require(!_blacklist[sender]);
953             }
954             if(!_excludedFromSellLock.contains(sender)){
955                 //If seller sold less than sellLockTime(2h) ago, sell is declined, can be disabled by Team         
956                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
957                 //Sets the time sellers get locked(2 hours by default)
958                 _sellLock[sender]=block.timestamp+sellLockTime;
959             }
960             //Sells can't exceed the sell limit(50.000 Tokens at start, can be updated to circulating supply)
961             if(amount>sellLimit) {
962                 triedToDump.push(sender);
963             }
964             require(amount<=sellLimit,"Dump protection");
965             tax=_sellTax;
966 
967         } else if(isBuy){
968             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
969             require(recipientBalance+amount<=balanceLimit,"whale protection");
970             require(amount<=buyLimit, "whale protection");
971             tax=_buyTax;
972 
973         } else {//Transfer
974             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
975             require(recipientBalance+amount<=balanceLimit,"whale protection");
976             //Transfers are disabled in sell lock, this doesn't stop someone from transfering before
977             //selling, but there is no satisfying solution for that, and you would need to pax additional tax
978             if(!_excludedFromSellLock.contains(sender))
979                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
980             tax=_transferTax;
981 
982         }     
983         //Swapping AutoLP and MarketingBNB is only possible if sender is not pancake pair, 
984         //if its not manually disabled, if its not already swapping and if its a Sell to avoid
985         // people from causing a large price impact from repeatedly transfering when theres a large backlog of Tokens
986         if((sender!=_pancakePairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
987             _swapContractToken(amount);
988         //staking and liquidity Tax get treated the same, only during conversion they get split
989         uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax);
990         //Subtract the Taxed Tokens from the amount
991         uint256 taxedAmount=amount-(contractToken);
992 
993         //Removes token and handles staking
994         _removeToken(sender,amount);
995         
996         //Adds the taxed tokens to the contract wallet
997         _balances[address(this)] += contractToken;
998 
999         //Adds token and handles staking
1000         _addToken(recipient, taxedAmount);
1001         
1002         emit Transfer(sender,recipient,taxedAmount);
1003         
1004 
1005 
1006     }
1007     //Feeless transfer only transfers and autostakes
1008     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
1009         uint256 senderBalance = _balances[sender];
1010         require(senderBalance >= amount, "Transfer exceeds balance");
1011         //Removes token and handles staking
1012         _removeToken(sender,amount);
1013         //Adds token and handles staking
1014         _addToken(recipient, amount);
1015         
1016         emit Transfer(sender,recipient,amount);
1017 
1018     }
1019     //Calculates the token that should be taxed
1020     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
1021         return (amount*tax*taxPercent) / 10000;
1022     }
1023     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1024     //BNB Autostake/////////////////////////////////////////////////////////////////////////////////////////
1025     //////////////////////////////////////////////////////////////////////////////////////////////////////// 
1026     //Autostake uses the balances of each holder to redistribute auto generated BNB.
1027     //Each transaction _addToken and _removeToken gets called for the transaction amount
1028     //WithdrawBNB can be used for any holder to withdraw BNB at any time, like true Staking,
1029     //so unlike MRAT clones you can leave and forget your Token and claim after a while
1030 
1031     //adds Token to balances, adds new BNB to the toBePaid mapping and resets staking
1032     function _addToken(address addr, uint256 amount) private {
1033         //the amount of token after transfer
1034         uint256 newAmount=_balances[addr]+amount;
1035         _balances[addr]=newAmount;
1036 
1037     }
1038     
1039     
1040     //removes Token, adds BNB to the toBePaid mapping and resets staking
1041     function _removeToken(address addr, uint256 amount) private {
1042         //the amount of token after transfer
1043         uint256 newAmount=_balances[addr]-amount;
1044          _balances[addr]=newAmount;
1045     }
1046 
1047     //lock for the withdraw
1048     bool private _isTokenSwaping;
1049     //the total reward distributed through staking, for tracking purposes
1050     uint256 public totalTokenSwapGenerated;
1051     //the total payout through staking, for tracking purposes
1052     uint256 public totalPayouts;
1053     
1054     //marketing share of the TokenSwap tax
1055     uint8 public marketingShare=100;
1056     //balance that is claimable by the team
1057     uint256 public marketingBalance;
1058 
1059     //Mapping of shares that are reserved for payout
1060     mapping(address => uint256) private toBePaid;
1061 
1062     //Contract, pancake and burnAddress are excluded, other addresses like CEX
1063     //can be manually excluded, excluded list is limited to 30 entries to avoid a
1064     //out of gas exeption during sells
1065     function isexcludedFromRaffle(address addr) public view returns (bool){
1066         return _excludedFromRaffle.contains(addr);
1067     }
1068 
1069     //distributes bnb between marketing share and dividents 
1070     function _distributeFeesBNB(uint256 BNBamount) private {
1071         // Deduct marketing Tax
1072         uint256 marketingSplit = (BNBamount * marketingShare) / 100;
1073 
1074         marketingBalance+=marketingSplit;
1075 
1076     }
1077     
1078 
1079 
1080     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1081     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
1082     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1083     
1084     //tracks auto generated BNB, useful for ticker etc
1085     uint256 public totalLPBNB;
1086     //Locks the swap if already swapping
1087     bool private _isSwappingContractModifier;
1088     modifier lockTheSwap {
1089         _isSwappingContractModifier = true;
1090         _;
1091         _isSwappingContractModifier = false;
1092     }
1093 
1094     //swaps the token on the contract for Marketing BNB and LP Token.
1095     //always swaps the sellLimit of token to avoid a large price impact
1096     function _swapContractToken(uint256 totalMax) private lockTheSwap{
1097         uint256 contractBalance=_balances[address(this)];
1098         uint16 totalTax=_liquidityTax+_marketingTax;
1099         uint256 tokenToSwap=swapLimit;
1100         if(tokenToSwap > totalMax) {
1101             if(isSwapPegged) {
1102                 tokenToSwap = totalMax;
1103             }
1104         }
1105         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
1106         if(contractBalance<tokenToSwap||totalTax==0){
1107             return;
1108         }
1109         //splits the token in TokenForLiquidity and tokenForMarketing
1110         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
1111         uint256 tokenForMarketing= tokenToSwap-tokenForLiquidity;
1112 
1113         //splits tokenForLiquidity in 2 halves
1114         uint256 liqToken=tokenForLiquidity/2;
1115         uint256 liqBNBToken=tokenForLiquidity-liqToken;
1116 
1117         //swaps marktetingToken and the liquidity token half for BNB
1118         uint256 swapToken=liqBNBToken+tokenForMarketing;
1119         //Gets the initial BNB balance, so swap won't touch any staked BNB
1120         uint256 initialBNBBalance = address(this).balance;
1121         _swapTokenForBNB(swapToken);
1122         uint256 newBNB=(address(this).balance - initialBNBBalance);
1123         //calculates the amount of BNB belonging to the LP-Pair and converts them to LP
1124         uint256 liqBNB = (newBNB*liqBNBToken)/swapToken;
1125         _addLiquidity(liqToken, liqBNB);
1126         //Get the BNB balance after LP generation to get the
1127         //exact amount of token left for Staking
1128         uint256 generatedBNB=(address(this).balance - initialBNBBalance);
1129         //distributes remaining BNB between stakers and Marketing
1130         _distributeFeesBNB(generatedBNB);
1131     }
1132     //swaps tokens on the contract for BNB
1133     function _swapTokenForBNB(uint256 amount) private {
1134         _approve(address(this), address(_pancakeRouter), amount);
1135         address[] memory path = new address[](2);
1136         path[0] = address(this);
1137         path[1] = _pancakeRouter.WETH();
1138 
1139         _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1140             amount,
1141             0,
1142             path,
1143             address(this),
1144             block.timestamp
1145         );
1146     }
1147     //Adds Liquidity directly to the contract where LP are locked(unlike safemoon forks, that transfer it to the owner)
1148     function _addLiquidity(uint256 tokenamount, uint256 bnbamount) private {
1149         totalLPBNB+=bnbamount;
1150         _approve(address(this), address(_pancakeRouter), tokenamount);
1151         _pancakeRouter.addLiquidityETH{value: bnbamount}(
1152             address(this),
1153             tokenamount,
1154             0,
1155             0,
1156             address(this),
1157             block.timestamp
1158         );
1159     }
1160 
1161     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1162     //public functions /////////////////////////////////////////////////////////////////////////////////////
1163     //////////////////////////////////////////////////////////////////////////////////////////////////////// 
1164 
1165     function getBurnedTokens() public view returns(uint256){
1166         return (InitialSupply-_circulatingSupply)/10**_decimals;
1167     }
1168 
1169     function getLimits() public view returns(uint256 balance, uint256 sell){
1170         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
1171     }
1172 
1173     function getTaxes() public view returns(uint256 burnTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
1174         return (_burnTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
1175     }
1176 
1177     function getWhitelistedStatus(address AddressToCheck) public view returns(bool){
1178         return _whiteList.contains(AddressToCheck);
1179     }
1180     //How long is a given address still locked from selling
1181     function getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
1182        uint256 lockTime=_sellLock[AddressToCheck];
1183        if(lockTime<=block.timestamp)
1184        {
1185            return 0;
1186        }
1187        return lockTime-block.timestamp;
1188     }
1189     function getSellLockTimeInSeconds() public view returns(uint256){
1190         return sellLockTime;
1191     }
1192     
1193     //Functions every wallet can call
1194     //Resets sell lock of caller to the default sellLockTime should something go very wrong
1195     function AddressResetSellLock() public{
1196         _sellLock[msg.sender]=block.timestamp+sellLockTime;
1197     }
1198 
1199     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1200     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
1201     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1202 
1203     bool public sellLockDisabled;
1204     uint256 public sellLockTime;
1205     bool public manualConversion;
1206 
1207 
1208     function getDumpers() public view returns(address[] memory) {
1209         return triedToDump;
1210     }
1211     
1212     
1213     function TeamSetWhitelistedAddressAlt(address addy, bool booly) public onlyTeam {
1214         wListed[addy] = booly;
1215     }
1216     
1217     function TeamSetWhitelistedAddress(address addy, bool booly) public onlyTeam {
1218         wListed[addy] = booly;
1219         _excluded.add(addy);
1220     }
1221     
1222     
1223     function TeamSetWhitelistedAddressesAlt( address[] memory addy, bool booly) public onlyTeam {
1224         uint256 i;
1225         for(i=0; i<addy.length; i++) {
1226             wListed[addy[i]] = booly;
1227         }
1228     }
1229     
1230     function TeamSetWhitelistedAddresses( address[] memory addy, bool booly) public onlyTeam {
1231         uint256 i;
1232         for(i=0; i<addy.length; i++) {
1233             wListed[addy[i]] = booly;
1234             _excluded.add(addy[i]);
1235         }
1236     }
1237     
1238     function TeamSetPeggedSwap(bool isPegged) public onlyTeam {
1239         isSwapPegged = isPegged;
1240     }
1241     
1242 
1243     //Excludes account from Staking
1244     function TeamExcludeFromRaffle(address addr) public onlyTeam{
1245         require(!isexcludedFromRaffle(addr));
1246         _excludedFromRaffle.add(addr);
1247         
1248     }    
1249 
1250     //Includes excluded Account to staking
1251     function TeamIncludeToRaffle(address addr) public onlyTeam{
1252         require(isexcludedFromRaffle(addr));
1253         _excludedFromRaffle.remove(addr);
1254     }
1255 
1256     function TeamWithdrawMarketingBNB() public onlyTeam{
1257         uint256 amount=marketingBalance;
1258         marketingBalance=0;
1259         (bool sent,) =TeamWallet.call{value: (amount)}("");
1260         require(sent,"withdraw failed");
1261     } 
1262 
1263 
1264     //switches autoLiquidity and marketing BNB generation during transfers
1265     function TeamSwitchManualBNBConversion(bool manual) public onlyTeam{
1266         manualConversion=manual;
1267     }
1268     //Disables the timeLock after selling for everyone
1269     function TeamDisableSellLock(bool disabled) public onlyTeam{
1270         sellLockDisabled=disabled;
1271     }
1272     //Sets SellLockTime, needs to be lower than MaxSellLockTime
1273     function TeamSetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
1274             require(sellLockSeconds<=MaxSellLockTime,"Sell Lock time too high");
1275             sellLockTime=sellLockSeconds;
1276     } 
1277 
1278     //Sets Taxes, is limited by MaxTax(20%) to make it impossible to create honeypot
1279     function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
1280         uint8 totalTax=burnTaxes+liquidityTaxes+marketingTaxes;
1281         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
1282         require(buyTax<=MaxTax&&sellTax<=MaxTax&&transferTax<=MaxTax,"taxes higher than max tax");
1283         
1284         _burnTax=burnTaxes;
1285         _liquidityTax=liquidityTaxes;
1286         _marketingTax=marketingTaxes;
1287         
1288         _buyTax=buyTax;
1289         _sellTax=sellTax;
1290         _transferTax=transferTax;
1291     }
1292     //How much of the staking tax should be allocated for marketing
1293     function TeamChangeMarketingShare(uint8 newShare) public onlyTeam{
1294         marketingShare=newShare;
1295     }
1296     //manually converts contract token to LP and staking BNB
1297     function TeamManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
1298     _swapContractToken(_qty * 10**9);
1299     }
1300     //Exclude/Include account from fees (eg. CEX)
1301     function TeamExcludeAccountFromFees(address account) public onlyTeam {
1302         _excluded.add(account);
1303     }
1304     function TeamIncludeAccountToFees(address account) public onlyTeam {
1305         _excluded.remove(account);
1306     }
1307     //Exclude/Include account from fees (eg. CEX)
1308     function TeamExcludeAccountFromSellLock(address account) public onlyTeam {
1309         _excludedFromSellLock.add(account);
1310     }
1311     function TeamIncludeAccountToSellLock(address account) public onlyTeam {
1312         _excludedFromSellLock.remove(account);
1313     }
1314     
1315      //Limits need to be at least target, to avoid setting value to 0(avoid potential Honeypot)
1316     function TeamUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
1317         //Adds decimals to limits
1318         newBalanceLimit=newBalanceLimit*10**_decimals;
1319         newSellLimit=newSellLimit*10**_decimals;
1320         balanceLimit = newBalanceLimit;
1321         sellLimit = newSellLimit;     
1322     }
1323 
1324     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1325     //Setup Functions///////////////////////////////////////////////////////////////////////////////////////
1326     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1327 
1328     bool public tradingEnabled;
1329     bool public whiteListTrading;
1330     address private _liquidityTokenAddress;
1331     //Enables whitelist trading and locks Liquidity for a short time
1332     function SetupEnableWhitelistTrading() public onlyTeam{
1333         require(!tradingEnabled);
1334         //Sets up the excluded from staking list
1335         tradingEnabled=true;
1336         whiteListTrading=true;
1337     }
1338     //Enables trading for everyone
1339     function SetupEnableTrading() public onlyTeam{
1340         require(tradingEnabled&&whiteListTrading);
1341         whiteListTrading=false;
1342     }
1343 
1344     //Sets up the LP-Token Address required for LP Release
1345     function SetupLiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
1346         _liquidityTokenAddress=liquidityTokenAddress;
1347     }
1348     //Functions for whitelist
1349     function SetupAddToWhitelist(address addressToAdd) public onlyTeam{
1350         _whiteList.add(addressToAdd);
1351     }
1352     function SetupAddArrayToWhitelist(address[] memory addressesToAdd) public onlyTeam{
1353         for(uint i=0; i<addressesToAdd.length; i++){
1354             _whiteList.add(addressesToAdd[i]);
1355         }
1356     }
1357     function SetupRemoveFromWhitelist(address addressToRemove) public onlyTeam{
1358         _whiteList.remove(addressToRemove);
1359     } 
1360     
1361     
1362     function TeamRescueTokens(address tknAddress) public onlyTeam {
1363         IBEP20 token = IBEP20(tknAddress);
1364         uint256 ourBalance = token.balanceOf(address(this));
1365         require(ourBalance>0, "No tokens in our balance");
1366         token.transfer(msg.sender, ourBalance);
1367     }
1368     
1369     // Blacklists
1370     
1371     function setBlacklistEnabled(bool isBlacklistEnabled) public onlyTeam {
1372         isBlacklist = isBlacklistEnabled;
1373     }
1374     
1375     function setContractTokenSwapManual(bool manual) public onlyTeam {
1376         isTokenSwapManual = manual;
1377     }
1378     
1379     function setBlacklistedAddress(address toBlacklist) public onlyTeam {
1380         _blacklist[toBlacklist] = true;
1381     }
1382     
1383     function removeBlacklistedAddress(address toRemove) public onlyTeam {
1384         _blacklist[toRemove] = false;
1385     }
1386 
1387     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1388     //Utilities/////////////////////////////////////////////////////////////////////////////////////////////
1389     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1390     
1391     function TeamAvoidBurning() public onlyTeam{
1392         (bool sent,) =msg.sender.call{value: (address(this).balance)}("");
1393         require(sent);
1394     }
1395     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1396     //external//////////////////////////////////////////////////////////////////////////////////////////////
1397     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1398 
1399     receive() external payable {}
1400     fallback() external payable {}
1401     // IBEP20
1402 
1403     function getOwner() external view override returns (address) {
1404         return owner();
1405     }
1406 
1407     function name() external pure override returns (string memory) {
1408         return _name;
1409     }
1410 
1411     function symbol() external pure override returns (string memory) {
1412         return _symbol;
1413     }
1414 
1415     function decimals() external pure override returns (uint8) {
1416         return _decimals;
1417     }
1418 
1419     function totalSupply() external view override returns (uint256) {
1420         return _circulatingSupply;
1421     }
1422 
1423     function balanceOf(address account) external view override returns (uint256) {
1424         return _balances[account];
1425     }
1426 
1427     function transfer(address recipient, uint256 amount) external override returns (bool) {
1428         _transfer(msg.sender, recipient, amount);
1429         return true;
1430     }
1431 
1432     function allowance(address _owner, address spender) external view override returns (uint256) {
1433         return _allowances[_owner][spender];
1434     }
1435 
1436     function approve(address spender, uint256 amount) external override returns (bool) {
1437         _approve(msg.sender, spender, amount);
1438         return true;
1439     }
1440     function _approve(address owner, address spender, uint256 amount) private {
1441         require(owner != address(0), "Approve from zero");
1442         require(spender != address(0), "Approve to zero");
1443 
1444         _allowances[owner][spender] = amount;
1445         emit Approval(owner, spender, amount);
1446     }
1447 
1448     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1449         _transfer(sender, recipient, amount);
1450 
1451         uint256 currentAllowance = _allowances[sender][msg.sender];
1452         require(currentAllowance >= amount, "Transfer > allowance");
1453 
1454         _approve(sender, msg.sender, currentAllowance - amount);
1455         return true;
1456     }
1457 
1458     // IBEP20 - Helpers
1459 
1460     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1461         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1462         return true;
1463     }
1464 
1465     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1466         uint256 currentAllowance = _allowances[msg.sender][spender];
1467         require(currentAllowance >= subtractedValue, "<0 allowance");
1468 
1469         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1470         return true;
1471     }
1472 
1473 }