1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/AddressIsContract.sol@v1.1.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 // Partially derived from OpenZeppelin:
8 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/Address.sol
9 
10 pragma solidity >=0.7.6 <0.8.0;
11 
12 /**
13  * @dev Upgrades the address type to check if it is a contract.
14  */
15 library AddressIsContract {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize, which returns 0 for contracts in
35         // construction, since the code is only stored at the end of the
36         // constructor execution.
37 
38         uint256 size;
39         assembly {
40             size := extcodesize(account)
41         }
42         return size > 0;
43     }
44 }
45 
46 
47 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/ERC20Wrapper.sol@v1.1.2
48 
49 pragma solidity >=0.7.6 <0.8.0;
50 
51 /**
52  * @title ERC20Wrapper
53  * Wraps ERC20 functions to support non-standard implementations which do not return a bool value.
54  * Calls to the wrapped functions revert only if they throw or if they return false.
55  */
56 library ERC20Wrapper {
57     using AddressIsContract for address;
58 
59     function wrappedTransfer(
60         IWrappedERC20 token,
61         address to,
62         uint256 value
63     ) internal {
64         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transfer.selector, to, value));
65     }
66 
67     function wrappedTransferFrom(
68         IWrappedERC20 token,
69         address from,
70         address to,
71         uint256 value
72     ) internal {
73         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
74     }
75 
76     function wrappedApprove(
77         IWrappedERC20 token,
78         address spender,
79         uint256 value
80     ) internal {
81         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.approve.selector, spender, value));
82     }
83 
84     function _callWithOptionalReturnData(IWrappedERC20 token, bytes memory callData) internal {
85         address target = address(token);
86         require(target.isContract(), "ERC20Wrapper: non-contract");
87 
88         // solhint-disable-next-line avoid-low-level-calls
89         (bool success, bytes memory data) = target.call(callData);
90         if (success) {
91             if (data.length != 0) {
92                 require(abi.decode(data, (bool)), "ERC20Wrapper: operation failed");
93             }
94         } else {
95             // revert using a standard revert message
96             if (data.length == 0) {
97                 revert("ERC20Wrapper: operation failed");
98             }
99 
100             // revert using the revert message coming from the call
101             assembly {
102                 let size := mload(data)
103                 revert(add(32, data), size)
104             }
105         }
106     }
107 }
108 
109 interface IWrappedERC20 {
110     function transfer(address to, uint256 value) external returns (bool);
111 
112     function transferFrom(
113         address from,
114         address to,
115         uint256 value
116     ) external returns (bool);
117 
118     function approve(address spender, uint256 value) external returns (bool);
119 }
120 
121 
122 // File @animoca/ethereum-contracts-core-1.1.2/contracts/algo/EnumMap.sol@v1.1.2
123 
124 // Derived from OpenZeppelin:
125 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/structs/EnumerableMap.sol
126 
127 pragma solidity >=0.7.6 <0.8.0;
128 
129 /**
130  * @dev Library for managing an enumerable variant of Solidity's
131  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
132  * type.
133  *
134  * Maps have the following properties:
135  *
136  * - Entries are added, removed, and checked for existence in constant time
137  * (O(1)).
138  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
139  *
140  * ```
141  * contract Example {
142  *     // Add the library methods
143  *     using EnumMap for EnumMap.Map;
144  *
145  *     // Declare a set state variable
146  *     EnumMap.Map private myMap;
147  * }
148  * ```
149  */
150 library EnumMap {
151     // To implement this library for multiple types with as little code
152     // repetition as possible, we write it in terms of a generic Map type with
153     // bytes32 keys and values.
154     // This means that we can only create new EnumMaps for types that fit
155     // in bytes32.
156 
157     struct MapEntry {
158         bytes32 key;
159         bytes32 value;
160     }
161 
162     struct Map {
163         // Storage of map keys and values
164         MapEntry[] entries;
165         // Position of the entry defined by a key in the `entries` array, plus 1
166         // because index 0 means a key is not in the map.
167         mapping(bytes32 => uint256) indexes;
168     }
169 
170     /**
171      * @dev Adds a key-value pair to a map, or updates the value for an existing
172      * key. O(1).
173      *
174      * Returns true if the key was added to the map, that is if it was not
175      * already present.
176      */
177     function set(
178         Map storage map,
179         bytes32 key,
180         bytes32 value
181     ) internal returns (bool) {
182         // We read and store the key's index to prevent multiple reads from the same storage slot
183         uint256 keyIndex = map.indexes[key];
184 
185         if (keyIndex == 0) {
186             // Equivalent to !contains(map, key)
187             map.entries.push(MapEntry({key: key, value: value}));
188             // The entry is stored at length-1, but we add 1 to all indexes
189             // and use 0 as a sentinel value
190             map.indexes[key] = map.entries.length;
191             return true;
192         } else {
193             map.entries[keyIndex - 1].value = value;
194             return false;
195         }
196     }
197 
198     /**
199      * @dev Removes a key-value pair from a map. O(1).
200      *
201      * Returns true if the key was removed from the map, that is if it was present.
202      */
203     function remove(Map storage map, bytes32 key) internal returns (bool) {
204         // We read and store the key's index to prevent multiple reads from the same storage slot
205         uint256 keyIndex = map.indexes[key];
206 
207         if (keyIndex != 0) {
208             // Equivalent to contains(map, key)
209             // To delete a key-value pair from the entries array in O(1), we swap the entry to delete with the last one
210             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
211             // This modifies the order of the array, as noted in {at}.
212 
213             uint256 toDeleteIndex = keyIndex - 1;
214             uint256 lastIndex = map.entries.length - 1;
215 
216             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
217             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
218 
219             MapEntry storage lastEntry = map.entries[lastIndex];
220 
221             // Move the last entry to the index where the entry to delete is
222             map.entries[toDeleteIndex] = lastEntry;
223             // Update the index for the moved entry
224             map.indexes[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based
225 
226             // Delete the slot where the moved entry was stored
227             map.entries.pop();
228 
229             // Delete the index for the deleted slot
230             delete map.indexes[key];
231 
232             return true;
233         } else {
234             return false;
235         }
236     }
237 
238     /**
239      * @dev Returns true if the key is in the map. O(1).
240      */
241     function contains(Map storage map, bytes32 key) internal view returns (bool) {
242         return map.indexes[key] != 0;
243     }
244 
245     /**
246      * @dev Returns the number of key-value pairs in the map. O(1).
247      */
248     function length(Map storage map) internal view returns (uint256) {
249         return map.entries.length;
250     }
251 
252     /**
253      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
254      *
255      * Note that there are no guarantees on the ordering of entries inside the
256      * array, and it may change when more entries are added or removed.
257      *
258      * Requirements:
259      *
260      * - `index` must be strictly less than {length}.
261      */
262     function at(Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
263         require(map.entries.length > index, "EnumMap: index out of bounds");
264 
265         MapEntry storage entry = map.entries[index];
266         return (entry.key, entry.value);
267     }
268 
269     /**
270      * @dev Returns the value associated with `key`.  O(1).
271      *
272      * Requirements:
273      *
274      * - `key` must be in the map.
275      */
276     function get(Map storage map, bytes32 key) internal view returns (bytes32) {
277         uint256 keyIndex = map.indexes[key];
278         require(keyIndex != 0, "EnumMap: nonexistent key"); // Equivalent to contains(map, key)
279         return map.entries[keyIndex - 1].value; // All indexes are 1-based
280     }
281 }
282 
283 
284 // File @animoca/ethereum-contracts-core-1.1.2/contracts/algo/EnumSet.sol@v1.1.2
285 
286 // Derived from OpenZeppelin:
287 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/structs/EnumerableSet.sol
288 
289 pragma solidity >=0.7.6 <0.8.0;
290 
291 /**
292  * @dev Library for managing
293  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
294  * types.
295  *
296  * Sets have the following properties:
297  *
298  * - Elements are added, removed, and checked for existence in constant time
299  * (O(1)).
300  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
301  *
302  * ```
303  * contract Example {
304  *     // Add the library methods
305  *     using EnumSet for EnumSet.Set;
306  *
307  *     // Declare a set state variable
308  *     EnumSet.Set private mySet;
309  * }
310  * ```
311  */
312 library EnumSet {
313     // To implement this library for multiple types with as little code
314     // repetition as possible, we write it in terms of a generic Set type with
315     // bytes32 values.
316     // This means that we can only create new EnumerableSets for types that fit
317     // in bytes32.
318 
319     struct Set {
320         // Storage of set values
321         bytes32[] values;
322         // Position of the value in the `values` array, plus 1 because index 0
323         // means a value is not in the set.
324         mapping(bytes32 => uint256) indexes;
325     }
326 
327     /**
328      * @dev Add a value to a set. O(1).
329      *
330      * Returns true if the value was added to the set, that is if it was not
331      * already present.
332      */
333     function add(Set storage set, bytes32 value) internal returns (bool) {
334         if (!contains(set, value)) {
335             set.values.push(value);
336             // The value is stored at length-1, but we add 1 to all indexes
337             // and use 0 as a sentinel value
338             set.indexes[value] = set.values.length;
339             return true;
340         } else {
341             return false;
342         }
343     }
344 
345     /**
346      * @dev Removes a value from a set. O(1).
347      *
348      * Returns true if the value was removed from the set, that is if it was
349      * present.
350      */
351     function remove(Set storage set, bytes32 value) internal returns (bool) {
352         // We read and store the value's index to prevent multiple reads from the same storage slot
353         uint256 valueIndex = set.indexes[value];
354 
355         if (valueIndex != 0) {
356             // Equivalent to contains(set, value)
357             // To delete an element from the values array in O(1), we swap the element to delete with the last one in
358             // the array, and then remove the last element (sometimes called as 'swap and pop').
359             // This modifies the order of the array, as noted in {at}.
360 
361             uint256 toDeleteIndex = valueIndex - 1;
362             uint256 lastIndex = set.values.length - 1;
363 
364             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
365             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
366 
367             bytes32 lastvalue = set.values[lastIndex];
368 
369             // Move the last value to the index where the value to delete is
370             set.values[toDeleteIndex] = lastvalue;
371             // Update the index for the moved value
372             set.indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
373 
374             // Delete the slot where the moved value was stored
375             set.values.pop();
376 
377             // Delete the index for the deleted slot
378             delete set.indexes[value];
379 
380             return true;
381         } else {
382             return false;
383         }
384     }
385 
386     /**
387      * @dev Returns true if the value is in the set. O(1).
388      */
389     function contains(Set storage set, bytes32 value) internal view returns (bool) {
390         return set.indexes[value] != 0;
391     }
392 
393     /**
394      * @dev Returns the number of values on the set. O(1).
395      */
396     function length(Set storage set) internal view returns (uint256) {
397         return set.values.length;
398     }
399 
400     /**
401      * @dev Returns the value stored at position `index` in the set. O(1).
402      *
403      * Note that there are no guarantees on the ordering of values inside the
404      * array, and it may change when more values are added or removed.
405      *
406      * Requirements:
407      *
408      * - `index` must be strictly less than {length}.
409      */
410     function at(Set storage set, uint256 index) internal view returns (bytes32) {
411         require(set.values.length > index, "EnumSet: index out of bounds");
412         return set.values[index];
413     }
414 }
415 
416 
417 // File @animoca/ethereum-contracts-core-1.1.2/contracts/metatx/ManagedIdentity.sol@v1.1.2
418 
419 pragma solidity >=0.7.6 <0.8.0;
420 
421 /*
422  * Provides information about the current execution context, including the
423  * sender of the transaction and its data. While these are generally available
424  * via msg.sender and msg.data, they should not be accessed in such a direct
425  * manner.
426  */
427 abstract contract ManagedIdentity {
428     function _msgSender() internal view virtual returns (address payable) {
429         return msg.sender;
430     }
431 
432     function _msgData() internal view virtual returns (bytes memory) {
433         return msg.data;
434     }
435 }
436 
437 
438 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/IERC173.sol@v1.1.2
439 
440 pragma solidity >=0.7.6 <0.8.0;
441 
442 /**
443  * @title ERC-173 Contract Ownership Standard
444  * Note: the ERC-165 identifier for this interface is 0x7f5828d0
445  */
446 interface IERC173 {
447     /**
448      * Event emited when ownership of a contract changes.
449      * @param previousOwner the previous owner.
450      * @param newOwner the new owner.
451      */
452     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454     /**
455      * Get the address of the owner
456      * @return The address of the owner.
457      */
458     function owner() external view returns (address);
459 
460     /**
461      * Set the address of the new owner of the contract
462      * Set newOwner to address(0) to renounce any ownership.
463      * @dev Emits an {OwnershipTransferred} event.
464      * @param newOwner The address of the new owner of the contract. Using the zero address means renouncing ownership.
465      */
466     function transferOwnership(address newOwner) external;
467 }
468 
469 
470 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/Ownable.sol@v1.1.2
471 
472 pragma solidity >=0.7.6 <0.8.0;
473 
474 
475 /**
476  * @dev Contract module which provides a basic access control mechanism, where
477  * there is an account (an owner) that can be granted exclusive access to
478  * specific functions.
479  *
480  * By default, the owner account will be the one that deploys the contract. This
481  * can later be changed with {transferOwnership}.
482  *
483  * This module is used through inheritance. It will make available the modifier
484  * `onlyOwner`, which can be applied to your functions to restrict their use to
485  * the owner.
486  */
487 abstract contract Ownable is ManagedIdentity, IERC173 {
488     address internal _owner;
489 
490     /**
491      * Initializes the contract, setting the deployer as the initial owner.
492      * @dev Emits an {IERC173-OwnershipTransferred(address,address)} event.
493      */
494     constructor(address owner_) {
495         _owner = owner_;
496         emit OwnershipTransferred(address(0), owner_);
497     }
498 
499     /**
500      * Gets the address of the current contract owner.
501      */
502     function owner() public view virtual override returns (address) {
503         return _owner;
504     }
505 
506     /**
507      * See {IERC173-transferOwnership(address)}
508      * @dev Reverts if the sender is not the current contract owner.
509      * @param newOwner the address of the new owner. Use the zero address to renounce the ownership.
510      */
511     function transferOwnership(address newOwner) public virtual override {
512         _requireOwnership(_msgSender());
513         _owner = newOwner;
514         emit OwnershipTransferred(_owner, newOwner);
515     }
516 
517     /**
518      * @dev Reverts if `account` is not the contract owner.
519      * @param account the account to test.
520      */
521     function _requireOwnership(address account) internal virtual {
522         require(account == this.owner(), "Ownable: not the owner");
523     }
524 }
525 
526 
527 // File @animoca/ethereum-contracts-core-1.1.2/contracts/payment/PayoutWallet.sol@v1.1.2
528 
529 pragma solidity >=0.7.6 <0.8.0;
530 
531 
532 /**
533     @title PayoutWallet
534     @dev adds support for a payout wallet
535     Note: .
536  */
537 abstract contract PayoutWallet is ManagedIdentity, Ownable {
538     event PayoutWalletSet(address payoutWallet_);
539 
540     address payable public payoutWallet;
541 
542     constructor(address owner, address payable payoutWallet_) Ownable(owner) {
543         require(payoutWallet_ != address(0), "Payout: zero address");
544         payoutWallet = payoutWallet_;
545         emit PayoutWalletSet(payoutWallet_);
546     }
547 
548     function setPayoutWallet(address payable payoutWallet_) public {
549         _requireOwnership(_msgSender());
550         require(payoutWallet_ != address(0), "Payout: zero address");
551         payoutWallet = payoutWallet_;
552         emit PayoutWalletSet(payoutWallet);
553     }
554 }
555 
556 
557 // File @animoca/ethereum-contracts-core-1.1.2/contracts/lifecycle/Startable.sol@v1.1.2
558 
559 pragma solidity >=0.7.6 <0.8.0;
560 
561 /**
562  * Contract module which allows derived contracts to implement a mechanism for
563  * activating, or 'starting', a contract.
564  *
565  * This module is used through inheritance. It will make available the modifiers
566  * `whenNotStarted` and `whenStarted`, which can be applied to the functions of
567  * your contract. Those functions will only be 'startable' once the modifiers
568  * are put in place.
569  */
570 abstract contract Startable is ManagedIdentity {
571     event Started(address account);
572 
573     uint256 private _startedAt;
574 
575     /**
576      * Modifier to make a function callable only when the contract has not started.
577      */
578     modifier whenNotStarted() {
579         require(_startedAt == 0, "Startable: started");
580         _;
581     }
582 
583     /**
584      * Modifier to make a function callable only when the contract has started.
585      */
586     modifier whenStarted() {
587         require(_startedAt != 0, "Startable: not started");
588         _;
589     }
590 
591     /**
592      * Constructor.
593      */
594     constructor() {}
595 
596     /**
597      * Returns the timestamp when the contract entered the started state.
598      * @return The timestamp when the contract entered the started state.
599      */
600     function startedAt() public view returns (uint256) {
601         return _startedAt;
602     }
603 
604     /**
605      * Triggers the started state.
606      * @dev Emits the Started event when the function is successfully called.
607      */
608     function _start() internal virtual whenNotStarted {
609         _startedAt = block.timestamp;
610         emit Started(_msgSender());
611     }
612 }
613 
614 
615 // File @animoca/ethereum-contracts-core-1.1.2/contracts/lifecycle/Pausable.sol@v1.1.2
616 
617 pragma solidity >=0.7.6 <0.8.0;
618 
619 /**
620  * @dev Contract which allows children to implement pausability.
621  */
622 abstract contract Pausable is ManagedIdentity {
623     /**
624      * @dev Emitted when the pause is triggered by `account`.
625      */
626     event Paused(address account);
627 
628     /**
629      * @dev Emitted when the pause is lifted by `account`.
630      */
631     event Unpaused(address account);
632 
633     bool public paused;
634 
635     constructor(bool paused_) {
636         paused = paused_;
637     }
638 
639     function _requireNotPaused() internal view {
640         require(!paused, "Pausable: paused");
641     }
642 
643     function _requirePaused() internal view {
644         require(paused, "Pausable: not paused");
645     }
646 
647     /**
648      * @dev Triggers stopped state.
649      *
650      * Requirements:
651      *
652      * - The contract must not be paused.
653      */
654     function _pause() internal virtual {
655         _requireNotPaused();
656         paused = true;
657         emit Paused(_msgSender());
658     }
659 
660     /**
661      * @dev Returns to normal state.
662      *
663      * Requirements:
664      *
665      * - The contract must be paused.
666      */
667     function _unpause() internal virtual {
668         _requirePaused();
669         paused = false;
670         emit Unpaused(_msgSender());
671     }
672 }
673 
674 
675 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
676 
677 pragma solidity >=0.6.0 <0.8.0;
678 
679 /**
680  * @dev Wrappers over Solidity's arithmetic operations with added overflow
681  * checks.
682  *
683  * Arithmetic operations in Solidity wrap on overflow. This can easily result
684  * in bugs, because programmers usually assume that an overflow raises an
685  * error, which is the standard behavior in high level programming languages.
686  * `SafeMath` restores this intuition by reverting the transaction when an
687  * operation overflows.
688  *
689  * Using this library instead of the unchecked operations eliminates an entire
690  * class of bugs, so it's recommended to use it always.
691  */
692 library SafeMath {
693     /**
694      * @dev Returns the addition of two unsigned integers, with an overflow flag.
695      *
696      * _Available since v3.4._
697      */
698     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
699         uint256 c = a + b;
700         if (c < a) return (false, 0);
701         return (true, c);
702     }
703 
704     /**
705      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
706      *
707      * _Available since v3.4._
708      */
709     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
710         if (b > a) return (false, 0);
711         return (true, a - b);
712     }
713 
714     /**
715      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
716      *
717      * _Available since v3.4._
718      */
719     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
720         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
721         // benefit is lost if 'b' is also tested.
722         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
723         if (a == 0) return (true, 0);
724         uint256 c = a * b;
725         if (c / a != b) return (false, 0);
726         return (true, c);
727     }
728 
729     /**
730      * @dev Returns the division of two unsigned integers, with a division by zero flag.
731      *
732      * _Available since v3.4._
733      */
734     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
735         if (b == 0) return (false, 0);
736         return (true, a / b);
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
745         if (b == 0) return (false, 0);
746         return (true, a % b);
747     }
748 
749     /**
750      * @dev Returns the addition of two unsigned integers, reverting on
751      * overflow.
752      *
753      * Counterpart to Solidity's `+` operator.
754      *
755      * Requirements:
756      *
757      * - Addition cannot overflow.
758      */
759     function add(uint256 a, uint256 b) internal pure returns (uint256) {
760         uint256 c = a + b;
761         require(c >= a, "SafeMath: addition overflow");
762         return c;
763     }
764 
765     /**
766      * @dev Returns the subtraction of two unsigned integers, reverting on
767      * overflow (when the result is negative).
768      *
769      * Counterpart to Solidity's `-` operator.
770      *
771      * Requirements:
772      *
773      * - Subtraction cannot overflow.
774      */
775     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
776         require(b <= a, "SafeMath: subtraction overflow");
777         return a - b;
778     }
779 
780     /**
781      * @dev Returns the multiplication of two unsigned integers, reverting on
782      * overflow.
783      *
784      * Counterpart to Solidity's `*` operator.
785      *
786      * Requirements:
787      *
788      * - Multiplication cannot overflow.
789      */
790     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
791         if (a == 0) return 0;
792         uint256 c = a * b;
793         require(c / a == b, "SafeMath: multiplication overflow");
794         return c;
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers, reverting on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `/` operator. Note: this function uses a
802      * `revert` opcode (which leaves remaining gas untouched) while Solidity
803      * uses an invalid opcode to revert (consuming all remaining gas).
804      *
805      * Requirements:
806      *
807      * - The divisor cannot be zero.
808      */
809     function div(uint256 a, uint256 b) internal pure returns (uint256) {
810         require(b > 0, "SafeMath: division by zero");
811         return a / b;
812     }
813 
814     /**
815      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
816      * reverting when dividing by zero.
817      *
818      * Counterpart to Solidity's `%` operator. This function uses a `revert`
819      * opcode (which leaves remaining gas untouched) while Solidity uses an
820      * invalid opcode to revert (consuming all remaining gas).
821      *
822      * Requirements:
823      *
824      * - The divisor cannot be zero.
825      */
826     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
827         require(b > 0, "SafeMath: modulo by zero");
828         return a % b;
829     }
830 
831     /**
832      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
833      * overflow (when the result is negative).
834      *
835      * CAUTION: This function is deprecated because it requires allocating memory for the error
836      * message unnecessarily. For custom revert reasons use {trySub}.
837      *
838      * Counterpart to Solidity's `-` operator.
839      *
840      * Requirements:
841      *
842      * - Subtraction cannot overflow.
843      */
844     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
845         require(b <= a, errorMessage);
846         return a - b;
847     }
848 
849     /**
850      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
851      * division by zero. The result is rounded towards zero.
852      *
853      * CAUTION: This function is deprecated because it requires allocating memory for the error
854      * message unnecessarily. For custom revert reasons use {tryDiv}.
855      *
856      * Counterpart to Solidity's `/` operator. Note: this function uses a
857      * `revert` opcode (which leaves remaining gas untouched) while Solidity
858      * uses an invalid opcode to revert (consuming all remaining gas).
859      *
860      * Requirements:
861      *
862      * - The divisor cannot be zero.
863      */
864     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
865         require(b > 0, errorMessage);
866         return a / b;
867     }
868 
869     /**
870      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
871      * reverting with custom message when dividing by zero.
872      *
873      * CAUTION: This function is deprecated because it requires allocating memory for the error
874      * message unnecessarily. For custom revert reasons use {tryMod}.
875      *
876      * Counterpart to Solidity's `%` operator. This function uses a `revert`
877      * opcode (which leaves remaining gas untouched) while Solidity uses an
878      * invalid opcode to revert (consuming all remaining gas).
879      *
880      * Requirements:
881      *
882      * - The divisor cannot be zero.
883      */
884     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
885         require(b > 0, errorMessage);
886         return a % b;
887     }
888 }
889 
890 
891 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/interfaces/ISale.sol@v2.0.0
892 
893 pragma solidity >=0.7.6 <0.8.0;
894 
895 /**
896  * @title ISale
897  *
898  * An interface for a contract which allows merchants to display products and customers to purchase them.
899  *
900  *  Products, designated as SKUs, are represented by bytes32 identifiers so that an identifier can carry an
901  *  explicit name under the form of a fixed-length string. Each SKU can be priced via up to several payment
902  *  tokens which can be ETH and/or ERC20(s). ETH token is represented by the magic value TOKEN_ETH, which means
903  *  this value can be used as the 'token' argument of the purchase-related functions to indicate ETH payment.
904  *
905  *  The total available supply for a SKU is fixed at its creation. The magic value SUPPLY_UNLIMITED is used
906  *  to represent a SKU with an infinite, never-decreasing supply. An optional purchase notifications receiver
907  *  contract address can be set for a SKU at its creation: if the value is different from the zero address,
908  *  the function `onPurchaseNotificationReceived` will be called on this address upon every purchase of the SKU.
909  *
910  *  This interface is designed to be consistent while managing a variety of implementation scenarios. It is
911  *  also intended to be developer-friendly: all vital information is consistently deductible from the events
912  *  (backend-oriented), as well as retrievable through calls to public functions (frontend-oriented).
913  */
914 interface ISale {
915     /**
916      * Event emitted to notify about the magic values necessary for interfacing with this contract.
917      * @param names An array of names for the magic values used by the contract.
918      * @param values An array of values for the magic values used by the contract.
919      */
920     event MagicValues(bytes32[] names, bytes32[] values);
921 
922     /**
923      * Event emitted to notify about the creation of a SKU.
924      * @param sku The identifier of the created SKU.
925      * @param totalSupply The initial total supply for sale.
926      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
927      * @param notificationsReceiver If not the zero address, the address of a contract on which `onPurchaseNotificationReceived` will be called after
928      *  each purchase. If this is the zero address, the call is not enabled.
929      */
930     event SkuCreation(bytes32 sku, uint256 totalSupply, uint256 maxQuantityPerPurchase, address notificationsReceiver);
931 
932     /**
933      * Event emitted to notify about a change in the pricing of a SKU.
934      * @dev `tokens` and `prices` arrays MUST have the same length.
935      * @param sku The identifier of the updated SKU.
936      * @param tokens An array of updated payment tokens. If empty, interpret as all payment tokens being disabled.
937      * @param prices An array of updated prices for each of the payment tokens.
938      *  Zero price values are used for payment tokens being disabled.
939      */
940     event SkuPricingUpdate(bytes32 indexed sku, address[] tokens, uint256[] prices);
941 
942     /**
943      * Event emitted to notify about a purchase.
944      * @param purchaser The initiater and buyer of the purchase.
945      * @param recipient The recipient of the purchase.
946      * @param token The token used as the currency for the payment.
947      * @param sku The identifier of the purchased SKU.
948      * @param quantity The purchased quantity.
949      * @param userData Optional extra user input data.
950      * @param totalPrice The amount of `token` paid.
951      * @param extData Implementation-specific extra purchase data, such as
952      *  details about discounts applied, conversion rates, purchase receipts, etc.
953      */
954     event Purchase(
955         address indexed purchaser,
956         address recipient,
957         address indexed token,
958         bytes32 indexed sku,
959         uint256 quantity,
960         bytes userData,
961         uint256 totalPrice,
962         bytes extData
963     );
964 
965     /**
966      * Returns the magic value used to represent the ETH payment token.
967      * @dev MUST NOT be the zero address.
968      * @return the magic value used to represent the ETH payment token.
969      */
970     // solhint-disable-next-line func-name-mixedcase
971     function TOKEN_ETH() external pure returns (address);
972 
973     /**
974      * Returns the magic value used to represent an infinite, never-decreasing SKU's supply.
975      * @dev MUST NOT be zero.
976      * @return the magic value used to represent an infinite, never-decreasing SKU's supply.
977      */
978     // solhint-disable-next-line func-name-mixedcase
979     function SUPPLY_UNLIMITED() external pure returns (uint256);
980 
981     /**
982      * Performs a purchase.
983      * @dev Reverts if `recipient` is the zero address.
984      * @dev Reverts if `token` is the address zero.
985      * @dev Reverts if `quantity` is zero.
986      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
987      * @dev Reverts if `quantity` is greater than the remaining supply.
988      * @dev Reverts if `sku` does not exist.
989      * @dev Reverts if `sku` exists but does not have a price set for `token`.
990      * @dev Emits the Purchase event.
991      * @param recipient The recipient of the purchase.
992      * @param token The token to use as the payment currency.
993      * @param sku The identifier of the SKU to purchase.
994      * @param quantity The quantity to purchase.
995      * @param userData Optional extra user input data.
996      */
997     function purchaseFor(
998         address payable recipient,
999         address token,
1000         bytes32 sku,
1001         uint256 quantity,
1002         bytes calldata userData
1003     ) external payable;
1004 
1005     /**
1006      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1007      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1008      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1009      * @dev Reverts if `recipient` is the zero address.
1010      * @dev Reverts if `token` is the zero address.
1011      * @dev Reverts if `quantity` is zero.
1012      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1013      * @dev Reverts if `quantity` is greater than the remaining supply.
1014      * @dev Reverts if `sku` does not exist.
1015      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1016      * @param recipient The recipient of the purchase used to calculate the total price amount.
1017      * @param token The payment token used to calculate the total price amount.
1018      * @param sku The identifier of the SKU used to calculate the total price amount.
1019      * @param quantity The quantity used to calculate the total price amount.
1020      * @param userData Optional extra user input data.
1021      * @return totalPrice The computed total price to pay.
1022      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1023      *  If not empty, the implementer MUST document how to interepret the values.
1024      */
1025     function estimatePurchase(
1026         address payable recipient,
1027         address token,
1028         bytes32 sku,
1029         uint256 quantity,
1030         bytes calldata userData
1031     ) external view returns (uint256 totalPrice, bytes32[] memory pricingData);
1032 
1033     /**
1034      * Returns the information relative to a SKU.
1035      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1036      *  number of payment tokens is bounded, so that this function does not run out of gas.
1037      * @dev Reverts if `sku` does not exist.
1038      * @param sku The SKU identifier.
1039      * @return totalSupply The initial total supply for sale.
1040      * @return remainingSupply The remaining supply for sale.
1041      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1042      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1043      * @return tokens The list of supported payment tokens.
1044      * @return prices The list of associated prices for each of the `tokens`.
1045      */
1046     function getSkuInfo(bytes32 sku)
1047         external
1048         view
1049         returns (
1050             uint256 totalSupply,
1051             uint256 remainingSupply,
1052             uint256 maxQuantityPerPurchase,
1053             address notificationsReceiver,
1054             address[] memory tokens,
1055             uint256[] memory prices
1056         );
1057 
1058     /**
1059      * Returns the list of created SKU identifiers.
1060      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1061      *  number of SKUs is bounded, so that this function does not run out of gas.
1062      * @return skus the list of created SKU identifiers.
1063      */
1064     function getSkus() external view returns (bytes32[] memory skus);
1065 }
1066 
1067 
1068 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/interfaces/IPurchaseNotificationsReceiver.sol@v2.0.0
1069 
1070 pragma solidity >=0.7.6 <0.8.0;
1071 
1072 /**
1073  * @title IPurchaseNotificationsReceiver
1074  * Interface for any contract that wants to support purchase notifications from a Sale contract.
1075  */
1076 interface IPurchaseNotificationsReceiver {
1077     /**
1078      * Handles the receipt of a purchase notification.
1079      * @dev This function MUST return the function selector, otherwise the caller will revert the transaction.
1080      *  The selector to be returned can be obtained as `this.onPurchaseNotificationReceived.selector`
1081      * @dev This function MAY throw.
1082      * @param purchaser The purchaser of the purchase.
1083      * @param recipient The recipient of the purchase.
1084      * @param token The token to use as the payment currency.
1085      * @param sku The identifier of the SKU to purchase.
1086      * @param quantity The quantity to purchase.
1087      * @param userData Optional extra user input data.
1088      * @param totalPrice The total price paid.
1089      * @param pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1090      * @param paymentData Implementation-specific extra payment data, such as conversion rates.
1091      * @param deliveryData Implementation-specific extra delivery data, such as purchase receipts.
1092      * @return `bytes4(keccak256(
1093      *  "onPurchaseNotificationReceived(address,address,address,bytes32,uint256,bytes,uint256,bytes32[],bytes32[],bytes32[])"))`
1094      */
1095     function onPurchaseNotificationReceived(
1096         address purchaser,
1097         address recipient,
1098         address token,
1099         bytes32 sku,
1100         uint256 quantity,
1101         bytes calldata userData,
1102         uint256 totalPrice,
1103         bytes32[] calldata pricingData,
1104         bytes32[] calldata paymentData,
1105         bytes32[] calldata deliveryData
1106     ) external returns (bytes4);
1107 }
1108 
1109 
1110 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/abstract/PurchaseLifeCycles.sol@v2.0.0
1111 
1112 pragma solidity >=0.7.6 <0.8.0;
1113 
1114 /**
1115  * @title PurchaseLifeCycles
1116  * An abstract contract which define the life cycles for a purchase implementer.
1117  */
1118 abstract contract PurchaseLifeCycles {
1119     /**
1120      * Wrapper for the purchase data passed as argument to the life cycle functions and down to their step functions.
1121      */
1122     struct PurchaseData {
1123         address payable purchaser;
1124         address payable recipient;
1125         address token;
1126         bytes32 sku;
1127         uint256 quantity;
1128         bytes userData;
1129         uint256 totalPrice;
1130         bytes32[] pricingData;
1131         bytes32[] paymentData;
1132         bytes32[] deliveryData;
1133     }
1134 
1135     /*                               Internal Life Cycle Functions                               */
1136 
1137     /**
1138      * `estimatePurchase` lifecycle.
1139      * @param purchase The purchase conditions.
1140      */
1141     function _estimatePurchase(PurchaseData memory purchase) internal view virtual returns (uint256 totalPrice, bytes32[] memory pricingData) {
1142         _validation(purchase);
1143         _pricing(purchase);
1144 
1145         totalPrice = purchase.totalPrice;
1146         pricingData = purchase.pricingData;
1147     }
1148 
1149     /**
1150      * `purchaseFor` lifecycle.
1151      * @param purchase The purchase conditions.
1152      */
1153     function _purchaseFor(PurchaseData memory purchase) internal virtual {
1154         _validation(purchase);
1155         _pricing(purchase);
1156         _payment(purchase);
1157         _delivery(purchase);
1158         _notification(purchase);
1159     }
1160 
1161     /*                            Internal Life Cycle Step Functions                             */
1162 
1163     /**
1164      * Lifecycle step which validates the purchase pre-conditions.
1165      * @dev Responsibilities:
1166      *  - Ensure that the purchase pre-conditions are met and revert if not.
1167      * @param purchase The purchase conditions.
1168      */
1169     function _validation(PurchaseData memory purchase) internal view virtual;
1170 
1171     /**
1172      * Lifecycle step which computes the purchase price.
1173      * @dev Responsibilities:
1174      *  - Computes the pricing formula, including any discount logic and price conversion;
1175      *  - Set the value of `purchase.totalPrice`;
1176      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1177      * @param purchase The purchase conditions.
1178      */
1179     function _pricing(PurchaseData memory purchase) internal view virtual;
1180 
1181     /**
1182      * Lifecycle step which manages the transfer of funds from the purchaser.
1183      * @dev Responsibilities:
1184      *  - Ensure the payment reaches destination in the expected output token;
1185      *  - Handle any token swap logic;
1186      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1187      * @param purchase The purchase conditions.
1188      */
1189     function _payment(PurchaseData memory purchase) internal virtual;
1190 
1191     /**
1192      * Lifecycle step which delivers the purchased SKUs to the recipient.
1193      * @dev Responsibilities:
1194      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1195      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1196      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1197      * @param purchase The purchase conditions.
1198      */
1199     function _delivery(PurchaseData memory purchase) internal virtual;
1200 
1201     /**
1202      * Lifecycle step which notifies of the purchase.
1203      * @dev Responsibilities:
1204      *  - Manage after-purchase event(s) emission.
1205      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1206      * @param purchase The purchase conditions.
1207      */
1208     function _notification(PurchaseData memory purchase) internal virtual;
1209 }
1210 
1211 
1212 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/abstract/Sale.sol@v2.0.0
1213 
1214 pragma solidity >=0.7.6 <0.8.0;
1215 
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 /**
1226  * @title Sale
1227  * An abstract base sale contract with a minimal implementation of ISale and administration functions.
1228  *  A minimal implementation of the `_validation`, `_delivery` and `notification` life cycle step functions
1229  *  are provided, but the inheriting contract must implement `_pricing` and `_payment`.
1230  */
1231 abstract contract Sale is PurchaseLifeCycles, ISale, PayoutWallet, Startable, Pausable {
1232     using AddressIsContract for address;
1233     using SafeMath for uint256;
1234     using EnumSet for EnumSet.Set;
1235     using EnumMap for EnumMap.Map;
1236 
1237     struct SkuInfo {
1238         uint256 totalSupply;
1239         uint256 remainingSupply;
1240         uint256 maxQuantityPerPurchase;
1241         address notificationsReceiver;
1242         EnumMap.Map prices;
1243     }
1244 
1245     address public constant override TOKEN_ETH = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1246     uint256 public constant override SUPPLY_UNLIMITED = type(uint256).max;
1247 
1248     EnumSet.Set internal _skus;
1249     mapping(bytes32 => SkuInfo) internal _skuInfos;
1250 
1251     uint256 internal immutable _skusCapacity;
1252     uint256 internal immutable _tokensPerSkuCapacity;
1253 
1254     /**
1255      * Constructor.
1256      * @dev Emits the `MagicValues` event.
1257      * @dev Emits the `Paused` event.
1258      * @param payoutWallet_ the payout wallet.
1259      * @param skusCapacity the cap for the number of managed SKUs.
1260      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1261      */
1262     constructor(
1263         address payable payoutWallet_,
1264         uint256 skusCapacity,
1265         uint256 tokensPerSkuCapacity
1266     ) PayoutWallet(msg.sender, payoutWallet_) Pausable(true) {
1267         _skusCapacity = skusCapacity;
1268         _tokensPerSkuCapacity = tokensPerSkuCapacity;
1269         bytes32[] memory names = new bytes32[](2);
1270         bytes32[] memory values = new bytes32[](2);
1271         (names[0], values[0]) = ("TOKEN_ETH", bytes32(uint256(TOKEN_ETH)));
1272         (names[1], values[1]) = ("SUPPLY_UNLIMITED", bytes32(uint256(SUPPLY_UNLIMITED)));
1273         emit MagicValues(names, values);
1274     }
1275 
1276     /*                                   Public Admin Functions                                  */
1277 
1278     /**
1279      * Actvates, or 'starts', the contract.
1280      * @dev Emits the `Started` event.
1281      * @dev Emits the `Unpaused` event.
1282      * @dev Reverts if called by any other than the contract owner.
1283      * @dev Reverts if the contract has already been started.
1284      * @dev Reverts if the contract is not paused.
1285      */
1286     function start() public virtual {
1287         _requireOwnership(_msgSender());
1288         _start();
1289         _unpause();
1290     }
1291 
1292     /**
1293      * Pauses the contract.
1294      * @dev Emits the `Paused` event.
1295      * @dev Reverts if called by any other than the contract owner.
1296      * @dev Reverts if the contract has not been started yet.
1297      * @dev Reverts if the contract is already paused.
1298      */
1299     function pause() public virtual whenStarted {
1300         _requireOwnership(_msgSender());
1301         _pause();
1302     }
1303 
1304     /**
1305      * Resumes the contract.
1306      * @dev Emits the `Unpaused` event.
1307      * @dev Reverts if called by any other than the contract owner.
1308      * @dev Reverts if the contract has not been started yet.
1309      * @dev Reverts if the contract is not paused.
1310      */
1311     function unpause() public virtual whenStarted {
1312         _requireOwnership(_msgSender());
1313         _unpause();
1314     }
1315 
1316     /**
1317      * Sets the token prices for the specified product SKU.
1318      * @dev Reverts if called by any other than the contract owner.
1319      * @dev Reverts if `tokens` and `prices` have different lengths.
1320      * @dev Reverts if `sku` does not exist.
1321      * @dev Reverts if one of the `tokens` is the zero address.
1322      * @dev Reverts if the update results in too many tokens for the SKU.
1323      * @dev Emits the `SkuPricingUpdate` event.
1324      * @param sku The identifier of the SKU.
1325      * @param tokens The list of payment tokens to update.
1326      *  If empty, disable all the existing payment tokens.
1327      * @param prices The list of prices to apply for each payment token.
1328      *  Zero price values are used to disable a payment token.
1329      */
1330     function updateSkuPricing(
1331         bytes32 sku,
1332         address[] memory tokens,
1333         uint256[] memory prices
1334     ) public virtual {
1335         _requireOwnership(_msgSender());
1336         uint256 length = tokens.length;
1337         require(length == prices.length, "Sale: inconsistent arrays");
1338         SkuInfo storage skuInfo = _skuInfos[sku];
1339         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1340 
1341         EnumMap.Map storage tokenPrices = skuInfo.prices;
1342         if (length == 0) {
1343             uint256 currentLength = tokenPrices.length();
1344             for (uint256 i = 0; i < currentLength; ++i) {
1345                 // TODO add a clear function in EnumMap and EnumSet and use it
1346                 (bytes32 token, ) = tokenPrices.at(0);
1347                 tokenPrices.remove(token);
1348             }
1349         } else {
1350             _setTokenPrices(tokenPrices, tokens, prices);
1351         }
1352 
1353         emit SkuPricingUpdate(sku, tokens, prices);
1354     }
1355 
1356     /*                                   ISale Public Functions                                  */
1357 
1358     /**
1359      * Performs a purchase.
1360      * @dev Reverts if the sale has not started.
1361      * @dev Reverts if the sale is paused.
1362      * @dev Reverts if `recipient` is the zero address.
1363      * @dev Reverts if `token` is the zero address.
1364      * @dev Reverts if `quantity` is zero.
1365      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1366      * @dev Reverts if `quantity` is greater than the remaining supply.
1367      * @dev Reverts if `sku` does not exist.
1368      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1369      * @dev Emits the Purchase event.
1370      * @param recipient The recipient of the purchase.
1371      * @param token The token to use as the payment currency.
1372      * @param sku The identifier of the SKU to purchase.
1373      * @param quantity The quantity to purchase.
1374      * @param userData Optional extra user input data.
1375      */
1376     function purchaseFor(
1377         address payable recipient,
1378         address token,
1379         bytes32 sku,
1380         uint256 quantity,
1381         bytes calldata userData
1382     ) external payable virtual override whenStarted {
1383         _requireNotPaused();
1384         PurchaseData memory purchase;
1385         purchase.purchaser = _msgSender();
1386         purchase.recipient = recipient;
1387         purchase.token = token;
1388         purchase.sku = sku;
1389         purchase.quantity = quantity;
1390         purchase.userData = userData;
1391 
1392         _purchaseFor(purchase);
1393     }
1394 
1395     /**
1396      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1397      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1398      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1399      * @dev Reverts if the sale has not started.
1400      * @dev Reverts if the sale is paused.
1401      * @dev Reverts if `recipient` is the zero address.
1402      * @dev Reverts if `token` is the zero address.
1403      * @dev Reverts if `quantity` is zero.
1404      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1405      * @dev Reverts if `quantity` is greater than the remaining supply.
1406      * @dev Reverts if `sku` does not exist.
1407      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1408      * @param recipient The recipient of the purchase used to calculate the total price amount.
1409      * @param token The payment token used to calculate the total price amount.
1410      * @param sku The identifier of the SKU used to calculate the total price amount.
1411      * @param quantity The quantity used to calculate the total price amount.
1412      * @param userData Optional extra user input data.
1413      * @return totalPrice The computed total price.
1414      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1415      *  If not empty, the implementer MUST document how to interepret the values.
1416      */
1417     function estimatePurchase(
1418         address payable recipient,
1419         address token,
1420         bytes32 sku,
1421         uint256 quantity,
1422         bytes calldata userData
1423     ) external view virtual override whenStarted returns (uint256 totalPrice, bytes32[] memory pricingData) {
1424         _requireNotPaused();
1425         PurchaseData memory purchase;
1426         purchase.purchaser = _msgSender();
1427         purchase.recipient = recipient;
1428         purchase.token = token;
1429         purchase.sku = sku;
1430         purchase.quantity = quantity;
1431         purchase.userData = userData;
1432 
1433         return _estimatePurchase(purchase);
1434     }
1435 
1436     /**
1437      * Returns the information relative to a SKU.
1438      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1439      * number of payment tokens is bounded, so that this function does not run out of gas.
1440      * @dev Reverts if `sku` does not exist.
1441      * @param sku The SKU identifier.
1442      * @return totalSupply The initial total supply for sale.
1443      * @return remainingSupply The remaining supply for sale.
1444      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1445      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1446      * @return tokens The list of supported payment tokens.
1447      * @return prices The list of associated prices for each of the `tokens`.
1448      */
1449     function getSkuInfo(bytes32 sku)
1450         external
1451         view
1452         override
1453         returns (
1454             uint256 totalSupply,
1455             uint256 remainingSupply,
1456             uint256 maxQuantityPerPurchase,
1457             address notificationsReceiver,
1458             address[] memory tokens,
1459             uint256[] memory prices
1460         )
1461     {
1462         SkuInfo storage skuInfo = _skuInfos[sku];
1463         uint256 length = skuInfo.prices.length();
1464 
1465         totalSupply = skuInfo.totalSupply;
1466         require(totalSupply != 0, "Sale: non-existent sku");
1467         remainingSupply = skuInfo.remainingSupply;
1468         maxQuantityPerPurchase = skuInfo.maxQuantityPerPurchase;
1469         notificationsReceiver = skuInfo.notificationsReceiver;
1470 
1471         tokens = new address[](length);
1472         prices = new uint256[](length);
1473         for (uint256 i = 0; i < length; ++i) {
1474             (bytes32 token, bytes32 price) = skuInfo.prices.at(i);
1475             tokens[i] = address(uint256(token));
1476             prices[i] = uint256(price);
1477         }
1478     }
1479 
1480     /**
1481      * Returns the list of created SKU identifiers.
1482      * @return skus the list of created SKU identifiers.
1483      */
1484     function getSkus() external view override returns (bytes32[] memory skus) {
1485         skus = _skus.values;
1486     }
1487 
1488     /*                               Internal Utility Functions                                  */
1489 
1490     /**
1491      * Creates an SKU.
1492      * @dev Reverts if `totalSupply` is zero.
1493      * @dev Reverts if `sku` already exists.
1494      * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
1495      * @dev Reverts if the update results in too many SKUs.
1496      * @dev Emits the `SkuCreation` event.
1497      * @param sku the SKU identifier.
1498      * @param totalSupply the initial total supply.
1499      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1500      * @param notificationsReceiver The purchase notifications receiver contract address.
1501      *  If set to the zero address, the notification is not enabled.
1502      */
1503     function _createSku(
1504         bytes32 sku,
1505         uint256 totalSupply,
1506         uint256 maxQuantityPerPurchase,
1507         address notificationsReceiver
1508     ) internal virtual {
1509         require(totalSupply != 0, "Sale: zero supply");
1510         require(_skus.length() < _skusCapacity, "Sale: too many skus");
1511         require(_skus.add(sku), "Sale: sku already created");
1512         if (notificationsReceiver != address(0)) {
1513             require(notificationsReceiver.isContract(), "Sale: non-contract receiver");
1514         }
1515         SkuInfo storage skuInfo = _skuInfos[sku];
1516         skuInfo.totalSupply = totalSupply;
1517         skuInfo.remainingSupply = totalSupply;
1518         skuInfo.maxQuantityPerPurchase = maxQuantityPerPurchase;
1519         skuInfo.notificationsReceiver = notificationsReceiver;
1520         emit SkuCreation(sku, totalSupply, maxQuantityPerPurchase, notificationsReceiver);
1521     }
1522 
1523     /**
1524      * Updates SKU token prices.
1525      * @dev Reverts if one of the `tokens` is the zero address.
1526      * @dev Reverts if the update results in too many tokens for the SKU.
1527      * @param tokenPrices Storage pointer to a mapping of SKU token prices to update.
1528      * @param tokens The list of payment tokens to update.
1529      * @param prices The list of prices to apply for each payment token.
1530      *  Zero price values are used to disable a payment token.
1531      */
1532     function _setTokenPrices(
1533         EnumMap.Map storage tokenPrices,
1534         address[] memory tokens,
1535         uint256[] memory prices
1536     ) internal virtual {
1537         for (uint256 i = 0; i < tokens.length; ++i) {
1538             address token = tokens[i];
1539             require(token != address(0), "Sale: zero address token");
1540             uint256 price = prices[i];
1541             if (price == 0) {
1542                 tokenPrices.remove(bytes32(uint256(token)));
1543             } else {
1544                 tokenPrices.set(bytes32(uint256(token)), bytes32(price));
1545             }
1546         }
1547         require(tokenPrices.length() <= _tokensPerSkuCapacity, "Sale: too many tokens");
1548     }
1549 
1550     /*                            Internal Life Cycle Step Functions                             */
1551 
1552     /**
1553      * Lifecycle step which validates the purchase pre-conditions.
1554      * @dev Responsibilities:
1555      *  - Ensure that the purchase pre-conditions are met and revert if not.
1556      * @dev Reverts if `purchase.recipient` is the zero address.
1557      * @dev Reverts if `purchase.token` is the zero address.
1558      * @dev Reverts if `purchase.quantity` is zero.
1559      * @dev Reverts if `purchase.quantity` is greater than the SKU's `maxQuantityPerPurchase`.
1560      * @dev Reverts if `purchase.quantity` is greater than the available supply.
1561      * @dev Reverts if `purchase.sku` does not exist.
1562      * @dev Reverts if `purchase.sku` exists but does not have a price set for `purchase.token`.
1563      * @dev If this function is overriden, the implementer SHOULD super call this before.
1564      * @param purchase The purchase conditions.
1565      */
1566     function _validation(PurchaseData memory purchase) internal view virtual override {
1567         require(purchase.recipient != address(0), "Sale: zero address recipient");
1568         require(purchase.token != address(0), "Sale: zero address token");
1569         require(purchase.quantity != 0, "Sale: zero quantity purchase");
1570         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1571         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1572         require(skuInfo.maxQuantityPerPurchase >= purchase.quantity, "Sale: above max quantity");
1573         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1574             require(skuInfo.remainingSupply >= purchase.quantity, "Sale: insufficient supply");
1575         }
1576         bytes32 priceKey = bytes32(uint256(purchase.token));
1577         require(skuInfo.prices.contains(priceKey), "Sale: non-existent sku token");
1578     }
1579 
1580     /**
1581      * Lifecycle step which delivers the purchased SKUs to the recipient.
1582      * @dev Responsibilities:
1583      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1584      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1585      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1586      * @dev Reverts if there is not enough available supply.
1587      * @dev If this function is overriden, the implementer SHOULD super call it.
1588      * @param purchase The purchase conditions.
1589      */
1590     function _delivery(PurchaseData memory purchase) internal virtual override {
1591         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1592         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1593             _skuInfos[purchase.sku].remainingSupply = skuInfo.remainingSupply.sub(purchase.quantity);
1594         }
1595     }
1596 
1597     /**
1598      * Lifecycle step which notifies of the purchase.
1599      * @dev Responsibilities:
1600      *  - Manage after-purchase event(s) emission.
1601      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1602      * @dev Reverts if `onPurchaseNotificationReceived` throws or returns an incorrect value.
1603      * @dev Emits the `Purchase` event. The values of `purchaseData` are the concatenated values of `priceData`, `paymentData`
1604      * and `deliveryData`. If not empty, the implementer MUST document how to interpret these values.
1605      * @dev If this function is overriden, the implementer SHOULD super call it.
1606      * @param purchase The purchase conditions.
1607      */
1608     function _notification(PurchaseData memory purchase) internal virtual override {
1609         emit Purchase(
1610             purchase.purchaser,
1611             purchase.recipient,
1612             purchase.token,
1613             purchase.sku,
1614             purchase.quantity,
1615             purchase.userData,
1616             purchase.totalPrice,
1617             abi.encodePacked(purchase.pricingData, purchase.paymentData, purchase.deliveryData)
1618         );
1619 
1620         address notificationsReceiver = _skuInfos[purchase.sku].notificationsReceiver;
1621         if (notificationsReceiver != address(0)) {
1622             require(
1623                 IPurchaseNotificationsReceiver(notificationsReceiver).onPurchaseNotificationReceived(
1624                     purchase.purchaser,
1625                     purchase.recipient,
1626                     purchase.token,
1627                     purchase.sku,
1628                     purchase.quantity,
1629                     purchase.userData,
1630                     purchase.totalPrice,
1631                     purchase.pricingData,
1632                     purchase.paymentData,
1633                     purchase.deliveryData
1634                 ) == IPurchaseNotificationsReceiver(address(0)).onPurchaseNotificationReceived.selector, // TODO precompute return value
1635                 "Sale: notification refused"
1636             );
1637         }
1638     }
1639 }
1640 
1641 
1642 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/FixedPricesSale.sol@v2.0.0
1643 
1644 pragma solidity >=0.7.6 <0.8.0;
1645 
1646 
1647 /**
1648  * @title FixedPricesSale
1649  * An Sale which implements a fixed prices strategy.
1650  *  The final implementer is responsible for implementing any additional pricing and/or delivery logic.
1651  */
1652 abstract contract FixedPricesSale is Sale {
1653     using ERC20Wrapper for IWrappedERC20;
1654     using SafeMath for uint256;
1655     using EnumMap for EnumMap.Map;
1656 
1657     /**
1658      * Constructor.
1659      * @dev Emits the `MagicValues` event.
1660      * @dev Emits the `Paused` event.
1661      * @param payoutWallet_ the payout wallet.
1662      * @param skusCapacity the cap for the number of managed SKUs.
1663      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1664      */
1665     constructor(
1666         address payable payoutWallet_,
1667         uint256 skusCapacity,
1668         uint256 tokensPerSkuCapacity
1669     ) Sale(payoutWallet_, skusCapacity, tokensPerSkuCapacity) {}
1670 
1671     /*                               Internal Life Cycle Functions                               */
1672 
1673     /**
1674      * Lifecycle step which computes the purchase price.
1675      * @dev Responsibilities:
1676      *  - Computes the pricing formula, including any discount logic and price conversion;
1677      *  - Set the value of `purchase.totalPrice`;
1678      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1679      * @dev Reverts if `purchase.sku` does not exist.
1680      * @dev Reverts if `purchase.token` is not supported by the SKU.
1681      * @dev Reverts in case of price overflow.
1682      * @param purchase The purchase conditions.
1683      */
1684     function _pricing(PurchaseData memory purchase) internal view virtual override {
1685         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1686         require(skuInfo.totalSupply != 0, "Sale: unsupported SKU");
1687         EnumMap.Map storage prices = skuInfo.prices;
1688         uint256 unitPrice = _unitPrice(purchase, prices);
1689         purchase.totalPrice = unitPrice.mul(purchase.quantity);
1690     }
1691 
1692     /**
1693      * Lifecycle step which manages the transfer of funds from the purchaser.
1694      * @dev Responsibilities:
1695      *  - Ensure the payment reaches destination in the expected output token;
1696      *  - Handle any token swap logic;
1697      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1698      * @dev Reverts in case of payment failure.
1699      * @param purchase The purchase conditions.
1700      */
1701     function _payment(PurchaseData memory purchase) internal virtual override {
1702         if (purchase.token == TOKEN_ETH) {
1703             require(msg.value >= purchase.totalPrice, "Sale: insufficient ETH");
1704 
1705             payoutWallet.transfer(purchase.totalPrice);
1706 
1707             uint256 change = msg.value.sub(purchase.totalPrice);
1708 
1709             if (change != 0) {
1710                 purchase.purchaser.transfer(change);
1711             }
1712         } else {
1713             IWrappedERC20(purchase.token).wrappedTransferFrom(_msgSender(), payoutWallet, purchase.totalPrice);
1714         }
1715     }
1716 
1717     /*                               Internal Utility Functions                                  */
1718 
1719     /**
1720      * Retrieves the unit price of a SKU for the specified payment token.
1721      * @dev Reverts if the specified payment token is unsupported.
1722      * @param purchase The purchase conditions specifying the payment token with which the unit price will be retrieved.
1723      * @param prices Storage pointer to a mapping of SKU token prices to retrieve the unit price from.
1724      * @return unitPrice The unit price of a SKU for the specified payment token.
1725      */
1726     function _unitPrice(PurchaseData memory purchase, EnumMap.Map storage prices) internal view virtual returns (uint256 unitPrice) {
1727         unitPrice = uint256(prices.get(bytes32(uint256(purchase.token))));
1728         require(unitPrice != 0, "Sale: unsupported payment token");
1729     }
1730 }
1731 
1732 
1733 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/Recoverable.sol@v1.1.2
1734 
1735 pragma solidity >=0.7.6 <0.8.0;
1736 
1737 
1738 
1739 abstract contract Recoverable is ManagedIdentity, Ownable {
1740     using ERC20Wrapper for IWrappedERC20;
1741 
1742     /**
1743      * Extract ERC20 tokens which were accidentally sent to the contract to a list of accounts.
1744      * Warning: this function should be overriden for contracts which are supposed to hold ERC20 tokens
1745      * so that the extraction is limited to only amounts sent accidentally.
1746      * @dev Reverts if the sender is not the contract owner.
1747      * @dev Reverts if `accounts`, `tokens` and `amounts` do not have the same length.
1748      * @dev Reverts if one of `tokens` is does not implement the ERC20 transfer function.
1749      * @dev Reverts if one of the ERC20 transfers fail for any reason.
1750      * @param accounts the list of accounts to transfer the tokens to.
1751      * @param tokens the list of ERC20 token addresses.
1752      * @param amounts the list of token amounts to transfer.
1753      */
1754     function recoverERC20s(
1755         address[] calldata accounts,
1756         address[] calldata tokens,
1757         uint256[] calldata amounts
1758     ) external virtual {
1759         _requireOwnership(_msgSender());
1760         uint256 length = accounts.length;
1761         require(length == tokens.length && length == amounts.length, "Recov: inconsistent arrays");
1762         for (uint256 i = 0; i != length; ++i) {
1763             IWrappedERC20(tokens[i]).wrappedTransfer(accounts[i], amounts[i]);
1764         }
1765     }
1766 
1767     /**
1768      * Extract ERC721 tokens which were accidentally sent to the contract to a list of accounts.
1769      * Warning: this function should be overriden for contracts which are supposed to hold ERC721 tokens
1770      * so that the extraction is limited to only tokens sent accidentally.
1771      * @dev Reverts if the sender is not the contract owner.
1772      * @dev Reverts if `accounts`, `contracts` and `amounts` do not have the same length.
1773      * @dev Reverts if one of `contracts` is does not implement the ERC721 transferFrom function.
1774      * @dev Reverts if one of the ERC721 transfers fail for any reason.
1775      * @param accounts the list of accounts to transfer the tokens to.
1776      * @param contracts the list of ERC721 contract addresses.
1777      * @param tokenIds the list of token ids to transfer.
1778      */
1779     function recoverERC721s(
1780         address[] calldata accounts,
1781         address[] calldata contracts,
1782         uint256[] calldata tokenIds
1783     ) external virtual {
1784         _requireOwnership(_msgSender());
1785         uint256 length = accounts.length;
1786         require(length == contracts.length && length == tokenIds.length, "Recov: inconsistent arrays");
1787         for (uint256 i = 0; i != length; ++i) {
1788             IRecoverableERC721(contracts[i]).transferFrom(address(this), accounts[i], tokenIds[i]);
1789         }
1790     }
1791 }
1792 
1793 interface IRecoverableERC721 {
1794     /// See {IERC721-transferFrom(address,address,uint256)}
1795     function transferFrom(
1796         address from,
1797         address to,
1798         uint256 tokenId
1799     ) external;
1800 }
1801 
1802 
1803 // File contracts/sale/TokenLaunchpadVouchersSale.sol
1804 
1805 pragma solidity >=0.7.6 <0.8.0;
1806 
1807 
1808 /**
1809  * @title TokenLaunchpad Vouchers Sale
1810  * A FixedPricesSale contract that handles the purchase and delivery of TokenLaunchpad vouchers.
1811  */
1812 contract TokenLaunchpadVouchersSale is FixedPricesSale, Recoverable {
1813     IVouchersContract public immutable vouchersContract;
1814 
1815     mapping(bytes32 => uint256) public skuTokenIds;
1816 
1817     /**
1818      * Constructor.
1819      * @dev Emits the `MagicValues` event.
1820      * @dev Emits the `Paused` event.
1821      * @param vouchersContract_ The inventory contract from which the sale supply is attributed from.
1822      * @param payoutWallet the payout wallet.
1823      * @param skusCapacity the cap for the number of managed SKUs.
1824      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1825      */
1826     constructor(
1827         IVouchersContract vouchersContract_,
1828         address payable payoutWallet,
1829         uint256 skusCapacity,
1830         uint256 tokensPerSkuCapacity
1831     ) FixedPricesSale(payoutWallet, skusCapacity, tokensPerSkuCapacity) {
1832         vouchersContract = vouchersContract_;
1833     }
1834 
1835     /**
1836      * Creates an SKU.
1837      * @dev Reverts if `totalSupply` is zero.
1838      * @dev Reverts if `sku` already exists.
1839      * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
1840      * @dev Reverts if the update results in too many SKUs.
1841      * @dev Reverts if `tokenId` is zero.
1842      * @dev Emits the `SkuCreation` event.
1843      * @param sku The SKU identifier.
1844      * @param totalSupply The initial total supply.
1845      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1846      * param notificationsReceiver The purchase notifications receiver contract address.
1847      *  If set to the zero address, the notification is not enabled.
1848      * @param tokenId The inventory contract token ID to associate with the SKU, used for purchase
1849      *  delivery.
1850      */
1851     function createSku(
1852         bytes32 sku,
1853         uint256 totalSupply,
1854         uint256 maxQuantityPerPurchase,
1855         uint256 tokenId
1856     ) external {
1857         _requireOwnership(_msgSender());
1858         require(vouchersContract.isFungible(tokenId), "Sale: not a fungible token");
1859         skuTokenIds[sku] = tokenId;
1860         _createSku(sku, totalSupply, maxQuantityPerPurchase, address(0));
1861     }
1862 
1863     /// @inheritdoc Sale
1864     function _delivery(PurchaseData memory purchase) internal override {
1865         super._delivery(purchase);
1866         vouchersContract.safeMint(purchase.recipient, skuTokenIds[purchase.sku], purchase.quantity, "");
1867     }
1868 }
1869 
1870 interface IVouchersContract {
1871     function isFungible(uint256 id) external pure returns (bool);
1872 
1873     function safeMint(
1874         address to,
1875         uint256 id,
1876         uint256 value,
1877         bytes calldata data
1878     ) external;
1879 }