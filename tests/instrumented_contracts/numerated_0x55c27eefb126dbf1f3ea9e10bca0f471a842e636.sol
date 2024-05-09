1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @animoca/ethereum-contracts-erc20_base-4.0.0/contracts/token/ERC20/IERC20.sol@v4.0.0
4 
5 /*
6 https://github.com/OpenZeppelin/openzeppelin-contracts
7 
8 The MIT License (MIT)
9 
10 Copyright (c) 2016-2019 zOS Global Limited
11 
12 Permission is hereby granted, free of charge, to any person obtaining
13 a copy of this software and associated documentation files (the
14 "Software"), to deal in the Software without restriction, including
15 without limitation the rights to use, copy, modify, merge, publish,
16 distribute, sublicense, and/or sell copies of the Software, and to
17 permit persons to whom the Software is furnished to do so, subject to
18 the following conditions:
19 
20 The above copyright notice and this permission notice shall be included
21 in all copies or substantial portions of the Software.
22 
23 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
24 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
25 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
26 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
27 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
28 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
29 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
30 */
31 
32 // SPDX-License-Identifier: MIT
33 
34 pragma solidity 0.6.8;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Emitted when `value` tokens are moved from one account (`from`) to
42      * another (`to`).
43      *
44      * Note that `value` may be zero.
45      */
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47 
48     /**
49      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
50      * a call to {approve}. `value` is the new allowance.
51      */
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `recipient`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `sender` to `recipient` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address sender,
109         address recipient,
110         uint256 amount
111     ) external returns (bool);
112 }
113 
114 
115 // File @animoca/ethereum-contracts-core_library-5.0.0/contracts/algo/EnumMap.sol@v5.0.0
116 
117 /*
118 https://github.com/OpenZeppelin/openzeppelin-contracts
119 
120 The MIT License (MIT)
121 
122 Copyright (c) 2016-2019 zOS Global Limited
123 
124 Permission is hereby granted, free of charge, to any person obtaining
125 a copy of this software and associated documentation files (the
126 "Software"), to deal in the Software without restriction, including
127 without limitation the rights to use, copy, modify, merge, publish,
128 distribute, sublicense, and/or sell copies of the Software, and to
129 permit persons to whom the Software is furnished to do so, subject to
130 the following conditions:
131 
132 The above copyright notice and this permission notice shall be included
133 in all copies or substantial portions of the Software.
134 
135 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
136 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
137 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
138 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
139 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
140 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
141 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
142 */
143 
144 pragma solidity 0.6.8;
145 
146 /**
147  * @dev Library for managing an enumerable variant of Solidity's
148  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
149  * type.
150  *
151  * Maps have the following properties:
152  *
153  * - Entries are added, removed, and checked for existence in constant time
154  * (O(1)).
155  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
156  *
157  * ```
158  * contract Example {
159  *     // Add the library methods
160  *     using EnumMap for EnumMap.Map;
161  *
162  *     // Declare a set state variable
163  *     EnumMap.Map private myMap;
164  * }
165  * ```
166  */
167 library EnumMap {
168     // To implement this library for multiple types with as little code
169     // repetition as possible, we write it in terms of a generic Map type with
170     // bytes32 keys and values.
171     // This means that we can only create new EnumMaps for types that fit
172     // in bytes32.
173 
174     struct MapEntry {
175         bytes32 key;
176         bytes32 value;
177     }
178 
179     struct Map {
180         // Storage of map keys and values
181         MapEntry[] entries;
182         // Position of the entry defined by a key in the `entries` array, plus 1
183         // because index 0 means a key is not in the map.
184         mapping(bytes32 => uint256) indexes;
185     }
186 
187     /**
188      * @dev Adds a key-value pair to a map, or updates the value for an existing
189      * key. O(1).
190      *
191      * Returns true if the key was added to the map, that is if it was not
192      * already present.
193      */
194     function set(
195         Map storage map,
196         bytes32 key,
197         bytes32 value
198     ) internal returns (bool) {
199         // We read and store the key's index to prevent multiple reads from the same storage slot
200         uint256 keyIndex = map.indexes[key];
201 
202         if (keyIndex == 0) {
203             // Equivalent to !contains(map, key)
204             map.entries.push(MapEntry({key: key, value: value}));
205             // The entry is stored at length-1, but we add 1 to all indexes
206             // and use 0 as a sentinel value
207             map.indexes[key] = map.entries.length;
208             return true;
209         } else {
210             map.entries[keyIndex - 1].value = value;
211             return false;
212         }
213     }
214 
215     /**
216      * @dev Removes a key-value pair from a map. O(1).
217      *
218      * Returns true if the key was removed from the map, that is if it was present.
219      */
220     function remove(Map storage map, bytes32 key) internal returns (bool) {
221         // We read and store the key's index to prevent multiple reads from the same storage slot
222         uint256 keyIndex = map.indexes[key];
223 
224         if (keyIndex != 0) {
225             // Equivalent to contains(map, key)
226             // To delete a key-value pair from the entries array in O(1), we swap the entry to delete with the last one
227             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
228             // This modifies the order of the array, as noted in {at}.
229 
230             uint256 toDeleteIndex = keyIndex - 1;
231             uint256 lastIndex = map.entries.length - 1;
232 
233             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
234             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
235 
236             MapEntry storage lastEntry = map.entries[lastIndex];
237 
238             // Move the last entry to the index where the entry to delete is
239             map.entries[toDeleteIndex] = lastEntry;
240             // Update the index for the moved entry
241             map.indexes[lastEntry.key] = toDeleteIndex + 1; // All indexes are 1-based
242 
243             // Delete the slot where the moved entry was stored
244             map.entries.pop();
245 
246             // Delete the index for the deleted slot
247             delete map.indexes[key];
248 
249             return true;
250         } else {
251             return false;
252         }
253     }
254 
255     /**
256      * @dev Returns true if the key is in the map. O(1).
257      */
258     function contains(Map storage map, bytes32 key) internal view returns (bool) {
259         return map.indexes[key] != 0;
260     }
261 
262     /**
263      * @dev Returns the number of key-value pairs in the map. O(1).
264      */
265     function length(Map storage map) internal view returns (uint256) {
266         return map.entries.length;
267     }
268 
269     /**
270      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
271      *
272      * Note that there are no guarantees on the ordering of entries inside the
273      * array, and it may change when more entries are added or removed.
274      *
275      * Requirements:
276      *
277      * - `index` must be strictly less than {length}.
278      */
279     function at(Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
280         require(map.entries.length > index, "EnumMap: index out of bounds");
281 
282         MapEntry storage entry = map.entries[index];
283         return (entry.key, entry.value);
284     }
285 
286     /**
287      * @dev Returns the value associated with `key`.  O(1).
288      *
289      * Requirements:
290      *
291      * - `key` must be in the map.
292      */
293     function get(Map storage map, bytes32 key) internal view returns (bytes32) {
294         uint256 keyIndex = map.indexes[key];
295         require(keyIndex != 0, "EnumMap: nonexistent key"); // Equivalent to contains(map, key)
296         return map.entries[keyIndex - 1].value; // All indexes are 1-based
297     }
298 }
299 
300 
301 // File @animoca/ethereum-contracts-core_library-5.0.0/contracts/algo/EnumSet.sol@v5.0.0
302 
303 /*
304 https://github.com/OpenZeppelin/openzeppelin-contracts
305 
306 The MIT License (MIT)
307 
308 Copyright (c) 2016-2019 zOS Global Limited
309 
310 Permission is hereby granted, free of charge, to any person obtaining
311 a copy of this software and associated documentation files (the
312 "Software"), to deal in the Software without restriction, including
313 without limitation the rights to use, copy, modify, merge, publish,
314 distribute, sublicense, and/or sell copies of the Software, and to
315 permit persons to whom the Software is furnished to do so, subject to
316 the following conditions:
317 
318 The above copyright notice and this permission notice shall be included
319 in all copies or substantial portions of the Software.
320 
321 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
322 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
323 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
324 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
325 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
326 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
327 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
328 */
329 
330 pragma solidity 0.6.8;
331 
332 /**
333  * @dev Library for managing
334  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
335  * types.
336  *
337  * Sets have the following properties:
338  *
339  * - Elements are added, removed, and checked for existence in constant time
340  * (O(1)).
341  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
342  *
343  * ```
344  * contract Example {
345  *     // Add the library methods
346  *     using EnumSet for EnumSet.Set;
347  *
348  *     // Declare a set state variable
349  *     EnumSet.Set private mySet;
350  * }
351  * ```
352  */
353 library EnumSet {
354     // To implement this library for multiple types with as little code
355     // repetition as possible, we write it in terms of a generic Set type with
356     // bytes32 values.
357     // This means that we can only create new EnumerableSets for types that fit
358     // in bytes32.
359 
360     struct Set {
361         // Storage of set values
362         bytes32[] values;
363         // Position of the value in the `values` array, plus 1 because index 0
364         // means a value is not in the set.
365         mapping(bytes32 => uint256) indexes;
366     }
367 
368     /**
369      * @dev Add a value to a set. O(1).
370      *
371      * Returns true if the value was added to the set, that is if it was not
372      * already present.
373      */
374     function add(Set storage set, bytes32 value) internal returns (bool) {
375         if (!contains(set, value)) {
376             set.values.push(value);
377             // The value is stored at length-1, but we add 1 to all indexes
378             // and use 0 as a sentinel value
379             set.indexes[value] = set.values.length;
380             return true;
381         } else {
382             return false;
383         }
384     }
385 
386     /**
387      * @dev Removes a value from a set. O(1).
388      *
389      * Returns true if the value was removed from the set, that is if it was
390      * present.
391      */
392     function remove(Set storage set, bytes32 value) internal returns (bool) {
393         // We read and store the value's index to prevent multiple reads from the same storage slot
394         uint256 valueIndex = set.indexes[value];
395 
396         if (valueIndex != 0) {
397             // Equivalent to contains(set, value)
398             // To delete an element from the values array in O(1), we swap the element to delete with the last one in
399             // the array, and then remove the last element (sometimes called as 'swap and pop').
400             // This modifies the order of the array, as noted in {at}.
401 
402             uint256 toDeleteIndex = valueIndex - 1;
403             uint256 lastIndex = set.values.length - 1;
404 
405             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
406             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
407 
408             bytes32 lastvalue = set.values[lastIndex];
409 
410             // Move the last value to the index where the value to delete is
411             set.values[toDeleteIndex] = lastvalue;
412             // Update the index for the moved value
413             set.indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
414 
415             // Delete the slot where the moved value was stored
416             set.values.pop();
417 
418             // Delete the index for the deleted slot
419             delete set.indexes[value];
420 
421             return true;
422         } else {
423             return false;
424         }
425     }
426 
427     /**
428      * @dev Returns true if the value is in the set. O(1).
429      */
430     function contains(Set storage set, bytes32 value) internal view returns (bool) {
431         return set.indexes[value] != 0;
432     }
433 
434     /**
435      * @dev Returns the number of values on the set. O(1).
436      */
437     function length(Set storage set) internal view returns (uint256) {
438         return set.values.length;
439     }
440 
441     /**
442      * @dev Returns the value stored at position `index` in the set. O(1).
443      *
444      * Note that there are no guarantees on the ordering of values inside the
445      * array, and it may change when more values are added or removed.
446      *
447      * Requirements:
448      *
449      * - `index` must be strictly less than {length}.
450      */
451     function at(Set storage set, uint256 index) internal view returns (bytes32) {
452         require(set.values.length > index, "EnumSet: index out of bounds");
453         return set.values[index];
454     }
455 }
456 
457 
458 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
459 
460 pragma solidity >=0.6.0 <0.8.0;
461 
462 /*
463  * @dev Provides information about the current execution context, including the
464  * sender of the transaction and its data. While these are generally available
465  * via msg.sender and msg.data, they should not be accessed in such a direct
466  * manner, since when dealing with GSN meta-transactions the account sending and
467  * paying for execution may not be the actual sender (as far as an application
468  * is concerned).
469  *
470  * This contract is only required for intermediate, library-like contracts.
471  */
472 abstract contract Context {
473     function _msgSender() internal view virtual returns (address payable) {
474         return msg.sender;
475     }
476 
477     function _msgData() internal view virtual returns (bytes memory) {
478         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
479         return msg.data;
480     }
481 }
482 
483 
484 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
485 
486 pragma solidity >=0.6.0 <0.8.0;
487 
488 /**
489  * @dev Contract module which provides a basic access control mechanism, where
490  * there is an account (an owner) that can be granted exclusive access to
491  * specific functions.
492  *
493  * By default, the owner account will be the one that deploys the contract. This
494  * can later be changed with {transferOwnership}.
495  *
496  * This module is used through inheritance. It will make available the modifier
497  * `onlyOwner`, which can be applied to your functions to restrict their use to
498  * the owner.
499  */
500 abstract contract Ownable is Context {
501     address private _owner;
502 
503     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
504 
505     /**
506      * @dev Initializes the contract setting the deployer as the initial owner.
507      */
508     constructor () internal {
509         address msgSender = _msgSender();
510         _owner = msgSender;
511         emit OwnershipTransferred(address(0), msgSender);
512     }
513 
514     /**
515      * @dev Returns the address of the current owner.
516      */
517     function owner() public view returns (address) {
518         return _owner;
519     }
520 
521     /**
522      * @dev Throws if called by any account other than the owner.
523      */
524     modifier onlyOwner() {
525         require(_owner == _msgSender(), "Ownable: caller is not the owner");
526         _;
527     }
528 
529     /**
530      * @dev Leaves the contract without owner. It will not be possible to call
531      * `onlyOwner` functions anymore. Can only be called by the current owner.
532      *
533      * NOTE: Renouncing ownership will leave the contract without an owner,
534      * thereby removing any functionality that is only available to the owner.
535      */
536     function renounceOwnership() public virtual onlyOwner {
537         emit OwnershipTransferred(_owner, address(0));
538         _owner = address(0);
539     }
540 
541     /**
542      * @dev Transfers ownership of the contract to a new account (`newOwner`).
543      * Can only be called by the current owner.
544      */
545     function transferOwnership(address newOwner) public virtual onlyOwner {
546         require(newOwner != address(0), "Ownable: new owner is the zero address");
547         emit OwnershipTransferred(_owner, newOwner);
548         _owner = newOwner;
549     }
550 }
551 
552 
553 // File @animoca/ethereum-contracts-core_library-5.0.0/contracts/payment/PayoutWallet.sol@v5.0.0
554 
555 pragma solidity 0.6.8;
556 
557 /**
558     @title PayoutWallet
559     @dev adds support for a payout wallet
560     Note: .
561  */
562 contract PayoutWallet is Ownable {
563     event PayoutWalletSet(address payoutWallet_);
564 
565     address payable public payoutWallet;
566 
567     constructor(address payoutWallet_) internal {
568         setPayoutWallet(payoutWallet_);
569     }
570 
571     function setPayoutWallet(address payoutWallet_) public onlyOwner {
572         require(payoutWallet_ != address(0), "Payout: zero address");
573         require(payoutWallet_ != address(this), "Payout: this contract as payout");
574         require(payoutWallet_ != payoutWallet, "Payout: same payout wallet");
575         payoutWallet = payable(payoutWallet_);
576         emit PayoutWalletSet(payoutWallet);
577     }
578 }
579 
580 
581 // File @animoca/ethereum-contracts-core_library-5.0.0/contracts/utils/Startable.sol@v5.0.0
582 
583 pragma solidity 0.6.8;
584 
585 /**
586  * Contract module which allows derived contracts to implement a mechanism for
587  * activating, or 'starting', a contract.
588  *
589  * This module is used through inheritance. It will make available the modifiers
590  * `whenNotStarted` and `whenStarted`, which can be applied to the functions of
591  * your contract. Those functions will only be 'startable' once the modifiers
592  * are put in place.
593  */
594 contract Startable is Context {
595     event Started(address account);
596 
597     uint256 private _startedAt;
598 
599     /**
600      * Modifier to make a function callable only when the contract has not started.
601      */
602     modifier whenNotStarted() {
603         require(_startedAt == 0, "Startable: started");
604         _;
605     }
606 
607     /**
608      * Modifier to make a function callable only when the contract has started.
609      */
610     modifier whenStarted() {
611         require(_startedAt != 0, "Startable: not started");
612         _;
613     }
614 
615     /**
616      * Constructor.
617      */
618     constructor() internal {}
619 
620     /**
621      * Returns the timestamp when the contract entered the started state.
622      * @return The timestamp when the contract entered the started state.
623      */
624     function startedAt() public view returns (uint256) {
625         return _startedAt;
626     }
627 
628     /**
629      * Triggers the started state.
630      * @dev Emits the Started event when the function is successfully called.
631      */
632     function _start() internal virtual whenNotStarted {
633         _startedAt = now;
634         emit Started(_msgSender());
635     }
636 }
637 
638 
639 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
640 
641 pragma solidity >=0.6.0 <0.8.0;
642 
643 /**
644  * @dev Contract module which allows children to implement an emergency stop
645  * mechanism that can be triggered by an authorized account.
646  *
647  * This module is used through inheritance. It will make available the
648  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
649  * the functions of your contract. Note that they will not be pausable by
650  * simply including this module, only once the modifiers are put in place.
651  */
652 abstract contract Pausable is Context {
653     /**
654      * @dev Emitted when the pause is triggered by `account`.
655      */
656     event Paused(address account);
657 
658     /**
659      * @dev Emitted when the pause is lifted by `account`.
660      */
661     event Unpaused(address account);
662 
663     bool private _paused;
664 
665     /**
666      * @dev Initializes the contract in unpaused state.
667      */
668     constructor () internal {
669         _paused = false;
670     }
671 
672     /**
673      * @dev Returns true if the contract is paused, and false otherwise.
674      */
675     function paused() public view returns (bool) {
676         return _paused;
677     }
678 
679     /**
680      * @dev Modifier to make a function callable only when the contract is not paused.
681      *
682      * Requirements:
683      *
684      * - The contract must not be paused.
685      */
686     modifier whenNotPaused() {
687         require(!_paused, "Pausable: paused");
688         _;
689     }
690 
691     /**
692      * @dev Modifier to make a function callable only when the contract is paused.
693      *
694      * Requirements:
695      *
696      * - The contract must be paused.
697      */
698     modifier whenPaused() {
699         require(_paused, "Pausable: not paused");
700         _;
701     }
702 
703     /**
704      * @dev Triggers stopped state.
705      *
706      * Requirements:
707      *
708      * - The contract must not be paused.
709      */
710     function _pause() internal virtual whenNotPaused {
711         _paused = true;
712         emit Paused(_msgSender());
713     }
714 
715     /**
716      * @dev Returns to normal state.
717      *
718      * Requirements:
719      *
720      * - The contract must be paused.
721      */
722     function _unpause() internal virtual whenPaused {
723         _paused = false;
724         emit Unpaused(_msgSender());
725     }
726 }
727 
728 
729 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
730 
731 pragma solidity >=0.6.2 <0.8.0;
732 
733 /**
734  * @dev Collection of functions related to the address type
735  */
736 library Address {
737     /**
738      * @dev Returns true if `account` is a contract.
739      *
740      * [IMPORTANT]
741      * ====
742      * It is unsafe to assume that an address for which this function returns
743      * false is an externally-owned account (EOA) and not a contract.
744      *
745      * Among others, `isContract` will return false for the following
746      * types of addresses:
747      *
748      *  - an externally-owned account
749      *  - a contract in construction
750      *  - an address where a contract will be created
751      *  - an address where a contract lived, but was destroyed
752      * ====
753      */
754     function isContract(address account) internal view returns (bool) {
755         // This method relies on extcodesize, which returns 0 for contracts in
756         // construction, since the code is only stored at the end of the
757         // constructor execution.
758 
759         uint256 size;
760         // solhint-disable-next-line no-inline-assembly
761         assembly { size := extcodesize(account) }
762         return size > 0;
763     }
764 
765     /**
766      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
767      * `recipient`, forwarding all available gas and reverting on errors.
768      *
769      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
770      * of certain opcodes, possibly making contracts go over the 2300 gas limit
771      * imposed by `transfer`, making them unable to receive funds via
772      * `transfer`. {sendValue} removes this limitation.
773      *
774      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
775      *
776      * IMPORTANT: because control is transferred to `recipient`, care must be
777      * taken to not create reentrancy vulnerabilities. Consider using
778      * {ReentrancyGuard} or the
779      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
780      */
781     function sendValue(address payable recipient, uint256 amount) internal {
782         require(address(this).balance >= amount, "Address: insufficient balance");
783 
784         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
785         (bool success, ) = recipient.call{ value: amount }("");
786         require(success, "Address: unable to send value, recipient may have reverted");
787     }
788 
789     /**
790      * @dev Performs a Solidity function call using a low level `call`. A
791      * plain`call` is an unsafe replacement for a function call: use this
792      * function instead.
793      *
794      * If `target` reverts with a revert reason, it is bubbled up by this
795      * function (like regular Solidity function calls).
796      *
797      * Returns the raw returned data. To convert to the expected return value,
798      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
799      *
800      * Requirements:
801      *
802      * - `target` must be a contract.
803      * - calling `target` with `data` must not revert.
804      *
805      * _Available since v3.1._
806      */
807     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
808       return functionCall(target, data, "Address: low-level call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
813      * `errorMessage` as a fallback revert reason when `target` reverts.
814      *
815      * _Available since v3.1._
816      */
817     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
818         return functionCallWithValue(target, data, 0, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but also transferring `value` wei to `target`.
824      *
825      * Requirements:
826      *
827      * - the calling contract must have an ETH balance of at least `value`.
828      * - the called Solidity function must be `payable`.
829      *
830      * _Available since v3.1._
831      */
832     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
833         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
838      * with `errorMessage` as a fallback revert reason when `target` reverts.
839      *
840      * _Available since v3.1._
841      */
842     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
843         require(address(this).balance >= value, "Address: insufficient balance for call");
844         require(isContract(target), "Address: call to non-contract");
845 
846         // solhint-disable-next-line avoid-low-level-calls
847         (bool success, bytes memory returndata) = target.call{ value: value }(data);
848         return _verifyCallResult(success, returndata, errorMessage);
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
853      * but performing a static call.
854      *
855      * _Available since v3.3._
856      */
857     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
858         return functionStaticCall(target, data, "Address: low-level static call failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
863      * but performing a static call.
864      *
865      * _Available since v3.3._
866      */
867     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
868         require(isContract(target), "Address: static call to non-contract");
869 
870         // solhint-disable-next-line avoid-low-level-calls
871         (bool success, bytes memory returndata) = target.staticcall(data);
872         return _verifyCallResult(success, returndata, errorMessage);
873     }
874 
875     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
876         if (success) {
877             return returndata;
878         } else {
879             // Look for revert reason and bubble it up if present
880             if (returndata.length > 0) {
881                 // The easiest way to bubble the revert reason is using memory via assembly
882 
883                 // solhint-disable-next-line no-inline-assembly
884                 assembly {
885                     let returndata_size := mload(returndata)
886                     revert(add(32, returndata), returndata_size)
887                 }
888             } else {
889                 revert(errorMessage);
890             }
891         }
892     }
893 }
894 
895 
896 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
897 
898 pragma solidity >=0.6.0 <0.8.0;
899 
900 /**
901  * @dev Wrappers over Solidity's arithmetic operations with added overflow
902  * checks.
903  *
904  * Arithmetic operations in Solidity wrap on overflow. This can easily result
905  * in bugs, because programmers usually assume that an overflow raises an
906  * error, which is the standard behavior in high level programming languages.
907  * `SafeMath` restores this intuition by reverting the transaction when an
908  * operation overflows.
909  *
910  * Using this library instead of the unchecked operations eliminates an entire
911  * class of bugs, so it's recommended to use it always.
912  */
913 library SafeMath {
914     /**
915      * @dev Returns the addition of two unsigned integers, reverting on
916      * overflow.
917      *
918      * Counterpart to Solidity's `+` operator.
919      *
920      * Requirements:
921      *
922      * - Addition cannot overflow.
923      */
924     function add(uint256 a, uint256 b) internal pure returns (uint256) {
925         uint256 c = a + b;
926         require(c >= a, "SafeMath: addition overflow");
927 
928         return c;
929     }
930 
931     /**
932      * @dev Returns the subtraction of two unsigned integers, reverting on
933      * overflow (when the result is negative).
934      *
935      * Counterpart to Solidity's `-` operator.
936      *
937      * Requirements:
938      *
939      * - Subtraction cannot overflow.
940      */
941     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
942         return sub(a, b, "SafeMath: subtraction overflow");
943     }
944 
945     /**
946      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
947      * overflow (when the result is negative).
948      *
949      * Counterpart to Solidity's `-` operator.
950      *
951      * Requirements:
952      *
953      * - Subtraction cannot overflow.
954      */
955     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
956         require(b <= a, errorMessage);
957         uint256 c = a - b;
958 
959         return c;
960     }
961 
962     /**
963      * @dev Returns the multiplication of two unsigned integers, reverting on
964      * overflow.
965      *
966      * Counterpart to Solidity's `*` operator.
967      *
968      * Requirements:
969      *
970      * - Multiplication cannot overflow.
971      */
972     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
973         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
974         // benefit is lost if 'b' is also tested.
975         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
976         if (a == 0) {
977             return 0;
978         }
979 
980         uint256 c = a * b;
981         require(c / a == b, "SafeMath: multiplication overflow");
982 
983         return c;
984     }
985 
986     /**
987      * @dev Returns the integer division of two unsigned integers. Reverts on
988      * division by zero. The result is rounded towards zero.
989      *
990      * Counterpart to Solidity's `/` operator. Note: this function uses a
991      * `revert` opcode (which leaves remaining gas untouched) while Solidity
992      * uses an invalid opcode to revert (consuming all remaining gas).
993      *
994      * Requirements:
995      *
996      * - The divisor cannot be zero.
997      */
998     function div(uint256 a, uint256 b) internal pure returns (uint256) {
999         return div(a, b, "SafeMath: division by zero");
1000     }
1001 
1002     /**
1003      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1004      * division by zero. The result is rounded towards zero.
1005      *
1006      * Counterpart to Solidity's `/` operator. Note: this function uses a
1007      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1008      * uses an invalid opcode to revert (consuming all remaining gas).
1009      *
1010      * Requirements:
1011      *
1012      * - The divisor cannot be zero.
1013      */
1014     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1015         require(b > 0, errorMessage);
1016         uint256 c = a / b;
1017         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1018 
1019         return c;
1020     }
1021 
1022     /**
1023      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1024      * Reverts when dividing by zero.
1025      *
1026      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1027      * opcode (which leaves remaining gas untouched) while Solidity uses an
1028      * invalid opcode to revert (consuming all remaining gas).
1029      *
1030      * Requirements:
1031      *
1032      * - The divisor cannot be zero.
1033      */
1034     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1035         return mod(a, b, "SafeMath: modulo by zero");
1036     }
1037 
1038     /**
1039      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1040      * Reverts with custom message when dividing by zero.
1041      *
1042      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1043      * opcode (which leaves remaining gas untouched) while Solidity uses an
1044      * invalid opcode to revert (consuming all remaining gas).
1045      *
1046      * Requirements:
1047      *
1048      * - The divisor cannot be zero.
1049      */
1050     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1051         require(b != 0, errorMessage);
1052         return a % b;
1053     }
1054 }
1055 
1056 
1057 // File @animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/interfaces/ISale.sol@v8.0.0
1058 
1059 pragma solidity 0.6.8;
1060 
1061 /**
1062  * @title ISale
1063  *
1064  * An interface for a contract which allows merchants to display products and customers to purchase them.
1065  *
1066  *  Products, designated as SKUs, are represented by bytes32 identifiers so that an identifier can carry an
1067  *  explicit name under the form of a fixed-length string. Each SKU can be priced via up to several payment
1068  *  tokens which can be ETH and/or ERC20(s). ETH token is represented by the magic value TOKEN_ETH, which means
1069  *  this value can be used as the 'token' argument of the purchase-related functions to indicate ETH payment.
1070  *
1071  *  The total available supply for a SKU is fixed at its creation. The magic value SUPPLY_UNLIMITED is used
1072  *  to represent a SKU with an infinite, never-decreasing supply. An optional purchase notifications receiver
1073  *  contract address can be set for a SKU at its creation: if the value is different from the zero address,
1074  *  the function `onPurchaseNotificationReceived` will be called on this address upon every purchase of the SKU.
1075  *
1076  *  This interface is designed to be consistent while managing a variety of implementation scenarios. It is
1077  *  also intended to be developer-friendly: all vital information is consistently deductible from the events
1078  *  (backend-oriented), as well as retrievable through calls to public functions (frontend-oriented).
1079  */
1080 interface ISale {
1081     /**
1082      * Event emitted to notify about the magic values necessary for interfacing with this contract.
1083      * @param names An array of names for the magic values used by the contract.
1084      * @param values An array of values for the magic values used by the contract.
1085      */
1086     event MagicValues(bytes32[] names, bytes32[] values);
1087 
1088     /**
1089      * Event emitted to notify about the creation of a SKU.
1090      * @param sku The identifier of the created SKU.
1091      * @param totalSupply The initial total supply for sale.
1092      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1093      * @param notificationsReceiver If not the zero address, the address of a contract on which `onPurchaseNotificationReceived` will be called after
1094      *  each purchase. If this is the zero address, the call is not enabled.
1095      */
1096     event SkuCreation(bytes32 sku, uint256 totalSupply, uint256 maxQuantityPerPurchase, address notificationsReceiver);
1097 
1098     /**
1099      * Event emitted to notify about a change in the pricing of a SKU.
1100      * @dev `tokens` and `prices` arrays MUST have the same length.
1101      * @param sku The identifier of the updated SKU.
1102      * @param tokens An array of updated payment tokens. If empty, interpret as all payment tokens being disabled.
1103      * @param prices An array of updated prices for each of the payment tokens.
1104      *  Zero price values are used for payment tokens being disabled.
1105      */
1106     event SkuPricingUpdate(bytes32 indexed sku, address[] tokens, uint256[] prices);
1107 
1108     /**
1109      * Event emitted to notify about a purchase.
1110      * @param purchaser The initiater and buyer of the purchase.
1111      * @param recipient The recipient of the purchase.
1112      * @param token The token used as the currency for the payment.
1113      * @param sku The identifier of the purchased SKU.
1114      * @param quantity The purchased quantity.
1115      * @param userData Optional extra user input data.
1116      * @param totalPrice The amount of `token` paid.
1117      * @param extData Implementation-specific extra purchase data, such as
1118      *  details about discounts applied, conversion rates, purchase receipts, etc.
1119      */
1120     event Purchase(
1121         address indexed purchaser,
1122         address recipient,
1123         address indexed token,
1124         bytes32 indexed sku,
1125         uint256 quantity,
1126         bytes userData,
1127         uint256 totalPrice,
1128         bytes extData
1129     );
1130 
1131     /**
1132      * Returns the magic value used to represent the ETH payment token.
1133      * @dev MUST NOT be the zero address.
1134      * @return the magic value used to represent the ETH payment token.
1135      */
1136     // solhint-disable-next-line func-name-mixedcase
1137     function TOKEN_ETH() external pure returns (address);
1138 
1139     /**
1140      * Returns the magic value used to represent an infinite, never-decreasing SKU's supply.
1141      * @dev MUST NOT be zero.
1142      * @return the magic value used to represent an infinite, never-decreasing SKU's supply.
1143      */
1144     // solhint-disable-next-line func-name-mixedcase
1145     function SUPPLY_UNLIMITED() external pure returns (uint256);
1146 
1147     /**
1148      * Performs a purchase.
1149      * @dev Reverts if `recipient` is the zero address.
1150      * @dev Reverts if `token` is the address zero.
1151      * @dev Reverts if `quantity` is zero.
1152      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1153      * @dev Reverts if `quantity` is greater than the remaining supply.
1154      * @dev Reverts if `sku` does not exist.
1155      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1156      * @dev Emits the Purchase event.
1157      * @param recipient The recipient of the purchase.
1158      * @param token The token to use as the payment currency.
1159      * @param sku The identifier of the SKU to purchase.
1160      * @param quantity The quantity to purchase.
1161      * @param userData Optional extra user input data.
1162      */
1163     function purchaseFor(
1164         address payable recipient,
1165         address token,
1166         bytes32 sku,
1167         uint256 quantity,
1168         bytes calldata userData
1169     ) external payable;
1170 
1171     /**
1172      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1173      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1174      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1175      * @dev Reverts if `recipient` is the zero address.
1176      * @dev Reverts if `token` is the zero address.
1177      * @dev Reverts if `quantity` is zero.
1178      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1179      * @dev Reverts if `quantity` is greater than the remaining supply.
1180      * @dev Reverts if `sku` does not exist.
1181      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1182      * @param recipient The recipient of the purchase used to calculate the total price amount.
1183      * @param token The payment token used to calculate the total price amount.
1184      * @param sku The identifier of the SKU used to calculate the total price amount.
1185      * @param quantity The quantity used to calculate the total price amount.
1186      * @param userData Optional extra user input data.
1187      * @return totalPrice The computed total price to pay.
1188      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1189      *  If not empty, the implementer MUST document how to interepret the values.
1190      */
1191     function estimatePurchase(
1192         address payable recipient,
1193         address token,
1194         bytes32 sku,
1195         uint256 quantity,
1196         bytes calldata userData
1197     ) external view returns (uint256 totalPrice, bytes32[] memory pricingData);
1198 
1199     /**
1200      * Returns the information relative to a SKU.
1201      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1202      *  number of payment tokens is bounded, so that this function does not run out of gas.
1203      * @dev Reverts if `sku` does not exist.
1204      * @param sku The SKU identifier.
1205      * @return totalSupply The initial total supply for sale.
1206      * @return remainingSupply The remaining supply for sale.
1207      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1208      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1209      * @return tokens The list of supported payment tokens.
1210      * @return prices The list of associated prices for each of the `tokens`.
1211      */
1212     function getSkuInfo(bytes32 sku)
1213         external
1214         view
1215         returns (
1216             uint256 totalSupply,
1217             uint256 remainingSupply,
1218             uint256 maxQuantityPerPurchase,
1219             address notificationsReceiver,
1220             address[] memory tokens,
1221             uint256[] memory prices
1222         );
1223 
1224     /**
1225      * Returns the list of created SKU identifiers.
1226      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1227      *  number of SKUs is bounded, so that this function does not run out of gas.
1228      * @return skus the list of created SKU identifiers.
1229      */
1230     function getSkus() external view returns (bytes32[] memory skus);
1231 }
1232 
1233 
1234 // File @animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/interfaces/IPurchaseNotificationsReceiver.sol@v8.0.0
1235 
1236 pragma solidity 0.6.8;
1237 
1238 /**
1239  * @title IPurchaseNotificationsReceiver
1240  * Interface for any contract that wants to support purchase notifications from a Sale contract.
1241  */
1242 interface IPurchaseNotificationsReceiver {
1243     /**
1244      * Handles the receipt of a purchase notification.
1245      * @dev This function MUST return the function selector, otherwise the caller will revert the transaction.
1246      *  The selector to be returned can be obtained as `this.onPurchaseNotificationReceived.selector`
1247      * @dev This function MAY throw.
1248      * @param purchaser The purchaser of the purchase.
1249      * @param recipient The recipient of the purchase.
1250      * @param token The token to use as the payment currency.
1251      * @param sku The identifier of the SKU to purchase.
1252      * @param quantity The quantity to purchase.
1253      * @param userData Optional extra user input data.
1254      * @param totalPrice The total price paid.
1255      * @param pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1256      * @param paymentData Implementation-specific extra payment data, such as conversion rates.
1257      * @param deliveryData Implementation-specific extra delivery data, such as purchase receipts.
1258      * @return `bytes4(keccak256(
1259      *  "onPurchaseNotificationReceived(address,address,address,bytes32,uint256,bytes,uint256,bytes32[],bytes32[],bytes32[])"))`
1260      */
1261     function onPurchaseNotificationReceived(
1262         address purchaser,
1263         address recipient,
1264         address token,
1265         bytes32 sku,
1266         uint256 quantity,
1267         bytes calldata userData,
1268         uint256 totalPrice,
1269         bytes32[] calldata pricingData,
1270         bytes32[] calldata paymentData,
1271         bytes32[] calldata deliveryData
1272     ) external returns (bytes4);
1273 }
1274 
1275 
1276 // File @animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/abstract/PurchaseLifeCycles.sol@v8.0.0
1277 
1278 pragma solidity 0.6.8;
1279 
1280 /**
1281  * @title PurchaseLifeCycles
1282  * An abstract contract which define the life cycles for a purchase implementer.
1283  */
1284 abstract contract PurchaseLifeCycles {
1285     /**
1286      * Wrapper for the purchase data passed as argument to the life cycle functions and down to their step functions.
1287      */
1288     struct PurchaseData {
1289         address payable purchaser;
1290         address payable recipient;
1291         address token;
1292         bytes32 sku;
1293         uint256 quantity;
1294         bytes userData;
1295         uint256 totalPrice;
1296         bytes32[] pricingData;
1297         bytes32[] paymentData;
1298         bytes32[] deliveryData;
1299     }
1300 
1301     /*                               Internal Life Cycle Functions                               */
1302 
1303     /**
1304      * `estimatePurchase` lifecycle.
1305      * @param purchase The purchase conditions.
1306      */
1307     function _estimatePurchase(PurchaseData memory purchase) internal view virtual returns (uint256 totalPrice, bytes32[] memory pricingData) {
1308         _validation(purchase);
1309         _pricing(purchase);
1310 
1311         totalPrice = purchase.totalPrice;
1312         pricingData = purchase.pricingData;
1313     }
1314 
1315     /**
1316      * `purchaseFor` lifecycle.
1317      * @param purchase The purchase conditions.
1318      */
1319     function _purchaseFor(PurchaseData memory purchase) internal virtual {
1320         _validation(purchase);
1321         _pricing(purchase);
1322         _payment(purchase);
1323         _delivery(purchase);
1324         _notification(purchase);
1325     }
1326 
1327     /*                            Internal Life Cycle Step Functions                             */
1328 
1329     /**
1330      * Lifecycle step which validates the purchase pre-conditions.
1331      * @dev Responsibilities:
1332      *  - Ensure that the purchase pre-conditions are met and revert if not.
1333      * @param purchase The purchase conditions.
1334      */
1335     function _validation(PurchaseData memory purchase) internal view virtual;
1336 
1337     /**
1338      * Lifecycle step which computes the purchase price.
1339      * @dev Responsibilities:
1340      *  - Computes the pricing formula, including any discount logic and price conversion;
1341      *  - Set the value of `purchase.totalPrice`;
1342      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1343      * @param purchase The purchase conditions.
1344      */
1345     function _pricing(PurchaseData memory purchase) internal view virtual;
1346 
1347     /**
1348      * Lifecycle step which manages the transfer of funds from the purchaser.
1349      * @dev Responsibilities:
1350      *  - Ensure the payment reaches destination in the expected output token;
1351      *  - Handle any token swap logic;
1352      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1353      * @param purchase The purchase conditions.
1354      */
1355     function _payment(PurchaseData memory purchase) internal virtual;
1356 
1357     /**
1358      * Lifecycle step which delivers the purchased SKUs to the recipient.
1359      * @dev Responsibilities:
1360      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1361      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1362      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1363      * @param purchase The purchase conditions.
1364      */
1365     function _delivery(PurchaseData memory purchase) internal virtual;
1366 
1367     /**
1368      * Lifecycle step which notifies of the purchase.
1369      * @dev Responsibilities:
1370      *  - Manage after-purchase event(s) emission.
1371      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1372      * @param purchase The purchase conditions.
1373      */
1374     function _notification(PurchaseData memory purchase) internal virtual;
1375 }
1376 
1377 
1378 // File @animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/abstract/Sale.sol@v8.0.0
1379 
1380 pragma solidity 0.6.8;
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 
1389 
1390 
1391 /**
1392  * @title Sale
1393  * An abstract base sale contract with a minimal implementation of ISale and administration functions.
1394  *  A minimal implementation of the `_validation`, `_delivery` and `notification` life cycle step functions
1395  *  are provided, but the inheriting contract must implement `_pricing` and `_payment`.
1396  */
1397 abstract contract Sale is PurchaseLifeCycles, ISale, PayoutWallet, Startable, Pausable {
1398     using Address for address;
1399     using SafeMath for uint256;
1400     using EnumSet for EnumSet.Set;
1401     using EnumMap for EnumMap.Map;
1402 
1403     struct SkuInfo {
1404         uint256 totalSupply;
1405         uint256 remainingSupply;
1406         uint256 maxQuantityPerPurchase;
1407         address notificationsReceiver;
1408         EnumMap.Map prices;
1409     }
1410 
1411     address public constant override TOKEN_ETH = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1412     uint256 public constant override SUPPLY_UNLIMITED = type(uint256).max;
1413 
1414     EnumSet.Set internal _skus;
1415     mapping(bytes32 => SkuInfo) internal _skuInfos;
1416 
1417     uint256 internal immutable _skusCapacity;
1418     uint256 internal immutable _tokensPerSkuCapacity;
1419 
1420     /**
1421      * Constructor.
1422      * @dev Emits the `MagicValues` event.
1423      * @dev Emits the `Paused` event.
1424      * @param payoutWallet_ the payout wallet.
1425      * @param skusCapacity the cap for the number of managed SKUs.
1426      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1427      */
1428     constructor(
1429         address payoutWallet_,
1430         uint256 skusCapacity,
1431         uint256 tokensPerSkuCapacity
1432     ) internal PayoutWallet(payoutWallet_) {
1433         _skusCapacity = skusCapacity;
1434         _tokensPerSkuCapacity = tokensPerSkuCapacity;
1435         bytes32[] memory names = new bytes32[](2);
1436         bytes32[] memory values = new bytes32[](2);
1437         (names[0], values[0]) = ("TOKEN_ETH", bytes32(uint256(TOKEN_ETH)));
1438         (names[1], values[1]) = ("SUPPLY_UNLIMITED", bytes32(uint256(SUPPLY_UNLIMITED)));
1439         emit MagicValues(names, values);
1440         _pause();
1441     }
1442 
1443     /*                                   Public Admin Functions                                  */
1444 
1445     /**
1446      * Actvates, or 'starts', the contract.
1447      * @dev Emits the `Started` event.
1448      * @dev Emits the `Unpaused` event.
1449      * @dev Reverts if called by any other than the contract owner.
1450      * @dev Reverts if the contract has already been started.
1451      * @dev Reverts if the contract is not paused.
1452      */
1453     function start() public virtual onlyOwner {
1454         _start();
1455         _unpause();
1456     }
1457 
1458     /**
1459      * Pauses the contract.
1460      * @dev Emits the `Paused` event.
1461      * @dev Reverts if called by any other than the contract owner.
1462      * @dev Reverts if the contract has not been started yet.
1463      * @dev Reverts if the contract is already paused.
1464      */
1465     function pause() public virtual onlyOwner whenStarted {
1466         _pause();
1467     }
1468 
1469     /**
1470      * Resumes the contract.
1471      * @dev Emits the `Unpaused` event.
1472      * @dev Reverts if called by any other than the contract owner.
1473      * @dev Reverts if the contract has not been started yet.
1474      * @dev Reverts if the contract is not paused.
1475      */
1476     function unpause() public virtual onlyOwner whenStarted {
1477         _unpause();
1478     }
1479 
1480     /**
1481      * Sets the token prices for the specified product SKU.
1482      * @dev Reverts if called by any other than the contract owner.
1483      * @dev Reverts if `tokens` and `prices` have different lengths.
1484      * @dev Reverts if `sku` does not exist.
1485      * @dev Reverts if one of the `tokens` is the zero address.
1486      * @dev Reverts if the update results in too many tokens for the SKU.
1487      * @dev Emits the `SkuPricingUpdate` event.
1488      * @param sku The identifier of the SKU.
1489      * @param tokens The list of payment tokens to update.
1490      *  If empty, disable all the existing payment tokens.
1491      * @param prices The list of prices to apply for each payment token.
1492      *  Zero price values are used to disable a payment token.
1493      */
1494     function updateSkuPricing(
1495         bytes32 sku,
1496         address[] memory tokens,
1497         uint256[] memory prices
1498     ) public virtual onlyOwner {
1499         uint256 length = tokens.length;
1500         // solhint-disable-next-line reason-string
1501         require(length == prices.length, "Sale: tokens/prices lengths mismatch");
1502         SkuInfo storage skuInfo = _skuInfos[sku];
1503         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1504 
1505         EnumMap.Map storage tokenPrices = skuInfo.prices;
1506         if (length == 0) {
1507             uint256 currentLength = tokenPrices.length();
1508             for (uint256 i = 0; i < currentLength; ++i) {
1509                 // TODO add a clear function in EnumMap and EnumSet and use it
1510                 (bytes32 token, ) = tokenPrices.at(0);
1511                 tokenPrices.remove(token);
1512             }
1513         } else {
1514             _setTokenPrices(tokenPrices, tokens, prices);
1515         }
1516 
1517         emit SkuPricingUpdate(sku, tokens, prices);
1518     }
1519 
1520     /*                                   ISale Public Functions                                  */
1521 
1522     /**
1523      * Performs a purchase.
1524      * @dev Reverts if the sale has not started.
1525      * @dev Reverts if the sale is paused.
1526      * @dev Reverts if `recipient` is the zero address.
1527      * @dev Reverts if `token` is the zero address.
1528      * @dev Reverts if `quantity` is zero.
1529      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1530      * @dev Reverts if `quantity` is greater than the remaining supply.
1531      * @dev Reverts if `sku` does not exist.
1532      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1533      * @dev Emits the Purchase event.
1534      * @param recipient The recipient of the purchase.
1535      * @param token The token to use as the payment currency.
1536      * @param sku The identifier of the SKU to purchase.
1537      * @param quantity The quantity to purchase.
1538      * @param userData Optional extra user input data.
1539      */
1540     function purchaseFor(
1541         address payable recipient,
1542         address token,
1543         bytes32 sku,
1544         uint256 quantity,
1545         bytes calldata userData
1546     ) external payable virtual override whenStarted whenNotPaused {
1547         PurchaseData memory purchase;
1548         purchase.purchaser = _msgSender();
1549         purchase.recipient = recipient;
1550         purchase.token = token;
1551         purchase.sku = sku;
1552         purchase.quantity = quantity;
1553         purchase.userData = userData;
1554 
1555         _purchaseFor(purchase);
1556     }
1557 
1558     /**
1559      * Estimates the computed final total amount to pay for a purchase, including any potential discount.
1560      * @dev This function MUST compute the same price as `purchaseFor` would in identical conditions (same arguments, same point in time).
1561      * @dev If an implementer contract uses the `pricingData` field, it SHOULD document how to interpret the values.
1562      * @dev Reverts if the sale has not started.
1563      * @dev Reverts if the sale is paused.
1564      * @dev Reverts if `recipient` is the zero address.
1565      * @dev Reverts if `token` is the zero address.
1566      * @dev Reverts if `quantity` is zero.
1567      * @dev Reverts if `quantity` is greater than the maximum purchase quantity.
1568      * @dev Reverts if `quantity` is greater than the remaining supply.
1569      * @dev Reverts if `sku` does not exist.
1570      * @dev Reverts if `sku` exists but does not have a price set for `token`.
1571      * @param recipient The recipient of the purchase used to calculate the total price amount.
1572      * @param token The payment token used to calculate the total price amount.
1573      * @param sku The identifier of the SKU used to calculate the total price amount.
1574      * @param quantity The quantity used to calculate the total price amount.
1575      * @param userData Optional extra user input data.
1576      * @return totalPrice The computed total price.
1577      * @return pricingData Implementation-specific extra pricing data, such as details about discounts applied.
1578      *  If not empty, the implementer MUST document how to interepret the values.
1579      */
1580     function estimatePurchase(
1581         address payable recipient,
1582         address token,
1583         bytes32 sku,
1584         uint256 quantity,
1585         bytes calldata userData
1586     ) external view virtual override whenStarted whenNotPaused returns (uint256 totalPrice, bytes32[] memory pricingData) {
1587         PurchaseData memory purchase;
1588         purchase.purchaser = _msgSender();
1589         purchase.recipient = recipient;
1590         purchase.token = token;
1591         purchase.sku = sku;
1592         purchase.quantity = quantity;
1593         purchase.userData = userData;
1594 
1595         return _estimatePurchase(purchase);
1596     }
1597 
1598     /**
1599      * Returns the information relative to a SKU.
1600      * @dev WARNING: it is the responsibility of the implementer to ensure that the
1601      * number of payment tokens is bounded, so that this function does not run out of gas.
1602      * @dev Reverts if `sku` does not exist.
1603      * @param sku The SKU identifier.
1604      * @return totalSupply The initial total supply for sale.
1605      * @return remainingSupply The remaining supply for sale.
1606      * @return maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1607      * @return notificationsReceiver The address of a contract on which to call the `onPurchaseNotificationReceived` function.
1608      * @return tokens The list of supported payment tokens.
1609      * @return prices The list of associated prices for each of the `tokens`.
1610      */
1611     function getSkuInfo(bytes32 sku)
1612         external
1613         view
1614         override
1615         returns (
1616             uint256 totalSupply,
1617             uint256 remainingSupply,
1618             uint256 maxQuantityPerPurchase,
1619             address notificationsReceiver,
1620             address[] memory tokens,
1621             uint256[] memory prices
1622         )
1623     {
1624         SkuInfo storage skuInfo = _skuInfos[sku];
1625         uint256 length = skuInfo.prices.length();
1626 
1627         totalSupply = skuInfo.totalSupply;
1628         require(totalSupply != 0, "Sale: non-existent sku");
1629         remainingSupply = skuInfo.remainingSupply;
1630         maxQuantityPerPurchase = skuInfo.maxQuantityPerPurchase;
1631         notificationsReceiver = skuInfo.notificationsReceiver;
1632 
1633         tokens = new address[](length);
1634         prices = new uint256[](length);
1635         for (uint256 i = 0; i < length; ++i) {
1636             (bytes32 token, bytes32 price) = skuInfo.prices.at(i);
1637             tokens[i] = address(uint256(token));
1638             prices[i] = uint256(price);
1639         }
1640     }
1641 
1642     /**
1643      * Returns the list of created SKU identifiers.
1644      * @return skus the list of created SKU identifiers.
1645      */
1646     function getSkus() external view override returns (bytes32[] memory skus) {
1647         skus = _skus.values;
1648     }
1649 
1650     /*                               Internal Utility Functions                                  */
1651 
1652     /**
1653      * Creates an SKU.
1654      * @dev Reverts if `totalSupply` is zero.
1655      * @dev Reverts if `sku` already exists.
1656      * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
1657      * @dev Reverts if the update results in too many SKUs.
1658      * @dev Emits the `SkuCreation` event.
1659      * @param sku the SKU identifier.
1660      * @param totalSupply the initial total supply.
1661      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1662      * @param notificationsReceiver The purchase notifications receiver contract address.
1663      *  If set to the zero address, the notification is not enabled.
1664      */
1665     function _createSku(
1666         bytes32 sku,
1667         uint256 totalSupply,
1668         uint256 maxQuantityPerPurchase,
1669         address notificationsReceiver
1670     ) internal virtual {
1671         require(totalSupply != 0, "Sale: zero supply");
1672         require(_skus.length() < _skusCapacity, "Sale: too many skus");
1673         require(_skus.add(sku), "Sale: sku already created");
1674         if (notificationsReceiver != address(0)) {
1675             // solhint-disable-next-line reason-string
1676             require(notificationsReceiver.isContract(), "Sale: receiver is not a contract");
1677         }
1678         SkuInfo storage skuInfo = _skuInfos[sku];
1679         skuInfo.totalSupply = totalSupply;
1680         skuInfo.remainingSupply = totalSupply;
1681         skuInfo.maxQuantityPerPurchase = maxQuantityPerPurchase;
1682         skuInfo.notificationsReceiver = notificationsReceiver;
1683         emit SkuCreation(sku, totalSupply, maxQuantityPerPurchase, notificationsReceiver);
1684     }
1685 
1686     /**
1687      * Updates SKU token prices.
1688      * @dev Reverts if one of the `tokens` is the zero address.
1689      * @dev Reverts if the update results in too many tokens for the SKU.
1690      * @param tokenPrices Storage pointer to a mapping of SKU token prices to update.
1691      * @param tokens The list of payment tokens to update.
1692      * @param prices The list of prices to apply for each payment token.
1693      *  Zero price values are used to disable a payment token.
1694      */
1695     function _setTokenPrices(
1696         EnumMap.Map storage tokenPrices,
1697         address[] memory tokens,
1698         uint256[] memory prices
1699     ) internal virtual {
1700         for (uint256 i = 0; i < tokens.length; ++i) {
1701             address token = tokens[i];
1702             require(token != address(0), "Sale: zero address token");
1703             uint256 price = prices[i];
1704             if (price == 0) {
1705                 tokenPrices.remove(bytes32(uint256(token)));
1706             } else {
1707                 tokenPrices.set(bytes32(uint256(token)), bytes32(price));
1708             }
1709         }
1710         require(tokenPrices.length() <= _tokensPerSkuCapacity, "Sale: too many tokens");
1711     }
1712 
1713     /*                            Internal Life Cycle Step Functions                             */
1714 
1715     /**
1716      * Lifecycle step which validates the purchase pre-conditions.
1717      * @dev Responsibilities:
1718      *  - Ensure that the purchase pre-conditions are met and revert if not.
1719      * @dev Reverts if `purchase.recipient` is the zero address.
1720      * @dev Reverts if `purchase.token` is the zero address.
1721      * @dev Reverts if `purchase.quantity` is zero.
1722      * @dev Reverts if `purchase.quantity` is greater than the SKU's `maxQuantityPerPurchase`.
1723      * @dev Reverts if `purchase.quantity` is greater than the available supply.
1724      * @dev Reverts if `purchase.sku` does not exist.
1725      * @dev Reverts if `purchase.sku` exists but does not have a price set for `purchase.token`.
1726      * @dev If this function is overriden, the implementer SHOULD super call this before.
1727      * @param purchase The purchase conditions.
1728      */
1729     function _validation(PurchaseData memory purchase) internal view virtual override {
1730         require(purchase.recipient != address(0), "Sale: zero address recipient");
1731         require(purchase.token != address(0), "Sale: zero address token");
1732         require(purchase.quantity != 0, "Sale: zero quantity purchase");
1733         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1734         require(skuInfo.totalSupply != 0, "Sale: non-existent sku");
1735         require(skuInfo.maxQuantityPerPurchase >= purchase.quantity, "Sale: above max quantity");
1736         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1737             require(skuInfo.remainingSupply >= purchase.quantity, "Sale: insufficient supply");
1738         }
1739         bytes32 priceKey = bytes32(uint256(purchase.token));
1740         require(skuInfo.prices.contains(priceKey), "Sale: non-existent sku token");
1741     }
1742 
1743     /**
1744      * Lifecycle step which delivers the purchased SKUs to the recipient.
1745      * @dev Responsibilities:
1746      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1747      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1748      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1749      * @dev Reverts if there is not enough available supply.
1750      * @dev If this function is overriden, the implementer SHOULD super call it.
1751      * @param purchase The purchase conditions.
1752      */
1753     function _delivery(PurchaseData memory purchase) internal virtual override {
1754         SkuInfo memory skuInfo = _skuInfos[purchase.sku];
1755         if (skuInfo.totalSupply != SUPPLY_UNLIMITED) {
1756             _skuInfos[purchase.sku].remainingSupply = skuInfo.remainingSupply.sub(purchase.quantity);
1757         }
1758     }
1759 
1760     /**
1761      * Lifecycle step which notifies of the purchase.
1762      * @dev Responsibilities:
1763      *  - Manage after-purchase event(s) emission.
1764      *  - Handle calls to the notifications receiver contract's `onPurchaseNotificationReceived` function, if applicable.
1765      * @dev Reverts if `onPurchaseNotificationReceived` throws or returns an incorrect value.
1766      * @dev Emits the `Purchase` event. The values of `purchaseData` are the concatenated values of `priceData`, `paymentData`
1767      * and `deliveryData`. If not empty, the implementer MUST document how to interpret these values.
1768      * @dev If this function is overriden, the implementer SHOULD super call it.
1769      * @param purchase The purchase conditions.
1770      */
1771     function _notification(PurchaseData memory purchase) internal virtual override {
1772         emit Purchase(
1773             purchase.purchaser,
1774             purchase.recipient,
1775             purchase.token,
1776             purchase.sku,
1777             purchase.quantity,
1778             purchase.userData,
1779             purchase.totalPrice,
1780             abi.encodePacked(purchase.pricingData, purchase.paymentData, purchase.deliveryData)
1781         );
1782 
1783         address notificationsReceiver = _skuInfos[purchase.sku].notificationsReceiver;
1784         if (notificationsReceiver != address(0)) {
1785             // solhint-disable-next-line reason-string
1786             require(
1787                 IPurchaseNotificationsReceiver(notificationsReceiver).onPurchaseNotificationReceived(
1788                     purchase.purchaser,
1789                     purchase.recipient,
1790                     purchase.token,
1791                     purchase.sku,
1792                     purchase.quantity,
1793                     purchase.userData,
1794                     purchase.totalPrice,
1795                     purchase.pricingData,
1796                     purchase.paymentData,
1797                     purchase.deliveryData
1798                 ) == IPurchaseNotificationsReceiver(address(0)).onPurchaseNotificationReceived.selector, // TODO precompute return value
1799                 "Sale: wrong receiver return value"
1800             );
1801         }
1802     }
1803 }
1804 
1805 
1806 // File @animoca/ethereum-contracts-sale_base-8.0.0/contracts/sale/FixedPricesSale.sol@v8.0.0
1807 
1808 pragma solidity 0.6.8;
1809 
1810 
1811 /**
1812  * @title FixedPricesSale
1813  * An Sale which implements a fixed prices strategy.
1814  *  The final implementer is responsible for implementing any additional pricing and/or delivery logic.
1815  */
1816 contract FixedPricesSale is Sale {
1817     /**
1818      * Constructor.
1819      * @dev Emits the `MagicValues` event.
1820      * @dev Emits the `Paused` event.
1821      * @param payoutWallet_ the payout wallet.
1822      * @param skusCapacity the cap for the number of managed SKUs.
1823      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1824      */
1825     constructor(
1826         address payoutWallet_,
1827         uint256 skusCapacity,
1828         uint256 tokensPerSkuCapacity
1829     ) internal Sale(payoutWallet_, skusCapacity, tokensPerSkuCapacity) {}
1830 
1831     /*                               Internal Life Cycle Functions                               */
1832 
1833     /**
1834      * Lifecycle step which computes the purchase price.
1835      * @dev Responsibilities:
1836      *  - Computes the pricing formula, including any discount logic and price conversion;
1837      *  - Set the value of `purchase.totalPrice`;
1838      *  - Add any relevant extra data related to pricing in `purchase.pricingData` and document how to interpret it.
1839      * @dev Reverts if `purchase.sku` does not exist.
1840      * @dev Reverts if `purchase.token` is not supported by the SKU.
1841      * @dev Reverts in case of price overflow.
1842      * @param purchase The purchase conditions.
1843      */
1844     function _pricing(PurchaseData memory purchase) internal view virtual override {
1845         SkuInfo storage skuInfo = _skuInfos[purchase.sku];
1846         require(skuInfo.totalSupply != 0, "Sale: unsupported SKU");
1847         EnumMap.Map storage prices = skuInfo.prices;
1848         uint256 unitPrice = _unitPrice(purchase, prices);
1849         purchase.totalPrice = unitPrice.mul(purchase.quantity);
1850     }
1851 
1852     /**
1853      * Lifecycle step which manages the transfer of funds from the purchaser.
1854      * @dev Responsibilities:
1855      *  - Ensure the payment reaches destination in the expected output token;
1856      *  - Handle any token swap logic;
1857      *  - Add any relevant extra data related to payment in `purchase.paymentData` and document how to interpret it.
1858      * @dev Reverts in case of payment failure.
1859      * @param purchase The purchase conditions.
1860      */
1861     function _payment(PurchaseData memory purchase) internal virtual override {
1862         if (purchase.token == TOKEN_ETH) {
1863             require(msg.value >= purchase.totalPrice, "Sale: insufficient ETH provided");
1864 
1865             payoutWallet.transfer(purchase.totalPrice);
1866 
1867             uint256 change = msg.value.sub(purchase.totalPrice);
1868 
1869             if (change != 0) {
1870                 purchase.purchaser.transfer(change);
1871             }
1872         } else {
1873             require(IERC20(purchase.token).transferFrom(_msgSender(), payoutWallet, purchase.totalPrice), "Sale: ERC20 payment failed");
1874         }
1875     }
1876 
1877     /*                               Internal Utility Functions                                  */
1878 
1879     /**
1880      * Retrieves the unit price of a SKU for the specified payment token.
1881      * @dev Reverts if the specified payment token is unsupported.
1882      * @param purchase The purchase conditions specifying the payment token with which the unit price will be retrieved.
1883      * @param prices Storage pointer to a mapping of SKU token prices to retrieve the unit price from.
1884      * @return unitPrice The unit price of a SKU for the specified payment token.
1885      */
1886     function _unitPrice(PurchaseData memory purchase, EnumMap.Map storage prices) internal view virtual returns (uint256 unitPrice) {
1887         unitPrice = uint256(prices.get(bytes32(uint256(purchase.token))));
1888         require(unitPrice != 0, "Sale: unsupported payment token");
1889     }
1890 }
1891 
1892 
1893 // File contracts/solc-0.6/sale/GAMEEVoucherSale.sol
1894 
1895 pragma solidity 0.6.8;
1896 
1897 /**
1898  * @title GAMEEVoucherSale
1899  * A FixedPricesSale contract implementation that handles the purchase of pre-minted GAMEE token
1900  * (GMEE) voucher fungible tokens from a holder account to the purchase recipient.
1901  */
1902 contract GAMEEVoucherSale is FixedPricesSale {
1903     IGAMEEVoucherInventoryTransferable public immutable inventory;
1904 
1905     address public immutable tokenHolder;
1906 
1907     mapping(bytes32 => uint256) public skuTokenIds;
1908 
1909     /**
1910      * Constructor.
1911      * @dev Reverts if `inventory_` is the zero address.
1912      * @dev Reverts if `tokenHolder_` is the zero address.
1913      * @dev Emits the `MagicValues` event.
1914      * @dev Emits the `Paused` event.
1915      * @param inventory_ The inventory contract from which the sale supply is attributed from.
1916      * @param tokenHolder_ The account holding the pool of sale supply tokens.
1917      * @param payoutWallet the payout wallet.
1918      * @param skusCapacity the cap for the number of managed SKUs.
1919      * @param tokensPerSkuCapacity the cap for the number of tokens managed per SKU.
1920      */
1921     constructor(
1922         address inventory_,
1923         address tokenHolder_,
1924         address payoutWallet,
1925         uint256 skusCapacity,
1926         uint256 tokensPerSkuCapacity
1927     ) public FixedPricesSale(payoutWallet, skusCapacity, tokensPerSkuCapacity) {
1928         // solhint-disable-next-line reason-string
1929         require(inventory_ != address(0), "GAMEEVoucherSale: zero address inventory");
1930         // solhint-disable-next-line reason-string
1931         require(tokenHolder_ != address(0), "GAMEEVoucherSale: zero address token holder");
1932         inventory = IGAMEEVoucherInventoryTransferable(inventory_);
1933         tokenHolder = tokenHolder_;
1934     }
1935 
1936     /**
1937      * Creates an SKU.
1938      * @dev Reverts if `totalSupply` is zero.
1939      * @dev Reverts if `sku` already exists.
1940      * @dev Reverts if `notificationsReceiver` is not the zero address and is not a contract address.
1941      * @dev Reverts if the update results in too many SKUs.
1942      * @dev Reverts if `tokenId` is zero.
1943      * @dev Emits the `SkuCreation` event.
1944      * @param sku The SKU identifier.
1945      * @param totalSupply The initial total supply.
1946      * @param maxQuantityPerPurchase The maximum allowed quantity for a single purchase.
1947      * @param notificationsReceiver The purchase notifications receiver contract address.
1948      *  If set to the zero address, the notification is not enabled.
1949      * @param tokenId The inventory contract token ID to associate with the SKU, used for purchase
1950      *  delivery.
1951      */
1952     function createSku(
1953         bytes32 sku,
1954         uint256 totalSupply,
1955         uint256 maxQuantityPerPurchase,
1956         address notificationsReceiver,
1957         uint256 tokenId
1958     ) external onlyOwner whenPaused {
1959         require(tokenId != 0, "GAMEEVoucherSale: zero token ID");
1960         _createSku(sku, totalSupply, maxQuantityPerPurchase, notificationsReceiver);
1961         skuTokenIds[sku] = tokenId;
1962     }
1963 
1964     /**
1965      * Lifecycle step which delivers the purchased SKUs to the recipient.
1966      * @dev Responsibilities:
1967      *  - Ensure the product is delivered to the recipient, if that is the contract's responsibility.
1968      *  - Handle any internal logic related to the delivery, including the remaining supply update;
1969      *  - Add any relevant extra data related to delivery in `purchase.deliveryData` and document how to interpret it.
1970      * @dev Reverts if there is not enough available supply.
1971      * @dev If this function is overriden, the implementer SHOULD super call it.
1972      * @param purchase The purchase conditions.
1973      */
1974     function _delivery(PurchaseData memory purchase) internal override {
1975         super._delivery(purchase);
1976         inventory.safeTransferFrom(tokenHolder, purchase.recipient, skuTokenIds[purchase.sku], purchase.quantity, "");
1977     }
1978 }
1979 
1980 /**
1981  * @dev Interface for the transfer function of the GAMEE voucher inventory contract.
1982  */
1983 interface IGAMEEVoucherInventoryTransferable {
1984     /**
1985      * Safely transfers some token.
1986      * @dev Reverts if `to` is the zero address.
1987      * @dev Reverts if the sender is not approved.
1988      * @dev Reverts if `from` has an insufficient balance.
1989      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
1990      * @dev Emits a `TransferSingle` event.
1991      * @param from Current token owner.
1992      * @param to Address of the new token owner.
1993      * @param id Identifier of the token to transfer.
1994      * @param value Amount of token to transfer.
1995      * @param data Optional data to send along to a receiver contract.
1996      */
1997     function safeTransferFrom(
1998         address from,
1999         address to,
2000         uint256 id,
2001         uint256 value,
2002         bytes calldata data
2003     ) external;
2004 }