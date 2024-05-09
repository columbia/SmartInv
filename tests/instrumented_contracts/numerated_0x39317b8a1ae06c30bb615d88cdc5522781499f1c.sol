1 /**
2  //SPDX-License-Identifier: MIT
3  
4 */
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  */
32 library EnumerableSet {
33     // To implement this library for multiple types with as little code
34     // repetition as possible, we write it in terms of a generic Set type with
35     // bytes32 values.
36     // The Set implementation uses private functions, and user-facing
37     // implementations (such as AddressSet) are just wrappers around the
38     // underlying Set.
39     // This means that we can only create new EnumerableSets for types that fit
40     // in bytes32.
41 
42     struct Set {
43         // Storage of set values
44         bytes32[] _values;
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping(bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) {
79             // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             if (lastIndex != toDeleteIndex) {
88                 bytes32 lastvalue = set._values[lastIndex];
89 
90                 // Move the last value to the index where the value to delete is
91                 set._values[toDeleteIndex] = lastvalue;
92                 // Update the index for the moved value
93                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
94             }
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122     /**
123      * @dev Returns the value stored at position `index` in the set. O(1).
124      *
125      * Note that there are no guarantees on the ordering of values inside the
126      * array, and it may change when more values are added or removed.
127      *
128      * Requirements:
129      *
130      * - `index` must be strictly less than {length}.
131      */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         return set._values[index];
134     }
135 
136     /**
137      * @dev Return the entire set in an array
138      *
139      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
140      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
141      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
142      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
143      */
144     function _values(Set storage set) private view returns (bytes32[] memory) {
145         return set._values;
146     }
147 
148     // Bytes32Set
149 
150     struct Bytes32Set {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
161         return _add(set._inner, value);
162     }
163 
164     /**
165      * @dev Removes a value from a set. O(1).
166      *
167      * Returns true if the value was removed from the set, that is if it was
168      * present.
169      */
170     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
171         return _remove(set._inner, value);
172     }
173 
174     /**
175      * @dev Returns true if the value is in the set. O(1).
176      */
177     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
178         return _contains(set._inner, value);
179     }
180 
181     /**
182      * @dev Returns the number of values in the set. O(1).
183      */
184     function length(Bytes32Set storage set) internal view returns (uint256) {
185         return _length(set._inner);
186     }
187 
188     /**
189      * @dev Returns the value stored at position `index` in the set. O(1).
190      *
191      * Note that there are no guarantees on the ordering of values inside the
192      * array, and it may change when more values are added or removed.
193      *
194      * Requirements:
195      *
196      * - `index` must be strictly less than {length}.
197      */
198     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
199         return _at(set._inner, index);
200     }
201 
202     /**
203      * @dev Return the entire set in an array
204      *
205      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
206      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
207      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
208      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
209      */
210     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
211         return _values(set._inner);
212     }
213 
214     // AddressSet
215 
216     struct AddressSet {
217         Set _inner;
218     }
219 
220     /**
221      * @dev Add a value to a set. O(1).
222      *
223      * Returns true if the value was added to the set, that is if it was not
224      * already present.
225      */
226     function add(AddressSet storage set, address value) internal returns (bool) {
227         return _add(set._inner, bytes32(uint256(uint160(value))));
228     }
229 
230     /**
231      * @dev Removes a value from a set. O(1).
232      *
233      * Returns true if the value was removed from the set, that is if it was
234      * present.
235      */
236     function remove(AddressSet storage set, address value) internal returns (bool) {
237         return _remove(set._inner, bytes32(uint256(uint160(value))));
238     }
239 
240     /**
241      * @dev Returns true if the value is in the set. O(1).
242      */
243     function contains(AddressSet storage set, address value) internal view returns (bool) {
244         return _contains(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     /**
248      * @dev Returns the number of values in the set. O(1).
249      */
250     function length(AddressSet storage set) internal view returns (uint256) {
251         return _length(set._inner);
252     }
253 
254     /**
255      * @dev Returns the value stored at position `index` in the set. O(1).
256      *
257      * Note that there are no guarantees on the ordering of values inside the
258      * array, and it may change when more values are added or removed.
259      *
260      * Requirements:
261      *
262      * - `index` must be strictly less than {length}.
263      */
264     function at(AddressSet storage set, uint256 index) internal view returns (address) {
265         return address(uint160(uint256(_at(set._inner, index))));
266     }
267 
268     /**
269      * @dev Return the entire set in an array
270      *
271      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
272      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
273      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
274      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
275      */
276     function values(AddressSet storage set) internal view returns (address[] memory) {
277         bytes32[] memory store = _values(set._inner);
278         address[] memory result;
279 
280         assembly {
281             result := store
282         }
283 
284         return result;
285     }
286 
287     // UintSet
288 
289     struct UintSet {
290         Set _inner;
291     }
292 
293     /**
294      * @dev Add a value to a set. O(1).
295      *
296      * Returns true if the value was added to the set, that is if it was not
297      * already present.
298      */
299     function add(UintSet storage set, uint256 value) internal returns (bool) {
300         return _add(set._inner, bytes32(value));
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function remove(UintSet storage set, uint256 value) internal returns (bool) {
310         return _remove(set._inner, bytes32(value));
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
317         return _contains(set._inner, bytes32(value));
318     }
319 
320     /**
321      * @dev Returns the number of values on the set. O(1).
322      */
323     function length(UintSet storage set) internal view returns (uint256) {
324         return _length(set._inner);
325     }
326 
327     /**
328      * @dev Returns the value stored at position `index` in the set. O(1).
329      *
330      * Note that there are no guarantees on the ordering of values inside the
331      * array, and it may change when more values are added or removed.
332      *
333      * Requirements:
334      *
335      * - `index` must be strictly less than {length}.
336      */
337     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
338         return uint256(_at(set._inner, index));
339     }
340 
341     /**
342      * @dev Return the entire set in an array
343      *
344      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
345      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
346      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
347      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
348      */
349     function values(UintSet storage set) internal view returns (uint256[] memory) {
350         bytes32[] memory store = _values(set._inner);
351         uint256[] memory result;
352 
353         assembly {
354             result := store
355         }
356 
357         return result;
358     }
359 }
360 /**
361  * @dev Collection of functions related to the address type
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * [IMPORTANT]
368      * ====
369      * It is unsafe to assume that an address for which this function returns
370      * false is an externally-owned account (EOA) and not a contract.
371      *
372      * Among others, `isContract` will return false for the following
373      * types of addresses:
374      *
375      *  - an externally-owned account
376      *  - a contract in construction
377      *  - an address where a contract will be created
378      *  - an address where a contract lived, but was destroyed
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize, which returns 0 for contracts in
383         // construction, since the code is only stored at the end of the
384         // constructor execution.
385 
386         uint256 size;
387         assembly {
388             size := extcodesize(account)
389         }
390         return size > 0;
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         (bool success, ) = recipient.call{value: amount}("");
413         require(success, "Address: unable to send value, recipient may have reverted");
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain `call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, 0, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but also transferring `value` wei to `target`.
455      *
456      * Requirements:
457      *
458      * - the calling contract must have an ETH balance of at least `value`.
459      * - the called Solidity function must be `payable`.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         require(isContract(target), "Address: call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.call{value: value}(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal view returns (bytes memory) {
511         require(isContract(target), "Address: static call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(isContract(target), "Address: delegate call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address) {
575         return msg.sender;
576     }
577 }
578 
579 interface IERC20 {
580     function totalSupply() external view returns (uint256);
581     function balanceOf(address account) external view returns (uint256);
582     function transfer(address recipient, uint256 amount) external returns (bool);
583     function allowance(address owner, address spender) external view returns (uint256);
584     function approve(address spender, uint256 amount) external returns (bool);
585     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
586     event Transfer(address indexed from, address indexed to, uint256 value);
587     event Approval(address indexed owner, address indexed spender, uint256 value);
588 }
589 
590 interface IERC20Metadata is IERC20 {
591     /**
592      * @dev Returns the name of the token.
593      */
594     function name() external view returns (string memory);
595 
596     /**
597      * @dev Returns the symbol of the token.
598      */
599     function symbol() external view returns (string memory);
600 
601     /**
602      * @dev Returns the decimals places of the token.
603      */
604     function decimals() external view returns (uint8);
605 }
606 
607 library SafeMath {
608     function add(uint256 a, uint256 b) internal pure returns (uint256) {
609         uint256 c = a + b;
610         require(c >= a, "SafeMath: addition overflow");
611         return c;
612     }
613 
614     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
615         return sub(a, b, "SafeMath: subtraction overflow");
616     }
617 
618     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
619         require(b <= a, errorMessage);
620         uint256 c = a - b;
621         return c;
622     }
623 
624     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
625         if (a == 0) {
626             return 0;
627         }
628         uint256 c = a * b;
629         require(c / a == b, "SafeMath: multiplication overflow");
630         return c;
631     }
632 
633     function div(uint256 a, uint256 b) internal pure returns (uint256) {
634         return div(a, b, "SafeMath: division by zero");
635     }
636 
637     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
638         require(b > 0, errorMessage);
639         uint256 c = a / b;
640         return c;
641     }
642 
643 }
644 
645 /**
646  * @title SafeERC20
647  * @dev Wrappers around ERC20 operations that throw on failure (when the token
648  * contract returns false). Tokens that return no value (and instead revert or
649  * throw on failure) are also supported, non-reverting calls are assumed to be
650  * successful.
651  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
652  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
653  */
654 library SafeERC20 {
655     using Address for address;
656 
657     function safeTransfer(
658         IERC20 token,
659         address to,
660         uint256 value
661     ) internal {
662         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
663     }
664 
665     function safeTransferFrom(
666         IERC20 token,
667         address from,
668         address to,
669         uint256 value
670     ) internal {
671         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
672     }
673 
674     /**
675      * @dev Deprecated. This function has issues similar to the ones found in
676      * {IERC20-approve}, and its usage is discouraged.
677      *
678      * Whenever possible, use {safeIncreaseAllowance} and
679      * {safeDecreaseAllowance} instead.
680      */
681     function safeApprove(
682         IERC20 token,
683         address spender,
684         uint256 value
685     ) internal {
686         // safeApprove should only be called when setting an initial allowance,
687         // or when resetting it to zero. To increase and decrease it, use
688         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
689         require(
690             (value == 0) || (token.allowance(address(this), spender) == 0),
691             "SafeERC20: approve from non-zero to non-zero allowance"
692         );
693         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
694     }
695 
696     function safeIncreaseAllowance(
697         IERC20 token,
698         address spender,
699         uint256 value
700     ) internal {
701         uint256 newAllowance = token.allowance(address(this), spender) + value;
702         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
703     }
704 
705     function safeDecreaseAllowance(
706         IERC20 token,
707         address spender,
708         uint256 value
709     ) internal {
710         unchecked {
711             uint256 oldAllowance = token.allowance(address(this), spender);
712             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
713             uint256 newAllowance = oldAllowance - value;
714             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
715         }
716     }
717 
718     /**
719      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
720      * on the return value: the return value is optional (but if data is returned, it must not be false).
721      * @param token The token targeted by the call.
722      * @param data The call data (encoded using abi.encode or one of its variants).
723      */
724     function _callOptionalReturn(IERC20 token, bytes memory data) private {
725         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
726         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
727         // the target address contains contract code and also asserts for success in the low-level call.
728 
729         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
730         if (returndata.length > 0) {
731             // Return data is optional
732             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
733         }
734     }
735 }
736 
737 /**
738  * @dev Implementation of the {IERC20} interface.
739  *
740  * This implementation is agnostic to the way tokens are created. This means
741  * that a supply mechanism has to be added in a derived contract using {_mint}.
742  * For a generic mechanism see {ERC20PresetMinterPauser}.
743  *
744  * TIP: For a detailed writeup see our guide
745  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
746  * to implement supply mechanisms].
747  *
748  * We have followed general OpenZeppelin Contracts guidelines: functions revert
749  * instead returning `false` on failure. This behavior is nonetheless
750  * conventional and does not conflict with the expectations of ERC20
751  * applications.
752  *
753  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
754  * This allows applications to reconstruct the allowance for all accounts just
755  * by listening to said events. Other implementations of the EIP may not emit
756  * these events, as it isn't required by the specification.
757  *
758  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
759  * functions have been added to mitigate the well-known issues around setting
760  * allowances. See {IERC20-approve}.
761  */
762 contract ERC20 is Context, IERC20, IERC20Metadata {
763     mapping(address => uint256) public _balances;
764 
765     mapping(address => mapping(address => uint256)) public _allowances;
766 
767     uint256 public _totalSupply;
768 
769     string public _name;
770     string public _symbol;
771 
772     /**
773      * @dev Sets the values for {name} and {symbol}.
774      *
775      * The default value of {decimals} is 18. To select a different value for
776      * {decimals} you should overload it.
777      *
778      * All two of these values are immutable: they can only be set once during
779      * construction.
780      */
781     constructor(string memory name_, string memory symbol_) {
782         _name = name_;
783         _symbol = symbol_;
784     }
785 
786     /**
787      * @dev Returns the name of the token.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev Returns the symbol of the token, usually a shorter version of the
795      * name.
796      */
797     function symbol() public view virtual override returns (string memory) {
798         return _symbol;
799     }
800 
801     /**
802      * @dev Returns the number of decimals used to get its user representation.
803      * For example, if `decimals` equals `2`, a balance of `505` tokens should
804      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
805      *
806      * Tokens usually opt for a value of 18, imitating the relationship between
807      * Ether and Wei. This is the value {ERC20} uses, unless this function is
808      * overridden;
809      *
810      * NOTE: This information is only used for _display_ purposes: it in
811      * no way affects any of the arithmetic of the contract, including
812      * {IERC20-balanceOf} and {IERC20-transfer}.
813      */
814     function decimals() public view virtual override returns (uint8) {
815         return 18;
816     }
817 
818     /**
819      * @dev See {IERC20-totalSupply}.
820      */
821     function totalSupply() public view virtual override returns (uint256) {
822         return _totalSupply;
823     }
824 
825     /**
826      * @dev See {IERC20-balanceOf}.
827      */
828     function balanceOf(address account) public view virtual override returns (uint256) {
829         return _balances[account];
830     }
831 
832     /**
833      * @dev See {IERC20-transfer}.
834      *
835      * Requirements:
836      *
837      * - `recipient` cannot be the zero address.
838      * - the caller must have a balance of at least `amount`.
839      */
840     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
841         _transfer(_msgSender(), recipient, amount);
842         return true;
843     }
844 
845     /**
846      * @dev See {IERC20-allowance}.
847      */
848     function allowance(address owner, address spender) public view virtual override returns (uint256) {
849         return _allowances[owner][spender];
850     }
851 
852     /**
853      * @dev See {IERC20-approve}.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      */
859     function approve(address spender, uint256 amount) public virtual override returns (bool) {
860         _approve(_msgSender(), spender, amount);
861         return true;
862     }
863 
864     /**
865      * @dev See {IERC20-transferFrom}.
866      *
867      * Emits an {Approval} event indicating the updated allowance. This is not
868      * required by the EIP. See the note at the beginning of {ERC20}.
869      *
870      * Requirements:
871      *
872      * - `sender` and `recipient` cannot be the zero address.
873      * - `sender` must have a balance of at least `amount`.
874      * - the caller must have allowance for ``sender``'s tokens of at least
875      * `amount`.
876      */
877     function transferFrom(
878         address sender,
879         address recipient,
880         uint256 amount
881     ) public virtual override returns (bool) {
882         _transfer(sender, recipient, amount);
883 
884         uint256 currentAllowance = _allowances[sender][_msgSender()];
885         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
886         unchecked {
887             _approve(sender, _msgSender(), currentAllowance - amount);
888         }
889 
890         return true;
891     }
892 
893     /**
894      * @dev Atomically increases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
906         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
907         return true;
908     }
909 
910     /**
911      * @dev Atomically decreases the allowance granted to `spender` by the caller.
912      *
913      * This is an alternative to {approve} that can be used as a mitigation for
914      * problems described in {IERC20-approve}.
915      *
916      * Emits an {Approval} event indicating the updated allowance.
917      *
918      * Requirements:
919      *
920      * - `spender` cannot be the zero address.
921      * - `spender` must have allowance for the caller of at least
922      * `subtractedValue`.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
925         uint256 currentAllowance = _allowances[_msgSender()][spender];
926         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
927         unchecked {
928             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
929         }
930 
931         return true;
932     }
933 
934     /**
935      * @dev Moves `amount` of tokens from `sender` to `recipient`.
936      *
937      * This internal function is equivalent to {transfer}, and can be used to
938      * e.g. implement automatic token fees, slashing mechanisms, etc.
939      *
940      * Emits a {Transfer} event.
941      *
942      * Requirements:
943      *
944      * - `sender` cannot be the zero address.
945      * - `recipient` cannot be the zero address.
946      * - `sender` must have a balance of at least `amount`.
947      */
948     function _transfer(
949         address sender,
950         address recipient,
951         uint256 amount
952     ) internal virtual {
953         require(sender != address(0), "ERC20: transfer from the zero address");
954         require(recipient != address(0), "ERC20: transfer to the zero address");
955 
956         _beforeTokenTransfer(sender, recipient, amount);
957 
958         uint256 senderBalance = _balances[sender];
959         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
960         unchecked {
961             _balances[sender] = senderBalance - amount;
962         }
963         _balances[recipient] += amount;
964 
965         emit Transfer(sender, recipient, amount);
966 
967         _afterTokenTransfer(sender, recipient, amount);
968     }
969 
970     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
971      * the total supply.
972      *
973      * Emits a {Transfer} event with `from` set to the zero address.
974      *
975      * Requirements:
976      *
977      * - `account` cannot be the zero address.
978      */
979     function _mint(address account, uint256 amount) internal virtual {
980         require(account != address(0), "ERC20: mint to the zero address");
981 
982         _beforeTokenTransfer(address(0), account, amount);
983 
984         _totalSupply += amount;
985         _balances[account] += amount;
986         emit Transfer(address(0), account, amount);
987 
988         _afterTokenTransfer(address(0), account, amount);
989     }
990 
991     /**
992      * @dev Destroys `amount` tokens from `account`, reducing the
993      * total supply.
994      *
995      * Emits a {Transfer} event with `to` set to the zero address.
996      *
997      * Requirements:
998      *
999      * - `account` cannot be the zero address.
1000      * - `account` must have at least `amount` tokens.
1001      */
1002     function _burn(address account, uint256 amount) internal virtual {
1003         require(account != address(0), "ERC20: burn from the zero address");
1004 
1005         _beforeTokenTransfer(account, address(0), amount);
1006 
1007         uint256 accountBalance = _balances[account];
1008         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1009         unchecked {
1010             _balances[account] = accountBalance - amount;
1011         }
1012         _totalSupply -= amount;
1013 
1014         emit Transfer(account, address(0), amount);
1015 
1016         _afterTokenTransfer(account, address(0), amount);
1017     }
1018 
1019     /**
1020      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1021      *
1022      * This internal function is equivalent to `approve`, and can be used to
1023      * e.g. set automatic allowances for certain subsystems, etc.
1024      *
1025      * Emits an {Approval} event.
1026      *
1027      * Requirements:
1028      *
1029      * - `owner` cannot be the zero address.
1030      * - `spender` cannot be the zero address.
1031      */
1032     function _approve(
1033         address owner,
1034         address spender,
1035         uint256 amount
1036     ) internal virtual {
1037         require(owner != address(0), "ERC20: approve from the zero address");
1038         require(spender != address(0), "ERC20: approve to the zero address");
1039 
1040         _allowances[owner][spender] = amount;
1041         emit Approval(owner, spender, amount);
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any transfer of tokens. This includes
1046      * minting and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1051      * will be transferred to `to`.
1052      * - when `from` is zero, `amount` tokens will be minted for `to`.
1053      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1054      * - `from` and `to` are never both zero.
1055      *
1056      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1057      */
1058     function _beforeTokenTransfer(
1059         address from,
1060         address to,
1061         uint256 amount
1062     ) internal virtual {}
1063 
1064     /**
1065      * @dev Hook that is called after any transfer of tokens. This includes
1066      * minting and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1071      * has been transferred to `to`.
1072      * - when `from` is zero, `amount` tokens have been minted for `to`.
1073      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _afterTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 amount
1082     ) internal virtual {}
1083 }
1084 
1085 /**
1086  * @dev Contract module which provides a basic access control mechanism, where
1087  * there is an account (an owner) that can be granted exclusive access to
1088  * specific functions.
1089  *
1090  * By default, the owner account will be the one that deploys the contract. This
1091  * can later be changed with {transferOwnership}.
1092  *
1093  * This module is used through inheritance. It will make available the modifier
1094  * `onlyOwner`, which can be applied to your functions to restrict their use to
1095  * the owner.
1096  */
1097 abstract contract Ownable is Context {
1098     address private _owner;
1099 
1100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1101 
1102     /**
1103      * @dev Initializes the contract setting the deployer as the initial owner.
1104      */
1105     constructor() {
1106         _setOwner(_msgSender());
1107     }
1108 
1109     /**
1110      * @dev Returns the address of the current owner.
1111      */
1112     function owner() public view virtual returns (address) {
1113         return _owner;
1114     }
1115 
1116     /**
1117      * @dev Throws if called by any account other than the owner.
1118      */
1119     modifier onlyOwner() {
1120         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1121         _;
1122     }
1123 
1124     /**
1125      * @dev Leaves the contract without owner. It will not be possible to call
1126      * `onlyOwner` functions anymore. Can only be called by the current owner.
1127      *
1128      * NOTE: Renouncing ownership will leave the contract without an owner,
1129      * thereby removing any functionality that is only available to the owner.
1130      */
1131     function renounceOwnership() public virtual onlyOwner {
1132         _setOwner(address(0));
1133     }
1134 
1135     /**
1136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1137      * Can only be called by the current owner.
1138      */
1139     function transferOwnership(address newOwner) public virtual onlyOwner {
1140         require(newOwner != address(0), "Ownable: new owner is the zero address");
1141         _setOwner(newOwner);
1142     }
1143 
1144     function _setOwner(address newOwner) private {
1145         address oldOwner = _owner;
1146         _owner = newOwner;
1147         emit OwnershipTransferred(oldOwner, newOwner);
1148     }
1149 }
1150 
1151 interface IUniswapV2Factory {
1152     function createPair(address tokenA, address tokenB) external returns (address pair);
1153 }
1154 
1155 interface IUniswapV2Router02 {
1156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1157         uint amountIn,
1158         uint amountOutMin,
1159         address[] calldata path,
1160         address to,
1161         uint deadline
1162     ) external;
1163     function factory() external pure returns (address);
1164     function WETH() external pure returns (address);
1165     function addLiquidityETH(
1166         address token,
1167         uint amountTokenDesired,
1168         uint amountTokenMin,
1169         uint amountETHMin,
1170         address to,
1171         uint deadline
1172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1173 
1174 }
1175 
1176 interface BRAINToken {
1177     
1178     function excludeFromFees(address) external;
1179     function includeInFees(address) external;
1180     function changeMarketing(address payable) external;
1181     function changeTreasury(address payable) external;
1182     function setMaxTx(uint256) external;
1183     function toggleMaxTx() external;
1184     function setTax(uint256) external;
1185     function toggleTax() external;
1186     function addBots(address[] memory) external;
1187     function removeBot(address) external;
1188     function addMinter(address) external;
1189     function removeMinter(address) external;
1190     function mint(address, uint256) external;
1191     function burn() external;
1192     function burn(uint256) external;
1193 }
1194 
1195 contract BRAIN is Ownable, ERC20, BRAINToken {
1196     
1197     using SafeMath for uint256;
1198     using SafeERC20 for ERC20;
1199     using Address for address;
1200     
1201     mapping (address => bool) private _isExcludedFromFee;
1202     mapping (address => bool) private bots;
1203     
1204     EnumerableSet.AddressSet minters;
1205     
1206     uint256 public MAX_t;
1207     bool public MAX_tx_on;
1208     bool public tax_on;
1209     bool private inSwap;
1210     
1211     uint256 public tax;
1212     address payable public marketingWallet;
1213     address payable public treasuryWallet;
1214     address public uniswapV2Pair;
1215     
1216     //bsc = 0x10ED43C718714eb63d5aA57B78B54704E256024E
1217     //Uni = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1218     //Matic = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff 
1219     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1220     
1221     address[] path = [address(this), _uniswapV2Router.WETH()];
1222     
1223     constructor( string memory name, string memory symbol, uint256 _Max_t, address payable _marketingWallet, address payable _treasuryWallet, uint256 _tax) ERC20(name, symbol){
1224 
1225         MAX_t = _Max_t;   
1226         MAX_tx_on = true;
1227         marketingWallet = _marketingWallet;
1228         treasuryWallet = _treasuryWallet;
1229         tax = _tax;
1230         tax_on = false;
1231         EnumerableSet.add(minters, msg.sender);
1232         _approve(address(this), address(_uniswapV2Router), type(uint256).max);
1233     }
1234     
1235     receive() external payable {}
1236     
1237     modifier onlyMinter() {
1238         require(EnumerableSet.contains(minters,msg.sender)==true, "NOT MINTER");
1239         _;
1240     }
1241     
1242     modifier lockSwap {
1243         inSwap = true;
1244         _;
1245         inSwap = false;
1246     }
1247     
1248     function approveRouter() external {
1249         _approve(address(this), address(_uniswapV2Router), type(uint256).max);
1250     }
1251     
1252     function excludeFromFees(address _addy) external override onlyOwner {
1253         _isExcludedFromFee[_addy] = true;
1254     }
1255     
1256     function includeInFees(address _addy) external override onlyOwner {
1257         _isExcludedFromFee[_addy] = false;
1258     }
1259     
1260     function changeMarketing(address payable _addy) external override onlyOwner {
1261         
1262         marketingWallet = _addy;
1263     }
1264     
1265     function changeTreasury(address payable _addy) external override onlyOwner {
1266         
1267         treasuryWallet = _addy;
1268     }
1269     
1270     function setMaxTx(uint256 amount) external override onlyOwner {
1271         MAX_t = amount;
1272     }
1273     
1274     function toggleMaxTx() external override onlyOwner {
1275         if (MAX_tx_on == true) {
1276             MAX_tx_on = false;
1277         } else {
1278             MAX_tx_on = true;
1279         }
1280     }
1281     
1282     function setTax(uint256 _tax) external override onlyOwner {
1283         
1284         require(_tax <= 10, "TAX TOO HIGH");
1285         tax = _tax;
1286     }
1287     
1288     function toggleTax() external override onlyOwner {
1289         if(tax_on == true) {
1290             tax_on = false;
1291         } else {
1292             tax_on = true;
1293         }
1294     }
1295     
1296     function addBots(address[] memory _bots) external override onlyOwner {
1297         for (uint256 i=0; i>_bots.length; i++) {
1298             bots[_bots[i]] = true; 
1299         }
1300     }
1301     
1302     function removeBot(address _removeBot) external override onlyOwner {
1303         require(bots[_removeBot]==true, "NOT BOT");
1304         bots[_removeBot] = false;
1305     }
1306     
1307     function addMinter(address _minter) external override onlyOwner {
1308 
1309         EnumerableSet.add(minters, _minter);
1310     }
1311     
1312     function removeMinter(address _minter) external override onlyOwner {
1313 
1314         require(EnumerableSet.contains(minters, _minter), "NOT A MINTER");
1315         EnumerableSet.remove(minters, _minter);
1316         
1317     }
1318     
1319     function mint(address to, uint256 amount) external override onlyMinter {
1320         
1321         _mint(to, amount);
1322         
1323     }
1324     
1325     function burn() external override {
1326         
1327         _burn(msg.sender, (this).balanceOf(msg.sender));
1328     }
1329     
1330     function burn(uint256 _amount) external override {
1331         
1332         require(this.balanceOf(msg.sender)>=_amount,"INSUFFICIENT AMOUNT");
1333         _burn(msg.sender, _amount);
1334     }
1335     
1336         
1337     function _transfer(
1338         address sender,
1339         address recipient,
1340         uint256 amount
1341         ) internal override {
1342             require(sender != address(0), "ERC20: transfer from the zero address");
1343             require(recipient != address(0), "ERC20: transfer to the zero address");
1344             require(bots[sender] != true, "BOT");
1345             require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
1346             
1347             if (sender != marketingWallet && MAX_tx_on && sender != address(this)) {
1348                 
1349                 require(amount<=MAX_t, "TX TOO HIGH");
1350             }
1351             
1352             if(!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient] && tax_on && !(sender == uniswapV2Pair && recipient == address(_uniswapV2Router)) &&!(sender == address(_uniswapV2Router))) {
1353                 
1354                 if (!inSwap && sender != uniswapV2Pair) {
1355                     swapTokensForEth(this.balanceOf(address(this)));   
1356                 }
1357                     
1358                 uint256 senderBalance = _balances[sender];
1359                 unchecked {
1360                     _balances[sender] = senderBalance - amount;
1361                 }
1362                 _balances[recipient] += amount.mul(100-tax).div(100);
1363                 _balances[address(this)] += amount.mul(tax).div(100);
1364                     
1365             } else {
1366                
1367                 uint256 senderBalance = _balances[sender];
1368                 unchecked {
1369                     _balances[sender] = senderBalance - amount;
1370                 }
1371                 _balances[recipient] += amount;
1372             }
1373             emit Transfer(sender, recipient, amount);
1374     }
1375     
1376     
1377     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
1378 
1379         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1380         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1381             tokenAmount,
1382             0,
1383             path,
1384             address(this),
1385             block.timestamp
1386         );
1387         
1388         uint256 amount = address(this).balance.div(2);
1389         
1390         treasuryWallet.transfer(amount);
1391         marketingWallet.transfer(amount);
1392         
1393     }
1394         
1395     function startCreateLiq() external onlyOwner {
1396         
1397         MAX_tx_on = false;
1398         tax_on = false;
1399         
1400         _approve(address(this), address(_uniswapV2Router), 10 ** 18 * 1e18);
1401         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1402         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),this.balanceOf(address(this)),this.balanceOf(address(this)),address(this).balance,owner(),block.timestamp);
1403 
1404         IERC20(uniswapV2Pair).transfer(marketingWallet, IERC20(uniswapV2Pair).balanceOf(address(this)));
1405         IERC20(uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
1406         
1407         MAX_t = 0;
1408         MAX_tx_on = true;
1409         
1410     }
1411     
1412     
1413     function manualswap() external {
1414 
1415         uint256 contractBalance = balanceOf(address(this));
1416         swapTokensForEth(contractBalance);
1417     }
1418     
1419     
1420     function withdrawEth() external onlyOwner {
1421         
1422         payable(msg.sender).transfer(address(this).balance);
1423     }
1424     
1425     
1426     
1427 }