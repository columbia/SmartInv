1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 pragma experimental ABIEncoderV2;
5 
6 interface IUniswapV2Router01 {
7     function factory() external pure returns (address);
8     function WETH() external pure returns (address);
9 
10     function addLiquidity(
11         address tokenA,
12         address tokenB,
13         uint amountADesired,
14         uint amountBDesired,
15         uint amountAMin,
16         uint amountBMin,
17         address to,
18         uint deadline
19     ) external returns (uint amountA, uint amountB, uint liquidity);
20     function addLiquidityETH(
21         address token,
22         uint amountTokenDesired,
23         uint amountTokenMin,
24         uint amountETHMin,
25         address to,
26         uint deadline
27     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
28     function removeLiquidity(
29         address tokenA,
30         address tokenB,
31         uint liquidity,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB);
37     function removeLiquidityETH(
38         address token,
39         uint liquidity,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external returns (uint amountToken, uint amountETH);
45     function removeLiquidityWithPermit(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline,
53         bool approveMax, uint8 v, bytes32 r, bytes32 s
54     ) external returns (uint amountA, uint amountB);
55     function removeLiquidityETHWithPermit(
56         address token,
57         uint liquidity,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline,
62         bool approveMax, uint8 v, bytes32 r, bytes32 s
63     ) external returns (uint amountToken, uint amountETH);
64     function swapExactTokensForTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external returns (uint[] memory amounts);
71     function swapTokensForExactTokens(
72         uint amountOut,
73         uint amountInMax,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
79         external
80         payable
81         returns (uint[] memory amounts);
82     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
89         external
90         payable
91         returns (uint[] memory amounts);
92 
93     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
94     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
95     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
96     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
97     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
98 }
99 
100 interface IUniswapV2Router02 is IUniswapV2Router01 {
101     function removeLiquidityETHSupportingFeeOnTransferTokens(
102         address token,
103         uint liquidity,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountETH);
109     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline,
116         bool approveMax, uint8 v, bytes32 r, bytes32 s
117     ) external returns (uint amountETH);
118 
119     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function swapExactETHForTokensSupportingFeeOnTransferTokens(
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external payable;
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 }
140 
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 /**
162  * @dev Collection of functions related to the address type
163  */
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         assembly {
189             size := extcodesize(account)
190         }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         (bool success, ) = recipient.call{value: amount}("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain `call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal returns (bytes memory) {
250         return functionCallWithValue(target, data, 0, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but also transferring `value` wei to `target`.
256      *
257      * Requirements:
258      *
259      * - the calling contract must have an ETH balance of at least `value`.
260      * - the called Solidity function must be `payable`.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(
265         address target,
266         bytes memory data,
267         uint256 value
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
274      * with `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         require(address(this).balance >= value, "Address: insufficient balance for call");
285         require(isContract(target), "Address: call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.call{value: value}(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
298         return functionStaticCall(target, data, "Address: low-level static call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
303      * but performing a static call.
304      *
305      * _Available since v3.3._
306      */
307     function functionStaticCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal view returns (bytes memory) {
312         require(isContract(target), "Address: static call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.staticcall(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a delegate call.
331      *
332      * _Available since v3.4._
333      */
334     function functionDelegateCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(isContract(target), "Address: delegate call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.delegatecall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
347      * revert reason using the provided one.
348      *
349      * _Available since v4.3._
350      */
351     function verifyCallResult(
352         bool success,
353         bytes memory returndata,
354         string memory errorMessage
355     ) internal pure returns (bytes memory) {
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 /**
375  * @dev Library for managing
376  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
377  * types.
378  *
379  * Sets have the following properties:
380  *
381  * - Elements are added, removed, and checked for existence in constant time
382  * (O(1)).
383  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
384  *
385  * ```
386  * contract Example {
387  *     // Add the library methods
388  *     using EnumerableSet for EnumerableSet.AddressSet;
389  *
390  *     // Declare a set state variable
391  *     EnumerableSet.AddressSet private mySet;
392  * }
393  * ```
394  *
395  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
396  * and `uint256` (`UintSet`) are supported.
397  */
398 library EnumerableSet {
399     // To implement this library for multiple types with as little code
400     // repetition as possible, we write it in terms of a generic Set type with
401     // bytes32 values.
402     // The Set implementation uses private functions, and user-facing
403     // implementations (such as AddressSet) are just wrappers around the
404     // underlying Set.
405     // This means that we can only create new EnumerableSets for types that fit
406     // in bytes32.
407 
408     struct Set {
409         // Storage of set values
410         bytes32[] _values;
411         // Position of the value in the `values` array, plus 1 because index 0
412         // means a value is not in the set.
413         mapping(bytes32 => uint256) _indexes;
414     }
415 
416     /**
417      * @dev Add a value to a set. O(1).
418      *
419      * Returns true if the value was added to the set, that is if it was not
420      * already present.
421      */
422     function _add(Set storage set, bytes32 value) private returns (bool) {
423         if (!_contains(set, value)) {
424             set._values.push(value);
425             // The value is stored at length-1, but we add 1 to all indexes
426             // and use 0 as a sentinel value
427             set._indexes[value] = set._values.length;
428             return true;
429         } else {
430             return false;
431         }
432     }
433 
434     /**
435      * @dev Removes a value from a set. O(1).
436      *
437      * Returns true if the value was removed from the set, that is if it was
438      * present.
439      */
440     function _remove(Set storage set, bytes32 value) private returns (bool) {
441         // We read and store the value's index to prevent multiple reads from the same storage slot
442         uint256 valueIndex = set._indexes[value];
443 
444         if (valueIndex != 0) {
445             // Equivalent to contains(set, value)
446             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
447             // the array, and then remove the last element (sometimes called as 'swap and pop').
448             // This modifies the order of the array, as noted in {at}.
449 
450             uint256 toDeleteIndex = valueIndex - 1;
451             uint256 lastIndex = set._values.length - 1;
452 
453             if (lastIndex != toDeleteIndex) {
454                 bytes32 lastvalue = set._values[lastIndex];
455 
456                 // Move the last value to the index where the value to delete is
457                 set._values[toDeleteIndex] = lastvalue;
458                 // Update the index for the moved value
459                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
460             }
461 
462             // Delete the slot where the moved value was stored
463             set._values.pop();
464 
465             // Delete the index for the deleted slot
466             delete set._indexes[value];
467 
468             return true;
469         } else {
470             return false;
471         }
472     }
473 
474     /**
475      * @dev Returns true if the value is in the set. O(1).
476      */
477     function _contains(Set storage set, bytes32 value) private view returns (bool) {
478         return set._indexes[value] != 0;
479     }
480 
481     /**
482      * @dev Returns the number of values on the set. O(1).
483      */
484     function _length(Set storage set) private view returns (uint256) {
485         return set._values.length;
486     }
487 
488     /**
489      * @dev Returns the value stored at position `index` in the set. O(1).
490      *
491      * Note that there are no guarantees on the ordering of values inside the
492      * array, and it may change when more values are added or removed.
493      *
494      * Requirements:
495      *
496      * - `index` must be strictly less than {length}.
497      */
498     function _at(Set storage set, uint256 index) private view returns (bytes32) {
499         return set._values[index];
500     }
501 
502     /**
503      * @dev Return the entire set in an array
504      *
505      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
506      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
507      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
508      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
509      */
510     function _values(Set storage set) private view returns (bytes32[] memory) {
511         return set._values;
512     }
513 
514     // Bytes32Set
515 
516     struct Bytes32Set {
517         Set _inner;
518     }
519 
520     /**
521      * @dev Add a value to a set. O(1).
522      *
523      * Returns true if the value was added to the set, that is if it was not
524      * already present.
525      */
526     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
527         return _add(set._inner, value);
528     }
529 
530     /**
531      * @dev Removes a value from a set. O(1).
532      *
533      * Returns true if the value was removed from the set, that is if it was
534      * present.
535      */
536     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
537         return _remove(set._inner, value);
538     }
539 
540     /**
541      * @dev Returns true if the value is in the set. O(1).
542      */
543     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
544         return _contains(set._inner, value);
545     }
546 
547     /**
548      * @dev Returns the number of values in the set. O(1).
549      */
550     function length(Bytes32Set storage set) internal view returns (uint256) {
551         return _length(set._inner);
552     }
553 
554     /**
555      * @dev Returns the value stored at position `index` in the set. O(1).
556      *
557      * Note that there are no guarantees on the ordering of values inside the
558      * array, and it may change when more values are added or removed.
559      *
560      * Requirements:
561      *
562      * - `index` must be strictly less than {length}.
563      */
564     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
565         return _at(set._inner, index);
566     }
567 
568     /**
569      * @dev Return the entire set in an array
570      *
571      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
572      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
573      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
574      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
575      */
576     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
577         return _values(set._inner);
578     }
579 
580     // AddressSet
581 
582     struct AddressSet {
583         Set _inner;
584     }
585 
586     /**
587      * @dev Add a value to a set. O(1).
588      *
589      * Returns true if the value was added to the set, that is if it was not
590      * already present.
591      */
592     function add(AddressSet storage set, address value) internal returns (bool) {
593         return _add(set._inner, bytes32(uint256(uint160(value))));
594     }
595 
596     /**
597      * @dev Removes a value from a set. O(1).
598      *
599      * Returns true if the value was removed from the set, that is if it was
600      * present.
601      */
602     function remove(AddressSet storage set, address value) internal returns (bool) {
603         return _remove(set._inner, bytes32(uint256(uint160(value))));
604     }
605 
606     /**
607      * @dev Returns true if the value is in the set. O(1).
608      */
609     function contains(AddressSet storage set, address value) internal view returns (bool) {
610         return _contains(set._inner, bytes32(uint256(uint160(value))));
611     }
612 
613     /**
614      * @dev Returns the number of values in the set. O(1).
615      */
616     function length(AddressSet storage set) internal view returns (uint256) {
617         return _length(set._inner);
618     }
619 
620     /**
621      * @dev Returns the value stored at position `index` in the set. O(1).
622      *
623      * Note that there are no guarantees on the ordering of values inside the
624      * array, and it may change when more values are added or removed.
625      *
626      * Requirements:
627      *
628      * - `index` must be strictly less than {length}.
629      */
630     function at(AddressSet storage set, uint256 index) internal view returns (address) {
631         return address(uint160(uint256(_at(set._inner, index))));
632     }
633 
634     /**
635      * @dev Return the entire set in an array
636      *
637      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
638      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
639      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
640      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
641      */
642     function values(AddressSet storage set) internal view returns (address[] memory) {
643         bytes32[] memory store = _values(set._inner);
644         address[] memory result;
645 
646         assembly {
647             result := store
648         }
649 
650         return result;
651     }
652 
653     // UintSet
654 
655     struct UintSet {
656         Set _inner;
657     }
658 
659     /**
660      * @dev Add a value to a set. O(1).
661      *
662      * Returns true if the value was added to the set, that is if it was not
663      * already present.
664      */
665     function add(UintSet storage set, uint256 value) internal returns (bool) {
666         return _add(set._inner, bytes32(value));
667     }
668 
669     /**
670      * @dev Removes a value from a set. O(1).
671      *
672      * Returns true if the value was removed from the set, that is if it was
673      * present.
674      */
675     function remove(UintSet storage set, uint256 value) internal returns (bool) {
676         return _remove(set._inner, bytes32(value));
677     }
678 
679     /**
680      * @dev Returns true if the value is in the set. O(1).
681      */
682     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
683         return _contains(set._inner, bytes32(value));
684     }
685 
686     /**
687      * @dev Returns the number of values on the set. O(1).
688      */
689     function length(UintSet storage set) internal view returns (uint256) {
690         return _length(set._inner);
691     }
692 
693     /**
694      * @dev Returns the value stored at position `index` in the set. O(1).
695      *
696      * Note that there are no guarantees on the ordering of values inside the
697      * array, and it may change when more values are added or removed.
698      *
699      * Requirements:
700      *
701      * - `index` must be strictly less than {length}.
702      */
703     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
704         return uint256(_at(set._inner, index));
705     }
706 
707     /**
708      * @dev Return the entire set in an array
709      *
710      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
711      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
712      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
713      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
714      */
715     function values(UintSet storage set) internal view returns (uint256[] memory) {
716         bytes32[] memory store = _values(set._inner);
717         uint256[] memory result;
718 
719         assembly {
720             result := store
721         }
722 
723         return result;
724     }
725 }
726 
727 /**
728  * @dev Interface of the ERC20 standard as defined in the EIP.
729  */
730 interface IERC20 {
731     /**
732      * @dev Returns the amount of tokens in existence.
733      */
734     function totalSupply() external view returns (uint256);
735 
736     /**
737      * @dev Returns the amount of tokens owned by `account`.
738      */
739     function balanceOf(address account) external view returns (uint256);
740 
741     /**
742      * @dev Moves `amount` tokens from the caller's account to `recipient`.
743      *
744      * Returns a boolean value indicating whether the operation succeeded.
745      *
746      * Emits a {Transfer} event.
747      */
748     function transfer(address recipient, uint256 amount) external returns (bool);
749 
750     /**
751      * @dev Returns the remaining number of tokens that `spender` will be
752      * allowed to spend on behalf of `owner` through {transferFrom}. This is
753      * zero by default.
754      *
755      * This value changes when {approve} or {transferFrom} are called.
756      */
757     function allowance(address owner, address spender) external view returns (uint256);
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
761      *
762      * Returns a boolean value indicating whether the operation succeeded.
763      *
764      * IMPORTANT: Beware that changing an allowance with this method brings the risk
765      * that someone may use both the old and the new allowance by unfortunate
766      * transaction ordering. One possible solution to mitigate this race
767      * condition is to first reduce the spender's allowance to 0 and set the
768      * desired value afterwards:
769      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address spender, uint256 amount) external returns (bool);
774 
775     /**
776      * @dev Moves `amount` tokens from `sender` to `recipient` using the
777      * allowance mechanism. `amount` is then deducted from the caller's
778      * allowance.
779      *
780      * Returns a boolean value indicating whether the operation succeeded.
781      *
782      * Emits a {Transfer} event.
783      */
784     function transferFrom(
785         address sender,
786         address recipient,
787         uint256 amount
788     ) external returns (bool);
789 
790     /**
791      * @dev Emitted when `value` tokens are moved from one account (`from`) to
792      * another (`to`).
793      *
794      * Note that `value` may be zero.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 value);
797 
798     /**
799      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
800      * a call to {approve}. `value` is the new allowance.
801      */
802     event Approval(address indexed owner, address indexed spender, uint256 value);
803 }
804 
805 /**
806  * @dev Contract module which provides a basic access control mechanism, where
807  * there is an account (an owner) that can be granted exclusive access to
808  * specific functions.
809  *
810  * By default, the owner account will be the one that deploys the contract. This
811  * can later be changed with {transferOwnership}.
812  *
813  * This module is used through inheritance. It will make available the modifier
814  * `onlyOwner`, which can be applied to your functions to restrict their use to
815  * the owner.
816  */
817 abstract contract Ownable is Context {
818     address private _owner;
819 
820     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
821 
822     /**
823      * @dev Initializes the contract setting the deployer as the initial owner.
824      */
825     constructor() {
826         _setOwner(_msgSender());
827     }
828 
829     /**
830      * @dev Returns the address of the current owner.
831      */
832     function owner() public view virtual returns (address) {
833         return _owner;
834     }
835 
836     /**
837      * @dev Throws if called by any account other than the owner.
838      */
839     modifier onlyOwner() {
840         require(owner() == _msgSender(), "Ownable: caller is not the owner");
841         _;
842     }
843 
844     /**
845      * @dev Leaves the contract without owner. It will not be possible to call
846      * `onlyOwner` functions anymore. Can only be called by the current owner.
847      *
848      * NOTE: Renouncing ownership will leave the contract without an owner,
849      * thereby removing any functionality that is only available to the owner.
850      */
851     function renounceOwnership() public virtual onlyOwner {
852         _setOwner(address(0));
853     }
854 
855     /**
856      * @dev Transfers ownership of the contract to a new account (`newOwner`).
857      * Can only be called by the current owner.
858      */
859     function transferOwnership(address newOwner) public virtual onlyOwner {
860         require(newOwner != address(0), "Ownable: new owner is the zero address");
861         _setOwner(newOwner);
862     }
863 
864     function _setOwner(address newOwner) private {
865         address oldOwner = _owner;
866         _owner = newOwner;
867         emit OwnershipTransferred(oldOwner, newOwner);
868     }
869 }
870 
871 // CAUTION
872 // This version of SafeMath should only be used with Solidity 0.8 or later,
873 // because it relies on the compiler's built in overflow checks.
874 
875 /**
876  * @dev Wrappers over Solidity's arithmetic operations.
877  *
878  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
879  * now has built in overflow checking.
880  */
881 library SafeMath {
882     /**
883      * @dev Returns the addition of two unsigned integers, with an overflow flag.
884      *
885      * _Available since v3.4._
886      */
887     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
888         unchecked {
889             uint256 c = a + b;
890             if (c < a) return (false, 0);
891             return (true, c);
892         }
893     }
894 
895     /**
896      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
897      *
898      * _Available since v3.4._
899      */
900     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
901         unchecked {
902             if (b > a) return (false, 0);
903             return (true, a - b);
904         }
905     }
906 
907     /**
908      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
909      *
910      * _Available since v3.4._
911      */
912     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
913         unchecked {
914             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
915             // benefit is lost if 'b' is also tested.
916             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
917             if (a == 0) return (true, 0);
918             uint256 c = a * b;
919             if (c / a != b) return (false, 0);
920             return (true, c);
921         }
922     }
923 
924     /**
925      * @dev Returns the division of two unsigned integers, with a division by zero flag.
926      *
927      * _Available since v3.4._
928      */
929     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
930         unchecked {
931             if (b == 0) return (false, 0);
932             return (true, a / b);
933         }
934     }
935 
936     /**
937      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
938      *
939      * _Available since v3.4._
940      */
941     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
942         unchecked {
943             if (b == 0) return (false, 0);
944             return (true, a % b);
945         }
946     }
947 
948     /**
949      * @dev Returns the addition of two unsigned integers, reverting on
950      * overflow.
951      *
952      * Counterpart to Solidity's `+` operator.
953      *
954      * Requirements:
955      *
956      * - Addition cannot overflow.
957      */
958     function add(uint256 a, uint256 b) internal pure returns (uint256) {
959         return a + b;
960     }
961 
962     /**
963      * @dev Returns the subtraction of two unsigned integers, reverting on
964      * overflow (when the result is negative).
965      *
966      * Counterpart to Solidity's `-` operator.
967      *
968      * Requirements:
969      *
970      * - Subtraction cannot overflow.
971      */
972     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
973         return a - b;
974     }
975 
976     /**
977      * @dev Returns the multiplication of two unsigned integers, reverting on
978      * overflow.
979      *
980      * Counterpart to Solidity's `*` operator.
981      *
982      * Requirements:
983      *
984      * - Multiplication cannot overflow.
985      */
986     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
987         return a * b;
988     }
989 
990     /**
991      * @dev Returns the integer division of two unsigned integers, reverting on
992      * division by zero. The result is rounded towards zero.
993      *
994      * Counterpart to Solidity's `/` operator.
995      *
996      * Requirements:
997      *
998      * - The divisor cannot be zero.
999      */
1000     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1001         return a / b;
1002     }
1003 
1004     /**
1005      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1006      * reverting when dividing by zero.
1007      *
1008      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1009      * opcode (which leaves remaining gas untouched) while Solidity uses an
1010      * invalid opcode to revert (consuming all remaining gas).
1011      *
1012      * Requirements:
1013      *
1014      * - The divisor cannot be zero.
1015      */
1016     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1017         return a % b;
1018     }
1019 
1020     /**
1021      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1022      * overflow (when the result is negative).
1023      *
1024      * CAUTION: This function is deprecated because it requires allocating memory for the error
1025      * message unnecessarily. For custom revert reasons use {trySub}.
1026      *
1027      * Counterpart to Solidity's `-` operator.
1028      *
1029      * Requirements:
1030      *
1031      * - Subtraction cannot overflow.
1032      */
1033     function sub(
1034         uint256 a,
1035         uint256 b,
1036         string memory errorMessage
1037     ) internal pure returns (uint256) {
1038         unchecked {
1039             require(b <= a, errorMessage);
1040             return a - b;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1046      * division by zero. The result is rounded towards zero.
1047      *
1048      * Counterpart to Solidity's `/` operator. Note: this function uses a
1049      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1050      * uses an invalid opcode to revert (consuming all remaining gas).
1051      *
1052      * Requirements:
1053      *
1054      * - The divisor cannot be zero.
1055      */
1056     function div(
1057         uint256 a,
1058         uint256 b,
1059         string memory errorMessage
1060     ) internal pure returns (uint256) {
1061         unchecked {
1062             require(b > 0, errorMessage);
1063             return a / b;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1069      * reverting with custom message when dividing by zero.
1070      *
1071      * CAUTION: This function is deprecated because it requires allocating memory for the error
1072      * message unnecessarily. For custom revert reasons use {tryMod}.
1073      *
1074      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1075      * opcode (which leaves remaining gas untouched) while Solidity uses an
1076      * invalid opcode to revert (consuming all remaining gas).
1077      *
1078      * Requirements:
1079      *
1080      * - The divisor cannot be zero.
1081      */
1082     function mod(
1083         uint256 a,
1084         uint256 b,
1085         string memory errorMessage
1086     ) internal pure returns (uint256) {
1087         unchecked {
1088             require(b > 0, errorMessage);
1089             return a % b;
1090         }
1091     }
1092 }
1093 
1094 
1095 /**
1096  * @title SafeERC20
1097  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1098  * contract returns false). Tokens that return no value (and instead revert or
1099  * throw on failure) are also supported, non-reverting calls are assumed to be
1100  * successful.
1101  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1102  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1103  */
1104 library SafeERC20 {
1105     using Address for address;
1106 
1107     function safeTransfer(
1108         IERC20 token,
1109         address to,
1110         uint256 value
1111     ) internal {
1112         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1113     }
1114 
1115     function safeTransferFrom(
1116         IERC20 token,
1117         address from,
1118         address to,
1119         uint256 value
1120     ) internal {
1121         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1122     }
1123 
1124     /**
1125      * @dev Deprecated. This function has issues similar to the ones found in
1126      * {IERC20-approve}, and its usage is discouraged.
1127      *
1128      * Whenever possible, use {safeIncreaseAllowance} and
1129      * {safeDecreaseAllowance} instead.
1130      */
1131     function safeApprove(
1132         IERC20 token,
1133         address spender,
1134         uint256 value
1135     ) internal {
1136         // safeApprove should only be called when setting an initial allowance,
1137         // or when resetting it to zero. To increase and decrease it, use
1138         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1139         require(
1140             (value == 0) || (token.allowance(address(this), spender) == 0),
1141             "SafeERC20: approve from non-zero to non-zero allowance"
1142         );
1143         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1144     }
1145 
1146     function safeIncreaseAllowance(
1147         IERC20 token,
1148         address spender,
1149         uint256 value
1150     ) internal {
1151         uint256 newAllowance = token.allowance(address(this), spender) + value;
1152         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1153     }
1154 
1155     function safeDecreaseAllowance(
1156         IERC20 token,
1157         address spender,
1158         uint256 value
1159     ) internal {
1160         unchecked {
1161             uint256 oldAllowance = token.allowance(address(this), spender);
1162             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1163             uint256 newAllowance = oldAllowance - value;
1164             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1165         }
1166     }
1167 
1168     /**
1169      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1170      * on the return value: the return value is optional (but if data is returned, it must not be false).
1171      * @param token The token targeted by the call.
1172      * @param data The call data (encoded using abi.encode or one of its variants).
1173      */
1174     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1175         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1176         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1177         // the target address contains contract code and also asserts for success in the low-level call.
1178 
1179         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1180         if (returndata.length > 0) {
1181             // Return data is optional
1182             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1183         }
1184     }
1185 }
1186 
1187 /**
1188  * @dev Interface for the optional metadata functions from the ERC20 standard.
1189  *
1190  * _Available since v4.1._
1191  */
1192 interface IERC20Metadata is IERC20 {
1193     /**
1194      * @dev Returns the name of the token.
1195      */
1196     function name() external view returns (string memory);
1197 
1198     /**
1199      * @dev Returns the symbol of the token.
1200      */
1201     function symbol() external view returns (string memory);
1202 
1203     /**
1204      * @dev Returns the decimals places of the token.
1205      */
1206     function decimals() external view returns (uint8);
1207 }
1208 
1209 /**
1210  * @dev Implementation of the {IERC20} interface.
1211  *
1212  * This implementation is agnostic to the way tokens are created. This means
1213  * that a supply mechanism has to be added in a derived contract using {_mint}.
1214  * For a generic mechanism see {ERC20PresetMinterPauser}.
1215  *
1216  * TIP: For a detailed writeup see our guide
1217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1218  * to implement supply mechanisms].
1219  *
1220  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1221  * instead returning `false` on failure. This behavior is nonetheless
1222  * conventional and does not conflict with the expectations of ERC20
1223  * applications.
1224  *
1225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1226  * This allows applications to reconstruct the allowance for all accounts just
1227  * by listening to said events. Other implementations of the EIP may not emit
1228  * these events, as it isn't required by the specification.
1229  *
1230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1231  * functions have been added to mitigate the well-known issues around setting
1232  * allowances. See {IERC20-approve}.
1233  */
1234 contract ERC20 is Context, IERC20, IERC20Metadata {
1235     mapping(address => uint256) private _balances;
1236 
1237     mapping(address => mapping(address => uint256)) private _allowances;
1238 
1239     uint256 private _totalSupply;
1240 
1241     string private _name;
1242     string private _symbol;
1243 
1244     /**
1245      * @dev Sets the values for {name} and {symbol}.
1246      *
1247      * The default value of {decimals} is 18. To select a different value for
1248      * {decimals} you should overload it.
1249      *
1250      * All two of these values are immutable: they can only be set once during
1251      * construction.
1252      */
1253     constructor(string memory name_, string memory symbol_) {
1254         _name = name_;
1255         _symbol = symbol_;
1256     }
1257 
1258     /**
1259      * @dev Returns the name of the token.
1260      */
1261     function name() public view virtual override returns (string memory) {
1262         return _name;
1263     }
1264 
1265     /**
1266      * @dev Returns the symbol of the token, usually a shorter version of the
1267      * name.
1268      */
1269     function symbol() public view virtual override returns (string memory) {
1270         return _symbol;
1271     }
1272 
1273     /**
1274      * @dev Returns the number of decimals used to get its user representation.
1275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1276      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1277      *
1278      * Tokens usually opt for a value of 18, imitating the relationship between
1279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1280      * overridden;
1281      *
1282      * NOTE: This information is only used for _display_ purposes: it in
1283      * no way affects any of the arithmetic of the contract, including
1284      * {IERC20-balanceOf} and {IERC20-transfer}.
1285      */
1286     function decimals() public view virtual override returns (uint8) {
1287         return 18;
1288     }
1289 
1290     /**
1291      * @dev See {IERC20-totalSupply}.
1292      */
1293     function totalSupply() public view virtual override returns (uint256) {
1294         return _totalSupply;
1295     }
1296 
1297     /**
1298      * @dev See {IERC20-balanceOf}.
1299      */
1300     function balanceOf(address account) public view virtual override returns (uint256) {
1301         return _balances[account];
1302     }
1303 
1304     /**
1305      * @dev See {IERC20-transfer}.
1306      *
1307      * Requirements:
1308      *
1309      * - `recipient` cannot be the zero address.
1310      * - the caller must have a balance of at least `amount`.
1311      */
1312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1313         _transfer(_msgSender(), recipient, amount);
1314         return true;
1315     }
1316 
1317     /**
1318      * @dev See {IERC20-allowance}.
1319      */
1320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1321         return _allowances[owner][spender];
1322     }
1323 
1324     /**
1325      * @dev See {IERC20-approve}.
1326      *
1327      * Requirements:
1328      *
1329      * - `spender` cannot be the zero address.
1330      */
1331     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1332         _approve(_msgSender(), spender, amount);
1333         return true;
1334     }
1335 
1336     /**
1337      * @dev See {IERC20-transferFrom}.
1338      *
1339      * Emits an {Approval} event indicating the updated allowance. This is not
1340      * required by the EIP. See the note at the beginning of {ERC20}.
1341      *
1342      * Requirements:
1343      *
1344      * - `sender` and `recipient` cannot be the zero address.
1345      * - `sender` must have a balance of at least `amount`.
1346      * - the caller must have allowance for ``sender``'s tokens of at least
1347      * `amount`.
1348      */
1349     function transferFrom(
1350         address sender,
1351         address recipient,
1352         uint256 amount
1353     ) public virtual override returns (bool) {
1354         _transfer(sender, recipient, amount);
1355 
1356         uint256 currentAllowance = _allowances[sender][_msgSender()];
1357         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1358         unchecked {
1359             _approve(sender, _msgSender(), currentAllowance - amount);
1360         }
1361 
1362         return true;
1363     }
1364 
1365     /**
1366      * @dev Atomically increases the allowance granted to `spender` by the caller.
1367      *
1368      * This is an alternative to {approve} that can be used as a mitigation for
1369      * problems described in {IERC20-approve}.
1370      *
1371      * Emits an {Approval} event indicating the updated allowance.
1372      *
1373      * Requirements:
1374      *
1375      * - `spender` cannot be the zero address.
1376      */
1377     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1379         return true;
1380     }
1381 
1382     /**
1383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1384      *
1385      * This is an alternative to {approve} that can be used as a mitigation for
1386      * problems described in {IERC20-approve}.
1387      *
1388      * Emits an {Approval} event indicating the updated allowance.
1389      *
1390      * Requirements:
1391      *
1392      * - `spender` cannot be the zero address.
1393      * - `spender` must have allowance for the caller of at least
1394      * `subtractedValue`.
1395      */
1396     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1397         uint256 currentAllowance = _allowances[_msgSender()][spender];
1398         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1399         unchecked {
1400             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1401         }
1402 
1403         return true;
1404     }
1405 
1406     /**
1407      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1408      *
1409      * This internal function is equivalent to {transfer}, and can be used to
1410      * e.g. implement automatic token fees, slashing mechanisms, etc.
1411      *
1412      * Emits a {Transfer} event.
1413      *
1414      * Requirements:
1415      *
1416      * - `sender` cannot be the zero address.
1417      * - `recipient` cannot be the zero address.
1418      * - `sender` must have a balance of at least `amount`.
1419      */
1420     function _transfer(
1421         address sender,
1422         address recipient,
1423         uint256 amount
1424     ) internal virtual {
1425         require(sender != address(0), "ERC20: transfer from the zero address");
1426         require(recipient != address(0), "ERC20: transfer to the zero address");
1427 
1428         _beforeTokenTransfer(sender, recipient, amount);
1429 
1430         uint256 senderBalance = _balances[sender];
1431         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1432         unchecked {
1433             _balances[sender] = senderBalance - amount;
1434         }
1435         _balances[recipient] += amount;
1436 
1437         emit Transfer(sender, recipient, amount);
1438 
1439         _afterTokenTransfer(sender, recipient, amount);
1440     }
1441 
1442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1443      * the total supply.
1444      *
1445      * Emits a {Transfer} event with `from` set to the zero address.
1446      *
1447      * Requirements:
1448      *
1449      * - `account` cannot be the zero address.
1450      */
1451     function _mint(address account, uint256 amount) internal virtual {
1452         require(account != address(0), "ERC20: mint to the zero address");
1453 
1454         _beforeTokenTransfer(address(0), account, amount);
1455 
1456         _totalSupply += amount;
1457         _balances[account] += amount;
1458         emit Transfer(address(0), account, amount);
1459 
1460         _afterTokenTransfer(address(0), account, amount);
1461     }
1462 
1463     /**
1464      * @dev Destroys `amount` tokens from `account`, reducing the
1465      * total supply.
1466      *
1467      * Emits a {Transfer} event with `to` set to the zero address.
1468      *
1469      * Requirements:
1470      *
1471      * - `account` cannot be the zero address.
1472      * - `account` must have at least `amount` tokens.
1473      */
1474     function _burn(address account, uint256 amount) internal virtual {
1475         require(account != address(0), "ERC20: burn from the zero address");
1476 
1477         _beforeTokenTransfer(account, address(0), amount);
1478 
1479         uint256 accountBalance = _balances[account];
1480         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1481         unchecked {
1482             _balances[account] = accountBalance - amount;
1483         }
1484         _totalSupply -= amount;
1485 
1486         emit Transfer(account, address(0), amount);
1487 
1488         _afterTokenTransfer(account, address(0), amount);
1489     }
1490 
1491     /**
1492      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1493      *
1494      * This internal function is equivalent to `approve`, and can be used to
1495      * e.g. set automatic allowances for certain subsystems, etc.
1496      *
1497      * Emits an {Approval} event.
1498      *
1499      * Requirements:
1500      *
1501      * - `owner` cannot be the zero address.
1502      * - `spender` cannot be the zero address.
1503      */
1504     function _approve(
1505         address owner,
1506         address spender,
1507         uint256 amount
1508     ) internal virtual {
1509         require(owner != address(0), "ERC20: approve from the zero address");
1510         require(spender != address(0), "ERC20: approve to the zero address");
1511 
1512         _allowances[owner][spender] = amount;
1513         emit Approval(owner, spender, amount);
1514     }
1515 
1516     /**
1517      * @dev Hook that is called before any transfer of tokens. This includes
1518      * minting and burning.
1519      *
1520      * Calling conditions:
1521      *
1522      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1523      * will be transferred to `to`.
1524      * - when `from` is zero, `amount` tokens will be minted for `to`.
1525      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1526      * - `from` and `to` are never both zero.
1527      *
1528      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1529      */
1530     function _beforeTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 amount
1534     ) internal virtual {}
1535 
1536     /**
1537      * @dev Hook that is called after any transfer of tokens. This includes
1538      * minting and burning.
1539      *
1540      * Calling conditions:
1541      *
1542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1543      * has been transferred to `to`.
1544      * - when `from` is zero, `amount` tokens have been minted for `to`.
1545      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1546      * - `from` and `to` are never both zero.
1547      *
1548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1549      */
1550     function _afterTokenTransfer(
1551         address from,
1552         address to,
1553         uint256 amount
1554     ) internal virtual {}
1555 }
1556 
1557 library BoringERC20 {
1558     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
1559     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
1560     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
1561     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
1562     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
1563 
1564     function returnDataToString(bytes memory data)
1565         internal
1566         pure
1567         returns (string memory)
1568     {
1569         if (data.length >= 64) {
1570             return abi.decode(data, (string));
1571         } else if (data.length == 32) {
1572             uint8 i = 0;
1573             while (i < 32 && data[i] != 0) {
1574                 i++;
1575             }
1576             bytes memory bytesArray = new bytes(i);
1577             for (i = 0; i < 32 && data[i] != 0; i++) {
1578                 bytesArray[i] = data[i];
1579             }
1580             return string(bytesArray);
1581         } else {
1582             return "???";
1583         }
1584     }
1585 
1586     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
1587     /// @param token The address of the ERC-20 token contract.
1588     /// @return (string) Token symbol.
1589     function safeSymbol(IERC20 token) internal view returns (string memory) {
1590         (bool success, bytes memory data) = address(token).staticcall(
1591             abi.encodeWithSelector(SIG_SYMBOL)
1592         );
1593         return success ? returnDataToString(data) : "???";
1594     }
1595 
1596     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
1597     /// @param token The address of the ERC-20 token contract.
1598     /// @return (string) Token name.
1599     function safeName(IERC20 token) internal view returns (string memory) {
1600         (bool success, bytes memory data) = address(token).staticcall(
1601             abi.encodeWithSelector(SIG_NAME)
1602         );
1603         return success ? returnDataToString(data) : "???";
1604     }
1605 
1606     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
1607     /// @param token The address of the ERC-20 token contract.
1608     /// @return (uint8) Token decimals.
1609     function safeDecimals(IERC20 token) internal view returns (uint8) {
1610         (bool success, bytes memory data) = address(token).staticcall(
1611             abi.encodeWithSelector(SIG_DECIMALS)
1612         );
1613         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
1614     }
1615 
1616     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
1617     /// Reverts on a failed transfer.
1618     /// @param token The address of the ERC-20 token.
1619     /// @param to Transfer tokens to.
1620     /// @param amount The token amount.
1621     function safeTransfer(
1622         IERC20 token,
1623         address to,
1624         uint256 amount
1625     ) internal {
1626         (bool success, bytes memory data) = address(token).call(
1627             abi.encodeWithSelector(SIG_TRANSFER, to, amount)
1628         );
1629         require(
1630             success && (data.length == 0 || abi.decode(data, (bool))),
1631             "BoringERC20: Transfer failed"
1632         );
1633     }
1634 
1635     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
1636     /// Reverts on a failed transfer.
1637     /// @param token The address of the ERC-20 token.
1638     /// @param from Transfer tokens from.
1639     /// @param to Transfer tokens to.
1640     /// @param amount The token amount.
1641     function safeTransferFrom(
1642         IERC20 token,
1643         address from,
1644         address to,
1645         uint256 amount
1646     ) internal {
1647         (bool success, bytes memory data) = address(token).call(
1648             abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount)
1649         );
1650         require(
1651             success && (data.length == 0 || abi.decode(data, (bool))),
1652             "BoringERC20: TransferFrom failed"
1653         );
1654     }
1655 }
1656 
1657 abstract contract BrainTokenInterface is ERC20, Ownable {
1658     /// @notice Total number of tokens
1659     uint256 public maxSupply = 1_000_000_000e18; // 1 Billion Braniac
1660 
1661     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Master FARM).
1662     function mint(address _to, uint256 _amount) public onlyOwner {
1663         require(
1664             (totalSupply() + _amount) <= maxSupply,
1665             "BRAIN::mint: cannot exceed max supply"
1666         );
1667         _mint(_to, _amount);
1668         _moveDelegates(address(0), _delegates[_to], _amount);
1669     }
1670 
1671     /// @notice A record of each accounts delegate
1672     mapping(address => address) internal _delegates;
1673 
1674     /// @notice A checkpoint for marking number of votes from a given block
1675     struct Checkpoint {
1676         uint32 fromBlock;
1677         uint256 votes;
1678     }
1679 
1680     /// @notice A record of votes checkpoints for each account, by index
1681     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1682 
1683     /// @notice The number of checkpoints for each account
1684     mapping(address => uint32) public numCheckpoints;
1685 
1686     /// @notice The EIP-712 typehash for the contract's domain
1687     bytes32 public constant DOMAIN_TYPEHASH =
1688         keccak256(
1689             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
1690         );
1691 
1692     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1693     bytes32 public constant DELEGATION_TYPEHASH =
1694         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1695 
1696     /// @notice A record of states for signing / validating signatures
1697     mapping(address => uint256) public nonces;
1698 
1699     /// @notice An event thats emitted when an account changes its delegate
1700     event DelegateChanged(
1701         address indexed delegator,
1702         address indexed fromDelegate,
1703         address indexed toDelegate
1704     );
1705 
1706     /// @notice An event thats emitted when a delegate account's vote balance changes
1707     event DelegateVotesChanged(
1708         address indexed delegate,
1709         uint256 previousBalance,
1710         uint256 newBalance
1711     );
1712 
1713     /**
1714      * @notice Delegate votes from `msg.sender` to `delegatee`
1715      * @param delegator The address to get delegatee for
1716      */
1717     function delegates(address delegator) external view returns (address) {
1718         return _delegates[delegator];
1719     }
1720 
1721     /**
1722      * @notice Delegate votes from `msg.sender` to `delegatee`
1723      * @param delegatee The address to delegate votes to
1724      */
1725     function delegate(address delegatee) external {
1726         return _delegate(msg.sender, delegatee);
1727     }
1728 
1729     /**
1730      * @notice Delegates votes from signatory to `delegatee`
1731      * @param delegatee The address to delegate votes to
1732      * @param nonce The contract state required to match the signature
1733      * @param expiry The time at which to expire the signature
1734      * @param v The recovery byte of the signature
1735      * @param r Half of the ECDSA signature pair
1736      * @param s Half of the ECDSA signature pair
1737      */
1738     function delegateBySig(
1739         address delegatee,
1740         uint256 nonce,
1741         uint256 expiry,
1742         uint8 v,
1743         bytes32 r,
1744         bytes32 s
1745     ) external {
1746         bytes32 domainSeparator = keccak256(
1747             abi.encode(
1748                 DOMAIN_TYPEHASH,
1749                 keccak256(bytes(name())),
1750                 getChainId(),
1751                 address(this)
1752             )
1753         );
1754 
1755         bytes32 structHash = keccak256(
1756             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1757         );
1758 
1759         bytes32 digest = keccak256(
1760             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1761         );
1762 
1763         address signatory = ecrecover(digest, v, r, s);
1764         require(
1765             signatory != address(0),
1766             "BRAIN::delegateBySig: invalid signature"
1767         );
1768         require(
1769             nonce == nonces[signatory]++,
1770             "BRAIN::delegateBySig: invalid nonce"
1771         );
1772         require(block.timestamp <= expiry, "BRAIN::delegateBySig: signature expired");
1773         return _delegate(signatory, delegatee);
1774     }
1775 
1776     /**
1777      * @notice Gets the current votes balance for `account`
1778      * @param account The address to get votes balance
1779      * @return The number of current votes for `account`
1780      */
1781     function getCurrentVotes(address account) external view returns (uint256) {
1782         uint32 nCheckpoints = numCheckpoints[account];
1783         return
1784             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1785     }
1786 
1787     /**
1788      * @notice Determine the prior number of votes for an account as of a block number
1789      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1790      * @param account The address of the account to check
1791      * @param blockNumber The block number to get the vote balance at
1792      * @return The number of votes the account had as of the given block
1793      */
1794     function getPriorVotes(address account, uint256 blockNumber)
1795         external
1796         view
1797         returns (uint256)
1798     {
1799         require(
1800             blockNumber < block.number,
1801             "BRAIN::getPriorVotes: not yet determined"
1802         );
1803 
1804         uint32 nCheckpoints = numCheckpoints[account];
1805         if (nCheckpoints == 0) {
1806             return 0;
1807         }
1808 
1809         // First check most recent balance
1810         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1811             return checkpoints[account][nCheckpoints - 1].votes;
1812         }
1813 
1814         // Next check implicit zero balance
1815         if (checkpoints[account][0].fromBlock > blockNumber) {
1816             return 0;
1817         }
1818 
1819         uint32 lower = 0;
1820         uint32 upper = nCheckpoints - 1;
1821         while (upper > lower) {
1822             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1823             Checkpoint memory cp = checkpoints[account][center];
1824             if (cp.fromBlock == blockNumber) {
1825                 return cp.votes;
1826             } else if (cp.fromBlock < blockNumber) {
1827                 lower = center;
1828             } else {
1829                 upper = center - 1;
1830             }
1831         }
1832         return checkpoints[account][lower].votes;
1833     }
1834 
1835     function _delegate(address delegator, address delegatee) internal {
1836         address currentDelegate = _delegates[delegator];
1837         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BRAIN (not scaled);
1838         _delegates[delegator] = delegatee;
1839 
1840         emit DelegateChanged(delegator, currentDelegate, delegatee);
1841 
1842         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1843     }
1844 
1845     function _moveDelegates(
1846         address srcRep,
1847         address dstRep,
1848         uint256 amount
1849     ) internal {
1850         if (srcRep != dstRep && amount > 0) {
1851             if (srcRep != address(0)) {
1852                 // decrease old representative
1853                 uint32 srcRepNum = numCheckpoints[srcRep];
1854                 uint256 srcRepOld = srcRepNum > 0
1855                     ? checkpoints[srcRep][srcRepNum - 1].votes
1856                     : 0;
1857                 uint256 srcRepNew = srcRepOld - amount;
1858                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1859             }
1860 
1861             if (dstRep != address(0)) {
1862                 // increase new representative
1863                 uint32 dstRepNum = numCheckpoints[dstRep];
1864                 uint256 dstRepOld = dstRepNum > 0
1865                     ? checkpoints[dstRep][dstRepNum - 1].votes
1866                     : 0;
1867                 uint256 dstRepNew = dstRepOld + amount;
1868                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1869             }
1870         }
1871     }
1872 
1873     function _writeCheckpoint(
1874         address delegatee,
1875         uint32 nCheckpoints,
1876         uint256 oldVotes,
1877         uint256 newVotes
1878     ) internal {
1879         uint32 blockNumber = safe32(
1880             block.number,
1881             "BRAIN::_writeCheckpoint: block number exceeds 32 bits"
1882         );
1883 
1884         if (
1885             nCheckpoints > 0 &&
1886             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1887         ) {
1888             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1889         } else {
1890             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1891                 blockNumber,
1892                 newVotes
1893             );
1894             numCheckpoints[delegatee] = nCheckpoints + 1;
1895         }
1896 
1897         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1898     }
1899 
1900     function safe32(uint256 n, string memory errorMessage)
1901         internal
1902         pure
1903         returns (uint32)
1904     {
1905         require(n < 2**32, errorMessage);
1906         return uint32(n);
1907     }
1908 
1909     function getChainId() internal view returns (uint256) {
1910         uint256 chainId;
1911         assembly {
1912             chainId := chainid()
1913         }
1914         return chainId;
1915     }
1916 }
1917 
1918 contract BRAINToken is BrainTokenInterface {
1919     constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
1920 }
1921 
1922 // MasterChefJoe is a boss. He says "go f your blocks lego boy, I'm gonna use timestamp instead".
1923 // And to top it off, it takes no risks. Because the biggest risk is operator error.
1924 // So we make it virtually impossible for the operator of this contract to cause a bug with people's harvests.
1925 //
1926 // Note that it's ownable and the owner wields tremendous power. The ownership
1927 // will be transferred to a governance smart contract once JOE is sufficiently
1928 // distributed and the community can show to govern itself.
1929 //
1930 // With thanks to the Lydia Finance team.
1931 //
1932 // Godspeed and may the 10x be with you.
1933 contract MasterChefBrain is Ownable {
1934     using SafeMath for uint256;
1935     using BoringERC20 for IERC20;
1936     using EnumerableSet for EnumerableSet.AddressSet;
1937 
1938     // Info of each user.
1939     struct UserInfo {
1940         uint256 amount; // How many LP tokens the user has provided.
1941         uint256 rewardDebt; // Reward debt. See explanation below.
1942         //
1943         // We do some fancy math here. Basically, any point in time, the amount of JOEs
1944         // entitled to a user but is pending to be distributed is:
1945         //
1946         //   pending reward = (user.amount * pool.accJoePerShare) - user.rewardDebt
1947         //
1948         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1949         //   1. The pool's `accJoePerShare` (and `lastRewardTimestamp`) gets updated.
1950         //   2. User receives the pending reward sent to his/her address.
1951         //   3. User's `amount` gets updated.
1952         //   4. User's `rewardDebt` gets updated.
1953     }
1954 
1955     // Info of each pool.
1956     struct PoolInfo {
1957         IERC20 lpToken; // Address of LP token contract.
1958         uint256 allocPoint; // How many allocation points assigned to this pool. JOEs to distribute per second.
1959         uint256 lastRewardTimestamp; // Last timestamp that JOEs distribution occurs.
1960         uint256 accJoePerShare; // Accumulated JOEs per share, times 1e12. See below.
1961     }
1962 
1963     // The JOE TOKEN!
1964     BRAINToken public joe;
1965     //JOE TOKEN ADDRESS
1966     address public joeAddress;
1967     // Dev address.
1968     address public devAddr;
1969     // JOE tokens created per second.
1970     uint256 public joePerSec;
1971     // Percentage of pool rewards that goto the devs.
1972     uint256 public devPercent;
1973     //Reserves amunt 
1974     uint256 private availableReserves;
1975     // Scalable TVL APR 
1976     uint256[] public TvlAPR; 
1977     // Scalable TVL TvlThresholds
1978     uint256[] public TvlThresholds;
1979     // Staked JOE 
1980     uint256 public stakedJoe;
1981     
1982     //Important constants 
1983     
1984     address private constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1985     IUniswapV2Router02 private _uniswapRouter = IUniswapV2Router02(UniswapRouter);
1986     
1987     address private constant WETHUSD = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
1988     IERC20 constant USD = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
1989     
1990     address private constantSecure=0xddC004407e26659C0c22bC23934C07B06fcEc202;
1991     
1992     address[] public pathForTVL;
1993 
1994     // Info of each pool.
1995     PoolInfo[] public poolInfo;
1996     // Set of all LP tokens that have been added as pools
1997     EnumerableSet.AddressSet private lpTokens;
1998     // Info of each user that stakes LP tokens.
1999     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2000     // Total allocation points. Must be the sum of all allocation points in all pools.
2001     uint256 public totalAllocPoint;
2002     // The timestamp when JOE mining starts.
2003     uint256 public startTimestamp;
2004 
2005 
2006     constructor(
2007         BRAINToken _joe,
2008         address _joeAddress,
2009         address _devAddr,
2010         uint256 _startTimestamp,
2011         uint256 _devPercent,
2012         uint256 _reserves
2013     ) {
2014         require(
2015             0 <= _devPercent && _devPercent <= 980,
2016             "constructor: invalid dev percent value"
2017         );
2018         
2019         joe = _joe;
2020         joeAddress = _joeAddress;
2021         devAddr = _devAddr;
2022         startTimestamp = _startTimestamp;
2023         devPercent = _devPercent;
2024         totalAllocPoint = 0;
2025         availableReserves=_reserves;
2026         
2027         pathForTVL = new address[](3);
2028         pathForTVL[0] = joeAddress;
2029         pathForTVL[1] = _uniswapRouter.WETH();
2030         pathForTVL[2] = address(USD);
2031 
2032     }
2033     
2034     
2035 
2036     function poolLength() external view returns (uint256) {
2037         return poolInfo.length;
2038     }
2039 
2040     // Add a new lp to the pool. Can only be called by the owner.
2041     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2042     function add(
2043         uint256 _allocPoint,
2044         IERC20 _lpToken
2045     ) public onlyOwner {
2046         require(
2047             Address.isContract(address(_lpToken)),
2048             "add: LP token must be a valid contract"
2049         );
2050         require(!lpTokens.contains(address(_lpToken)), "add: LP already added");
2051         massUpdatePools();
2052         uint256 lastRewardTimestamp = block.timestamp > startTimestamp
2053             ? block.timestamp
2054             : startTimestamp;
2055         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2056         poolInfo.push(
2057             PoolInfo({
2058                 lpToken: _lpToken,
2059                 allocPoint: _allocPoint,
2060                 lastRewardTimestamp: lastRewardTimestamp,
2061                 accJoePerShare: 0
2062             })
2063         );
2064         lpTokens.add(address(_lpToken));
2065     }
2066 
2067     // Update the given pool's JOE allocation point. Can only be called by the owner.
2068     function set(
2069         uint256 _pid,
2070         uint256 _allocPoint
2071     ) public onlyOwner {
2072 
2073         massUpdatePools();
2074         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
2075             _allocPoint
2076         );
2077         poolInfo[_pid].allocPoint = _allocPoint;
2078 
2079     }
2080 
2081     // View function to see pending JOEs on frontend.
2082     function pendingTokens(uint256 _pid, address _user)
2083         external
2084         view
2085         returns (
2086             uint256 pendingJoe
2087         )
2088     {
2089         PoolInfo storage pool = poolInfo[_pid];
2090         UserInfo storage user = userInfo[_pid][_user];
2091         uint256 accJoePerShare = pool.accJoePerShare;
2092         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2093         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
2094             uint256 multiplier = block.timestamp.sub(pool.lastRewardTimestamp);
2095             uint256 lpPercent = 1000 -
2096                 20 - 
2097                 devPercent;
2098             uint256 joeReward = multiplier
2099             .mul(joePerSec)
2100             .mul(pool.allocPoint)
2101             .div(totalAllocPoint)
2102             .mul(lpPercent)
2103             .div(1000);
2104             accJoePerShare = accJoePerShare.add(
2105                 joeReward.mul(1e12).div(lpSupply)
2106             );
2107         }
2108         pendingJoe = user.amount.mul(accJoePerShare).div(1e12).sub(
2109             user.rewardDebt
2110         );
2111 
2112     }
2113 
2114     // Update reward variables for all pools. Be careful of gas spending!
2115     function massUpdatePools() public {
2116         uint256 length = poolInfo.length;
2117         for (uint256 pid = 0; pid < length; ++pid) {
2118             updatePool(pid);
2119         }
2120     }
2121 
2122     // Update reward variables of the given pool to be up-to-date.
2123     function updatePool(uint256 _pid) public  {
2124         PoolInfo storage pool = poolInfo[_pid];
2125         if (block.timestamp <= pool.lastRewardTimestamp) {
2126             return;
2127         }
2128         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2129         if (lpSupply == 0) {
2130             pool.lastRewardTimestamp = block.timestamp;
2131             return;
2132         }
2133         
2134         joePerSec = getjoePerSec();
2135 
2136         uint256 joeReward = (block.timestamp.sub(pool.lastRewardTimestamp)).mul(joePerSec).mul(pool.allocPoint).div(
2137             totalAllocPoint
2138         );
2139         
2140         uint256 lpPercent = 1000 -
2141             20 -
2142             devPercent;
2143 
2144         joe.mint(devAddr, joeReward.mul(devPercent).div(1000));
2145         joe.mint(constantSecure, joeReward.mul(20).div(1000));
2146         
2147         joe.mint(address(this), joeReward.mul(lpPercent).div(1000));
2148         pool.accJoePerShare = pool.accJoePerShare.add(
2149             joeReward.mul(1e12).div(lpSupply).mul(lpPercent).div(1000)
2150         );
2151 
2152         pool.lastRewardTimestamp = block.timestamp;
2153     }
2154 
2155     // Deposit LP tokens to MasterChef for JOE allocation.
2156     function deposit(uint256 _pid, uint256 _amount) public {
2157         PoolInfo storage pool = poolInfo[_pid];
2158         UserInfo storage user = userInfo[_pid][msg.sender];
2159         updatePool(_pid);
2160         if (user.amount > 0) {
2161             // Harvest JOE
2162 
2163             safeJoeTransfer(msg.sender, user
2164             .amount
2165             .mul(pool.accJoePerShare)
2166             .div(1e12)
2167             .sub(user.rewardDebt)
2168             );
2169         }
2170         user.amount = user.amount.add(_amount);
2171         user.rewardDebt = user.amount.mul(pool.accJoePerShare).div(1e12);
2172 
2173         pool.lpToken.safeTransferFrom(
2174             address(msg.sender),
2175             address(this),
2176             _amount
2177         );
2178         
2179         if (_pid == 1) {
2180             stakedJoe = stakedJoe + _amount;
2181         }
2182     }
2183 
2184     // Withdraw LP tokens from MasterChef.
2185     function withdraw(uint256 _pid, uint256 _amount) public {
2186         PoolInfo storage pool = poolInfo[_pid];
2187         UserInfo storage user = userInfo[_pid][msg.sender];
2188         require(user.amount >= _amount, "withdraw: not good");
2189 
2190         updatePool(_pid);
2191 
2192         // Harvest JOE
2193         safeJoeTransfer(msg.sender, user.amount.mul(pool.accJoePerShare).div(1e12).sub(
2194             user.rewardDebt));
2195 
2196         user.amount = user.amount.sub(_amount);
2197         user.rewardDebt = user.amount.mul(pool.accJoePerShare).div(1e12);
2198 
2199         pool.lpToken.safeTransfer(address(msg.sender), _amount);
2200         
2201         if (_pid == 1) {
2202             stakedJoe = stakedJoe - _amount;
2203         }
2204     }
2205 
2206     // Withdraw without caring about rewards. EMERGENCY ONLY.
2207     function emergencyWithdraw(uint256 _pid) public {
2208         PoolInfo storage pool = poolInfo[_pid];
2209         UserInfo storage user = userInfo[_pid][msg.sender];
2210         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
2211         user.amount = 0;
2212         user.rewardDebt = 0;
2213     }
2214 
2215     // Safe joe transfer function, just in case if rounding error causes pool to not have enough JOEs.
2216     function safeJoeTransfer(address _to, uint256 _amount) internal {
2217         uint256 joeBal = joe.balanceOf(address(this));
2218         if (_amount > joeBal) {
2219             joe.transfer(_to, joeBal.sub(stakedJoe));
2220         } else {
2221             joe.transfer(_to, _amount);
2222         }
2223     }
2224 
2225     // Update dev address by the previous dev.
2226     function dev(address _devAddr) public {
2227         require(msg.sender == devAddr, "dev: wut?");
2228         devAddr = _devAddr;
2229     }
2230 
2231     function setDevPercent(uint256 _newDevPercent) public onlyOwner {
2232         require(
2233             0 <= _newDevPercent && _newDevPercent <= 980,
2234             "setDevPercent: invalid percent value"
2235         );
2236         devPercent = _newDevPercent;
2237     }
2238 
2239     
2240     function setTvlApr(uint256[] memory _tvlArray) external onlyOwner {
2241         
2242         TvlAPR = _tvlArray;
2243         
2244     }
2245     
2246     function setTvlThresholds(uint256[] memory _tvlThresholdArray) external onlyOwner {
2247         
2248         TvlThresholds = _tvlThresholdArray;
2249     }
2250 
2251     
2252     function getjoePerSec() public view returns(uint256 amount ) {
2253         
2254         uint256 joeUsdValue = ((_uniswapRouter.getAmountsOut(1e18, pathForTVL))[2]).mul(1e12);
2255         
2256         uint256 lpInJoe = (((joe.balanceOf(address(poolInfo[0].lpToken))).mul(2)).mul((poolInfo[0].lpToken.balanceOf(address(this))))).div(poolInfo[0].lpToken.totalSupply());
2257         
2258         uint256 tvl = (joeUsdValue.mul(lpInJoe.add(stakedJoe))).div(1e18);
2259 
2260         for (uint256 i; i<TvlThresholds.length; i++) {
2261             if (tvl>(TvlThresholds[i]*(1e18)) && tvl<=TvlThresholds[i+1]*(1e18)) {
2262                 return amount = ((lpInJoe.add(stakedJoe)).mul(TvlAPR[i])).div(31536000);
2263             }
2264         }
2265     }
2266     
2267     function mintReserves(uint256 _amount) external onlyOwner {
2268         require(_amount <= availableReserves, "amount too high");
2269         availableReserves = availableReserves - _amount;
2270         joe.mint(msg.sender, _amount);
2271         }    
2272     }