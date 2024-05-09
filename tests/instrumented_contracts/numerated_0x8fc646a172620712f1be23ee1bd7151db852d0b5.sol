1 // SPDX-License-Identifier: MIT
2 // File: contracts/interfaces/IStaking.sol
3 
4 
5 pragma solidity 0.8.18;
6 
7 interface IStaking {
8     function stake(uint256 amount) external;
9 
10     function unstake(uint256 amount) external;
11 
12     function claimReward() external;
13 
14     function earned(address stakeholder) external view returns (uint256);
15 
16     function stakingToken() external view returns (address);
17 
18     function rewardToken() external view returns (address);
19 
20     function rewardAmount() external view returns (uint256);
21 
22     function startTime() external view returns (uint256);
23 
24     function stopTime() external view returns (uint256);
25 
26     function duration() external view returns (uint256);
27 
28     function lockTime() external view returns (uint256);
29 
30     function totalStaked() external view returns (uint256);
31 
32     function totalStakedRatio() external view returns (uint256);
33 
34     function getRewardTokenBalance() external view returns (uint256);
35 
36     function getStakingTokenBalance() external view returns (uint256);
37 }
38 
39 // File: @openzeppelin/contracts/utils/Context.sol
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/security/Pausable.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 
74 /**
75  * @dev Contract module which allows children to implement an emergency stop
76  * mechanism that can be triggered by an authorized account.
77  *
78  * This module is used through inheritance. It will make available the
79  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
80  * the functions of your contract. Note that they will not be pausable by
81  * simply including this module, only once the modifiers are put in place.
82  */
83 abstract contract Pausable is Context {
84     /**
85      * @dev Emitted when the pause is triggered by `account`.
86      */
87     event Paused(address account);
88 
89     /**
90      * @dev Emitted when the pause is lifted by `account`.
91      */
92     event Unpaused(address account);
93 
94     bool private _paused;
95 
96     /**
97      * @dev Initializes the contract in unpaused state.
98      */
99     constructor() {
100         _paused = false;
101     }
102 
103     /**
104      * @dev Returns true if the contract is paused, and false otherwise.
105      */
106     function paused() public view virtual returns (bool) {
107         return _paused;
108     }
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is not paused.
112      *
113      * Requirements:
114      *
115      * - The contract must not be paused.
116      */
117     modifier whenNotPaused() {
118         require(!paused(), "Pausable: paused");
119         _;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is paused.
124      *
125      * Requirements:
126      *
127      * - The contract must be paused.
128      */
129     modifier whenPaused() {
130         require(paused(), "Pausable: not paused");
131         _;
132     }
133 
134     /**
135      * @dev Triggers stopped state.
136      *
137      * Requirements:
138      *
139      * - The contract must not be paused.
140      */
141     function _pause() internal virtual whenNotPaused {
142         _paused = true;
143         emit Paused(_msgSender());
144     }
145 
146     /**
147      * @dev Returns to normal state.
148      *
149      * Requirements:
150      *
151      * - The contract must be paused.
152      */
153     function _unpause() internal virtual whenPaused {
154         _paused = false;
155         emit Unpaused(_msgSender());
156     }
157 }
158 
159 // File: @openzeppelin/contracts/access/Ownable.sol
160 
161 
162 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 /**
168  * @dev Contract module which provides a basic access control mechanism, where
169  * there is an account (an owner) that can be granted exclusive access to
170  * specific functions.
171  *
172  * By default, the owner account will be the one that deploys the contract. This
173  * can later be changed with {transferOwnership}.
174  *
175  * This module is used through inheritance. It will make available the modifier
176  * `onlyOwner`, which can be applied to your functions to restrict their use to
177  * the owner.
178  */
179 abstract contract Ownable is Context {
180     address private _owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     /**
185      * @dev Initializes the contract setting the deployer as the initial owner.
186      */
187     constructor() {
188         _transferOwnership(_msgSender());
189     }
190 
191     /**
192      * @dev Throws if called by any account other than the owner.
193      */
194     modifier onlyOwner() {
195         _checkOwner();
196         _;
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     /**
207      * @dev Throws if the sender is not the owner.
208      */
209     function _checkOwner() internal view virtual {
210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Library for managing
253  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
254  * types.
255  *
256  * Sets have the following properties:
257  *
258  * - Elements are added, removed, and checked for existence in constant time
259  * (O(1)).
260  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
261  *
262  * ```
263  * contract Example {
264  *     // Add the library methods
265  *     using EnumerableSet for EnumerableSet.AddressSet;
266  *
267  *     // Declare a set state variable
268  *     EnumerableSet.AddressSet private mySet;
269  * }
270  * ```
271  *
272  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
273  * and `uint256` (`UintSet`) are supported.
274  *
275  * [WARNING]
276  * ====
277  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
278  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
279  *
280  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
281  * ====
282  */
283 library EnumerableSet {
284     // To implement this library for multiple types with as little code
285     // repetition as possible, we write it in terms of a generic Set type with
286     // bytes32 values.
287     // The Set implementation uses private functions, and user-facing
288     // implementations (such as AddressSet) are just wrappers around the
289     // underlying Set.
290     // This means that we can only create new EnumerableSets for types that fit
291     // in bytes32.
292 
293     struct Set {
294         // Storage of set values
295         bytes32[] _values;
296         // Position of the value in the `values` array, plus 1 because index 0
297         // means a value is not in the set.
298         mapping(bytes32 => uint256) _indexes;
299     }
300 
301     /**
302      * @dev Add a value to a set. O(1).
303      *
304      * Returns true if the value was added to the set, that is if it was not
305      * already present.
306      */
307     function _add(Set storage set, bytes32 value) private returns (bool) {
308         if (!_contains(set, value)) {
309             set._values.push(value);
310             // The value is stored at length-1, but we add 1 to all indexes
311             // and use 0 as a sentinel value
312             set._indexes[value] = set._values.length;
313             return true;
314         } else {
315             return false;
316         }
317     }
318 
319     /**
320      * @dev Removes a value from a set. O(1).
321      *
322      * Returns true if the value was removed from the set, that is if it was
323      * present.
324      */
325     function _remove(Set storage set, bytes32 value) private returns (bool) {
326         // We read and store the value's index to prevent multiple reads from the same storage slot
327         uint256 valueIndex = set._indexes[value];
328 
329         if (valueIndex != 0) {
330             // Equivalent to contains(set, value)
331             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
332             // the array, and then remove the last element (sometimes called as 'swap and pop').
333             // This modifies the order of the array, as noted in {at}.
334 
335             uint256 toDeleteIndex = valueIndex - 1;
336             uint256 lastIndex = set._values.length - 1;
337 
338             if (lastIndex != toDeleteIndex) {
339                 bytes32 lastValue = set._values[lastIndex];
340 
341                 // Move the last value to the index where the value to delete is
342                 set._values[toDeleteIndex] = lastValue;
343                 // Update the index for the moved value
344                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
345             }
346 
347             // Delete the slot where the moved value was stored
348             set._values.pop();
349 
350             // Delete the index for the deleted slot
351             delete set._indexes[value];
352 
353             return true;
354         } else {
355             return false;
356         }
357     }
358 
359     /**
360      * @dev Returns true if the value is in the set. O(1).
361      */
362     function _contains(Set storage set, bytes32 value) private view returns (bool) {
363         return set._indexes[value] != 0;
364     }
365 
366     /**
367      * @dev Returns the number of values on the set. O(1).
368      */
369     function _length(Set storage set) private view returns (uint256) {
370         return set._values.length;
371     }
372 
373     /**
374      * @dev Returns the value stored at position `index` in the set. O(1).
375      *
376      * Note that there are no guarantees on the ordering of values inside the
377      * array, and it may change when more values are added or removed.
378      *
379      * Requirements:
380      *
381      * - `index` must be strictly less than {length}.
382      */
383     function _at(Set storage set, uint256 index) private view returns (bytes32) {
384         return set._values[index];
385     }
386 
387     /**
388      * @dev Return the entire set in an array
389      *
390      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
391      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
392      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
393      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
394      */
395     function _values(Set storage set) private view returns (bytes32[] memory) {
396         return set._values;
397     }
398 
399     // Bytes32Set
400 
401     struct Bytes32Set {
402         Set _inner;
403     }
404 
405     /**
406      * @dev Add a value to a set. O(1).
407      *
408      * Returns true if the value was added to the set, that is if it was not
409      * already present.
410      */
411     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
412         return _add(set._inner, value);
413     }
414 
415     /**
416      * @dev Removes a value from a set. O(1).
417      *
418      * Returns true if the value was removed from the set, that is if it was
419      * present.
420      */
421     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
422         return _remove(set._inner, value);
423     }
424 
425     /**
426      * @dev Returns true if the value is in the set. O(1).
427      */
428     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
429         return _contains(set._inner, value);
430     }
431 
432     /**
433      * @dev Returns the number of values in the set. O(1).
434      */
435     function length(Bytes32Set storage set) internal view returns (uint256) {
436         return _length(set._inner);
437     }
438 
439     /**
440      * @dev Returns the value stored at position `index` in the set. O(1).
441      *
442      * Note that there are no guarantees on the ordering of values inside the
443      * array, and it may change when more values are added or removed.
444      *
445      * Requirements:
446      *
447      * - `index` must be strictly less than {length}.
448      */
449     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
450         return _at(set._inner, index);
451     }
452 
453     /**
454      * @dev Return the entire set in an array
455      *
456      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
457      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
458      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
459      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
460      */
461     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
462         return _values(set._inner);
463     }
464 
465     // AddressSet
466 
467     struct AddressSet {
468         Set _inner;
469     }
470 
471     /**
472      * @dev Add a value to a set. O(1).
473      *
474      * Returns true if the value was added to the set, that is if it was not
475      * already present.
476      */
477     function add(AddressSet storage set, address value) internal returns (bool) {
478         return _add(set._inner, bytes32(uint256(uint160(value))));
479     }
480 
481     /**
482      * @dev Removes a value from a set. O(1).
483      *
484      * Returns true if the value was removed from the set, that is if it was
485      * present.
486      */
487     function remove(AddressSet storage set, address value) internal returns (bool) {
488         return _remove(set._inner, bytes32(uint256(uint160(value))));
489     }
490 
491     /**
492      * @dev Returns true if the value is in the set. O(1).
493      */
494     function contains(AddressSet storage set, address value) internal view returns (bool) {
495         return _contains(set._inner, bytes32(uint256(uint160(value))));
496     }
497 
498     /**
499      * @dev Returns the number of values in the set. O(1).
500      */
501     function length(AddressSet storage set) internal view returns (uint256) {
502         return _length(set._inner);
503     }
504 
505     /**
506      * @dev Returns the value stored at position `index` in the set. O(1).
507      *
508      * Note that there are no guarantees on the ordering of values inside the
509      * array, and it may change when more values are added or removed.
510      *
511      * Requirements:
512      *
513      * - `index` must be strictly less than {length}.
514      */
515     function at(AddressSet storage set, uint256 index) internal view returns (address) {
516         return address(uint160(uint256(_at(set._inner, index))));
517     }
518 
519     /**
520      * @dev Return the entire set in an array
521      *
522      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
523      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
524      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
525      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
526      */
527     function values(AddressSet storage set) internal view returns (address[] memory) {
528         bytes32[] memory store = _values(set._inner);
529         address[] memory result;
530 
531         /// @solidity memory-safe-assembly
532         assembly {
533             result := store
534         }
535 
536         return result;
537     }
538 
539     // UintSet
540 
541     struct UintSet {
542         Set _inner;
543     }
544 
545     /**
546      * @dev Add a value to a set. O(1).
547      *
548      * Returns true if the value was added to the set, that is if it was not
549      * already present.
550      */
551     function add(UintSet storage set, uint256 value) internal returns (bool) {
552         return _add(set._inner, bytes32(value));
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function remove(UintSet storage set, uint256 value) internal returns (bool) {
562         return _remove(set._inner, bytes32(value));
563     }
564 
565     /**
566      * @dev Returns true if the value is in the set. O(1).
567      */
568     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
569         return _contains(set._inner, bytes32(value));
570     }
571 
572     /**
573      * @dev Returns the number of values on the set. O(1).
574      */
575     function length(UintSet storage set) internal view returns (uint256) {
576         return _length(set._inner);
577     }
578 
579     /**
580      * @dev Returns the value stored at position `index` in the set. O(1).
581      *
582      * Note that there are no guarantees on the ordering of values inside the
583      * array, and it may change when more values are added or removed.
584      *
585      * Requirements:
586      *
587      * - `index` must be strictly less than {length}.
588      */
589     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
590         return uint256(_at(set._inner, index));
591     }
592 
593     /**
594      * @dev Return the entire set in an array
595      *
596      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
597      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
598      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
599      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
600      */
601     function values(UintSet storage set) internal view returns (uint256[] memory) {
602         bytes32[] memory store = _values(set._inner);
603         uint256[] memory result;
604 
605         /// @solidity memory-safe-assembly
606         assembly {
607             result := store
608         }
609 
610         return result;
611     }
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
623  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
624  *
625  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
626  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
627  * need to send a transaction, and thus is not required to hold Ether at all.
628  */
629 interface IERC20Permit {
630     /**
631      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
632      * given ``owner``'s signed approval.
633      *
634      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
635      * ordering also apply here.
636      *
637      * Emits an {Approval} event.
638      *
639      * Requirements:
640      *
641      * - `spender` cannot be the zero address.
642      * - `deadline` must be a timestamp in the future.
643      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
644      * over the EIP712-formatted function arguments.
645      * - the signature must use ``owner``'s current nonce (see {nonces}).
646      *
647      * For more information on the signature format, see the
648      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
649      * section].
650      */
651     function permit(
652         address owner,
653         address spender,
654         uint256 value,
655         uint256 deadline,
656         uint8 v,
657         bytes32 r,
658         bytes32 s
659     ) external;
660 
661     /**
662      * @dev Returns the current nonce for `owner`. This value must be
663      * included whenever a signature is generated for {permit}.
664      *
665      * Every successful call to {permit} increases ``owner``'s nonce by one. This
666      * prevents a signature from being used multiple times.
667      */
668     function nonces(address owner) external view returns (uint256);
669 
670     /**
671      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
672      */
673     // solhint-disable-next-line func-name-mixedcase
674     function DOMAIN_SEPARATOR() external view returns (bytes32);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Interface of the ERC20 standard as defined in the EIP.
686  */
687 interface IERC20 {
688     /**
689      * @dev Returns the amount of tokens in existence.
690      */
691     function totalSupply() external view returns (uint256);
692 
693     /**
694      * @dev Returns the amount of tokens owned by `account`.
695      */
696     function balanceOf(address account) external view returns (uint256);
697 
698     /**
699      * @dev Moves `amount` tokens from the caller's account to `recipient`.
700      *
701      * Returns a boolean value indicating whether the operation succeeded.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transfer(address recipient, uint256 amount) external returns (bool);
706 
707     /**
708      * @dev Returns the remaining number of tokens that `spender` will be
709      * allowed to spend on behalf of `owner` through {transferFrom}. This is
710      * zero by default.
711      *
712      * This value changes when {approve} or {transferFrom} are called.
713      */
714     function allowance(address owner, address spender) external view returns (uint256);
715 
716     /**
717      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
718      *
719      * Returns a boolean value indicating whether the operation succeeded.
720      *
721      * IMPORTANT: Beware that changing an allowance with this method brings the risk
722      * that someone may use both the old and the new allowance by unfortunate
723      * transaction ordering. One possible solution to mitigate this race
724      * condition is to first reduce the spender's allowance to 0 and set the
725      * desired value afterwards:
726      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
727      *
728      * Emits an {Approval} event.
729      */
730     function approve(address spender, uint256 amount) external returns (bool);
731 
732     /**
733      * @dev Moves `amount` tokens from `sender` to `recipient` using the
734      * allowance mechanism. `amount` is then deducted from the caller's
735      * allowance.
736      *
737      * Returns a boolean value indicating whether the operation succeeded.
738      *
739      * Emits a {Transfer} event.
740      */
741     function transferFrom(
742         address sender,
743         address recipient,
744         uint256 amount
745     ) external returns (bool);
746 
747     /**
748      * @dev Emitted when `value` tokens are moved from one account (`from`) to
749      * another (`to`).
750      *
751      * Note that `value` may be zero.
752      */
753     event Transfer(address indexed from, address indexed to, uint256 value);
754 
755     /**
756      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
757      * a call to {approve}. `value` is the new allowance.
758      */
759     event Approval(address indexed owner, address indexed spender, uint256 value);
760 }
761 
762 // File: @openzeppelin/contracts/utils/Address.sol
763 
764 
765 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
766 
767 pragma solidity ^0.8.1;
768 
769 /**
770  * @dev Collection of functions related to the address type
771  */
772 library Address {
773     /**
774      * @dev Returns true if `account` is a contract.
775      *
776      * [IMPORTANT]
777      * ====
778      * It is unsafe to assume that an address for which this function returns
779      * false is an externally-owned account (EOA) and not a contract.
780      *
781      * Among others, `isContract` will return false for the following
782      * types of addresses:
783      *
784      *  - an externally-owned account
785      *  - a contract in construction
786      *  - an address where a contract will be created
787      *  - an address where a contract lived, but was destroyed
788      * ====
789      *
790      * [IMPORTANT]
791      * ====
792      * You shouldn't rely on `isContract` to protect against flash loan attacks!
793      *
794      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
795      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
796      * constructor.
797      * ====
798      */
799     function isContract(address account) internal view returns (bool) {
800         // This method relies on extcodesize/address.code.length, which returns 0
801         // for contracts in construction, since the code is only stored at the end
802         // of the constructor execution.
803 
804         return account.code.length > 0;
805     }
806 
807     /**
808      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
809      * `recipient`, forwarding all available gas and reverting on errors.
810      *
811      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
812      * of certain opcodes, possibly making contracts go over the 2300 gas limit
813      * imposed by `transfer`, making them unable to receive funds via
814      * `transfer`. {sendValue} removes this limitation.
815      *
816      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
817      *
818      * IMPORTANT: because control is transferred to `recipient`, care must be
819      * taken to not create reentrancy vulnerabilities. Consider using
820      * {ReentrancyGuard} or the
821      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
822      */
823     function sendValue(address payable recipient, uint256 amount) internal {
824         require(address(this).balance >= amount, "Address: insufficient balance");
825 
826         (bool success, ) = recipient.call{value: amount}("");
827         require(success, "Address: unable to send value, recipient may have reverted");
828     }
829 
830     /**
831      * @dev Performs a Solidity function call using a low level `call`. A
832      * plain `call` is an unsafe replacement for a function call: use this
833      * function instead.
834      *
835      * If `target` reverts with a revert reason, it is bubbled up by this
836      * function (like regular Solidity function calls).
837      *
838      * Returns the raw returned data. To convert to the expected return value,
839      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
840      *
841      * Requirements:
842      *
843      * - `target` must be a contract.
844      * - calling `target` with `data` must not revert.
845      *
846      * _Available since v3.1._
847      */
848     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
849         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
854      * `errorMessage` as a fallback revert reason when `target` reverts.
855      *
856      * _Available since v3.1._
857      */
858     function functionCall(
859         address target,
860         bytes memory data,
861         string memory errorMessage
862     ) internal returns (bytes memory) {
863         return functionCallWithValue(target, data, 0, errorMessage);
864     }
865 
866     /**
867      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
868      * but also transferring `value` wei to `target`.
869      *
870      * Requirements:
871      *
872      * - the calling contract must have an ETH balance of at least `value`.
873      * - the called Solidity function must be `payable`.
874      *
875      * _Available since v3.1._
876      */
877     function functionCallWithValue(
878         address target,
879         bytes memory data,
880         uint256 value
881     ) internal returns (bytes memory) {
882         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
883     }
884 
885     /**
886      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
887      * with `errorMessage` as a fallback revert reason when `target` reverts.
888      *
889      * _Available since v3.1._
890      */
891     function functionCallWithValue(
892         address target,
893         bytes memory data,
894         uint256 value,
895         string memory errorMessage
896     ) internal returns (bytes memory) {
897         require(address(this).balance >= value, "Address: insufficient balance for call");
898         (bool success, bytes memory returndata) = target.call{value: value}(data);
899         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
900     }
901 
902     /**
903      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
904      * but performing a static call.
905      *
906      * _Available since v3.3._
907      */
908     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
909         return functionStaticCall(target, data, "Address: low-level static call failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
914      * but performing a static call.
915      *
916      * _Available since v3.3._
917      */
918     function functionStaticCall(
919         address target,
920         bytes memory data,
921         string memory errorMessage
922     ) internal view returns (bytes memory) {
923         (bool success, bytes memory returndata) = target.staticcall(data);
924         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
925     }
926 
927     /**
928      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
929      * but performing a delegate call.
930      *
931      * _Available since v3.4._
932      */
933     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
934         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
935     }
936 
937     /**
938      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
939      * but performing a delegate call.
940      *
941      * _Available since v3.4._
942      */
943     function functionDelegateCall(
944         address target,
945         bytes memory data,
946         string memory errorMessage
947     ) internal returns (bytes memory) {
948         (bool success, bytes memory returndata) = target.delegatecall(data);
949         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
950     }
951 
952     /**
953      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
954      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
955      *
956      * _Available since v4.8._
957      */
958     function verifyCallResultFromTarget(
959         address target,
960         bool success,
961         bytes memory returndata,
962         string memory errorMessage
963     ) internal view returns (bytes memory) {
964         if (success) {
965             if (returndata.length == 0) {
966                 // only check isContract if the call was successful and the return data is empty
967                 // otherwise we already know that it was a contract
968                 require(isContract(target), "Address: call to non-contract");
969             }
970             return returndata;
971         } else {
972             _revert(returndata, errorMessage);
973         }
974     }
975 
976     /**
977      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
978      * revert reason or using the provided one.
979      *
980      * _Available since v4.3._
981      */
982     function verifyCallResult(
983         bool success,
984         bytes memory returndata,
985         string memory errorMessage
986     ) internal pure returns (bytes memory) {
987         if (success) {
988             return returndata;
989         } else {
990             _revert(returndata, errorMessage);
991         }
992     }
993 
994     function _revert(bytes memory returndata, string memory errorMessage) private pure {
995         // Look for revert reason and bubble it up if present
996         if (returndata.length > 0) {
997             // The easiest way to bubble the revert reason is using memory via assembly
998             /// @solidity memory-safe-assembly
999             assembly {
1000                 let returndata_size := mload(returndata)
1001                 revert(add(32, returndata), returndata_size)
1002             }
1003         } else {
1004             revert(errorMessage);
1005         }
1006     }
1007 }
1008 
1009 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1010 
1011 
1012 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 
1017 
1018 
1019 /**
1020  * @title SafeERC20
1021  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1022  * contract returns false). Tokens that return no value (and instead revert or
1023  * throw on failure) are also supported, non-reverting calls are assumed to be
1024  * successful.
1025  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1026  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1027  */
1028 library SafeERC20 {
1029     using Address for address;
1030 
1031     function safeTransfer(
1032         IERC20 token,
1033         address to,
1034         uint256 value
1035     ) internal {
1036         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1037     }
1038 
1039     function safeTransferFrom(
1040         IERC20 token,
1041         address from,
1042         address to,
1043         uint256 value
1044     ) internal {
1045         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1046     }
1047 
1048     /**
1049      * @dev Deprecated. This function has issues similar to the ones found in
1050      * {IERC20-approve}, and its usage is discouraged.
1051      *
1052      * Whenever possible, use {safeIncreaseAllowance} and
1053      * {safeDecreaseAllowance} instead.
1054      */
1055     function safeApprove(
1056         IERC20 token,
1057         address spender,
1058         uint256 value
1059     ) internal {
1060         // safeApprove should only be called when setting an initial allowance,
1061         // or when resetting it to zero. To increase and decrease it, use
1062         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1063         require(
1064             (value == 0) || (token.allowance(address(this), spender) == 0),
1065             "SafeERC20: approve from non-zero to non-zero allowance"
1066         );
1067         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1068     }
1069 
1070     function safeIncreaseAllowance(
1071         IERC20 token,
1072         address spender,
1073         uint256 value
1074     ) internal {
1075         uint256 newAllowance = token.allowance(address(this), spender) + value;
1076         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1077     }
1078 
1079     function safeDecreaseAllowance(
1080         IERC20 token,
1081         address spender,
1082         uint256 value
1083     ) internal {
1084         unchecked {
1085             uint256 oldAllowance = token.allowance(address(this), spender);
1086             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1087             uint256 newAllowance = oldAllowance - value;
1088             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1089         }
1090     }
1091 
1092     function safePermit(
1093         IERC20Permit token,
1094         address owner,
1095         address spender,
1096         uint256 value,
1097         uint256 deadline,
1098         uint8 v,
1099         bytes32 r,
1100         bytes32 s
1101     ) internal {
1102         uint256 nonceBefore = token.nonces(owner);
1103         token.permit(owner, spender, value, deadline, v, r, s);
1104         uint256 nonceAfter = token.nonces(owner);
1105         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1106     }
1107 
1108     /**
1109      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1110      * on the return value: the return value is optional (but if data is returned, it must not be false).
1111      * @param token The token targeted by the call.
1112      * @param data The call data (encoded using abi.encode or one of its variants).
1113      */
1114     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1115         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1116         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1117         // the target address contains contract code and also asserts for success in the low-level call.
1118 
1119         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1120         if (returndata.length > 0) {
1121             // Return data is optional
1122             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1123         }
1124     }
1125 }
1126 
1127 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 /**
1135  * @dev Contract module that helps prevent reentrant calls to a function.
1136  *
1137  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1138  * available, which can be applied to functions to make sure there are no nested
1139  * (reentrant) calls to them.
1140  *
1141  * Note that because there is a single `nonReentrant` guard, functions marked as
1142  * `nonReentrant` may not call one another. This can be worked around by making
1143  * those functions `private`, and then adding `external` `nonReentrant` entry
1144  * points to them.
1145  *
1146  * TIP: If you would like to learn more about reentrancy and alternative ways
1147  * to protect against it, check out our blog post
1148  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1149  */
1150 abstract contract ReentrancyGuard {
1151     // Booleans are more expensive than uint256 or any type that takes up a full
1152     // word because each write operation emits an extra SLOAD to first read the
1153     // slot's contents, replace the bits taken up by the boolean, and then write
1154     // back. This is the compiler's defense against contract upgrades and
1155     // pointer aliasing, and it cannot be disabled.
1156 
1157     // The values being non-zero value makes deployment a bit more expensive,
1158     // but in exchange the refund on every call to nonReentrant will be lower in
1159     // amount. Since refunds are capped to a percentage of the total
1160     // transaction's gas, it is best to keep them low in cases like this one, to
1161     // increase the likelihood of the full refund coming into effect.
1162     uint256 private constant _NOT_ENTERED = 1;
1163     uint256 private constant _ENTERED = 2;
1164 
1165     uint256 private _status;
1166 
1167     constructor() {
1168         _status = _NOT_ENTERED;
1169     }
1170 
1171     /**
1172      * @dev Prevents a contract from calling itself, directly or indirectly.
1173      * Calling a `nonReentrant` function from another `nonReentrant`
1174      * function is not supported. It is possible to prevent this from happening
1175      * by making the `nonReentrant` function external, and making it call a
1176      * `private` function that does the actual work.
1177      */
1178     modifier nonReentrant() {
1179         // On the first call to nonReentrant, _notEntered will be true
1180         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1181 
1182         // Any calls to nonReentrant after this point will fail
1183         _status = _ENTERED;
1184 
1185         _;
1186 
1187         // By storing the original value once again, a refund is triggered (see
1188         // https://eips.ethereum.org/EIPS/eip-2200)
1189         _status = _NOT_ENTERED;
1190     }
1191 }
1192 
1193 // File: contracts/AlphaStaking.sol
1194 
1195 
1196 pragma solidity ^0.8.18;
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 
1206 contract AlphaStaking is Ownable, Pausable, ReentrancyGuard {
1207     using SafeERC20 for IERC20;
1208     using Address for address;
1209 
1210     struct Stakeholder {
1211         uint256 staked; // amount of staked tokens
1212         uint256 timestamp;
1213         uint256 earnedRewards;
1214         uint256 rewardDebt;
1215         uint256 totalRewardsClaimed;
1216     }
1217 
1218     struct Pool {
1219         address stakingToken;
1220         address rewardToken;
1221         uint256 rewardAmount;
1222         uint256 startTime;
1223         uint256 stopTime;
1224         uint256 duration;
1225         uint256 lockTime;
1226         uint256 totalStaked;
1227         uint256 rewardPerSecond;
1228         uint256 accRewardPerShare;
1229         uint256 lastRewardTimestamp;
1230         mapping(address => Stakeholder) stakeholders;
1231     }
1232 
1233     Pool[] Pools;
1234     
1235     uint256 private constant REWARDS_PRECISION = 1e12;
1236 
1237     event Staked(address indexed staker, uint256 amount, uint256 poolId);
1238     event Withdraw(address indexed staker, uint256 rewardAmount, uint256 poolId);
1239     event Recover(address indexed token, uint256 amount);
1240 
1241     constructor(
1242     ) {
1243     }
1244 
1245     function loadReward(uint256 _poolId) external onlyOwner {
1246         Pool storage pool = Pools[_poolId];
1247         IERC20(pool.rewardToken).safeTransferFrom(msg.sender, address(this), pool.rewardAmount);
1248 
1249     }
1250 
1251     function recoverTokens(IERC20 _token) external onlyOwner {
1252         uint256 balance = _token.balanceOf(address(this));
1253         _token.transfer(owner(), balance);
1254         emit Recover(address(_token), balance);
1255     }
1256 
1257     function pause() external onlyOwner {
1258         _pause();
1259     }
1260 
1261     function unpause() external onlyOwner {
1262         _unpause();
1263     }
1264 
1265     function addPool(address _stakingToken,
1266         address _rewardToken,
1267         uint256 _rewardAmount,
1268         uint256 _startTime,
1269         uint256 _stopTime,
1270         uint256 _lockTime) external onlyOwner
1271     {
1272         require(_stakingToken.isContract(), "Staking: stakingToken not a contract address");
1273         require(_rewardToken.isContract(), "Staking: rewardToken not a contract address");
1274         require(_rewardAmount > 0, "Staking: rewardAmount must be greater than zero");
1275         require(_startTime > block.timestamp && _startTime < _stopTime, "Staking: incorrect timestamps");
1276         require(_lockTime > 0, "Staking: lockTime must be greater than zero");
1277 
1278         Pool storage newPool = Pools.push();
1279 
1280         newPool.stakingToken = _stakingToken;
1281         newPool.rewardToken = _rewardToken;
1282         newPool.rewardAmount = _rewardAmount;
1283         newPool.startTime = _startTime;
1284         newPool.stopTime = _stopTime;
1285         newPool.duration = _stopTime - _startTime;
1286         newPool.lockTime = _lockTime;
1287         newPool.rewardPerSecond = _rewardAmount / (_stopTime - _startTime);
1288         newPool.lastRewardTimestamp = _startTime;
1289         newPool.accRewardPerShare = 0;
1290     }
1291 
1292     function stake(uint256 _amount, uint256 _poolId) external whenNotPaused {
1293         updatePoolRewards(_poolId);
1294         Pool storage pool = Pools[_poolId];
1295         
1296         require(block.timestamp >= pool.startTime, "Staking: staking not started");
1297         require(block.timestamp <= pool.stopTime, "Staking: staking period over");
1298         require(_amount > 0, "Staking: amount can't be 0");
1299 
1300         Stakeholder storage stakeholder = pool.stakeholders[msg.sender];
1301         stakeholder.staked += _amount;
1302         stakeholder.rewardDebt = stakeholder.staked * pool.accRewardPerShare / REWARDS_PRECISION;
1303 
1304         stakeholder.timestamp = block.timestamp;
1305 
1306         pool.totalStaked += _amount;
1307 
1308         IERC20(pool.stakingToken).safeTransferFrom(msg.sender, address(this), _amount);
1309 
1310         emit Staked(msg.sender, _amount, _poolId);
1311     }
1312 
1313     function unstake(uint256 _amount, uint256 _poolId) external whenNotPaused nonReentrant{
1314         updatePoolRewards(_poolId);
1315         Pool storage pool = Pools[_poolId];
1316 
1317         require(_amount > 0, "_amount have to be bigger than 0");
1318         Stakeholder storage stakeholder = pool.stakeholders[msg.sender];
1319         require(stakeholder.staked > 0, "Staking: you have not participated in staking");
1320         require(stakeholder.staked >= _amount, "Staking: cannot unstake more than your balance");
1321         uint256 accumulatedReward = stakeholder.staked * pool.accRewardPerShare / REWARDS_PRECISION;
1322         uint256 pendingReward = accumulatedReward - stakeholder.rewardDebt;
1323 
1324         stakeholder.rewardDebt = accumulatedReward - (_amount * pool.accRewardPerShare / REWARDS_PRECISION);
1325         stakeholder.staked -= _amount;
1326         
1327         pool.totalStaked -= _amount;
1328         _withdrawReward(msg.sender, _poolId, pendingReward);
1329         _withdrawStaked(msg.sender, _amount, pool.stakingToken);
1330     }
1331 
1332     function claimRewards(uint256 _poolId) external whenNotPaused nonReentrant {
1333         updatePoolRewards(_poolId);
1334         Pool storage pool = Pools[_poolId];
1335         Stakeholder storage stakeholder = pool.stakeholders[msg.sender];
1336         uint256 rewardsToHarvest = (stakeholder.staked * pool.accRewardPerShare / REWARDS_PRECISION) - stakeholder.rewardDebt;
1337         if (rewardsToHarvest == 0) {
1338             stakeholder.rewardDebt = stakeholder.staked * pool.accRewardPerShare / REWARDS_PRECISION;
1339             return;
1340         }
1341         stakeholder.rewardDebt = stakeholder.staked * pool.accRewardPerShare / REWARDS_PRECISION;
1342         _withdrawReward(msg.sender, _poolId, rewardsToHarvest);
1343     }
1344 
1345 
1346     function updatePoolRewards(uint256 pid) public {
1347         Pool storage pool = Pools[pid];
1348         if (block.timestamp > pool.lastRewardTimestamp) {
1349             uint256 lpSupply = pool.totalStaked;
1350             if (lpSupply > 0) {
1351                 uint256 timestamps = block.timestamp - pool.lastRewardTimestamp;
1352                 uint256 rewards = timestamps * pool.rewardPerSecond;
1353                 pool.accRewardPerShare = pool.accRewardPerShare + (rewards * REWARDS_PRECISION / pool.totalStaked);
1354             }
1355             pool.lastRewardTimestamp = block.timestamp;
1356         }
1357     }
1358     
1359 
1360     function earned(address _stakeholder, uint256 _poolId) public view returns (uint256) {
1361         Pool storage pool = Pools[_poolId];
1362         Stakeholder memory stakeholder = pool.stakeholders[_stakeholder];
1363         if ( stakeholder.staked == 0) return 0;
1364 
1365         uint256 accRewardPerShare = pool.accRewardPerShare;
1366         uint256 lpSupply = pool.totalStaked;
1367         if (block.timestamp > pool.lastRewardTimestamp && lpSupply != 0) {
1368             uint256 timestampSinceLastReward = block.timestamp - pool.lastRewardTimestamp;
1369             uint256 rewards = timestampSinceLastReward * pool.rewardPerSecond;
1370             accRewardPerShare = accRewardPerShare + ((rewards * REWARDS_PRECISION) / lpSupply);
1371         }
1372         uint256 pending = (stakeholder.staked * accRewardPerShare) / REWARDS_PRECISION - stakeholder.rewardDebt;
1373 
1374         return pending;
1375     }
1376 
1377     function getStartTime(uint256 _poolId) external view returns (uint256) {
1378         Pool storage pool = Pools[_poolId];
1379         return pool.startTime;
1380     }
1381 
1382     function getStopTime(uint256 _poolId) external view returns (uint256) {
1383         Pool storage pool = Pools[_poolId];
1384         return pool.stopTime;
1385     }
1386 
1387     function getLockTime(uint256 _poolId) external view returns (uint256) {
1388         Pool storage pool = Pools[_poolId];
1389         return pool.lockTime;
1390     }
1391 
1392     function getDuration(uint256 _poolId) external view returns (uint256) {
1393         Pool storage pool = Pools[_poolId];
1394         return pool.duration;
1395     }
1396 
1397     function getTotalStaked(uint256 _poolId) external view returns (uint256) {
1398         Pool storage pool = Pools[_poolId];
1399         return pool.totalStaked;
1400     }
1401 
1402     function getRewardTokenBalance(uint256 _poolId) external view returns (uint256) {
1403         Pool storage pool = Pools[_poolId];
1404         return IERC20(pool.rewardToken).balanceOf(address(this));
1405     }
1406 
1407     function getStakingTokenBalance(uint256 _poolId) external view returns (uint256) {
1408         Pool storage pool = Pools[_poolId];
1409         return IERC20(pool.stakingToken).balanceOf(address(this));
1410     }
1411 
1412     function getStakingTokenBalancebyAddress(uint256 _poolId, address _userAddress) external view returns (uint256) {
1413         Pool storage pool = Pools[_poolId];
1414         Stakeholder memory stakeholder = pool.stakeholders[_userAddress];
1415         return stakeholder.staked;
1416     }
1417 
1418     function getTimeRemaining(uint256 _poolId) public view returns (uint256) {
1419         Pool storage pool = Pools[_poolId];
1420         uint256 timeRemaining = block.timestamp <= pool.stopTime
1421             ? block.timestamp >= pool.startTime ? pool.stopTime - block.timestamp : pool.duration
1422             : 0;
1423         return timeRemaining;
1424     }
1425 
1426     function getTimeElapsed(uint256 _poolId) external view returns (uint256) {
1427         Pool storage pool = Pools[_poolId];
1428         uint256 timeElapsed = block.timestamp >= pool.startTime
1429             ? block.timestamp <= pool.stopTime ? block.timestamp - pool.startTime : pool.duration
1430             : 0;
1431         return timeElapsed;
1432     }
1433 
1434     function getStaked(address _stakeholder, uint256 _poolId) external view returns (uint256) {
1435         Pool storage pool = Pools[_poolId];
1436         return pool.stakeholders[_stakeholder].staked;
1437     }
1438 
1439     function getStakedLock(address _stakeholder, uint256 _poolId) external view returns (uint256) {
1440         Pool storage pool = Pools[_poolId];
1441         return pool.stakeholders[_stakeholder].timestamp;
1442     }
1443 
1444     function getRewardShare(uint256 _poolId) external view returns (uint256) {
1445         Pool storage pool = Pools[_poolId];
1446         return pool.accRewardPerShare;
1447     }
1448 
1449     function getRewardperSecond(uint256 _poolId) external view returns (uint256) {
1450         Pool storage pool = Pools[_poolId];
1451         return pool.rewardPerSecond;
1452     }
1453 
1454     function getLastReward(uint256 _poolId) external view returns (uint256) {
1455         Pool storage pool = Pools[_poolId];
1456         return pool.lastRewardTimestamp;
1457     }
1458 
1459     function getTotalRewardsClaimed(address _stakeholder, uint256 _poolId) external view returns (uint256) {
1460         Pool storage pool = Pools[_poolId];
1461         return pool.stakeholders[_stakeholder].totalRewardsClaimed;
1462     }
1463 
1464     function _withdrawStaked(address _to, uint256 _amount, address _stakingToken) internal {
1465         IERC20(_stakingToken).safeTransfer(_to, _amount);
1466     }
1467 
1468     function _withdrawReward(address _to, uint256 _poolId, uint256 _reward) internal {
1469         Pool storage pool = Pools[_poolId];
1470         IERC20(pool.rewardToken).safeTransfer(_to, _reward);
1471         pool.stakeholders[_to].totalRewardsClaimed += _reward;
1472 
1473         emit Withdraw(msg.sender, _reward, _poolId);
1474     }
1475 }