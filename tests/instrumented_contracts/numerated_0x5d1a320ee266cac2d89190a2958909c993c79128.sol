1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File contracts/sale/BenjiBananasPassSale.sol
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-11-02
7  */
8 
9 // Sources flattened with hardhat v2.6.5 https://hardhat.org
10 
11 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/AddressIsContract.sol@v1.1.2
12 
13 // SPDX-License-Identifier: MIT
14 
15 // Partially derived from OpenZeppelin:
16 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/Address.sol
17 
18 pragma solidity >=0.7.6 <0.8.0;
19 
20 /**
21  * @dev Upgrades the address type to check if it is a contract.
22  */
23 library AddressIsContract {
24     /**
25      * @dev Returns true if `account` is a contract.
26      *
27      * [IMPORTANT]
28      * ====
29      * It is unsafe to assume that an address for which this function returns
30      * false is an externally-owned account (EOA) and not a contract.
31      *
32      * Among others, `isContract` will return false for the following
33      * types of addresses:
34      *
35      *  - an externally-owned account
36      *  - a contract in construction
37      *  - an address where a contract will be created
38      *  - an address where a contract lived, but was destroyed
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize, which returns 0 for contracts in
43         // construction, since the code is only stored at the end of the
44         // constructor execution.
45 
46         uint256 size;
47         assembly {
48             size := extcodesize(account)
49         }
50         return size > 0;
51     }
52 }
53 
54 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/ERC20Wrapper.sol@v1.1.2
55 
56 pragma solidity >=0.7.6 <0.8.0;
57 
58 /**
59  * @title ERC20Wrapper
60  * Wraps ERC20 functions to support non-standard implementations which do not return a bool value.
61  * Calls to the wrapped functions revert only if they throw or if they return false.
62  */
63 library ERC20Wrapper {
64     using AddressIsContract for address;
65 
66     function wrappedTransfer(
67         IWrappedERC20 token,
68         address to,
69         uint256 value
70     ) internal {
71         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transfer.selector, to, value));
72     }
73 
74     function wrappedTransferFrom(
75         IWrappedERC20 token,
76         address from,
77         address to,
78         uint256 value
79     ) internal {
80         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
81     }
82 
83     function wrappedApprove(
84         IWrappedERC20 token,
85         address spender,
86         uint256 value
87     ) internal {
88         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.approve.selector, spender, value));
89     }
90 
91     function _callWithOptionalReturnData(IWrappedERC20 token, bytes memory callData) internal {
92         address target = address(token);
93         require(target.isContract(), "ERC20Wrapper: non-contract");
94 
95         // solhint-disable-next-line avoid-low-level-calls
96         (bool success, bytes memory data) = target.call(callData);
97         if (success) {
98             if (data.length != 0) {
99                 require(abi.decode(data, (bool)), "ERC20Wrapper: operation failed");
100             }
101         } else {
102             // revert using a standard revert message
103             if (data.length == 0) {
104                 revert("ERC20Wrapper: operation failed");
105             }
106 
107             // revert using the revert message coming from the call
108             assembly {
109                 let size := mload(data)
110                 revert(add(32, data), size)
111             }
112         }
113     }
114 }
115 
116 interface IWrappedERC20 {
117     function transfer(address to, uint256 value) external returns (bool);
118 
119     function transferFrom(
120         address from,
121         address to,
122         uint256 value
123     ) external returns (bool);
124 
125     function approve(address spender, uint256 value) external returns (bool);
126 }
127 
128 // File @animoca/ethereum-contracts-core-1.1.2/contracts/algo/EnumMap.sol@v1.1.2
129 
130 // Derived from OpenZeppelin:
131 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/structs/EnumerableMap.sol
132 
133 pragma solidity >=0.7.6 <0.8.0;
134 
135 /**
136  * @dev Library for managing an enumerable variant of Solidity's
137  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
138  * type.
139  *
140  * Maps have the following properties:
141  *
142  * - Entries are added, removed, and checked for existence in constant time
143  * (O(1)).
144  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
145  *
146  * ```
147  * contract Example {
148  *     // Add the library methods
149  *     using EnumMap for EnumMap.Map;
150  *
151  *     // Declare a set state variable
152  *     EnumMap.Map private myMap;
153  * }
154  * ```
155  */
156 library EnumMap {
157     // To implement this library for multiple types with as little code
158     // repetition as possible, we write it in terms of a generic Map type with
159     // bytes32 keys and values.
160     // This means that we can only create new EnumMaps for types that fit
161     // in bytes32.
162 
163     struct MapEntry {
164         bytes32 key;
165         bytes32 value;
166     }
167 
168     struct Map {
169         // Storage of map keys and values
170         MapEntry[] entries;
171         // Position of the entry defined by a key in the `entries` array, plus 1
172         // because index 0 means a key is not in the map.
173         mapping(bytes32 => uint256) indexes;
174     }
175 
176     /**
177      * @dev Adds a key-value pair to a map, or updates the value for an existing
178      * key. O(1).
179      *
180      * Returns true if the key was added to the map, that is if it was not
181      * already present.
182      */
183     function set(
184         Map storage map,
185         bytes32 key,
186         bytes32 value
187     ) internal returns (bool) {
188         // We read and store the key's index to prevent multiple reads from the same storage slot
189         uint256 keyIndex = map.indexes[key];
190 
191         if (keyIndex == 0) {
192             // Equivalent to !contains(map, key)
193             map.entries.push(MapEntry({key: key, value: value}));
194             // The entry is stored at length-1, but we add 1 to all indexes
195             // and use 0 as a sentinel value
196             map.indexes[key] = map.entries.length;
197             return true;
198         } else {
199             map.entries[keyIndex - 1].value = value;
200             return false;
201         }
202     }
203 
204     /**
205      * @dev Removes a key-value pair from a map. O(1).
206      *
207      * Returns true if the key was removed from the map, that is if it was present.
208      */
209     function remove(Map storage map, bytes32 key) internal returns (bool) {
210         // We read and store the key's index to prevent multiple reads from the same storage slot
211         uint256 keyIndex = map.indexes[key];
212 
213         if (keyIndex != 0) {
214             // Equivalent to contains(map, key)
215             // To delete a key-value pair from the entries array in O(1), we swap the entry to delete with the last one
216             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
217             // This modifies the order of the array, as noted in {at}.
218 
219             uint256 toDeleteIndex = keyIndex - 1;
220             uint256 lastIndex = map.entries.length - 1;
221 
222             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
223             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
224 
225             MapEntry storage lastEntry = map.entries[lastIndex];
226 
227             // Move the last entry to the index where the entry to delete is
228             map.entries[toDeleteIndex] = lastEntry;
229             // Update the index for the moved entry
230             map.indexes[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based
231 
232             // Delete the slot where the moved entry was stored
233             map.entries.pop();
234 
235             // Delete the index for the deleted slot
236             delete map.indexes[key];
237 
238             return true;
239         } else {
240             return false;
241         }
242     }
243 
244     /**
245      * @dev Returns true if the key is in the map. O(1).
246      */
247     function contains(Map storage map, bytes32 key) internal view returns (bool) {
248         return map.indexes[key] != 0;
249     }
250 
251     /**
252      * @dev Returns the number of key-value pairs in the map. O(1).
253      */
254     function length(Map storage map) internal view returns (uint256) {
255         return map.entries.length;
256     }
257 
258     /**
259      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
260      *
261      * Note that there are no guarantees on the ordering of entries inside the
262      * array, and it may change when more entries are added or removed.
263      *
264      * Requirements:
265      *
266      * - `index` must be strictly less than {length}.
267      */
268     function at(Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
269         require(map.entries.length > index, "EnumMap: index out of bounds");
270 
271         MapEntry storage entry = map.entries[index];
272         return (entry.key, entry.value);
273     }
274 
275     /**
276      * @dev Returns the value associated with `key`.  O(1).
277      *
278      * Requirements:
279      *
280      * - `key` must be in the map.
281      */
282     function get(Map storage map, bytes32 key) internal view returns (bytes32) {
283         uint256 keyIndex = map.indexes[key];
284         require(keyIndex != 0, "EnumMap: nonexistent key"); // Equivalent to contains(map, key)
285         return map.entries[keyIndex - 1].value; // All indexes are 1-based
286     }
287 }
288 
289 // File @animoca/ethereum-contracts-core-1.1.2/contracts/algo/EnumSet.sol@v1.1.2
290 
291 // Derived from OpenZeppelin:
292 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/structs/EnumerableSet.sol
293 
294 pragma solidity >=0.7.6 <0.8.0;
295 
296 /**
297  * @dev Library for managing
298  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
299  * types.
300  *
301  * Sets have the following properties:
302  *
303  * - Elements are added, removed, and checked for existence in constant time
304  * (O(1)).
305  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
306  *
307  * ```
308  * contract Example {
309  *     // Add the library methods
310  *     using EnumSet for EnumSet.Set;
311  *
312  *     // Declare a set state variable
313  *     EnumSet.Set private mySet;
314  * }
315  * ```
316  */
317 library EnumSet {
318     // To implement this library for multiple types with as little code
319     // repetition as possible, we write it in terms of a generic Set type with
320     // bytes32 values.
321     // This means that we can only create new EnumerableSets for types that fit
322     // in bytes32.
323 
324     struct Set {
325         // Storage of set values
326         bytes32[] values;
327         // Position of the value in the `values` array, plus 1 because index 0
328         // means a value is not in the set.
329         mapping(bytes32 => uint256) indexes;
330     }
331 
332     /**
333      * @dev Add a value to a set. O(1).
334      *
335      * Returns true if the value was added to the set, that is if it was not
336      * already present.
337      */
338     function add(Set storage set, bytes32 value) internal returns (bool) {
339         if (!contains(set, value)) {
340             set.values.push(value);
341             // The value is stored at length-1, but we add 1 to all indexes
342             // and use 0 as a sentinel value
343             set.indexes[value] = set.values.length;
344             return true;
345         } else {
346             return false;
347         }
348     }
349 
350     /**
351      * @dev Removes a value from a set. O(1).
352      *
353      * Returns true if the value was removed from the set, that is if it was
354      * present.
355      */
356     function remove(Set storage set, bytes32 value) internal returns (bool) {
357         // We read and store the value's index to prevent multiple reads from the same storage slot
358         uint256 valueIndex = set.indexes[value];
359 
360         if (valueIndex != 0) {
361             // Equivalent to contains(set, value)
362             // To delete an element from the values array in O(1), we swap the element to delete with the last one in
363             // the array, and then remove the last element (sometimes called as 'swap and pop').
364             // This modifies the order of the array, as noted in {at}.
365 
366             uint256 toDeleteIndex = valueIndex - 1;
367             uint256 lastIndex = set.values.length - 1;
368 
369             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
370             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
371 
372             bytes32 lastvalue = set.values[lastIndex];
373 
374             // Move the last value to the index where the value to delete is
375             set.values[toDeleteIndex] = lastvalue;
376             // Update the index for the moved value
377             set.indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
378 
379             // Delete the slot where the moved value was stored
380             set.values.pop();
381 
382             // Delete the index for the deleted slot
383             delete set.indexes[value];
384 
385             return true;
386         } else {
387             return false;
388         }
389     }
390 
391     /**
392      * @dev Returns true if the value is in the set. O(1).
393      */
394     function contains(Set storage set, bytes32 value) internal view returns (bool) {
395         return set.indexes[value] != 0;
396     }
397 
398     /**
399      * @dev Returns the number of values on the set. O(1).
400      */
401     function length(Set storage set) internal view returns (uint256) {
402         return set.values.length;
403     }
404 
405     /**
406      * @dev Returns the value stored at position `index` in the set. O(1).
407      *
408      * Note that there are no guarantees on the ordering of values inside the
409      * array, and it may change when more values are added or removed.
410      *
411      * Requirements:
412      *
413      * - `index` must be strictly less than {length}.
414      */
415     function at(Set storage set, uint256 index) internal view returns (bytes32) {
416         require(set.values.length > index, "EnumSet: index out of bounds");
417         return set.values[index];
418     }
419 }
420 
421 // File @animoca/ethereum-contracts-core-1.1.2/contracts/metatx/ManagedIdentity.sol@v1.1.2
422 
423 pragma solidity >=0.7.6 <0.8.0;
424 
425 /*
426  * Provides information about the current execution context, including the
427  * sender of the transaction and its data. While these are generally available
428  * via msg.sender and msg.data, they should not be accessed in such a direct
429  * manner.
430  */
431 abstract contract ManagedIdentity {
432     function _msgSender() internal view virtual returns (address payable) {
433         return msg.sender;
434     }
435 
436     function _msgData() internal view virtual returns (bytes memory) {
437         return msg.data;
438     }
439 }
440 
441 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/IERC173.sol@v1.1.2
442 
443 pragma solidity >=0.7.6 <0.8.0;
444 
445 /**
446  * @title ERC-173 Contract Ownership Standard
447  * Note: the ERC-165 identifier for this interface is 0x7f5828d0
448  */
449 interface IERC173 {
450     /**
451      * Event emited when ownership of a contract changes.
452      * @param previousOwner the previous owner.
453      * @param newOwner the new owner.
454      */
455     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
456 
457     /**
458      * Get the address of the owner
459      * @return The address of the owner.
460      */
461     function owner() external view returns (address);
462 
463     /**
464      * Set the address of the new owner of the contract
465      * Set newOwner to address(0) to renounce any ownership.
466      * @dev Emits an {OwnershipTransferred} event.
467      * @param newOwner The address of the new owner of the contract. Using the zero address means renouncing ownership.
468      */
469     function transferOwnership(address newOwner) external;
470 }
471 
472 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/Ownable.sol@v1.1.2
473 
474 pragma solidity >=0.7.6 <0.8.0;
475 
476 /**
477  * @dev Contract module which provides a basic access control mechanism, where
478  * there is an account (an owner) that can be granted exclusive access to
479  * specific functions.
480  *
481  * By default, the owner account will be the one that deploys the contract. This
482  * can later be changed with {transferOwnership}.
483  *
484  * This module is used through inheritance. It will make available the modifier
485  * `onlyOwner`, which can be applied to your functions to restrict their use to
486  * the owner.
487  */
488 abstract contract Ownable is ManagedIdentity, IERC173 {
489     address internal _owner;
490 
491     /**
492      * Initializes the contract, setting the deployer as the initial owner.
493      * @dev Emits an {IERC173-OwnershipTransferred(address,address)} event.
494      */
495     constructor(address owner_) {
496         _owner = owner_;
497         emit OwnershipTransferred(address(0), owner_);
498     }
499 
500     /**
501      * Gets the address of the current contract owner.
502      */
503     function owner() public view virtual override returns (address) {
504         return _owner;
505     }
506 
507     /**
508      * See {IERC173-transferOwnership(address)}
509      * @dev Reverts if the sender is not the current contract owner.
510      * @param newOwner the address of the new owner. Use the zero address to renounce the ownership.
511      */
512     function transferOwnership(address newOwner) public virtual override {
513         _requireOwnership(_msgSender());
514         _owner = newOwner;
515         emit OwnershipTransferred(_owner, newOwner);
516     }
517 
518     /**
519      * @dev Reverts if `account` is not the contract owner.
520      * @param account the account to test.
521      */
522     function _requireOwnership(address account) internal virtual {
523         require(account == this.owner(), "Ownable: not the owner");
524     }
525 }
526 
527 // File @animoca/ethereum-contracts-core-1.1.2/contracts/payment/PayoutWallet.sol@v1.1.2
528 
529 pragma solidity >=0.7.6 <0.8.0;
530 
531 /**
532     @title PayoutWallet
533     @dev adds support for a payout wallet
534     Note: .
535  */
536 abstract contract PayoutWallet is ManagedIdentity, Ownable {
537     event PayoutWalletSet(address payoutWallet_);
538 
539     address payable public payoutWallet;
540 
541     constructor(address owner, address payable payoutWallet_) Ownable(owner) {
542         require(payoutWallet_ != address(0), "Payout: zero address");
543         payoutWallet = payoutWallet_;
544         emit PayoutWalletSet(payoutWallet_);
545     }
546 
547     function setPayoutWallet(address payable payoutWallet_) public {
548         _requireOwnership(_msgSender());
549         require(payoutWallet_ != address(0), "Payout: zero address");
550         payoutWallet = payoutWallet_;
551         emit PayoutWalletSet(payoutWallet);
552     }
553 }
554 
555 // File @animoca/ethereum-contracts-core-1.1.2/contracts/lifecycle/Startable.sol@v1.1.2
556 
557 pragma solidity >=0.7.6 <0.8.0;
558 
559 /**
560  * Contract module which allows derived contracts to implement a mechanism for
561  * activating, or 'starting', a contract.
562  *
563  * This module is used through inheritance. It will make available the modifiers
564  * `whenNotStarted` and `whenStarted`, which can be applied to the functions of
565  * your contract. Those functions will only be 'startable' once the modifiers
566  * are put in place.
567  */
568 abstract contract Startable is ManagedIdentity {
569     event Started(address account);
570 
571     uint256 private _startedAt;
572 
573     /**
574      * Modifier to make a function callable only when the contract has not started.
575      */
576     modifier whenNotStarted() {
577         require(_startedAt == 0, "Startable: started");
578         _;
579     }
580 
581     /**
582      * Modifier to make a function callable only when the contract has started.
583      */
584     modifier whenStarted() {
585         require(_startedAt != 0, "Startable: not started");
586         _;
587     }
588 
589     /**
590      * Constructor.
591      */
592     constructor() {}
593 
594     /**
595      * Returns the timestamp when the contract entered the started state.
596      * @return The timestamp when the contract entered the started state.
597      */
598     function startedAt() public view returns (uint256) {
599         return _startedAt;
600     }
601 
602     /**
603      * Triggers the started state.
604      * @dev Emits the Started event when the function is successfully called.
605      */
606     function _start() internal virtual whenNotStarted {
607         _startedAt = block.timestamp;
608         emit Started(_msgSender());
609     }
610 }
611 
612 // File @animoca/ethereum-contracts-core-1.1.2/contracts/lifecycle/Pausable.sol@v1.1.2
613 
614 pragma solidity >=0.7.6 <0.8.0;
615 
616 /**
617  * @dev Contract which allows children to implement pausability.
618  */
619 abstract contract Pausable is ManagedIdentity {
620     /**
621      * @dev Emitted when the pause is triggered by `account`.
622      */
623     event Paused(address account);
624 
625     /**
626      * @dev Emitted when the pause is lifted by `account`.
627      */
628     event Unpaused(address account);
629 
630     bool public paused;
631 
632     constructor(bool paused_) {
633         paused = paused_;
634     }
635 
636     function _requireNotPaused() internal view {
637         require(!paused, "Pausable: paused");
638     }
639 
640     function _requirePaused() internal view {
641         require(paused, "Pausable: not paused");
642     }
643 
644     /**
645      * @dev Triggers stopped state.
646      *
647      * Requirements:
648      *
649      * - The contract must not be paused.
650      */
651     function _pause() internal virtual {
652         _requireNotPaused();
653         paused = true;
654         emit Paused(_msgSender());
655     }
656 
657     /**
658      * @dev Returns to normal state.
659      *
660      * Requirements:
661      *
662      * - The contract must be paused.
663      */
664     function _unpause() internal virtual {
665         _requirePaused();
666         paused = false;
667         emit Unpaused(_msgSender());
668     }
669 }
670 
671 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
672 
673 pragma solidity >=0.6.0 <0.8.0;
674 
675 /**
676  * @dev Wrappers over Solidity's arithmetic operations with added overflow
677  * checks.
678  *
679  * Arithmetic operations in Solidity wrap on overflow. This can easily result
680  * in bugs, because programmers usually assume that an overflow raises an
681  * error, which is the standard behavior in high level programming languages.
682  * `SafeMath` restores this intuition by reverting the transaction when an
683  * operation overflows.
684  *
685  * Using this library instead of the unchecked operations eliminates an entire
686  * class of bugs, so it's recommended to use it always.
687  */
688 library SafeMath {
689     /**
690      * @dev Returns the addition of two unsigned integers, with an overflow flag.
691      *
692      * _Available since v3.4._
693      */
694     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
695         uint256 c = a + b;
696         if (c < a) return (false, 0);
697         return (true, c);
698     }
699 
700     /**
701      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
702      *
703      * _Available since v3.4._
704      */
705     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
706         if (b > a) return (false, 0);
707         return (true, a - b);
708     }
709 
710     /**
711      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
712      *
713      * _Available since v3.4._
714      */
715     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
716         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
717         // benefit is lost if 'b' is also tested.
718         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
719         if (a == 0) return (true, 0);
720         uint256 c = a * b;
721         if (c / a != b) return (false, 0);
722         return (true, c);
723     }
724 
725     /**
726      * @dev Returns the division of two unsigned integers, with a division by zero flag.
727      *
728      * _Available since v3.4._
729      */
730     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
731         if (b == 0) return (false, 0);
732         return (true, a / b);
733     }
734 
735     /**
736      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
737      *
738      * _Available since v3.4._
739      */
740     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
741         if (b == 0) return (false, 0);
742         return (true, a % b);
743     }
744 
745     /**
746      * @dev Returns the addition of two unsigned integers, reverting on
747      * overflow.
748      *
749      * Counterpart to Solidity's `+` operator.
750      *
751      * Requirements:
752      *
753      * - Addition cannot overflow.
754      */
755     function add(uint256 a, uint256 b) internal pure returns (uint256) {
756         uint256 c = a + b;
757         require(c >= a, "SafeMath: addition overflow");
758         return c;
759     }
760 
761     /**
762      * @dev Returns the subtraction of two unsigned integers, reverting on
763      * overflow (when the result is negative).
764      *
765      * Counterpart to Solidity's `-` operator.
766      *
767      * Requirements:
768      *
769      * - Subtraction cannot overflow.
770      */
771     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
772         require(b <= a, "SafeMath: subtraction overflow");
773         return a - b;
774     }
775 
776     /**
777      * @dev Returns the multiplication of two unsigned integers, reverting on
778      * overflow.
779      *
780      * Counterpart to Solidity's `*` operator.
781      *
782      * Requirements:
783      *
784      * - Multiplication cannot overflow.
785      */
786     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
787         if (a == 0) return 0;
788         uint256 c = a * b;
789         require(c / a == b, "SafeMath: multiplication overflow");
790         return c;
791     }
792 
793     /**
794      * @dev Returns the integer division of two unsigned integers, reverting on
795      * division by zero. The result is rounded towards zero.
796      *
797      * Counterpart to Solidity's `/` operator. Note: this function uses a
798      * `revert` opcode (which leaves remaining gas untouched) while Solidity
799      * uses an invalid opcode to revert (consuming all remaining gas).
800      *
801      * Requirements:
802      *
803      * - The divisor cannot be zero.
804      */
805     function div(uint256 a, uint256 b) internal pure returns (uint256) {
806         require(b > 0, "SafeMath: division by zero");
807         return a / b;
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting when dividing by zero.
813      *
814      * Counterpart to Solidity's `%` operator. This function uses a `revert`
815      * opcode (which leaves remaining gas untouched) while Solidity uses an
816      * invalid opcode to revert (consuming all remaining gas).
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
823         require(b > 0, "SafeMath: modulo by zero");
824         return a % b;
825     }
826 
827     /**
828      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
829      * overflow (when the result is negative).
830      *
831      * CAUTION: This function is deprecated because it requires allocating memory for the error
832      * message unnecessarily. For custom revert reasons use {trySub}.
833      *
834      * Counterpart to Solidity's `-` operator.
835      *
836      * Requirements:
837      *
838      * - Subtraction cannot overflow.
839      */
840     function sub(
841         uint256 a,
842         uint256 b,
843         string memory errorMessage
844     ) internal pure returns (uint256) {
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
864     function div(
865         uint256 a,
866         uint256 b,
867         string memory errorMessage
868     ) internal pure returns (uint256) {
869         require(b > 0, errorMessage);
870         return a / b;
871     }
872 
873     /**
874      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
875      * reverting with custom message when dividing by zero.
876      *
877      * CAUTION: This function is deprecated because it requires allocating memory for the error
878      * message unnecessarily. For custom revert reasons use {tryMod}.
879      *
880      * Counterpart to Solidity's `%` operator. This function uses a `revert`
881      * opcode (which leaves remaining gas untouched) while Solidity uses an
882      * invalid opcode to revert (consuming all remaining gas).
883      *
884      * Requirements:
885      *
886      * - The divisor cannot be zero.
887      */
888     function mod(
889         uint256 a,
890         uint256 b,
891         string memory errorMessage
892     ) internal pure returns (uint256) {
893         require(b > 0, errorMessage);
894         return a % b;
895     }
896 }
897 
898 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/interfaces/ISale.sol@v2.0.0
899 
900 pragma solidity >=0.7.6 <0.8.0;
901 
902 /**
903  * @title ISale
904  *
905  * An interface for a contract which allows merchants to display products and customers to purchase them.
906  *
907  *  Products, designated as SKUs, are represented by bytes32 identifiers so that an identifier can carry an
908  *  explicit name under the form of a fixed-length string. Each SKU can be priced via up to several payment
909  *  tokens which can be ETH and/or ERC20(s). ETH token is represented by the magic value TOKEN_ETH, which means
910  *  this value can be used as the 'token' argument of the purchase-related functions to indicate ETH payment.
911  *
912  *  The total available supply for a SKU is fixed at its creation. The magic value SUPPLY_UNLIMITED is used
913  *  to represent a SKU with an infinite, never-decreasing supply. An optional purchase notifications receiver
914  *  contract address can be set for a SKU at its creation: if the value is different from the zero address,
915  *  the function `onPurchaseNotificationReceived` will be called on this address upon every purchase of the SKU.
916  *
917  *  This interface is designed to be consistent while managing a variety of implementation scenarios. It is
918  *  also intended to be developer-friendly: all vital information is consistently deductible from the events
919  *  (backend-oriented), as well as retrievable through calls to public functions (frontend-oriented).
920  */
921 interface ISale {
922     /**
923      * Event emitted to notify about the magic values necessary for interfacing with this contract.
924      * @param names An array of names for the magic values used by the contract.
925      * @param values An array of values for the magic values used by the contract.
926      */
927     event MagicValues(bytes32[] names, bytes32[] values);
928 
929     /**
930      * Event emitted to notify about the creation of a SKU.
931      * @param sku The identifier of the created SKU.
932      * @param totalSupply The initial total supply for sale.
933      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
934      * @param notificationsReceiver If not the zero address, the address of a contract on which `onPurchaseNotificationReceived` will be called after
935      *  each purchase. If this is the zero address, the call is not enabled.
936      */
937     event SkuCreation(bytes32 sku, uint256 totalSupply, uint256 maxQuantityPerPurchase, address notificationsReceiver);
938 
939     /**
940      * Event emitted to notify about a change in the pricing of a SKU.
941      * @dev `tokens` and `prices` arrays MUST have the same length.
942      * @param sku The identifier of the updated SKU.
943      * @param tokens An array of updated payment tokens. If empty, interpret as all payment tokens being disabled.
944      * @param prices An array of updated prices for each of the payment tokens.
945      *  Zero price values are used for payment tokens being disabled.
946      */
947     event SkuPricingUpdate(bytes32 indexed sku, address[] tokens, uint256[] prices);
948 
949     /**
950      * Event emitted to notify about a purchase.
951      * @param purchaser The initiater and buyer of the purchase.
952      * @param recipient The recipient of the purchase.
953      * @param token The token used as the currency for the payment.
954      * @param sku The identifier of the purchased SKU.
955      * @param quantity The purchased quantity.
956      * @param userData Optional extra user input data.
957      * @param totalPrice The amount of `token` paid.
958      * @param extData Implementation-specific extra purchase data, such as
959      *  details about discounts applied, conversion rates, purchase receipts, etc.
960      */
961     event Purchase(
962         address indexed purchaser,
963         address recipient,
964         address indexed token,
965         bytes32 indexed sku,
966         uint256 quantity,
967         bytes userData,
968         uint256 totalPrice,
969         bytes extData
970     );
971 
972     /**
973      * Returns the magic value used to represent the ETH payment token.
974      * @dev MUST NOT be the zero address.
975      * @return the magic value used to represent the ETH payment token.
976      */
977     // solhint-disable-next-line func-name-mixedcase
978     function TOKEN_ETH() external pure returns (address);
979 
980     /**
981      * Returns the magic value used to represent an infinite, never-decreasing SKU's supply.
982      * @dev MUST NOT be zero.
983      * @return the magic value used to represent an infinite, never-decreasing SKU's supply.
984      */
985     // solhint-disable-next-line func-name-mixedcase
986     function SUPPLY_UNLIMITED() external pure returns (uint256);
987 
988     /**
989      * Performs a purchase.
990      * @dev Reverts if `recipient` is the zero address.
991      * @dev Reverts if `token` is the address zero.
992      * @dev Reverts if `quantity` is zero.
993      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
994      * @dev Reverts if `quantity` is greater than the remaining supply.
995      * @dev Reverts if `sku` does not exist.
996      * @dev Reverts if `sku` exists but does not have a price set for `token`.
997      * @dev Emits the Purchase event.
998      * @param recipient The recipient of the purchase.
999      * @param token The token to use as the payment currency.
1000      * @param sku The identifier of the SKU to purchase.
1001      * @param quantity The quantity to purchase.
1002      * @param userData Optional extra user input data.
1003      */
1004     function purchaseFor(
1005         address payable recipient,
1006         address token,
1007         bytes32 sku,
1008         uint256 quantity,
1009         bytes calldata userData
1010     ) external payable;
1011 
1012     /**
1013      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1014      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1015      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1016      * @dev Reverts if `recipient` is the zero address.
1017      * @dev Reverts if `token` is the zero address.
1018      * @dev Reverts if `quantity` is zero.
1019      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1020      * @dev Reverts if `quantity` is greater than the remaining supply.
1021      * @dev Reverts if `sku` does not exist.
1022      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1023      * @param recipient The recipient of the purchase used to calculate the total price amount.
1024      * @param token The payment token used to calculate the total price amount.
1025      * @param sku The identifier of the SKU used to calculate the total price amount.
1026      * @param quantity The quantity used to calculate the total price amount.
1027      * @param userData Optional extra user input data.
1028      * @return totalPrice The computed total price to pay.
1029      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1030      *  If not empty, the implementer MUST document how to interepret the values.
1031      */
1032     function estimatePurchase(
1033         address payable recipient,
1034         address token,
1035         bytes32 sku,
1036         uint256 quantity,
1037         bytes calldata userData
1038     ) external view returns (uint256 totalPrice, bytes32[] memory pricingData);
1039 
1040     /**
1041      * Returns the information relative to a SKU.
1042      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1043      *  number of payment tokens is bounded, so that this function does not run out of gas.
1044      * @dev Reverts if `sku` does not exist.
1045      * @param sku The SKU identifier.
1046      * @return totalSupply The initial total supply for sale.
1047      * @return remainingSupply The remaining supply for sale.
1048      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1049      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1050      * @return tokens The list of supported payment tokens.
1051      * @return prices The list of associated prices for each of the `tokens`.
1052      */
1053     function getSkuInfo(bytes32 sku)
1054         external
1055         view
1056         returns (
1057             uint256 totalSupply,
1058             uint256 remainingSupply,
1059             uint256 maxQuantityPerPurchase,
1060             address notificationsReceiver,
1061             address[] memory tokens,
1062             uint256[] memory prices
1063         );
1064 
1065     /**
1066      * Returns the list of created SKU identifiers.
1067      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1068      *  number of SKUs is bounded, so that this function does not run out of gas.
1069      * @return skus the list of created SKU identifiers.
1070      */
1071     function getSkus() external view returns (bytes32[] memory skus);
1072 }
1073 
1074 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/interfaces/IPurchaseNotificationsReceiver.sol@v2.0.0
1075 
1076 pragma solidity >=0.7.6 <0.8.0;
1077 
1078 /**
1079  * @title IPurchaseNotificationsReceiver
1080  * Interface for any contract that wants to support purchase notifications from a Sale contract.
1081  */
1082 interface IPurchaseNotificationsReceiver {
1083     /**
1084      * Handles the receipt of a purchase notification.
1085      * @dev This function MUST return the function selector, otherwise the caller will revert the transaction.
1086      *  The selector to be returned can be obtained as `this.onPurchaseNotificationReceived.selector`
1087      * @dev This function MAY throw.
1088      * @param purchaser The purchaser of the purchase.
1089      * @param recipient The recipient of the purchase.
1090      * @param token The token to use as the payment currency.
1091      * @param sku The identifier of the SKU to purchase.
1092      * @param quantity The quantity to purchase.
1093      * @param userData Optional extra user input data.
1094      * @param totalPrice The total price paid.
1095      * @param pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1096      * @param paymentData Implementation-specific extra payment data, such as conversion rates.
1097      * @param deliveryData Implementation-specific extra delivery data, such as purchase receipts.
1098      * @return `bytes4(keccak256(
1099      *  "onPurchaseNotificationReceived(address,address,address,bytes32,uint256,bytes,uint256,bytes32[],bytes32[],bytes32[])"))`
1100      */
1101     function onPurchaseNotificationReceived(
1102         address purchaser,
1103         address recipient,
1104         address token,
1105         bytes32 sku,
1106         uint256 quantity,
1107         bytes calldata userData,
1108         uint256 totalPrice,
1109         bytes32[] calldata pricingData,
1110         bytes32[] calldata paymentData,
1111         bytes32[] calldata deliveryData
1112     ) external returns (bytes4);
1113 }
1114 
1115 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/abstract/PurchaseLifeCycles.sol@v2.0.0
1116 
1117 pragma solidity >=0.7.6 <0.8.0;
1118 
1119 /**
1120  * @title PurchaseLifeCycles
1121  * An abstract contract which define the life cycles for a purchase implementer.
1122  */
1123 abstract contract PurchaseLifeCycles {
1124     /**
1125      * Wrapper for the purchase data passed as argument to the life cycle functions and down to their step functions.
1126      */
1127     struct PurchaseData {
1128         address payable purchaser;
1129         address payable recipient;
1130         address token;
1131         bytes32 sku;
1132         uint256 quantity;
1133         bytes userData;
1134         uint256 totalPrice;
1135         bytes32[] pricingData;
1136         bytes32[] paymentData;
1137         bytes32[] deliveryData;
1138     }
1139 
1140     /*                               Internal Life Cycle Functions                               */
1141 
1142     /**
1143      * `estimatePurchase` lifecycle.
1144      * @param purchase The purchase conditions.
1145      */
1146     function _estimatePurchase(PurchaseData memory purchase) internal view virtual returns (uint256 totalPrice, bytes32[] memory pricingData) {
1147         _validation(purchase);
1148         _pricing(purchase);
1149 
1150         totalPrice = purchase.totalPrice;
1151         pricingData = purchase.pricingData;
1152     }
1153 
1154     /**
1155      * `purchaseFor` lifecycle.
1156      * @param purchase The purchase conditions.
1157      */
1158     function _purchaseFor(PurchaseData memory purchase) internal virtual {
1159         _validation(purchase);
1160         _pricing(purchase);
1161         _payment(purchase);
1162         _delivery(purchase);
1163         _notification(purchase);
1164     }
1165 
1166     /*                            Internal Life Cycle Step Functions                             */
1167 
1168     /**
1169      * Lifecycle step which validates the purchase pre-conditions.
1170      * @dev Responsibilities:
1171      *  - Ensure that the purchase pre-conditions are met and revert if not.
1172      * @param purchase The purchase conditions.
1173      */
1174     function _validation(PurchaseData memory purchase) internal view virtual;
1175 
1176     /**
1177      * Lifecycle step which computes the purchase price.
1178      * @dev Responsibilities:
1179      *  - Computes the pricing formula, including any discount logic and price conversion;
1180      *  - Set the value of `purchase.totalPrice`;
1181      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1182      * @param purchase The purchase conditions.
1183      */
1184     function _pricing(PurchaseData memory purchase) internal view virtual;
1185 
1186     /**
1187      * Lifecycle step which manages the transfer of funds from the purchaser.
1188      * @dev Responsibilities:
1189      *  - Ensure the payment reaches destination in the expected output token;
1190      *  - Handle any token swap logic;
1191      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1192      * @param purchase The purchase conditions.
1193      */
1194     function _payment(PurchaseData memory purchase) internal virtual;
1195 
1196     /**
1197      * Lifecycle step which delivers the purchased SKUs to the recipient.
1198      * @dev Responsibilities:
1199      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1200      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1201      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1202      * @param purchase The purchase conditions.
1203      */
1204     function _delivery(PurchaseData memory purchase) internal virtual;
1205 
1206     /**
1207      * Lifecycle step which notifies of the purchase.
1208      * @dev Responsibilities:
1209      *  - Manage after-purchase event(s) emission.
1210      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1211      * @param purchase The purchase conditions.
1212      */
1213     function _notification(PurchaseData memory purchase) internal virtual;
1214 }
1215 
1216 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/abstract/Sale.sol@v2.0.0
1217 
1218 pragma solidity >=0.7.6 <0.8.0;
1219 
1220 /**
1221  * @title Sale
1222  * An abstract base sale contract with a minimal implementation of ISale and administration functions.
1223  *  A minimal implementation of the `_validation`, `_delivery` and `notification` life cycle step functions
1224  *  are provided, but the inheriting contract must implement `_pricing` and `_payment`.
1225  */
1226 abstract contract Sale is PurchaseLifeCycles, ISale, PayoutWallet, Startable, Pausable {
1227     using AddressIsContract for address;
1228     using SafeMath for uint256;
1229     using EnumSet for EnumSet.Set;
1230     using EnumMap for EnumMap.Map;
1231 
1232     struct SkuInfo {
1233         uint256 totalSupply;
1234         uint256 remainingSupply;
1235         uint256 maxQuantityPerPurchase;
1236         address notificationsReceiver;
1237         EnumMap.Map prices;
1238     }
1239 
1240     address public constant override TOKEN_ETH = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1241     uint256 public constant override SUPPLY_UNLIMITED = type(uint256).max;
1242 
1243     EnumSet.Set internal _skus;
1244     mapping(bytes32 => SkuInfo) internal _skuInfos;
1245 
1246     uint256 internal immutable _skusCapacity;
1247     uint256 internal immutable _tokensPerSkuCapacity;
1248 
1249     /**
1250      * Constructor.
1251      * @dev Emits the `MagicValues` event.
1252      * @dev Emits the `Paused` event.
1253      * @param payoutWallet_ the payout wallet.
1254      * @param skusCapacity the cap for the number of managed SKUs.
1255      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1256      */
1257     constructor(
1258         address payable payoutWallet_,
1259         uint256 skusCapacity,
1260         uint256 tokensPerSkuCapacity
1261     ) PayoutWallet(msg.sender, payoutWallet_) Pausable(true) {
1262         _skusCapacity = skusCapacity;
1263         _tokensPerSkuCapacity = tokensPerSkuCapacity;
1264         bytes32[] memory names = new bytes32[](2);
1265         bytes32[] memory values = new bytes32[](2);
1266         (names[0], values[0]) = ("TOKEN_ETH", bytes32(uint256(TOKEN_ETH)));
1267         (names[1], values[1]) = ("SUPPLY_UNLIMITED", bytes32(uint256(SUPPLY_UNLIMITED)));
1268         emit MagicValues(names, values);
1269     }
1270 
1271     /*                                   Public Admin Functions                                  */
1272 
1273     /**
1274      * Actvates, or 'starts', the contract.
1275      * @dev Emits the `Started` event.
1276      * @dev Emits the `Unpaused` event.
1277      * @dev Reverts if called by any other than the contract owner.
1278      * @dev Reverts if the contract has already been started.
1279      * @dev Reverts if the contract is not paused.
1280      */
1281     function start() public virtual {
1282         _requireOwnership(_msgSender());
1283         _start();
1284         _unpause();
1285     }
1286 
1287     /**
1288      * Pauses the contract.
1289      * @dev Emits the `Paused` event.
1290      * @dev Reverts if called by any other than the contract owner.
1291      * @dev Reverts if the contract has not been started yet.
1292      * @dev Reverts if the contract is already paused.
1293      */
1294     function pause() public virtual whenStarted {
1295         _requireOwnership(_msgSender());
1296         _pause();
1297     }
1298 
1299     /**
1300      * Resumes the contract.
1301      * @dev Emits the `Unpaused` event.
1302      * @dev Reverts if called by any other than the contract owner.
1303      * @dev Reverts if the contract has not been started yet.
1304      * @dev Reverts if the contract is not paused.
1305      */
1306     function unpause() public virtual whenStarted {
1307         _requireOwnership(_msgSender());
1308         _unpause();
1309     }
1310 
1311     /**
1312      * Sets the token prices for the specified product SKU.
1313      * @dev Reverts if called by any other than the contract owner.
1314      * @dev Reverts if `tokens` and `prices` have different lengths.
1315      * @dev Reverts if `sku` does not exist.
1316      * @dev Reverts if one of the `tokens` is the zero address.
1317      * @dev Reverts if the update results in too many tokens for the SKU.
1318      * @dev Emits the `SkuPricingUpdate` event.
1319      * @param sku The identifier of the SKU.
1320      * @param tokens The list of payment tokens to update.
1321      *  If empty, disable all the existing payment tokens.
1322      * @param prices The list of prices to apply for each payment token.
1323      *  Zero price values are used to disable a payment token.
1324      */
1325     function updateSkuPricing(
1326         bytes32 sku,
1327         address[] memory tokens,
1328         uint256[] memory prices
1329     ) public virtual {
1330         _requireOwnership(_msgSender());
1331         uint256 length = tokens.length;
1332         require(length == prices.length, "Sale: inconsistent arrays");
1333         SkuInfo storage skuInfo = _skuInfos[sku];
1334         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1335 
1336         EnumMap.Map storage tokenPrices = skuInfo.prices;
1337         if (length == 0) {
1338             uint256 currentLength = tokenPrices.length();
1339             for (uint256 i = 0; i < currentLength; ++i) {
1340                 // TODO add a clear function in EnumMap and EnumSet and use it
1341                 (bytes32 token, ) = tokenPrices.at(0);
1342                 tokenPrices.remove(token);
1343             }
1344         } else {
1345             _setTokenPrices(tokenPrices, tokens, prices);
1346         }
1347 
1348         emit SkuPricingUpdate(sku, tokens, prices);
1349     }
1350 
1351     /*                                   ISale Public Functions                                  */
1352 
1353     /**
1354      * Performs a purchase.
1355      * @dev Reverts if the sale has not started.
1356      * @dev Reverts if the sale is paused.
1357      * @dev Reverts if `recipient` is the zero address.
1358      * @dev Reverts if `token` is the zero address.
1359      * @dev Reverts if `quantity` is zero.
1360      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1361      * @dev Reverts if `quantity` is greater than the remaining supply.
1362      * @dev Reverts if `sku` does not exist.
1363      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1364      * @dev Emits the Purchase event.
1365      * @param recipient The recipient of the purchase.
1366      * @param token The token to use as the payment currency.
1367      * @param sku The identifier of the SKU to purchase.
1368      * @param quantity The quantity to purchase.
1369      * @param userData Optional extra user input data.
1370      */
1371     function purchaseFor(
1372         address payable recipient,
1373         address token,
1374         bytes32 sku,
1375         uint256 quantity,
1376         bytes calldata userData
1377     ) external payable virtual override whenStarted {
1378         _requireNotPaused();
1379         PurchaseData memory purchase;
1380         purchase.purchaser = _msgSender();
1381         purchase.recipient = recipient;
1382         purchase.token = token;
1383         purchase.sku = sku;
1384         purchase.quantity = quantity;
1385         purchase.userData = userData;
1386 
1387         _purchaseFor(purchase);
1388     }
1389 
1390     /**
1391      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1392      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1393      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1394      * @dev Reverts if the sale has not started.
1395      * @dev Reverts if the sale is paused.
1396      * @dev Reverts if `recipient` is the zero address.
1397      * @dev Reverts if `token` is the zero address.
1398      * @dev Reverts if `quantity` is zero.
1399      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1400      * @dev Reverts if `quantity` is greater than the remaining supply.
1401      * @dev Reverts if `sku` does not exist.
1402      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1403      * @param recipient The recipient of the purchase used to calculate the total price amount.
1404      * @param token The payment token used to calculate the total price amount.
1405      * @param sku The identifier of the SKU used to calculate the total price amount.
1406      * @param quantity The quantity used to calculate the total price amount.
1407      * @param userData Optional extra user input data.
1408      * @return totalPrice The computed total price.
1409      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1410      *  If not empty, the implementer MUST document how to interepret the values.
1411      */
1412     function estimatePurchase(
1413         address payable recipient,
1414         address token,
1415         bytes32 sku,
1416         uint256 quantity,
1417         bytes calldata userData
1418     ) external view virtual override whenStarted returns (uint256 totalPrice, bytes32[] memory pricingData) {
1419         _requireNotPaused();
1420         PurchaseData memory purchase;
1421         purchase.purchaser = _msgSender();
1422         purchase.recipient = recipient;
1423         purchase.token = token;
1424         purchase.sku = sku;
1425         purchase.quantity = quantity;
1426         purchase.userData = userData;
1427 
1428         return _estimatePurchase(purchase);
1429     }
1430 
1431     /**
1432      * Returns the information relative to a SKU.
1433      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1434      * number of payment tokens is bounded, so that this function does not run out of gas.
1435      * @dev Reverts if `sku` does not exist.
1436      * @param sku The SKU identifier.
1437      * @return totalSupply The initial total supply for sale.
1438      * @return remainingSupply The remaining supply for sale.
1439      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1440      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1441      * @return tokens The list of supported payment tokens.
1442      * @return prices The list of associated prices for each of the `tokens`.
1443      */
1444     function getSkuInfo(bytes32 sku)
1445         external
1446         view
1447         override
1448         returns (
1449             uint256 totalSupply,
1450             uint256 remainingSupply,
1451             uint256 maxQuantityPerPurchase,
1452             address notificationsReceiver,
1453             address[] memory tokens,
1454             uint256[] memory prices
1455         )
1456     {
1457         SkuInfo storage skuInfo = _skuInfos[sku];
1458         uint256 length = skuInfo.prices.length();
1459 
1460         totalSupply = skuInfo.totalSupply;
1461         require(totalSupply != 0, "Sale: non-existent sku");
1462         remainingSupply = skuInfo.remainingSupply;
1463         maxQuantityPerPurchase = skuInfo.maxQuantityPerPurchase;
1464         notificationsReceiver = skuInfo.notificationsReceiver;
1465 
1466         tokens = new address[](length);
1467         prices = new uint256[](length);
1468         for (uint256 i = 0; i < length; ++i) {
1469             (bytes32 token, bytes32 price) = skuInfo.prices.at(i);
1470             tokens[i] = address(uint256(token));
1471             prices[i] = uint256(price);
1472         }
1473     }
1474 
1475     /**
1476      * Returns the list of created SKU identifiers.
1477      * @return skus the list of created SKU identifiers.
1478      */
1479     function getSkus() external view override returns (bytes32[] memory skus) {
1480         skus = _skus.values;
1481     }
1482 
1483     /*                               Internal Utility Functions                                  */
1484 
1485     /**
1486      * Creates an SKU.
1487      * @dev Reverts if `totalSupply` is zero.
1488      * @dev Reverts if `sku` already exists.
1489      * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
1490      * @dev Reverts if the update results in too many SKUs.
1491      * @dev Emits the `SkuCreation` event.
1492      * @param sku the SKU identifier.
1493      * @param totalSupply the initial total supply.
1494      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1495      * @param notificationsReceiver The purchase notifications receiver contract address.
1496      *  If set to the zero address, the notification is not enabled.
1497      */
1498     function _createSku(
1499         bytes32 sku,
1500         uint256 totalSupply,
1501         uint256 maxQuantityPerPurchase,
1502         address notificationsReceiver
1503     ) internal virtual {
1504         require(totalSupply != 0, "Sale: zero supply");
1505         require(_skus.length() < _skusCapacity, "Sale: too many skus");
1506         require(_skus.add(sku), "Sale: sku already created");
1507         if (notificationsReceiver != address(0)) {
1508             require(notificationsReceiver.isContract(), "Sale: non-contract receiver");
1509         }
1510         SkuInfo storage skuInfo = _skuInfos[sku];
1511         skuInfo.totalSupply = totalSupply;
1512         skuInfo.remainingSupply = totalSupply;
1513         skuInfo.maxQuantityPerPurchase = maxQuantityPerPurchase;
1514         skuInfo.notificationsReceiver = notificationsReceiver;
1515         emit SkuCreation(sku, totalSupply, maxQuantityPerPurchase, notificationsReceiver);
1516     }
1517 
1518     /**
1519      * Updates SKU token prices.
1520      * @dev Reverts if one of the `tokens` is the zero address.
1521      * @dev Reverts if the update results in too many tokens for the SKU.
1522      * @param tokenPrices Storage pointer to a mapping of SKU token prices to update.
1523      * @param tokens The list of payment tokens to update.
1524      * @param prices The list of prices to apply for each payment token.
1525      *  Zero price values are used to disable a payment token.
1526      */
1527     function _setTokenPrices(
1528         EnumMap.Map storage tokenPrices,
1529         address[] memory tokens,
1530         uint256[] memory prices
1531     ) internal virtual {
1532         for (uint256 i = 0; i < tokens.length; ++i) {
1533             address token = tokens[i];
1534             require(token != address(0), "Sale: zero address token");
1535             uint256 price = prices[i];
1536             if (price == 0) {
1537                 tokenPrices.remove(bytes32(uint256(token)));
1538             } else {
1539                 tokenPrices.set(bytes32(uint256(token)), bytes32(price));
1540             }
1541         }
1542         require(tokenPrices.length() <= _tokensPerSkuCapacity, "Sale: too many tokens");
1543     }
1544 
1545     /*                            Internal Life Cycle Step Functions                             */
1546 
1547     /**
1548      * Lifecycle step which validates the purchase pre-conditions.
1549      * @dev Responsibilities:
1550      *  - Ensure that the purchase pre-conditions are met and revert if not.
1551      * @dev Reverts if `purchase.recipient` is the zero address.
1552      * @dev Reverts if `purchase.token` is the zero address.
1553      * @dev Reverts if `purchase.quantity` is zero.
1554      * @dev Reverts if `purchase.quantity` is greater than the SKU's `maxQuantityPerPurchase`.
1555      * @dev Reverts if `purchase.quantity` is greater than the available supply.
1556      * @dev Reverts if `purchase.sku` does not exist.
1557      * @dev Reverts if `purchase.sku` exists but does not have a price set for `purchase.token`.
1558      * @dev If this function is overriden, the implementer SHOULD super call this before.
1559      * @param purchase The purchase conditions.
1560      */
1561     function _validation(PurchaseData memory purchase) internal view virtual override {
1562         require(purchase.recipient != address(0), "Sale: zero address recipient");
1563         require(purchase.token != address(0), "Sale: zero address token");
1564         require(purchase.quantity != 0, "Sale: zero quantity purchase");
1565         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1566         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1567         require(skuInfo.maxQuantityPerPurchase >= purchase.quantity, "Sale: above max quantity");
1568         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1569             require(skuInfo.remainingSupply >= purchase.quantity, "Sale: insufficient supply");
1570         }
1571         bytes32 priceKey = bytes32(uint256(purchase.token));
1572         require(skuInfo.prices.contains(priceKey), "Sale: non-existent sku token");
1573     }
1574 
1575     /**
1576      * Lifecycle step which delivers the purchased SKUs to the recipient.
1577      * @dev Responsibilities:
1578      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1579      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1580      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1581      * @dev Reverts if there is not enough available supply.
1582      * @dev If this function is overriden, the implementer SHOULD super call it.
1583      * @param purchase The purchase conditions.
1584      */
1585     function _delivery(PurchaseData memory purchase) internal virtual override {
1586         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1587         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1588             _skuInfos[purchase.sku].remainingSupply = skuInfo.remainingSupply.sub(purchase.quantity);
1589         }
1590     }
1591 
1592     /**
1593      * Lifecycle step which notifies of the purchase.
1594      * @dev Responsibilities:
1595      *  - Manage after-purchase event(s) emission.
1596      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1597      * @dev Reverts if `onPurchaseNotificationReceived` throws or returns an incorrect value.
1598      * @dev Emits the `Purchase` event. The values of `purchaseData` are the concatenated values of `priceData`, `paymentData`
1599      * and `deliveryData`. If not empty, the implementer MUST document how to interpret these values.
1600      * @dev If this function is overriden, the implementer SHOULD super call it.
1601      * @param purchase The purchase conditions.
1602      */
1603     function _notification(PurchaseData memory purchase) internal virtual override {
1604         emit Purchase(
1605             purchase.purchaser,
1606             purchase.recipient,
1607             purchase.token,
1608             purchase.sku,
1609             purchase.quantity,
1610             purchase.userData,
1611             purchase.totalPrice,
1612             abi.encodePacked(purchase.pricingData, purchase.paymentData, purchase.deliveryData)
1613         );
1614 
1615         address notificationsReceiver = _skuInfos[purchase.sku].notificationsReceiver;
1616         if (notificationsReceiver != address(0)) {
1617             require(
1618                 IPurchaseNotificationsReceiver(notificationsReceiver).onPurchaseNotificationReceived(
1619                     purchase.purchaser,
1620                     purchase.recipient,
1621                     purchase.token,
1622                     purchase.sku,
1623                     purchase.quantity,
1624                     purchase.userData,
1625                     purchase.totalPrice,
1626                     purchase.pricingData,
1627                     purchase.paymentData,
1628                     purchase.deliveryData
1629                 ) == IPurchaseNotificationsReceiver(address(0)).onPurchaseNotificationReceived.selector, // TODO precompute return value
1630                 "Sale: notification refused"
1631             );
1632         }
1633     }
1634 }
1635 
1636 // File @animoca/ethereum-contracts-sale-2.0.0/contracts/sale/FixedPricesSale.sol@v2.0.0
1637 
1638 pragma solidity >=0.7.6 <0.8.0;
1639 
1640 /**
1641  * @title FixedPricesSale
1642  * An Sale which implements a fixed prices strategy.
1643  *  The final implementer is responsible for implementing any additional pricing and/or delivery logic.
1644  */
1645 abstract contract FixedPricesSale is Sale {
1646     using ERC20Wrapper for IWrappedERC20;
1647     using SafeMath for uint256;
1648     using EnumMap for EnumMap.Map;
1649 
1650     /**
1651      * Constructor.
1652      * @dev Emits the `MagicValues` event.
1653      * @dev Emits the `Paused` event.
1654      * @param payoutWallet_ the payout wallet.
1655      * @param skusCapacity the cap for the number of managed SKUs.
1656      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1657      */
1658     constructor(
1659         address payable payoutWallet_,
1660         uint256 skusCapacity,
1661         uint256 tokensPerSkuCapacity
1662     ) Sale(payoutWallet_, skusCapacity, tokensPerSkuCapacity) {}
1663 
1664     /*                               Internal Life Cycle Functions                               */
1665 
1666     /**
1667      * Lifecycle step which computes the purchase price.
1668      * @dev Responsibilities:
1669      *  - Computes the pricing formula, including any discount logic and price conversion;
1670      *  - Set the value of `purchase.totalPrice`;
1671      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1672      * @dev Reverts if `purchase.sku` does not exist.
1673      * @dev Reverts if `purchase.token` is not supported by the SKU.
1674      * @dev Reverts in case of price overflow.
1675      * @param purchase The purchase conditions.
1676      */
1677     function _pricing(PurchaseData memory purchase) internal view virtual override {
1678         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1679         require(skuInfo.totalSupply != 0, "Sale: unsupported SKU");
1680         EnumMap.Map storage prices = skuInfo.prices;
1681         uint256 unitPrice = _unitPrice(purchase, prices);
1682         purchase.totalPrice = unitPrice.mul(purchase.quantity);
1683     }
1684 
1685     /**
1686      * Lifecycle step which manages the transfer of funds from the purchaser.
1687      * @dev Responsibilities:
1688      *  - Ensure the payment reaches destination in the expected output token;
1689      *  - Handle any token swap logic;
1690      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1691      * @dev Reverts in case of payment failure.
1692      * @param purchase The purchase conditions.
1693      */
1694     function _payment(PurchaseData memory purchase) internal virtual override {
1695         if (purchase.token == TOKEN_ETH) {
1696             require(msg.value >= purchase.totalPrice, "Sale: insufficient ETH");
1697 
1698             payoutWallet.transfer(purchase.totalPrice);
1699 
1700             uint256 change = msg.value.sub(purchase.totalPrice);
1701 
1702             if (change != 0) {
1703                 purchase.purchaser.transfer(change);
1704             }
1705         } else {
1706             IWrappedERC20(purchase.token).wrappedTransferFrom(_msgSender(), payoutWallet, purchase.totalPrice);
1707         }
1708     }
1709 
1710     /*                               Internal Utility Functions                                  */
1711 
1712     /**
1713      * Retrieves the unit price of a SKU for the specified payment token.
1714      * @dev Reverts if the specified payment token is unsupported.
1715      * @param purchase The purchase conditions specifying the payment token with which the unit price will be retrieved.
1716      * @param prices Storage pointer to a mapping of SKU token prices to retrieve the unit price from.
1717      * @return unitPrice The unit price of a SKU for the specified payment token.
1718      */
1719     function _unitPrice(PurchaseData memory purchase, EnumMap.Map storage prices) internal view virtual returns (uint256 unitPrice) {
1720         unitPrice = uint256(prices.get(bytes32(uint256(purchase.token))));
1721         require(unitPrice != 0, "Sale: unsupported payment token");
1722     }
1723 }
1724 
1725 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/Recoverable.sol@v1.1.2
1726 
1727 pragma solidity >=0.7.6 <0.8.0;
1728 
1729 abstract contract Recoverable is ManagedIdentity, Ownable {
1730     using ERC20Wrapper for IWrappedERC20;
1731 
1732     /**
1733      * Extract ERC20 tokens which were accidentally sent to the contract to a list of accounts.
1734      * Warning: this function should be overriden for contracts which are supposed to hold ERC20 tokens
1735      * so that the extraction is limited to only amounts sent accidentally.
1736      * @dev Reverts if the sender is not the contract owner.
1737      * @dev Reverts if `accounts`, `tokens` and `amounts` do not have the same length.
1738      * @dev Reverts if one of `tokens` is does not implement the ERC20 transfer function.
1739      * @dev Reverts if one of the ERC20 transfers fail for any reason.
1740      * @param accounts the list of accounts to transfer the tokens to.
1741      * @param tokens the list of ERC20 token addresses.
1742      * @param amounts the list of token amounts to transfer.
1743      */
1744     function recoverERC20s(
1745         address[] calldata accounts,
1746         address[] calldata tokens,
1747         uint256[] calldata amounts
1748     ) external virtual {
1749         _requireOwnership(_msgSender());
1750         uint256 length = accounts.length;
1751         require(length == tokens.length && length == amounts.length, "Recov: inconsistent arrays");
1752         for (uint256 i = 0; i != length; ++i) {
1753             IWrappedERC20(tokens[i]).wrappedTransfer(accounts[i], amounts[i]);
1754         }
1755     }
1756 
1757     /**
1758      * Extract ERC721 tokens which were accidentally sent to the contract to a list of accounts.
1759      * Warning: this function should be overriden for contracts which are supposed to hold ERC721 tokens
1760      * so that the extraction is limited to only tokens sent accidentally.
1761      * @dev Reverts if the sender is not the contract owner.
1762      * @dev Reverts if `accounts`, `contracts` and `amounts` do not have the same length.
1763      * @dev Reverts if one of `contracts` is does not implement the ERC721 transferFrom function.
1764      * @dev Reverts if one of the ERC721 transfers fail for any reason.
1765      * @param accounts the list of accounts to transfer the tokens to.
1766      * @param contracts the list of ERC721 contract addresses.
1767      * @param tokenIds the list of token ids to transfer.
1768      */
1769     function recoverERC721s(
1770         address[] calldata accounts,
1771         address[] calldata contracts,
1772         uint256[] calldata tokenIds
1773     ) external virtual {
1774         _requireOwnership(_msgSender());
1775         uint256 length = accounts.length;
1776         require(length == contracts.length && length == tokenIds.length, "Recov: inconsistent arrays");
1777         for (uint256 i = 0; i != length; ++i) {
1778             IRecoverableERC721(contracts[i]).transferFrom(address(this), accounts[i], tokenIds[i]);
1779         }
1780     }
1781 }
1782 
1783 interface IRecoverableERC721 {
1784     /// See {IERC721-transferFrom(address,address,uint256)}
1785     function transferFrom(
1786         address from,
1787         address to,
1788         uint256 tokenId
1789     ) external;
1790 }
1791 
1792 // File contracts/sale/BenjiBananasPassSale.sol
1793 
1794 pragma solidity >=0.7.6 <0.8.0;
1795 
1796 /**
1797  * @title BenjiBananas Membership Pass Sale
1798  * A FixedPricesSale contract that handles the purchase and delivery of BenjiBananas Membership Pass.
1799  */
1800 contract BenjiBananasPassSale is FixedPricesSale, Recoverable {
1801     IMembershipPassContract public immutable membershipPassContract;
1802 
1803     struct SkuAdditionalInfo {
1804         uint256[] tokenIds;
1805         uint256 startTimestamp;
1806         uint256 endTimestamp;
1807     }
1808 
1809     mapping(bytes32 => SkuAdditionalInfo) internal _skuAdditionalInfo;
1810 
1811     /**
1812      * Constructor.
1813      * @dev Emits the `MagicValues` event.
1814      * @dev Emits the `Paused` event.
1815      * @param membershipPass_ The inventory contract from which the sale supply is attributed from.
1816      * @param payoutWallet the payout wallet.
1817      * @param skusCapacity the cap for the number of managed SKUs.
1818      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1819      */
1820     constructor(
1821         IMembershipPassContract membershipPass_,
1822         address payable payoutWallet,
1823         uint256 skusCapacity,
1824         uint256 tokensPerSkuCapacity
1825     ) FixedPricesSale(payoutWallet, skusCapacity, tokensPerSkuCapacity) {
1826         membershipPassContract = membershipPass_;
1827     }
1828 
1829     /**
1830      * Creates an SKU.
1831      * @dev Reverts if `totalSupply` is zero.
1832      * @dev Reverts if `sku` already exists.
1833      * @dev Reverts if the update results in too many SKUs.
1834      * @dev Reverts if one of `tokenIds` is not a fungible token identifier.
1835      * @dev Emits the `SkuCreation` event.
1836      * @param sku The SKU identifier.
1837      * @param totalSupply The initial total supply.
1838      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1839      * @param tokenIds The inventory contract token IDs to associate with the SKU, used for purchase delivery.
1840      * @param startTimestamp The start timestamp of the sale.
1841      * @param endTimestamp The end timestamp of the sale, or zero to indicate there is no end.
1842      */
1843     function createSku(
1844         bytes32 sku,
1845         uint256 totalSupply,
1846         uint256 maxQuantityPerPurchase,
1847         uint256[] calldata tokenIds,
1848         uint256 startTimestamp,
1849         uint256 endTimestamp
1850     ) external {
1851         _requireOwnership(_msgSender());
1852         uint256 length = tokenIds.length;
1853         require(length != 0, "Sale: empty tokens");
1854         for (uint256 i; i != length; ++i) {
1855             require(membershipPassContract.isFungible(tokenIds[i]), "Sale: not a fungible token");
1856         }
1857         _skuAdditionalInfo[sku] = SkuAdditionalInfo(tokenIds, startTimestamp, endTimestamp);
1858         _createSku(sku, totalSupply, maxQuantityPerPurchase, address(0));
1859     }
1860 
1861     /**
1862      * Updates start and end timestamps of a SKU.
1863      * @dev Reverts if not sent by the contract owner.
1864      * @dev Reverts if the SKU does not exist.
1865      * @param sku the SKU identifier.
1866      * @param startTimestamp The start timestamp of the sale.
1867      * @param endTimestamp The end timestamp of the sale, or zero to indicate there is no end.
1868      */
1869     function updateSkuTimestamps(
1870         bytes32 sku,
1871         uint256 startTimestamp,
1872         uint256 endTimestamp
1873     ) external {
1874         _requireOwnership(_msgSender());
1875         require(_skuInfos[sku].totalSupply != 0, "Sale: non-existent sku");
1876         SkuAdditionalInfo storage info = _skuAdditionalInfo[sku];
1877         info.startTimestamp = startTimestamp;
1878         info.endTimestamp = endTimestamp;
1879     }
1880 
1881     /**
1882      * Gets the additional sku info.
1883      * @dev Reverts if the SKU does not exist.
1884      * @param sku the SKU identifier.
1885      * @return tokenIds The identifiers of the tokens delivered via this SKU.
1886      * @return startTimestamp The start timestamp of the SKU sale.
1887      * @return endTimestamp The end timestamp of the SKU sale (zero if there is no end).
1888      */
1889     function getSkuAdditionalInfo(bytes32 sku)
1890         external
1891         view
1892         returns (
1893             uint256[] memory tokenIds,
1894             uint256 startTimestamp,
1895             uint256 endTimestamp
1896         )
1897     {
1898         require(_skuInfos[sku].totalSupply != 0, "Sale: non-existent sku");
1899         SkuAdditionalInfo memory info = _skuAdditionalInfo[sku];
1900         return (info.tokenIds, info.startTimestamp, info.endTimestamp);
1901     }
1902 
1903     /**
1904      * Returns whether a SKU is currently within the sale time range.
1905      * @dev Reverts if the SKU does not exist.
1906      * @param sku the SKU identifier.
1907      * @return true if `sku` is currently within the sale time range, false otherwise.
1908      */
1909     function canPurchaseSku(bytes32 sku) external view returns (bool) {
1910         require(_skuInfos[sku].totalSupply != 0, "Sale: non-existent sku");
1911         SkuAdditionalInfo memory info = _skuAdditionalInfo[sku];
1912         return block.timestamp > info.startTimestamp && (info.endTimestamp == 0 || block.timestamp < info.endTimestamp);
1913     }
1914 
1915     /// @inheritdoc Sale
1916     function _delivery(PurchaseData memory purchase) internal override {
1917         super._delivery(purchase);
1918         SkuAdditionalInfo memory info = _skuAdditionalInfo[purchase.sku];
1919         uint256 startTimestamp = info.startTimestamp;
1920         uint256 endTimestamp = info.endTimestamp;
1921         require(block.timestamp > startTimestamp, "Sale: not started yet");
1922         require(endTimestamp == 0 || block.timestamp < endTimestamp, "Sale: already ended");
1923 
1924         uint256 length = info.tokenIds.length;
1925         if (length == 1) {
1926             membershipPassContract.safeMint(purchase.recipient, info.tokenIds[0], purchase.quantity, "");
1927         } else {
1928             uint256 purchaseQuantity = purchase.quantity;
1929             uint256[] memory quantities = new uint256[](length);
1930             for (uint256 i; i != length; ++i) {
1931                 quantities[i] = purchaseQuantity;
1932             }
1933             membershipPassContract.safeBatchMint(purchase.recipient, info.tokenIds, quantities, "");
1934         }
1935     }
1936 }
1937 
1938 interface IMembershipPassContract {
1939     function isFungible(uint256 id) external pure returns (bool);
1940 
1941     function safeMint(
1942         address to,
1943         uint256 id,
1944         uint256 value,
1945         bytes calldata data
1946     ) external;
1947 
1948     function safeBatchMint(
1949         address to,
1950         uint256[] calldata ids,
1951         uint256[] calldata values,
1952         bytes calldata data
1953     ) external;
1954 }