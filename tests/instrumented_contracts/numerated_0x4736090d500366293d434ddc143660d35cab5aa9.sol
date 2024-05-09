1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
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
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Returns the amount of tokens in existence.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns the amount of tokens owned by `account`.
239      */
240     function balanceOf(address account) external view returns (uint256);
241 
242     /**
243      * @dev Moves `amount` tokens from the caller's account to `recipient`.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transfer(address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Returns the remaining number of tokens that `spender` will be
253      * allowed to spend on behalf of `owner` through {transferFrom}. This is
254      * zero by default.
255      *
256      * This value changes when {approve} or {transferFrom} are called.
257      */
258     function allowance(address owner, address spender) external view returns (uint256);
259 
260     /**
261      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * IMPORTANT: Beware that changing an allowance with this method brings the risk
266      * that someone may use both the old and the new allowance by unfortunate
267      * transaction ordering. One possible solution to mitigate this race
268      * condition is to first reduce the spender's allowance to 0 and set the
269      * desired value afterwards:
270      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address spender, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Moves `amount` tokens from `sender` to `recipient` using the
278      * allowance mechanism. `amount` is then deducted from the caller's
279      * allowance.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 // File: @openzeppelin/contracts/utils/math/Math.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.0 (utils/math/Math.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Standard math utilities missing in the Solidity language.
315  */
316 library Math {
317     /**
318      * @dev Returns the largest of two numbers.
319      */
320     function max(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a >= b ? a : b;
322     }
323 
324     /**
325      * @dev Returns the smallest of two numbers.
326      */
327     function min(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a < b ? a : b;
329     }
330 
331     /**
332      * @dev Returns the average of two numbers. The result is rounded towards
333      * zero.
334      */
335     function average(uint256 a, uint256 b) internal pure returns (uint256) {
336         // (a + b) / 2 can overflow.
337         return (a & b) + (a ^ b) / 2;
338     }
339 
340     /**
341      * @dev Returns the ceiling of the division of two numbers.
342      *
343      * This differs from standard division with `/` in that it rounds up instead
344      * of rounding down.
345      */
346     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
347         // (a + b - 1) / b can overflow on addition, so we distribute.
348         return a / b + (a % b == 0 ? 0 : 1);
349     }
350 }
351 
352 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
353 
354 
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @dev Contract module that helps prevent reentrant calls to a function.
360  *
361  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
362  * available, which can be applied to functions to make sure there are no nested
363  * (reentrant) calls to them.
364  *
365  * Note that because there is a single `nonReentrant` guard, functions marked as
366  * `nonReentrant` may not call one another. This can be worked around by making
367  * those functions `private`, and then adding `external` `nonReentrant` entry
368  * points to them.
369  *
370  * TIP: If you would like to learn more about reentrancy and alternative ways
371  * to protect against it, check out our blog post
372  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
373  */
374 abstract contract ReentrancyGuard {
375     // Booleans are more expensive than uint256 or any type that takes up a full
376     // word because each write operation emits an extra SLOAD to first read the
377     // slot's contents, replace the bits taken up by the boolean, and then write
378     // back. This is the compiler's defense against contract upgrades and
379     // pointer aliasing, and it cannot be disabled.
380 
381     // The values being non-zero value makes deployment a bit more expensive,
382     // but in exchange the refund on every call to nonReentrant will be lower in
383     // amount. Since refunds are capped to a percentage of the total
384     // transaction's gas, it is best to keep them low in cases like this one, to
385     // increase the likelihood of the full refund coming into effect.
386     uint256 private constant _NOT_ENTERED = 1;
387     uint256 private constant _ENTERED = 2;
388 
389     uint256 private _status;
390 
391     constructor() {
392         _status = _NOT_ENTERED;
393     }
394 
395     /**
396      * @dev Prevents a contract from calling itself, directly or indirectly.
397      * Calling a `nonReentrant` function from another `nonReentrant`
398      * function is not supported. It is possible to prevent this from happening
399      * by making the `nonReentrant` function external, and make it call a
400      * `private` function that does the actual work.
401      */
402     modifier nonReentrant() {
403         // On the first call to nonReentrant, _notEntered will be true
404         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
405 
406         // Any calls to nonReentrant after this point will fail
407         _status = _ENTERED;
408 
409         _;
410 
411         // By storing the original value once again, a refund is triggered (see
412         // https://eips.ethereum.org/EIPS/eip-2200)
413         _status = _NOT_ENTERED;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.0 (utils/structs/EnumerableSet.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Library for managing
426  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
427  * types.
428  *
429  * Sets have the following properties:
430  *
431  * - Elements are added, removed, and checked for existence in constant time
432  * (O(1)).
433  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
434  *
435  * ```
436  * contract Example {
437  *     // Add the library methods
438  *     using EnumerableSet for EnumerableSet.AddressSet;
439  *
440  *     // Declare a set state variable
441  *     EnumerableSet.AddressSet private mySet;
442  * }
443  * ```
444  *
445  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
446  * and `uint256` (`UintSet`) are supported.
447  */
448 library EnumerableSet {
449     // To implement this library for multiple types with as little code
450     // repetition as possible, we write it in terms of a generic Set type with
451     // bytes32 values.
452     // The Set implementation uses private functions, and user-facing
453     // implementations (such as AddressSet) are just wrappers around the
454     // underlying Set.
455     // This means that we can only create new EnumerableSets for types that fit
456     // in bytes32.
457 
458     struct Set {
459         // Storage of set values
460         bytes32[] _values;
461         // Position of the value in the `values` array, plus 1 because index 0
462         // means a value is not in the set.
463         mapping(bytes32 => uint256) _indexes;
464     }
465 
466     /**
467      * @dev Add a value to a set. O(1).
468      *
469      * Returns true if the value was added to the set, that is if it was not
470      * already present.
471      */
472     function _add(Set storage set, bytes32 value) private returns (bool) {
473         if (!_contains(set, value)) {
474             set._values.push(value);
475             // The value is stored at length-1, but we add 1 to all indexes
476             // and use 0 as a sentinel value
477             set._indexes[value] = set._values.length;
478             return true;
479         } else {
480             return false;
481         }
482     }
483 
484     /**
485      * @dev Removes a value from a set. O(1).
486      *
487      * Returns true if the value was removed from the set, that is if it was
488      * present.
489      */
490     function _remove(Set storage set, bytes32 value) private returns (bool) {
491         // We read and store the value's index to prevent multiple reads from the same storage slot
492         uint256 valueIndex = set._indexes[value];
493 
494         if (valueIndex != 0) {
495             // Equivalent to contains(set, value)
496             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
497             // the array, and then remove the last element (sometimes called as 'swap and pop').
498             // This modifies the order of the array, as noted in {at}.
499 
500             uint256 toDeleteIndex = valueIndex - 1;
501             uint256 lastIndex = set._values.length - 1;
502 
503             if (lastIndex != toDeleteIndex) {
504                 bytes32 lastvalue = set._values[lastIndex];
505 
506                 // Move the last value to the index where the value to delete is
507                 set._values[toDeleteIndex] = lastvalue;
508                 // Update the index for the moved value
509                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
510             }
511 
512             // Delete the slot where the moved value was stored
513             set._values.pop();
514 
515             // Delete the index for the deleted slot
516             delete set._indexes[value];
517 
518             return true;
519         } else {
520             return false;
521         }
522     }
523 
524     /**
525      * @dev Returns true if the value is in the set. O(1).
526      */
527     function _contains(Set storage set, bytes32 value) private view returns (bool) {
528         return set._indexes[value] != 0;
529     }
530 
531     /**
532      * @dev Returns the number of values on the set. O(1).
533      */
534     function _length(Set storage set) private view returns (uint256) {
535         return set._values.length;
536     }
537 
538     /**
539      * @dev Returns the value stored at position `index` in the set. O(1).
540      *
541      * Note that there are no guarantees on the ordering of values inside the
542      * array, and it may change when more values are added or removed.
543      *
544      * Requirements:
545      *
546      * - `index` must be strictly less than {length}.
547      */
548     function _at(Set storage set, uint256 index) private view returns (bytes32) {
549         return set._values[index];
550     }
551 
552     /**
553      * @dev Return the entire set in an array
554      *
555      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
556      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
557      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
558      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
559      */
560     function _values(Set storage set) private view returns (bytes32[] memory) {
561         return set._values;
562     }
563 
564     // Bytes32Set
565 
566     struct Bytes32Set {
567         Set _inner;
568     }
569 
570     /**
571      * @dev Add a value to a set. O(1).
572      *
573      * Returns true if the value was added to the set, that is if it was not
574      * already present.
575      */
576     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
577         return _add(set._inner, value);
578     }
579 
580     /**
581      * @dev Removes a value from a set. O(1).
582      *
583      * Returns true if the value was removed from the set, that is if it was
584      * present.
585      */
586     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
587         return _remove(set._inner, value);
588     }
589 
590     /**
591      * @dev Returns true if the value is in the set. O(1).
592      */
593     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
594         return _contains(set._inner, value);
595     }
596 
597     /**
598      * @dev Returns the number of values in the set. O(1).
599      */
600     function length(Bytes32Set storage set) internal view returns (uint256) {
601         return _length(set._inner);
602     }
603 
604     /**
605      * @dev Returns the value stored at position `index` in the set. O(1).
606      *
607      * Note that there are no guarantees on the ordering of values inside the
608      * array, and it may change when more values are added or removed.
609      *
610      * Requirements:
611      *
612      * - `index` must be strictly less than {length}.
613      */
614     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
615         return _at(set._inner, index);
616     }
617 
618     /**
619      * @dev Return the entire set in an array
620      *
621      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
622      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
623      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
624      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
625      */
626     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
627         return _values(set._inner);
628     }
629 
630     // AddressSet
631 
632     struct AddressSet {
633         Set _inner;
634     }
635 
636     /**
637      * @dev Add a value to a set. O(1).
638      *
639      * Returns true if the value was added to the set, that is if it was not
640      * already present.
641      */
642     function add(AddressSet storage set, address value) internal returns (bool) {
643         return _add(set._inner, bytes32(uint256(uint160(value))));
644     }
645 
646     /**
647      * @dev Removes a value from a set. O(1).
648      *
649      * Returns true if the value was removed from the set, that is if it was
650      * present.
651      */
652     function remove(AddressSet storage set, address value) internal returns (bool) {
653         return _remove(set._inner, bytes32(uint256(uint160(value))));
654     }
655 
656     /**
657      * @dev Returns true if the value is in the set. O(1).
658      */
659     function contains(AddressSet storage set, address value) internal view returns (bool) {
660         return _contains(set._inner, bytes32(uint256(uint160(value))));
661     }
662 
663     /**
664      * @dev Returns the number of values in the set. O(1).
665      */
666     function length(AddressSet storage set) internal view returns (uint256) {
667         return _length(set._inner);
668     }
669 
670     /**
671      * @dev Returns the value stored at position `index` in the set. O(1).
672      *
673      * Note that there are no guarantees on the ordering of values inside the
674      * array, and it may change when more values are added or removed.
675      *
676      * Requirements:
677      *
678      * - `index` must be strictly less than {length}.
679      */
680     function at(AddressSet storage set, uint256 index) internal view returns (address) {
681         return address(uint160(uint256(_at(set._inner, index))));
682     }
683 
684     /**
685      * @dev Return the entire set in an array
686      *
687      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
688      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
689      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
690      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
691      */
692     function values(AddressSet storage set) internal view returns (address[] memory) {
693         bytes32[] memory store = _values(set._inner);
694         address[] memory result;
695 
696         assembly {
697             result := store
698         }
699 
700         return result;
701     }
702 
703     // UintSet
704 
705     struct UintSet {
706         Set _inner;
707     }
708 
709     /**
710      * @dev Add a value to a set. O(1).
711      *
712      * Returns true if the value was added to the set, that is if it was not
713      * already present.
714      */
715     function add(UintSet storage set, uint256 value) internal returns (bool) {
716         return _add(set._inner, bytes32(value));
717     }
718 
719     /**
720      * @dev Removes a value from a set. O(1).
721      *
722      * Returns true if the value was removed from the set, that is if it was
723      * present.
724      */
725     function remove(UintSet storage set, uint256 value) internal returns (bool) {
726         return _remove(set._inner, bytes32(value));
727     }
728 
729     /**
730      * @dev Returns true if the value is in the set. O(1).
731      */
732     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
733         return _contains(set._inner, bytes32(value));
734     }
735 
736     /**
737      * @dev Returns the number of values on the set. O(1).
738      */
739     function length(UintSet storage set) internal view returns (uint256) {
740         return _length(set._inner);
741     }
742 
743     /**
744      * @dev Returns the value stored at position `index` in the set. O(1).
745      *
746      * Note that there are no guarantees on the ordering of values inside the
747      * array, and it may change when more values are added or removed.
748      *
749      * Requirements:
750      *
751      * - `index` must be strictly less than {length}.
752      */
753     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
754         return uint256(_at(set._inner, index));
755     }
756 
757     /**
758      * @dev Return the entire set in an array
759      *
760      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
761      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
762      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
763      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
764      */
765     function values(UintSet storage set) internal view returns (uint256[] memory) {
766         bytes32[] memory store = _values(set._inner);
767         uint256[] memory result;
768 
769         assembly {
770             result := store
771         }
772 
773         return result;
774     }
775 }
776 
777 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
778 
779 
780 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 /**
785  * @title ERC721 token receiver interface
786  * @dev Interface for any contract that wants to support safeTransfers
787  * from ERC721 asset contracts.
788  */
789 interface IERC721Receiver {
790     /**
791      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
792      * by `operator` from `from`, this function is called.
793      *
794      * It must return its Solidity selector to confirm the token transfer.
795      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
796      *
797      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
798      */
799     function onERC721Received(
800         address operator,
801         address from,
802         uint256 tokenId,
803         bytes calldata data
804     ) external returns (bytes4);
805 }
806 
807 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
808 
809 
810 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Interface of the ERC165 standard, as defined in the
816  * https://eips.ethereum.org/EIPS/eip-165[EIP].
817  *
818  * Implementers can declare support of contract interfaces, which can then be
819  * queried by others ({ERC165Checker}).
820  *
821  * For an implementation, see {ERC165}.
822  */
823 interface IERC165 {
824     /**
825      * @dev Returns true if this contract implements the interface defined by
826      * `interfaceId`. See the corresponding
827      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
828      * to learn more about how these ids are created.
829      *
830      * This function call must use less than 30 000 gas.
831      */
832     function supportsInterface(bytes4 interfaceId) external view returns (bool);
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 
843 /**
844  * @dev Required interface of an ERC721 compliant contract.
845  */
846 interface IERC721 is IERC165 {
847     /**
848      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
849      */
850     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
851 
852     /**
853      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
854      */
855     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
856 
857     /**
858      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
859      */
860     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
861 
862     /**
863      * @dev Returns the number of tokens in ``owner``'s account.
864      */
865     function balanceOf(address owner) external view returns (uint256 balance);
866 
867     /**
868      * @dev Returns the owner of the `tokenId` token.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function ownerOf(uint256 tokenId) external view returns (address owner);
875 
876     /**
877      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
878      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
879      *
880      * Requirements:
881      *
882      * - `from` cannot be the zero address.
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must exist and be owned by `from`.
885      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) external;
895 
896     /**
897      * @dev Transfers `tokenId` token from `from` to `to`.
898      *
899      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
907      *
908      * Emits a {Transfer} event.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) external;
915 
916     /**
917      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
918      * The approval is cleared when the token is transferred.
919      *
920      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
921      *
922      * Requirements:
923      *
924      * - The caller must own the token or be an approved operator.
925      * - `tokenId` must exist.
926      *
927      * Emits an {Approval} event.
928      */
929     function approve(address to, uint256 tokenId) external;
930 
931     /**
932      * @dev Returns the account approved for `tokenId` token.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      */
938     function getApproved(uint256 tokenId) external view returns (address operator);
939 
940     /**
941      * @dev Approve or remove `operator` as an operator for the caller.
942      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
943      *
944      * Requirements:
945      *
946      * - The `operator` cannot be the caller.
947      *
948      * Emits an {ApprovalForAll} event.
949      */
950     function setApprovalForAll(address operator, bool _approved) external;
951 
952     /**
953      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
954      *
955      * See {setApprovalForAll}
956      */
957     function isApprovedForAll(address owner, address operator) external view returns (bool);
958 
959     /**
960      * @dev Safely transfers `tokenId` token from `from` to `to`.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must exist and be owned by `from`.
967      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes calldata data
977     ) external;
978 }
979 
980 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
981 
982 
983 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
984 
985 pragma solidity ^0.8.0;
986 
987 
988 /**
989  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
990  * @dev See https://eips.ethereum.org/EIPS/eip-721
991  */
992 interface IERC721Enumerable is IERC721 {
993     /**
994      * @dev Returns the total amount of tokens stored by the contract.
995      */
996     function totalSupply() external view returns (uint256);
997 
998     /**
999      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1000      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1001      */
1002     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1003 
1004     /**
1005      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1006      * Use along with {totalSupply} to enumerate all tokens.
1007      */
1008     function tokenByIndex(uint256 index) external view returns (uint256);
1009 }
1010 
1011 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1012 
1013 
1014 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 // CAUTION
1019 // This version of SafeMath should only be used with Solidity 0.8 or later,
1020 // because it relies on the compiler's built in overflow checks.
1021 
1022 /**
1023  * @dev Wrappers over Solidity's arithmetic operations.
1024  *
1025  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1026  * now has built in overflow checking.
1027  */
1028 library SafeMath {
1029     /**
1030      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1031      *
1032      * _Available since v3.4._
1033      */
1034     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1035         unchecked {
1036             uint256 c = a + b;
1037             if (c < a) return (false, 0);
1038             return (true, c);
1039         }
1040     }
1041 
1042     /**
1043      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1044      *
1045      * _Available since v3.4._
1046      */
1047     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1048         unchecked {
1049             if (b > a) return (false, 0);
1050             return (true, a - b);
1051         }
1052     }
1053 
1054     /**
1055      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1056      *
1057      * _Available since v3.4._
1058      */
1059     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1060         unchecked {
1061             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1062             // benefit is lost if 'b' is also tested.
1063             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1064             if (a == 0) return (true, 0);
1065             uint256 c = a * b;
1066             if (c / a != b) return (false, 0);
1067             return (true, c);
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1077         unchecked {
1078             if (b == 0) return (false, 0);
1079             return (true, a / b);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1085      *
1086      * _Available since v3.4._
1087      */
1088     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1089         unchecked {
1090             if (b == 0) return (false, 0);
1091             return (true, a % b);
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns the addition of two unsigned integers, reverting on
1097      * overflow.
1098      *
1099      * Counterpart to Solidity's `+` operator.
1100      *
1101      * Requirements:
1102      *
1103      * - Addition cannot overflow.
1104      */
1105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1106         return a + b;
1107     }
1108 
1109     /**
1110      * @dev Returns the subtraction of two unsigned integers, reverting on
1111      * overflow (when the result is negative).
1112      *
1113      * Counterpart to Solidity's `-` operator.
1114      *
1115      * Requirements:
1116      *
1117      * - Subtraction cannot overflow.
1118      */
1119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1120         return a - b;
1121     }
1122 
1123     /**
1124      * @dev Returns the multiplication of two unsigned integers, reverting on
1125      * overflow.
1126      *
1127      * Counterpart to Solidity's `*` operator.
1128      *
1129      * Requirements:
1130      *
1131      * - Multiplication cannot overflow.
1132      */
1133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1134         return a * b;
1135     }
1136 
1137     /**
1138      * @dev Returns the integer division of two unsigned integers, reverting on
1139      * division by zero. The result is rounded towards zero.
1140      *
1141      * Counterpart to Solidity's `/` operator.
1142      *
1143      * Requirements:
1144      *
1145      * - The divisor cannot be zero.
1146      */
1147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1148         return a / b;
1149     }
1150 
1151     /**
1152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1153      * reverting when dividing by zero.
1154      *
1155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1156      * opcode (which leaves remaining gas untouched) while Solidity uses an
1157      * invalid opcode to revert (consuming all remaining gas).
1158      *
1159      * Requirements:
1160      *
1161      * - The divisor cannot be zero.
1162      */
1163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1164         return a % b;
1165     }
1166 
1167     /**
1168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1169      * overflow (when the result is negative).
1170      *
1171      * CAUTION: This function is deprecated because it requires allocating memory for the error
1172      * message unnecessarily. For custom revert reasons use {trySub}.
1173      *
1174      * Counterpart to Solidity's `-` operator.
1175      *
1176      * Requirements:
1177      *
1178      * - Subtraction cannot overflow.
1179      */
1180     function sub(
1181         uint256 a,
1182         uint256 b,
1183         string memory errorMessage
1184     ) internal pure returns (uint256) {
1185         unchecked {
1186             require(b <= a, errorMessage);
1187             return a - b;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1193      * division by zero. The result is rounded towards zero.
1194      *
1195      * Counterpart to Solidity's `/` operator. Note: this function uses a
1196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1197      * uses an invalid opcode to revert (consuming all remaining gas).
1198      *
1199      * Requirements:
1200      *
1201      * - The divisor cannot be zero.
1202      */
1203     function div(
1204         uint256 a,
1205         uint256 b,
1206         string memory errorMessage
1207     ) internal pure returns (uint256) {
1208         unchecked {
1209             require(b > 0, errorMessage);
1210             return a / b;
1211         }
1212     }
1213 
1214     /**
1215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1216      * reverting with custom message when dividing by zero.
1217      *
1218      * CAUTION: This function is deprecated because it requires allocating memory for the error
1219      * message unnecessarily. For custom revert reasons use {tryMod}.
1220      *
1221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1222      * opcode (which leaves remaining gas untouched) while Solidity uses an
1223      * invalid opcode to revert (consuming all remaining gas).
1224      *
1225      * Requirements:
1226      *
1227      * - The divisor cannot be zero.
1228      */
1229     function mod(
1230         uint256 a,
1231         uint256 b,
1232         string memory errorMessage
1233     ) internal pure returns (uint256) {
1234         unchecked {
1235             require(b > 0, errorMessage);
1236             return a % b;
1237         }
1238     }
1239 }
1240 
1241 // File: @openzeppelin/contracts/utils/Context.sol
1242 
1243 
1244 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
1245 
1246 pragma solidity ^0.8.0;
1247 
1248 /**
1249  * @dev Provides information about the current execution context, including the
1250  * sender of the transaction and its data. While these are generally available
1251  * via msg.sender and msg.data, they should not be accessed in such a direct
1252  * manner, since when dealing with meta-transactions the account sending and
1253  * paying for execution may not be the actual sender (as far as an application
1254  * is concerned).
1255  *
1256  * This contract is only required for intermediate, library-like contracts.
1257  */
1258 abstract contract Context {
1259     function _msgSender() internal view virtual returns (address) {
1260         return msg.sender;
1261     }
1262 
1263     function _msgData() internal view virtual returns (bytes calldata) {
1264         return msg.data;
1265     }
1266 }
1267 
1268 // File: @openzeppelin/contracts/security/Pausable.sol
1269 
1270 
1271 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @dev Contract module which allows children to implement an emergency stop
1278  * mechanism that can be triggered by an authorized account.
1279  *
1280  * This module is used through inheritance. It will make available the
1281  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1282  * the functions of your contract. Note that they will not be pausable by
1283  * simply including this module, only once the modifiers are put in place.
1284  */
1285 abstract contract Pausable is Context {
1286     /**
1287      * @dev Emitted when the pause is triggered by `account`.
1288      */
1289     event Paused(address account);
1290 
1291     /**
1292      * @dev Emitted when the pause is lifted by `account`.
1293      */
1294     event Unpaused(address account);
1295 
1296     bool private _paused;
1297 
1298     /**
1299      * @dev Initializes the contract in unpaused state.
1300      */
1301     constructor() {
1302         _paused = false;
1303     }
1304 
1305     /**
1306      * @dev Returns true if the contract is paused, and false otherwise.
1307      */
1308     function paused() public view virtual returns (bool) {
1309         return _paused;
1310     }
1311 
1312     /**
1313      * @dev Modifier to make a function callable only when the contract is not paused.
1314      *
1315      * Requirements:
1316      *
1317      * - The contract must not be paused.
1318      */
1319     modifier whenNotPaused() {
1320         require(!paused(), "Pausable: paused");
1321         _;
1322     }
1323 
1324     /**
1325      * @dev Modifier to make a function callable only when the contract is paused.
1326      *
1327      * Requirements:
1328      *
1329      * - The contract must be paused.
1330      */
1331     modifier whenPaused() {
1332         require(paused(), "Pausable: not paused");
1333         _;
1334     }
1335 
1336     /**
1337      * @dev Triggers stopped state.
1338      *
1339      * Requirements:
1340      *
1341      * - The contract must not be paused.
1342      */
1343     function _pause() internal virtual whenNotPaused {
1344         _paused = true;
1345         emit Paused(_msgSender());
1346     }
1347 
1348     /**
1349      * @dev Returns to normal state.
1350      *
1351      * Requirements:
1352      *
1353      * - The contract must be paused.
1354      */
1355     function _unpause() internal virtual whenPaused {
1356         _paused = false;
1357         emit Unpaused(_msgSender());
1358     }
1359 }
1360 
1361 // File: @openzeppelin/contracts/access/Ownable.sol
1362 
1363 
1364 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 
1369 /**
1370  * @dev Contract module which provides a basic access control mechanism, where
1371  * there is an account (an owner) that can be granted exclusive access to
1372  * specific functions.
1373  *
1374  * By default, the owner account will be the one that deploys the contract. This
1375  * can later be changed with {transferOwnership}.
1376  *
1377  * This module is used through inheritance. It will make available the modifier
1378  * `onlyOwner`, which can be applied to your functions to restrict their use to
1379  * the owner.
1380  */
1381 abstract contract Ownable is Context {
1382     address private _owner;
1383 
1384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1385 
1386     /**
1387      * @dev Initializes the contract setting the deployer as the initial owner.
1388      */
1389     constructor() {
1390         _transferOwnership(_msgSender());
1391     }
1392 
1393     /**
1394      * @dev Returns the address of the current owner.
1395      */
1396     function owner() public view virtual returns (address) {
1397         return _owner;
1398     }
1399 
1400     /**
1401      * @dev Throws if called by any account other than the owner.
1402      */
1403     modifier onlyOwner() {
1404         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1405         _;
1406     }
1407 
1408     /**
1409      * @dev Leaves the contract without owner. It will not be possible to call
1410      * `onlyOwner` functions anymore. Can only be called by the current owner.
1411      *
1412      * NOTE: Renouncing ownership will leave the contract without an owner,
1413      * thereby removing any functionality that is only available to the owner.
1414      */
1415     function renounceOwnership() public virtual onlyOwner {
1416         _transferOwnership(address(0));
1417     }
1418 
1419     /**
1420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1421      * Can only be called by the current owner.
1422      */
1423     function transferOwnership(address newOwner) public virtual onlyOwner {
1424         require(newOwner != address(0), "Ownable: new owner is the zero address");
1425         _transferOwnership(newOwner);
1426     }
1427 
1428     /**
1429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1430      * Internal function without access restriction.
1431      */
1432     function _transferOwnership(address newOwner) internal virtual {
1433         address oldOwner = _owner;
1434         _owner = newOwner;
1435         emit OwnershipTransferred(oldOwner, newOwner);
1436     }
1437 }
1438 
1439 // File: Staking.sol
1440 
1441 
1442 pragma solidity ^0.8.2;
1443 
1444 
1445 
1446 
1447 
1448 
1449 
1450 
1451 
1452 
1453 
1454 
1455 
1456 contract PandaStaking is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1457     using EnumerableSet for EnumerableSet.UintSet;
1458 
1459     //addresses
1460     address public stakingDestinationAddress;
1461     address public erc20Address;
1462 
1463     //uint256's
1464     uint256 public expiration = block.number + 21900000; // 21900000 = 6000 blocks/day * 10 years
1465     //rate governs how often you receive your token
1466     // 100 $BAMBOO PER DAY
1467     // n Blocks per day = 6000, Token Decimal = 18
1468     // Rate = 16666666666666666
1469     // 108 $BAMBOO PER DAY
1470     // Rate = 18000000000000000
1471 
1472     uint256 public rate = 0.0166666666666666 * 10**18;
1473     uint256 public genesisLegendaryRate = 0.018 * 10**18;
1474 
1475     uint256 [] public legendaryIds = [1675, 394, 1427, 4942, 4000, 4127, 4979, 8501];
1476 
1477     // mappings
1478     mapping(address => EnumerableSet.UintSet) private _deposits;
1479     mapping(address => mapping(uint256 => uint256)) public _depositBlocks;
1480     mapping(uint256 => bool) public initialBambooClaimed;
1481 
1482 
1483 
1484     constructor() {
1485     stakingDestinationAddress = 0x24998f0A028d197413EF57C7810f7a5EF8B9FA55;
1486     erc20Address = 0x91287d7013f1087fB880C3b36bE4A28948d6C751;
1487 
1488     _pause();
1489     }
1490 
1491     function pause() public onlyOwner {
1492         _pause();
1493     }
1494 
1495     function unpause() public onlyOwner {
1496         _unpause();
1497     }
1498 
1499 /* STAKING MECHANICS */
1500 
1501     // Set a multiplier for how many tokens to earn each time a block passes.
1502         // 100 $BAMBOO PER DAY
1503         // n Blocks per day = 6000, Token Decimal = 18
1504         // Rate = 16666666666666666
1505         // 108 $BAMBOO PER DAY
1506         // Rate = 18000000000000000
1507     function setRate(uint256 _rate) public onlyOwner() {
1508       rate = _rate;
1509     }
1510 
1511     function setGenesisLegendaryRate(uint256 _rate) public onlyOwner() {
1512       genesisLegendaryRate = _rate;
1513     }
1514 
1515     function setStakingDestinationAddress(address _address) public onlyOwner() {
1516       stakingDestinationAddress = _address;
1517     }
1518 
1519     function setERC20Address(address _address) public onlyOwner() {
1520       erc20Address = _address;
1521     }
1522 
1523     // Set this to a block to disable the ability to continue accruing tokens past that block number.
1524     function setExpiration(uint256 _expiration) public onlyOwner() {
1525       expiration = block.number + _expiration;
1526     }
1527 
1528     //check deposit amount. - Tested
1529     function depositsOf(address account) external view returns (uint256[] memory) {
1530       EnumerableSet.UintSet storage depositSet = _deposits[account];
1531       uint256[] memory tokenIds = new uint256[] (depositSet.length());
1532 
1533       for (uint256 i; i < depositSet.length(); i++) {
1534         tokenIds[i] = depositSet.at(i);
1535       }
1536 
1537       return tokenIds;
1538     }
1539 
1540     function isGenesisLegendary(uint256 tokenId) public view returns (bool) {
1541       if (tokenId >= 1 && tokenId <= 888 )
1542       {
1543         return true;
1544       }
1545 
1546       for (uint256 i; i < legendaryIds.length; i++)
1547       {
1548         if (tokenId == legendaryIds[i])
1549         {
1550            return true;
1551         }
1552       }
1553 
1554       return false;
1555     }
1556 
1557     //reward amount by address/tokenIds[] - Tested
1558     function calculateRewards(address account, uint256[] memory tokenIds) public view returns (uint256[] memory rewards) {
1559       rewards = new uint256[](tokenIds.length);
1560       uint256 rewardRate = rate;
1561 
1562       for (uint256 i; i < tokenIds.length; i++) {
1563         uint256 tokenId = tokenIds[i];
1564 
1565         if (isGenesisLegendary(tokenId))
1566         {
1567           rewardRate = genesisLegendaryRate;
1568         }
1569 
1570         rewards[i] = rewardRate * (_deposits[account].contains(tokenId) ? 1 : 0) * (Math.min(block.number, expiration) - _depositBlocks[account][tokenId]);
1571 
1572       }
1573 
1574       return rewards;
1575     }
1576 
1577     //reward amount by address/tokenId - Tested
1578     function calculateReward(address account, uint256 tokenId) public view returns (uint256) {
1579       require(Math.min(block.number, expiration) > _depositBlocks[account][tokenId], "Invalid blocks");
1580       uint256 rewardRate = rate;
1581 
1582       if (isGenesisLegendary(tokenId))
1583       {
1584         rewardRate = genesisLegendaryRate;
1585       }
1586 
1587       return rewardRate * (_deposits[account].contains(tokenId) ? 1 : 0) * (Math.min(block.number, expiration) - _depositBlocks[account][tokenId]);
1588     }
1589 
1590     //reward claim function - Tested
1591     function claimRewards(uint256[] calldata tokenIds) public whenNotPaused {
1592       uint256 reward;
1593       uint256 blockCur = Math.min(block.number, expiration);
1594 
1595       for (uint256 i; i < tokenIds.length; i++) {
1596         reward += calculateReward(msg.sender, tokenIds[i]);
1597         _depositBlocks[msg.sender][tokenIds[i]] = blockCur;
1598       }
1599 
1600       if (reward > 0) {
1601         IERC20(erc20Address).transfer(msg.sender, reward);
1602       }
1603 
1604     }
1605 
1606 
1607 
1608     //deposit function.  - Tested
1609     function deposit(uint256[] calldata tokenIds) external whenNotPaused {
1610         require(msg.sender != stakingDestinationAddress, "Invalid address");
1611 
1612         require(IERC721(stakingDestinationAddress).isApprovedForAll(msg.sender, address(this)), "You must first approve your ERC721 tokens to deposit");
1613 
1614         claimRewards(tokenIds);
1615 
1616         for (uint256 i; i < tokenIds.length; i++) {
1617             IERC721(stakingDestinationAddress).safeTransferFrom(msg.sender,address(this),tokenIds[i],"");
1618             _deposits[msg.sender].add(tokenIds[i]);
1619         }
1620     }
1621 
1622     //withdrawal function. Tested
1623     function withdraw(uint256[] calldata tokenIds) external whenNotPaused nonReentrant() {
1624         claimRewards(tokenIds);
1625         for (uint256 i; i < tokenIds.length; i++) {
1626             require( _deposits[msg.sender].contains(tokenIds[i]),"Staking: token not deposited");
1627             _deposits[msg.sender].remove(tokenIds[i]);
1628             IERC721(stakingDestinationAddress).safeTransferFrom(address(this), msg.sender,tokenIds[i],"");
1629         }
1630     }
1631 
1632     //Claim initial BAMBOO (10 days worth)
1633     function claimInitialBamboo(uint256[] calldata tokenIds) external whenNotPaused nonReentrant() {
1634       uint256 totalToClaim = 0;
1635       uint256 bambooAmountTenDays = 1000 * 10**18;
1636       uint256 genesisLegendaryAmountTenDays = 1080 * 10**18;
1637 
1638       for (uint256 i = 0; i < tokenIds.length; i++) {
1639         require(!initialBambooClaimed[tokenIds[i]], "Initial bamboo already claimed");
1640         require(msg.sender == IERC721(stakingDestinationAddress).ownerOf(tokenIds[i]), "Not owner of panda");
1641 
1642         if(isGenesisLegendary(tokenIds[i]))
1643         {
1644           totalToClaim += genesisLegendaryAmountTenDays;
1645         } else {
1646           totalToClaim += bambooAmountTenDays;
1647         }
1648 
1649         initialBambooClaimed[tokenIds[i]] = true;
1650       }
1651 
1652       IERC20(erc20Address).transfer(msg.sender, totalToClaim);
1653     }
1654 
1655     //withdrawal function.
1656     function withdrawTokens() external onlyOwner {
1657         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1658         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
1659     }
1660 
1661     function onERC721Received(address,address,uint256,bytes calldata) external pure override returns (bytes4) {
1662         return IERC721Receiver.onERC721Received.selector;
1663     }
1664 
1665 }