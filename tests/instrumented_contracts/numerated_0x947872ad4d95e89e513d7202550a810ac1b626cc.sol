1 // SPDX-License-Identifier: Apache-2.0
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address payable) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes memory) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: EnumerableSet
219 
220 /**
221  * @dev Library for managing
222  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
223  * types.
224  *
225  * Sets have the following properties:
226  *
227  * - Elements are added, removed, and checked for existence in constant time
228  * (O(1)).
229  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
230  *
231  * ```
232  * contract Example {
233  *     // Add the library methods
234  *     using EnumerableSet for EnumerableSet.AddressSet;
235  *
236  *     // Declare a set state variable
237  *     EnumerableSet.AddressSet private mySet;
238  * }
239  * ```
240  *
241  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
242  * and `uint256` (`UintSet`) are supported.
243  */
244 library EnumerableSet {
245     // To implement this library for multiple types with as little code
246     // repetition as possible, we write it in terms of a generic Set type with
247     // bytes32 values.
248     // The Set implementation uses private functions, and user-facing
249     // implementations (such as AddressSet) are just wrappers around the
250     // underlying Set.
251     // This means that we can only create new EnumerableSets for types that fit
252     // in bytes32.
253 
254     struct Set {
255         // Storage of set values
256         bytes32[] _values;
257 
258         // Position of the value in the `values` array, plus 1 because index 0
259         // means a value is not in the set.
260         mapping (bytes32 => uint256) _indexes;
261     }
262 
263     /**
264      * @dev Add a value to a set. O(1).
265      *
266      * Returns true if the value was added to the set, that is if it was not
267      * already present.
268      */
269     function _add(Set storage set, bytes32 value) private returns (bool) {
270         if (!_contains(set, value)) {
271             set._values.push(value);
272             // The value is stored at length-1, but we add 1 to all indexes
273             // and use 0 as a sentinel value
274             set._indexes[value] = set._values.length;
275             return true;
276         } else {
277             return false;
278         }
279     }
280 
281     /**
282      * @dev Removes a value from a set. O(1).
283      *
284      * Returns true if the value was removed from the set, that is if it was
285      * present.
286      */
287     function _remove(Set storage set, bytes32 value) private returns (bool) {
288         // We read and store the value's index to prevent multiple reads from the same storage slot
289         uint256 valueIndex = set._indexes[value];
290 
291         if (valueIndex != 0) { // Equivalent to contains(set, value)
292             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
293             // the array, and then remove the last element (sometimes called as 'swap and pop').
294             // This modifies the order of the array, as noted in {at}.
295 
296             uint256 toDeleteIndex = valueIndex - 1;
297             uint256 lastIndex = set._values.length - 1;
298 
299             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
300             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
301 
302             bytes32 lastvalue = set._values[lastIndex];
303 
304             // Move the last value to the index where the value to delete is
305             set._values[toDeleteIndex] = lastvalue;
306             // Update the index for the moved value
307             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
308 
309             // Delete the slot where the moved value was stored
310             set._values.pop();
311 
312             // Delete the index for the deleted slot
313             delete set._indexes[value];
314 
315             return true;
316         } else {
317             return false;
318         }
319     }
320 
321     /**
322      * @dev Returns true if the value is in the set. O(1).
323      */
324     function _contains(Set storage set, bytes32 value) private view returns (bool) {
325         return set._indexes[value] != 0;
326     }
327 
328     /**
329      * @dev Returns the number of values on the set. O(1).
330      */
331     function _length(Set storage set) private view returns (uint256) {
332         return set._values.length;
333     }
334 
335    /**
336     * @dev Returns the value stored at position `index` in the set. O(1).
337     *
338     * Note that there are no guarantees on the ordering of values inside the
339     * array, and it may change when more values are added or removed.
340     *
341     * Requirements:
342     *
343     * - `index` must be strictly less than {length}.
344     */
345     function _at(Set storage set, uint256 index) private view returns (bytes32) {
346         require(set._values.length > index, "EnumerableSet: index out of bounds");
347         return set._values[index];
348     }
349 
350     // Bytes32Set
351 
352     struct Bytes32Set {
353         Set _inner;
354     }
355 
356     /**
357      * @dev Add a value to a set. O(1).
358      *
359      * Returns true if the value was added to the set, that is if it was not
360      * already present.
361      */
362     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
363         return _add(set._inner, value);
364     }
365 
366     /**
367      * @dev Removes a value from a set. O(1).
368      *
369      * Returns true if the value was removed from the set, that is if it was
370      * present.
371      */
372     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
373         return _remove(set._inner, value);
374     }
375 
376     /**
377      * @dev Returns true if the value is in the set. O(1).
378      */
379     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
380         return _contains(set._inner, value);
381     }
382 
383     /**
384      * @dev Returns the number of values in the set. O(1).
385      */
386     function length(Bytes32Set storage set) internal view returns (uint256) {
387         return _length(set._inner);
388     }
389 
390    /**
391     * @dev Returns the value stored at position `index` in the set. O(1).
392     *
393     * Note that there are no guarantees on the ordering of values inside the
394     * array, and it may change when more values are added or removed.
395     *
396     * Requirements:
397     *
398     * - `index` must be strictly less than {length}.
399     */
400     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
401         return _at(set._inner, index);
402     }
403 
404     // AddressSet
405 
406     struct AddressSet {
407         Set _inner;
408     }
409 
410     /**
411      * @dev Add a value to a set. O(1).
412      *
413      * Returns true if the value was added to the set, that is if it was not
414      * already present.
415      */
416     function add(AddressSet storage set, address value) internal returns (bool) {
417         return _add(set._inner, bytes32(uint256(uint160(value))));
418     }
419 
420     /**
421      * @dev Removes a value from a set. O(1).
422      *
423      * Returns true if the value was removed from the set, that is if it was
424      * present.
425      */
426     function remove(AddressSet storage set, address value) internal returns (bool) {
427         return _remove(set._inner, bytes32(uint256(uint160(value))));
428     }
429 
430     /**
431      * @dev Returns true if the value is in the set. O(1).
432      */
433     function contains(AddressSet storage set, address value) internal view returns (bool) {
434         return _contains(set._inner, bytes32(uint256(uint160(value))));
435     }
436 
437     /**
438      * @dev Returns the number of values in the set. O(1).
439      */
440     function length(AddressSet storage set) internal view returns (uint256) {
441         return _length(set._inner);
442     }
443 
444    /**
445     * @dev Returns the value stored at position `index` in the set. O(1).
446     *
447     * Note that there are no guarantees on the ordering of values inside the
448     * array, and it may change when more values are added or removed.
449     *
450     * Requirements:
451     *
452     * - `index` must be strictly less than {length}.
453     */
454     function at(AddressSet storage set, uint256 index) internal view returns (address) {
455         return address(uint160(uint256(_at(set._inner, index))));
456     }
457 
458 
459     // UintSet
460 
461     struct UintSet {
462         Set _inner;
463     }
464 
465     /**
466      * @dev Add a value to a set. O(1).
467      *
468      * Returns true if the value was added to the set, that is if it was not
469      * already present.
470      */
471     function add(UintSet storage set, uint256 value) internal returns (bool) {
472         return _add(set._inner, bytes32(value));
473     }
474 
475     /**
476      * @dev Removes a value from a set. O(1).
477      *
478      * Returns true if the value was removed from the set, that is if it was
479      * present.
480      */
481     function remove(UintSet storage set, uint256 value) internal returns (bool) {
482         return _remove(set._inner, bytes32(value));
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
489         return _contains(set._inner, bytes32(value));
490     }
491 
492     /**
493      * @dev Returns the number of values on the set. O(1).
494      */
495     function length(UintSet storage set) internal view returns (uint256) {
496         return _length(set._inner);
497     }
498 
499    /**
500     * @dev Returns the value stored at position `index` in the set. O(1).
501     *
502     * Note that there are no guarantees on the ordering of values inside the
503     * array, and it may change when more values are added or removed.
504     *
505     * Requirements:
506     *
507     * - `index` must be strictly less than {length}.
508     */
509     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
510         return uint256(_at(set._inner, index));
511     }
512 }
513 
514 // Part: IBridgeCommon
515 
516 /**
517  * @title Events for Bi-directional bridge transferring FET tokens between Ethereum and Fetch Mainnet-v2
518  */
519 interface IBridgeCommon {
520 
521     event Swap(uint64 indexed id, address indexed from, string indexed indexedTo, string to, uint256 amount);
522 
523     event SwapRefund(uint64 indexed id, address indexed to, uint256 refundedAmount, uint256 fee);
524     event ReverseSwap(uint64 indexed rid, address indexed to, string indexed from, bytes32 originTxHash, uint256 effectiveAmount, uint256 fee);
525     event PausePublicApi(uint256 sinceBlock);
526     event PauseRelayerApi(uint256 sinceBlock);
527     event NewRelayEon(uint64 eon);
528 
529     event LimitsUpdate(uint256 max, uint256 min, uint256 fee);
530     event CapUpdate(uint256 value);
531     event ReverseAggregatedAllowanceUpdate(uint256 value);
532     event ReverseAggregatedAllowanceApproverCapUpdate(uint256 value);
533     event Withdraw(address indexed targetAddress, uint256 amount);
534     event Deposit(address indexed fromAddress, uint256 amount);
535     event FeesWithdrawal(address indexed targetAddress, uint256 amount);
536     event DeleteContract(address targetAddress, uint256 amount);
537     // NOTE(pb): It is NOT necessary to have dedicated events here for Mint & Burn operations, since ERC20 contract
538     //  already emits the `Transfer(from, to, amount)` events, with `from`, resp. `to`, address parameter value set to
539     //  ZERO_ADDRESS (= address(0) = 0x00...00) for `mint`, resp `burn`, calls to ERC20 contract. That way we can
540     //  identify events for mint, resp. burn, calls by filtering ERC20 Transfer events with `from == ZERO_ADDR  &&
541     //  to == Bridge.address` for MINT operation, resp `from == Bridge.address` and `to == ZERO_ADDR` for BURN operation.
542     //event Mint(uint256 amount);
543     //event Burn(uint256 amount);
544 
545     function getApproverRole() external view returns(bytes32);
546     function getMonitorRole() external view returns(bytes32);
547     function getRelayerRole() external view returns(bytes32);
548 
549     function getToken() external view returns(address);
550     function getEarliestDelete() external view returns(uint256);
551     function getSupply() external view returns(uint256);
552     function getNextSwapId() external view returns(uint64);
553     function getRelayEon() external view returns(uint64);
554     function getRefund(uint64 swap_id) external view returns(uint256); // swapId -> original swap amount(= *includes* swapFee)
555     function getSwapMax() external view returns(uint256);
556     function getSwapMin() external view returns(uint256);
557     function getCap() external view returns(uint256);
558     function getSwapFee() external view returns(uint256);
559     function getPausedSinceBlockPublicApi() external view returns(uint256);
560     function getPausedSinceBlockRelayerApi() external view returns(uint256);
561     function getReverseAggregatedAllowance() external view returns(uint256);
562     function getReverseAggregatedAllowanceApproverCap() external view returns(uint256);
563 
564 }
565 
566 // Part: IERC20
567 
568 /**
569  * @dev Interface of the ERC20 standard as defined in the EIP.
570  */
571 interface IERC20 {
572     /**
573      * @dev Returns the amount of tokens in existence.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     /**
578      * @dev Returns the amount of tokens owned by `account`.
579      */
580     function balanceOf(address account) external view returns (uint256);
581 
582     /**
583      * @dev Moves `amount` tokens from the caller's account to `recipient`.
584      *
585      * Returns a boolean value indicating whether the operation succeeded.
586      *
587      * Emits a {Transfer} event.
588      */
589     function transfer(address recipient, uint256 amount) external returns (bool);
590 
591     /**
592      * @dev Returns the remaining number of tokens that `spender` will be
593      * allowed to spend on behalf of `owner` through {transferFrom}. This is
594      * zero by default.
595      *
596      * This value changes when {approve} or {transferFrom} are called.
597      */
598     function allowance(address owner, address spender) external view returns (uint256);
599 
600     /**
601      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
602      *
603      * Returns a boolean value indicating whether the operation succeeded.
604      *
605      * IMPORTANT: Beware that changing an allowance with this method brings the risk
606      * that someone may use both the old and the new allowance by unfortunate
607      * transaction ordering. One possible solution to mitigate this race
608      * condition is to first reduce the spender's allowance to 0 and set the
609      * desired value afterwards:
610      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address spender, uint256 amount) external returns (bool);
615 
616     /**
617      * @dev Moves `amount` tokens from `sender` to `recipient` using the
618      * allowance mechanism. `amount` is then deducted from the caller's
619      * allowance.
620      *
621      * Returns a boolean value indicating whether the operation succeeded.
622      *
623      * Emits a {Transfer} event.
624      */
625     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
626 
627     /**
628      * @dev Emitted when `value` tokens are moved from one account (`from`) to
629      * another (`to`).
630      *
631      * Note that `value` may be zero.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 value);
634 
635     /**
636      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
637      * a call to {approve}. `value` is the new allowance.
638      */
639     event Approval(address indexed owner, address indexed spender, uint256 value);
640 }
641 
642 // Part: IERC20MintFacility
643 
644 interface IERC20MintFacility
645 {
646     function mint(address to, uint256 amount) external;
647     function burn(uint256 amount) external;
648     function burnFrom(address from, uint256 amount) external;
649 }
650 
651 // Part: SafeMath
652 
653 /**
654  * @dev Wrappers over Solidity's arithmetic operations with added overflow
655  * checks.
656  *
657  * Arithmetic operations in Solidity wrap on overflow. This can easily result
658  * in bugs, because programmers usually assume that an overflow raises an
659  * error, which is the standard behavior in high level programming languages.
660  * `SafeMath` restores this intuition by reverting the transaction when an
661  * operation overflows.
662  *
663  * Using this library instead of the unchecked operations eliminates an entire
664  * class of bugs, so it's recommended to use it always.
665  */
666 library SafeMath {
667     /**
668      * @dev Returns the addition of two unsigned integers, with an overflow flag.
669      *
670      * _Available since v3.4._
671      */
672     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
673         uint256 c = a + b;
674         if (c < a) return (false, 0);
675         return (true, c);
676     }
677 
678     /**
679      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
680      *
681      * _Available since v3.4._
682      */
683     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
684         if (b > a) return (false, 0);
685         return (true, a - b);
686     }
687 
688     /**
689      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
695         // benefit is lost if 'b' is also tested.
696         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
697         if (a == 0) return (true, 0);
698         uint256 c = a * b;
699         if (c / a != b) return (false, 0);
700         return (true, c);
701     }
702 
703     /**
704      * @dev Returns the division of two unsigned integers, with a division by zero flag.
705      *
706      * _Available since v3.4._
707      */
708     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
709         if (b == 0) return (false, 0);
710         return (true, a / b);
711     }
712 
713     /**
714      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
715      *
716      * _Available since v3.4._
717      */
718     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
719         if (b == 0) return (false, 0);
720         return (true, a % b);
721     }
722 
723     /**
724      * @dev Returns the addition of two unsigned integers, reverting on
725      * overflow.
726      *
727      * Counterpart to Solidity's `+` operator.
728      *
729      * Requirements:
730      *
731      * - Addition cannot overflow.
732      */
733     function add(uint256 a, uint256 b) internal pure returns (uint256) {
734         uint256 c = a + b;
735         require(c >= a, "SafeMath: addition overflow");
736         return c;
737     }
738 
739     /**
740      * @dev Returns the subtraction of two unsigned integers, reverting on
741      * overflow (when the result is negative).
742      *
743      * Counterpart to Solidity's `-` operator.
744      *
745      * Requirements:
746      *
747      * - Subtraction cannot overflow.
748      */
749     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
750         require(b <= a, "SafeMath: subtraction overflow");
751         return a - b;
752     }
753 
754     /**
755      * @dev Returns the multiplication of two unsigned integers, reverting on
756      * overflow.
757      *
758      * Counterpart to Solidity's `*` operator.
759      *
760      * Requirements:
761      *
762      * - Multiplication cannot overflow.
763      */
764     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
765         if (a == 0) return 0;
766         uint256 c = a * b;
767         require(c / a == b, "SafeMath: multiplication overflow");
768         return c;
769     }
770 
771     /**
772      * @dev Returns the integer division of two unsigned integers, reverting on
773      * division by zero. The result is rounded towards zero.
774      *
775      * Counterpart to Solidity's `/` operator. Note: this function uses a
776      * `revert` opcode (which leaves remaining gas untouched) while Solidity
777      * uses an invalid opcode to revert (consuming all remaining gas).
778      *
779      * Requirements:
780      *
781      * - The divisor cannot be zero.
782      */
783     function div(uint256 a, uint256 b) internal pure returns (uint256) {
784         require(b > 0, "SafeMath: division by zero");
785         return a / b;
786     }
787 
788     /**
789      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
790      * reverting when dividing by zero.
791      *
792      * Counterpart to Solidity's `%` operator. This function uses a `revert`
793      * opcode (which leaves remaining gas untouched) while Solidity uses an
794      * invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
801         require(b > 0, "SafeMath: modulo by zero");
802         return a % b;
803     }
804 
805     /**
806      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
807      * overflow (when the result is negative).
808      *
809      * CAUTION: This function is deprecated because it requires allocating memory for the error
810      * message unnecessarily. For custom revert reasons use {trySub}.
811      *
812      * Counterpart to Solidity's `-` operator.
813      *
814      * Requirements:
815      *
816      * - Subtraction cannot overflow.
817      */
818     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
819         require(b <= a, errorMessage);
820         return a - b;
821     }
822 
823     /**
824      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
825      * division by zero. The result is rounded towards zero.
826      *
827      * CAUTION: This function is deprecated because it requires allocating memory for the error
828      * message unnecessarily. For custom revert reasons use {tryDiv}.
829      *
830      * Counterpart to Solidity's `/` operator. Note: this function uses a
831      * `revert` opcode (which leaves remaining gas untouched) while Solidity
832      * uses an invalid opcode to revert (consuming all remaining gas).
833      *
834      * Requirements:
835      *
836      * - The divisor cannot be zero.
837      */
838     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
839         require(b > 0, errorMessage);
840         return a / b;
841     }
842 
843     /**
844      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
845      * reverting with custom message when dividing by zero.
846      *
847      * CAUTION: This function is deprecated because it requires allocating memory for the error
848      * message unnecessarily. For custom revert reasons use {tryMod}.
849      *
850      * Counterpart to Solidity's `%` operator. This function uses a `revert`
851      * opcode (which leaves remaining gas untouched) while Solidity uses an
852      * invalid opcode to revert (consuming all remaining gas).
853      *
854      * Requirements:
855      *
856      * - The divisor cannot be zero.
857      */
858     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
859         require(b > 0, errorMessage);
860         return a % b;
861     }
862 }
863 
864 // Part: AccessControl
865 
866 /**
867  * @dev Contract module that allows children to implement role-based access
868  * control mechanisms.
869  *
870  * Roles are referred to by their `bytes32` identifier. These should be exposed
871  * in the external API and be unique. The best way to achieve this is by
872  * using `public constant` hash digests:
873  *
874  * ```
875  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
876  * ```
877  *
878  * Roles can be used to represent a set of permissions. To restrict access to a
879  * function call, use {hasRole}:
880  *
881  * ```
882  * function foo() public {
883  *     require(hasRole(MY_ROLE, msg.sender));
884  *     ...
885  * }
886  * ```
887  *
888  * Roles can be granted and revoked dynamically via the {grantRole} and
889  * {revokeRole} functions. Each role has an associated admin role, and only
890  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
891  *
892  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
893  * that only accounts with this role will be able to grant or revoke other
894  * roles. More complex role relationships can be created by using
895  * {_setRoleAdmin}.
896  *
897  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
898  * grant and revoke this role. Extra precautions should be taken to secure
899  * accounts that have been granted it.
900  */
901 abstract contract AccessControl is Context {
902     using EnumerableSet for EnumerableSet.AddressSet;
903     using Address for address;
904 
905     struct RoleData {
906         EnumerableSet.AddressSet members;
907         bytes32 adminRole;
908     }
909 
910     mapping (bytes32 => RoleData) private _roles;
911 
912     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
913 
914     /**
915      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
916      *
917      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
918      * {RoleAdminChanged} not being emitted signaling this.
919      *
920      * _Available since v3.1._
921      */
922     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
923 
924     /**
925      * @dev Emitted when `account` is granted `role`.
926      *
927      * `sender` is the account that originated the contract call, an admin role
928      * bearer except when using {_setupRole}.
929      */
930     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
931 
932     /**
933      * @dev Emitted when `account` is revoked `role`.
934      *
935      * `sender` is the account that originated the contract call:
936      *   - if using `revokeRole`, it is the admin role bearer
937      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
938      */
939     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
940 
941     /**
942      * @dev Returns `true` if `account` has been granted `role`.
943      */
944     function hasRole(bytes32 role, address account) public view returns (bool) {
945         return _roles[role].members.contains(account);
946     }
947 
948     /**
949      * @dev Returns the number of accounts that have `role`. Can be used
950      * together with {getRoleMember} to enumerate all bearers of a role.
951      */
952     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
953         return _roles[role].members.length();
954     }
955 
956     /**
957      * @dev Returns one of the accounts that have `role`. `index` must be a
958      * value between 0 and {getRoleMemberCount}, non-inclusive.
959      *
960      * Role bearers are not sorted in any particular way, and their ordering may
961      * change at any point.
962      *
963      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
964      * you perform all queries on the same block. See the following
965      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
966      * for more information.
967      */
968     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
969         return _roles[role].members.at(index);
970     }
971 
972     /**
973      * @dev Returns the admin role that controls `role`. See {grantRole} and
974      * {revokeRole}.
975      *
976      * To change a role's admin, use {_setRoleAdmin}.
977      */
978     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
979         return _roles[role].adminRole;
980     }
981 
982     /**
983      * @dev Grants `role` to `account`.
984      *
985      * If `account` had not been already granted `role`, emits a {RoleGranted}
986      * event.
987      *
988      * Requirements:
989      *
990      * - the caller must have ``role``'s admin role.
991      */
992     function grantRole(bytes32 role, address account) public virtual {
993         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
994 
995         _grantRole(role, account);
996     }
997 
998     /**
999      * @dev Revokes `role` from `account`.
1000      *
1001      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1002      *
1003      * Requirements:
1004      *
1005      * - the caller must have ``role``'s admin role.
1006      */
1007     function revokeRole(bytes32 role, address account) public virtual {
1008         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1009 
1010         _revokeRole(role, account);
1011     }
1012 
1013     /**
1014      * @dev Revokes `role` from the calling account.
1015      *
1016      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1017      * purpose is to provide a mechanism for accounts to lose their privileges
1018      * if they are compromised (such as when a trusted device is misplaced).
1019      *
1020      * If the calling account had been granted `role`, emits a {RoleRevoked}
1021      * event.
1022      *
1023      * Requirements:
1024      *
1025      * - the caller must be `account`.
1026      */
1027     function renounceRole(bytes32 role, address account) public virtual {
1028         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1029 
1030         _revokeRole(role, account);
1031     }
1032 
1033     /**
1034      * @dev Grants `role` to `account`.
1035      *
1036      * If `account` had not been already granted `role`, emits a {RoleGranted}
1037      * event. Note that unlike {grantRole}, this function doesn't perform any
1038      * checks on the calling account.
1039      *
1040      * [WARNING]
1041      * ====
1042      * This function should only be called from the constructor when setting
1043      * up the initial roles for the system.
1044      *
1045      * Using this function in any other way is effectively circumventing the admin
1046      * system imposed by {AccessControl}.
1047      * ====
1048      */
1049     function _setupRole(bytes32 role, address account) internal virtual {
1050         _grantRole(role, account);
1051     }
1052 
1053     /**
1054      * @dev Sets `adminRole` as ``role``'s admin role.
1055      *
1056      * Emits a {RoleAdminChanged} event.
1057      */
1058     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1059         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1060         _roles[role].adminRole = adminRole;
1061     }
1062 
1063     function _grantRole(bytes32 role, address account) private {
1064         if (_roles[role].members.add(account)) {
1065             emit RoleGranted(role, account, _msgSender());
1066         }
1067     }
1068 
1069     function _revokeRole(bytes32 role, address account) private {
1070         if (_roles[role].members.remove(account)) {
1071             emit RoleRevoked(role, account, _msgSender());
1072         }
1073     }
1074 }
1075 
1076 // Part: IBridgeMonitor
1077 
1078 /**
1079  * @title *Monitor* interface of Bi-directional bridge for transfer of FET tokens between Ethereum
1080  *        and Fetch Mainnet-v2.
1081  *
1082  * @notice By design, all methods of this monitor-level interface can be called monitor and admin roles of
1083  *         the Bridge contract.
1084  *
1085  */
1086 interface IBridgeMonitor is IBridgeCommon {
1087     /**
1088      * @notice Pauses Public API since the specified block number
1089      * @param blockNumber block number since which non-admin interaction will be paused (for all
1090      *        block.number >= blockNumber).
1091      * @dev Delegate only
1092      *      If `blocknumber < block.number`, then contract will be paused immediately = from `block.number`.
1093      */
1094     function pausePublicApiSince(uint256 blockNumber) external;
1095 
1096     /**
1097      * @notice Pauses Relayer API since the specified block number
1098      * @param blockNumber block number since which non-admin interaction will be paused (for all
1099      *        block.number >= blockNumber).
1100      * @dev Delegate only
1101      *      If `blocknumber < block.number`, then contract will be paused immediately = from `block.number`.
1102      */
1103     function pauseRelayerApiSince(uint256 blockNumber) external;
1104 }
1105 
1106 // Part: IBridgePublic
1107 
1108 /**
1109  * @title Public interface of the Bridge for transferring FET tokens between Ethereum and Fetch Mainnet-v2
1110  *
1111  * @notice Methods of this public interface is allow users to interact with Bridge contract.
1112  */
1113 interface IBridgePublic is IBridgeCommon {
1114 
1115     /**
1116       * @notice Initiates swap, which will be relayed to the other blockchain.
1117       *         Swap might fail, if `destinationAddress` value is invalid (see bellow), in which case the swap will be
1118       *         refunded back to user. Swap fee will be *WITHDRAWN* from `amount` in that case - please see details
1119       *         in desc. for `refund(...)` call.
1120       *
1121       * @dev Swap call will create unique identifier (swap id), which is, by design, sequentially growing by 1 per each
1122       *      new swap created, and so uniquely identifies each swap. This identifier is referred to as "reverse swap id"
1123       *      on the other blockchain.
1124       *      Callable by anyone.
1125       *
1126       * @param destinationAddress - address on **OTHER** blockchain where the swap effective amount will be transferred
1127       *                             in to.
1128       *                             User is **RESPONSIBLE** for providing the **CORRECT** and valid value.
1129       *                             The **CORRECT** means, in this context, that address is valid *AND* user really
1130       *                             intended this particular address value as destination = that address is NOT lets say
1131       *                             copy-paste mistake made by user. Reason being that when user provided valid address
1132       *                             value, but made mistake = address is of someone else (e.g. copy-paste mistake), then
1133       *                             there is **NOTHING** what can be done to recover funds back to user (= refund) once
1134       *                             the swap will be relayed to the other blockchain!
1135       *                             The **VALID** means that provided value successfully passes consistency checks of
1136       *                             valid address of **OTHER** blockchain. In the case when user provides invalid
1137       *                             address value, relayer will execute refund - please see desc. for `refund()` call
1138       *                             for more details.
1139       */
1140     function swap(uint256 amount, string calldata destinationAddress) external;
1141 }
1142 
1143 // Part: IBridgeRelayer
1144 
1145 /**
1146  * @title *Relayer* interface of Bi-directional bridge for transfer of FET tokens between Ethereum
1147  *        and Fetch Mainnet-v2.
1148  *
1149  * @notice By design, all methods of this relayer-level interface can be called exclusively by relayer(s) of
1150  *         the Bridge contract.
1151  *         It is offers set of methods to perform relaying functionality of the Bridge = transferring swaps
1152  *         across chains.
1153  *
1154  * @notice This bridge allows to transfer [ERC20-FET] tokens from Ethereum Mainnet to [Native FET] tokens on Fetch
1155  *         Native Mainnet-v2 and **other way around** (= it is bi-directional).
1156  *         User will be *charged* swap fee defined in counterpart contract deployed on Fetch Native Mainnet-v2.
1157  *         In the case of a refund, user will be charged a swap fee configured in this contract.
1158  *
1159  *         Swap Fees for `swap(...)` operations (direction from this contract to Native Fetch Mainnet-v2 are handled by
1160  *         the counterpart contract on Fetch Native Mainnet-v2, **except** for refunds, for
1161  *         which user is charged swap fee defined by this contract (since relayer needs to send refund transaction back
1162  *         to this contract.
1163  */
1164 interface IBridgeRelayer is IBridgeCommon {
1165 
1166     /**
1167       * @notice Starts the new relay eon.
1168       * @dev Relay eon concept is part of the design in order to ensure safe management of hand-over between two
1169       *      relayer services. It provides clean isolation of potentially still pending transactions from previous
1170       *      relayer svc and the current one.
1171       */
1172     function newRelayEon() external;
1173 
1174 
1175     /**
1176       * @notice Refunds swap previously created by `swap(...)` call to this contract. The `swapFee` is *NOT* refunded
1177       *         back to the user (this is by-design).
1178       *
1179       * @dev Callable exclusively by `relayer` role
1180       *
1181       * @param id - swap id to refund - must be swap id of swap originally created by `swap(...)` call to this contract,
1182       *             **NOT** *reverse* swap id!
1183       * @param to - address where the refund will be transferred in to(IDENTICAL to address used in associated `swap`
1184       *             call)
1185       * @param amount - original amount specified in associated `swap` call = it INCLUDES swap fee, which will be
1186       *                 withdrawn
1187       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1188       */
1189     function refund(uint64 id, address to, uint256 amount, uint64 relayEon_) external;
1190 
1191 
1192     /**
1193       * @notice Refunds swap previously created by `swap(...)` call to this contract, where `swapFee` *IS* refunded
1194       *         back to the user (= swap fee is waived = user will receive full `amount`).
1195       *         Purpose of this method is to enable full refund in the situations when it si not user's fault that
1196       *         swap needs to be refunded (e.g. when Fetch Native Mainnet-v2 will become unavailable for prolonged
1197       *         period of time, etc. ...).
1198       *
1199       * @dev Callable exclusively by `relayer` role
1200       *
1201       * @param id - swap id to refund - must be swap id of swap originally created by `swap(...)` call to this contract,
1202       *             **NOT** *reverse* swap id!
1203       * @param to - address where the refund will be transferred in to(IDENTICAL to address used in associated `swap`
1204       *             call)
1205       * @param amount - original amount specified in associated `swap` call = it INCLUDES swap fee, which will be
1206       *                 waived = user will receive whole `amount` value.
1207       *                 Pleas mind that `amount > 0`, otherways relayer will pay Tx fee for executing the transaction
1208       *                 which will have *NO* effect (= like this function `refundInFull(...)` would *not* have been
1209       *                 called at all!
1210       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1211       */
1212     function refundInFull(uint64 id, address to, uint256 amount, uint64 relayEon_) external;
1213 
1214 
1215     /**
1216       * @notice Finalises swap initiated by counterpart contract on the other blockchain.
1217       *         This call sends swapped tokens to `to` address value user specified in original swap on the **OTHER**
1218       *         blockchain.
1219       *
1220       * @dev Callable exclusively by `relayer` role
1221       *
1222       * @param rid - reverse swap id - unique identifier of the swap initiated on the **OTHER** blockchain.
1223       *              This id is, by definition, sequentially growing number incremented by 1 for each new swap initiated
1224       *              the other blockchain. **However**, it is *NOT* ensured that *all* swaps from the other blockchain
1225       *              will be transferred to this (Ethereum) blockchain, since some of these swaps can be refunded back
1226       *              to users (on the other blockchain).
1227       * @param to - address where the refund will be transferred in to
1228       * @param from - source address from which user transferred tokens from on the other blockchain. Present primarily
1229       *               for purposes of quick querying of events on this blockchain.
1230       * @param originTxHash - transaction hash for swap initiated on the **OTHER** blockchain. Present in order to
1231       *                       create strong bond between this and other blockchain.
1232       * @param amount - original amount specified in associated swap initiated on the other blockchain.
1233       *                 Swap fee is *withdrawn* from the `amount` user specified in the swap on the other blockchain,
1234       *                 what means that user receives `amount - swapFee`, or *nothing* if `amount <= swapFee`.
1235       *                 Pleas mind that `amount > 0`, otherways relayer will pay Tx fee for executing the transaction
1236       *                 which will have *NO* effect (= like this function `refundInFull(...)` would *not* have been
1237       *                 called at all!
1238       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1239       */
1240     function reverseSwap(
1241         uint64 rid,
1242         address to,
1243         string calldata from,
1244         bytes32 originTxHash,
1245         uint256 amount,
1246         uint64 relayEon_
1247         )
1248         external;
1249 }
1250 
1251 // Part: IERC20Token
1252 
1253 interface IERC20Token is IERC20, IERC20MintFacility {}
1254 
1255 // Part: IBridgeAdmin
1256 
1257 /**
1258  * @title *Administrative* interface of Bi-directional bridge for transfer of FET tokens between Ethereum
1259  *        and Fetch Mainnet-v2.
1260  *
1261  * @notice By design, all methods of this administrative interface can be called exclusively by administrator(s) of
1262  *         the Bridge contract, since it allows to configure essential parameters of the the Bridge, and change
1263  *         supply transferred across the Bridge.
1264  */
1265 interface IBridgeAdmin is IBridgeCommon, IBridgeMonitor {
1266 
1267     /**
1268      * @notice Returns amount of excess FET ERC20 tokens which were sent to address of this contract via direct ERC20
1269      *         transfer (by calling ERC20.transfer(...)), without interacting with API of this contract, what can happen
1270      *         only by mistake.
1271      *
1272      * @return targetAddress : address to send tokens to
1273      */
1274     function getFeesAccrued() external view returns(uint256);
1275 
1276 
1277     /**
1278      * @notice Mints provided amount of FET tokens.
1279      *         This is to reflect changes in minted Native FET token supply on the Fetch Native Mainnet-v2 blockchain.
1280      * @param amount - number of FET tokens to mint.
1281      */
1282     function mint(uint256 amount) external;
1283 
1284 
1285     /**
1286      * @notice Burns provided amount of FET tokens.
1287      *         This is to reflect changes in minted Native FET token supply on the Fetch Native Mainnet-v2 blockchain.
1288      * @param amount - number of FET tokens to burn.
1289      */
1290     function burn(uint256 amount) external;
1291 
1292 
1293     /**
1294      * @notice Sets cap (max) value of `supply` this contract can hold = the value of tokens transferred to the other
1295      *         blockchain.
1296      *         This cap affects(limits) all operations which *increase* contract's `supply` value = `swap(...)` and
1297      *         `mint(...)`.
1298      * @param value - new cap value.
1299      */
1300     function setCap(uint256 value) external;
1301 
1302 
1303     /**
1304      * @notice Sets value of `reverseAggregatedAllowance` state variable.
1305      *         This affects(limits) operations which *decrease* contract's `supply` value via **RELAYER** authored
1306      *         operations (= `reverseSwap(...)` and `refund(...)`). It does **NOT** affect **ADMINISTRATION** authored
1307      *         supply decrease operations (= `withdraw(...)` & `burn(...)`).
1308      * @param value - new cap value.
1309      */
1310     function setReverseAggregatedAllowance(uint256 value) external;
1311 
1312     /**
1313      * @notice Sets value of `reverseAggregatedAllowanceCap` state variable.
1314      *         This limits APPROVER_ROLE from top - value up to which can approver rise the allowance.
1315      * @param value - new cap value (absolute)
1316      */
1317     function setReverseAggregatedAllowanceApproverCap(uint256 value) external;
1318 
1319 
1320     /**
1321      * @notice Sets limits for swap amount
1322      *         FUnction will revert if following consitency check fails: `swapfee_ <= swapMin_ <= swapMax_`
1323      * @param swapMax_ : >= swap amount, applies for **OUTGOING** swap (= `swap(...)` call)
1324      * @param swapMin_ : <= swap amount, applies for **OUTGOING** swap (= `swap(...)` call)
1325      * @param swapFee_ : defines swap fee for **INCOMING** swap (= `reverseSwap(...)` call), and `refund(...)`
1326      */
1327     function setLimits(uint256 swapMax_, uint256 swapMin_, uint256 swapFee_) external;
1328 
1329 
1330     /**
1331      * @notice Withdraws amount from contract's supply, which is supposed to be done exclusively for relocating funds to
1332      *       another Bridge system, and **NO** other purpose.
1333      * @param targetAddress : address to send tokens to
1334      * @param amount : amount of tokens to withdraw
1335      */
1336     function withdraw(address targetAddress, uint256 amount) external;
1337 
1338 
1339     /**
1340      * @dev Deposits funds back in to the contract supply.
1341      *      Dedicated to increase contract's supply, usually(but not necessarily) after previous withdrawal from supply.
1342      *      NOTE: This call needs preexisting ERC20 allowance >= `amount` for address of this Bridge contract as
1343      *            recipient/beneficiary and Tx sender address as sender.
1344      *            This means that address passed in as the Tx sender, must have already crated allowance by calling the
1345      *            `ERC20.approve(from, ADDR_OF_BRIDGE_CONTRACT, amount)` *before* calling this(`deposit(...)`) call.
1346      * @param amount : deposit amount
1347      */
1348     function deposit(uint256 amount) external;
1349 
1350 
1351     /**
1352      * @notice Withdraw fees accrued so far.
1353      *         !IMPORTANT!: Current design of this contract does *NOT* allow to distinguish between *swap fees accrued*
1354      *                      and *excess funds* sent to the contract's address via *direct* `ERC20.transfer(...)`.
1355      *                      Implication is that excess funds **are treated** as swap fees.
1356      *                      The only way how to separate these two is off-chain, by replaying events from this and
1357      *                      Fet ERC20 contracts and do the reconciliation.
1358      *
1359      * @param targetAddress : address to send tokens to.
1360      */
1361     function withdrawFees(address targetAddress) external;
1362 
1363 
1364     /**
1365      * @notice Delete the contract, transfers the remaining token and ether balance to the specified
1366      *         payoutAddress
1367      * @param targetAddress address to transfer the balances to. Ensure that this is able to handle ERC20 tokens
1368      * @dev owner only + only on or after `earliestDelete` block
1369      */
1370     function deleteContract(address payable targetAddress) external;
1371 }
1372 
1373 // Part: IBridge
1374 
1375 /**
1376  * @title Bi-directional bridge for transferring FET tokens between Ethereum and Fetch Mainnet-v2
1377  *
1378  * @notice This bridge allows to transfer [ERC20-FET] tokens from Ethereum Mainnet to [Native FET] tokens on Fetch
1379  *         Native Mainnet-v2 and **other way around** (= it is bi-directional).
1380  *         User will be *charged* swap fee defined in counterpart contract deployed on Fetch Native Mainnet-v2.
1381  *         In the case of a refund, user will be charged a swap fee configured in this contract.
1382  *
1383  * @dev There are three primary actions defining business logic of this contract:
1384  *       * `swap(...)`: initiates swap of tokens from Ethereum to Fetch Native Mainnet-v2, callable by anyone (= users)
1385  *       * `reverseSwap(...)`: finalises the swap of tokens in *opposite* direction = receives swap originally
1386  *                             initiated on Fetch Native Mainnet-v2, callable exclusively by `relayer` role
1387  *       * `refund(...)`: refunds swap originally initiated in this contract(by `swap(...)` call), callable exclusively
1388  *                        by `relayer` role
1389  *
1390  *      Swap Fees for `swap(...)` operations (direction from this contract to are handled by the counterpart contract on Fetch Native Mainnet-v2, **except** for refunds, for
1391  *      which user is charged swap fee defined by this contract (since relayer needs to send refund transaction back to
1392  *      this contract.
1393  *
1394  *      ! IMPORTANT !: Current design of this contract does *NOT* allow to distinguish between *swap fees accrued* and
1395  *      *excess funds* sent to the address of this contract via *direct* `ERC20.transfer(...)`.
1396  *      Implication is, that excess funds **are treated** as swap fees.
1397  *      The only way how to separate these two is to do it *off-chain*, by replaying events from this and FET ERC20
1398  *      contracts, and do the reconciliation.
1399  */
1400 interface IBridge is IBridgePublic, IBridgeRelayer, IBridgeAdmin {}
1401 
1402 // File: Bridge.sol
1403 
1404 /**
1405  * @title Bi-directional bridge for transferring FET tokens between Ethereum and Fetch Mainnet-v2
1406  *
1407  * @notice This bridge allows to transfer [ERC20-FET] tokens from Ethereum Mainnet to [Native FET] tokens on Fetch
1408  *         Native Mainnet-v2 and **other way around** (= it is bi-directional).
1409  *         User will be *charged* swap fee defined in counterpart contract deployed on Fetch Native Mainnet-v2.
1410  *         In the case of a refund, user will be charged a swap fee configured in this contract.
1411  *
1412  * @dev There are three primary actions defining business logic of this contract:
1413  *       * `swap(...)`: initiates swap of tokens from Ethereum to Fetch Native Mainnet-v2, callable by anyone (= users)
1414  *       * `reverseSwap(...)`: finalises the swap of tokens in *opposite* direction = receives swap originally
1415  *                             initiated on Fetch Native Mainnet-v2, callable exclusively by `relayer` role
1416  *       * `refund(...)`: refunds swap originally initiated in this contract(by `swap(...)` call), callable exclusively
1417  *                        by `relayer` role
1418  *
1419  *      Swap Fees for `swap(...)` operations (direction from this contract to are handled by the counterpart contract on Fetch Native Mainnet-v2, **except** for refunds, for
1420  *      which user is charged swap fee defined by this contract (since relayer needs to send refund transaction back to
1421  *      this contract.
1422  *
1423  *      ! IMPORTANT !: Current design of this contract does *NOT* allow to distinguish between *swap fees accrued* and
1424  *      *excess funds* sent to the address of this contract via *direct* `ERC20.transfer(...)`.
1425  *      Implication is, that excess funds **are treated** as swap fees.
1426  *      The only way how to separate these two is to do it *off-chain*, by replaying events from this and FET ERC20
1427  *      contracts, and do the reconciliation.
1428  */
1429 contract Bridge is IBridge, AccessControl {
1430     using SafeMath for uint256;
1431 
1432     /// @notice **********    CONSTANTS    ***********
1433     bytes32 public constant APPROVER_ROLE = keccak256("APPROVER_ROLE");
1434     bytes32 public constant MONITOR_ROLE = keccak256("MONITOR_ROLE");
1435     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
1436 
1437     /// @notice *******    IMMUTABLE STATE    ********
1438     IERC20Token public immutable token;
1439     uint256 public immutable earliestDelete;
1440     /// @notice ********    MUTABLE STATE    *********
1441     uint256 public supply;
1442     uint64 public  nextSwapId;
1443     uint64 public  relayEon;
1444     mapping(uint64 => uint256) public refunds; // swapId -> original swap amount(= *includes* swapFee)
1445     uint256 public swapMax;
1446     uint256 public swapMin;
1447     uint256 public cap;
1448     uint256 public swapFee;
1449     uint256 public pausedSinceBlockPublicApi;
1450     uint256 public pausedSinceBlockRelayerApi;
1451     uint256 public reverseAggregatedAllowance;
1452     uint256 public reverseAggregatedAllowanceApproverCap;
1453 
1454 
1455     /* Only callable by owner */
1456     modifier onlyOwner() {
1457         require(_isOwner(), "Only admin role");
1458         _;
1459     }
1460 
1461     modifier onlyRelayer() {
1462         require(hasRole(RELAYER_ROLE, msg.sender), "Only relayer role");
1463         _;
1464     }
1465 
1466     modifier verifyTxRelayEon(uint64 relayEon_) {
1467         require(relayEon == relayEon_, "Tx doesn't belong to current relayEon");
1468         _;
1469     }
1470 
1471     modifier canPause(uint256 pauseSinceBlockNumber) {
1472         if (pauseSinceBlockNumber > block.number) // Checking UN-pausing (the most critical operation)
1473         {
1474             require(_isOwner(), "Only admin role");
1475         }
1476         else
1477         {
1478             require(hasRole(MONITOR_ROLE, msg.sender) || _isOwner(), "Only admin or monitor role");
1479         }
1480         _;
1481     }
1482 
1483     modifier canSetReverseAggregatedAllowance(uint256 allowance) {
1484         if (allowance > reverseAggregatedAllowanceApproverCap) // Check for going over the approver cap (the most critical operation)
1485         {
1486             require(_isOwner(), "Only admin role");
1487         }
1488         else
1489         {
1490             require(hasRole(APPROVER_ROLE, msg.sender) || _isOwner(), "Only admin or approver role");
1491         }
1492         _;
1493     }
1494 
1495     modifier verifyPublicAPINotPaused() {
1496         require(pausedSinceBlockPublicApi > block.number, "Contract has been paused");
1497         _verifyRelayerApiNotPaused();
1498         _;
1499     }
1500 
1501     modifier verifyRelayerApiNotPaused() {
1502         _verifyRelayerApiNotPaused();
1503         _;
1504     }
1505 
1506     modifier verifySwapAmount(uint256 amount) {
1507         // NOTE(pb): Commenting-out check against `swapFee` in order to spare gas for user's Tx, relying solely on check
1508         //  against `swapMin` only, which is ensured to be `>= swapFee` (by `_setLimits(...)` function).
1509         //require(amount > swapFee, "Amount must be higher than fee");
1510         require(amount >= swapMin, "Amount bellow lower limit");
1511         require(amount <= swapMax, "Amount exceeds upper limit");
1512         _;
1513     }
1514 
1515     modifier verifyReverseSwapAmount(uint256 amount) {
1516         require(amount <= swapMax, "Amount exceeds swap max limit");
1517         _;
1518     }
1519 
1520     modifier verifyRefundSwapId(uint64 id) {
1521         require(id < nextSwapId, "Invalid swap id");
1522         require(refunds[id] == 0, "Refund was already processed");
1523         _;
1524     }
1525 
1526 
1527     /*******************
1528     Contract start
1529     *******************/
1530     /**
1531      * @notice Contract constructor
1532      * @dev Input parameters offers full flexibility to configure the contract during deployment, with minimal need of
1533      *      further setup transactions necessary to open contract to the public.
1534      *
1535      * @param ERC20Address - address of FET ERC20 token contract
1536      * @param cap_ - limits contract `supply` value from top
1537      * @param reverseAggregatedAllowance_ - allowance value which limits how much can refund & reverseSwap transfer
1538      *                                      in aggregated form
1539      * @param reverseAggregatedAllowanceApproverCap_ - limits allowance value up to which can APPROVER_ROLE set
1540      *                                                 the allowance
1541      * @param swapMax_ - value representing UPPER limit which can be transferred (this value INCLUDES swapFee)
1542      * @param swapMin_ - value representing LOWER limit which can be transferred (this value INCLUDES swapFee)
1543      * @param swapFee_ - represents fee which user has to pay for swap execution,
1544      * @param pausedSinceBlockPublicApi_ - block number since which the Public API of the contract will be paused
1545      * @param pausedSinceBlockRelayerApi_ - block number since which the Relayer API of the contract will be paused
1546      * @param deleteProtectionPeriod_ - number of blocks(from contract deployment block) during which contract can
1547      *                                  NOT be deleted
1548      */
1549     constructor(
1550           address ERC20Address
1551         , uint256 cap_
1552         , uint256 reverseAggregatedAllowance_
1553         , uint256 reverseAggregatedAllowanceApproverCap_
1554         , uint256 swapMax_
1555         , uint256 swapMin_
1556         , uint256 swapFee_
1557         , uint256 pausedSinceBlockPublicApi_
1558         , uint256 pausedSinceBlockRelayerApi_
1559         , uint256 deleteProtectionPeriod_)
1560     {
1561         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1562         token = IERC20Token(ERC20Address);
1563         earliestDelete = block.number.add(deleteProtectionPeriod_);
1564 
1565         /// @dev Unnecessary initialisations, done implicitly by VM
1566         //supply = 0;
1567         //refundsFeesAccrued = 0;
1568         //nextSwapId = 0;
1569 
1570         // NOTE(pb): Initial value is by design set to MAX_LIMIT<uint64>, so that its NEXT increment(+1) will
1571         //           overflow to 0.
1572         relayEon = type(uint64).max;
1573 
1574         _setCap(cap_);
1575         _setReverseAggregatedAllowance(reverseAggregatedAllowance_);
1576         _setReverseAggregatedAllowanceApproverCap(reverseAggregatedAllowanceApproverCap_);
1577         _setLimits(swapMax_, swapMin_, swapFee_);
1578         _pausePublicApiSince(pausedSinceBlockPublicApi_);
1579         _pauseRelayerApiSince(pausedSinceBlockRelayerApi_);
1580     }
1581 
1582 
1583     // **********************************************************
1584     // ***********    USER-LEVEL ACCESS METHODS    **********
1585 
1586 
1587     /**
1588       * @notice Initiates swap, which will be relayed to the other blockchain.
1589       *         Swap might fail, if `destinationAddress` value is invalid (see bellow), in which case the swap will be
1590       *         refunded back to user. Swap fee will be *WITHDRAWN* from `amount` in that case - please see details
1591       *         in desc. for `refund(...)` call.
1592       *
1593       * @dev Swap call will create unique identifier (swap id), which is, by design, sequentially growing by 1 per each
1594       *      new swap created, and so uniquely identifies each swap. This identifier is referred to as "reverse swap id"
1595       *      on the other blockchain.
1596       *      Callable by anyone.
1597       *
1598       * @param destinationAddress - address on **OTHER** blockchain where the swap effective amount will be transferred
1599       *                             in to.
1600       *                             User is **RESPONSIBLE** for providing the **CORRECT** and valid value.
1601       *                             The **CORRECT** means, in this context, that address is valid *AND* user really
1602       *                             intended this particular address value as destination = that address is NOT lets say
1603       *                             copy-paste mistake made by user. Reason being that when user provided valid address
1604       *                             value, but made mistake = address is of someone else (e.g. copy-paste mistake), then
1605       *                             there is **NOTHING** what can be done to recover funds back to user (= refund) once
1606       *                             the swap will be relayed to the other blockchain!
1607       *                             The **VALID** means that provided value successfully passes consistency checks of
1608       *                             valid address of **OTHER** blockchain. In the case when user provides invalid
1609       *                             address value, relayer will execute refund - please see desc. for `refund()` call
1610       *                             for more details.
1611       */
1612     function swap(
1613         uint256 amount, // This is original amount (INCLUDES fee)
1614         string calldata destinationAddress
1615         )
1616         external
1617         override
1618         verifyPublicAPINotPaused
1619         verifySwapAmount(amount)
1620     {
1621         supply = supply.add(amount);
1622         require(cap >= supply, "Swap would exceed cap");
1623         token.transferFrom(msg.sender, address(this), amount);
1624         emit Swap(nextSwapId, msg.sender, destinationAddress, destinationAddress, amount);
1625         // NOTE(pb): No necessity to use SafeMath here:
1626         nextSwapId += 1;
1627     }
1628 
1629 
1630     /**
1631      * @notice Returns amount of excess FET ERC20 tokens which were sent to address of this contract via direct ERC20
1632      *         transfer (by calling ERC20.transfer(...)), without interacting with API of this contract, what can happen
1633      *         only by mistake.
1634      *
1635      * @return targetAddress : address to send tokens to
1636      */
1637     function getFeesAccrued() external view override returns(uint256) {
1638         // NOTE(pb): This subtraction shall NEVER fail:
1639         return token.balanceOf(address(this)).sub(supply, "Critical err: balance < supply");
1640     }
1641 
1642     function getApproverRole() external view override returns(bytes32) {return APPROVER_ROLE;}
1643     function getMonitorRole() external view override returns(bytes32) {return MONITOR_ROLE;}
1644     function getRelayerRole() external view override returns(bytes32) {return RELAYER_ROLE;}
1645 
1646     function getToken() external view override returns(address) {return address(token);}
1647     function getEarliestDelete() external view override returns(uint256) {return earliestDelete;}
1648     function getSupply() external view override returns(uint256) {return supply;}
1649     function getNextSwapId() external view override returns(uint64) {return nextSwapId;}
1650     function getRelayEon() external view override returns(uint64) {return relayEon;}
1651     function getRefund(uint64 swap_id) external view override returns(uint256) {return refunds[swap_id];}
1652     function getSwapMax() external view override returns(uint256) {return swapMax;}
1653     function getSwapMin() external view override returns(uint256) {return swapMin;}
1654     function getCap() external view override returns(uint256) {return cap;}
1655     function getSwapFee() external view override returns(uint256) {return swapFee;}
1656     function getPausedSinceBlockPublicApi() external view override returns(uint256) {return pausedSinceBlockPublicApi;}
1657     function getPausedSinceBlockRelayerApi() external view override returns(uint256) {return pausedSinceBlockRelayerApi;}
1658     function getReverseAggregatedAllowance() external view override returns(uint256) {return reverseAggregatedAllowance;}
1659     function getReverseAggregatedAllowanceApproverCap() external view override returns(uint256) {return reverseAggregatedAllowanceApproverCap;}
1660 
1661 
1662     // **********************************************************
1663     // ***********    RELAYER-LEVEL ACCESS METHODS    ***********
1664 
1665 
1666     /**
1667       * @notice Starts the new relay eon.
1668       * @dev Relay eon concept is part of the design in order to ensure safe management of hand-over between two
1669       *      relayer services. It provides clean isolation of potentially still pending transactions from previous
1670       *      relayer svc and the current one.
1671       */
1672     function newRelayEon()
1673         external
1674         override
1675         verifyRelayerApiNotPaused
1676         onlyRelayer
1677     {
1678         // NOTE(pb): No need for safe math for this increment, since the MAX_LIMIT<uint64> is huge number (~10^19),
1679         //  there is no way that +1 incrementing from initial 0 value can possibly cause overflow in real world - that
1680         //  would require to send more than 10^19 transactions to reach that point.
1681         //  The only case, where this increment operation will lead to overflow, by-design, is the **VERY 1st**
1682         //  increment = very 1st call of this contract method, when the `relayEon` is by-design & intentionally
1683         //  initialised to MAX_LIMIT<uint64> value, so the resulting value of the `relayEon` after increment will be `0`
1684         relayEon += 1;
1685         emit NewRelayEon(relayEon);
1686     }
1687 
1688 
1689     /**
1690       * @notice Refunds swap previously created by `swap(...)` call to this contract. The `swapFee` is *NOT* refunded
1691       *         back to the user (this is by-design).
1692       *
1693       * @dev Callable exclusively by `relayer` role
1694       *
1695       * @param id - swap id to refund - must be swap id of swap originally created by `swap(...)` call to this contract,
1696       *             **NOT** *reverse* swap id!
1697       * @param to - address where the refund will be transferred in to(IDENTICAL to address used in associated `swap`
1698       *             call)
1699       * @param amount - original amount specified in associated `swap` call = it INCLUDES swap fee, which will be
1700       *                 withdrawn
1701       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1702       */
1703     function refund(
1704         uint64 id,
1705         address to,
1706         uint256 amount,
1707         uint64 relayEon_
1708         )
1709         external
1710         override
1711         verifyRelayerApiNotPaused
1712         verifyTxRelayEon(relayEon_)
1713         verifyReverseSwapAmount(amount)
1714         onlyRelayer
1715         verifyRefundSwapId(id)
1716     {
1717         // NOTE(pb): Fail as early as possible - withdrawal from aggregated allowance is most likely to fail comparing
1718         //  to rest of the operations bellow.
1719         _updateReverseAggregatedAllowance(amount);
1720 
1721         supply = supply.sub(amount, "Amount exceeds contract supply");
1722 
1723         // NOTE(pb): Same calls are repeated in both branches of the if-else in order to minimise gas impact, comparing
1724         //  to implementation, where these calls would be present in the code just once, after if-else block.
1725         if (amount > swapFee) {
1726             // NOTE(pb): No need to use safe math here, the overflow is prevented by `if` condition above.
1727             uint256 effectiveAmount = amount - swapFee;
1728             token.transfer(to, effectiveAmount);
1729             emit SwapRefund(id, to, effectiveAmount, swapFee);
1730         } else {
1731             // NOTE(pb): No transfer necessary in this case, since whole amount is taken as swap fee.
1732             emit SwapRefund(id, to, 0, amount);
1733         }
1734 
1735         // NOTE(pb): Here we need to record the original `amount` value (passed as input param) rather than
1736         //  `effectiveAmount` in order to make sure, that the value is **NOT** zero (so it is possible to detect
1737         //  existence of key-value record in the `refunds` mapping (this is done in the `verifyRefundSwapId(...)`
1738         //  modifier). This also means that relayer role shall call this `refund(...)` function only for `amount > 0`,
1739         //  otherways relayer will pay Tx fee for executing the transaction which will have *NO* effect.
1740         refunds[id] = amount;
1741     }
1742 
1743 
1744     /**
1745       * @notice Refunds swap previously created by `swap(...)` call to this contract, where `swapFee` *IS* refunded
1746       *         back to the user (= swap fee is waived = user will receive full `amount`).
1747       *         Purpose of this method is to enable full refund in the situations when it si not user's fault that
1748       *         swap needs to be refunded (e.g. when Fetch Native Mainnet-v2 will become unavailable for prolonged
1749       *         period of time, etc. ...).
1750       *
1751       * @dev Callable exclusively by `relayer` role
1752       *
1753       * @param id - swap id to refund - must be swap id of swap originally created by `swap(...)` call to this contract,
1754       *             **NOT** *reverse* swap id!
1755       * @param to - address where the refund will be transferred in to(IDENTICAL to address used in associated `swap`
1756       *             call)
1757       * @param amount - original amount specified in associated `swap` call = it INCLUDES swap fee, which will be
1758       *                 waived = user will receive whole `amount` value.
1759       *                 Pleas mind that `amount > 0`, otherways relayer will pay Tx fee for executing the transaction
1760       *                 which will have *NO* effect (= like this function `refundInFull(...)` would *not* have been
1761       *                 called at all!
1762       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1763       */
1764     function refundInFull(
1765         uint64 id,
1766         address to,
1767         uint256 amount,
1768         uint64 relayEon_
1769         )
1770         external
1771         override
1772         verifyRelayerApiNotPaused
1773         verifyTxRelayEon(relayEon_)
1774         verifyReverseSwapAmount(amount)
1775         onlyRelayer
1776         verifyRefundSwapId(id)
1777     {
1778         // NOTE(pb): Fail as early as possible - withdrawal from aggregated allowance is most likely to fail comparing
1779         //  to rest of the operations bellow.
1780         _updateReverseAggregatedAllowance(amount);
1781 
1782         supply = supply.sub(amount, "Amount exceeds contract supply");
1783 
1784         token.transfer(to, amount);
1785         emit SwapRefund(id, to, amount, 0);
1786 
1787         // NOTE(pb): Here we need to record the original `amount` value (passed as input param) rather than
1788         //  `effectiveAmount` in order to make sure, that the value is **NOT** zero (so it is possible to detect
1789         //  existence of key-value record in the `refunds` mapping (this is done in the `verifyRefundSwapId(...)`
1790         //  modifier). This also means that relayer role shall call this function function only for `amount > 0`,
1791         //  otherways relayer will pay Tx fee for executing the transaction which will have *NO* effect.
1792         refunds[id] = amount;
1793     }
1794 
1795 
1796     /**
1797       * @notice Finalises swap initiated by counterpart contract on the other blockchain.
1798       *         This call sends swapped tokens to `to` address value user specified in original swap on the **OTHER**
1799       *         blockchain.
1800       *
1801       * @dev Callable exclusively by `relayer` role
1802       *
1803       * @param rid - reverse swap id - unique identifier of the swap initiated on the **OTHER** blockchain.
1804       *              This id is, by definition, sequentially growing number incremented by 1 for each new swap initiated
1805       *              the other blockchain. **However**, it is *NOT* ensured that *all* swaps from the other blockchain
1806       *              will be transferred to this (Ethereum) blockchain, since some of these swaps can be refunded back
1807       *              to users (on the other blockchain).
1808       * @param to - address where the refund will be transferred in to
1809       * @param from - source address from which user transferred tokens from on the other blockchain. Present primarily
1810       *               for purposes of quick querying of events on this blockchain.
1811       * @param originTxHash - transaction hash for swap initiated on the **OTHER** blockchain. Present in order to
1812       *                       create strong bond between this and other blockchain.
1813       * @param amount - original amount specified in associated swap initiated on the other blockchain.
1814       *                 Swap fee is *withdrawn* from the `amount` user specified in the swap on the other blockchain,
1815       *                 what means that user receives `amount - swapFee`, or *nothing* if `amount <= swapFee`.
1816       *                 Pleas mind that `amount > 0`, otherways relayer will pay Tx fee for executing the transaction
1817       *                 which will have *NO* effect (= like this function `refundInFull(...)` would *not* have been
1818       *                 called at all!
1819       * @param relayEon_ - current relay eon, ensures safe management of relaying process
1820       */
1821     function reverseSwap(
1822         uint64 rid, // Reverse swp id (from counterpart contract on other blockchain)
1823         address to,
1824         string calldata from,
1825         bytes32 originTxHash,
1826         uint256 amount, // This is original swap amount (= *includes* swapFee)
1827         uint64 relayEon_
1828         )
1829         external
1830         override
1831         verifyRelayerApiNotPaused
1832         verifyTxRelayEon(relayEon_)
1833         verifyReverseSwapAmount(amount)
1834         onlyRelayer
1835     {
1836         // NOTE(pb): Fail as early as possible - withdrawal from aggregated allowance is most likely to fail comparing
1837         //  to rest of the operations bellow.
1838         _updateReverseAggregatedAllowance(amount);
1839 
1840         supply = supply.sub(amount, "Amount exceeds contract supply");
1841 
1842         if (amount > swapFee) {
1843             // NOTE(pb): No need to use safe math here, the overflow is prevented by `if` condition above.
1844             uint256 effectiveAmount = amount - swapFee;
1845             token.transfer(to, effectiveAmount);
1846             emit ReverseSwap(rid, to, from, originTxHash, effectiveAmount, swapFee);
1847         } else {
1848             // NOTE(pb): No transfer, no contract supply change since whole amount is taken as swap fee.
1849             emit ReverseSwap(rid, to, from, originTxHash, 0, amount);
1850         }
1851     }
1852 
1853 
1854     // **********************************************************
1855     // ****   MONITOR/ADMIN-LEVEL ACCESS METHODS   *****
1856 
1857 
1858     /**
1859      * @notice Pauses Public API since the specified block number
1860      * @param blockNumber block number since which public interaction will be paused (for all
1861      *        block.number >= blockNumber).
1862      * @dev Delegate only
1863      *      If `blocknumber < block.number`, then contract will be paused immediately = from `block.number`.
1864      */
1865     function pausePublicApiSince(uint256 blockNumber)
1866         external
1867         override
1868         canPause(blockNumber)
1869     {
1870         _pausePublicApiSince(blockNumber);
1871     }
1872 
1873 
1874     /**
1875      * @notice Pauses Relayer API since the specified block number
1876      * @param blockNumber block number since which Relayer API interaction will be paused (for all
1877      *        block.number >= blockNumber).
1878      * @dev Delegate only
1879      *      If `blocknumber < block.number`, then contract will be paused immediately = from `block.number`.
1880      */
1881     function pauseRelayerApiSince(uint256 blockNumber)
1882         external
1883         override
1884         canPause(blockNumber)
1885     {
1886         _pauseRelayerApiSince(blockNumber);
1887     }
1888 
1889 
1890     // **********************************************************
1891     // ************    ADMIN-LEVEL ACCESS METHODS   *************
1892 
1893 
1894     /**
1895      * @notice Mints provided amount of FET tokens.
1896      *         This is to reflect changes in minted Native FET token supply on the Fetch Native Mainnet-v2 blockchain.
1897      * @param amount - number of FET tokens to mint.
1898      */
1899     function mint(uint256 amount)
1900         external
1901         override
1902         onlyOwner
1903     {
1904         // NOTE(pb): The `supply` shall be adjusted by minted amount.
1905         supply = supply.add(amount);
1906         require(cap >= supply, "Minting would exceed the cap");
1907         token.mint(address(this), amount);
1908     }
1909 
1910     /**
1911      * @notice Burns provided amount of FET tokens.
1912      *         This is to reflect changes in minted Native FET token supply on the Fetch Native Mainnet-v2 blockchain.
1913      * @param amount - number of FET tokens to burn.
1914      */
1915     function burn(uint256 amount)
1916         external
1917         override
1918         onlyOwner
1919     {
1920         // NOTE(pb): The `supply` shall be adjusted by burned amount.
1921         supply = supply.sub(amount, "Amount exceeds contract supply");
1922         token.burn(amount);
1923     }
1924 
1925 
1926     /**
1927      * @notice Sets cap (max) value of `supply` this contract can hold = the value of tokens transferred to the other
1928      *         blockchain.
1929      *         This cap affects(limits) all operations which *increase* contract's `supply` value = `swap(...)` and
1930      *         `mint(...)`.
1931      * @param value - new cap value.
1932      */
1933     function setCap(uint256 value)
1934         external
1935         override
1936         onlyOwner
1937     {
1938         _setCap(value);
1939     }
1940 
1941 
1942     /**
1943      * @notice Sets value of `reverseAggregatedAllowance` state variable.
1944      *         This affects(limits) operations which *decrease* contract's `supply` value via **RELAYER** authored
1945      *         operations (= `reverseSwap(...)` and `refund(...)`). It does **NOT** affect **ADMINISTRATION** authored
1946      *         supply decrease operations (= `withdraw(...)` & `burn(...)`).
1947      * @param value - new allowance value (absolute)
1948      */
1949     function setReverseAggregatedAllowance(uint256 value)
1950         external
1951         override
1952         canSetReverseAggregatedAllowance(value)
1953     {
1954         _setReverseAggregatedAllowance(value);
1955     }
1956 
1957 
1958     /**
1959      * @notice Sets value of `reverseAggregatedAllowanceApproverCap` state variable.
1960      *         This limits APPROVER_ROLE from top - value up to which can approver rise the allowance.
1961      * @param value - new cap value (absolute)
1962      */
1963     function setReverseAggregatedAllowanceApproverCap(uint256 value)
1964         external
1965         override
1966         onlyOwner
1967     {
1968         _setReverseAggregatedAllowanceApproverCap(value);
1969     }
1970 
1971 
1972     /**
1973      * @notice Sets limits for swap amount
1974      *         FUnction will revert if following consitency check fails: `swapfee_ <= swapMin_ <= swapMax_`
1975      * @param swapMax_ : >= swap amount, applies for **OUTGOING** swap (= `swap(...)` call)
1976      * @param swapMin_ : <= swap amount, applies for **OUTGOING** swap (= `swap(...)` call)
1977      * @param swapFee_ : defines swap fee for **INCOMING** swap (= `reverseSwap(...)` call), and `refund(...)`
1978      */
1979     function setLimits(
1980         uint256 swapMax_,
1981         uint256 swapMin_,
1982         uint256 swapFee_
1983         )
1984         external
1985         override
1986         onlyOwner
1987     {
1988         _setLimits(swapMax_, swapMin_, swapFee_);
1989     }
1990 
1991 
1992     /**
1993      * @notice Withdraws amount from contract's supply, which is supposed to be done exclusively for relocating funds to
1994      *       another Bridge system, and **NO** other purpose.
1995      * @param targetAddress : address to send tokens to
1996      * @param amount : amount of tokens to withdraw
1997      */
1998     function withdraw(
1999         address targetAddress,
2000         uint256 amount
2001         )
2002         external
2003         override
2004         onlyOwner
2005     {
2006         supply = supply.sub(amount, "Amount exceeds contract supply");
2007         token.transfer(targetAddress, amount);
2008         emit Withdraw(targetAddress, amount);
2009     }
2010 
2011 
2012     /**
2013      * @dev Deposits funds back in to the contract supply.
2014      *      Dedicated to increase contract's supply, usually(but not necessarily) after previous withdrawal from supply.
2015      *      NOTE: This call needs preexisting ERC20 allowance >= `amount` for address of this Bridge contract as
2016      *            recipient/beneficiary and Tx sender address as sender.
2017      *            This means that address passed in as the Tx sender, must have already crated allowance by calling the
2018      *            `ERC20.approve(from, ADDR_OF_BRIDGE_CONTRACT, amount)` *before* calling this(`deposit(...)`) call.
2019      * @param amount : deposit amount
2020      */
2021     function deposit(uint256 amount)
2022         external
2023         override
2024         onlyOwner
2025     {
2026         supply = supply.add(amount);
2027         require(cap >= supply, "Deposit would exceed the cap");
2028         token.transferFrom(msg.sender, address(this), amount);
2029         emit Deposit(msg.sender, amount);
2030     }
2031 
2032 
2033     /**
2034      * @notice Withdraw fees accrued so far.
2035      *         !IMPORTANT!: Current design of this contract does *NOT* allow to distinguish between *swap fees accrued*
2036      *                      and *excess funds* sent to the contract's address via *direct* `ERC20.transfer(...)`.
2037      *                      Implication is that excess funds **are treated** as swap fees.
2038      *                      The only way how to separate these two is off-chain, by replaying events from this and
2039      *                      Fet ERC20 contracts and do the reconciliation.
2040      *
2041      * @param targetAddress : address to send tokens to.
2042      */
2043     function withdrawFees(address targetAddress)
2044         external
2045         override
2046         onlyOwner
2047     {
2048         uint256 fees = this.getFeesAccrued();
2049         require(fees > 0, "No fees to withdraw");
2050         token.transfer(targetAddress, fees);
2051         emit FeesWithdrawal(targetAddress, fees);
2052     }
2053 
2054 
2055     /**
2056      * @notice Delete the contract, transfers the remaining token and ether balance to the specified
2057      *         payoutAddress
2058      * @param targetAddress address to transfer the balances to. Ensure that this is able to handle ERC20 tokens
2059      * @dev owner only + only on or after `earliestDelete` block
2060      */
2061     function deleteContract(address payable targetAddress)
2062         external
2063         override
2064         onlyOwner
2065     {
2066         require(earliestDelete <= block.number, "Earliest delete not reached");
2067         require(targetAddress != address(this), "pay addr == this contract addr");
2068         uint256 contractBalance = token.balanceOf(address(this));
2069         token.transfer(targetAddress, contractBalance);
2070         emit DeleteContract(targetAddress, contractBalance);
2071         selfdestruct(targetAddress);
2072     }
2073 
2074 
2075     // **********************************************************
2076     // ******************    INTERNAL METHODS   *****************
2077 
2078 
2079     function _isOwner() internal view returns(bool) {
2080         return hasRole(DEFAULT_ADMIN_ROLE, msg.sender);
2081     }
2082 
2083     function _verifyRelayerApiNotPaused() internal view {
2084         require(pausedSinceBlockRelayerApi > block.number, "Contract has been paused");
2085     }
2086 
2087     /**
2088      * @notice Pauses Public API since the specified block number
2089      * @param blockNumber - block number since which interaction with Public API will be paused (for all
2090      *                      block.number >= blockNumber)
2091      */
2092     function _pausePublicApiSince(uint256 blockNumber) internal
2093     {
2094         pausedSinceBlockPublicApi = blockNumber < block.number ? block.number : blockNumber;
2095         emit PausePublicApi(pausedSinceBlockPublicApi);
2096     }
2097 
2098 
2099     /**
2100      * @notice Pauses Relayer API since the specified block number
2101      * @param blockNumber - block number since which interaction with Relayer API will be paused (for all
2102      *                      block.number >= blockNumber)
2103      */
2104     function _pauseRelayerApiSince(uint256 blockNumber) internal
2105     {
2106         pausedSinceBlockRelayerApi = blockNumber < block.number ? block.number : blockNumber;
2107         emit PauseRelayerApi(pausedSinceBlockRelayerApi);
2108     }
2109 
2110 
2111     function _setLimits(
2112         uint256 swapMax_,
2113         uint256 swapMin_,
2114         uint256 swapFee_
2115         )
2116         internal
2117     {
2118         require((swapFee_ <= swapMin_) && (swapMin_ <= swapMax_), "fee<=lower<=upper violated");
2119 
2120         swapMax = swapMax_;
2121         swapMin = swapMin_;
2122         swapFee = swapFee_;
2123 
2124         emit LimitsUpdate(swapMax, swapMin, swapFee);
2125     }
2126 
2127 
2128     function _setCap(uint256 cap_) internal
2129     {
2130         cap = cap_;
2131         emit CapUpdate(cap);
2132     }
2133 
2134 
2135     function _setReverseAggregatedAllowance(uint256 allowance) internal
2136     {
2137         reverseAggregatedAllowance = allowance;
2138         emit ReverseAggregatedAllowanceUpdate(reverseAggregatedAllowance);
2139     }
2140 
2141 
2142     function _setReverseAggregatedAllowanceApproverCap(uint256 value) internal
2143     {
2144         reverseAggregatedAllowanceApproverCap = value;
2145         emit ReverseAggregatedAllowanceApproverCapUpdate(reverseAggregatedAllowanceApproverCap);
2146     }
2147 
2148 
2149     function _updateReverseAggregatedAllowance(uint256 amount) internal {
2150         reverseAggregatedAllowance = reverseAggregatedAllowance.sub(amount, "Operation exceeds reverse aggregated allowance");
2151     }
2152 }
