1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
3 
4 interface IERC20Permit {
5     /**
6      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
7      * given ``owner``'s signed approval.
8      *
9      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
10      * ordering also apply here.
11      *
12      * Emits an {Approval} event.
13      *
14      * Requirements:
15      *
16      * - `spender` cannot be the zero address.
17      * - `deadline` must be a timestamp in the future.
18      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
19      * over the EIP712-formatted function arguments.
20      * - the signature must use ``owner``'s current nonce (see {nonces}).
21      *
22      * For more information on the signature format, see the
23      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
24      * section].
25      */
26     function permit(
27         address owner,
28         address spender,
29         uint256 value,
30         uint256 deadline,
31         uint8 v,
32         bytes32 r,
33         bytes32 s
34     ) external;
35 
36     /**
37      * @dev Returns the current nonce for `owner`. This value must be
38      * included whenever a signature is generated for {permit}.
39      *
40      * Every successful call to {permit} increases ``owner``'s nonce by one. This
41      * prevents a signature from being used multiple times.
42      */
43     function nonces(address owner) external view returns (uint256);
44 
45     /**
46      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
47      */
48     // solhint-disable-next-line func-name-mixedcase
49     function DOMAIN_SEPARATOR() external view returns (bytes32);
50 }
51 //  MIT
52 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
53 
54 pragma solidity ^0.8.1;
55 
56 /**
57  * @dev Collection of functions related to the address type
58  */
59 library Address {
60     /**
61      * @dev Returns true if `account` is a contract.
62      *
63      * [IMPORTANT]
64      * ====
65      * It is unsafe to assume that an address for which this function returns
66      * false is an externally-owned account (EOA) and not a contract.
67      *
68      * Among others, `isContract` will return false for the following
69      * types of addresses:
70      *
71      *  - an externally-owned account
72      *  - a contract in construction
73      *  - an address where a contract will be created
74      *  - an address where a contract lived, but was destroyed
75      * ====
76      *
77      * [IMPORTANT]
78      * ====
79      * You shouldn't rely on `isContract` to protect against flash loan attacks!
80      *
81      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
82      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
83      * constructor.
84      * ====
85      */
86     function isContract(address account) internal view returns (bool) {
87         // This method relies on extcodesize/address.code.length, which returns 0
88         // for contracts in construction, since the code is only stored at the end
89         // of the constructor execution.
90 
91         return account.code.length > 0;
92     }
93 
94     /**
95      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
96      * `recipient`, forwarding all available gas and reverting on errors.
97      *
98      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
99      * of certain opcodes, possibly making contracts go over the 2300 gas limit
100      * imposed by `transfer`, making them unable to receive funds via
101      * `transfer`. {sendValue} removes this limitation.
102      *
103      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
104      *
105      * IMPORTANT: because control is transferred to `recipient`, care must be
106      * taken to not create reentrancy vulnerabilities. Consider using
107      * {ReentrancyGuard} or the
108      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
109      */
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         (bool success, ) = recipient.call{value: amount}("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     /**
118      * @dev Performs a Solidity function call using a low level `call`. A
119      * plain `call` is an unsafe replacement for a function call: use this
120      * function instead.
121      *
122      * If `target` reverts with a revert reason, it is bubbled up by this
123      * function (like regular Solidity function calls).
124      *
125      * Returns the raw returned data. To convert to the expected return value,
126      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
127      *
128      * Requirements:
129      *
130      * - `target` must be a contract.
131      * - calling `target` with `data` must not revert.
132      *
133      * _Available since v3.1._
134      */
135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
141      * `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(
146         address target,
147         bytes memory data,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         return functionCallWithValue(target, data, 0, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but also transferring `value` wei to `target`.
156      *
157      * Requirements:
158      *
159      * - the calling contract must have an ETH balance of at least `value`.
160      * - the called Solidity function must be `payable`.
161      *
162      * _Available since v3.1._
163      */
164     function functionCallWithValue(
165         address target,
166         bytes memory data,
167         uint256 value
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
174      * with `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         (bool success, bytes memory returndata) = target.call{value: value}(data);
186         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         return functionStaticCall(target, data, "Address: low-level static call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         (bool success, bytes memory returndata) = target.staticcall(data);
211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a delegate call.
217      *
218      * _Available since v3.4._
219      */
220     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         (bool success, bytes memory returndata) = target.delegatecall(data);
236         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
241      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
242      *
243      * _Available since v4.8._
244      */
245     function verifyCallResultFromTarget(
246         address target,
247         bool success,
248         bytes memory returndata,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         if (success) {
252             if (returndata.length == 0) {
253                 // only check isContract if the call was successful and the return data is empty
254                 // otherwise we already know that it was a contract
255                 require(isContract(target), "Address: call to non-contract");
256             }
257             return returndata;
258         } else {
259             _revert(returndata, errorMessage);
260         }
261     }
262 
263     /**
264      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason or using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             _revert(returndata, errorMessage);
278         }
279     }
280 
281     function _revert(bytes memory returndata, string memory errorMessage) private pure {
282         // Look for revert reason and bubble it up if present
283         if (returndata.length > 0) {
284             // The easiest way to bubble the revert reason is using memory via assembly
285             /// @solidity memory-safe-assembly
286             assembly {
287                 let returndata_size := mload(returndata)
288                 revert(add(32, returndata), returndata_size)
289             }
290         } else {
291             revert(errorMessage);
292         }
293     }
294 }
295 
296 /**
297  * @title SafeERC20
298  * @dev Wrappers around ERC20 operations that throw on failure (when the token
299  * contract returns false). Tokens that return no value (and instead revert or
300  * throw on failure) are also supported, non-reverting calls are assumed to be
301  * successful.
302  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
303  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
304  */
305 library SafeERC20 {
306     using Address for address;
307 
308     function safeTransfer(
309         IERC20 token,
310         address to,
311         uint256 value
312     ) internal {
313         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
314     }
315 
316     function safeTransferFrom(
317         IERC20 token,
318         address from,
319         address to,
320         uint256 value
321     ) internal {
322         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
323     }
324 
325     /**
326      * @dev Deprecated. This function has issues similar to the ones found in
327      * {IERC20-approve}, and its usage is discouraged.
328      *
329      * Whenever possible, use {safeIncreaseAllowance} and
330      * {safeDecreaseAllowance} instead.
331      */
332     function safeApprove(
333         IERC20 token,
334         address spender,
335         uint256 value
336     ) internal {
337         // safeApprove should only be called when setting an initial allowance,
338         // or when resetting it to zero. To increase and decrease it, use
339         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
340         require(
341             (value == 0) || (token.allowance(address(this), spender) == 0),
342             "SafeERC20: approve from non-zero to non-zero allowance"
343         );
344         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
345     }
346 
347     function safeIncreaseAllowance(
348         IERC20 token,
349         address spender,
350         uint256 value
351     ) internal {
352         uint256 newAllowance = token.allowance(address(this), spender) + value;
353         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(
357         IERC20 token,
358         address spender,
359         uint256 value
360     ) internal {
361         unchecked {
362             uint256 oldAllowance = token.allowance(address(this), spender);
363             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
364             uint256 newAllowance = oldAllowance - value;
365             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
366         }
367     }
368 
369     function safePermit(
370         IERC20Permit token,
371         address owner,
372         address spender,
373         uint256 value,
374         uint256 deadline,
375         uint8 v,
376         bytes32 r,
377         bytes32 s
378     ) internal {
379         uint256 nonceBefore = token.nonces(owner);
380         token.permit(owner, spender, value, deadline, v, r, s);
381         uint256 nonceAfter = token.nonces(owner);
382         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
383     }
384 
385     /**
386      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
387      * on the return value: the return value is optional (but if data is returned, it must not be false).
388      * @param token The token targeted by the call.
389      * @param data The call data (encoded using abi.encode or one of its variants).
390      */
391     function _callOptionalReturn(IERC20 token, bytes memory data) private {
392         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
393         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
394         // the target address contains contract code and also asserts for success in the low-level call.
395 
396         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
397         if (returndata.length > 0) {
398             // Return data is optional
399             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
400         }
401     }
402 }
403 //  MIT
404 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
405 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Library for managing
411  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
412  * types.
413  *
414  * Sets have the following properties:
415  *
416  * - Elements are added, removed, and checked for existence in constant time
417  * (O(1)).
418  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
419  *
420  * ```
421  * contract Example {
422  *     // Add the library methods
423  *     using EnumerableSet for EnumerableSet.AddressSet;
424  *
425  *     // Declare a set state variable
426  *     EnumerableSet.AddressSet private mySet;
427  * }
428  * ```
429  *
430  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
431  * and `uint256` (`UintSet`) are supported.
432  *
433  * [WARNING]
434  * ====
435  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
436  * unusable.
437  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
438  *
439  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
440  * array of EnumerableSet.
441  * ====
442  */
443 library EnumerableSet {
444     // To implement this library for multiple types with as little code
445     // repetition as possible, we write it in terms of a generic Set type with
446     // bytes32 values.
447     // The Set implementation uses private functions, and user-facing
448     // implementations (such as AddressSet) are just wrappers around the
449     // underlying Set.
450     // This means that we can only create new EnumerableSets for types that fit
451     // in bytes32.
452 
453     struct Set {
454         // Storage of set values
455         bytes32[] _values;
456         // Position of the value in the `values` array, plus 1 because index 0
457         // means a value is not in the set.
458         mapping(bytes32 => uint256) _indexes;
459     }
460 
461     /**
462      * @dev Add a value to a set. O(1).
463      *
464      * Returns true if the value was added to the set, that is if it was not
465      * already present.
466      */
467     function _add(Set storage set, bytes32 value) private returns (bool) {
468         if (!_contains(set, value)) {
469             set._values.push(value);
470             // The value is stored at length-1, but we add 1 to all indexes
471             // and use 0 as a sentinel value
472             set._indexes[value] = set._values.length;
473             return true;
474         } else {
475             return false;
476         }
477     }
478 
479     /**
480      * @dev Removes a value from a set. O(1).
481      *
482      * Returns true if the value was removed from the set, that is if it was
483      * present.
484      */
485     function _remove(Set storage set, bytes32 value) private returns (bool) {
486         // We read and store the value's index to prevent multiple reads from the same storage slot
487         uint256 valueIndex = set._indexes[value];
488 
489         if (valueIndex != 0) {
490             // Equivalent to contains(set, value)
491             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
492             // the array, and then remove the last element (sometimes called as 'swap and pop').
493             // This modifies the order of the array, as noted in {at}.
494 
495             uint256 toDeleteIndex = valueIndex - 1;
496             uint256 lastIndex = set._values.length - 1;
497 
498             if (lastIndex != toDeleteIndex) {
499                 bytes32 lastValue = set._values[lastIndex];
500 
501                 // Move the last value to the index where the value to delete is
502                 set._values[toDeleteIndex] = lastValue;
503                 // Update the index for the moved value
504                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
505             }
506 
507             // Delete the slot where the moved value was stored
508             set._values.pop();
509 
510             // Delete the index for the deleted slot
511             delete set._indexes[value];
512 
513             return true;
514         } else {
515             return false;
516         }
517     }
518 
519     /**
520      * @dev Returns true if the value is in the set. O(1).
521      */
522     function _contains(Set storage set, bytes32 value) private view returns (bool) {
523         return set._indexes[value] != 0;
524     }
525 
526     /**
527      * @dev Returns the number of values on the set. O(1).
528      */
529     function _length(Set storage set) private view returns (uint256) {
530         return set._values.length;
531     }
532 
533     /**
534      * @dev Returns the value stored at position `index` in the set. O(1).
535      *
536      * Note that there are no guarantees on the ordering of values inside the
537      * array, and it may change when more values are added or removed.
538      *
539      * Requirements:
540      *
541      * - `index` must be strictly less than {length}.
542      */
543     function _at(Set storage set, uint256 index) private view returns (bytes32) {
544         return set._values[index];
545     }
546 
547     /**
548      * @dev Return the entire set in an array
549      *
550      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
551      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
552      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
553      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
554      */
555     function _values(Set storage set) private view returns (bytes32[] memory) {
556         return set._values;
557     }
558 
559     // Bytes32Set
560 
561     struct Bytes32Set {
562         Set _inner;
563     }
564 
565     /**
566      * @dev Add a value to a set. O(1).
567      *
568      * Returns true if the value was added to the set, that is if it was not
569      * already present.
570      */
571     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
572         return _add(set._inner, value);
573     }
574 
575     /**
576      * @dev Removes a value from a set. O(1).
577      *
578      * Returns true if the value was removed from the set, that is if it was
579      * present.
580      */
581     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
582         return _remove(set._inner, value);
583     }
584 
585     /**
586      * @dev Returns true if the value is in the set. O(1).
587      */
588     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
589         return _contains(set._inner, value);
590     }
591 
592     /**
593      * @dev Returns the number of values in the set. O(1).
594      */
595     function length(Bytes32Set storage set) internal view returns (uint256) {
596         return _length(set._inner);
597     }
598 
599     /**
600      * @dev Returns the value stored at position `index` in the set. O(1).
601      *
602      * Note that there are no guarantees on the ordering of values inside the
603      * array, and it may change when more values are added or removed.
604      *
605      * Requirements:
606      *
607      * - `index` must be strictly less than {length}.
608      */
609     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
610         return _at(set._inner, index);
611     }
612 
613     /**
614      * @dev Return the entire set in an array
615      *
616      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
617      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
618      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
619      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
620      */
621     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
622         bytes32[] memory store = _values(set._inner);
623         bytes32[] memory result;
624 
625         /// @solidity memory-safe-assembly
626         assembly {
627             result := store
628         }
629 
630         return result;
631     }
632 
633     // AddressSet
634 
635     struct AddressSet {
636         Set _inner;
637     }
638 
639     /**
640      * @dev Add a value to a set. O(1).
641      *
642      * Returns true if the value was added to the set, that is if it was not
643      * already present.
644      */
645     function add(AddressSet storage set, address value) internal returns (bool) {
646         return _add(set._inner, bytes32(uint256(uint160(value))));
647     }
648 
649     /**
650      * @dev Removes a value from a set. O(1).
651      *
652      * Returns true if the value was removed from the set, that is if it was
653      * present.
654      */
655     function remove(AddressSet storage set, address value) internal returns (bool) {
656         return _remove(set._inner, bytes32(uint256(uint160(value))));
657     }
658 
659     /**
660      * @dev Returns true if the value is in the set. O(1).
661      */
662     function contains(AddressSet storage set, address value) internal view returns (bool) {
663         return _contains(set._inner, bytes32(uint256(uint160(value))));
664     }
665 
666     /**
667      * @dev Returns the number of values in the set. O(1).
668      */
669     function length(AddressSet storage set) internal view returns (uint256) {
670         return _length(set._inner);
671     }
672 
673     /**
674      * @dev Returns the value stored at position `index` in the set. O(1).
675      *
676      * Note that there are no guarantees on the ordering of values inside the
677      * array, and it may change when more values are added or removed.
678      *
679      * Requirements:
680      *
681      * - `index` must be strictly less than {length}.
682      */
683     function at(AddressSet storage set, uint256 index) internal view returns (address) {
684         return address(uint160(uint256(_at(set._inner, index))));
685     }
686 
687     /**
688      * @dev Return the entire set in an array
689      *
690      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
691      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
692      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
693      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
694      */
695     function values(AddressSet storage set) internal view returns (address[] memory) {
696         bytes32[] memory store = _values(set._inner);
697         address[] memory result;
698 
699         /// @solidity memory-safe-assembly
700         assembly {
701             result := store
702         }
703 
704         return result;
705     }
706 
707     // UintSet
708 
709     struct UintSet {
710         Set _inner;
711     }
712 
713     /**
714      * @dev Add a value to a set. O(1).
715      *
716      * Returns true if the value was added to the set, that is if it was not
717      * already present.
718      */
719     function add(UintSet storage set, uint256 value) internal returns (bool) {
720         return _add(set._inner, bytes32(value));
721     }
722 
723     /**
724      * @dev Removes a value from a set. O(1).
725      *
726      * Returns true if the value was removed from the set, that is if it was
727      * present.
728      */
729     function remove(UintSet storage set, uint256 value) internal returns (bool) {
730         return _remove(set._inner, bytes32(value));
731     }
732 
733     /**
734      * @dev Returns true if the value is in the set. O(1).
735      */
736     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
737         return _contains(set._inner, bytes32(value));
738     }
739 
740     /**
741      * @dev Returns the number of values in the set. O(1).
742      */
743     function length(UintSet storage set) internal view returns (uint256) {
744         return _length(set._inner);
745     }
746 
747     /**
748      * @dev Returns the value stored at position `index` in the set. O(1).
749      *
750      * Note that there are no guarantees on the ordering of values inside the
751      * array, and it may change when more values are added or removed.
752      *
753      * Requirements:
754      *
755      * - `index` must be strictly less than {length}.
756      */
757     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
758         return uint256(_at(set._inner, index));
759     }
760 
761     /**
762      * @dev Return the entire set in an array
763      *
764      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
765      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
766      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
767      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
768      */
769     function values(UintSet storage set) internal view returns (uint256[] memory) {
770         bytes32[] memory store = _values(set._inner);
771         uint256[] memory result;
772 
773         /// @solidity memory-safe-assembly
774         assembly {
775             result := store
776         }
777 
778         return result;
779     }
780 }
781 pragma solidity ^0.8.9;
782 
783 //  MIT
784 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789  * @dev Provides information about the current execution context, including the
790  * sender of the transaction and its data. While these are generally available
791  * via msg.sender and msg.data, they should not be accessed in such a direct
792  * manner, since when dealing with meta-transactions the account sending and
793  * paying for execution may not be the actual sender (as far as an application
794  * is concerned).
795  *
796  * This contract is only required for intermediate, library-like contracts.
797  */
798 abstract contract Context {
799     function _msgSender() internal view virtual returns (address) {
800         return msg.sender;
801     }
802 
803     function _msgData() internal view virtual returns (bytes calldata) {
804         return msg.data;
805     }
806 }
807 //  MIT
808 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @dev Interface of the ERC20 standard as defined in the EIP.
814  */
815 interface IERC20 {
816     /**
817      * @dev Emitted when `value` tokens are moved from one account (`from`) to
818      * another (`to`).
819      *
820      * Note that `value` may be zero.
821      */
822     event Transfer(address indexed from, address indexed to, uint256 value);
823 
824     /**
825      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
826      * a call to {approve}. `value` is the new allowance.
827      */
828     event Approval(address indexed owner, address indexed spender, uint256 value);
829 
830     /**
831      * @dev Returns the amount of tokens in existence.
832      */
833     function totalSupply() external view returns (uint256);
834 
835     /**
836      * @dev Returns the amount of tokens owned by `account`.
837      */
838     function balanceOf(address account) external view returns (uint256);
839 
840     /**
841      * @dev Moves `amount` tokens from the caller's account to `to`.
842      *
843      * Returns a boolean value indicating whether the operation succeeded.
844      *
845      * Emits a {Transfer} event.
846      */
847     function transfer(address to, uint256 amount) external returns (bool);
848 
849     /**
850      * @dev Returns the remaining number of tokens that `spender` will be
851      * allowed to spend on behalf of `owner` through {transferFrom}. This is
852      * zero by default.
853      *
854      * This value changes when {approve} or {transferFrom} are called.
855      */
856     function allowance(address owner, address spender) external view returns (uint256);
857 
858     /**
859      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
860      *
861      * Returns a boolean value indicating whether the operation succeeded.
862      *
863      * IMPORTANT: Beware that changing an allowance with this method brings the risk
864      * that someone may use both the old and the new allowance by unfortunate
865      * transaction ordering. One possible solution to mitigate this race
866      * condition is to first reduce the spender's allowance to 0 and set the
867      * desired value afterwards:
868      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
869      *
870      * Emits an {Approval} event.
871      */
872     function approve(address spender, uint256 amount) external returns (bool);
873 
874     /**
875      * @dev Moves `amount` tokens from `from` to `to` using the
876      * allowance mechanism. `amount` is then deducted from the caller's
877      * allowance.
878      *
879      * Returns a boolean value indicating whether the operation succeeded.
880      *
881      * Emits a {Transfer} event.
882      */
883     function transferFrom(
884         address from,
885         address to,
886         uint256 amount
887     ) external returns (bool);
888 }
889 //  MIT
890 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
891 
892 pragma solidity ^0.8.1;
893 
894 //  MIT
895 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @dev Contract module which provides a basic access control mechanism, where
902  * there is an account (an owner) that can be granted exclusive access to
903  * specific functions.
904  *
905  * By default, the owner account will be the one that deploys the contract. This
906  * can later be changed with {transferOwnership}.
907  *
908  * This module is used through inheritance. It will make available the modifier
909  * `onlyOwner`, which can be applied to your functions to restrict their use to
910  * the owner.
911  */
912 abstract contract Ownable is Context {
913     address private _owner;
914 
915     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
916 
917     /**
918      * @dev Initializes the contract setting the deployer as the initial owner.
919      */
920     constructor() {
921         _transferOwnership(_msgSender());
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         _checkOwner();
929         _;
930     }
931 
932     /**
933      * @dev Returns the address of the current owner.
934      */
935     function owner() public view virtual returns (address) {
936         return _owner;
937     }
938 
939     /**
940      * @dev Throws if the sender is not the owner.
941      */
942     function _checkOwner() internal view virtual {
943         require(owner() == _msgSender(), "Ownable: caller is not the owner");
944     }
945 
946     /**
947      * @dev Leaves the contract without owner. It will not be possible to call
948      * `onlyOwner` functions anymore. Can only be called by the current owner.
949      *
950      * NOTE: Renouncing ownership will leave the contract without an owner,
951      * thereby removing any functionality that is only available to the owner.
952      */
953     function renounceOwnership() public virtual onlyOwner {
954         _transferOwnership(address(0));
955     }
956 
957     /**
958      * @dev Transfers ownership of the contract to a new account (`newOwner`).
959      * Can only be called by the current owner.
960      */
961     function transferOwnership(address newOwner) public virtual onlyOwner {
962         require(newOwner != address(0), "Ownable: new owner is the zero address");
963         _transferOwnership(newOwner);
964     }
965 
966     /**
967      * @dev Transfers ownership of the contract to a new account (`newOwner`).
968      * Internal function without access restriction.
969      */
970     function _transferOwnership(address newOwner) internal virtual {
971         address oldOwner = _owner;
972         _owner = newOwner;
973         emit OwnershipTransferred(oldOwner, newOwner);
974     }
975 }
976 
977 error InsufficientBalance(uint256 available, uint256 required);
978 error InvalidPool();
979 error NothingToDo();
980 
981 contract BullRunStaking is Ownable {
982     using SafeERC20 for IERC20;
983 
984     struct UserInfo {
985         uint256 amount;
986         uint256 rewardDebt;
987         uint256 startTime;
988         uint256 totalRewards;
989     }
990 
991     struct PoolInfo {
992         IERC20 token;
993         uint256 lastRewardTimestamp;
994         uint256 accBRLPerShare;
995         uint256 balance;
996         uint256 rewardSupply;
997         uint256 brlPerSecond;
998     }
999 
1000     IERC20 public brl;
1001     uint256 public brlPoolIndex;
1002     address public bulldozer;
1003 
1004     PoolInfo[] public poolInfo;
1005     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1006 
1007     uint256 public startTime;
1008     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1009     event Compound(address indexed user, uint256 indexed pid, uint256 amount);
1010     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1011     event EmergencyWithdraw(
1012         address indexed user,
1013         uint256 indexed pid,
1014         uint256 amount
1015     );
1016 
1017     constructor(IERC20 _brl, uint256 _startTime, address _bulldozer) {
1018         brl = _brl;
1019         startTime = _startTime;
1020         bulldozer = _bulldozer;
1021     }
1022 
1023     function poolLength() external view returns (uint256) {
1024         return poolInfo.length;
1025     }
1026 
1027     function add(IERC20 _token, uint256 _rewardSupply, uint256 _brlPerSecond) public onlyOwner {
1028         uint256 lastRewardTimestamp = block.timestamp > startTime ? block.timestamp : startTime;
1029         uint256 balBefore = brl.balanceOf(address(this));
1030         brl.transferFrom(msg.sender, address(this), _rewardSupply);
1031         uint256 amountReceived = brl.balanceOf(address(this)) - balBefore;
1032         poolInfo.push(
1033             PoolInfo({
1034                 token: _token,
1035                 lastRewardTimestamp: lastRewardTimestamp,
1036                 accBRLPerShare: 0,
1037                 balance: 0,
1038                 rewardSupply: amountReceived,
1039                 brlPerSecond: _brlPerSecond
1040             })
1041         );
1042     }
1043 
1044     function setRewardRate(uint256 _pid, uint256 _brlPerSecond) public onlyOwner {
1045         poolInfo[_pid].brlPerSecond = _brlPerSecond;
1046     }
1047 
1048     function supplyRewards(uint256 _pid, uint256 _amount) external {
1049         uint256 balBefore = brl.balanceOf(address(this));
1050         brl.transferFrom(msg.sender, address(this), _amount);
1051         uint256 amountReceived = brl.balanceOf(address(this)) - balBefore;
1052         poolInfo[_pid].rewardSupply += amountReceived;
1053     }
1054 
1055     function pendingBRL(uint256 _pid, address _user) external view returns (uint256)
1056     {
1057         PoolInfo storage pool = poolInfo[_pid];
1058         UserInfo storage user = userInfo[_pid][_user];
1059         uint256 accBRLPerShare = pool.accBRLPerShare;
1060         uint256 balance = pool.balance;
1061         uint256 lastRewardTimestamp = pool.lastRewardTimestamp;
1062         if (block.timestamp > lastRewardTimestamp && balance != 0) {
1063             uint256 brlReward = (block.timestamp - lastRewardTimestamp) * pool.brlPerSecond;
1064             accBRLPerShare += (brlReward * 1e12 / balance);
1065         }
1066         return (user.amount * accBRLPerShare / 1e12) - user.rewardDebt;
1067     }
1068 
1069     function massUpdatePools() public {
1070         uint256 length = poolInfo.length;
1071         for (uint256 pid = 0; pid < length; ++pid) {
1072             updatePool(pid);
1073         }
1074     }
1075 
1076     function updatePool(uint256 _pid) public {
1077         PoolInfo storage pool = poolInfo[_pid];
1078         uint256 timestamp = block.timestamp;
1079         if (timestamp <= pool.lastRewardTimestamp) {
1080             return;
1081         }
1082         uint256 balance = pool.balance;
1083         if (balance == 0) {
1084             pool.lastRewardTimestamp = timestamp;
1085             return;
1086         }
1087         uint256 brlReward = (timestamp - pool.lastRewardTimestamp) * pool.brlPerSecond;
1088         pool.accBRLPerShare += (brlReward * 1e12 / balance);
1089         pool.lastRewardTimestamp = timestamp;
1090     }
1091 
1092     function deposit(uint256 _pid, uint256 _amount) external {
1093         PoolInfo storage pool = poolInfo[_pid];
1094         UserInfo storage user = userInfo[_pid][msg.sender];
1095         updatePool(_pid);
1096         if (user.amount > 0) {
1097             uint256 pending = (user.amount * pool.accBRLPerShare / 1e12) - user.rewardDebt;
1098             uint256 amountTransferred = safeBRLTransfer(msg.sender, pending, pool.rewardSupply);
1099             pool.rewardSupply -= amountTransferred;
1100             user.totalRewards += amountTransferred;
1101         }
1102         uint256 beforeBal = pool.token.balanceOf(address(this));
1103         pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
1104         uint256 amountReceived = pool.token.balanceOf(address(this)) - beforeBal;
1105         //take fees
1106         uint256 fee = amountReceived / 50;
1107         pool.token.safeTransfer(bulldozer, fee);
1108         amountReceived -= fee;
1109         //for apy calculations
1110         if (user.amount == 0) {
1111             user.startTime = block.timestamp;
1112             user.totalRewards = 0;
1113         }
1114         //update balances
1115         pool.balance += amountReceived;
1116         user.amount += amountReceived;
1117         user.rewardDebt = user.amount * pool.accBRLPerShare / 1e12;
1118         emit Deposit(msg.sender, _pid, _amount);
1119     }
1120 
1121     function compound(uint256 _pid) external {
1122         PoolInfo storage pool = poolInfo[_pid];
1123         UserInfo storage user = userInfo[_pid][msg.sender];
1124         updatePool(_pid);
1125         uint256 pending = (user.amount * pool.accBRLPerShare / 1e12) - user.rewardDebt;
1126         if (pending == 0) {
1127             revert NothingToDo();
1128         }
1129         uint256 rewardSupply = pool.rewardSupply;
1130         uint256 paidRewards = pending > rewardSupply ? rewardSupply : pending;
1131         pool.rewardSupply -= paidRewards;
1132         user.totalRewards += paidRewards;
1133         user.rewardDebt = user.amount * pool.accBRLPerShare / 1e12;
1134         uint256 totalCompounded = _compound(paidRewards);
1135         emit Compound(msg.sender, _pid, totalCompounded);
1136     }
1137 
1138     function _compound(uint256 _amount) internal returns (uint256) {
1139         PoolInfo storage pool = poolInfo[brlPoolIndex];
1140         UserInfo storage user = userInfo[brlPoolIndex][msg.sender];
1141         updatePool(brlPoolIndex);
1142         uint256 paidRewards;
1143         if (user.amount > 0) {
1144             uint256 pending = (user.amount * pool.accBRLPerShare / 1e12) - user.rewardDebt;
1145             paidRewards = pending > pool.rewardSupply ? pool.rewardSupply : pending;
1146             pool.rewardSupply -= paidRewards;
1147             user.totalRewards += paidRewards;
1148         }
1149         uint256 sum = _amount + paidRewards;
1150         pool.balance += sum;
1151         user.amount += sum;
1152         user.rewardDebt = user.amount * pool.accBRLPerShare / 1e12;
1153 
1154         return sum;
1155     }
1156 
1157     function withdraw(uint256 _pid, uint256 _amount) external {
1158         PoolInfo storage pool = poolInfo[_pid];
1159         UserInfo storage user = userInfo[_pid][msg.sender];
1160         if (_amount > user.amount) {
1161             revert InsufficientBalance(user.amount, _amount);
1162         }
1163         updatePool(_pid);
1164         uint256 pending = (user.amount * pool.accBRLPerShare / 1e12) - user.rewardDebt;
1165         uint256 amountTransferred = safeBRLTransfer(msg.sender, pending, pool.rewardSupply);
1166         pool.rewardSupply -= amountTransferred;
1167         user.totalRewards += amountTransferred;
1168         pool.balance -= _amount;
1169         user.amount -= _amount;
1170         user.rewardDebt = user.amount * pool.accBRLPerShare / 1e12;
1171         //take fees
1172         uint256 fee = _amount / 20;
1173         _amount -= fee;
1174         pool.token.safeTransfer(bulldozer, fee);
1175         pool.token.safeTransfer(address(msg.sender), _amount);
1176         emit Withdraw(msg.sender, _pid, _amount);
1177     }
1178 
1179     function emergencyWithdraw(uint256 _pid) external {
1180         PoolInfo storage pool = poolInfo[_pid];
1181         UserInfo storage user = userInfo[_pid][msg.sender];
1182         uint256 amount = user.amount;
1183         pool.balance -= amount;
1184         user.amount = 0;
1185         user.rewardDebt = 0;
1186         pool.token.safeTransfer(address(msg.sender), amount);
1187         emit EmergencyWithdraw(msg.sender, _pid, amount);
1188     }
1189 
1190     function safeBRLTransfer(address _to, uint256 _amount, uint256 _rewardSupply) internal returns (uint256) {
1191         uint256 amountToSend = _amount > _rewardSupply ? _rewardSupply : _amount;
1192         brl.transfer(_to, amountToSend);
1193         return amountToSend;
1194     }
1195 
1196     function setBRLPoolIndex(uint256 _pid) external onlyOwner {
1197         PoolInfo storage pool = poolInfo[_pid];
1198         if (pool.token != brl) {
1199             revert InvalidPool();
1200         }
1201         brlPoolIndex = _pid;
1202     }
1203 
1204     function setBulldozer(address wallet) external onlyOwner {
1205         bulldozer = wallet;
1206     }
1207 
1208 
1209 }