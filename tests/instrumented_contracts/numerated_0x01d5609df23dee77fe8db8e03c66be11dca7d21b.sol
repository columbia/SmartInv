1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.4;
8 
9 interface IBEP20 {
10   function totalSupply() external view returns (uint256);
11   function decimals() external view returns (uint8);
12   function symbol() external view returns (string memory);
13   function name() external view returns (string memory);
14   function getOwner() external view returns (address);
15   function balanceOf(address account) external view returns (uint256);
16   function transfer(address recipient, uint256 amount) external returns (bool);
17   function allowance(address _owner, address spender) external view returns (uint256);
18   function approve(address spender, uint256 amount) external returns (bool);
19   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 interface IPancakeERC20 {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28 
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42 }
43 
44 interface IPancakeFactory {
45     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
46 
47     function feeTo() external view returns (address);
48     function feeToSetter() external view returns (address);
49     function getPair(address tokenA, address tokenB) external view returns (address pair);
50     function allPairs(uint) external view returns (address pair);
51     function allPairsLength() external view returns (uint);
52     function createPair(address tokenA, address tokenB) external returns (address pair);
53     function setFeeTo(address) external;
54     function setFeeToSetter(address) external;
55 }
56 
57 interface IPancakeRouter01 {
58     function addLiquidity(
59         address tokenA,
60         address tokenB,
61         uint amountADesired,
62         uint amountBDesired,
63         uint amountAMin,
64         uint amountBMin,
65         address to,
66         uint deadline
67     ) external returns (uint amountA, uint amountB, uint liquidity);
68     function addLiquidityETH(
69         address token,
70         uint amountTokenDesired,
71         uint amountTokenMin,
72         uint amountETHMin,
73         address to,
74         uint deadline
75     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
76     function removeLiquidity(
77         address tokenA,
78         address tokenB,
79         uint liquidity,
80         uint amountAMin,
81         uint amountBMin,
82         address to,
83         uint deadline
84     ) external returns (uint amountA, uint amountB);
85     function removeLiquidityETH(
86         address token,
87         uint liquidity,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external returns (uint amountToken, uint amountETH);
93     function removeLiquidityWithPermit(
94         address tokenA,
95         address tokenB,
96         uint liquidity,
97         uint amountAMin,
98         uint amountBMin,
99         address to,
100         uint deadline,
101         bool approveMax, uint8 v, bytes32 r, bytes32 s
102     ) external returns (uint amountA, uint amountB);
103     function removeLiquidityETHWithPermit(
104         address token,
105         uint liquidity,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline,
110         bool approveMax, uint8 v, bytes32 r, bytes32 s
111     ) external returns (uint amountToken, uint amountETH);
112     function swapExactTokensForTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external returns (uint[] memory amounts);
119     function swapTokensForExactTokens(
120         uint amountOut,
121         uint amountInMax,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external returns (uint[] memory amounts);
126     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
127         external
128         payable
129         returns (uint[] memory amounts);
130     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
131         external
132         returns (uint[] memory amounts);
133     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
134         external
135         returns (uint[] memory amounts);
136     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
137         external
138         payable
139         returns (uint[] memory amounts);
140 
141     function factory() external pure returns (address);
142     function WETH() external pure returns (address);
143     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
144     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
145     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
146     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
147     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
148 }
149 
150 interface IPancakeRouter02 is IPancakeRouter01 {
151     function removeLiquidityETHSupportingFeeOnTransferTokens(
152         address token,
153         uint liquidity,
154         uint amountTokenMin,
155         uint amountETHMin,
156         address to,
157         uint deadline
158     ) external returns (uint amountETH);
159     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
160         address token,
161         uint liquidity,
162         uint amountTokenMin,
163         uint amountETHMin,
164         address to,
165         uint deadline,
166         bool approveMax, uint8 v, bytes32 r, bytes32 s
167     ) external returns (uint amountETH);
168     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175     function swapExactETHForTokensSupportingFeeOnTransferTokens(
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external payable;
181     function swapExactTokensForETHSupportingFeeOnTransferTokens(
182         uint amountIn,
183         uint amountOutMin,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external;
188 }
189 
190 
191 
192 /**
193  * @dev Contract module which provides a basic access control mechanism, where
194  * there is an account (an owner) that can be granted exclusive access to
195  * specific functions.
196  *
197  * By default, the owner account will be the one that deploys the contract. This
198  * can later be changed with {transferOwnership}.
199  *
200  * This module is used through inheritance. It will make available the modifier
201  * `onlyOwner`, which can be applied to your functions to restrict their use to
202  * the owner.
203  */
204 abstract contract Ownable {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev Initializes the contract setting the deployer as the initial owner.
211      */
212     constructor () {
213         address msgSender = msg.sender;
214         _owner = msgSender;
215         emit OwnershipTransferred(address(0), msgSender);
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(owner() == msg.sender, "Ownable: caller is not the owner");
230         _;
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public onlyOwner {
241         emit OwnershipTransferred(_owner, address(0));
242         _owner = address(0);
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Can only be called by the current owner.
248      */
249     function transferOwnership(address newOwner) public onlyOwner {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize, which returns 0 for contracts in
279         // construction, since the code is only stored at the end of the
280         // constructor execution.
281 
282         uint256 size;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { size := extcodesize(account) }
285         return size > 0;
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: value }(data);
371         return _verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
381         return functionStaticCall(target, data, "Address: low-level static call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return _verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
423         if (success) {
424             return returndata;
425         } else {
426             // Look for revert reason and bubble it up if present
427             if (returndata.length > 0) {
428                 // The easiest way to bubble the revert reason is using memory via assembly
429 
430                 // solhint-disable-next-line no-inline-assembly
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 /**
443  * @dev Library for managing
444  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
445  * types.
446  *
447  * Sets have the following properties:
448  *
449  * - Elements are added, removed, and checked for existence in constant time
450  * (O(1)).
451  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
452  *
453  * ```
454  * contract Example {
455  *     // Add the library methods
456  *     using EnumerableSet for EnumerableSet.AddressSet;
457  *
458  *     // Declare a set state variable
459  *     EnumerableSet.AddressSet private mySet;
460  * }
461  * ```
462  *
463  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
464  * and `uint256` (`UintSet`) are supported.
465  */
466 library EnumerableSet {
467     // To implement this library for multiple types with as little code
468     // repetition as possible, we write it in terms of a generic Set type with
469     // bytes32 values.
470     // The Set implementation uses private functions, and user-facing
471     // implementations (such as AddressSet) are just wrappers around the
472     // underlying Set.
473     // This means that we can only create new EnumerableSets for types that fit
474     // in bytes32.
475 
476     struct Set {
477         // Storage of set values
478         bytes32[] _values;
479 
480         // Position of the value in the `values` array, plus 1 because index 0
481         // means a value is not in the set.
482         mapping (bytes32 => uint256) _indexes;
483     }
484 
485     /**
486      * @dev Add a value to a set. O(1).
487      *
488      * Returns true if the value was added to the set, that is if it was not
489      * already present.
490      */
491     function _add(Set storage set, bytes32 value) private returns (bool) {
492         if (!_contains(set, value)) {
493             set._values.push(value);
494             // The value is stored at length-1, but we add 1 to all indexes
495             // and use 0 as a sentinel value
496             set._indexes[value] = set._values.length;
497             return true;
498         } else {
499             return false;
500         }
501     }
502 
503     /**
504      * @dev Removes a value from a set. O(1).
505      *
506      * Returns true if the value was removed from the set, that is if it was
507      * present.
508      */
509     function _remove(Set storage set, bytes32 value) private returns (bool) {
510         // We read and store the value's index to prevent multiple reads from the same storage slot
511         uint256 valueIndex = set._indexes[value];
512 
513         if (valueIndex != 0) { // Equivalent to contains(set, value)
514             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
515             // the array, and then remove the last element (sometimes called as 'swap and pop').
516             // This modifies the order of the array, as noted in {at}.
517 
518             uint256 toDeleteIndex = valueIndex - 1;
519             uint256 lastIndex = set._values.length - 1;
520 
521             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
522             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
523 
524             bytes32 lastvalue = set._values[lastIndex];
525 
526             // Move the last value to the index where the value to delete is
527             set._values[toDeleteIndex] = lastvalue;
528             // Update the index for the moved value
529             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
530 
531             // Delete the slot where the moved value was stored
532             set._values.pop();
533 
534             // Delete the index for the deleted slot
535             delete set._indexes[value];
536 
537             return true;
538         } else {
539             return false;
540         }
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function _contains(Set storage set, bytes32 value) private view returns (bool) {
547         return set._indexes[value] != 0;
548     }
549 
550     /**
551      * @dev Returns the number of values on the set. O(1).
552      */
553     function _length(Set storage set) private view returns (uint256) {
554         return set._values.length;
555     }
556 
557    /**
558     * @dev Returns the value stored at position `index` in the set. O(1).
559     *
560     * Note that there are no guarantees on the ordering of values inside the
561     * array, and it may change when more values are added or removed.
562     *
563     * Requirements:
564     *
565     * - `index` must be strictly less than {length}.
566     */
567     function _at(Set storage set, uint256 index) private view returns (bytes32) {
568         require(set._values.length > index, "EnumerableSet: index out of bounds");
569         return set._values[index];
570     }
571 
572     // Bytes32Set
573 
574     struct Bytes32Set {
575         Set _inner;
576     }
577 
578     /**
579      * @dev Add a value to a set. O(1).
580      *
581      * Returns true if the value was added to the set, that is if it was not
582      * already present.
583      */
584     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
585         return _add(set._inner, value);
586     }
587 
588     /**
589      * @dev Removes a value from a set. O(1).
590      *
591      * Returns true if the value was removed from the set, that is if it was
592      * present.
593      */
594     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
595         return _remove(set._inner, value);
596     }
597 
598     /**
599      * @dev Returns true if the value is in the set. O(1).
600      */
601     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
602         return _contains(set._inner, value);
603     }
604 
605     /**
606      * @dev Returns the number of values in the set. O(1).
607      */
608     function length(Bytes32Set storage set) internal view returns (uint256) {
609         return _length(set._inner);
610     }
611 
612    /**
613     * @dev Returns the value stored at position `index` in the set. O(1).
614     *
615     * Note that there are no guarantees on the ordering of values inside the
616     * array, and it may change when more values are added or removed.
617     *
618     * Requirements:
619     *
620     * - `index` must be strictly less than {length}.
621     */
622     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
623         return _at(set._inner, index);
624     }
625 
626     // AddressSet
627 
628     struct AddressSet {
629         Set _inner;
630     }
631 
632     /**
633      * @dev Add a value to a set. O(1).
634      *
635      * Returns true if the value was added to the set, that is if it was not
636      * already present.
637      */
638     function add(AddressSet storage set, address value) internal returns (bool) {
639         return _add(set._inner, bytes32(uint256(uint160(value))));
640     }
641 
642     /**
643      * @dev Removes a value from a set. O(1).
644      *
645      * Returns true if the value was removed from the set, that is if it was
646      * present.
647      */
648     function remove(AddressSet storage set, address value) internal returns (bool) {
649         return _remove(set._inner, bytes32(uint256(uint160(value))));
650     }
651 
652     /**
653      * @dev Returns true if the value is in the set. O(1).
654      */
655     function contains(AddressSet storage set, address value) internal view returns (bool) {
656         return _contains(set._inner, bytes32(uint256(uint160(value))));
657     }
658 
659     /**
660      * @dev Returns the number of values in the set. O(1).
661      */
662     function length(AddressSet storage set) internal view returns (uint256) {
663         return _length(set._inner);
664     }
665 
666    /**
667     * @dev Returns the value stored at position `index` in the set. O(1).
668     *
669     * Note that there are no guarantees on the ordering of values inside the
670     * array, and it may change when more values are added or removed.
671     *
672     * Requirements:
673     *
674     * - `index` must be strictly less than {length}.
675     */
676     function at(AddressSet storage set, uint256 index) internal view returns (address) {
677         return address(uint160(uint256(_at(set._inner, index))));
678     }
679 
680     // UintSet
681 
682     struct UintSet {
683         Set _inner;
684     }
685 
686     /**
687      * @dev Add a value to a set. O(1).
688      *
689      * Returns true if the value was added to the set, that is if it was not
690      * already present.
691      */
692     function add(UintSet storage set, uint256 value) internal returns (bool) {
693         return _add(set._inner, bytes32(value));
694     }
695 
696     /**
697      * @dev Removes a value from a set. O(1).
698      *
699      * Returns true if the value was removed from the set, that is if it was
700      * present.
701      */
702     function remove(UintSet storage set, uint256 value) internal returns (bool) {
703         return _remove(set._inner, bytes32(value));
704     }
705 
706     /**
707      * @dev Returns true if the value is in the set. O(1).
708      */
709     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
710         return _contains(set._inner, bytes32(value));
711     }
712 
713     /**
714      * @dev Returns the number of values on the set. O(1).
715      */
716     function length(UintSet storage set) internal view returns (uint256) {
717         return _length(set._inner);
718     }
719 
720    /**
721     * @dev Returns the value stored at position `index` in the set. O(1).
722     *
723     * Note that there are no guarantees on the ordering of values inside the
724     * array, and it may change when more values are added or removed.
725     *
726     * Requirements:
727     *
728     * - `index` must be strictly less than {length}.
729     */
730     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
731         return uint256(_at(set._inner, index));
732     }
733 }
734 
735 
736 
737 
738 ////////////////////////////////////////////////////////////////////////////////////////////////////////
739 //Mittens Contract ////////////////////////////////////////////////////////////////////////////////
740 ////////////////////////////////////////////////////////////////////////////////////////////////////////
741 contract Mittens is IBEP20, Ownable
742 {
743     using Address for address;
744     using EnumerableSet for EnumerableSet.AddressSet;
745 
746     mapping (address => uint256) private _balances;
747     mapping (address => mapping (address => uint256)) private _allowances;
748     mapping (address => uint256) private _sellLock;
749 	mapping (address => bool) public wListed;
750 
751 
752     EnumerableSet.AddressSet private _excluded;
753     EnumerableSet.AddressSet private _whiteList;
754     EnumerableSet.AddressSet private _excludedFromSellLock;
755     EnumerableSet.AddressSet private _excludedFromRaffle;
756 
757     mapping (address => bool) public _blacklist;
758     bool isBlacklist = true;
759 
760     //Token Info
761     string private constant _name = 'Mittens';
762     string private constant _symbol = 'MITTEN';
763     uint8 private constant _decimals = 9;
764     uint256 public constant InitialSupply= 1000000 * 10**6 * 10**_decimals;//equals 1.000.000.000.000 token
765 
766     uint256 swapLimit = 1000 * 10**5 * 10**_decimals;
767     bool isSwapPegged = true;
768 
769     //Divider for the buyLimit based on circulating Supply (1%)
770     uint16 public constant BuyLimitDivider=100;
771     //Divider for the MaxBalance based on circulating Supply (1.5%)
772     uint8 public constant BalanceLimitDivider=65;
773     //Divider for the Whitelist MaxBalance based on initial Supply(1.5%)
774     uint16 public constant WhiteListBalanceLimitDivider=65;
775     //Divider for sellLimit based on circulating Supply (1%)
776     uint16 public constant SellLimitDivider=100;
777     //Sellers get locked for MaxSellLockTime so they can't dump repeatedly
778     uint16 public constant MaxSellLockTime= 1 seconds;
779     // Team wallets
780     address public constant TeamWallet=0x87846A5B9304efd296e70c0e8cCd1fd80aAbB89B;
781     address public constant SecondTeamWallet=0x25e1884DA68CCc879e561Ef9Cd82b3ABFC2968Ce; //need ell or dev address
782     //TODO: Change to Mainnet
783     //TestNet
784     //address private constant PancakeRouter=0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
785     //MainNet
786     // 0x10ED43C718714eb63d5aA57B78B54704E256024E
787     address private constant PancakeRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
788 
789     //variables that track balanceLimit and sellLimit,
790     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
791     uint256 private _circulatingSupply =InitialSupply;
792     uint256 public  balanceLimit = _circulatingSupply;
793     uint256 public  sellLimit = _circulatingSupply;
794     uint256 public  buyLimit = _circulatingSupply;
795     address[] public triedToDump;
796 
797     //Limits max tax, only gets applied for tax changes, doesn't affect inital Tax
798     uint8 public constant MaxTax=95;
799 
800     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
801     uint8 private _buyTax;
802     uint8 private _sellTax;
803     uint8 private _transferTax;
804     bool botRekt = false;
805     uint8 private _burnTax;
806     uint8 private _liquidityTax;
807     uint8 private _marketingTax;
808 
809     bool isTokenSwapManual = true;
810 
811 
812     address private _pancakePairAddress;
813     IPancakeRouter02 private  _pancakeRouter;
814 
815     //modifier for functions only the team can call
816     modifier onlyTeam() {
817         require(_isTeam(msg.sender), "Caller not in Team");
818         _;
819     }
820     //Checks if address is in Team, is needed to give Team access even if contract is renounced
821     //Team doesn't have access to critical Functions that could turn this into a Rugpull(Exept liquidity unlocks)
822     function _isTeam(address addr) private view returns (bool){
823         return addr==owner()||addr==TeamWallet||addr==SecondTeamWallet;
824     }
825 
826 
827     ////////////////////////////////////////////////////////////////////////////////////////////////////////
828     //Constructor///////////////////////////////////////////////////////////////////////////////////////////
829     ////////////////////////////////////////////////////////////////////////////////////////////////////////
830     constructor () {
831         //contract creator gets 90% of the token to create LP-Pair
832         uint256 deployerBalance=_circulatingSupply*9/10;
833         _balances[msg.sender] = deployerBalance;
834         emit Transfer(address(0), msg.sender, deployerBalance);
835         //contract gets 10% of the token to generate LP token and Marketing Budget fase
836         //contract will sell token over the first 200 sells to generate maximum LP and BNB
837         uint256 injectBalance=_circulatingSupply-deployerBalance;
838         _balances[address(this)]=injectBalance;
839        emit Transfer(address(0), address(this),injectBalance);
840 
841         // Pancake Router
842         _pancakeRouter = IPancakeRouter02(PancakeRouter);
843         //Creates a Pancake Pair
844         _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
845 
846         //Sets Buy/Sell limits
847         balanceLimit=InitialSupply/BalanceLimitDivider;
848         sellLimit=InitialSupply/SellLimitDivider;
849         buyLimit=InitialSupply/BuyLimitDivider;
850 
851        //Sets sellLockTime to be 2 seconds by default
852         sellLockTime=2 seconds;
853 
854         //Set Starting Tax to very high percentage(36%) to achieve maximum burn in the beginning
855         //as in the beginning there is the highest token volume
856         //any change in tax rate needs to be below maxTax(20%)
857         _buyTax=11;
858         _sellTax=11;//Sell Tax is lower, as otherwise slippage would be too high to sell
859         _transferTax=11;
860         //a small percentage gets added to the Contract token as 10% of token are already injected to
861         //be converted to LP and MarketingBNB
862         _liquidityTax=20;
863         _marketingTax=80;
864         //Team wallet and deployer are excluded from Taxes
865         _excluded.add(TeamWallet);
866         _excluded.add(SecondTeamWallet);
867         _excluded.add(msg.sender);
868         //excludes Pancake Router, pair, contract and burn address from staking
869         _excludedFromRaffle.add(address(_pancakeRouter));
870         _excludedFromRaffle.add(_pancakePairAddress);
871         _excludedFromRaffle.add(address(this));
872         _excludedFromRaffle.add(0x000000000000000000000000000000000000dEaD);
873         _excludedFromSellLock.add(address(_pancakeRouter));
874         _excludedFromSellLock.add(_pancakePairAddress);
875         _excludedFromSellLock.add(address(this));
876     }
877 
878     ////////////////////////////////////////////////////////////////////////////////////////////////////////
879     //Transfer functionality////////////////////////////////////////////////////////////////////////////////
880     ////////////////////////////////////////////////////////////////////////////////////////////////////////
881 
882     //transfer function, every transfer runs through this function
883     function _transfer(address sender, address recipient, uint256 amount) private{
884         require(sender != address(0), "Transfer from zero");
885         require(recipient != address(0), "Transfer to zero");
886 
887 
888         //Manually Excluded adresses are transfering tax and lock free
889         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
890 
891         //Transactions from and to the contract are always tax and lock free
892         bool isContractTransfer=(sender==address(this) || recipient==address(this));
893 
894         //transfers between PancakeRouter and PancakePair are tax and lock free
895         address pancakeRouter=address(_pancakeRouter);
896         bool isLiquidityTransfer = ((sender == _pancakePairAddress && recipient == pancakeRouter)
897         || (recipient == _pancakePairAddress && sender == pancakeRouter));
898 
899         //differentiate between buy/sell/transfer to apply different taxes/restrictions
900         bool isBuy=sender==_pancakePairAddress|| sender == pancakeRouter;
901         bool isSell=recipient==_pancakePairAddress|| recipient == pancakeRouter;
902 
903         //Pick transfer
904         if(isContractTransfer || isLiquidityTransfer || isExcluded){
905             _feelessTransfer(sender, recipient, amount);
906         }
907         else{
908             //once trading is enabled, it can't be turned off again
909             if (!tradingEnabled) {
910                 if (sender != owner() && recipient != owner()) {
911                     if (!wListed[sender] && !wListed[recipient]) {
912                         if (botRekt) {
913                            emit Transfer(sender,recipient,0);
914                            return;
915                         }
916                         else {
917                             require(tradingEnabled,"trading not yet enabled");
918                         }
919                     }
920                 }
921             }
922             if(whiteListTrading){
923                 _whiteListTransfer(sender,recipient,amount,isBuy,isSell);
924             }
925             else{
926                 _taxedTransfer(sender,recipient,amount,isBuy,isSell);
927             }
928         }
929     }
930     //if whitelist is active, all taxed transfers run through this
931     function _whiteListTransfer(address sender, address recipient,uint256 amount,bool isBuy,bool isSell) private{
932         //only apply whitelist restrictions during buys and transfers
933         if(!isSell){
934             //the recipient needs to be on Whitelist. Works for both buys and transfers.
935             //transfers to other whitelisted addresses are allowed.
936             require(_whiteList.contains(recipient),"recipient not on whitelist");
937             //Limit is 1/500 of initialSupply during whitelist, to allow for a large whitelist without causing a massive
938             //price impact of the whitelist
939             require((_balances[recipient]+amount<=InitialSupply/WhiteListBalanceLimitDivider),"amount exceeds whitelist max");
940         }
941         _taxedTransfer(sender,recipient,amount,isBuy,isSell);
942 
943     }
944     //applies taxes, checks for limits, locks generates autoLP and stakingBNB, and autostakes
945     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
946         uint256 recipientBalance = _balances[recipient];
947         uint256 senderBalance = _balances[sender];
948         require(senderBalance >= amount, "Transfer exceeds balance");
949 
950 
951         swapLimit = sellLimit/2;
952 
953         uint8 tax;
954         if(isSell){
955             if(isBlacklist) {
956                 require(!_blacklist[sender]);
957             }
958             if(!_excludedFromSellLock.contains(sender)){
959                 //If seller sold less than sellLockTime(2h) ago, sell is declined, can be disabled by Team
960                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
961                 //Sets the time sellers get locked(2 hours by default)
962                 _sellLock[sender]=block.timestamp+sellLockTime;
963             }
964             //Sells can't exceed the sell limit(50.000 Tokens at start, can be updated to circulating supply)
965             if(amount>sellLimit) {
966                 triedToDump.push(sender);
967             }
968             require(amount<=sellLimit,"Dump protection");
969             tax=_sellTax;
970 
971         } else if(isBuy){
972             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
973             require(recipientBalance+amount<=balanceLimit,"whale protection");
974             require(amount<=buyLimit, "whale protection");
975             tax=_buyTax;
976 
977         } else {//Transfer
978             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
979             require(recipientBalance+amount<=balanceLimit,"whale protection");
980             //Transfers are disabled in sell lock, this doesn't stop someone from transfering before
981             //selling, but there is no satisfying solution for that, and you would need to pax additional tax
982             if(!_excludedFromSellLock.contains(sender))
983                 require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
984             tax=_transferTax;
985 
986         }
987         //Swapping AutoLP and MarketingBNB is only possible if sender is not pancake pair,
988         //if its not manually disabled, if its not already swapping and if its a Sell to avoid
989         // people from causing a large price impact from repeatedly transfering when theres a large backlog of Tokens
990         if((sender!=_pancakePairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
991             _swapContractToken(amount);
992         //staking and liquidity Tax get treated the same, only during conversion they get split
993         uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax);
994         //Subtract the Taxed Tokens from the amount
995         uint256 taxedAmount=amount-(contractToken);
996 
997         //Removes token and handles staking
998         _removeToken(sender,amount);
999 
1000         //Adds the taxed tokens to the contract wallet
1001         _balances[address(this)] += contractToken;
1002 
1003         //Adds token and handles staking
1004         _addToken(recipient, taxedAmount);
1005 
1006         emit Transfer(sender,recipient,taxedAmount);
1007 
1008 
1009 
1010     }
1011     //Feeless transfer only transfers and autostakes
1012     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
1013         uint256 senderBalance = _balances[sender];
1014         require(senderBalance >= amount, "Transfer exceeds balance");
1015         //Removes token and handles staking
1016         _removeToken(sender,amount);
1017         //Adds token and handles staking
1018         _addToken(recipient, amount);
1019 
1020         emit Transfer(sender,recipient,amount);
1021 
1022     }
1023     //Calculates the token that should be taxed
1024     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
1025         return (amount*tax*taxPercent) / 10000;
1026     }
1027     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1028     //BNB Autostake/////////////////////////////////////////////////////////////////////////////////////////
1029     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1030     //Autostake uses the balances of each holder to redistribute auto generated BNB.
1031     //Each transaction _addToken and _removeToken gets called for the transaction amount
1032     //WithdrawBNB can be used for any holder to withdraw BNB at any time, like true Staking,
1033     //so unlike MRAT clones you can leave and forget your Token and claim after a while
1034 
1035     //adds Token to balances, adds new BNB to the toBePaid mapping and resets staking
1036     function _addToken(address addr, uint256 amount) private {
1037         //the amount of token after transfer
1038         uint256 newAmount=_balances[addr]+amount;
1039         _balances[addr]=newAmount;
1040 
1041     }
1042 
1043 
1044     //removes Token, adds BNB to the toBePaid mapping and resets staking
1045     function _removeToken(address addr, uint256 amount) private {
1046         //the amount of token after transfer
1047         uint256 newAmount=_balances[addr]-amount;
1048          _balances[addr]=newAmount;
1049     }
1050 
1051     //lock for the withdraw
1052     bool private _isTokenSwaping;
1053     //the total reward distributed through staking, for tracking purposes
1054     uint256 public totalTokenSwapGenerated;
1055     //the total payout through staking, for tracking purposes
1056     uint256 public totalPayouts;
1057 
1058     //marketing share of the TokenSwap tax
1059     uint8 public marketingShare=100;
1060     //balance that is claimable by the team
1061     uint256 public marketingBalance;
1062 
1063     //Mapping of shares that are reserved for payout
1064     mapping(address => uint256) private toBePaid;
1065 
1066     //Contract, pancake and burnAddress are excluded, other addresses like CEX
1067     //can be manually excluded, excluded list is limited to 30 entries to avoid a
1068     //out of gas exeption during sells
1069     function isexcludedFromRaffle(address addr) public view returns (bool){
1070         return _excludedFromRaffle.contains(addr);
1071     }
1072 
1073     //distributes bnb between marketing share and dividents
1074     function _distributeFeesBNB(uint256 BNBamount) private {
1075         // Deduct marketing Tax
1076         uint256 marketingSplit = (BNBamount * marketingShare) / 100;
1077 
1078         marketingBalance+=marketingSplit;
1079 
1080     }
1081 
1082 
1083 
1084     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1085     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
1086     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1087 
1088     //tracks auto generated BNB, useful for ticker etc
1089     uint256 public totalLPBNB;
1090     //Locks the swap if already swapping
1091     bool private _isSwappingContractModifier;
1092     modifier lockTheSwap {
1093         _isSwappingContractModifier = true;
1094         _;
1095         _isSwappingContractModifier = false;
1096     }
1097 
1098     //swaps the token on the contract for Marketing BNB and LP Token.
1099     //always swaps the sellLimit of token to avoid a large price impact
1100     function _swapContractToken(uint256 totalMax) private lockTheSwap{
1101         uint256 contractBalance=_balances[address(this)];
1102         uint16 totalTax=_liquidityTax+_marketingTax;
1103         uint256 tokenToSwap=swapLimit;
1104         if(tokenToSwap > totalMax) {
1105             if(isSwapPegged) {
1106                 tokenToSwap = totalMax;
1107             }
1108         }
1109         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
1110         if(contractBalance<tokenToSwap||totalTax==0){
1111             return;
1112         }
1113         //splits the token in TokenForLiquidity and tokenForMarketing
1114         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
1115         uint256 tokenForMarketing= tokenToSwap-tokenForLiquidity;
1116 
1117         //splits tokenForLiquidity in 2 halves
1118         uint256 liqToken=tokenForLiquidity/2;
1119         uint256 liqBNBToken=tokenForLiquidity-liqToken;
1120 
1121         //swaps marktetingToken and the liquidity token half for BNB
1122         uint256 swapToken=liqBNBToken+tokenForMarketing;
1123         //Gets the initial BNB balance, so swap won't touch any staked BNB
1124         uint256 initialBNBBalance = address(this).balance;
1125         _swapTokenForBNB(swapToken);
1126         uint256 newBNB=(address(this).balance - initialBNBBalance);
1127         //calculates the amount of BNB belonging to the LP-Pair and converts them to LP
1128         uint256 liqBNB = (newBNB*liqBNBToken)/swapToken;
1129         _addLiquidity(liqToken, liqBNB);
1130         //Get the BNB balance after LP generation to get the
1131         //exact amount of token left for Staking
1132         uint256 generatedBNB=(address(this).balance - initialBNBBalance);
1133         //distributes remaining BNB between stakers and Marketing
1134         _distributeFeesBNB(generatedBNB);
1135     }
1136     //swaps tokens on the contract for BNB
1137     function _swapTokenForBNB(uint256 amount) private {
1138         _approve(address(this), address(_pancakeRouter), amount);
1139         address[] memory path = new address[](2);
1140         path[0] = address(this);
1141         path[1] = _pancakeRouter.WETH();
1142 
1143         _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1144             amount,
1145             0,
1146             path,
1147             address(this),
1148             block.timestamp
1149         );
1150     }
1151     //Adds Liquidity directly to the contract where LP are locked(unlike safemoon forks, that transfer it to the owner)
1152     function _addLiquidity(uint256 tokenamount, uint256 bnbamount) private {
1153         totalLPBNB+=bnbamount;
1154         _approve(address(this), address(_pancakeRouter), tokenamount);
1155         _pancakeRouter.addLiquidityETH{value: bnbamount}(
1156             address(this),
1157             tokenamount,
1158             0,
1159             0,
1160             address(this),
1161             block.timestamp
1162         );
1163     }
1164 
1165     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1166     //public functions /////////////////////////////////////////////////////////////////////////////////////
1167     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1168 
1169     function getBurnedTokens() public view returns(uint256){
1170         return (InitialSupply-_circulatingSupply)/10**_decimals;
1171     }
1172 
1173     function getLimits() public view returns(uint256 balance, uint256 sell){
1174         return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
1175     }
1176 
1177     function getTaxes() public view returns(uint256 burnTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
1178         return (_burnTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
1179     }
1180 
1181     function getWhitelistedStatus(address AddressToCheck) public view returns(bool){
1182         return _whiteList.contains(AddressToCheck);
1183     }
1184     //How long is a given address still locked from selling
1185     function getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
1186        uint256 lockTime=_sellLock[AddressToCheck];
1187        if(lockTime<=block.timestamp)
1188        {
1189            return 0;
1190        }
1191        return lockTime-block.timestamp;
1192     }
1193     function getSellLockTimeInSeconds() public view returns(uint256){
1194         return sellLockTime;
1195     }
1196 
1197     //Functions every wallet can call
1198     //Resets sell lock of caller to the default sellLockTime should something go very wrong
1199     function AddressResetSellLock() public{
1200         _sellLock[msg.sender]=block.timestamp+sellLockTime;
1201     }
1202 
1203     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1204     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
1205     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1206 
1207     bool public sellLockDisabled;
1208     uint256 public sellLockTime;
1209     bool public manualConversion;
1210 
1211 
1212     function getDumpers() public view returns(address[] memory) {
1213         return triedToDump;
1214     }
1215 
1216 
1217     function TeamSetWhitelistedAddressAlt(address addy, bool booly) public onlyTeam {
1218         wListed[addy] = booly;
1219     }
1220 
1221     function TeamSetWhitelistedAddress(address addy, bool booly) public onlyTeam {
1222         wListed[addy] = booly;
1223         _excluded.add(addy);
1224     }
1225 
1226 
1227     function TeamSetWhitelistedAddressesAlt( address[] memory addy, bool booly) public onlyTeam {
1228         uint256 i;
1229         for(i=0; i<addy.length; i++) {
1230             wListed[addy[i]] = booly;
1231         }
1232     }
1233 
1234     function TeamSetWhitelistedAddresses( address[] memory addy, bool booly) public onlyTeam {
1235         uint256 i;
1236         for(i=0; i<addy.length; i++) {
1237             wListed[addy[i]] = booly;
1238             _excluded.add(addy[i]);
1239         }
1240     }
1241 
1242     function TeamSetPeggedSwap(bool isPegged) public onlyTeam {
1243         isSwapPegged = isPegged;
1244     }
1245 
1246 
1247     //Excludes account from Staking
1248     function TeamExcludeFromRaffle(address addr) public onlyTeam{
1249         require(!isexcludedFromRaffle(addr));
1250         _excludedFromRaffle.add(addr);
1251 
1252     }
1253 
1254     //Includes excluded Account to staking
1255     function TeamIncludeToRaffle(address addr) public onlyTeam{
1256         require(isexcludedFromRaffle(addr));
1257         _excludedFromRaffle.remove(addr);
1258     }
1259 
1260     function TeamWithdrawMarketingBNB() public onlyTeam{
1261         uint256 amount=marketingBalance;
1262         marketingBalance=0;
1263         (bool sent,) =TeamWallet.call{value: (amount)}("");
1264         require(sent,"withdraw failed");
1265     }
1266 
1267 
1268     //switches autoLiquidity and marketing BNB generation during transfers
1269     function TeamSwitchManualBNBConversion(bool manual) public onlyTeam{
1270         manualConversion=manual;
1271     }
1272     //Disables the timeLock after selling for everyone
1273     function TeamDisableSellLock(bool disabled) public onlyTeam{
1274         sellLockDisabled=disabled;
1275     }
1276     //Sets SellLockTime, needs to be lower than MaxSellLockTime
1277     function TeamSetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
1278             require(sellLockSeconds<=MaxSellLockTime,"Sell Lock time too high");
1279             sellLockTime=sellLockSeconds;
1280     }
1281 
1282     //Sets Taxes, is limited by MaxTax(20%) to make it impossible to create honeypot
1283     function TeamSetTaxes(uint8 burnTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
1284         uint8 totalTax=burnTaxes+liquidityTaxes+marketingTaxes;
1285         require(totalTax==100, "burn+liq+marketing needs to equal 100%");
1286         require(buyTax<=MaxTax&&sellTax<=MaxTax&&transferTax<=MaxTax,"taxes higher than max tax");
1287 
1288         _burnTax=burnTaxes;
1289         _liquidityTax=liquidityTaxes;
1290         _marketingTax=marketingTaxes;
1291 
1292         _buyTax=buyTax;
1293         _sellTax=sellTax;
1294         _transferTax=transferTax;
1295     }
1296     //How much of the staking tax should be allocated for marketing
1297     function TeamChangeMarketingShare(uint8 newShare) public onlyTeam{
1298         marketingShare=newShare;
1299     }
1300     //manually converts contract token to LP and staking BNB
1301     function TeamManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
1302     _swapContractToken(_qty * 10**9);
1303     }
1304     //Exclude/Include account from fees (eg. CEX)
1305     function TeamExcludeAccountFromFees(address account) public onlyTeam {
1306         _excluded.add(account);
1307     }
1308     function TeamIncludeAccountToFees(address account) public onlyTeam {
1309         _excluded.remove(account);
1310     }
1311     //Exclude/Include account from fees (eg. CEX)
1312     function TeamExcludeAccountFromSellLock(address account) public onlyTeam {
1313         _excludedFromSellLock.add(account);
1314     }
1315     function TeamIncludeAccountToSellLock(address account) public onlyTeam {
1316         _excludedFromSellLock.remove(account);
1317     }
1318 
1319      //Limits need to be at least target, to avoid setting value to 0(avoid potential Honeypot)
1320     function TeamUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
1321         //Adds decimals to limits
1322         newBalanceLimit=newBalanceLimit*10**_decimals;
1323         newSellLimit=newSellLimit*10**_decimals;
1324         balanceLimit = newBalanceLimit;
1325         sellLimit = newSellLimit;
1326     }
1327 
1328     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1329     //Setup Functions///////////////////////////////////////////////////////////////////////////////////////
1330     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1331 
1332     bool public tradingEnabled;
1333     bool public whiteListTrading;
1334     address private _liquidityTokenAddress;
1335     //Enables whitelist trading and locks Liquidity for a short time
1336     function SetupEnableWhitelistTrading() public onlyTeam{
1337         require(!tradingEnabled);
1338         //Sets up the excluded from staking list
1339         tradingEnabled=true;
1340         whiteListTrading=true;
1341     }
1342     //Enables trading for everyone
1343     function SetupEnableTrading() public onlyTeam{
1344         require(tradingEnabled&&whiteListTrading);
1345         whiteListTrading=false;
1346     }
1347 
1348     //Sets up the LP-Token Address required for LP Release
1349     function SetupLiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
1350         _liquidityTokenAddress=liquidityTokenAddress;
1351     }
1352     //Functions for whitelist
1353     function SetupAddToWhitelist(address addressToAdd) public onlyTeam{
1354         _whiteList.add(addressToAdd);
1355     }
1356     function SetupAddArrayToWhitelist(address[] memory addressesToAdd) public onlyTeam{
1357         for(uint i=0; i<addressesToAdd.length; i++){
1358             _whiteList.add(addressesToAdd[i]);
1359         }
1360     }
1361     function SetupRemoveFromWhitelist(address addressToRemove) public onlyTeam{
1362         _whiteList.remove(addressToRemove);
1363     }
1364 
1365 
1366     function TeamRescueTokens(address tknAddress) public onlyTeam {
1367         IBEP20 token = IBEP20(tknAddress);
1368         uint256 ourBalance = token.balanceOf(address(this));
1369         require(ourBalance>0, "No tokens in our balance");
1370         token.transfer(msg.sender, ourBalance);
1371     }
1372 
1373     // Blacklists
1374 
1375     function setBlacklistEnabled(bool isBlacklistEnabled) public onlyTeam {
1376         isBlacklist = isBlacklistEnabled;
1377     }
1378 
1379     function setContractTokenSwapManual(bool manual) public onlyTeam {
1380         isTokenSwapManual = manual;
1381     }
1382 
1383     function setBlacklistedAddress(address toBlacklist) public onlyTeam {
1384         _blacklist[toBlacklist] = true;
1385     }
1386 
1387     function removeBlacklistedAddress(address toRemove) public onlyTeam {
1388         _blacklist[toRemove] = false;
1389     }
1390 
1391     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1392     //Utilities/////////////////////////////////////////////////////////////////////////////////////////////
1393     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1394 
1395     function TeamAvoidBurning() public onlyTeam{
1396         (bool sent,) =msg.sender.call{value: (address(this).balance)}("");
1397         require(sent);
1398     }
1399     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1400     //external//////////////////////////////////////////////////////////////////////////////////////////////
1401     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1402 
1403     receive() external payable {}
1404     fallback() external payable {}
1405     // IBEP20
1406 
1407     function getOwner() external view override returns (address) {
1408         return owner();
1409     }
1410 
1411     function name() external pure override returns (string memory) {
1412         return _name;
1413     }
1414 
1415     function symbol() external pure override returns (string memory) {
1416         return _symbol;
1417     }
1418 
1419     function decimals() external pure override returns (uint8) {
1420         return _decimals;
1421     }
1422 
1423     function totalSupply() external view override returns (uint256) {
1424         return _circulatingSupply;
1425     }
1426 
1427     function balanceOf(address account) external view override returns (uint256) {
1428         return _balances[account];
1429     }
1430 
1431     function transfer(address recipient, uint256 amount) external override returns (bool) {
1432         _transfer(msg.sender, recipient, amount);
1433         return true;
1434     }
1435 
1436     function allowance(address _owner, address spender) external view override returns (uint256) {
1437         return _allowances[_owner][spender];
1438     }
1439 
1440     function approve(address spender, uint256 amount) external override returns (bool) {
1441         _approve(msg.sender, spender, amount);
1442         return true;
1443     }
1444     function _approve(address owner, address spender, uint256 amount) private {
1445         require(owner != address(0), "Approve from zero");
1446         require(spender != address(0), "Approve to zero");
1447 
1448         _allowances[owner][spender] = amount;
1449         emit Approval(owner, spender, amount);
1450     }
1451 
1452     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1453         _transfer(sender, recipient, amount);
1454 
1455         uint256 currentAllowance = _allowances[sender][msg.sender];
1456         require(currentAllowance >= amount, "Transfer > allowance");
1457 
1458         _approve(sender, msg.sender, currentAllowance - amount);
1459         return true;
1460     }
1461 
1462     // IBEP20 - Helpers
1463 
1464     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1465         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1466         return true;
1467     }
1468 
1469     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1470         uint256 currentAllowance = _allowances[msg.sender][spender];
1471         require(currentAllowance >= subtractedValue, "<0 allowance");
1472 
1473         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1474         return true;
1475     }
1476 
1477 }