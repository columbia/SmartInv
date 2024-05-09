1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File interfaces/IMailbox.sol
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.6.11;
7 
8 pragma abicoder v2;
9 
10 interface IMailbox {
11     function localDomain() external view returns (uint32);
12 }
13 
14 // File interfaces/IOutbox.sol
15 
16 // pragma solidity >=0.6.11;
17 
18 interface IOutbox is IMailbox {
19     function dispatch(
20         uint32 _destinationDomain,
21         bytes32 _recipientAddress,
22         bytes calldata _messageBody
23     ) external returns (uint256);
24 
25     function cacheCheckpoint() external;
26 
27     function latestCheckpoint() external view returns (bytes32, uint256);
28 
29     function count() external returns (uint256);
30 
31     function fail() external;
32 
33     function cachedCheckpoints(bytes32) external view returns (uint256);
34 
35     function latestCachedCheckpoint()
36         external
37         view
38         returns (bytes32 root, uint256 index);
39 }
40 
41 // File interfaces/IAbacusConnectionManager.sol
42 
43 // pragma solidity >=0.6.11;
44 
45 interface IAbacusConnectionManager {
46     function outbox() external view returns (IOutbox);
47 
48     function isInbox(address _inbox) external view returns (bool);
49 
50     function localDomain() external view returns (uint32);
51 }
52 
53 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
56 
57 // pragma solidity ^0.8.0;
58 
59 /**
60  * @dev Provides information about the current execution context, including the
61  * sender of the transaction and its data. While these are generally available
62  * via msg.sender and msg.data, they should not be accessed in such a direct
63  * manner, since when dealing with meta-transactions the account sending and
64  * paying for execution may not be the actual sender (as far as an application
65  * is concerned).
66  *
67  * This contract is only required for intermediate, library-like contracts.
68  */
69 abstract contract Context {
70     function _msgSender() internal view virtual returns (address) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view virtual returns (bytes calldata) {
75         return msg.data;
76     }
77 }
78 
79 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
80 
81 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
82 
83 // pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Contract module which provides a basic access control mechanism, where
87  * there is an account (an owner) that can be granted exclusive access to
88  * specific functions.
89  *
90  * By default, the owner account will be the one that deploys the contract. This
91  * can later be changed with {transferOwnership}.
92  *
93  * This module is used through inheritance. It will make available the modifier
94  * `onlyOwner`, which can be applied to your functions to restrict their use to
95  * the owner.
96  */
97 abstract contract Ownable is Context {
98     address private _owner;
99 
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _transferOwnership(_msgSender());
110     }
111 
112     /**
113      * @dev Returns the address of the current owner.
114      */
115     function owner() public view virtual returns (address) {
116         return _owner;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(owner() == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public virtual onlyOwner {
135         _transferOwnership(address(0));
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(
144             newOwner != address(0),
145             "Ownable: new owner is the zero address"
146         );
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.6.0
162 
163 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
164 
165 // pragma solidity ^0.8.0;
166 
167 /**
168  * @dev Library for managing
169  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
170  * types.
171  *
172  * Sets have the following properties:
173  *
174  * - Elements are added, removed, and checked for existence in constant time
175  * (O(1)).
176  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
177  *
178  * ```
179  * contract Example {
180  *     // Add the library methods
181  *     using EnumerableSet for EnumerableSet.AddressSet;
182  *
183  *     // Declare a set state variable
184  *     EnumerableSet.AddressSet private mySet;
185  * }
186  * ```
187  *
188  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
189  * and `uint256` (`UintSet`) are supported.
190  */
191 library EnumerableSet {
192     // To implement this library for multiple types with as little code
193     // repetition as possible, we write it in terms of a generic Set type with
194     // bytes32 values.
195     // The Set implementation uses private functions, and user-facing
196     // implementations (such as AddressSet) are just wrappers around the
197     // underlying Set.
198     // This means that we can only create new EnumerableSets for types that fit
199     // in bytes32.
200 
201     struct Set {
202         // Storage of set values
203         bytes32[] _values;
204         // Position of the value in the `values` array, plus 1 because index 0
205         // means a value is not in the set.
206         mapping(bytes32 => uint256) _indexes;
207     }
208 
209     /**
210      * @dev Add a value to a set. O(1).
211      *
212      * Returns true if the value was added to the set, that is if it was not
213      * already present.
214      */
215     function _add(Set storage set, bytes32 value) private returns (bool) {
216         if (!_contains(set, value)) {
217             set._values.push(value);
218             // The value is stored at length-1, but we add 1 to all indexes
219             // and use 0 as a sentinel value
220             set._indexes[value] = set._values.length;
221             return true;
222         } else {
223             return false;
224         }
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function _remove(Set storage set, bytes32 value) private returns (bool) {
234         // We read and store the value's index to prevent multiple reads from the same storage slot
235         uint256 valueIndex = set._indexes[value];
236 
237         if (valueIndex != 0) {
238             // Equivalent to contains(set, value)
239             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
240             // the array, and then remove the last element (sometimes called as 'swap and pop').
241             // This modifies the order of the array, as noted in {at}.
242 
243             uint256 toDeleteIndex = valueIndex - 1;
244             uint256 lastIndex = set._values.length - 1;
245 
246             if (lastIndex != toDeleteIndex) {
247                 bytes32 lastValue = set._values[lastIndex];
248 
249                 // Move the last value to the index where the value to delete is
250                 set._values[toDeleteIndex] = lastValue;
251                 // Update the index for the moved value
252                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
253             }
254 
255             // Delete the slot where the moved value was stored
256             set._values.pop();
257 
258             // Delete the index for the deleted slot
259             delete set._indexes[value];
260 
261             return true;
262         } else {
263             return false;
264         }
265     }
266 
267     /**
268      * @dev Returns true if the value is in the set. O(1).
269      */
270     function _contains(Set storage set, bytes32 value)
271         private
272         view
273         returns (bool)
274     {
275         return set._indexes[value] != 0;
276     }
277 
278     /**
279      * @dev Returns the number of values on the set. O(1).
280      */
281     function _length(Set storage set) private view returns (uint256) {
282         return set._values.length;
283     }
284 
285     /**
286      * @dev Returns the value stored at position `index` in the set. O(1).
287      *
288      * Note that there are no guarantees on the ordering of values inside the
289      * array, and it may change when more values are added or removed.
290      *
291      * Requirements:
292      *
293      * - `index` must be strictly less than {length}.
294      */
295     function _at(Set storage set, uint256 index)
296         private
297         view
298         returns (bytes32)
299     {
300         return set._values[index];
301     }
302 
303     /**
304      * @dev Return the entire set in an array
305      *
306      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
307      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
308      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
309      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
310      */
311     function _values(Set storage set) private view returns (bytes32[] memory) {
312         return set._values;
313     }
314 
315     // Bytes32Set
316 
317     struct Bytes32Set {
318         Set _inner;
319     }
320 
321     /**
322      * @dev Add a value to a set. O(1).
323      *
324      * Returns true if the value was added to the set, that is if it was not
325      * already present.
326      */
327     function add(Bytes32Set storage set, bytes32 value)
328         internal
329         returns (bool)
330     {
331         return _add(set._inner, value);
332     }
333 
334     /**
335      * @dev Removes a value from a set. O(1).
336      *
337      * Returns true if the value was removed from the set, that is if it was
338      * present.
339      */
340     function remove(Bytes32Set storage set, bytes32 value)
341         internal
342         returns (bool)
343     {
344         return _remove(set._inner, value);
345     }
346 
347     /**
348      * @dev Returns true if the value is in the set. O(1).
349      */
350     function contains(Bytes32Set storage set, bytes32 value)
351         internal
352         view
353         returns (bool)
354     {
355         return _contains(set._inner, value);
356     }
357 
358     /**
359      * @dev Returns the number of values in the set. O(1).
360      */
361     function length(Bytes32Set storage set) internal view returns (uint256) {
362         return _length(set._inner);
363     }
364 
365     /**
366      * @dev Returns the value stored at position `index` in the set. O(1).
367      *
368      * Note that there are no guarantees on the ordering of values inside the
369      * array, and it may change when more values are added or removed.
370      *
371      * Requirements:
372      *
373      * - `index` must be strictly less than {length}.
374      */
375     function at(Bytes32Set storage set, uint256 index)
376         internal
377         view
378         returns (bytes32)
379     {
380         return _at(set._inner, index);
381     }
382 
383     /**
384      * @dev Return the entire set in an array
385      *
386      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
387      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
388      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
389      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
390      */
391     function values(Bytes32Set storage set)
392         internal
393         view
394         returns (bytes32[] memory)
395     {
396         return _values(set._inner);
397     }
398 
399     // AddressSet
400 
401     struct AddressSet {
402         Set _inner;
403     }
404 
405     /**
406      * @dev Add a value to a set. O(1).
407      *
408      * Returns true if the value was added to the set, that is if it was not
409      * already present.
410      */
411     function add(AddressSet storage set, address value)
412         internal
413         returns (bool)
414     {
415         return _add(set._inner, bytes32(uint256(uint160(value))));
416     }
417 
418     /**
419      * @dev Removes a value from a set. O(1).
420      *
421      * Returns true if the value was removed from the set, that is if it was
422      * present.
423      */
424     function remove(AddressSet storage set, address value)
425         internal
426         returns (bool)
427     {
428         return _remove(set._inner, bytes32(uint256(uint160(value))));
429     }
430 
431     /**
432      * @dev Returns true if the value is in the set. O(1).
433      */
434     function contains(AddressSet storage set, address value)
435         internal
436         view
437         returns (bool)
438     {
439         return _contains(set._inner, bytes32(uint256(uint160(value))));
440     }
441 
442     /**
443      * @dev Returns the number of values in the set. O(1).
444      */
445     function length(AddressSet storage set) internal view returns (uint256) {
446         return _length(set._inner);
447     }
448 
449     /**
450      * @dev Returns the value stored at position `index` in the set. O(1).
451      *
452      * Note that there are no guarantees on the ordering of values inside the
453      * array, and it may change when more values are added or removed.
454      *
455      * Requirements:
456      *
457      * - `index` must be strictly less than {length}.
458      */
459     function at(AddressSet storage set, uint256 index)
460         internal
461         view
462         returns (address)
463     {
464         return address(uint160(uint256(_at(set._inner, index))));
465     }
466 
467     /**
468      * @dev Return the entire set in an array
469      *
470      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
471      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
472      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
473      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
474      */
475     function values(AddressSet storage set)
476         internal
477         view
478         returns (address[] memory)
479     {
480         bytes32[] memory store = _values(set._inner);
481         address[] memory result;
482 
483         assembly {
484             result := store
485         }
486 
487         return result;
488     }
489 
490     // UintSet
491 
492     struct UintSet {
493         Set _inner;
494     }
495 
496     /**
497      * @dev Add a value to a set. O(1).
498      *
499      * Returns true if the value was added to the set, that is if it was not
500      * already present.
501      */
502     function add(UintSet storage set, uint256 value) internal returns (bool) {
503         return _add(set._inner, bytes32(value));
504     }
505 
506     /**
507      * @dev Removes a value from a set. O(1).
508      *
509      * Returns true if the value was removed from the set, that is if it was
510      * present.
511      */
512     function remove(UintSet storage set, uint256 value)
513         internal
514         returns (bool)
515     {
516         return _remove(set._inner, bytes32(value));
517     }
518 
519     /**
520      * @dev Returns true if the value is in the set. O(1).
521      */
522     function contains(UintSet storage set, uint256 value)
523         internal
524         view
525         returns (bool)
526     {
527         return _contains(set._inner, bytes32(value));
528     }
529 
530     /**
531      * @dev Returns the number of values on the set. O(1).
532      */
533     function length(UintSet storage set) internal view returns (uint256) {
534         return _length(set._inner);
535     }
536 
537     /**
538      * @dev Returns the value stored at position `index` in the set. O(1).
539      *
540      * Note that there are no guarantees on the ordering of values inside the
541      * array, and it may change when more values are added or removed.
542      *
543      * Requirements:
544      *
545      * - `index` must be strictly less than {length}.
546      */
547     function at(UintSet storage set, uint256 index)
548         internal
549         view
550         returns (uint256)
551     {
552         return uint256(_at(set._inner, index));
553     }
554 
555     /**
556      * @dev Return the entire set in an array
557      *
558      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
559      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
560      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
561      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
562      */
563     function values(UintSet storage set)
564         internal
565         view
566         returns (uint256[] memory)
567     {
568         bytes32[] memory store = _values(set._inner);
569         uint256[] memory result;
570 
571         assembly {
572             result := store
573         }
574 
575         return result;
576     }
577 }
578 
579 // File contracts/AbacusConnectionManager.sol
580 
581 // pragma solidity >=0.8.0;
582 // pragma abicoder v2;
583 
584 // ============ Internal Imports ============
585 
586 // ============ External Imports ============
587 
588 /**
589  * @title AbacusConnectionManager
590  * @author Celo Labs Inc.
591  * @notice Manages a registry of local Inbox contracts for remote Outbox
592  * domains.
593  */
594 contract AbacusConnectionManager is IAbacusConnectionManager, Ownable {
595     using EnumerableSet for EnumerableSet.AddressSet;
596 
597     // ============ Public Storage ============
598 
599     // Outbox contract
600     IOutbox public override outbox;
601     // local Inbox address => remote Outbox domain
602     mapping(address => uint32) public inboxToDomain;
603     // remote Outbox domain => local Inbox addresses
604     mapping(uint32 => EnumerableSet.AddressSet) domainToInboxes;
605 
606     // ============ Events ============
607 
608     /**
609      * @notice Emitted when a new Outbox is set.
610      * @param outbox the address of the Outbox
611      */
612     event OutboxSet(address indexed outbox);
613 
614     /**
615      * @notice Emitted when a new Inbox is enrolled / added
616      * @param domain the remote domain of the Outbox contract for the Inbox
617      * @param inbox the address of the Inbox
618      */
619     event InboxEnrolled(uint32 indexed domain, address inbox);
620 
621     /**
622      * @notice Emitted when a new Inbox is un-enrolled / removed
623      * @param domain the remote domain of the Outbox contract for the Inbox
624      * @param inbox the address of the Inbox
625      */
626     event InboxUnenrolled(uint32 indexed domain, address inbox);
627 
628     // ============ Constructor ============
629 
630     // solhint-disable-next-line no-empty-blocks
631     constructor() Ownable() {}
632 
633     // ============ External Functions ============
634 
635     /**
636      * @notice Sets the address of the local Outbox contract.
637      * @param _outbox The address of the new local Outbox contract.
638      */
639     function setOutbox(address _outbox) external onlyOwner {
640         outbox = IOutbox(_outbox);
641         emit OutboxSet(_outbox);
642     }
643 
644     /**
645      * @notice Allow Owner to enroll Inbox contract
646      * @param _domain the remote domain of the Outbox contract for the Inbox
647      * @param _inbox the address of the Inbox
648      */
649     function enrollInbox(uint32 _domain, address _inbox) external onlyOwner {
650         require(!isInbox(_inbox), "already inbox");
651         // add inbox and domain to two-way mapping
652         inboxToDomain[_inbox] = _domain;
653         domainToInboxes[_domain].add(_inbox);
654         emit InboxEnrolled(_domain, _inbox);
655     }
656 
657     /**
658      * @notice Allow Owner to un-enroll Inbox contract
659      * @param _inbox the address of the Inbox
660      */
661     function unenrollInbox(address _inbox) external onlyOwner {
662         _unenrollInbox(_inbox);
663     }
664 
665     /**
666      * @notice Query local domain from Outbox
667      * @return local domain
668      */
669     function localDomain() external view override returns (uint32) {
670         return outbox.localDomain();
671     }
672 
673     /**
674      * @notice Returns the Inbox addresses for a given remote domain
675      * @return inboxes An array of addresses of the Inboxes
676      */
677     function getInboxes(uint32 remoteDomain)
678         external
679         view
680         returns (address[] memory)
681     {
682         EnumerableSet.AddressSet storage _inboxes = domainToInboxes[
683             remoteDomain
684         ];
685         uint256 length = _inboxes.length();
686         address[] memory ret = new address[](length);
687         for (uint256 i = 0; i < length; i += 1) {
688             ret[i] = _inboxes.at(i);
689         }
690         return ret;
691     }
692 
693     // ============ Public Functions ============
694 
695     /**
696      * @notice Check whether _inbox is enrolled
697      * @param _inbox the inbox to check for enrollment
698      * @return TRUE iff _inbox is enrolled
699      */
700     function isInbox(address _inbox) public view override returns (bool) {
701         return inboxToDomain[_inbox] != 0;
702     }
703 
704     // ============ Internal Functions ============
705 
706     /**
707      * @notice Remove the inbox from the two-way mappings
708      * @param _inbox inbox to un-enroll
709      */
710     function _unenrollInbox(address _inbox) internal {
711         uint32 _currentDomain = inboxToDomain[_inbox];
712         domainToInboxes[_currentDomain].remove(_inbox);
713         inboxToDomain[_inbox] = 0;
714         emit InboxUnenrolled(_currentDomain, _inbox);
715     }
716 }
717 
718 // File contracts/Version0.sol
719 
720 // pragma solidity >=0.6.11;
721 
722 /**
723  * @title Version0
724  * @notice Version getter for contracts
725  **/
726 contract Version0 {
727     uint8 public constant VERSION = 0;
728 }
729 
730 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.6.0
731 
732 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
733 
734 // pragma solidity ^0.8.1;
735 
736 /**
737  * @dev Collection of functions related to the address type
738  */
739 library AddressUpgradeable {
740     /**
741      * @dev Returns true if `account` is a contract.
742      *
743      * [IMPORTANT]
744      * ====
745      * It is unsafe to assume that an address for which this function returns
746      * false is an externally-owned account (EOA) and not a contract.
747      *
748      * Among others, `isContract` will return false for the following
749      * types of addresses:
750      *
751      *  - an externally-owned account
752      *  - a contract in construction
753      *  - an address where a contract will be created
754      *  - an address where a contract lived, but was destroyed
755      * ====
756      *
757      * [IMPORTANT]
758      * ====
759      * You shouldn't rely on `isContract` to protect against flash loan attacks!
760      *
761      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
762      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
763      * constructor.
764      * ====
765      */
766     function isContract(address account) internal view returns (bool) {
767         // This method relies on extcodesize/address.code.length, which returns 0
768         // for contracts in construction, since the code is only stored at the end
769         // of the constructor execution.
770 
771         return account.code.length > 0;
772     }
773 
774     /**
775      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
776      * `recipient`, forwarding all available gas and reverting on errors.
777      *
778      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
779      * of certain opcodes, possibly making contracts go over the 2300 gas limit
780      * imposed by `transfer`, making them unable to receive funds via
781      * `transfer`. {sendValue} removes this limitation.
782      *
783      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
784      *
785      * IMPORTANT: because control is transferred to `recipient`, care must be
786      * taken to not create reentrancy vulnerabilities. Consider using
787      * {ReentrancyGuard} or the
788      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
789      */
790     function sendValue(address payable recipient, uint256 amount) internal {
791         require(
792             address(this).balance >= amount,
793             "Address: insufficient balance"
794         );
795 
796         (bool success, ) = recipient.call{value: amount}("");
797         require(
798             success,
799             "Address: unable to send value, recipient may have reverted"
800         );
801     }
802 
803     /**
804      * @dev Performs a Solidity function call using a low level `call`. A
805      * plain `call` is an unsafe replacement for a function call: use this
806      * function instead.
807      *
808      * If `target` reverts with a revert reason, it is bubbled up by this
809      * function (like regular Solidity function calls).
810      *
811      * Returns the raw returned data. To convert to the expected return value,
812      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
813      *
814      * Requirements:
815      *
816      * - `target` must be a contract.
817      * - calling `target` with `data` must not revert.
818      *
819      * _Available since v3.1._
820      */
821     function functionCall(address target, bytes memory data)
822         internal
823         returns (bytes memory)
824     {
825         return functionCall(target, data, "Address: low-level call failed");
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
830      * `errorMessage` as a fallback revert reason when `target` reverts.
831      *
832      * _Available since v3.1._
833      */
834     function functionCall(
835         address target,
836         bytes memory data,
837         string memory errorMessage
838     ) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, 0, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but also transferring `value` wei to `target`.
845      *
846      * Requirements:
847      *
848      * - the calling contract must have an ETH balance of at least `value`.
849      * - the called Solidity function must be `payable`.
850      *
851      * _Available since v3.1._
852      */
853     function functionCallWithValue(
854         address target,
855         bytes memory data,
856         uint256 value
857     ) internal returns (bytes memory) {
858         return
859             functionCallWithValue(
860                 target,
861                 data,
862                 value,
863                 "Address: low-level call with value failed"
864             );
865     }
866 
867     /**
868      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
869      * with `errorMessage` as a fallback revert reason when `target` reverts.
870      *
871      * _Available since v3.1._
872      */
873     function functionCallWithValue(
874         address target,
875         bytes memory data,
876         uint256 value,
877         string memory errorMessage
878     ) internal returns (bytes memory) {
879         require(
880             address(this).balance >= value,
881             "Address: insufficient balance for call"
882         );
883         require(isContract(target), "Address: call to non-contract");
884 
885         (bool success, bytes memory returndata) = target.call{value: value}(
886             data
887         );
888         return verifyCallResult(success, returndata, errorMessage);
889     }
890 
891     /**
892      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
893      * but performing a static call.
894      *
895      * _Available since v3.3._
896      */
897     function functionStaticCall(address target, bytes memory data)
898         internal
899         view
900         returns (bytes memory)
901     {
902         return
903             functionStaticCall(
904                 target,
905                 data,
906                 "Address: low-level static call failed"
907             );
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
912      * but performing a static call.
913      *
914      * _Available since v3.3._
915      */
916     function functionStaticCall(
917         address target,
918         bytes memory data,
919         string memory errorMessage
920     ) internal view returns (bytes memory) {
921         require(isContract(target), "Address: static call to non-contract");
922 
923         (bool success, bytes memory returndata) = target.staticcall(data);
924         return verifyCallResult(success, returndata, errorMessage);
925     }
926 
927     /**
928      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
929      * revert reason using the provided one.
930      *
931      * _Available since v4.3._
932      */
933     function verifyCallResult(
934         bool success,
935         bytes memory returndata,
936         string memory errorMessage
937     ) internal pure returns (bytes memory) {
938         if (success) {
939             return returndata;
940         } else {
941             // Look for revert reason and bubble it up if present
942             if (returndata.length > 0) {
943                 // The easiest way to bubble the revert reason is using memory via assembly
944 
945                 assembly {
946                     let returndata_size := mload(returndata)
947                     revert(add(32, returndata), returndata_size)
948                 }
949             } else {
950                 revert(errorMessage);
951             }
952         }
953     }
954 }
955 
956 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.6.0
957 
958 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/utils/Initializable.sol)
959 
960 // pragma solidity ^0.8.2;
961 
962 /**
963  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
964  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
965  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
966  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
967  *
968  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
969  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
970  * case an upgrade adds a module that needs to be initialized.
971  *
972  * For example:
973  *
974  * [.hljs-theme-light.nopadding]
975  * ```
976  * contract MyToken is ERC20Upgradeable {
977  *     function initialize() initializer public {
978  *         __ERC20_init("MyToken", "MTK");
979  *     }
980  * }
981  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
982  *     function initializeV2() reinitializer(2) public {
983  *         __ERC20Permit_init("MyToken");
984  *     }
985  * }
986  * ```
987  *
988  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
989  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
990  *
991  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
992  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
993  *
994  * [CAUTION]
995  * ====
996  * Avoid leaving a contract uninitialized.
997  *
998  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
999  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
1000  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
1001  *
1002  * [.hljs-theme-light.nopadding]
1003  * ```
1004  * /// @custom:oz-upgrades-unsafe-allow constructor
1005  * constructor() {
1006  *     _disableInitializers();
1007  * }
1008  * ```
1009  * ====
1010  */
1011 abstract contract Initializable {
1012     /**
1013      * @dev Indicates that the contract has been initialized.
1014      * @custom:oz-retyped-from bool
1015      */
1016     uint8 private _initialized;
1017 
1018     /**
1019      * @dev Indicates that the contract is in the process of being initialized.
1020      */
1021     bool private _initializing;
1022 
1023     /**
1024      * @dev Triggered when the contract has been initialized or reinitialized.
1025      */
1026     event Initialized(uint8 version);
1027 
1028     /**
1029      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
1030      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
1031      */
1032     modifier initializer() {
1033         bool isTopLevelCall = _setInitializedVersion(1);
1034         if (isTopLevelCall) {
1035             _initializing = true;
1036         }
1037         _;
1038         if (isTopLevelCall) {
1039             _initializing = false;
1040             emit Initialized(1);
1041         }
1042     }
1043 
1044     /**
1045      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
1046      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
1047      * used to initialize parent contracts.
1048      *
1049      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
1050      * initialization step. This is essential to configure modules that are added through upgrades and that require
1051      * initialization.
1052      *
1053      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
1054      * a contract, executing them in the right order is up to the developer or operator.
1055      */
1056     modifier reinitializer(uint8 version) {
1057         bool isTopLevelCall = _setInitializedVersion(version);
1058         if (isTopLevelCall) {
1059             _initializing = true;
1060         }
1061         _;
1062         if (isTopLevelCall) {
1063             _initializing = false;
1064             emit Initialized(version);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
1070      * {initializer} and {reinitializer} modifiers, directly or indirectly.
1071      */
1072     modifier onlyInitializing() {
1073         require(_initializing, "Initializable: contract is not initializing");
1074         _;
1075     }
1076 
1077     /**
1078      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
1079      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
1080      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
1081      * through proxies.
1082      */
1083     function _disableInitializers() internal virtual {
1084         _setInitializedVersion(type(uint8).max);
1085     }
1086 
1087     function _setInitializedVersion(uint8 version) private returns (bool) {
1088         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
1089         // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
1090         // of initializers, because in other contexts the contract may have been reentered.
1091         if (_initializing) {
1092             require(
1093                 version == 1 && !AddressUpgradeable.isContract(address(this)),
1094                 "Initializable: contract is already initialized"
1095             );
1096             return false;
1097         } else {
1098             require(
1099                 _initialized < version,
1100                 "Initializable: contract is already initialized"
1101             );
1102             _initialized = version;
1103             return true;
1104         }
1105     }
1106 }
1107 
1108 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.6.0
1109 
1110 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1111 
1112 // pragma solidity ^0.8.0;
1113 
1114 /**
1115  * @dev Provides information about the current execution context, including the
1116  * sender of the transaction and its data. While these are generally available
1117  * via msg.sender and msg.data, they should not be accessed in such a direct
1118  * manner, since when dealing with meta-transactions the account sending and
1119  * paying for execution may not be the actual sender (as far as an application
1120  * is concerned).
1121  *
1122  * This contract is only required for intermediate, library-like contracts.
1123  */
1124 abstract contract ContextUpgradeable is Initializable {
1125     function __Context_init() internal onlyInitializing {}
1126 
1127     function __Context_init_unchained() internal onlyInitializing {}
1128 
1129     function _msgSender() internal view virtual returns (address) {
1130         return msg.sender;
1131     }
1132 
1133     function _msgData() internal view virtual returns (bytes calldata) {
1134         return msg.data;
1135     }
1136 
1137     /**
1138      * @dev This empty reserved space is put in place to allow future versions to add new
1139      * variables without shifting down storage in the inheritance chain.
1140      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1141      */
1142     uint256[50] private __gap;
1143 }
1144 
1145 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v4.6.0
1146 
1147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1148 
1149 // pragma solidity ^0.8.0;
1150 
1151 /**
1152  * @dev Contract module which provides a basic access control mechanism, where
1153  * there is an account (an owner) that can be granted exclusive access to
1154  * specific functions.
1155  *
1156  * By default, the owner account will be the one that deploys the contract. This
1157  * can later be changed with {transferOwnership}.
1158  *
1159  * This module is used through inheritance. It will make available the modifier
1160  * `onlyOwner`, which can be applied to your functions to restrict their use to
1161  * the owner.
1162  */
1163 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(
1167         address indexed previousOwner,
1168         address indexed newOwner
1169     );
1170 
1171     /**
1172      * @dev Initializes the contract setting the deployer as the initial owner.
1173      */
1174     function __Ownable_init() internal onlyInitializing {
1175         __Ownable_init_unchained();
1176     }
1177 
1178     function __Ownable_init_unchained() internal onlyInitializing {
1179         _transferOwnership(_msgSender());
1180     }
1181 
1182     /**
1183      * @dev Returns the address of the current owner.
1184      */
1185     function owner() public view virtual returns (address) {
1186         return _owner;
1187     }
1188 
1189     /**
1190      * @dev Throws if called by any account other than the owner.
1191      */
1192     modifier onlyOwner() {
1193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1194         _;
1195     }
1196 
1197     /**
1198      * @dev Leaves the contract without owner. It will not be possible to call
1199      * `onlyOwner` functions anymore. Can only be called by the current owner.
1200      *
1201      * NOTE: Renouncing ownership will leave the contract without an owner,
1202      * thereby removing any functionality that is only available to the owner.
1203      */
1204     function renounceOwnership() public virtual onlyOwner {
1205         _transferOwnership(address(0));
1206     }
1207 
1208     /**
1209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1210      * Can only be called by the current owner.
1211      */
1212     function transferOwnership(address newOwner) public virtual onlyOwner {
1213         require(
1214             newOwner != address(0),
1215             "Ownable: new owner is the zero address"
1216         );
1217         _transferOwnership(newOwner);
1218     }
1219 
1220     /**
1221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1222      * Internal function without access restriction.
1223      */
1224     function _transferOwnership(address newOwner) internal virtual {
1225         address oldOwner = _owner;
1226         _owner = newOwner;
1227         emit OwnershipTransferred(oldOwner, newOwner);
1228     }
1229 
1230     /**
1231      * @dev This empty reserved space is put in place to allow future versions to add new
1232      * variables without shifting down storage in the inheritance chain.
1233      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1234      */
1235     uint256[49] private __gap;
1236 }
1237 
1238 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
1239 
1240 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1241 
1242 // pragma solidity ^0.8.1;
1243 
1244 /**
1245  * @dev Collection of functions related to the address type
1246  */
1247 library Address {
1248     /**
1249      * @dev Returns true if `account` is a contract.
1250      *
1251      * [IMPORTANT]
1252      * ====
1253      * It is unsafe to assume that an address for which this function returns
1254      * false is an externally-owned account (EOA) and not a contract.
1255      *
1256      * Among others, `isContract` will return false for the following
1257      * types of addresses:
1258      *
1259      *  - an externally-owned account
1260      *  - a contract in construction
1261      *  - an address where a contract will be created
1262      *  - an address where a contract lived, but was destroyed
1263      * ====
1264      *
1265      * [IMPORTANT]
1266      * ====
1267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1268      *
1269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1271      * constructor.
1272      * ====
1273      */
1274     function isContract(address account) internal view returns (bool) {
1275         // This method relies on extcodesize/address.code.length, which returns 0
1276         // for contracts in construction, since the code is only stored at the end
1277         // of the constructor execution.
1278 
1279         return account.code.length > 0;
1280     }
1281 
1282     /**
1283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1284      * `recipient`, forwarding all available gas and reverting on errors.
1285      *
1286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1288      * imposed by `transfer`, making them unable to receive funds via
1289      * `transfer`. {sendValue} removes this limitation.
1290      *
1291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1292      *
1293      * IMPORTANT: because control is transferred to `recipient`, care must be
1294      * taken to not create reentrancy vulnerabilities. Consider using
1295      * {ReentrancyGuard} or the
1296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1297      */
1298     function sendValue(address payable recipient, uint256 amount) internal {
1299         require(
1300             address(this).balance >= amount,
1301             "Address: insufficient balance"
1302         );
1303 
1304         (bool success, ) = recipient.call{value: amount}("");
1305         require(
1306             success,
1307             "Address: unable to send value, recipient may have reverted"
1308         );
1309     }
1310 
1311     /**
1312      * @dev Performs a Solidity function call using a low level `call`. A
1313      * plain `call` is an unsafe replacement for a function call: use this
1314      * function instead.
1315      *
1316      * If `target` reverts with a revert reason, it is bubbled up by this
1317      * function (like regular Solidity function calls).
1318      *
1319      * Returns the raw returned data. To convert to the expected return value,
1320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1321      *
1322      * Requirements:
1323      *
1324      * - `target` must be a contract.
1325      * - calling `target` with `data` must not revert.
1326      *
1327      * _Available since v3.1._
1328      */
1329     function functionCall(address target, bytes memory data)
1330         internal
1331         returns (bytes memory)
1332     {
1333         return functionCall(target, data, "Address: low-level call failed");
1334     }
1335 
1336     /**
1337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1338      * `errorMessage` as a fallback revert reason when `target` reverts.
1339      *
1340      * _Available since v3.1._
1341      */
1342     function functionCall(
1343         address target,
1344         bytes memory data,
1345         string memory errorMessage
1346     ) internal returns (bytes memory) {
1347         return functionCallWithValue(target, data, 0, errorMessage);
1348     }
1349 
1350     /**
1351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1352      * but also transferring `value` wei to `target`.
1353      *
1354      * Requirements:
1355      *
1356      * - the calling contract must have an ETH balance of at least `value`.
1357      * - the called Solidity function must be `payable`.
1358      *
1359      * _Available since v3.1._
1360      */
1361     function functionCallWithValue(
1362         address target,
1363         bytes memory data,
1364         uint256 value
1365     ) internal returns (bytes memory) {
1366         return
1367             functionCallWithValue(
1368                 target,
1369                 data,
1370                 value,
1371                 "Address: low-level call with value failed"
1372             );
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1377      * with `errorMessage` as a fallback revert reason when `target` reverts.
1378      *
1379      * _Available since v3.1._
1380      */
1381     function functionCallWithValue(
1382         address target,
1383         bytes memory data,
1384         uint256 value,
1385         string memory errorMessage
1386     ) internal returns (bytes memory) {
1387         require(
1388             address(this).balance >= value,
1389             "Address: insufficient balance for call"
1390         );
1391         require(isContract(target), "Address: call to non-contract");
1392 
1393         (bool success, bytes memory returndata) = target.call{value: value}(
1394             data
1395         );
1396         return verifyCallResult(success, returndata, errorMessage);
1397     }
1398 
1399     /**
1400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1401      * but performing a static call.
1402      *
1403      * _Available since v3.3._
1404      */
1405     function functionStaticCall(address target, bytes memory data)
1406         internal
1407         view
1408         returns (bytes memory)
1409     {
1410         return
1411             functionStaticCall(
1412                 target,
1413                 data,
1414                 "Address: low-level static call failed"
1415             );
1416     }
1417 
1418     /**
1419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1420      * but performing a static call.
1421      *
1422      * _Available since v3.3._
1423      */
1424     function functionStaticCall(
1425         address target,
1426         bytes memory data,
1427         string memory errorMessage
1428     ) internal view returns (bytes memory) {
1429         require(isContract(target), "Address: static call to non-contract");
1430 
1431         (bool success, bytes memory returndata) = target.staticcall(data);
1432         return verifyCallResult(success, returndata, errorMessage);
1433     }
1434 
1435     /**
1436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1437      * but performing a delegate call.
1438      *
1439      * _Available since v3.4._
1440      */
1441     function functionDelegateCall(address target, bytes memory data)
1442         internal
1443         returns (bytes memory)
1444     {
1445         return
1446             functionDelegateCall(
1447                 target,
1448                 data,
1449                 "Address: low-level delegate call failed"
1450             );
1451     }
1452 
1453     /**
1454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1455      * but performing a delegate call.
1456      *
1457      * _Available since v3.4._
1458      */
1459     function functionDelegateCall(
1460         address target,
1461         bytes memory data,
1462         string memory errorMessage
1463     ) internal returns (bytes memory) {
1464         require(isContract(target), "Address: delegate call to non-contract");
1465 
1466         (bool success, bytes memory returndata) = target.delegatecall(data);
1467         return verifyCallResult(success, returndata, errorMessage);
1468     }
1469 
1470     /**
1471      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1472      * revert reason using the provided one.
1473      *
1474      * _Available since v4.3._
1475      */
1476     function verifyCallResult(
1477         bool success,
1478         bytes memory returndata,
1479         string memory errorMessage
1480     ) internal pure returns (bytes memory) {
1481         if (success) {
1482             return returndata;
1483         } else {
1484             // Look for revert reason and bubble it up if present
1485             if (returndata.length > 0) {
1486                 // The easiest way to bubble the revert reason is using memory via assembly
1487 
1488                 assembly {
1489                     let returndata_size := mload(returndata)
1490                     revert(add(32, returndata), returndata_size)
1491                 }
1492             } else {
1493                 revert(errorMessage);
1494             }
1495         }
1496     }
1497 }
1498 
1499 // File contracts/Mailbox.sol
1500 
1501 // pragma solidity >=0.8.0;
1502 
1503 // ============ Internal Imports ============
1504 
1505 // ============ External Imports ============
1506 
1507 /**
1508  * @title Mailbox
1509  * @author Celo Labs Inc.
1510  * @notice Shared utilities between Outbox and Inbox.
1511  */
1512 abstract contract Mailbox is IMailbox, OwnableUpgradeable {
1513     // ============ Immutable Variables ============
1514 
1515     // Domain of chain on which the contract is deployed
1516     uint32 public immutable override localDomain;
1517 
1518     // ============ Public Variables ============
1519 
1520     // Address of the validator manager contract.
1521     address public validatorManager;
1522 
1523     // ============ Upgrade Gap ============
1524 
1525     // gap for upgrade safety
1526     uint256[49] private __GAP;
1527 
1528     // ============ Events ============
1529 
1530     /**
1531      * @notice Emitted when the validator manager contract is changed
1532      * @param validatorManager The address of the new validatorManager
1533      */
1534     event ValidatorManagerSet(address validatorManager);
1535 
1536     // ============ Modifiers ============
1537 
1538     /**
1539      * @notice Ensures that a function is called by the validator manager contract.
1540      */
1541     modifier onlyValidatorManager() {
1542         require(msg.sender == validatorManager, "!validatorManager");
1543         _;
1544     }
1545 
1546     // ============ Constructor ============
1547 
1548     constructor(uint32 _localDomain) {
1549         localDomain = _localDomain;
1550     }
1551 
1552     // ============ Initializer ============
1553 
1554     function __Mailbox_initialize(address _validatorManager)
1555         internal
1556         onlyInitializing
1557     {
1558         // initialize owner
1559         __Ownable_init();
1560         _setValidatorManager(_validatorManager);
1561     }
1562 
1563     // ============ External Functions ============
1564 
1565     /**
1566      * @notice Set a new validator manager contract
1567      * @dev Mailbox(es) will initially be initialized using a trusted validator manager contract;
1568      * we will progressively decentralize by swapping the trusted contract with a new implementation
1569      * that implements Validator bonding & slashing, and rules for Validator selection & rotation
1570      * @param _validatorManager the new validator manager contract
1571      */
1572     function setValidatorManager(address _validatorManager) external onlyOwner {
1573         _setValidatorManager(_validatorManager);
1574     }
1575 
1576     // ============ Internal Functions ============
1577 
1578     /**
1579      * @notice Set the validator manager
1580      * @param _validatorManager Address of the validator manager
1581      */
1582     function _setValidatorManager(address _validatorManager) internal {
1583         require(
1584             Address.isContract(_validatorManager),
1585             "!contract validatorManager"
1586         );
1587         validatorManager = _validatorManager;
1588         emit ValidatorManagerSet(_validatorManager);
1589     }
1590 }
1591 
1592 // File contracts/libs/Merkle.sol
1593 
1594 // pragma solidity >=0.6.11;
1595 
1596 // work based on eth2 deposit contract, which is used under CC0-1.0
1597 
1598 /**
1599  * @title MerkleLib
1600  * @author Celo Labs Inc.
1601  * @notice An incremental merkle tree modeled on the eth2 deposit contract.
1602  **/
1603 library MerkleLib {
1604     uint256 internal constant TREE_DEPTH = 32;
1605     uint256 internal constant MAX_LEAVES = 2**TREE_DEPTH - 1;
1606 
1607     /**
1608      * @notice Struct representing incremental merkle tree. Contains current
1609      * branch and the number of inserted leaves in the tree.
1610      **/
1611     struct Tree {
1612         bytes32[TREE_DEPTH] branch;
1613         uint256 count;
1614     }
1615 
1616     /**
1617      * @notice Inserts `_node` into merkle tree
1618      * @dev Reverts if tree is full
1619      * @param _node Element to insert into tree
1620      **/
1621     function insert(Tree storage _tree, bytes32 _node) internal {
1622         require(_tree.count < MAX_LEAVES, "merkle tree full");
1623 
1624         _tree.count += 1;
1625         uint256 size = _tree.count;
1626         for (uint256 i = 0; i < TREE_DEPTH; i++) {
1627             if ((size & 1) == 1) {
1628                 _tree.branch[i] = _node;
1629                 return;
1630             }
1631             _node = keccak256(abi.encodePacked(_tree.branch[i], _node));
1632             size /= 2;
1633         }
1634         // As the loop should always end prematurely with the `return` statement,
1635         // this code should be unreachable. We assert `false` just to be safe.
1636         assert(false);
1637     }
1638 
1639     /**
1640      * @notice Calculates and returns`_tree`'s current root given array of zero
1641      * hashes
1642      * @param _zeroes Array of zero hashes
1643      * @return _current Calculated root of `_tree`
1644      **/
1645     function rootWithCtx(Tree storage _tree, bytes32[TREE_DEPTH] memory _zeroes)
1646         internal
1647         view
1648         returns (bytes32 _current)
1649     {
1650         uint256 _index = _tree.count;
1651 
1652         for (uint256 i = 0; i < TREE_DEPTH; i++) {
1653             uint256 _ithBit = (_index >> i) & 0x01;
1654             bytes32 _next = _tree.branch[i];
1655             if (_ithBit == 1) {
1656                 _current = keccak256(abi.encodePacked(_next, _current));
1657             } else {
1658                 _current = keccak256(abi.encodePacked(_current, _zeroes[i]));
1659             }
1660         }
1661     }
1662 
1663     /// @notice Calculates and returns`_tree`'s current root
1664     function root(Tree storage _tree) internal view returns (bytes32) {
1665         return rootWithCtx(_tree, zeroHashes());
1666     }
1667 
1668     /// @notice Returns array of TREE_DEPTH zero hashes
1669     /// @return _zeroes Array of TREE_DEPTH zero hashes
1670     function zeroHashes()
1671         internal
1672         pure
1673         returns (bytes32[TREE_DEPTH] memory _zeroes)
1674     {
1675         _zeroes[0] = Z_0;
1676         _zeroes[1] = Z_1;
1677         _zeroes[2] = Z_2;
1678         _zeroes[3] = Z_3;
1679         _zeroes[4] = Z_4;
1680         _zeroes[5] = Z_5;
1681         _zeroes[6] = Z_6;
1682         _zeroes[7] = Z_7;
1683         _zeroes[8] = Z_8;
1684         _zeroes[9] = Z_9;
1685         _zeroes[10] = Z_10;
1686         _zeroes[11] = Z_11;
1687         _zeroes[12] = Z_12;
1688         _zeroes[13] = Z_13;
1689         _zeroes[14] = Z_14;
1690         _zeroes[15] = Z_15;
1691         _zeroes[16] = Z_16;
1692         _zeroes[17] = Z_17;
1693         _zeroes[18] = Z_18;
1694         _zeroes[19] = Z_19;
1695         _zeroes[20] = Z_20;
1696         _zeroes[21] = Z_21;
1697         _zeroes[22] = Z_22;
1698         _zeroes[23] = Z_23;
1699         _zeroes[24] = Z_24;
1700         _zeroes[25] = Z_25;
1701         _zeroes[26] = Z_26;
1702         _zeroes[27] = Z_27;
1703         _zeroes[28] = Z_28;
1704         _zeroes[29] = Z_29;
1705         _zeroes[30] = Z_30;
1706         _zeroes[31] = Z_31;
1707     }
1708 
1709     /**
1710      * @notice Calculates and returns the merkle root for the given leaf
1711      * `_item`, a merkle branch, and the index of `_item` in the tree.
1712      * @param _item Merkle leaf
1713      * @param _branch Merkle proof
1714      * @param _index Index of `_item` in tree
1715      * @return _current Calculated merkle root
1716      **/
1717     function branchRoot(
1718         bytes32 _item,
1719         bytes32[TREE_DEPTH] memory _branch,
1720         uint256 _index
1721     ) internal pure returns (bytes32 _current) {
1722         _current = _item;
1723 
1724         for (uint256 i = 0; i < TREE_DEPTH; i++) {
1725             uint256 _ithBit = (_index >> i) & 0x01;
1726             bytes32 _next = _branch[i];
1727             if (_ithBit == 1) {
1728                 _current = keccak256(abi.encodePacked(_next, _current));
1729             } else {
1730                 _current = keccak256(abi.encodePacked(_current, _next));
1731             }
1732         }
1733     }
1734 
1735     // keccak256 zero hashes
1736     bytes32 internal constant Z_0 =
1737         hex"0000000000000000000000000000000000000000000000000000000000000000";
1738     bytes32 internal constant Z_1 =
1739         hex"ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5";
1740     bytes32 internal constant Z_2 =
1741         hex"b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d30";
1742     bytes32 internal constant Z_3 =
1743         hex"21ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85";
1744     bytes32 internal constant Z_4 =
1745         hex"e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344";
1746     bytes32 internal constant Z_5 =
1747         hex"0eb01ebfc9ed27500cd4dfc979272d1f0913cc9f66540d7e8005811109e1cf2d";
1748     bytes32 internal constant Z_6 =
1749         hex"887c22bd8750d34016ac3c66b5ff102dacdd73f6b014e710b51e8022af9a1968";
1750     bytes32 internal constant Z_7 =
1751         hex"ffd70157e48063fc33c97a050f7f640233bf646cc98d9524c6b92bcf3ab56f83";
1752     bytes32 internal constant Z_8 =
1753         hex"9867cc5f7f196b93bae1e27e6320742445d290f2263827498b54fec539f756af";
1754     bytes32 internal constant Z_9 =
1755         hex"cefad4e508c098b9a7e1d8feb19955fb02ba9675585078710969d3440f5054e0";
1756     bytes32 internal constant Z_10 =
1757         hex"f9dc3e7fe016e050eff260334f18a5d4fe391d82092319f5964f2e2eb7c1c3a5";
1758     bytes32 internal constant Z_11 =
1759         hex"f8b13a49e282f609c317a833fb8d976d11517c571d1221a265d25af778ecf892";
1760     bytes32 internal constant Z_12 =
1761         hex"3490c6ceeb450aecdc82e28293031d10c7d73bf85e57bf041a97360aa2c5d99c";
1762     bytes32 internal constant Z_13 =
1763         hex"c1df82d9c4b87413eae2ef048f94b4d3554cea73d92b0f7af96e0271c691e2bb";
1764     bytes32 internal constant Z_14 =
1765         hex"5c67add7c6caf302256adedf7ab114da0acfe870d449a3a489f781d659e8becc";
1766     bytes32 internal constant Z_15 =
1767         hex"da7bce9f4e8618b6bd2f4132ce798cdc7a60e7e1460a7299e3c6342a579626d2";
1768     bytes32 internal constant Z_16 =
1769         hex"2733e50f526ec2fa19a22b31e8ed50f23cd1fdf94c9154ed3a7609a2f1ff981f";
1770     bytes32 internal constant Z_17 =
1771         hex"e1d3b5c807b281e4683cc6d6315cf95b9ade8641defcb32372f1c126e398ef7a";
1772     bytes32 internal constant Z_18 =
1773         hex"5a2dce0a8a7f68bb74560f8f71837c2c2ebbcbf7fffb42ae1896f13f7c7479a0";
1774     bytes32 internal constant Z_19 =
1775         hex"b46a28b6f55540f89444f63de0378e3d121be09e06cc9ded1c20e65876d36aa0";
1776     bytes32 internal constant Z_20 =
1777         hex"c65e9645644786b620e2dd2ad648ddfcbf4a7e5b1a3a4ecfe7f64667a3f0b7e2";
1778     bytes32 internal constant Z_21 =
1779         hex"f4418588ed35a2458cffeb39b93d26f18d2ab13bdce6aee58e7b99359ec2dfd9";
1780     bytes32 internal constant Z_22 =
1781         hex"5a9c16dc00d6ef18b7933a6f8dc65ccb55667138776f7dea101070dc8796e377";
1782     bytes32 internal constant Z_23 =
1783         hex"4df84f40ae0c8229d0d6069e5c8f39a7c299677a09d367fc7b05e3bc380ee652";
1784     bytes32 internal constant Z_24 =
1785         hex"cdc72595f74c7b1043d0e1ffbab734648c838dfb0527d971b602bc216c9619ef";
1786     bytes32 internal constant Z_25 =
1787         hex"0abf5ac974a1ed57f4050aa510dd9c74f508277b39d7973bb2dfccc5eeb0618d";
1788     bytes32 internal constant Z_26 =
1789         hex"b8cd74046ff337f0a7bf2c8e03e10f642c1886798d71806ab1e888d9e5ee87d0";
1790     bytes32 internal constant Z_27 =
1791         hex"838c5655cb21c6cb83313b5a631175dff4963772cce9108188b34ac87c81c41e";
1792     bytes32 internal constant Z_28 =
1793         hex"662ee4dd2dd7b2bc707961b1e646c4047669dcb6584f0d8d770daf5d7e7deb2e";
1794     bytes32 internal constant Z_29 =
1795         hex"388ab20e2573d171a88108e79d820e98f26c0b84aa8b2f4aa4968dbb818ea322";
1796     bytes32 internal constant Z_30 =
1797         hex"93237c50ba75ee485f4c22adf2f741400bdf8d6a9cc7df7ecae576221665d735";
1798     bytes32 internal constant Z_31 =
1799         hex"8448818bb4ae4562849e949e17ac16e0be16688e156b5cf15e098c627c0056a9";
1800 }
1801 
1802 // File contracts/libs/TypeCasts.sol
1803 
1804 // pragma solidity >=0.6.11;
1805 
1806 library TypeCasts {
1807     // treat it as a null-terminated string of max 32 bytes
1808     function coerceString(bytes32 _buf)
1809         internal
1810         pure
1811         returns (string memory _newStr)
1812     {
1813         uint8 _slen = 0;
1814         while (_slen < 32 && _buf[_slen] != 0) {
1815             _slen++;
1816         }
1817 
1818         // solhint-disable-next-line no-inline-assembly
1819         assembly {
1820             _newStr := mload(0x40)
1821             mstore(0x40, add(_newStr, 0x40)) // may end up with extra
1822             mstore(_newStr, _slen)
1823             mstore(add(_newStr, 0x20), _buf)
1824         }
1825     }
1826 
1827     // alignment preserving cast
1828     function addressToBytes32(address _addr) internal pure returns (bytes32) {
1829         return bytes32(uint256(uint160(_addr)));
1830     }
1831 
1832     // alignment preserving cast
1833     function bytes32ToAddress(bytes32 _buf) internal pure returns (address) {
1834         return address(uint160(uint256(_buf)));
1835     }
1836 }
1837 
1838 // File contracts/libs/Message.sol
1839 
1840 // pragma solidity >=0.8.0;
1841 
1842 /**
1843  * @title Message Library
1844  * @author Celo Labs Inc.
1845  * @notice Library for formatted messages used by Outbox and Replica.
1846  **/
1847 library Message {
1848     using TypeCasts for bytes32;
1849 
1850     /**
1851      * @notice Returns formatted (packed) message with provided fields
1852      * @dev This function should only be used in memory message construction.
1853      * @param _originDomain Domain of home chain
1854      * @param _sender Address of sender as bytes32
1855      * @param _destinationDomain Domain of destination chain
1856      * @param _recipient Address of recipient on destination chain as bytes32
1857      * @param _messageBody Raw bytes of message body
1858      * @return Formatted message
1859      **/
1860     function formatMessage(
1861         uint32 _originDomain,
1862         bytes32 _sender,
1863         uint32 _destinationDomain,
1864         bytes32 _recipient,
1865         bytes calldata _messageBody
1866     ) internal pure returns (bytes memory) {
1867         return
1868             abi.encodePacked(
1869                 _originDomain,
1870                 _sender,
1871                 _destinationDomain,
1872                 _recipient,
1873                 _messageBody
1874             );
1875     }
1876 
1877     /**
1878      * @notice Returns leaf of formatted message with provided fields.
1879      * @dev hash of abi packed message and leaf index.
1880      * @param _message Raw bytes of message contents.
1881      * @param _leafIndex Index of the message in the tree
1882      * @return Leaf (hash) of formatted message
1883      */
1884     function leaf(bytes calldata _message, uint256 _leafIndex)
1885         internal
1886         pure
1887         returns (bytes32)
1888     {
1889         return keccak256(abi.encodePacked(_message, _leafIndex));
1890     }
1891 
1892     /**
1893      * @notice Decode raw message bytes into structured message fields.
1894      * @dev Efficiently slices calldata into structured message fields.
1895      * @param _message Raw bytes of message contents.
1896      * @return origin Domain of home chain
1897      * @return sender Address of sender as bytes32
1898      * @return destination Domain of destination chain
1899      * @return recipient Address of recipient on destination chain as bytes32
1900      * @return body Raw bytes of message body
1901      */
1902     function destructure(bytes calldata _message)
1903         internal
1904         pure
1905         returns (
1906             uint32 origin,
1907             bytes32 sender,
1908             uint32 destination,
1909             bytes32 recipient,
1910             bytes calldata body
1911         )
1912     {
1913         return (
1914             uint32(bytes4(_message[0:4])),
1915             bytes32(_message[4:36]),
1916             uint32(bytes4(_message[36:40])),
1917             bytes32(_message[40:72]),
1918             bytes(_message[72:])
1919         );
1920     }
1921 
1922     /**
1923      * @notice Decode raw message bytes into structured message fields.
1924      * @dev Efficiently slices calldata into structured message fields.
1925      * @param _message Raw bytes of message contents.
1926      * @return origin Domain of home chain
1927      * @return sender Address of sender as address (bytes20)
1928      * @return destination Domain of destination chain
1929      * @return recipient Address of recipient on destination chain as address (bytes20)
1930      * @return body Raw bytes of message body
1931      */
1932     function destructureAddresses(bytes calldata _message)
1933         internal
1934         pure
1935         returns (
1936             uint32,
1937             address,
1938             uint32,
1939             address,
1940             bytes calldata
1941         )
1942     {
1943         (
1944             uint32 _origin,
1945             bytes32 _sender,
1946             uint32 destination,
1947             bytes32 _recipient,
1948             bytes calldata body
1949         ) = destructure(_message);
1950         return (
1951             _origin,
1952             _sender.bytes32ToAddress(),
1953             destination,
1954             _recipient.bytes32ToAddress(),
1955             body
1956         );
1957     }
1958 }
1959 
1960 // File interfaces/IMessageRecipient.sol
1961 
1962 // pragma solidity >=0.6.11;
1963 
1964 interface IMessageRecipient {
1965     function handle(
1966         uint32 _origin,
1967         bytes32 _sender,
1968         bytes calldata _message
1969     ) external;
1970 }
1971 
1972 // File interfaces/IInbox.sol
1973 
1974 // pragma solidity >=0.6.11;
1975 
1976 interface IInbox is IMailbox {
1977     function remoteDomain() external returns (uint32);
1978 
1979     function process(
1980         bytes32 _root,
1981         uint256 _index,
1982         bytes calldata _message,
1983         bytes32[32] calldata _proof,
1984         uint256 _leafIndex
1985     ) external;
1986 }
1987 
1988 // File @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol@v4.6.0
1989 
1990 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1991 
1992 // pragma solidity ^0.8.0;
1993 
1994 /**
1995  * @dev Contract module that helps prevent reentrant calls to a function.
1996  *
1997  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1998  * available, which can be applied to functions to make sure there are no nested
1999  * (reentrant) calls to them.
2000  *
2001  * Note that because there is a single `nonReentrant` guard, functions marked as
2002  * `nonReentrant` may not call one another. This can be worked around by making
2003  * those functions `private`, and then adding `external` `nonReentrant` entry
2004  * points to them.
2005  *
2006  * TIP: If you would like to learn more about reentrancy and alternative ways
2007  * to protect against it, check out our blog post
2008  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2009  */
2010 abstract contract ReentrancyGuardUpgradeable is Initializable {
2011     // Booleans are more expensive than uint256 or any type that takes up a full
2012     // word because each write operation emits an extra SLOAD to first read the
2013     // slot's contents, replace the bits taken up by the boolean, and then write
2014     // back. This is the compiler's defense against contract upgrades and
2015     // pointer aliasing, and it cannot be disabled.
2016 
2017     // The values being non-zero value makes deployment a bit more expensive,
2018     // but in exchange the refund on every call to nonReentrant will be lower in
2019     // amount. Since refunds are capped to a percentage of the total
2020     // transaction's gas, it is best to keep them low in cases like this one, to
2021     // increase the likelihood of the full refund coming into effect.
2022     uint256 private constant _NOT_ENTERED = 1;
2023     uint256 private constant _ENTERED = 2;
2024 
2025     uint256 private _status;
2026 
2027     function __ReentrancyGuard_init() internal onlyInitializing {
2028         __ReentrancyGuard_init_unchained();
2029     }
2030 
2031     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
2032         _status = _NOT_ENTERED;
2033     }
2034 
2035     /**
2036      * @dev Prevents a contract from calling itself, directly or indirectly.
2037      * Calling a `nonReentrant` function from another `nonReentrant`
2038      * function is not supported. It is possible to prevent this from happening
2039      * by making the `nonReentrant` function external, and making it call a
2040      * `private` function that does the actual work.
2041      */
2042     modifier nonReentrant() {
2043         // On the first call to nonReentrant, _notEntered will be true
2044         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2045 
2046         // Any calls to nonReentrant after this point will fail
2047         _status = _ENTERED;
2048 
2049         _;
2050 
2051         // By storing the original value once again, a refund is triggered (see
2052         // https://eips.ethereum.org/EIPS/eip-2200)
2053         _status = _NOT_ENTERED;
2054     }
2055 
2056     /**
2057      * @dev This empty reserved space is put in place to allow future versions to add new
2058      * variables without shifting down storage in the inheritance chain.
2059      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2060      */
2061     uint256[49] private __gap;
2062 }
2063 
2064 // File contracts/Inbox.sol
2065 
2066 // pragma solidity >=0.8.0;
2067 
2068 // ============ Internal Imports ============
2069 
2070 // ============ External Imports ============
2071 
2072 /**
2073  * @title Inbox
2074  * @author Celo Labs Inc.
2075  * @notice Track root updates on Outbox, prove and dispatch messages to end
2076  * recipients.
2077  */
2078 contract Inbox is IInbox, ReentrancyGuardUpgradeable, Version0, Mailbox {
2079     // ============ Libraries ============
2080 
2081     using MerkleLib for MerkleLib.Tree;
2082     using Message for bytes;
2083     using TypeCasts for bytes32;
2084 
2085     // ============ Enums ============
2086 
2087     // Status of Message:
2088     //   0 - None - message has not been processed
2089     //   1 - Processed - message has been dispatched to recipient
2090     enum MessageStatus {
2091         None,
2092         Processed
2093     }
2094 
2095     // ============ Public Storage ============
2096 
2097     // Domain of outbox chain
2098     uint32 public override remoteDomain;
2099     // Mapping of message leaves to MessageStatus
2100     mapping(bytes32 => MessageStatus) public messages;
2101 
2102     // ============ Upgrade Gap ============
2103 
2104     // gap for upgrade safety
2105     uint256[48] private __GAP;
2106 
2107     // ============ Events ============
2108 
2109     /**
2110      * @notice Emitted when message is processed
2111      * @dev This event allows watchers to observe the merkle proof they need
2112      * to prove fraud on the Outbox.
2113      * @param messageHash Hash of message that was processed.
2114      */
2115     event Process(bytes32 indexed messageHash);
2116 
2117     // ============ Constructor ============
2118 
2119     // solhint-disable-next-line no-empty-blocks
2120     constructor(uint32 _localDomain) Mailbox(_localDomain) {}
2121 
2122     // ============ Initializer ============
2123 
2124     function initialize(uint32 _remoteDomain, address _validatorManager)
2125         public
2126         initializer
2127     {
2128         __ReentrancyGuard_init();
2129         __Mailbox_initialize(_validatorManager);
2130         remoteDomain = _remoteDomain;
2131     }
2132 
2133     // ============ External Functions ============
2134 
2135     /**
2136      * @notice Attempts to process the provided formatted `message`. Performs
2137      * verification against root of the proof
2138      * @dev Called by the validator manager, which is responsible for verifying a
2139      * quorum of validator signatures on the checkpoint.
2140      * @dev Reverts if verification of the message fails.
2141      * @param _root The merkle root of the checkpoint used to prove message inclusion.
2142      * @param _index The index of the checkpoint used to prove message inclusion.
2143      * @param _message Formatted message (refer to Mailbox.sol Message library)
2144      * @param _proof Merkle proof of inclusion for message's leaf
2145      * @param _leafIndex Index of leaf in outbox's merkle tree
2146      */
2147     function process(
2148         bytes32 _root,
2149         uint256 _index,
2150         bytes calldata _message,
2151         bytes32[32] calldata _proof,
2152         uint256 _leafIndex
2153     ) external override nonReentrant onlyValidatorManager {
2154         require(_index >= _leafIndex, "!index");
2155         bytes32 _messageHash = _message.leaf(_leafIndex);
2156         // ensure that message has not been processed
2157         require(
2158             messages[_messageHash] == MessageStatus.None,
2159             "!MessageStatus.None"
2160         );
2161         // calculate the expected root based on the proof
2162         bytes32 _calculatedRoot = MerkleLib.branchRoot(
2163             _messageHash,
2164             _proof,
2165             _leafIndex
2166         );
2167         // verify the merkle proof
2168         require(_calculatedRoot == _root, "!proof");
2169         _process(_message, _messageHash);
2170         emit Process(_messageHash);
2171     }
2172 
2173     // ============ Internal Functions ============
2174 
2175     /**
2176      * @notice Marks a message as processed and calls handle on the recipient
2177      * @dev Internal function that can be called by contracts like TestInbox
2178      * @param _message Formatted message (refer to Mailbox.sol Message library)
2179      * @param _messageHash keccak256 hash of the message
2180      */
2181     function _process(bytes calldata _message, bytes32 _messageHash) internal {
2182         (
2183             uint32 origin,
2184             bytes32 sender,
2185             uint32 destination,
2186             bytes32 recipient,
2187             bytes calldata body
2188         ) = _message.destructure();
2189 
2190         // ensure message was meant for this domain
2191         require(destination == localDomain, "!destination");
2192 
2193         // update message status as processed
2194         messages[_messageHash] = MessageStatus.Processed;
2195 
2196         IMessageRecipient(recipient.bytes32ToAddress()).handle(
2197             origin,
2198             sender,
2199             body
2200         );
2201     }
2202 }
2203 
2204 // File interfaces/IInterchainGasPaymaster.sol
2205 
2206 // pragma solidity >=0.6.11;
2207 
2208 /**
2209  * @title IInterchainGasPaymaster
2210  * @notice Manages payments on a source chain to cover gas costs of relaying
2211  * messages to destination chains.
2212  */
2213 interface IInterchainGasPaymaster {
2214     function payGasFor(
2215         address _outbox,
2216         uint256 _leafIndex,
2217         uint32 _destinationDomain
2218     ) external payable;
2219 }
2220 
2221 // File contracts/InterchainGasPaymaster.sol
2222 
2223 // pragma solidity >=0.8.0;
2224 
2225 // ============ Internal Imports ============
2226 
2227 // ============ External Imports ============
2228 
2229 /**
2230  * @title InterchainGasPaymaster
2231  * @notice Manages payments on a source chain to cover gas costs of relaying
2232  * messages to destination chains.
2233  */
2234 contract InterchainGasPaymaster is IInterchainGasPaymaster, OwnableUpgradeable {
2235     // ============ Events ============
2236 
2237     /**
2238      * @notice Emitted when a payment is made for a message's gas costs.
2239      * @param outbox The address of the Outbox contract.
2240      * @param leafIndex The index of the message in the Outbox merkle tree.
2241      * @param amount The amount of native tokens paid.
2242      */
2243     event GasPayment(address indexed outbox, uint256 leafIndex, uint256 amount);
2244 
2245     // ============ Constructor ============
2246 
2247     // solhint-disable-next-line no-empty-blocks
2248     constructor() {
2249         initialize(); // allows contract to be used without proxying
2250     }
2251 
2252     // ============ External Functions ============
2253 
2254     function initialize() public initializer {
2255         __Ownable_init();
2256     }
2257 
2258     /**
2259      * @notice Deposits msg.value as a payment for the relaying of a message
2260      * to its destination chain.
2261      * @param _outbox The address of the Outbox contract.
2262      * @param _leafIndex The index of the message in the Outbox merkle tree.
2263      * @param _destinationDomain The domain of the message's destination chain.
2264      */
2265     function payGasFor(
2266         address _outbox,
2267         uint256 _leafIndex,
2268         uint32 _destinationDomain
2269     ) external payable override {
2270         // Silence compiler warning. The NatSpec @param requires the parameter to be named.
2271         // While not used at the moment, future versions of the paymaster may conditionally
2272         // forward payments depending on the destination domain.
2273         _destinationDomain;
2274 
2275         emit GasPayment(_outbox, _leafIndex, msg.value);
2276     }
2277 
2278     /**
2279      * @notice Transfers the entire native token balance to the owner of the contract.
2280      * @dev The owner must be able to receive native tokens.
2281      */
2282     function claim() external {
2283         // Transfer the entire balance to owner.
2284         (bool success, ) = owner().call{value: address(this).balance}("");
2285         require(success, "!transfer");
2286     }
2287 }
2288 
2289 // File contracts/MerkleTreeManager.sol
2290 
2291 // pragma solidity >=0.8.0;
2292 
2293 // ============ Internal Imports ============
2294 
2295 /**
2296  * @title MerkleTreeManager
2297  * @author Celo Labs Inc.
2298  * @notice Contains a Merkle tree instance and
2299  * exposes view functions for the tree.
2300  */
2301 contract MerkleTreeManager {
2302     // ============ Libraries ============
2303 
2304     using MerkleLib for MerkleLib.Tree;
2305     MerkleLib.Tree public tree;
2306 
2307     // ============ Upgrade Gap ============
2308 
2309     // gap for upgrade safety
2310     uint256[49] private __GAP;
2311 
2312     // ============ Public Functions ============
2313 
2314     /**
2315      * @notice Calculates and returns tree's current root
2316      */
2317     function root() public view returns (bytes32) {
2318         return tree.root();
2319     }
2320 }
2321 
2322 // File contracts/Outbox.sol
2323 
2324 // pragma solidity >=0.8.0;
2325 
2326 // ============ Internal Imports ============
2327 
2328 /**
2329  * @title Outbox
2330  * @author Celo Labs Inc.
2331  * @notice Accepts messages to be dispatched to remote chains,
2332  * constructs a Merkle tree of the messages,
2333  * and accepts signatures from a bonded Validator
2334  * which notarize the Merkle tree roots.
2335  * Accepts submissions of fraudulent signatures
2336  * by the Validator and slashes the Validator in this case.
2337  */
2338 contract Outbox is IOutbox, Version0, MerkleTreeManager, Mailbox {
2339     // ============ Libraries ============
2340 
2341     using MerkleLib for MerkleLib.Tree;
2342     using TypeCasts for address;
2343 
2344     // ============ Constants ============
2345 
2346     // Maximum bytes per message = 2 KiB
2347     // (somewhat arbitrarily set to begin)
2348     uint256 public constant MAX_MESSAGE_BODY_BYTES = 2 * 2**10;
2349 
2350     // ============ Enums ============
2351 
2352     // States:
2353     //   0 - UnInitialized - before initialize function is called
2354     //   note: the contract is initialized at deploy time, so it should never be in this state
2355     //   1 - Active - as long as the contract has not become fraudulent
2356     //   2 - Failed - after a valid fraud proof has been submitted;
2357     //   contract will no longer accept updates or new messages
2358     enum States {
2359         UnInitialized,
2360         Active,
2361         Failed
2362     }
2363 
2364     // ============ Public Storage Variables ============
2365 
2366     // Cached checkpoints, mapping root => leaf index.
2367     // Cached checkpoints must have index > 0 as the presence of such
2368     // a checkpoint cannot be distinguished from its absence.
2369     mapping(bytes32 => uint256) public cachedCheckpoints;
2370     // The latest cached root
2371     bytes32 public latestCachedRoot;
2372     // Current state of contract
2373     States public state;
2374 
2375     // ============ Upgrade Gap ============
2376 
2377     // gap for upgrade safety
2378     uint256[47] private __GAP;
2379 
2380     // ============ Events ============
2381 
2382     /**
2383      * @notice Emitted when a checkpoint is cached.
2384      * @param root Merkle root
2385      * @param index Leaf index
2386      */
2387     event CheckpointCached(bytes32 indexed root, uint256 indexed index);
2388 
2389     /**
2390      * @notice Emitted when a new message is dispatched via Abacus
2391      * @param leafIndex Index of message's leaf in merkle tree
2392      * @param message Raw bytes of message
2393      */
2394     event Dispatch(uint256 indexed leafIndex, bytes message);
2395 
2396     event Fail();
2397 
2398     // ============ Constructor ============
2399 
2400     constructor(uint32 _localDomain) Mailbox(_localDomain) {} // solhint-disable-line no-empty-blocks
2401 
2402     // ============ Initializer ============
2403 
2404     function initialize(address _validatorManager) public initializer {
2405         __Mailbox_initialize(_validatorManager);
2406         state = States.Active;
2407     }
2408 
2409     // ============ Modifiers ============
2410 
2411     /**
2412      * @notice Ensures that contract state != FAILED when the function is called
2413      */
2414     modifier notFailed() {
2415         require(state != States.Failed, "failed state");
2416         _;
2417     }
2418 
2419     // ============ External Functions  ============
2420 
2421     /**
2422      * @notice Dispatch the message it to the destination domain & recipient
2423      * @dev Format the message, insert its hash into Merkle tree,
2424      * and emit `Dispatch` event with message information.
2425      * @param _destinationDomain Domain of destination chain
2426      * @param _recipientAddress Address of recipient on destination chain as bytes32
2427      * @param _messageBody Raw bytes content of message
2428      * @return The leaf index of the dispatched message's hash in the Merkle tree.
2429      */
2430     function dispatch(
2431         uint32 _destinationDomain,
2432         bytes32 _recipientAddress,
2433         bytes calldata _messageBody
2434     ) external override notFailed returns (uint256) {
2435         require(_messageBody.length <= MAX_MESSAGE_BODY_BYTES, "msg too long");
2436         // The leaf has not been inserted yet at this point1
2437         uint256 _leafIndex = count();
2438         // format the message into packed bytes
2439         bytes memory _message = Message.formatMessage(
2440             localDomain,
2441             msg.sender.addressToBytes32(),
2442             _destinationDomain,
2443             _recipientAddress,
2444             _messageBody
2445         );
2446         // insert the hashed message into the Merkle tree
2447         bytes32 _messageHash = keccak256(
2448             abi.encodePacked(_message, _leafIndex)
2449         );
2450         tree.insert(_messageHash);
2451         emit Dispatch(_leafIndex, _message);
2452         return _leafIndex;
2453     }
2454 
2455     /**
2456      * @notice Caches the current merkle root and index.
2457      * @dev emits CheckpointCached event
2458      */
2459     function cacheCheckpoint() external override notFailed {
2460         (bytes32 _root, uint256 _index) = latestCheckpoint();
2461         require(_index > 0, "!index");
2462         cachedCheckpoints[_root] = _index;
2463         latestCachedRoot = _root;
2464         emit CheckpointCached(_root, _index);
2465     }
2466 
2467     /**
2468      * @notice Set contract state to FAILED.
2469      * @dev Called by the validator manager when fraud is proven.
2470      */
2471     function fail() external override onlyValidatorManager {
2472         // set contract to FAILED
2473         state = States.Failed;
2474         emit Fail();
2475     }
2476 
2477     /**
2478      * @notice Returns the latest entry in the checkpoint cache.
2479      * @return root Latest cached root
2480      * @return index Latest cached index
2481      */
2482     function latestCachedCheckpoint()
2483         external
2484         view
2485         returns (bytes32 root, uint256 index)
2486     {
2487         root = latestCachedRoot;
2488         index = cachedCheckpoints[root];
2489     }
2490 
2491     /**
2492      * @notice Returns the number of inserted leaves in the tree
2493      */
2494     function count() public view returns (uint256) {
2495         return tree.count;
2496     }
2497 
2498     /**
2499      * @notice Returns a checkpoint representing the current merkle tree.
2500      * @return root The root of the Outbox's merkle tree.
2501      * @return index The index of the last element in the tree.
2502      */
2503     function latestCheckpoint() public view returns (bytes32, uint256) {
2504         return (root(), count() - 1);
2505     }
2506 }
2507 
2508 // File contracts/test/bad-recipient/BadRecipient1.sol
2509 
2510 // pragma solidity >=0.8.0;
2511 
2512 contract BadRecipient1 is IMessageRecipient {
2513     function handle(
2514         uint32,
2515         bytes32,
2516         bytes calldata
2517     ) external pure override {
2518         assembly {
2519             revert(0, 0)
2520         }
2521     }
2522 }
2523 
2524 // File contracts/test/bad-recipient/BadRecipient3.sol
2525 
2526 // pragma solidity >=0.8.0;
2527 
2528 contract BadRecipient3 is IMessageRecipient {
2529     function handle(
2530         uint32,
2531         bytes32,
2532         bytes calldata
2533     ) external pure override {
2534         assembly {
2535             mstore(0, 0xabcdef)
2536             revert(0, 32)
2537         }
2538     }
2539 }
2540 
2541 // File contracts/test/bad-recipient/BadRecipient5.sol
2542 
2543 // pragma solidity >=0.8.0;
2544 
2545 contract BadRecipient5 is IMessageRecipient {
2546     function handle(
2547         uint32,
2548         bytes32,
2549         bytes calldata
2550     ) external pure override {
2551         require(false, "no can do");
2552     }
2553 }
2554 
2555 // File contracts/test/bad-recipient/BadRecipient6.sol
2556 
2557 // pragma solidity >=0.8.0;
2558 
2559 contract BadRecipient6 is IMessageRecipient {
2560     function handle(
2561         uint32,
2562         bytes32,
2563         bytes calldata
2564     ) external pure override {
2565         require(false); // solhint-disable-line reason-string
2566     }
2567 }
2568 
2569 // File contracts/test/MysteryMath.sol
2570 
2571 // pragma solidity >=0.8.0;
2572 
2573 abstract contract MysteryMath {
2574     uint256 public stateVar;
2575 
2576     function setState(uint256 _var) external {
2577         stateVar = _var;
2578     }
2579 
2580     function getState() external view returns (uint256) {
2581         return stateVar;
2582     }
2583 
2584     function doMath(uint256 a, uint256 b)
2585         external
2586         pure
2587         virtual
2588         returns (uint256 _result);
2589 }
2590 
2591 // File contracts/test/MysteryMathV1.sol
2592 
2593 // pragma solidity >=0.8.0;
2594 
2595 contract MysteryMathV1 is MysteryMath {
2596     uint32 public immutable version;
2597 
2598     constructor() {
2599         version = 1;
2600     }
2601 
2602     function doMath(uint256 a, uint256 b)
2603         external
2604         pure
2605         override
2606         returns (uint256 _result)
2607     {
2608         _result = a + b;
2609     }
2610 }
2611 
2612 // File contracts/test/MysteryMathV2.sol
2613 
2614 // pragma solidity >=0.8.0;
2615 
2616 contract MysteryMathV2 is MysteryMath {
2617     uint32 public immutable version;
2618 
2619     constructor() {
2620         version = 2;
2621     }
2622 
2623     function doMath(uint256 a, uint256 b)
2624         external
2625         pure
2626         override
2627         returns (uint256 _result)
2628     {
2629         _result = a * b;
2630     }
2631 }
2632 
2633 // File contracts/test/TestInbox.sol
2634 
2635 // pragma solidity >=0.8.0;
2636 
2637 contract TestInbox is Inbox {
2638     using Message for bytes32;
2639 
2640     constructor(uint32 _localDomain) Inbox(_localDomain) {} // solhint-disable-line no-empty-blocks
2641 
2642     function testBranchRoot(
2643         bytes32 leaf,
2644         bytes32[32] calldata proof,
2645         uint256 index
2646     ) external pure returns (bytes32) {
2647         return MerkleLib.branchRoot(leaf, proof, index);
2648     }
2649 
2650     function testProcess(bytes calldata _message, uint256 leafIndex) external {
2651         bytes32 _messageHash = keccak256(abi.encodePacked(_message, leafIndex));
2652         _process(_message, _messageHash);
2653     }
2654 
2655     function setMessageStatus(bytes32 _leaf, MessageStatus status) external {
2656         messages[_leaf] = status;
2657     }
2658 
2659     function getRevertMsg(bytes calldata _res)
2660         internal
2661         pure
2662         returns (string memory)
2663     {
2664         // If the _res length is less than 68, then the transaction failed
2665         // silently (without a revert message)
2666         if (_res.length < 68) return "Transaction reverted silently";
2667 
2668         // Remove the selector (first 4 bytes) and decode revert string
2669         return abi.decode(_res[4:], (string));
2670     }
2671 }
2672 
2673 // File contracts/test/TestMailbox.sol
2674 
2675 // pragma solidity >=0.8.0;
2676 
2677 contract TestMailbox is Mailbox {
2678     constructor(uint32 _localDomain) Mailbox(_localDomain) {}
2679 
2680     function initialize(address _validatorManager) external initializer {
2681         __Mailbox_initialize(_validatorManager);
2682     }
2683 }
2684 
2685 // File contracts/test/TestMerkle.sol
2686 
2687 // pragma solidity >=0.8.0;
2688 
2689 contract TestMerkle is MerkleTreeManager {
2690     using MerkleLib for MerkleLib.Tree;
2691 
2692     // solhint-disable-next-line no-empty-blocks
2693     constructor() MerkleTreeManager() {}
2694 
2695     function insert(bytes32 _node) external {
2696         tree.insert(_node);
2697     }
2698 
2699     function branchRoot(
2700         bytes32 _leaf,
2701         bytes32[32] calldata _proof,
2702         uint256 _index
2703     ) external pure returns (bytes32 _node) {
2704         return MerkleLib.branchRoot(_leaf, _proof, _index);
2705     }
2706 
2707     /**
2708      * @notice Returns the number of inserted leaves in the tree
2709      */
2710     function count() public view returns (uint256) {
2711         return tree.count;
2712     }
2713 }
2714 
2715 // File contracts/test/TestMessage.sol
2716 
2717 // pragma solidity >=0.6.11;
2718 
2719 contract TestMessage {
2720     using Message for bytes;
2721 
2722     function body(bytes calldata _message)
2723         external
2724         pure
2725         returns (bytes calldata _body)
2726     {
2727         (, , , , _body) = _message.destructure();
2728     }
2729 
2730     function origin(bytes calldata _message)
2731         external
2732         pure
2733         returns (uint32 _origin)
2734     {
2735         (_origin, , , , ) = _message.destructure();
2736     }
2737 
2738     function sender(bytes calldata _message)
2739         external
2740         pure
2741         returns (bytes32 _sender)
2742     {
2743         (, _sender, , , ) = _message.destructure();
2744     }
2745 
2746     function destination(bytes calldata _message)
2747         external
2748         pure
2749         returns (uint32 _destination)
2750     {
2751         (, , _destination, , ) = _message.destructure();
2752     }
2753 
2754     function recipient(bytes calldata _message)
2755         external
2756         pure
2757         returns (bytes32 _recipient)
2758     {
2759         (, , , _recipient, ) = _message.destructure();
2760     }
2761 
2762     function recipientAddress(bytes calldata _message)
2763         external
2764         pure
2765         returns (address _recipient)
2766     {
2767         (, , , _recipient, ) = _message.destructureAddresses();
2768     }
2769 
2770     function leaf(bytes calldata _message, uint256 _leafIndex)
2771         external
2772         pure
2773         returns (bytes32)
2774     {
2775         return _message.leaf(_leafIndex);
2776     }
2777 }
2778 
2779 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
2780 
2781 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2782 
2783 // pragma solidity ^0.8.0;
2784 
2785 /**
2786  * @dev String operations.
2787  */
2788 library Strings {
2789     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2790 
2791     /**
2792      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2793      */
2794     function toString(uint256 value) internal pure returns (string memory) {
2795         // Inspired by OraclizeAPI's implementation - MIT licence
2796         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2797 
2798         if (value == 0) {
2799             return "0";
2800         }
2801         uint256 temp = value;
2802         uint256 digits;
2803         while (temp != 0) {
2804             digits++;
2805             temp /= 10;
2806         }
2807         bytes memory buffer = new bytes(digits);
2808         while (value != 0) {
2809             digits -= 1;
2810             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2811             value /= 10;
2812         }
2813         return string(buffer);
2814     }
2815 
2816     /**
2817      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2818      */
2819     function toHexString(uint256 value) internal pure returns (string memory) {
2820         if (value == 0) {
2821             return "0x00";
2822         }
2823         uint256 temp = value;
2824         uint256 length = 0;
2825         while (temp != 0) {
2826             length++;
2827             temp >>= 8;
2828         }
2829         return toHexString(value, length);
2830     }
2831 
2832     /**
2833      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2834      */
2835     function toHexString(uint256 value, uint256 length)
2836         internal
2837         pure
2838         returns (string memory)
2839     {
2840         bytes memory buffer = new bytes(2 * length + 2);
2841         buffer[0] = "0";
2842         buffer[1] = "x";
2843         for (uint256 i = 2 * length + 1; i > 1; --i) {
2844             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2845             value >>= 4;
2846         }
2847         require(value == 0, "Strings: hex length insufficient");
2848         return string(buffer);
2849     }
2850 }
2851 
2852 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
2853 
2854 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
2855 
2856 // pragma solidity ^0.8.0;
2857 
2858 /**
2859  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2860  *
2861  * These functions can be used to verify that a message was signed by the holder
2862  * of the private keys of a given address.
2863  */
2864 library ECDSA {
2865     enum RecoverError {
2866         NoError,
2867         InvalidSignature,
2868         InvalidSignatureLength,
2869         InvalidSignatureS,
2870         InvalidSignatureV
2871     }
2872 
2873     function _throwError(RecoverError error) private pure {
2874         if (error == RecoverError.NoError) {
2875             return; // no error: do nothing
2876         } else if (error == RecoverError.InvalidSignature) {
2877             revert("ECDSA: invalid signature");
2878         } else if (error == RecoverError.InvalidSignatureLength) {
2879             revert("ECDSA: invalid signature length");
2880         } else if (error == RecoverError.InvalidSignatureS) {
2881             revert("ECDSA: invalid signature 's' value");
2882         } else if (error == RecoverError.InvalidSignatureV) {
2883             revert("ECDSA: invalid signature 'v' value");
2884         }
2885     }
2886 
2887     /**
2888      * @dev Returns the address that signed a hashed message (`hash`) with
2889      * `signature` or error string. This address can then be used for verification purposes.
2890      *
2891      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2892      * this function rejects them by requiring the `s` value to be in the lower
2893      * half order, and the `v` value to be either 27 or 28.
2894      *
2895      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2896      * verification to be secure: it is possible to craft signatures that
2897      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2898      * this is by receiving a hash of the original message (which may otherwise
2899      * be too long), and then calling {toEthSignedMessageHash} on it.
2900      *
2901      * Documentation for signature generation:
2902      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2903      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2904      *
2905      * _Available since v4.3._
2906      */
2907     function tryRecover(bytes32 hash, bytes memory signature)
2908         internal
2909         pure
2910         returns (address, RecoverError)
2911     {
2912         // Check the signature length
2913         // - case 65: r,s,v signature (standard)
2914         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
2915         if (signature.length == 65) {
2916             bytes32 r;
2917             bytes32 s;
2918             uint8 v;
2919             // ecrecover takes the signature parameters, and the only way to get them
2920             // currently is to use assembly.
2921             assembly {
2922                 r := mload(add(signature, 0x20))
2923                 s := mload(add(signature, 0x40))
2924                 v := byte(0, mload(add(signature, 0x60)))
2925             }
2926             return tryRecover(hash, v, r, s);
2927         } else if (signature.length == 64) {
2928             bytes32 r;
2929             bytes32 vs;
2930             // ecrecover takes the signature parameters, and the only way to get them
2931             // currently is to use assembly.
2932             assembly {
2933                 r := mload(add(signature, 0x20))
2934                 vs := mload(add(signature, 0x40))
2935             }
2936             return tryRecover(hash, r, vs);
2937         } else {
2938             return (address(0), RecoverError.InvalidSignatureLength);
2939         }
2940     }
2941 
2942     /**
2943      * @dev Returns the address that signed a hashed message (`hash`) with
2944      * `signature`. This address can then be used for verification purposes.
2945      *
2946      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2947      * this function rejects them by requiring the `s` value to be in the lower
2948      * half order, and the `v` value to be either 27 or 28.
2949      *
2950      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2951      * verification to be secure: it is possible to craft signatures that
2952      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2953      * this is by receiving a hash of the original message (which may otherwise
2954      * be too long), and then calling {toEthSignedMessageHash} on it.
2955      */
2956     function recover(bytes32 hash, bytes memory signature)
2957         internal
2958         pure
2959         returns (address)
2960     {
2961         (address recovered, RecoverError error) = tryRecover(hash, signature);
2962         _throwError(error);
2963         return recovered;
2964     }
2965 
2966     /**
2967      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2968      *
2969      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2970      *
2971      * _Available since v4.3._
2972      */
2973     function tryRecover(
2974         bytes32 hash,
2975         bytes32 r,
2976         bytes32 vs
2977     ) internal pure returns (address, RecoverError) {
2978         bytes32 s = vs &
2979             bytes32(
2980                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2981             );
2982         uint8 v = uint8((uint256(vs) >> 255) + 27);
2983         return tryRecover(hash, v, r, s);
2984     }
2985 
2986     /**
2987      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2988      *
2989      * _Available since v4.2._
2990      */
2991     function recover(
2992         bytes32 hash,
2993         bytes32 r,
2994         bytes32 vs
2995     ) internal pure returns (address) {
2996         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2997         _throwError(error);
2998         return recovered;
2999     }
3000 
3001     /**
3002      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
3003      * `r` and `s` signature fields separately.
3004      *
3005      * _Available since v4.3._
3006      */
3007     function tryRecover(
3008         bytes32 hash,
3009         uint8 v,
3010         bytes32 r,
3011         bytes32 s
3012     ) internal pure returns (address, RecoverError) {
3013         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
3014         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
3015         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
3016         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
3017         //
3018         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
3019         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
3020         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
3021         // these malleable signatures as well.
3022         if (
3023             uint256(s) >
3024             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
3025         ) {
3026             return (address(0), RecoverError.InvalidSignatureS);
3027         }
3028         if (v != 27 && v != 28) {
3029             return (address(0), RecoverError.InvalidSignatureV);
3030         }
3031 
3032         // If the signature is valid (and not malleable), return the signer address
3033         address signer = ecrecover(hash, v, r, s);
3034         if (signer == address(0)) {
3035             return (address(0), RecoverError.InvalidSignature);
3036         }
3037 
3038         return (signer, RecoverError.NoError);
3039     }
3040 
3041     /**
3042      * @dev Overload of {ECDSA-recover} that receives the `v`,
3043      * `r` and `s` signature fields separately.
3044      */
3045     function recover(
3046         bytes32 hash,
3047         uint8 v,
3048         bytes32 r,
3049         bytes32 s
3050     ) internal pure returns (address) {
3051         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
3052         _throwError(error);
3053         return recovered;
3054     }
3055 
3056     /**
3057      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
3058      * produces hash corresponding to the one signed with the
3059      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3060      * JSON-RPC method as part of EIP-191.
3061      *
3062      * See {recover}.
3063      */
3064     function toEthSignedMessageHash(bytes32 hash)
3065         internal
3066         pure
3067         returns (bytes32)
3068     {
3069         // 32 is the length in bytes of hash,
3070         // enforced by the type signature above
3071         return
3072             keccak256(
3073                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
3074             );
3075     }
3076 
3077     /**
3078      * @dev Returns an Ethereum Signed Message, created from `s`. This
3079      * produces hash corresponding to the one signed with the
3080      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3081      * JSON-RPC method as part of EIP-191.
3082      *
3083      * See {recover}.
3084      */
3085     function toEthSignedMessageHash(bytes memory s)
3086         internal
3087         pure
3088         returns (bytes32)
3089     {
3090         return
3091             keccak256(
3092                 abi.encodePacked(
3093                     "\x19Ethereum Signed Message:\n",
3094                     Strings.toString(s.length),
3095                     s
3096                 )
3097             );
3098     }
3099 
3100     /**
3101      * @dev Returns an Ethereum Signed Typed Data, created from a
3102      * `domainSeparator` and a `structHash`. This produces hash corresponding
3103      * to the one signed with the
3104      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
3105      * JSON-RPC method as part of EIP-712.
3106      *
3107      * See {recover}.
3108      */
3109     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
3110         internal
3111         pure
3112         returns (bytes32)
3113     {
3114         return
3115             keccak256(
3116                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
3117             );
3118     }
3119 }
3120 
3121 // File contracts/validator-manager/MultisigValidatorManager.sol
3122 
3123 // pragma solidity >=0.8.0;
3124 // pragma abicoder v2;
3125 
3126 // ============ External Imports ============
3127 
3128 /**
3129  * @title MultisigValidatorManager
3130  * @notice Manages an ownable set of validators that ECDSA sign checkpoints to
3131  * reach a quorum.
3132  */
3133 abstract contract MultisigValidatorManager is Ownable {
3134     // ============ Libraries ============
3135 
3136     using EnumerableSet for EnumerableSet.AddressSet;
3137 
3138     // ============ Immutables ============
3139 
3140     // The domain of the validator set's outbox chain.
3141     uint32 public immutable domain;
3142 
3143     // The domain hash of the validator set's outbox chain.
3144     bytes32 public immutable domainHash;
3145 
3146     // ============ Mutable Storage ============
3147 
3148     // The minimum threshold of validator signatures to constitute a quorum.
3149     uint256 public threshold;
3150 
3151     // The set of validators.
3152     EnumerableSet.AddressSet private validatorSet;
3153 
3154     // ============ Events ============
3155 
3156     /**
3157      * @notice Emitted when a validator is enrolled in the validator set.
3158      * @param validator The address of the validator.
3159      * @param validatorCount The new number of enrolled validators in the validator set.
3160      */
3161     event ValidatorEnrolled(address indexed validator, uint256 validatorCount);
3162 
3163     /**
3164      * @notice Emitted when a validator is unenrolled from the validator set.
3165      * @param validator The address of the validator.
3166      * @param validatorCount The new number of enrolled validators in the validator set.
3167      */
3168     event ValidatorUnenrolled(
3169         address indexed validator,
3170         uint256 validatorCount
3171     );
3172 
3173     /**
3174      * @notice Emitted when the quorum threshold is set.
3175      * @param threshold The new quorum threshold.
3176      */
3177     event ThresholdSet(uint256 threshold);
3178 
3179     // ============ Constructor ============
3180 
3181     /**
3182      * @dev Reverts if `_validators` has any duplicates.
3183      * @param _domain The domain of the outbox the validator set is for.
3184      * @param _validators The set of validator addresses.
3185      * @param _threshold The quorum threshold. Must be greater than or equal
3186      * to the length of `_validators`.
3187      */
3188     constructor(
3189         uint32 _domain,
3190         address[] memory _validators,
3191         uint256 _threshold
3192     ) Ownable() {
3193         // Set immutables.
3194         domain = _domain;
3195         domainHash = _domainHash(_domain);
3196 
3197         // Enroll validators. Reverts if there are any duplicates.
3198         uint256 _numValidators = _validators.length;
3199         for (uint256 i = 0; i < _numValidators; i++) {
3200             _enrollValidator(_validators[i]);
3201         }
3202 
3203         _setThreshold(_threshold);
3204     }
3205 
3206     // ============ External Functions ============
3207 
3208     /**
3209      * @notice Enrolls a validator into the validator set.
3210      * @dev Reverts if `_validator` is already in the validator set.
3211      * @param _validator The validator to add to the validator set.
3212      */
3213     function enrollValidator(address _validator) external onlyOwner {
3214         _enrollValidator(_validator);
3215     }
3216 
3217     /**
3218      * @notice Unenrolls a validator from the validator set.
3219      * @dev Reverts if `_validator` is not in the validator set.
3220      * @param _validator The validator to remove from the validator set.
3221      */
3222     function unenrollValidator(address _validator) external onlyOwner {
3223         _unenrollValidator(_validator);
3224     }
3225 
3226     /**
3227      * @notice Sets the quorum threshold.
3228      * @param _threshold The new quorum threshold.
3229      */
3230     function setThreshold(uint256 _threshold) external onlyOwner {
3231         _setThreshold(_threshold);
3232     }
3233 
3234     /**
3235      * @notice Gets the addresses of the current validator set.
3236      * @dev There are no ordering guarantees due to the semantics of EnumerableSet.AddressSet.
3237      * @return The addresses of the validator set.
3238      */
3239     function validators() external view returns (address[] memory) {
3240         uint256 _numValidators = validatorSet.length();
3241         address[] memory _validators = new address[](_numValidators);
3242         for (uint256 i = 0; i < _numValidators; i++) {
3243             _validators[i] = validatorSet.at(i);
3244         }
3245         return _validators;
3246     }
3247 
3248     // ============ Public Functions ============
3249 
3250     /**
3251      * @notice Returns whether provided signatures over a checkpoint constitute
3252      * a quorum of validator signatures.
3253      * @dev Reverts if `_signatures` is not sorted in ascending order by the signer
3254      * address, which is required for duplicate detection.
3255      * @dev Does not revert if a signature's signer is not in the validator set.
3256      * @param _root The merkle root of the checkpoint.
3257      * @param _index The index of the checkpoint.
3258      * @param _signatures Signatures over the checkpoint to be checked for a validator
3259      * quorum. Must be sorted in ascending order by signer address.
3260      * @return TRUE iff `_signatures` constitute a quorum of validator signatures over
3261      * the checkpoint.
3262      */
3263     function isQuorum(
3264         bytes32 _root,
3265         uint256 _index,
3266         bytes[] calldata _signatures
3267     ) public view returns (bool) {
3268         uint256 _numSignatures = _signatures.length;
3269         // If there are fewer signatures provided than the required quorum threshold,
3270         // this is not a quorum.
3271         if (_numSignatures < threshold) {
3272             return false;
3273         }
3274         // To identify duplicates, the signers recovered from _signatures
3275         // must be sorted in ascending order. previousSigner is used to
3276         // enforce ordering.
3277         address _previousSigner = address(0);
3278         uint256 _validatorSignatureCount = 0;
3279         for (uint256 i = 0; i < _numSignatures; i++) {
3280             address _signer = _recoverCheckpointSigner(
3281                 _root,
3282                 _index,
3283                 _signatures[i]
3284             );
3285             // Revert if the signer violates the required sort order.
3286             require(_previousSigner < _signer, "!sorted signers");
3287             // If the signer is a validator, increment _validatorSignatureCount.
3288             if (isValidator(_signer)) {
3289                 _validatorSignatureCount++;
3290             }
3291             _previousSigner = _signer;
3292         }
3293         return _validatorSignatureCount >= threshold;
3294     }
3295 
3296     /**
3297      * @notice Returns if `_validator` is enrolled in the validator set.
3298      * @param _validator The address of the validator.
3299      * @return TRUE iff `_validator` is enrolled in the validator set.
3300      */
3301     function isValidator(address _validator) public view returns (bool) {
3302         return validatorSet.contains(_validator);
3303     }
3304 
3305     /**
3306      * @notice Returns the number of validators enrolled in the validator set.
3307      * @return The number of validators enrolled in the validator set.
3308      */
3309     function validatorCount() public view returns (uint256) {
3310         return validatorSet.length();
3311     }
3312 
3313     // ============ Internal Functions ============
3314 
3315     /**
3316      * @notice Recovers the signer from a signature of a checkpoint.
3317      * @param _root The checkpoint's merkle root.
3318      * @param _index The checkpoint's index.
3319      * @param _signature Signature on the the checkpoint.
3320      * @return The signer of the checkpoint signature.
3321      **/
3322     function _recoverCheckpointSigner(
3323         bytes32 _root,
3324         uint256 _index,
3325         bytes calldata _signature
3326     ) internal view returns (address) {
3327         bytes32 _digest = keccak256(
3328             abi.encodePacked(domainHash, _root, _index)
3329         );
3330         return ECDSA.recover(ECDSA.toEthSignedMessageHash(_digest), _signature);
3331     }
3332 
3333     /**
3334      * @notice Enrolls a validator into the validator set.
3335      * @dev Reverts if `_validator` is already in the validator set.
3336      * @param _validator The validator to add to the validator set.
3337      */
3338     function _enrollValidator(address _validator) internal {
3339         require(validatorSet.add(_validator), "already enrolled");
3340         emit ValidatorEnrolled(_validator, validatorCount());
3341     }
3342 
3343     /**
3344      * @notice Unenrolls a validator from the validator set.
3345      * @dev Reverts if the resulting validator set length is less than
3346      * the quorum threshold.
3347      * @dev Reverts if `_validator` is not in the validator set.
3348      * @param _validator The validator to remove from the validator set.
3349      */
3350     function _unenrollValidator(address _validator) internal {
3351         require(validatorSet.remove(_validator), "!enrolled");
3352         uint256 _numValidators = validatorCount();
3353         require(_numValidators >= threshold, "violates quorum threshold");
3354         emit ValidatorUnenrolled(_validator, _numValidators);
3355     }
3356 
3357     /**
3358      * @notice Sets the quorum threshold.
3359      * @param _threshold The new quorum threshold.
3360      */
3361     function _setThreshold(uint256 _threshold) internal {
3362         require(_threshold > 0 && _threshold <= validatorCount(), "!range");
3363         threshold = _threshold;
3364         emit ThresholdSet(_threshold);
3365     }
3366 
3367     /**
3368      * @notice Hash of `_domain` concatenated with "ABACUS".
3369      * @param _domain The domain to hash.
3370      */
3371     function _domainHash(uint32 _domain) internal pure returns (bytes32) {
3372         return keccak256(abi.encodePacked(_domain, "ABACUS"));
3373     }
3374 }
3375 
3376 // File contracts/test/TestMultisigValidatorManager.sol
3377 
3378 // pragma solidity >=0.8.0;
3379 // pragma abicoder v2;
3380 
3381 /**
3382  * This contract exists to test MultisigValidatorManager.sol, which is abstract
3383  * and cannot be deployed directly.
3384  */
3385 contract TestMultisigValidatorManager is MultisigValidatorManager {
3386     // solhint-disable-next-line no-empty-blocks
3387     constructor(
3388         uint32 _domain,
3389         address[] memory _validators,
3390         uint256 _threshold
3391     ) MultisigValidatorManager(_domain, _validators, _threshold) {}
3392 
3393     /**
3394      * @notice Hash of domain concatenated with "ABACUS".
3395      * @dev This is a public getter of _domainHash to test with.
3396      * @param _domain The domain to hash.
3397      */
3398     function getDomainHash(uint32 _domain) external pure returns (bytes32) {
3399         return _domainHash(_domain);
3400     }
3401 }
3402 
3403 // File contracts/test/TestOutbox.sol
3404 
3405 // pragma solidity >=0.8.0;
3406 
3407 // ============ Internal Imports ============
3408 
3409 contract TestOutbox is Outbox {
3410     constructor(uint32 _localDomain) Outbox(_localDomain) {} // solhint-disable-line no-empty-blocks
3411 
3412     /**
3413      * @notice Set the validator manager
3414      * @param _validatorManager Address of the validator manager
3415      */
3416     function testSetValidatorManager(address _validatorManager) external {
3417         validatorManager = _validatorManager;
3418     }
3419 
3420     function proof() external view returns (bytes32[32] memory) {
3421         bytes32[32] memory _zeroes = MerkleLib.zeroHashes();
3422         uint256 _index = tree.count - 1;
3423         bytes32[32] memory _proof;
3424 
3425         for (uint256 i = 0; i < 32; i++) {
3426             uint256 _ithBit = (_index >> i) & 0x01;
3427             if (_ithBit == 1) {
3428                 _proof[i] = tree.branch[i];
3429             } else {
3430                 _proof[i] = _zeroes[i];
3431             }
3432         }
3433         return _proof;
3434     }
3435 
3436     function branch() external view returns (bytes32[32] memory) {
3437         return tree.branch;
3438     }
3439 
3440     function branchRoot(
3441         bytes32 _item,
3442         bytes32[32] memory _branch,
3443         uint256 _index
3444     ) external pure returns (bytes32) {
3445         return MerkleLib.branchRoot(_item, _branch, _index);
3446     }
3447 }
3448 
3449 // File contracts/test/TestRecipient.sol
3450 
3451 // pragma solidity >=0.8.0;
3452 
3453 contract TestRecipient is IMessageRecipient {
3454     bool public processed = false;
3455 
3456     // solhint-disable-next-line payable-fallback
3457     fallback() external {
3458         revert("Fallback");
3459     }
3460 
3461     function handle(
3462         uint32,
3463         bytes32,
3464         bytes calldata
3465     ) external pure override {} // solhint-disable-line no-empty-blocks
3466 
3467     function receiveString(string calldata _str)
3468         public
3469         pure
3470         returns (string memory)
3471     {
3472         return _str;
3473     }
3474 
3475     function processCall(bool callProcessed) public {
3476         processed = callProcessed;
3477     }
3478 
3479     function message() public pure returns (string memory) {
3480         return "message received";
3481     }
3482 }
3483 
3484 // File contracts/test/TestSendReceiver.sol
3485 
3486 // pragma solidity >=0.8.0;
3487 
3488 contract TestSendReceiver is IMessageRecipient {
3489     using TypeCasts for address;
3490 
3491     event Handled(bytes32 blockHash);
3492 
3493     function dispatchToSelf(
3494         IOutbox _outbox,
3495         IInterchainGasPaymaster _paymaster,
3496         uint32 _destinationDomain,
3497         bytes calldata _messageBody
3498     ) external payable {
3499         uint256 _leafIndex = _outbox.dispatch(
3500             _destinationDomain,
3501             address(this).addressToBytes32(),
3502             _messageBody
3503         );
3504         uint256 _blockHashNum = uint256(previousBlockHash());
3505         uint256 _value = msg.value;
3506         if (_blockHashNum % 5 == 0) {
3507             // Pay in two separate calls, resulting in 2 distinct events
3508             uint256 _half = _value / 2;
3509             _paymaster.payGasFor{value: _half}(
3510                 address(_outbox),
3511                 _leafIndex,
3512                 _destinationDomain
3513             );
3514             _paymaster.payGasFor{value: _value - _half}(
3515                 address(_outbox),
3516                 _leafIndex,
3517                 _destinationDomain
3518             );
3519         } else {
3520             // Pay the entire msg.value in one call
3521             _paymaster.payGasFor{value: _value}(
3522                 address(_outbox),
3523                 _leafIndex,
3524                 _destinationDomain
3525             );
3526         }
3527     }
3528 
3529     function handle(
3530         uint32,
3531         bytes32,
3532         bytes calldata
3533     ) external override {
3534         bytes32 blockHash = previousBlockHash();
3535         bool isBlockHashEven = uint256(blockHash) % 2 == 0;
3536         require(isBlockHashEven, "block hash is odd");
3537         emit Handled(blockHash);
3538     }
3539 
3540     function previousBlockHash() internal view returns (bytes32) {
3541         return blockhash(block.number - 1);
3542     }
3543 }
3544 
3545 // File contracts/test/TestValidatorManager.sol
3546 
3547 // pragma solidity >=0.8.0;
3548 
3549 /**
3550  * Intended for testing Inbox.sol, which requires its validator manager
3551  * to be a contract.
3552  */
3553 contract TestValidatorManager {
3554     function process(
3555         IInbox _inbox,
3556         bytes32 _root,
3557         uint256 _index,
3558         bytes calldata _message,
3559         bytes32[32] calldata _proof,
3560         uint256 _leafIndex
3561     ) external {
3562         _inbox.process(_root, _index, _message, _proof, _leafIndex);
3563     }
3564 }
3565 
3566 // File contracts/upgrade/UpgradeBeacon.sol
3567 
3568 // pragma solidity >=0.8.0;
3569 
3570 // ============ External Imports ============
3571 
3572 /**
3573  * @title UpgradeBeacon
3574  * @notice Stores the address of an implementation contract
3575  * and allows a controller to upgrade the implementation address
3576  * @dev This implementation combines the gas savings of having no function selectors
3577  * found in 0age's implementation:
3578  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol
3579  * With the added niceties of a safety check that each implementation is a contract
3580  * and an Upgrade event emitted each time the implementation is changed
3581  * found in OpenZeppelin's implementation:
3582  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/beacon/BeaconProxy.sol
3583  */
3584 contract UpgradeBeacon {
3585     // ============ Immutables ============
3586 
3587     // The controller is capable of modifying the implementation address
3588     address private immutable controller;
3589 
3590     // ============ Private Storage Variables ============
3591 
3592     // The implementation address is held in storage slot zero.
3593     address private implementation;
3594 
3595     // ============ Events ============
3596 
3597     // Upgrade event is emitted each time the implementation address is set
3598     // (including deployment)
3599     event Upgrade(address indexed implementation);
3600 
3601     // ============ Constructor ============
3602 
3603     /**
3604      * @notice Validate the initial implementation and store it.
3605      * Store the controller immutably.
3606      * @param _initialImplementation Address of the initial implementation contract
3607      * @param _controller Address of the controller who can upgrade the implementation
3608      */
3609     constructor(address _initialImplementation, address _controller) payable {
3610         _setImplementation(_initialImplementation);
3611         controller = _controller;
3612     }
3613 
3614     // ============ External Functions ============
3615 
3616     /**
3617      * @notice For all callers except the controller, return the current implementation address.
3618      * If called by the Controller, update the implementation address
3619      * to the address passed in the calldata.
3620      * Note: this requires inline assembly because Solidity fallback functions
3621      * do not natively take arguments or return values.
3622      */
3623     fallback() external payable {
3624         if (msg.sender != controller) {
3625             // if not called by the controller,
3626             // load implementation address from storage slot zero
3627             // and return it.
3628             assembly {
3629                 mstore(0, sload(0))
3630                 return(0, 32)
3631             }
3632         } else {
3633             // if called by the controller,
3634             // load new implementation address from the first word of the calldata
3635             address _newImplementation;
3636             assembly {
3637                 _newImplementation := calldataload(0)
3638             }
3639             // set the new implementation
3640             _setImplementation(_newImplementation);
3641         }
3642     }
3643 
3644     // ============ Private Functions ============
3645 
3646     /**
3647      * @notice Perform checks on the new implementation address
3648      * then upgrade the stored implementation.
3649      * @param _newImplementation Address of the new implementation contract which will replace the old one
3650      */
3651     function _setImplementation(address _newImplementation) private {
3652         // Require that the new implementation is different from the current one
3653         require(implementation != _newImplementation, "!upgrade");
3654         // Require that the new implementation is a contract
3655         require(
3656             Address.isContract(_newImplementation),
3657             "implementation !contract"
3658         );
3659         // set the new implementation
3660         implementation = _newImplementation;
3661         emit Upgrade(_newImplementation);
3662     }
3663 }
3664 
3665 // File contracts/upgrade/UpgradeBeaconController.sol
3666 
3667 // pragma solidity >=0.8.0;
3668 
3669 // ============ Internal Imports ============
3670 
3671 // ============ External Imports ============
3672 
3673 /**
3674  * @title UpgradeBeaconController
3675  * @notice Set as the controller of UpgradeBeacon contract(s),
3676  * capable of changing their stored implementation address.
3677  * @dev This implementation is a minimal version inspired by 0age's implementation:
3678  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/upgradeability/DharmaUpgradeBeaconController.sol
3679  */
3680 contract UpgradeBeaconController is Ownable {
3681     // ============ Events ============
3682 
3683     event BeaconUpgraded(address indexed beacon, address implementation);
3684 
3685     // ============ External Functions ============
3686 
3687     /**
3688      * @notice Modify the implementation stored in the UpgradeBeacon,
3689      * which will upgrade the implementation used by all
3690      * Proxy contracts using that UpgradeBeacon
3691      * @param _beacon Address of the UpgradeBeacon which will be updated
3692      * @param _implementation Address of the Implementation contract to upgrade the Beacon to
3693      */
3694     function upgrade(address _beacon, address _implementation)
3695         external
3696         onlyOwner
3697     {
3698         // Require that the beacon is a contract
3699         require(Address.isContract(_beacon), "beacon !contract");
3700         // Call into beacon and supply address of new implementation to update it.
3701         (bool _success, ) = _beacon.call(abi.encode(_implementation));
3702         // Revert with message on failure (i.e. if the beacon is somehow incorrect).
3703         if (!_success) {
3704             assembly {
3705                 returndatacopy(0, 0, returndatasize())
3706                 revert(0, returndatasize())
3707             }
3708         }
3709         emit BeaconUpgraded(_beacon, _implementation);
3710     }
3711 }
3712 
3713 // File contracts/upgrade/UpgradeBeaconProxy.sol
3714 
3715 // pragma solidity >=0.8.0;
3716 
3717 // ============ External Imports ============
3718 
3719 /**
3720  * @title UpgradeBeaconProxy
3721  * @notice
3722  * Proxy contract which delegates all logic, including initialization,
3723  * to an implementation contract.
3724  * The implementation contract is stored within an Upgrade Beacon contract;
3725  * the implementation contract can be changed by performing an upgrade on the Upgrade Beacon contract.
3726  * The Upgrade Beacon contract for this Proxy is immutably specified at deployment.
3727  * @dev This implementation combines the gas savings of keeping the UpgradeBeacon address outside of contract storage
3728  * found in 0age's implementation:
3729  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol
3730  * With the added safety checks that the UpgradeBeacon and implementation are contracts at time of deployment
3731  * found in OpenZeppelin's implementation:
3732  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/beacon/BeaconProxy.sol
3733  */
3734 contract UpgradeBeaconProxy {
3735     // ============ Immutables ============
3736 
3737     // Upgrade Beacon address is immutable (therefore not kept in contract storage)
3738     address private immutable upgradeBeacon;
3739 
3740     // ============ Constructor ============
3741 
3742     /**
3743      * @notice Validate that the Upgrade Beacon is a contract, then set its
3744      * address immutably within this contract.
3745      * Validate that the implementation is also a contract,
3746      * Then call the initialization function defined at the implementation.
3747      * The deployment will revert and pass along the
3748      * revert reason if the initialization function reverts.
3749      * @param _upgradeBeacon Address of the Upgrade Beacon to be stored immutably in the contract
3750      * @param _initializationCalldata Calldata supplied when calling the initialization function
3751      */
3752     constructor(address _upgradeBeacon, bytes memory _initializationCalldata)
3753         payable
3754     {
3755         // Validate the Upgrade Beacon is a contract
3756         require(Address.isContract(_upgradeBeacon), "beacon !contract");
3757         // set the Upgrade Beacon
3758         upgradeBeacon = _upgradeBeacon;
3759         // Validate the implementation is a contract
3760         address _implementation = _getImplementation(_upgradeBeacon);
3761         require(
3762             Address.isContract(_implementation),
3763             "beacon implementation !contract"
3764         );
3765         // Call the initialization function on the implementation
3766         if (_initializationCalldata.length > 0) {
3767             _initialize(_implementation, _initializationCalldata);
3768         }
3769     }
3770 
3771     // ============ External Functions ============
3772 
3773     /**
3774      * @notice Forwards all calls with data to _fallback()
3775      * No public functions are declared on the contract, so all calls hit fallback
3776      */
3777     fallback() external payable {
3778         _fallback();
3779     }
3780 
3781     /**
3782      * @notice Forwards all calls with no data to _fallback()
3783      */
3784     receive() external payable {
3785         _fallback();
3786     }
3787 
3788     // ============ Private Functions ============
3789 
3790     /**
3791      * @notice Call the initialization function on the implementation
3792      * Used at deployment to initialize the proxy
3793      * based on the logic for initialization defined at the implementation
3794      * @param _implementation - Contract to which the initalization is delegated
3795      * @param _initializationCalldata - Calldata supplied when calling the initialization function
3796      */
3797     function _initialize(
3798         address _implementation,
3799         bytes memory _initializationCalldata
3800     ) private {
3801         // Delegatecall into the implementation, supplying initialization calldata.
3802         (bool _ok, ) = _implementation.delegatecall(_initializationCalldata);
3803         // Revert and include revert data if delegatecall to implementation reverts.
3804         if (!_ok) {
3805             assembly {
3806                 returndatacopy(0, 0, returndatasize())
3807                 revert(0, returndatasize())
3808             }
3809         }
3810     }
3811 
3812     /**
3813      * @notice Delegates function calls to the implementation contract returned by the Upgrade Beacon
3814      */
3815     function _fallback() private {
3816         _delegate(_getImplementation());
3817     }
3818 
3819     /**
3820      * @notice Delegate function execution to the implementation contract
3821      * @dev This is a low level function that doesn't return to its internal
3822      * call site. It will return whatever is returned by the implementation to the
3823      * external caller, reverting and returning the revert data if implementation
3824      * reverts.
3825      * @param _implementation - Address to which the function execution is delegated
3826      */
3827     function _delegate(address _implementation) private {
3828         assembly {
3829             // Copy msg.data. We take full control of memory in this inline assembly
3830             // block because it will not return to Solidity code. We overwrite the
3831             // Solidity scratch pad at memory position 0.
3832             calldatacopy(0, 0, calldatasize())
3833             // Delegatecall to the implementation, supplying calldata and gas.
3834             // Out and outsize are set to zero - instead, use the return buffer.
3835             let result := delegatecall(
3836                 gas(),
3837                 _implementation,
3838                 0,
3839                 calldatasize(),
3840                 0,
3841                 0
3842             )
3843             // Copy the returned data from the return buffer.
3844             returndatacopy(0, 0, returndatasize())
3845             switch result
3846             // Delegatecall returns 0 on error.
3847             case 0 {
3848                 revert(0, returndatasize())
3849             }
3850             default {
3851                 return(0, returndatasize())
3852             }
3853         }
3854     }
3855 
3856     /**
3857      * @notice Call the Upgrade Beacon to get the current implementation contract address
3858      * @return _implementation Address of the current implementation.
3859      */
3860     function _getImplementation()
3861         private
3862         view
3863         returns (address _implementation)
3864     {
3865         _implementation = _getImplementation(upgradeBeacon);
3866     }
3867 
3868     /**
3869      * @notice Call the Upgrade Beacon to get the current implementation contract address
3870      * @dev _upgradeBeacon is passed as a parameter so that
3871      * we can also use this function in the constructor,
3872      * where we can't access immutable variables.
3873      * @param _upgradeBeacon Address of the UpgradeBeacon storing the current implementation
3874      * @return _implementation Address of the current implementation.
3875      */
3876     function _getImplementation(address _upgradeBeacon)
3877         private
3878         view
3879         returns (address _implementation)
3880     {
3881         // Get the current implementation address from the upgrade beacon.
3882         (bool _ok, bytes memory _returnData) = _upgradeBeacon.staticcall("");
3883         // Revert and pass along revert message if call to upgrade beacon reverts.
3884         require(_ok, string(_returnData));
3885         // Set the implementation to the address returned from the upgrade beacon.
3886         _implementation = abi.decode(_returnData, (address));
3887     }
3888 }
3889 
3890 // File contracts/validator-manager/InboxValidatorManager.sol
3891 
3892 // pragma solidity >=0.8.0;
3893 // pragma abicoder v2;
3894 
3895 // ============ Internal Imports ============
3896 
3897 /**
3898  * @title InboxValidatorManager
3899  * @notice Verifies checkpoints are signed by a quorum of validators and submits
3900  * them to an Inbox.
3901  */
3902 contract InboxValidatorManager is MultisigValidatorManager {
3903     // ============ Constructor ============
3904 
3905     /**
3906      * @dev Reverts if `_validators` has any duplicates.
3907      * @param _remoteDomain The remote domain of the outbox chain.
3908      * @param _validators The set of validator addresses.
3909      * @param _threshold The quorum threshold. Must be greater than or equal
3910      * to the length of `_validators`.
3911      */
3912     // solhint-disable-next-line no-empty-blocks
3913     constructor(
3914         uint32 _remoteDomain,
3915         address[] memory _validators,
3916         uint256 _threshold
3917     ) MultisigValidatorManager(_remoteDomain, _validators, _threshold) {}
3918 
3919     // ============ External Functions ============
3920 
3921     /**
3922      * @notice Verifies a signed checkpoint and submits a message for processing.
3923      * @dev Reverts if `_signatures` is not a quorum of validator signatures.
3924      * @dev Reverts if `_signatures` is not sorted in ascending order by the signer
3925      * address, which is required for duplicate detection.
3926      * @param _inbox The inbox to submit the message to.
3927      * @param _root The merkle root of the signed checkpoint.
3928      * @param _index The index of the signed checkpoint.
3929      * @param _signatures Signatures over the checkpoint to be checked for a validator
3930      * quorum. Must be sorted in ascending order by signer address.
3931      * @param _message The message to process.
3932      * @param _proof Merkle proof of inclusion for message's leaf
3933      * @param _leafIndex Index of leaf in outbox's merkle tree
3934      */
3935     function process(
3936         IInbox _inbox,
3937         bytes32 _root,
3938         uint256 _index,
3939         bytes[] calldata _signatures,
3940         bytes calldata _message,
3941         bytes32[32] calldata _proof,
3942         uint256 _leafIndex
3943     ) external {
3944         require(isQuorum(_root, _index, _signatures), "!quorum");
3945         _inbox.process(_root, _index, _message, _proof, _leafIndex);
3946     }
3947 }
3948 
3949 // File contracts/validator-manager/OutboxValidatorManager.sol
3950 
3951 // pragma solidity >=0.8.0;
3952 // pragma abicoder v2;
3953 
3954 // ============ Internal Imports ============
3955 
3956 /**
3957  * @title OutboxValidatorManager
3958  * @notice Verifies if an premature or fraudulent checkpoint has been signed by a quorum of
3959  * validators and reports it to an Outbox.
3960  */
3961 contract OutboxValidatorManager is MultisigValidatorManager {
3962     // ============ Events ============
3963 
3964     /**
3965      * @notice Emitted when a checkpoint is proven premature.
3966      * @dev Observers of this event should filter by the outbox address.
3967      * @param outbox The outbox.
3968      * @param signedRoot Root of the premature checkpoint.
3969      * @param signedIndex Index of the premature checkpoint.
3970      * @param signatures A quorum of signatures on the premature checkpoint.
3971      * May include non-validator signatures.
3972      * @param count The number of messages in the Outbox.
3973      */
3974     event PrematureCheckpoint(
3975         address indexed outbox,
3976         bytes32 signedRoot,
3977         uint256 signedIndex,
3978         bytes[] signatures,
3979         uint256 count
3980     );
3981 
3982     /**
3983      * @notice Emitted when a checkpoint is proven fraudulent.
3984      * @dev Observers of this event should filter by the outbox address.
3985      * @param outbox The outbox.
3986      * @param signedRoot Root of the fraudulent checkpoint.
3987      * @param signedIndex Index of the fraudulent checkpoint.
3988      * @param signatures A quorum of signatures on the fraudulent checkpoint.
3989      * May include non-validator signatures.
3990      * @param fraudulentLeaf The leaf in the fraudulent tree.
3991      * @param fraudulentProof Proof of inclusion of fraudulentLeaf.
3992      * @param actualLeaf The leaf in the Outbox's tree.
3993      * @param actualProof Proof of inclusion of actualLeaf.
3994      * @param leafIndex The index of the leaves that are being proved.
3995      */
3996     event FraudulentCheckpoint(
3997         address indexed outbox,
3998         bytes32 signedRoot,
3999         uint256 signedIndex,
4000         bytes[] signatures,
4001         bytes32 fraudulentLeaf,
4002         bytes32[32] fraudulentProof,
4003         bytes32 actualLeaf,
4004         bytes32[32] actualProof,
4005         uint256 leafIndex
4006     );
4007 
4008     // ============ Constructor ============
4009 
4010     /**
4011      * @dev Reverts if `_validators` has any duplicates.
4012      * @param _localDomain The local domain.
4013      * @param _validators The set of validator addresses.
4014      * @param _threshold The quorum threshold. Must be greater than or equal
4015      * to the length of `_validators`.
4016      */
4017     // solhint-disable-next-line no-empty-blocks
4018     constructor(
4019         uint32 _localDomain,
4020         address[] memory _validators,
4021         uint256 _threshold
4022     ) MultisigValidatorManager(_localDomain, _validators, _threshold) {}
4023 
4024     // ============ External Functions ============
4025 
4026     /**
4027      * @notice Determines if a quorum of validators have signed a premature checkpoint,
4028      * failing the Outbox if so.
4029      * A checkpoint is premature if it commits to more messages than are present in the
4030      * Outbox's merkle tree.
4031      * @dev Premature checkpoints signed by individual validators are not handled to prevent
4032      * a single byzantine validator from failing the Outbox.
4033      * @param _outbox The outbox.
4034      * @param _signedRoot The root of the signed checkpoint.
4035      * @param _signedIndex The index of the signed checkpoint.
4036      * @param _signatures Signatures over the checkpoint to be checked for a validator
4037      * quorum. Must be sorted in ascending order by signer address.
4038      * @return True iff prematurity was proved.
4039      */
4040     function prematureCheckpoint(
4041         IOutbox _outbox,
4042         bytes32 _signedRoot,
4043         uint256 _signedIndex,
4044         bytes[] calldata _signatures
4045     ) external returns (bool) {
4046         require(isQuorum(_signedRoot, _signedIndex, _signatures), "!quorum");
4047         // Checkpoints are premature if the checkpoint commits to more messages
4048         // than the Outbox has in its merkle tree.
4049         uint256 count = _outbox.count();
4050         require(_signedIndex >= count, "!premature");
4051         _outbox.fail();
4052         emit PrematureCheckpoint(
4053             address(_outbox),
4054             _signedRoot,
4055             _signedIndex,
4056             _signatures,
4057             count
4058         );
4059         return true;
4060     }
4061 
4062     /**
4063      * @notice Determines if a quorum of validators have signed a fraudulent checkpoint,
4064      * failing the Outbox if so.
4065      * A checkpoint is fraudulent if the leaf it commits to at index I differs
4066      * from the leaf the Outbox committed to at index I, where I is less than or equal
4067      * to the index of the checkpoint.
4068      * This difference can be proved by comparing two merkle proofs for leaf
4069      * index J >= I. One against the fraudulent checkpoint, and one against a
4070      * checkpoint cached on the Outbox.
4071      * @dev Fraudulent checkpoints signed by individual validators are not handled to prevent
4072      * a single byzantine validator from failing the Outbox.
4073      * @param _outbox The outbox.
4074      * @param _signedRoot The root of the signed checkpoint.
4075      * @param _signedIndex The index of the signed checkpoint.
4076      * @param _signatures Signatures over the checkpoint to be checked for a validator
4077      * quorum. Must be sorted in ascending order by signer address.
4078      * @param _fraudulentLeaf The leaf in the fraudulent tree.
4079      * @param _fraudulentProof Proof of inclusion of `_fraudulentLeaf`.
4080      * @param _actualLeaf The leaf in the Outbox's tree.
4081      * @param _actualProof Proof of inclusion of `_actualLeaf`.
4082      * @param _leafIndex The index of the leaves that are being proved.
4083      * @return True iff fraud was proved.
4084      */
4085     function fraudulentCheckpoint(
4086         IOutbox _outbox,
4087         bytes32 _signedRoot,
4088         uint256 _signedIndex,
4089         bytes[] calldata _signatures,
4090         bytes32 _fraudulentLeaf,
4091         bytes32[32] calldata _fraudulentProof,
4092         bytes32 _actualLeaf,
4093         bytes32[32] calldata _actualProof,
4094         uint256 _leafIndex
4095     ) external returns (bool) {
4096         // Check the signed checkpoint commits to _fraudulentLeaf at _leafIndex.
4097         require(isQuorum(_signedRoot, _signedIndex, _signatures), "!quorum");
4098         bytes32 _fraudulentRoot = MerkleLib.branchRoot(
4099             _fraudulentLeaf,
4100             _fraudulentProof,
4101             _leafIndex
4102         );
4103         require(_fraudulentRoot == _signedRoot, "!root");
4104         require(_signedIndex >= _leafIndex, "!index");
4105 
4106         // Check the cached checkpoint commits to _actualLeaf at _leafIndex.
4107         bytes32 _cachedRoot = MerkleLib.branchRoot(
4108             _actualLeaf,
4109             _actualProof,
4110             _leafIndex
4111         );
4112         uint256 _cachedIndex = _outbox.cachedCheckpoints(_cachedRoot);
4113         require(_cachedIndex > 0 && _cachedIndex >= _leafIndex, "!cache");
4114 
4115         // Check that the two roots commit to at least one differing leaf
4116         // with index <= _leafIndex.
4117         require(
4118             impliesDifferingLeaf(
4119                 _fraudulentLeaf,
4120                 _fraudulentProof,
4121                 _actualLeaf,
4122                 _actualProof,
4123                 _leafIndex
4124             ),
4125             "!fraud"
4126         );
4127 
4128         // Fail the Outbox.
4129         _outbox.fail();
4130         emit FraudulentCheckpoint(
4131             address(_outbox),
4132             _signedRoot,
4133             _signedIndex,
4134             _signatures,
4135             _fraudulentLeaf,
4136             _fraudulentProof,
4137             _actualLeaf,
4138             _actualProof,
4139             _leafIndex
4140         );
4141         return true;
4142     }
4143 
4144     /**
4145      * @notice Returns true if the implied merkle roots commit to at least one
4146      * differing leaf with index <= `_leafIndex`.
4147      * Given a merkle proof for leaf index J, we can determine whether an
4148      * element in the proof is an internal node whose terminal children are leaves
4149      * with index <= J.
4150      * Given two merkle proofs for leaf index J, if such elements do not match,
4151      * these two proofs necessarily commit to at least one differing leaf with
4152      * index I <= J.
4153      * @param _leafA The leaf in tree A.
4154      * @param _proofA Proof of inclusion of `_leafA` in tree A.
4155      * @param _leafB The leaf in tree B.
4156      * @param _proofB Proof of inclusion of `_leafB` in tree B.
4157      * @param _leafIndex The index of `_leafA` and `_leafB`.
4158      * @return differ True if the implied trees differ, false if not.
4159      */
4160     function impliesDifferingLeaf(
4161         bytes32 _leafA,
4162         bytes32[32] calldata _proofA,
4163         bytes32 _leafB,
4164         bytes32[32] calldata _proofB,
4165         uint256 _leafIndex
4166     ) public pure returns (bool) {
4167         // The implied merkle roots commit to at least one differing leaf
4168         // with index <= _leafIndex, if either:
4169 
4170         // 1. If the provided leaves differ.
4171         if (_leafA != _leafB) {
4172             return true;
4173         }
4174 
4175         // 2. If the branches contain internal nodes whose subtrees are full
4176         // (as implied by _leafIndex) that differ from one another.
4177         for (uint8 i = 0; i < 32; i++) {
4178             uint256 _ithBit = (_leafIndex >> i) & 0x01;
4179             // If the i'th is 1, the i'th element in the proof is an internal
4180             // node whose subtree is full.
4181             // If these nodes differ, at least one leaf that they commit to
4182             // must differ as well.
4183             if (_ithBit == 1) {
4184                 if (_proofA[i] != _proofB[i]) {
4185                     return true;
4186                 }
4187             }
4188         }
4189         return false;
4190     }
4191 }
4192 
4193 // File contracts/test/bad-recipient/BadRecipient2.sol
4194 
4195 // pragma solidity >=0.8.0;
4196 
4197 contract BadRecipient2 {
4198     function handle(uint32, bytes32) external pure {} // solhint-disable-line no-empty-blocks
4199 }
