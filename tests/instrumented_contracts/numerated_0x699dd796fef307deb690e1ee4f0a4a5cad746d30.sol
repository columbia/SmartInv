1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 contract OperatorFilterer {
5     error OperatorNotAllowed(address operator);
6 
7     IOperatorFilterRegistry constant operatorFilterRegistry =
8         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
9 
10     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
11         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
12         // will not revert, but the contract will need to be registered with the registry once it is deployed in
13         // order for the modifier to filter addresses.
14         if (address(operatorFilterRegistry).code.length > 0) {
15             if (subscribe) {
16                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
17             } else {
18                 if (subscriptionOrRegistrantToCopy != address(0)) {
19                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
20                 } else {
21                     operatorFilterRegistry.register(address(this));
22                 }
23             }
24         }
25     }
26 
27     modifier onlyAllowedOperator() virtual {
28         // Check registry code length to facilitate testing in environments without a deployed registry.
29         if (address(operatorFilterRegistry).code.length > 0) {
30             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
31                 revert OperatorNotAllowed(msg.sender);
32             }
33         }
34         _;
35     }
36 }
37 
38 interface IOperatorFilterRegistry {
39     function isOperatorAllowed(address registrant, address operator) external returns (bool);
40     function register(address registrant) external;
41     function registerAndSubscribe(address registrant, address subscription) external;
42     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
43     function updateOperator(address registrant, address operator, bool filtered) external;
44     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
45     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
46     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
47     function subscribe(address registrant, address registrantToSubscribe) external;
48     function unsubscribe(address registrant, bool copyExistingEntries) external;
49     function subscriptionOf(address addr) external returns (address registrant);
50     function subscribers(address registrant) external returns (address[] memory);
51     function subscriberAt(address registrant, uint256 index) external returns (address);
52     function copyEntriesOf(address registrant, address registrantToCopy) external;
53     function isOperatorFiltered(address registrant, address operator) external returns (bool);
54     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
55     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
56     function filteredOperators(address addr) external returns (address[] memory);
57     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
58     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
59     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
60     function isRegistered(address addr) external returns (bool);
61     function codeHashOf(address addr) external returns (bytes32);
62 }
63 
64 library EnumerableSet {
65     // To implement this library for multiple types with as little code
66     // repetition as possible, we write it in terms of a generic Set type with
67     // bytes32 values.
68     // The Set implementation uses private functions, and user-facing
69     // implementations (such as AddressSet) are just wrappers around the
70     // underlying Set.
71     // This means that we can only create new EnumerableSets for types that fit
72     // in bytes32.
73 
74     struct Set {
75         // Storage of set values
76         bytes32[] _values;
77         // Position of the value in the `values` array, plus 1 because index 0
78         // means a value is not in the set.
79         mapping(bytes32 => uint256) _indexes;
80     }
81 
82     /**
83      * @dev Add a value to a set. O(1).
84      *
85      * Returns true if the value was added to the set, that is if it was not
86      * already present.
87      */
88     function _add(Set storage set, bytes32 value) private returns (bool) {
89         if (!_contains(set, value)) {
90             set._values.push(value);
91             // The value is stored at length-1, but we add 1 to all indexes
92             // and use 0 as a sentinel value
93             set._indexes[value] = set._values.length;
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     /**
101      * @dev Removes a value from a set. O(1).
102      *
103      * Returns true if the value was removed from the set, that is if it was
104      * present.
105      */
106     function _remove(Set storage set, bytes32 value) private returns (bool) {
107         // We read and store the value's index to prevent multiple reads from the same storage slot
108         uint256 valueIndex = set._indexes[value];
109 
110         if (valueIndex != 0) {
111             // Equivalent to contains(set, value)
112             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
113             // the array, and then remove the last element (sometimes called as 'swap and pop').
114             // This modifies the order of the array, as noted in {at}.
115 
116             uint256 toDeleteIndex = valueIndex - 1;
117             uint256 lastIndex = set._values.length - 1;
118 
119             if (lastIndex != toDeleteIndex) {
120                 bytes32 lastValue = set._values[lastIndex];
121 
122                 // Move the last value to the index where the value to delete is
123                 set._values[toDeleteIndex] = lastValue;
124                 // Update the index for the moved value
125                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
126             }
127 
128             // Delete the slot where the moved value was stored
129             set._values.pop();
130 
131             // Delete the index for the deleted slot
132             delete set._indexes[value];
133 
134             return true;
135         } else {
136             return false;
137         }
138     }
139 
140     /**
141      * @dev Returns true if the value is in the set. O(1).
142      */
143     function _contains(Set storage set, bytes32 value) private view returns (bool) {
144         return set._indexes[value] != 0;
145     }
146 
147     /**
148      * @dev Returns the number of values on the set. O(1).
149      */
150     function _length(Set storage set) private view returns (uint256) {
151         return set._values.length;
152     }
153 
154     /**
155      * @dev Returns the value stored at position `index` in the set. O(1).
156      *
157      * Note that there are no guarantees on the ordering of values inside the
158      * array, and it may change when more values are added or removed.
159      *
160      * Requirements:
161      *
162      * - `index` must be strictly less than {length}.
163      */
164     function _at(Set storage set, uint256 index) private view returns (bytes32) {
165         return set._values[index];
166     }
167 
168     /**
169      * @dev Return the entire set in an array
170      *
171      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
172      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
173      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
174      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
175      */
176     function _values(Set storage set) private view returns (bytes32[] memory) {
177         return set._values;
178     }
179 
180     // Bytes32Set
181 
182     struct Bytes32Set {
183         Set _inner;
184     }
185 
186     /**
187      * @dev Add a value to a set. O(1).
188      *
189      * Returns true if the value was added to the set, that is if it was not
190      * already present.
191      */
192     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
193         return _add(set._inner, value);
194     }
195 
196     /**
197      * @dev Removes a value from a set. O(1).
198      *
199      * Returns true if the value was removed from the set, that is if it was
200      * present.
201      */
202     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
203         return _remove(set._inner, value);
204     }
205 
206     /**
207      * @dev Returns true if the value is in the set. O(1).
208      */
209     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
210         return _contains(set._inner, value);
211     }
212 
213     /**
214      * @dev Returns the number of values in the set. O(1).
215      */
216     function length(Bytes32Set storage set) internal view returns (uint256) {
217         return _length(set._inner);
218     }
219 
220     /**
221      * @dev Returns the value stored at position `index` in the set. O(1).
222      *
223      * Note that there are no guarantees on the ordering of values inside the
224      * array, and it may change when more values are added or removed.
225      *
226      * Requirements:
227      *
228      * - `index` must be strictly less than {length}.
229      */
230     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
231         return _at(set._inner, index);
232     }
233 
234     /**
235      * @dev Return the entire set in an array
236      *
237      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
238      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
239      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
240      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
241      */
242     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
243         bytes32[] memory store = _values(set._inner);
244         bytes32[] memory result;
245 
246         /// @solidity memory-safe-assembly
247         assembly {
248             result := store
249         }
250 
251         return result;
252     }
253 
254     // AddressSet
255 
256     struct AddressSet {
257         Set _inner;
258     }
259 
260     /**
261      * @dev Add a value to a set. O(1).
262      *
263      * Returns true if the value was added to the set, that is if it was not
264      * already present.
265      */
266     function add(AddressSet storage set, address value) internal returns (bool) {
267         return _add(set._inner, bytes32(uint256(uint160(value))));
268     }
269 
270     /**
271      * @dev Removes a value from a set. O(1).
272      *
273      * Returns true if the value was removed from the set, that is if it was
274      * present.
275      */
276     function remove(AddressSet storage set, address value) internal returns (bool) {
277         return _remove(set._inner, bytes32(uint256(uint160(value))));
278     }
279 
280     /**
281      * @dev Returns true if the value is in the set. O(1).
282      */
283     function contains(AddressSet storage set, address value) internal view returns (bool) {
284         return _contains(set._inner, bytes32(uint256(uint160(value))));
285     }
286 
287     /**
288      * @dev Returns the number of values in the set. O(1).
289      */
290     function length(AddressSet storage set) internal view returns (uint256) {
291         return _length(set._inner);
292     }
293 
294     /**
295      * @dev Returns the value stored at position `index` in the set. O(1).
296      *
297      * Note that there are no guarantees on the ordering of values inside the
298      * array, and it may change when more values are added or removed.
299      *
300      * Requirements:
301      *
302      * - `index` must be strictly less than {length}.
303      */
304     function at(AddressSet storage set, uint256 index) internal view returns (address) {
305         return address(uint160(uint256(_at(set._inner, index))));
306     }
307 
308     /**
309      * @dev Return the entire set in an array
310      *
311      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
312      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
313      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
314      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
315      */
316     function values(AddressSet storage set) internal view returns (address[] memory) {
317         bytes32[] memory store = _values(set._inner);
318         address[] memory result;
319 
320         /// @solidity memory-safe-assembly
321         assembly {
322             result := store
323         }
324 
325         return result;
326     }
327 
328     // UintSet
329 
330     struct UintSet {
331         Set _inner;
332     }
333 
334     /**
335      * @dev Add a value to a set. O(1).
336      *
337      * Returns true if the value was added to the set, that is if it was not
338      * already present.
339      */
340     function add(UintSet storage set, uint256 value) internal returns (bool) {
341         return _add(set._inner, bytes32(value));
342     }
343 
344     /**
345      * @dev Removes a value from a set. O(1).
346      *
347      * Returns true if the value was removed from the set, that is if it was
348      * present.
349      */
350     function remove(UintSet storage set, uint256 value) internal returns (bool) {
351         return _remove(set._inner, bytes32(value));
352     }
353 
354     /**
355      * @dev Returns true if the value is in the set. O(1).
356      */
357     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
358         return _contains(set._inner, bytes32(value));
359     }
360 
361     /**
362      * @dev Returns the number of values in the set. O(1).
363      */
364     function length(UintSet storage set) internal view returns (uint256) {
365         return _length(set._inner);
366     }
367 
368     /**
369      * @dev Returns the value stored at position `index` in the set. O(1).
370      *
371      * Note that there are no guarantees on the ordering of values inside the
372      * array, and it may change when more values are added or removed.
373      *
374      * Requirements:
375      *
376      * - `index` must be strictly less than {length}.
377      */
378     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
379         return uint256(_at(set._inner, index));
380     }
381 
382     /**
383      * @dev Return the entire set in an array
384      *
385      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
386      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
387      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
388      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
389      */
390     function values(UintSet storage set) internal view returns (uint256[] memory) {
391         bytes32[] memory store = _values(set._inner);
392         uint256[] memory result;
393 
394         /// @solidity memory-safe-assembly
395         assembly {
396             result := store
397         }
398 
399         return result;
400     }
401 }
402 
403 contract DefaultOperatorFilterer is OperatorFilterer {
404     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
405 
406     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
407 }
408 
409 /*                                      
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      *
430      * [IMPORTANT]
431      * ====
432      * You shouldn't rely on `isContract` to protect against flash loan attacks!
433      *
434      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
435      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
436      * constructor.
437      * ====
438      */
439     function isContract(address account) internal view returns (bool) {
440         // This method relies on extcodesize/address.code.length, which returns 0
441         // for contracts in construction, since the code is only stored at the end
442         // of the constructor execution.
443 
444         return account.code.length > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         (bool success, ) = recipient.call{value: amount}("");
467         require(success, "Address: unable to send value, recipient may have reverted");
468     }
469 
470     /**
471      * @dev Performs a Solidity function call using a low level `call`. A
472      * plain `call` is an unsafe replacement for a function call: use this
473      * function instead.
474      *
475      * If `target` reverts with a revert reason, it is bubbled up by this
476      * function (like regular Solidity function calls).
477      *
478      * Returns the raw returned data. To convert to the expected return value,
479      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
480      *
481      * Requirements:
482      *
483      * - `target` must be a contract.
484      * - calling `target` with `data` must not revert.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionCall(target, data, "Address: low-level call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
494      * `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, 0, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but also transferring `value` wei to `target`.
509      *
510      * Requirements:
511      *
512      * - the calling contract must have an ETH balance of at least `value`.
513      * - the called Solidity function must be `payable`.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value
521     ) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         require(address(this).balance >= value, "Address: insufficient balance for call");
538         require(isContract(target), "Address: call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.call{value: value}(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
551         return functionStaticCall(target, data, "Address: low-level static call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal view returns (bytes memory) {
565         require(isContract(target), "Address: static call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.staticcall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
578         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(isContract(target), "Address: delegate call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
600      * revert reason using the provided one.
601      *
602      * _Available since v4.3._
603      */
604     function verifyCallResult(
605         bool success,
606         bytes memory returndata,
607         string memory errorMessage
608     ) internal pure returns (bytes memory) {
609         if (success) {
610             return returndata;
611         } else {
612             // Look for revert reason and bubble it up if present
613             if (returndata.length > 0) {
614                 // The easiest way to bubble the revert reason is using memory via assembly
615                 /// @solidity memory-safe-assembly
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert(errorMessage);
622             }
623         }
624     }
625 }
626 
627 abstract contract Context {
628     function _msgSender() internal view virtual returns (address) {
629         return msg.sender;
630     }
631 
632     function _msgData() internal view virtual returns (bytes calldata) {
633         return msg.data;
634     }
635 }
636 
637 interface IERC721A {
638     /**
639      * The caller must own the token or be an approved operator.
640      */
641     error ApprovalCallerNotOwnerNorApproved();
642 
643     /**
644      * The token does not exist.
645      */
646     error ApprovalQueryForNonexistentToken();
647 
648     /**
649      * The caller cannot approve to their own address.
650      */
651     error ApproveToCaller();
652 
653     /**
654      * Cannot query the balance for the zero address.
655      */
656     error BalanceQueryForZeroAddress();
657 
658     /**
659      * Cannot mint to the zero address.
660      */
661     error MintToZeroAddress();
662 
663     /**
664      * The quantity of tokens minted must be more than zero.
665      */
666     error MintZeroQuantity();
667 
668     /**
669      * The token does not exist.
670      */
671     error OwnerQueryForNonexistentToken();
672 
673     /**
674      * The caller must own the token or be an approved operator.
675      */
676     error TransferCallerNotOwnerNorApproved();
677 
678     /**
679      * The token must be owned by `from`.
680      */
681     error TransferFromIncorrectOwner();
682 
683     /**
684      * Cannot safely transfer to a contract that does not implement the
685      * ERC721Receiver interface.
686      */
687     error TransferToNonERC721ReceiverImplementer();
688 
689     /**
690      * Cannot transfer to the zero address.
691      */
692     error TransferToZeroAddress();
693 
694     /**
695      * The token does not exist.
696      */
697     error URIQueryForNonexistentToken();
698 
699     /**
700      * The `quantity` minted with ERC2309 exceeds the safety limit.
701      */
702     error MintERC2309QuantityExceedsLimit();
703 
704     /**
705      * The `extraData` cannot be set on an unintialized ownership slot.
706      */
707     error OwnershipNotInitializedForExtraData();
708 
709     // =============================================================
710     //                            STRUCTS
711     // =============================================================
712 
713     struct TokenOwnership {
714         // The address of the owner.
715         address addr;
716         // Stores the start time of ownership with minimal overhead for tokenomics.
717         uint64 startTimestamp;
718         // Whether the token has been burned.
719         bool burned;
720         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
721         uint24 extraData;
722     }
723 
724     // =============================================================
725     //                         TOKEN COUNTERS
726     // =============================================================
727 
728     /**
729      * @dev Returns the total number of tokens in existence.
730      * Burned tokens will reduce the count.
731      * To get the total number of tokens minted, please see {_totalMinted}.
732      */
733     function totalSupply() external view returns (uint256);
734 
735     // =============================================================
736     //                            IERC165
737     // =============================================================
738 
739     /**
740      * @dev Returns true if this contract implements the interface defined by
741      * `interfaceId`. See the corresponding
742      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
743      * to learn more about how these ids are created.
744      *
745      * This function call must use less than 30000 gas.
746      */
747     function supportsInterface(bytes4 interfaceId) external view returns (bool);
748 
749     // =============================================================
750     //                            IERC721
751     // =============================================================
752 
753     /**
754      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
755      */
756     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
757 
758     /**
759      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
760      */
761     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables or disables
765      * (`approved`) `operator` to manage all of its assets.
766      */
767     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
768 
769     /**
770      * @dev Returns the number of tokens in `owner`'s account.
771      */
772     function balanceOf(address owner) external view returns (uint256 balance);
773 
774     /**
775      * @dev Returns the owner of the `tokenId` token.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      */
781     function ownerOf(uint256 tokenId) external view returns (address owner);
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`,
785      * checking first that contract recipients are aware of the ERC721 protocol
786      * to prevent tokens from being forever locked.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If the caller is not `from`, it must be have been allowed to move
794      * this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement
796      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes calldata data
805     ) external;
806 
807     /**
808      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) external;
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *
819      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
820      * whenever possible.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token
828      * by either {approve} or {setApprovalForAll}.
829      *
830      * Emits a {Transfer} event.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) external;
837 
838     /**
839      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
840      * The approval is cleared when the token is transferred.
841      *
842      * Only a single account can be approved at a time, so approving the
843      * zero address clears previous approvals.
844      *
845      * Requirements:
846      *
847      * - The caller must own the token or be an approved operator.
848      * - `tokenId` must exist.
849      *
850      * Emits an {Approval} event.
851      */
852     function approve(address to, uint256 tokenId) external;
853 
854     /**
855      * @dev Approve or remove `operator` as an operator for the caller.
856      * Operators can call {transferFrom} or {safeTransferFrom}
857      * for any token owned by the caller.
858      *
859      * Requirements:
860      *
861      * - The `operator` cannot be the caller.
862      *
863      * Emits an {ApprovalForAll} event.
864      */
865     function setApprovalForAll(address operator, bool _approved) external;
866 
867     /**
868      * @dev Returns the account approved for `tokenId` token.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function getApproved(uint256 tokenId) external view returns (address operator);
875 
876     /**
877      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
878      *
879      * See {setApprovalForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) external view returns (bool);
882 
883     // =============================================================
884     //                        IERC721Metadata
885     // =============================================================
886 
887     /**
888      * @dev Returns the token collection name.
889      */
890     function name() external view returns (string memory);
891 
892     /**
893      * @dev Returns the token collection symbol.
894      */
895     function symbol() external view returns (string memory);
896 
897     /**
898      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
899      */
900     function tokenURI(uint256 tokenId) external view returns (string memory);
901 
902     // =============================================================
903     //                           IERC2309
904     // =============================================================
905 
906     /**
907      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
908      * (inclusive) is transferred from `from` to `to`, as defined in the
909      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
910      *
911      * See {_mintERC2309} for more details.
912      */
913     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
914 }
915 
916 library Strings {
917     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
918     uint8 private constant _ADDRESS_LENGTH = 20;
919 
920     /**
921      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
922      */
923     function toString(uint256 value) internal pure returns (string memory) {
924         // Inspired by OraclizeAPI's implementation - MIT licence
925         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
926 
927         if (value == 0) {
928             return "0";
929         }
930         uint256 temp = value;
931         uint256 digits;
932         while (temp != 0) {
933             digits++;
934             temp /= 10;
935         }
936         bytes memory buffer = new bytes(digits);
937         while (value != 0) {
938             digits -= 1;
939             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
940             value /= 10;
941         }
942         return string(buffer);
943     }
944 
945     /**
946      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
947      */
948     function toHexString(uint256 value) internal pure returns (string memory) {
949         if (value == 0) {
950             return "0x00";
951         }
952         uint256 temp = value;
953         uint256 length = 0;
954         while (temp != 0) {
955             length++;
956             temp >>= 8;
957         }
958         return toHexString(value, length);
959     }
960 
961     /**
962      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
963      */
964     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
965         bytes memory buffer = new bytes(2 * length + 2);
966         buffer[0] = "0";
967         buffer[1] = "x";
968         for (uint256 i = 2 * length + 1; i > 1; --i) {
969             buffer[i] = _HEX_SYMBOLS[value & 0xf];
970             value >>= 4;
971         }
972         require(value == 0, "Strings: hex length insufficient");
973         return string(buffer);
974     }
975 
976     /**
977      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
978      */
979     function toHexString(address addr) internal pure returns (string memory) {
980         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
981     }
982 }
983 
984 abstract contract Ownable is Context {
985     address private _owner;
986 
987     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
988 
989     /**
990      * @dev Initializes the contract setting the deployer as the initial owner.
991      */
992     constructor() {
993         _transferOwnership(_msgSender());
994     }
995 
996     /**
997      * @dev Throws if called by any account other than the owner.
998      */
999     modifier onlyOwner() {
1000         _checkOwner();
1001         _;
1002     }
1003 
1004     /**
1005      * @dev Returns the address of the current owner.
1006      */
1007     function owner() public view virtual returns (address) {
1008         return _owner;
1009     }
1010 
1011     /**
1012      * @dev Throws if the sender is not the owner.
1013      */
1014     function _checkOwner() internal view virtual {
1015         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1016     }
1017 
1018     /**
1019      * @dev Leaves the contract without owner. It will not be possible to call
1020      * `onlyOwner` functions anymore. Can only be called by the current owner.
1021      *
1022      * NOTE: Renouncing ownership will leave the contract without an owner,
1023      * thereby removing any functionality that is only available to the owner.
1024      */
1025     function renounceOwnership() public virtual onlyOwner {
1026         _transferOwnership(address(0));
1027     }
1028 
1029     /**
1030      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1031      * Can only be called by the current owner.
1032      */
1033     function transferOwnership(address newOwner) public virtual onlyOwner {
1034         require(newOwner != address(0), "Ownable: new owner is the zero address");
1035         _transferOwnership(newOwner);
1036     }
1037 
1038     /**
1039      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1040      * Internal function without access restriction.
1041      */
1042     function _transferOwnership(address newOwner) internal virtual {
1043         address oldOwner = _owner;
1044         _owner = newOwner;
1045         emit OwnershipTransferred(oldOwner, newOwner);
1046     }
1047 }
1048 
1049 /**
1050  * @dev Interface of ERC721 token receiver.
1051  */
1052 interface ERC721A__IERC721Receiver {
1053     function onERC721Received(
1054         address operator,
1055         address from,
1056         uint256 tokenId,
1057         bytes calldata data
1058     ) external returns (bytes4);
1059 }
1060 
1061 /**
1062  * @title ERC721A
1063  *
1064  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1065  * Non-Fungible Token Standard, including the Metadata extension.
1066  * Optimized for lower gas during batch mints.
1067  *
1068  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1069  * starting from `_startTokenId()`.
1070  *
1071  * Assumptions:
1072  *
1073  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1074  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1075  */
1076 contract ERC721A is IERC721A {
1077     // Reference type for token approval.
1078     struct TokenApprovalRef {
1079         address value;
1080     }
1081 
1082     // =============================================================
1083     //                           CONSTANTS
1084     // =============================================================
1085 
1086     // Mask of an entry in packed address data.
1087     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1088 
1089     // The bit position of `numberMinted` in packed address data.
1090     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1091 
1092     // The bit position of `numberBurned` in packed address data.
1093     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1094 
1095     // The bit position of `aux` in packed address data.
1096     uint256 private constant _BITPOS_AUX = 192;
1097 
1098     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1099     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1100 
1101     // The bit position of `startTimestamp` in packed ownership.
1102     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1103 
1104     // The bit mask of the `burned` bit in packed ownership.
1105     uint256 private constant _BITMASK_BURNED = 1 << 224;
1106 
1107     // The bit position of the `nextInitialized` bit in packed ownership.
1108     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1109 
1110     // The bit mask of the `nextInitialized` bit in packed ownership.
1111     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1112 
1113     // The bit position of `extraData` in packed ownership.
1114     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1115 
1116     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1117     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1118 
1119     // The mask of the lower 160 bits for addresses.
1120     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1121 
1122     // The maximum `quantity` that can be minted with {_mintERC2309}.
1123     // This limit is to prevent overflows on the address data entries.
1124     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1125     // is required to cause an overflow, which is unrealistic.
1126     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1127 
1128     // The `Transfer` event signature is given by:
1129     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1130     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1131         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1132 
1133     // =============================================================
1134     //                            STORAGE
1135     // =============================================================
1136 
1137     // The next token ID to be minted.
1138     uint256 private _currentIndex;
1139 
1140     // The number of tokens burned.
1141     uint256 private _burnCounter;
1142 
1143     // Token name
1144     string private _name;
1145 
1146     // Token symbol
1147     string private _symbol;
1148 
1149     // Mapping from token ID to ownership details
1150     // An empty struct value does not necessarily mean the token is unowned.
1151     // See {_packedOwnershipOf} implementation for details.
1152     //
1153     // Bits Layout:
1154     // - [0..159]   `addr`
1155     // - [160..223] `startTimestamp`
1156     // - [224]      `burned`
1157     // - [225]      `nextInitialized`
1158     // - [232..255] `extraData`
1159     mapping(uint256 => uint256) private _packedOwnerships;
1160 
1161     // Mapping owner address to address data.
1162     //
1163     // Bits Layout:
1164     // - [0..63]    `balance`
1165     // - [64..127]  `numberMinted`
1166     // - [128..191] `numberBurned`
1167     // - [192..255] `aux`
1168     mapping(address => uint256) private _packedAddressData;
1169 
1170     // Mapping from token ID to approved address.
1171     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1172 
1173     // Mapping from owner to operator approvals
1174     mapping(address => mapping(address => bool)) private _operatorApprovals;
1175 
1176     // =============================================================
1177     //                          CONSTRUCTOR
1178     // =============================================================
1179 
1180     constructor(string memory name_, string memory symbol_) {
1181         _name = name_;
1182         _symbol = symbol_;
1183         _currentIndex = _startTokenId();
1184     }
1185 
1186     // =============================================================
1187     //                   TOKEN COUNTING OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Returns the starting token ID.
1192      * To change the starting token ID, please override this function.
1193      */
1194     function _startTokenId() internal view virtual returns (uint256) {
1195         return 1;
1196     }
1197 
1198     /**
1199      * @dev Returns the next token ID to be minted.
1200      */
1201     function _nextTokenId() internal view virtual returns (uint256) {
1202         return _currentIndex;
1203     }
1204 
1205     /**
1206      * @dev Returns the total number of tokens in existence.
1207      * Burned tokens will reduce the count.
1208      * To get the total number of tokens minted, please see {_totalMinted}.
1209      */
1210     function totalSupply() public view virtual override returns (uint256) {
1211         // Counter underflow is impossible as _burnCounter cannot be incremented
1212         // more than `_currentIndex - _startTokenId()` times.
1213         unchecked {
1214             return _currentIndex - _burnCounter - _startTokenId();
1215         }
1216     }
1217 
1218     /**
1219      * @dev Returns the total amount of tokens minted in the contract.
1220      */
1221     function _totalMinted() internal view virtual returns (uint256) {
1222         // Counter underflow is impossible as `_currentIndex` does not decrement,
1223         // and it is initialized to `_startTokenId()`.
1224         unchecked {
1225             return _currentIndex - _startTokenId();
1226         }
1227     }
1228 
1229     /**
1230      * @dev Returns the total number of tokens burned.
1231      */
1232     function _totalBurned() internal view virtual returns (uint256) {
1233         return _burnCounter;
1234     }
1235 
1236     // =============================================================
1237     //                    ADDRESS DATA OPERATIONS
1238     // =============================================================
1239 
1240     /**
1241      * @dev Returns the number of tokens in `owner`'s account.
1242      */
1243     function balanceOf(address owner) public view virtual override returns (uint256) {
1244         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1245         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1246     }
1247 
1248     /**
1249      * Returns the number of tokens minted by `owner`.
1250      */
1251     function _numberMinted(address owner) internal view returns (uint256) {
1252         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1253     }
1254 
1255     /**
1256      * Returns the number of tokens burned by or on behalf of `owner`.
1257      */
1258     function _numberBurned(address owner) internal view returns (uint256) {
1259         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1260     }
1261 
1262     /**
1263      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1264      */
1265     function _getAux(address owner) internal view returns (uint64) {
1266         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1267     }
1268 
1269     /**
1270      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1271      * If there are multiple variables, please pack them into a uint64.
1272      */
1273     function _setAux(address owner, uint64 aux) internal virtual {
1274         uint256 packed = _packedAddressData[owner];
1275         uint256 auxCasted;
1276         // Cast `aux` with assembly to avoid redundant masking.
1277         assembly {
1278             auxCasted := aux
1279         }
1280         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1281         _packedAddressData[owner] = packed;
1282     }
1283 
1284     // =============================================================
1285     //                            IERC165
1286     // =============================================================
1287 
1288     /**
1289      * @dev Returns true if this contract implements the interface defined by
1290      * `interfaceId`. See the corresponding
1291      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1292      * to learn more about how these ids are created.
1293      *
1294      * This function call must use less than 30000 gas.
1295      */
1296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1297         // The interface IDs are constants representing the first 4 bytes
1298         // of the XOR of all function selectors in the interface.
1299         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1300         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1301         return
1302             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1303             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1304             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1305     }
1306 
1307     // =============================================================
1308     //                        IERC721Metadata
1309     // =============================================================
1310 
1311     /**
1312      * @dev Returns the token collection name.
1313      */
1314     function name() public view virtual override returns (string memory) {
1315         return _name;
1316     }
1317 
1318     /**
1319      * @dev Returns the token collection symbol.
1320      */
1321     function symbol() public view virtual override returns (string memory) {
1322         return _symbol;
1323     }
1324 
1325     /**
1326      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1327      */
1328     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1329         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1330 
1331         string memory baseURI = _baseURI();
1332         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1333     }
1334 
1335     /**
1336      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1337      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1338      * by default, it can be overridden in child contracts.
1339      */
1340     function _baseURI() internal view virtual returns (string memory) {
1341         return '';
1342     }
1343 
1344     // =============================================================
1345     //                     OWNERSHIPS OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Returns the owner of the `tokenId` token.
1350      *
1351      * Requirements:
1352      *
1353      * - `tokenId` must exist.
1354      */
1355     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1356         return address(uint160(_packedOwnershipOf(tokenId)));
1357     }
1358 
1359     /**
1360      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1361      * It gradually moves to O(1) as tokens get transferred around over time.
1362      */
1363     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1364         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1365     }
1366 
1367     /**
1368      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1369      */
1370     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1371         return _unpackedOwnership(_packedOwnerships[index]);
1372     }
1373 
1374     /**
1375      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1376      */
1377     function _initializeOwnershipAt(uint256 index) internal virtual {
1378         if (_packedOwnerships[index] == 0) {
1379             _packedOwnerships[index] = _packedOwnershipOf(index);
1380         }
1381     }
1382 
1383     /**
1384      * Returns the packed ownership data of `tokenId`.
1385      */
1386     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1387         uint256 curr = tokenId;
1388 
1389         unchecked {
1390             if (_startTokenId() <= curr)
1391                 if (curr < _currentIndex) {
1392                     uint256 packed = _packedOwnerships[curr];
1393                     // If not burned.
1394                     if (packed & _BITMASK_BURNED == 0) {
1395                         // Invariant:
1396                         // There will always be an initialized ownership slot
1397                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1398                         // before an unintialized ownership slot
1399                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1400                         // Hence, `curr` will not underflow.
1401                         //
1402                         // We can directly compare the packed value.
1403                         // If the address is zero, packed will be zero.
1404                         while (packed == 0) {
1405                             packed = _packedOwnerships[--curr];
1406                         }
1407                         return packed;
1408                     }
1409                 }
1410         }
1411         revert OwnerQueryForNonexistentToken();
1412     }
1413 
1414     /**
1415      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1416      */
1417     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1418         ownership.addr = address(uint160(packed));
1419         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1420         ownership.burned = packed & _BITMASK_BURNED != 0;
1421         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1422     }
1423 
1424     /**
1425      * @dev Packs ownership data into a single uint256.
1426      */
1427     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1428         assembly {
1429             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1430             owner := and(owner, _BITMASK_ADDRESS)
1431             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1432             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1433         }
1434     }
1435 
1436     /**
1437      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1438      */
1439     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1440         // For branchless setting of the `nextInitialized` flag.
1441         assembly {
1442             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1443             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1444         }
1445     }
1446 
1447     // =============================================================
1448     //                      APPROVAL OPERATIONS
1449     // =============================================================
1450 
1451     /**
1452      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1453      * The approval is cleared when the token is transferred.
1454      *
1455      * Only a single account can be approved at a time, so approving the
1456      * zero address clears previous approvals.
1457      *
1458      * Requirements:
1459      *
1460      * - The caller must own the token or be an approved operator.
1461      * - `tokenId` must exist.
1462      *
1463      * Emits an {Approval} event.
1464      */
1465     function approve(address to, uint256 tokenId) public virtual override {
1466         address owner = ownerOf(tokenId);
1467 
1468         if (_msgSenderERC721A() != owner)
1469             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1470                 revert ApprovalCallerNotOwnerNorApproved();
1471             }
1472 
1473         _tokenApprovals[tokenId].value = to;
1474         emit Approval(owner, to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev Returns the account approved for `tokenId` token.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      */
1484     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1485         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1486 
1487         return _tokenApprovals[tokenId].value;
1488     }
1489 
1490     /**
1491      * @dev Approve or remove `operator` as an operator for the caller.
1492      * Operators can call {transferFrom} or {safeTransferFrom}
1493      * for any token owned by the caller.
1494      *
1495      * Requirements:
1496      *
1497      * - The `operator` cannot be the caller.
1498      *
1499      * Emits an {ApprovalForAll} event.
1500      */
1501     function setApprovalForAll(address operator, bool approved) public virtual override {
1502         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1503 
1504         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1505         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1506     }
1507 
1508     /**
1509      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1510      *
1511      * See {setApprovalForAll}.
1512      */
1513     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1514         return _operatorApprovals[owner][operator];
1515     }
1516 
1517     /**
1518      * @dev Returns whether `tokenId` exists.
1519      *
1520      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1521      *
1522      * Tokens start existing when they are minted. See {_mint}.
1523      */
1524     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1525         return
1526             _startTokenId() <= tokenId &&
1527             tokenId < _currentIndex && // If within bounds,
1528             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1529     }
1530 
1531     /**
1532      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1533      */
1534     function _isSenderApprovedOrOwner(
1535         address approvedAddress,
1536         address owner,
1537         address msgSender
1538     ) private pure returns (bool result) {
1539         assembly {
1540             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1541             owner := and(owner, _BITMASK_ADDRESS)
1542             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1543             msgSender := and(msgSender, _BITMASK_ADDRESS)
1544             // `msgSender == owner || msgSender == approvedAddress`.
1545             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1546         }
1547     }
1548 
1549     /**
1550      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1551      */
1552     function _getApprovedSlotAndAddress(uint256 tokenId)
1553         private
1554         view
1555         returns (uint256 approvedAddressSlot, address approvedAddress)
1556     {
1557         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1558         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1559         assembly {
1560             approvedAddressSlot := tokenApproval.slot
1561             approvedAddress := sload(approvedAddressSlot)
1562         }
1563     }
1564 
1565     // =============================================================
1566     //                      TRANSFER OPERATIONS
1567     // =============================================================
1568 
1569     /**
1570      * @dev Transfers `tokenId` from `from` to `to`.
1571      *
1572      * Requirements:
1573      *
1574      * - `from` cannot be the zero address.
1575      * - `to` cannot be the zero address.
1576      * - `tokenId` token must be owned by `from`.
1577      * - If the caller is not `from`, it must be approved to move this token
1578      * by either {approve} or {setApprovalForAll}.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function transferFrom(
1583         address from,
1584         address to,
1585         uint256 tokenId
1586     ) public virtual override {
1587         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1588 
1589         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1590 
1591         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1592 
1593         // The nested ifs save around 20+ gas over a compound boolean condition.
1594         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1595             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1596 
1597         if (to == address(0)) revert TransferToZeroAddress();
1598 
1599         _beforeTokenTransfers(from, to, tokenId, 1);
1600 
1601         // Clear approvals from the previous owner.
1602         assembly {
1603             if approvedAddress {
1604                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1605                 sstore(approvedAddressSlot, 0)
1606             }
1607         }
1608 
1609         // Underflow of the sender's balance is impossible because we check for
1610         // ownership above and the recipient's balance can't realistically overflow.
1611         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1612         unchecked {
1613             // We can directly increment and decrement the balances.
1614             --_packedAddressData[from]; // Updates: `balance -= 1`.
1615             ++_packedAddressData[to]; // Updates: `balance += 1`.
1616 
1617             // Updates:
1618             // - `address` to the next owner.
1619             // - `startTimestamp` to the timestamp of transfering.
1620             // - `burned` to `false`.
1621             // - `nextInitialized` to `true`.
1622             _packedOwnerships[tokenId] = _packOwnershipData(
1623                 to,
1624                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1625             );
1626 
1627             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1628             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1629                 uint256 nextTokenId = tokenId + 1;
1630                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1631                 if (_packedOwnerships[nextTokenId] == 0) {
1632                     // If the next slot is within bounds.
1633                     if (nextTokenId != _currentIndex) {
1634                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1635                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1636                     }
1637                 }
1638             }
1639         }
1640 
1641         emit Transfer(from, to, tokenId);
1642         _afterTokenTransfers(from, to, tokenId, 1);
1643     }
1644 
1645     /**
1646      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1647      */
1648     function safeTransferFrom(
1649         address from,
1650         address to,
1651         uint256 tokenId
1652     ) public virtual override {
1653         safeTransferFrom(from, to, tokenId, '');
1654     }
1655 
1656     /**
1657      * @dev Safely transfers `tokenId` token from `from` to `to`.
1658      *
1659      * Requirements:
1660      *
1661      * - `from` cannot be the zero address.
1662      * - `to` cannot be the zero address.
1663      * - `tokenId` token must exist and be owned by `from`.
1664      * - If the caller is not `from`, it must be approved to move this token
1665      * by either {approve} or {setApprovalForAll}.
1666      * - If `to` refers to a smart contract, it must implement
1667      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1668      *
1669      * Emits a {Transfer} event.
1670      */
1671     function safeTransferFrom(
1672         address from,
1673         address to,
1674         uint256 tokenId,
1675         bytes memory _data
1676     ) public virtual override {
1677         transferFrom(from, to, tokenId);
1678         if (to.code.length != 0)
1679             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1680                 revert TransferToNonERC721ReceiverImplementer();
1681             }
1682     }
1683 
1684     /**
1685      * @dev Hook that is called before a set of serially-ordered token IDs
1686      * are about to be transferred. This includes minting.
1687      * And also called before burning one token.
1688      *
1689      * `startTokenId` - the first token ID to be transferred.
1690      * `quantity` - the amount to be transferred.
1691      *
1692      * Calling conditions:
1693      *
1694      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1695      * transferred to `to`.
1696      * - When `from` is zero, `tokenId` will be minted for `to`.
1697      * - When `to` is zero, `tokenId` will be burned by `from`.
1698      * - `from` and `to` are never both zero.
1699      */
1700     function _beforeTokenTransfers(
1701         address from,
1702         address to,
1703         uint256 startTokenId,
1704         uint256 quantity
1705     ) internal virtual {}
1706 
1707     /**
1708      * @dev Hook that is called after a set of serially-ordered token IDs
1709      * have been transferred. This includes minting.
1710      * And also called after one token has been burned.
1711      *
1712      * `startTokenId` - the first token ID to be transferred.
1713      * `quantity` - the amount to be transferred.
1714      *
1715      * Calling conditions:
1716      *
1717      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1718      * transferred to `to`.
1719      * - When `from` is zero, `tokenId` has been minted for `to`.
1720      * - When `to` is zero, `tokenId` has been burned by `from`.
1721      * - `from` and `to` are never both zero.
1722      */
1723     function _afterTokenTransfers(
1724         address from,
1725         address to,
1726         uint256 startTokenId,
1727         uint256 quantity
1728     ) internal virtual {}
1729 
1730     /**
1731      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1732      *
1733      * `from` - Previous owner of the given token ID.
1734      * `to` - Target address that will receive the token.
1735      * `tokenId` - Token ID to be transferred.
1736      * `_data` - Optional data to send along with the call.
1737      *
1738      * Returns whether the call correctly returned the expected magic value.
1739      */
1740     function _checkContractOnERC721Received(
1741         address from,
1742         address to,
1743         uint256 tokenId,
1744         bytes memory _data
1745     ) private returns (bool) {
1746         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1747             bytes4 retval
1748         ) {
1749             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1750         } catch (bytes memory reason) {
1751             if (reason.length == 0) {
1752                 revert TransferToNonERC721ReceiverImplementer();
1753             } else {
1754                 assembly {
1755                     revert(add(32, reason), mload(reason))
1756                 }
1757             }
1758         }
1759     }
1760 
1761     // =============================================================
1762     //                        MINT OPERATIONS
1763     // =============================================================
1764 
1765     /**
1766      * @dev Mints `quantity` tokens and transfers them to `to`.
1767      *
1768      * Requirements:
1769      *
1770      * - `to` cannot be the zero address.
1771      * - `quantity` must be greater than 0.
1772      *
1773      * Emits a {Transfer} event for each mint.
1774      */
1775     function _mint(address to, uint256 quantity) internal virtual {
1776         uint256 startTokenId = _currentIndex;
1777         if (quantity == 0) revert MintZeroQuantity();
1778 
1779         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1780 
1781         // Overflows are incredibly unrealistic.
1782         // `balance` and `numberMinted` have a maximum limit of 2**64.
1783         // `tokenId` has a maximum limit of 2**256.
1784         unchecked {
1785             // Updates:
1786             // - `balance += quantity`.
1787             // - `numberMinted += quantity`.
1788             //
1789             // We can directly add to the `balance` and `numberMinted`.
1790             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1791 
1792             // Updates:
1793             // - `address` to the owner.
1794             // - `startTimestamp` to the timestamp of minting.
1795             // - `burned` to `false`.
1796             // - `nextInitialized` to `quantity == 1`.
1797             _packedOwnerships[startTokenId] = _packOwnershipData(
1798                 to,
1799                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1800             );
1801 
1802             uint256 toMasked;
1803             uint256 end = startTokenId + quantity;
1804 
1805             // Use assembly to loop and emit the `Transfer` event for gas savings.
1806             assembly {
1807                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1808                 toMasked := and(to, _BITMASK_ADDRESS)
1809                 // Emit the `Transfer` event.
1810                 log4(
1811                     0, // Start of data (0, since no data).
1812                     0, // End of data (0, since no data).
1813                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1814                     0, // `address(0)`.
1815                     toMasked, // `to`.
1816                     startTokenId // `tokenId`.
1817                 )
1818 
1819                 for {
1820                     let tokenId := add(startTokenId, 1)
1821                 } iszero(eq(tokenId, end)) {
1822                     tokenId := add(tokenId, 1)
1823                 } {
1824                     // Emit the `Transfer` event. Similar to above.
1825                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1826                 }
1827             }
1828             if (toMasked == 0) revert MintToZeroAddress();
1829 
1830             _currentIndex = end;
1831         }
1832         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1833     }
1834 
1835     /**
1836      * @dev Mints `quantity` tokens and transfers them to `to`.
1837      *
1838      * This function is intended for efficient minting only during contract creation.
1839      *
1840      * It emits only one {ConsecutiveTransfer} as defined in
1841      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1842      * instead of a sequence of {Transfer} event(s).
1843      *
1844      * Calling this function outside of contract creation WILL make your contract
1845      * non-compliant with the ERC721 standard.
1846      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1847      * {ConsecutiveTransfer} event is only permissible during contract creation.
1848      *
1849      * Requirements:
1850      *
1851      * - `to` cannot be the zero address.
1852      * - `quantity` must be greater than 0.
1853      *
1854      * Emits a {ConsecutiveTransfer} event.
1855      */
1856     function _mintERC2309(address to, uint256 quantity) internal virtual {
1857         uint256 startTokenId = _currentIndex;
1858         if (to == address(0)) revert MintToZeroAddress();
1859         if (quantity == 0) revert MintZeroQuantity();
1860         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1861 
1862         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1863 
1864         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1865         unchecked {
1866             // Updates:
1867             // - `balance += quantity`.
1868             // - `numberMinted += quantity`.
1869             //
1870             // We can directly add to the `balance` and `numberMinted`.
1871             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1872 
1873             // Updates:
1874             // - `address` to the owner.
1875             // - `startTimestamp` to the timestamp of minting.
1876             // - `burned` to `false`.
1877             // - `nextInitialized` to `quantity == 1`.
1878             _packedOwnerships[startTokenId] = _packOwnershipData(
1879                 to,
1880                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1881             );
1882 
1883             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1884 
1885             _currentIndex = startTokenId + quantity;
1886         }
1887         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1888     }
1889 
1890     /**
1891      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1892      *
1893      * Requirements:
1894      *
1895      * - If `to` refers to a smart contract, it must implement
1896      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1897      * - `quantity` must be greater than 0.
1898      *
1899      * See {_mint}.
1900      *
1901      * Emits a {Transfer} event for each mint.
1902      */
1903     function _safeMint(
1904         address to,
1905         uint256 quantity,
1906         bytes memory _data
1907     ) internal virtual {
1908         _mint(to, quantity);
1909 
1910         unchecked {
1911             if (to.code.length != 0) {
1912                 uint256 end = _currentIndex;
1913                 uint256 index = end - quantity;
1914                 do {
1915                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1916                         revert TransferToNonERC721ReceiverImplementer();
1917                     }
1918                 } while (index < end);
1919                 // Reentrancy protection.
1920                 if (_currentIndex != end) revert();
1921             }
1922         }
1923     }
1924 
1925     /**
1926      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1927      */
1928     function _safeMint(address to, uint256 quantity) internal virtual {
1929         _safeMint(to, quantity, '');
1930     }
1931 
1932     // =============================================================
1933     //                        BURN OPERATIONS
1934     // =============================================================
1935 
1936     /**
1937      * @dev Equivalent to `_burn(tokenId, false)`.
1938      */
1939     function _burn(uint256 tokenId) internal virtual {
1940         _burn(tokenId, false);
1941     }
1942 
1943     /**
1944      * @dev Destroys `tokenId`.
1945      * The approval is cleared when the token is burned.
1946      *
1947      * Requirements:
1948      *
1949      * - `tokenId` must exist.
1950      *
1951      * Emits a {Transfer} event.
1952      */
1953     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1954         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1955 
1956         address from = address(uint160(prevOwnershipPacked));
1957 
1958         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1959 
1960         if (approvalCheck) {
1961             // The nested ifs save around 20+ gas over a compound boolean condition.
1962             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1963                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1964         }
1965 
1966         _beforeTokenTransfers(from, address(0), tokenId, 1);
1967 
1968         // Clear approvals from the previous owner.
1969         assembly {
1970             if approvedAddress {
1971                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1972                 sstore(approvedAddressSlot, 0)
1973             }
1974         }
1975 
1976         // Underflow of the sender's balance is impossible because we check for
1977         // ownership above and the recipient's balance can't realistically overflow.
1978         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1979         unchecked {
1980             // Updates:
1981             // - `balance -= 1`.
1982             // - `numberBurned += 1`.
1983             //
1984             // We can directly decrement the balance, and increment the number burned.
1985             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1986             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1987 
1988             // Updates:
1989             // - `address` to the last owner.
1990             // - `startTimestamp` to the timestamp of burning.
1991             // - `burned` to `true`.
1992             // - `nextInitialized` to `true`.
1993             _packedOwnerships[tokenId] = _packOwnershipData(
1994                 from,
1995                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1996             );
1997 
1998             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1999             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2000                 uint256 nextTokenId = tokenId + 1;
2001                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2002                 if (_packedOwnerships[nextTokenId] == 0) {
2003                     // If the next slot is within bounds.
2004                     if (nextTokenId != _currentIndex) {
2005                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2006                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2007                     }
2008                 }
2009             }
2010         }
2011 
2012         emit Transfer(from, address(0), tokenId);
2013         _afterTokenTransfers(from, address(0), tokenId, 1);
2014 
2015         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2016         unchecked {
2017             _burnCounter++;
2018         }
2019     }
2020 
2021     // =============================================================
2022     //                     EXTRA DATA OPERATIONS
2023     // =============================================================
2024 
2025     /**
2026      * @dev Directly sets the extra data for the ownership data `index`.
2027      */
2028     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2029         uint256 packed = _packedOwnerships[index];
2030         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2031         uint256 extraDataCasted;
2032         // Cast `extraData` with assembly to avoid redundant masking.
2033         assembly {
2034             extraDataCasted := extraData
2035         }
2036         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2037         _packedOwnerships[index] = packed;
2038     }
2039 
2040     /**
2041      * @dev Called during each token transfer to set the 24bit `extraData` field.
2042      * Intended to be overridden by the cosumer contract.
2043      *
2044      * `previousExtraData` - the value of `extraData` before transfer.
2045      *
2046      * Calling conditions:
2047      *
2048      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2049      * transferred to `to`.
2050      * - When `from` is zero, `tokenId` will be minted for `to`.
2051      * - When `to` is zero, `tokenId` will be burned by `from`.
2052      * - `from` and `to` are never both zero.
2053      */
2054     function _extraData(
2055         address from,
2056         address to,
2057         uint24 previousExtraData
2058     ) internal view virtual returns (uint24) {}
2059 
2060     /**
2061      * @dev Returns the next extra data for the packed ownership data.
2062      * The returned result is shifted into position.
2063      */
2064     function _nextExtraData(
2065         address from,
2066         address to,
2067         uint256 prevOwnershipPacked
2068     ) private view returns (uint256) {
2069         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2070         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2071     }
2072 
2073     // =============================================================
2074     //                       OTHER OPERATIONS
2075     // =============================================================
2076 
2077     /**
2078      * @dev Returns the message sender (defaults to `msg.sender`).
2079      *
2080      * If you are writing GSN compatible contracts, you need to override this function.
2081      */
2082     function _msgSenderERC721A() internal view virtual returns (address) {
2083         return msg.sender;
2084     }
2085 
2086     /**
2087      * @dev Converts a uint256 to its ASCII string decimal representation.
2088      */
2089     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2090         assembly {
2091             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2092             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2093             // We will need 1 32-byte word to store the length,
2094             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2095             ptr := add(mload(0x40), 128)
2096             // Update the free memory pointer to allocate.
2097             mstore(0x40, ptr)
2098 
2099             // Cache the end of the memory to calculate the length later.
2100             let end := ptr
2101 
2102             // We write the string from the rightmost digit to the leftmost digit.
2103             // The following is essentially a do-while loop that also handles the zero case.
2104             // Costs a bit more than early returning for the zero case,
2105             // but cheaper in terms of deployment and overall runtime costs.
2106             for {
2107                 // Initialize and perform the first pass without check.
2108                 let temp := value
2109                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2110                 ptr := sub(ptr, 1)
2111                 // Write the character to the pointer.
2112                 // The ASCII index of the '0' character is 48.
2113                 mstore8(ptr, add(48, mod(temp, 10)))
2114                 temp := div(temp, 10)
2115             } temp {
2116                 // Keep dividing `temp` until zero.
2117                 temp := div(temp, 10)
2118             } {
2119                 // Body of the for loop.
2120                 ptr := sub(ptr, 1)
2121                 mstore8(ptr, add(48, mod(temp, 10)))
2122             }
2123 
2124             let length := sub(end, ptr)
2125             // Move the pointer 32 bytes leftwards to make room for the length.
2126             ptr := sub(ptr, 32)
2127             // Store the length.
2128             mstore(ptr, length)
2129         }
2130     }
2131 }
2132 
2133 interface IERC721AQueryable is IERC721A {
2134     /**
2135      * Invalid query range (`start` >= `stop`).
2136      */
2137     error InvalidQueryRange();
2138 
2139     /**
2140      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2141      *
2142      * If the `tokenId` is out of bounds:
2143      *
2144      * - `addr = address(0)`
2145      * - `startTimestamp = 0`
2146      * - `burned = false`
2147      * - `extraData = 0`
2148      *
2149      * If the `tokenId` is burned:
2150      *
2151      * - `addr = <Address of owner before token was burned>`
2152      * - `startTimestamp = <Timestamp when token was burned>`
2153      * - `burned = true`
2154      * - `extraData = <Extra data when token was burned>`
2155      *
2156      * Otherwise:
2157      *
2158      * - `addr = <Address of owner>`
2159      * - `startTimestamp = <Timestamp of start of ownership>`
2160      * - `burned = false`
2161      * - `extraData = <Extra data at start of ownership>`
2162      */
2163     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2164 
2165     /**
2166      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2167      * See {ERC721AQueryable-explicitOwnershipOf}
2168      */
2169     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2170 
2171     /**
2172      * @dev Returns an array of token IDs owned by `owner`,
2173      * in the range [`start`, `stop`)
2174      * (i.e. `start <= tokenId < stop`).
2175      *
2176      * This function allows for tokens to be queried if the collection
2177      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2178      *
2179      * Requirements:
2180      *
2181      * - `start < stop`
2182      */
2183     function tokensOfOwnerIn(
2184         address owner,
2185         uint256 start,
2186         uint256 stop
2187     ) external view returns (uint256[] memory);
2188 
2189     /**
2190      * @dev Returns an array of token IDs owned by `owner`.
2191      *
2192      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2193      * It is meant to be called off-chain.
2194      *
2195      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2196      * multiple smaller scans if the collection is large enough to cause
2197      * an out-of-gas error (10K collections should be fine).
2198      */
2199     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2200 }
2201 
2202 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2203     /**
2204      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2205      *
2206      * If the `tokenId` is out of bounds:
2207      *
2208      * - `addr = address(0)`
2209      * - `startTimestamp = 0`
2210      * - `burned = false`
2211      * - `extraData = 0`
2212      *
2213      * If the `tokenId` is burned:
2214      *
2215      * - `addr = <Address of owner before token was burned>`
2216      * - `startTimestamp = <Timestamp when token was burned>`
2217      * - `burned = true`
2218      * - `extraData = <Extra data when token was burned>`
2219      *
2220      * Otherwise:
2221      *
2222      * - `addr = <Address of owner>`
2223      * - `startTimestamp = <Timestamp of start of ownership>`
2224      * - `burned = false`
2225      * - `extraData = <Extra data at start of ownership>`
2226      */
2227     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2228         TokenOwnership memory ownership;
2229         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2230             return ownership;
2231         }
2232         ownership = _ownershipAt(tokenId);
2233         if (ownership.burned) {
2234             return ownership;
2235         }
2236         return _ownershipOf(tokenId);
2237     }
2238 
2239     /**
2240      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2241      * See {ERC721AQueryable-explicitOwnershipOf}
2242      */
2243     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2244         external
2245         view
2246         virtual
2247         override
2248         returns (TokenOwnership[] memory)
2249     {
2250         unchecked {
2251             uint256 tokenIdsLength = tokenIds.length;
2252             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2253             for (uint256 i; i != tokenIdsLength; ++i) {
2254                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2255             }
2256             return ownerships;
2257         }
2258     }
2259 
2260     /**
2261      * @dev Returns an array of token IDs owned by `owner`,
2262      * in the range [`start`, `stop`)
2263      * (i.e. `start <= tokenId < stop`).
2264      *
2265      * This function allows for tokens to be queried if the collection
2266      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2267      *
2268      * Requirements:
2269      *
2270      * - `start < stop`
2271      */
2272     function tokensOfOwnerIn(
2273         address owner,
2274         uint256 start,
2275         uint256 stop
2276     ) external view virtual override returns (uint256[] memory) {
2277         unchecked {
2278             if (start >= stop) revert InvalidQueryRange();
2279             uint256 tokenIdsIdx;
2280             uint256 stopLimit = _nextTokenId();
2281             // Set `start = max(start, _startTokenId())`.
2282             if (start < _startTokenId()) {
2283                 start = _startTokenId();
2284             }
2285             // Set `stop = min(stop, stopLimit)`.
2286             if (stop > stopLimit) {
2287                 stop = stopLimit;
2288             }
2289             uint256 tokenIdsMaxLength = balanceOf(owner);
2290             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2291             // to cater for cases where `balanceOf(owner)` is too big.
2292             if (start < stop) {
2293                 uint256 rangeLength = stop - start;
2294                 if (rangeLength < tokenIdsMaxLength) {
2295                     tokenIdsMaxLength = rangeLength;
2296                 }
2297             } else {
2298                 tokenIdsMaxLength = 0;
2299             }
2300             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2301             if (tokenIdsMaxLength == 0) {
2302                 return tokenIds;
2303             }
2304             // We need to call `explicitOwnershipOf(start)`,
2305             // because the slot at `start` may not be initialized.
2306             TokenOwnership memory ownership = explicitOwnershipOf(start);
2307             address currOwnershipAddr;
2308             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2309             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2310             if (!ownership.burned) {
2311                 currOwnershipAddr = ownership.addr;
2312             }
2313             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2314                 ownership = _ownershipAt(i);
2315                 if (ownership.burned) {
2316                     continue;
2317                 }
2318                 if (ownership.addr != address(0)) {
2319                     currOwnershipAddr = ownership.addr;
2320                 }
2321                 if (currOwnershipAddr == owner) {
2322                     tokenIds[tokenIdsIdx++] = i;
2323                 }
2324             }
2325             // Downsize the array to fit.
2326             assembly {
2327                 mstore(tokenIds, tokenIdsIdx)
2328             }
2329             return tokenIds;
2330         }
2331     }
2332 
2333     /**
2334      * @dev Returns an array of token IDs owned by `owner`.
2335      *
2336      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2337      * It is meant to be called off-chain.
2338      *
2339      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2340      * multiple smaller scans if the collection is large enough to cause
2341      * an out-of-gas error (10K collections should be fine).
2342      */
2343     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2344         unchecked {
2345             uint256 tokenIdsIdx;
2346             address currOwnershipAddr;
2347             uint256 tokenIdsLength = balanceOf(owner);
2348             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2349             TokenOwnership memory ownership;
2350             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2351                 ownership = _ownershipAt(i);
2352                 if (ownership.burned) {
2353                     continue;
2354                 }
2355                 if (ownership.addr != address(0)) {
2356                     currOwnershipAddr = ownership.addr;
2357                 }
2358                 if (currOwnershipAddr == owner) {
2359                     tokenIds[tokenIdsIdx++] = i;
2360                 }
2361             }
2362             return tokenIds;
2363         }
2364     }
2365 }
2366 
2367 contract PooPooGoru is Ownable, ERC721A, DefaultOperatorFilterer, ERC721AQueryable {
2368 
2369     using Strings for uint;
2370 
2371     enum Step {
2372         Before,
2373         PublicSale,
2374         SoldOut
2375     }
2376 
2377     string public baseURI;
2378 
2379     Step public sellingStep;
2380 
2381     uint private constant MAX_PUBLIC = 4444;
2382 
2383     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
2384 
2385     uint public maxMintAmountPerPublic = 10;
2386     uint public publicPrice = 0.003 ether;
2387 
2388     constructor(string memory _baseURI) ERC721A("PooPooGoru", "POO") {
2389         baseURI = _baseURI;
2390     }
2391 
2392     function mintForOpensea() external onlyOwner{
2393         if(totalSupply() != 0) revert("Only 30 mint for deployer");
2394         _mint(msg.sender, 30);
2395     }
2396 
2397     function publicSaleMint(uint _quantity) external payable {
2398         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2399         if(totalSupply() + _quantity > (MAX_PUBLIC)) revert("Max supply exceeded for public exceeded");
2400         if(mintedAmountNFTsperWalletPublicSale[msg.sender] == 0) {
2401             // Mint 1 Free
2402             if(_quantity > 1){
2403                 if(msg.value < publicPrice * (_quantity - 1)) revert("Not enough funds");
2404             }
2405             if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("Max exceeded");
2406             _mint(msg.sender, _quantity);
2407         } else {
2408             // Normal mint
2409             if(msg.value < publicPrice * _quantity ) revert("Not enough funds");
2410             if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("Max exceeded");
2411             _mint(msg.sender, _quantity);
2412         }
2413         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
2414     }
2415 
2416     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator {
2417         super.transferFrom(from, to, tokenId);
2418     }
2419 
2420     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator {
2421         super.safeTransferFrom(from, to, tokenId);
2422     }
2423 
2424     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2425         public
2426         override(ERC721A, IERC721A)
2427         onlyAllowedOperator
2428     {
2429         super.safeTransferFrom(from, to, tokenId, data);
2430     }
2431 
2432     function currentState() external view returns (Step, uint) {
2433         return (sellingStep, maxMintAmountPerPublic);
2434     }
2435 
2436     function setBaseUri(string memory _baseURI) external onlyOwner {
2437         baseURI = _baseURI;
2438     }
2439 
2440     function setStep(uint _step) external onlyOwner {
2441         sellingStep = Step(_step);
2442     }
2443 
2444     function setMaxMintPerPublic(uint amount) external onlyOwner{
2445         maxMintAmountPerPublic = amount;
2446     }
2447 
2448     function getNumberMinted(address account) external view returns (uint256) {
2449         return _numberMinted(account);
2450     }
2451 
2452     function getNumberPublicMinted(address account) external view returns (uint256) {
2453         return mintedAmountNFTsperWalletPublicSale[account];
2454     }
2455 
2456     function tokenURI(uint _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2457         require(_exists(_tokenId), "URI query for nonexistent token");
2458         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2459     }
2460 
2461     function withdraw() external onlyOwner {
2462         require(payable(msg.sender).send(address(this).balance));
2463     }
2464 }