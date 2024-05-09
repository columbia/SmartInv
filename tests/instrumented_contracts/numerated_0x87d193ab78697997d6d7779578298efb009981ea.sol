1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46         // Position of the value in the `values` array, plus 1 because index 0
47         // means a value is not in the set.
48         mapping(bytes32 => uint256) _indexes;
49     }
50 
51     /**
52      * @dev Add a value to a set. O(1).
53      *
54      * Returns true if the value was added to the set, that is if it was not
55      * already present.
56      */
57     function _add(Set storage set, bytes32 value) private returns (bool) {
58         if (!_contains(set, value)) {
59             set._values.push(value);
60             // The value is stored at length-1, but we add 1 to all indexes
61             // and use 0 as a sentinel value
62             set._indexes[value] = set._values.length;
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /**
70      * @dev Removes a value from a set. O(1).
71      *
72      * Returns true if the value was removed from the set, that is if it was
73      * present.
74      */
75     function _remove(Set storage set, bytes32 value) private returns (bool) {
76         // We read and store the value's index to prevent multiple reads from the same storage slot
77         uint256 valueIndex = set._indexes[value];
78 
79         if (valueIndex != 0) {
80             // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             if (lastIndex != toDeleteIndex) {
89                 bytes32 lastvalue = set._values[lastIndex];
90 
91                 // Move the last value to the index where the value to delete is
92                 set._values[toDeleteIndex] = lastvalue;
93                 // Update the index for the moved value
94                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
95             }
96 
97             // Delete the slot where the moved value was stored
98             set._values.pop();
99 
100             // Delete the index for the deleted slot
101             delete set._indexes[value];
102 
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function _contains(Set storage set, bytes32 value) private view returns (bool) {
113         return set._indexes[value] != 0;
114     }
115 
116     /**
117      * @dev Returns the number of values on the set. O(1).
118      */
119     function _length(Set storage set) private view returns (uint256) {
120         return set._values.length;
121     }
122 
123     /**
124      * @dev Returns the value stored at position `index` in the set. O(1).
125      *
126      * Note that there are no guarantees on the ordering of values inside the
127      * array, and it may change when more values are added or removed.
128      *
129      * Requirements:
130      *
131      * - `index` must be strictly less than {length}.
132      */
133     function _at(Set storage set, uint256 index) private view returns (bytes32) {
134         return set._values[index];
135     }
136 
137     /**
138      * @dev Return the entire set in an array
139      *
140      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
141      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
142      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
143      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
144      */
145     function _values(Set storage set) private view returns (bytes32[] memory) {
146         return set._values;
147     }
148 
149     // Bytes32Set
150 
151     struct Bytes32Set {
152         Set _inner;
153     }
154 
155     /**
156      * @dev Add a value to a set. O(1).
157      *
158      * Returns true if the value was added to the set, that is if it was not
159      * already present.
160      */
161     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
162         return _add(set._inner, value);
163     }
164 
165     /**
166      * @dev Removes a value from a set. O(1).
167      *
168      * Returns true if the value was removed from the set, that is if it was
169      * present.
170      */
171     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
172         return _remove(set._inner, value);
173     }
174 
175     /**
176      * @dev Returns true if the value is in the set. O(1).
177      */
178     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
179         return _contains(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns the number of values in the set. O(1).
184      */
185     function length(Bytes32Set storage set) internal view returns (uint256) {
186         return _length(set._inner);
187     }
188 
189     /**
190      * @dev Returns the value stored at position `index` in the set. O(1).
191      *
192      * Note that there are no guarantees on the ordering of values inside the
193      * array, and it may change when more values are added or removed.
194      *
195      * Requirements:
196      *
197      * - `index` must be strictly less than {length}.
198      */
199     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
200         return _at(set._inner, index);
201     }
202 
203     /**
204      * @dev Return the entire set in an array
205      *
206      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
207      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
208      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
209      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
210      */
211     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
212         return _values(set._inner);
213     }
214 
215     // AddressSet
216 
217     struct AddressSet {
218         Set _inner;
219     }
220 
221     /**
222      * @dev Add a value to a set. O(1).
223      *
224      * Returns true if the value was added to the set, that is if it was not
225      * already present.
226      */
227     function add(AddressSet storage set, address value) internal returns (bool) {
228         return _add(set._inner, bytes32(uint256(uint160(value))));
229     }
230 
231     /**
232      * @dev Removes a value from a set. O(1).
233      *
234      * Returns true if the value was removed from the set, that is if it was
235      * present.
236      */
237     function remove(AddressSet storage set, address value) internal returns (bool) {
238         return _remove(set._inner, bytes32(uint256(uint160(value))));
239     }
240 
241     /**
242      * @dev Returns true if the value is in the set. O(1).
243      */
244     function contains(AddressSet storage set, address value) internal view returns (bool) {
245         return _contains(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns the number of values in the set. O(1).
250      */
251     function length(AddressSet storage set) internal view returns (uint256) {
252         return _length(set._inner);
253     }
254 
255     /**
256      * @dev Returns the value stored at position `index` in the set. O(1).
257      *
258      * Note that there are no guarantees on the ordering of values inside the
259      * array, and it may change when more values are added or removed.
260      *
261      * Requirements:
262      *
263      * - `index` must be strictly less than {length}.
264      */
265     function at(AddressSet storage set, uint256 index) internal view returns (address) {
266         return address(uint160(uint256(_at(set._inner, index))));
267     }
268 
269     /**
270      * @dev Return the entire set in an array
271      *
272      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
273      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
274      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
275      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
276      */
277     function values(AddressSet storage set) internal view returns (address[] memory) {
278         bytes32[] memory store = _values(set._inner);
279         address[] memory result;
280 
281         assembly {
282             result := store
283         }
284 
285         return result;
286     }
287 
288     // UintSet
289 
290     struct UintSet {
291         Set _inner;
292     }
293 
294     /**
295      * @dev Add a value to a set. O(1).
296      *
297      * Returns true if the value was added to the set, that is if it was not
298      * already present.
299      */
300     function add(UintSet storage set, uint256 value) internal returns (bool) {
301         return _add(set._inner, bytes32(value));
302     }
303 
304     /**
305      * @dev Removes a value from a set. O(1).
306      *
307      * Returns true if the value was removed from the set, that is if it was
308      * present.
309      */
310     function remove(UintSet storage set, uint256 value) internal returns (bool) {
311         return _remove(set._inner, bytes32(value));
312     }
313 
314     /**
315      * @dev Returns true if the value is in the set. O(1).
316      */
317     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
318         return _contains(set._inner, bytes32(value));
319     }
320 
321     /**
322      * @dev Returns the number of values on the set. O(1).
323      */
324     function length(UintSet storage set) internal view returns (uint256) {
325         return _length(set._inner);
326     }
327 
328     /**
329      * @dev Returns the value stored at position `index` in the set. O(1).
330      *
331      * Note that there are no guarantees on the ordering of values inside the
332      * array, and it may change when more values are added or removed.
333      *
334      * Requirements:
335      *
336      * - `index` must be strictly less than {length}.
337      */
338     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
339         return uint256(_at(set._inner, index));
340     }
341 
342     /**
343      * @dev Return the entire set in an array
344      *
345      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
346      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
347      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
348      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
349      */
350     function values(UintSet storage set) internal view returns (uint256[] memory) {
351         bytes32[] memory store = _values(set._inner);
352         uint256[] memory result;
353 
354         assembly {
355             result := store
356         }
357 
358         return result;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Contract module that helps prevent reentrant calls to a function.
371  *
372  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
373  * available, which can be applied to functions to make sure there are no nested
374  * (reentrant) calls to them.
375  *
376  * Note that because there is a single `nonReentrant` guard, functions marked as
377  * `nonReentrant` may not call one another. This can be worked around by making
378  * those functions `private`, and then adding `external` `nonReentrant` entry
379  * points to them.
380  *
381  * TIP: If you would like to learn more about reentrancy and alternative ways
382  * to protect against it, check out our blog post
383  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
384  */
385 abstract contract ReentrancyGuard {
386     // Booleans are more expensive than uint256 or any type that takes up a full
387     // word because each write operation emits an extra SLOAD to first read the
388     // slot's contents, replace the bits taken up by the boolean, and then write
389     // back. This is the compiler's defense against contract upgrades and
390     // pointer aliasing, and it cannot be disabled.
391 
392     // The values being non-zero value makes deployment a bit more expensive,
393     // but in exchange the refund on every call to nonReentrant will be lower in
394     // amount. Since refunds are capped to a percentage of the total
395     // transaction's gas, it is best to keep them low in cases like this one, to
396     // increase the likelihood of the full refund coming into effect.
397     uint256 private constant _NOT_ENTERED = 1;
398     uint256 private constant _ENTERED = 2;
399 
400     uint256 private _status;
401 
402     constructor() {
403         _status = _NOT_ENTERED;
404     }
405 
406     /**
407      * @dev Prevents a contract from calling itself, directly or indirectly.
408      * Calling a `nonReentrant` function from another `nonReentrant`
409      * function is not supported. It is possible to prevent this from happening
410      * by making the `nonReentrant` function external, and making it call a
411      * `private` function that does the actual work.
412      */
413     modifier nonReentrant() {
414         // On the first call to nonReentrant, _notEntered will be true
415         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
416 
417         // Any calls to nonReentrant after this point will fail
418         _status = _ENTERED;
419 
420         _;
421 
422         // By storing the original value once again, a refund is triggered (see
423         // https://eips.ethereum.org/EIPS/eip-2200)
424         _status = _NOT_ENTERED;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
429 
430 
431 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC20 standard as defined in the EIP.
437  */
438 interface IERC20 {
439     /**
440      * @dev Returns the amount of tokens in existence.
441      */
442     function totalSupply() external view returns (uint256);
443 
444     /**
445      * @dev Returns the amount of tokens owned by `account`.
446      */
447     function balanceOf(address account) external view returns (uint256);
448 
449     /**
450      * @dev Moves `amount` tokens from the caller's account to `to`.
451      *
452      * Returns a boolean value indicating whether the operation succeeded.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transfer(address to, uint256 amount) external returns (bool);
457 
458     /**
459      * @dev Returns the remaining number of tokens that `spender` will be
460      * allowed to spend on behalf of `owner` through {transferFrom}. This is
461      * zero by default.
462      *
463      * This value changes when {approve} or {transferFrom} are called.
464      */
465     function allowance(address owner, address spender) external view returns (uint256);
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
469      *
470      * Returns a boolean value indicating whether the operation succeeded.
471      *
472      * IMPORTANT: Beware that changing an allowance with this method brings the risk
473      * that someone may use both the old and the new allowance by unfortunate
474      * transaction ordering. One possible solution to mitigate this race
475      * condition is to first reduce the spender's allowance to 0 and set the
476      * desired value afterwards:
477      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
478      *
479      * Emits an {Approval} event.
480      */
481     function approve(address spender, uint256 amount) external returns (bool);
482 
483     /**
484      * @dev Moves `amount` tokens from `from` to `to` using the
485      * allowance mechanism. `amount` is then deducted from the caller's
486      * allowance.
487      *
488      * Returns a boolean value indicating whether the operation succeeded.
489      *
490      * Emits a {Transfer} event.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 amount
496     ) external returns (bool);
497 
498     /**
499      * @dev Emitted when `value` tokens are moved from one account (`from`) to
500      * another (`to`).
501      *
502      * Note that `value` may be zero.
503      */
504     event Transfer(address indexed from, address indexed to, uint256 value);
505 
506     /**
507      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
508      * a call to {approve}. `value` is the new allowance.
509      */
510     event Approval(address indexed owner, address indexed spender, uint256 value);
511 }
512 
513 // File: @openzeppelin/contracts/utils/Context.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Provides information about the current execution context, including the
522  * sender of the transaction and its data. While these are generally available
523  * via msg.sender and msg.data, they should not be accessed in such a direct
524  * manner, since when dealing with meta-transactions the account sending and
525  * paying for execution may not be the actual sender (as far as an application
526  * is concerned).
527  *
528  * This contract is only required for intermediate, library-like contracts.
529  */
530 abstract contract Context {
531     function _msgSender() internal view virtual returns (address) {
532         return msg.sender;
533     }
534 
535     function _msgData() internal view virtual returns (bytes calldata) {
536         return msg.data;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/Ownable.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an owner) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the owner account will be the one that deploys the contract. This
554  * can later be changed with {transferOwnership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyOwner`, which can be applied to your functions to restrict their use to
558  * the owner.
559  */
560 abstract contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
564 
565     /**
566      * @dev Initializes the contract setting the deployer as the initial owner.
567      */
568     constructor() {
569         _transferOwnership(_msgSender());
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(owner() == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 // File: @openzeppelin/contracts/utils/Address.sol
619 
620 
621 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
622 
623 pragma solidity ^0.8.1;
624 
625 /**
626  * @dev Collection of functions related to the address type
627  */
628 library Address {
629     /**
630      * @dev Returns true if `account` is a contract.
631      *
632      * [IMPORTANT]
633      * ====
634      * It is unsafe to assume that an address for which this function returns
635      * false is an externally-owned account (EOA) and not a contract.
636      *
637      * Among others, `isContract` will return false for the following
638      * types of addresses:
639      *
640      *  - an externally-owned account
641      *  - a contract in construction
642      *  - an address where a contract will be created
643      *  - an address where a contract lived, but was destroyed
644      * ====
645      *
646      * [IMPORTANT]
647      * ====
648      * You shouldn't rely on `isContract` to protect against flash loan attacks!
649      *
650      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
651      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
652      * constructor.
653      * ====
654      */
655     function isContract(address account) internal view returns (bool) {
656         // This method relies on extcodesize/address.code.length, which returns 0
657         // for contracts in construction, since the code is only stored at the end
658         // of the constructor execution.
659 
660         return account.code.length > 0;
661     }
662 
663     /**
664      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
665      * `recipient`, forwarding all available gas and reverting on errors.
666      *
667      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
668      * of certain opcodes, possibly making contracts go over the 2300 gas limit
669      * imposed by `transfer`, making them unable to receive funds via
670      * `transfer`. {sendValue} removes this limitation.
671      *
672      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
673      *
674      * IMPORTANT: because control is transferred to `recipient`, care must be
675      * taken to not create reentrancy vulnerabilities. Consider using
676      * {ReentrancyGuard} or the
677      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
678      */
679     function sendValue(address payable recipient, uint256 amount) internal {
680         require(address(this).balance >= amount, "Address: insufficient balance");
681 
682         (bool success, ) = recipient.call{value: amount}("");
683         require(success, "Address: unable to send value, recipient may have reverted");
684     }
685 
686     /**
687      * @dev Performs a Solidity function call using a low level `call`. A
688      * plain `call` is an unsafe replacement for a function call: use this
689      * function instead.
690      *
691      * If `target` reverts with a revert reason, it is bubbled up by this
692      * function (like regular Solidity function calls).
693      *
694      * Returns the raw returned data. To convert to the expected return value,
695      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
696      *
697      * Requirements:
698      *
699      * - `target` must be a contract.
700      * - calling `target` with `data` must not revert.
701      *
702      * _Available since v3.1._
703      */
704     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
705         return functionCall(target, data, "Address: low-level call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
710      * `errorMessage` as a fallback revert reason when `target` reverts.
711      *
712      * _Available since v3.1._
713      */
714     function functionCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         return functionCallWithValue(target, data, 0, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but also transferring `value` wei to `target`.
725      *
726      * Requirements:
727      *
728      * - the calling contract must have an ETH balance of at least `value`.
729      * - the called Solidity function must be `payable`.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value
737     ) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
743      * with `errorMessage` as a fallback revert reason when `target` reverts.
744      *
745      * _Available since v3.1._
746      */
747     function functionCallWithValue(
748         address target,
749         bytes memory data,
750         uint256 value,
751         string memory errorMessage
752     ) internal returns (bytes memory) {
753         require(address(this).balance >= value, "Address: insufficient balance for call");
754         require(isContract(target), "Address: call to non-contract");
755 
756         (bool success, bytes memory returndata) = target.call{value: value}(data);
757         return verifyCallResult(success, returndata, errorMessage);
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
762      * but performing a static call.
763      *
764      * _Available since v3.3._
765      */
766     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
767         return functionStaticCall(target, data, "Address: low-level static call failed");
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
772      * but performing a static call.
773      *
774      * _Available since v3.3._
775      */
776     function functionStaticCall(
777         address target,
778         bytes memory data,
779         string memory errorMessage
780     ) internal view returns (bytes memory) {
781         require(isContract(target), "Address: static call to non-contract");
782 
783         (bool success, bytes memory returndata) = target.staticcall(data);
784         return verifyCallResult(success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
794         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal returns (bytes memory) {
808         require(isContract(target), "Address: delegate call to non-contract");
809 
810         (bool success, bytes memory returndata) = target.delegatecall(data);
811         return verifyCallResult(success, returndata, errorMessage);
812     }
813 
814     /**
815      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
816      * revert reason using the provided one.
817      *
818      * _Available since v4.3._
819      */
820     function verifyCallResult(
821         bool success,
822         bytes memory returndata,
823         string memory errorMessage
824     ) internal pure returns (bytes memory) {
825         if (success) {
826             return returndata;
827         } else {
828             // Look for revert reason and bubble it up if present
829             if (returndata.length > 0) {
830                 // The easiest way to bubble the revert reason is using memory via assembly
831 
832                 assembly {
833                     let returndata_size := mload(returndata)
834                     revert(add(32, returndata), returndata_size)
835                 }
836             } else {
837                 revert(errorMessage);
838             }
839         }
840     }
841 }
842 
843 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
844 
845 
846 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @dev Interface of the ERC165 standard, as defined in the
852  * https://eips.ethereum.org/EIPS/eip-165[EIP].
853  *
854  * Implementers can declare support of contract interfaces, which can then be
855  * queried by others ({ERC165Checker}).
856  *
857  * For an implementation, see {ERC165}.
858  */
859 interface IERC165 {
860     /**
861      * @dev Returns true if this contract implements the interface defined by
862      * `interfaceId`. See the corresponding
863      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
864      * to learn more about how these ids are created.
865      *
866      * This function call must use less than 30 000 gas.
867      */
868     function supportsInterface(bytes4 interfaceId) external view returns (bool);
869 }
870 
871 // File: @manifoldxyz/libraries-solidity/contracts/access/IAdminControl.sol
872 
873 
874 
875 pragma solidity ^0.8.0;
876 
877 /// @author: manifold.xyz
878 
879 
880 /**
881  * @dev Interface for admin control
882  */
883 interface IAdminControl is IERC165 {
884 
885     event AdminApproved(address indexed account, address indexed sender);
886     event AdminRevoked(address indexed account, address indexed sender);
887 
888     /**
889      * @dev gets address of all admins
890      */
891     function getAdmins() external view returns (address[] memory);
892 
893     /**
894      * @dev add an admin.  Can only be called by contract owner.
895      */
896     function approveAdmin(address admin) external;
897 
898     /**
899      * @dev remove an admin.  Can only be called by contract owner.
900      */
901     function revokeAdmin(address admin) external;
902 
903     /**
904      * @dev checks whether or not given address is an admin
905      * Returns True if they are
906      */
907     function isAdmin(address admin) external view returns (bool);
908 
909 }
910 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
911 
912 
913 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 
918 /**
919  * @dev Implementation of the {IERC165} interface.
920  *
921  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
922  * for the additional interface id that will be supported. For example:
923  *
924  * ```solidity
925  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
926  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
927  * }
928  * ```
929  *
930  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
931  */
932 abstract contract ERC165 is IERC165 {
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
937         return interfaceId == type(IERC165).interfaceId;
938     }
939 }
940 
941 // File: @manifoldxyz/libraries-solidity/contracts/access/AdminControl.sol
942 
943 
944 
945 pragma solidity ^0.8.0;
946 
947 
948 
949 
950 
951 
952 
953 abstract contract AdminControl is Ownable, IAdminControl, ERC165 {
954     using EnumerableSet for EnumerableSet.AddressSet;
955 
956     // Track registered admins
957     EnumerableSet.AddressSet private _admins;
958 
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
963         return interfaceId == type(IAdminControl).interfaceId
964             || super.supportsInterface(interfaceId);
965     }
966 
967     /**
968      * @dev Only allows approved admins to call the specified function
969      */
970     modifier adminRequired() {
971         require(owner() == msg.sender || _admins.contains(msg.sender), "AdminControl: Must be owner or admin");
972         _;
973     }   
974 
975     /**
976      * @dev See {IAdminControl-getAdmins}.
977      */
978     function getAdmins() external view override returns (address[] memory admins) {
979         admins = new address[](_admins.length());
980         for (uint i = 0; i < _admins.length(); i++) {
981             admins[i] = _admins.at(i);
982         }
983         return admins;
984     }
985 
986     /**
987      * @dev See {IAdminControl-approveAdmin}.
988      */
989     function approveAdmin(address admin) external override onlyOwner {
990         if (!_admins.contains(admin)) {
991             emit AdminApproved(admin, msg.sender);
992             _admins.add(admin);
993         }
994     }
995 
996     /**
997      * @dev See {IAdminControl-revokeAdmin}.
998      */
999     function revokeAdmin(address admin) external override onlyOwner {
1000         if (_admins.contains(admin)) {
1001             emit AdminRevoked(admin, msg.sender);
1002             _admins.remove(admin);
1003         }
1004     }
1005 
1006     /**
1007      * @dev See {IAdminControl-isAdmin}.
1008      */
1009     function isAdmin(address admin) public override view returns (bool) {
1010         return (owner() == admin || _admins.contains(admin));
1011     }
1012 
1013 }
1014 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1015 
1016 
1017 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @dev _Available since v3.1._
1024  */
1025 interface IERC1155Receiver is IERC165 {
1026     /**
1027      * @dev Handles the receipt of a single ERC1155 token type. This function is
1028      * called at the end of a `safeTransferFrom` after the balance has been updated.
1029      *
1030      * NOTE: To accept the transfer, this must return
1031      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1032      * (i.e. 0xf23a6e61, or its own function selector).
1033      *
1034      * @param operator The address which initiated the transfer (i.e. msg.sender)
1035      * @param from The address which previously owned the token
1036      * @param id The ID of the token being transferred
1037      * @param value The amount of tokens being transferred
1038      * @param data Additional data with no specified format
1039      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1040      */
1041     function onERC1155Received(
1042         address operator,
1043         address from,
1044         uint256 id,
1045         uint256 value,
1046         bytes calldata data
1047     ) external returns (bytes4);
1048 
1049     /**
1050      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1051      * is called at the end of a `safeBatchTransferFrom` after the balances have
1052      * been updated.
1053      *
1054      * NOTE: To accept the transfer(s), this must return
1055      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1056      * (i.e. 0xbc197c81, or its own function selector).
1057      *
1058      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1059      * @param from The address which previously owned the token
1060      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1061      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1062      * @param data Additional data with no specified format
1063      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1064      */
1065     function onERC1155BatchReceived(
1066         address operator,
1067         address from,
1068         uint256[] calldata ids,
1069         uint256[] calldata values,
1070         bytes calldata data
1071     ) external returns (bytes4);
1072 }
1073 
1074 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1075 
1076 
1077 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 
1082 /**
1083  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1084  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1085  *
1086  * _Available since v3.1._
1087  */
1088 interface IERC1155 is IERC165 {
1089     /**
1090      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1091      */
1092     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1093 
1094     /**
1095      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1096      * transfers.
1097      */
1098     event TransferBatch(
1099         address indexed operator,
1100         address indexed from,
1101         address indexed to,
1102         uint256[] ids,
1103         uint256[] values
1104     );
1105 
1106     /**
1107      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1108      * `approved`.
1109      */
1110     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1111 
1112     /**
1113      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1114      *
1115      * If an {URI} event was emitted for `id`, the standard
1116      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1117      * returned by {IERC1155MetadataURI-uri}.
1118      */
1119     event URI(string value, uint256 indexed id);
1120 
1121     /**
1122      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1123      *
1124      * Requirements:
1125      *
1126      * - `account` cannot be the zero address.
1127      */
1128     function balanceOf(address account, uint256 id) external view returns (uint256);
1129 
1130     /**
1131      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1132      *
1133      * Requirements:
1134      *
1135      * - `accounts` and `ids` must have the same length.
1136      */
1137     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1138         external
1139         view
1140         returns (uint256[] memory);
1141 
1142     /**
1143      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1144      *
1145      * Emits an {ApprovalForAll} event.
1146      *
1147      * Requirements:
1148      *
1149      * - `operator` cannot be the caller.
1150      */
1151     function setApprovalForAll(address operator, bool approved) external;
1152 
1153     /**
1154      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1155      *
1156      * See {setApprovalForAll}.
1157      */
1158     function isApprovedForAll(address account, address operator) external view returns (bool);
1159 
1160     /**
1161      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1162      *
1163      * Emits a {TransferSingle} event.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1169      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1170      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1171      * acceptance magic value.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 id,
1177         uint256 amount,
1178         bytes calldata data
1179     ) external;
1180 
1181     /**
1182      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1183      *
1184      * Emits a {TransferBatch} event.
1185      *
1186      * Requirements:
1187      *
1188      * - `ids` and `amounts` must have the same length.
1189      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1190      * acceptance magic value.
1191      */
1192     function safeBatchTransferFrom(
1193         address from,
1194         address to,
1195         uint256[] calldata ids,
1196         uint256[] calldata amounts,
1197         bytes calldata data
1198     ) external;
1199 }
1200 
1201 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1202 
1203 
1204 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 /**
1210  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1211  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1212  *
1213  * _Available since v3.1._
1214  */
1215 interface IERC1155MetadataURI is IERC1155 {
1216     /**
1217      * @dev Returns the URI for token type `id`.
1218      *
1219      * If the `\{id\}` substring is present in the URI, it must be replaced by
1220      * clients with the actual token type ID.
1221      */
1222     function uri(uint256 id) external view returns (string memory);
1223 }
1224 
1225 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1226 
1227 
1228 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 
1234 
1235 
1236 
1237 
1238 /**
1239  * @dev Implementation of the basic standard multi-token.
1240  * See https://eips.ethereum.org/EIPS/eip-1155
1241  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1242  *
1243  * _Available since v3.1._
1244  */
1245 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1246     using Address for address;
1247 
1248     // Mapping from token ID to account balances
1249     mapping(uint256 => mapping(address => uint256)) private _balances;
1250 
1251     // Mapping from account to operator approvals
1252     mapping(address => mapping(address => bool)) private _operatorApprovals;
1253 
1254     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1255     string private _uri;
1256 
1257     /**
1258      * @dev See {_setURI}.
1259      */
1260     constructor(string memory uri_) {
1261         _setURI(uri_);
1262     }
1263 
1264     /**
1265      * @dev See {IERC165-supportsInterface}.
1266      */
1267     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1268         return
1269             interfaceId == type(IERC1155).interfaceId ||
1270             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1271             super.supportsInterface(interfaceId);
1272     }
1273 
1274     /**
1275      * @dev See {IERC1155MetadataURI-uri}.
1276      *
1277      * This implementation returns the same URI for *all* token types. It relies
1278      * on the token type ID substitution mechanism
1279      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1280      *
1281      * Clients calling this function must replace the `\{id\}` substring with the
1282      * actual token type ID.
1283      */
1284     function uri(uint256) public view virtual override returns (string memory) {
1285         return _uri;
1286     }
1287 
1288     /**
1289      * @dev See {IERC1155-balanceOf}.
1290      *
1291      * Requirements:
1292      *
1293      * - `account` cannot be the zero address.
1294      */
1295     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1296         require(account != address(0), "ERC1155: balance query for the zero address");
1297         return _balances[id][account];
1298     }
1299 
1300     /**
1301      * @dev See {IERC1155-balanceOfBatch}.
1302      *
1303      * Requirements:
1304      *
1305      * - `accounts` and `ids` must have the same length.
1306      */
1307     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1308         public
1309         view
1310         virtual
1311         override
1312         returns (uint256[] memory)
1313     {
1314         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1315 
1316         uint256[] memory batchBalances = new uint256[](accounts.length);
1317 
1318         for (uint256 i = 0; i < accounts.length; ++i) {
1319             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1320         }
1321 
1322         return batchBalances;
1323     }
1324 
1325     /**
1326      * @dev See {IERC1155-setApprovalForAll}.
1327      */
1328     function setApprovalForAll(address operator, bool approved) public virtual override {
1329         _setApprovalForAll(_msgSender(), operator, approved);
1330     }
1331 
1332     /**
1333      * @dev See {IERC1155-isApprovedForAll}.
1334      */
1335     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1336         return _operatorApprovals[account][operator];
1337     }
1338 
1339     /**
1340      * @dev See {IERC1155-safeTransferFrom}.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 id,
1346         uint256 amount,
1347         bytes memory data
1348     ) public virtual override {
1349         require(
1350             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1351             "ERC1155: caller is not owner nor approved"
1352         );
1353         _safeTransferFrom(from, to, id, amount, data);
1354     }
1355 
1356     /**
1357      * @dev See {IERC1155-safeBatchTransferFrom}.
1358      */
1359     function safeBatchTransferFrom(
1360         address from,
1361         address to,
1362         uint256[] memory ids,
1363         uint256[] memory amounts,
1364         bytes memory data
1365     ) public virtual override {
1366         require(
1367             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1368             "ERC1155: transfer caller is not owner nor approved"
1369         );
1370         _safeBatchTransferFrom(from, to, ids, amounts, data);
1371     }
1372 
1373     /**
1374      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1375      *
1376      * Emits a {TransferSingle} event.
1377      *
1378      * Requirements:
1379      *
1380      * - `to` cannot be the zero address.
1381      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1382      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1383      * acceptance magic value.
1384      */
1385     function _safeTransferFrom(
1386         address from,
1387         address to,
1388         uint256 id,
1389         uint256 amount,
1390         bytes memory data
1391     ) internal virtual {
1392         require(to != address(0), "ERC1155: transfer to the zero address");
1393 
1394         address operator = _msgSender();
1395 
1396         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1397 
1398         uint256 fromBalance = _balances[id][from];
1399         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1400         unchecked {
1401             _balances[id][from] = fromBalance - amount;
1402         }
1403         _balances[id][to] += amount;
1404 
1405         emit TransferSingle(operator, from, to, id, amount);
1406 
1407         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1408     }
1409 
1410     /**
1411      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1412      *
1413      * Emits a {TransferBatch} event.
1414      *
1415      * Requirements:
1416      *
1417      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1418      * acceptance magic value.
1419      */
1420     function _safeBatchTransferFrom(
1421         address from,
1422         address to,
1423         uint256[] memory ids,
1424         uint256[] memory amounts,
1425         bytes memory data
1426     ) internal virtual {
1427         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1428         require(to != address(0), "ERC1155: transfer to the zero address");
1429 
1430         address operator = _msgSender();
1431 
1432         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1433 
1434         for (uint256 i = 0; i < ids.length; ++i) {
1435             uint256 id = ids[i];
1436             uint256 amount = amounts[i];
1437 
1438             uint256 fromBalance = _balances[id][from];
1439             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1440             unchecked {
1441                 _balances[id][from] = fromBalance - amount;
1442             }
1443             _balances[id][to] += amount;
1444         }
1445 
1446         emit TransferBatch(operator, from, to, ids, amounts);
1447 
1448         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1449     }
1450 
1451     /**
1452      * @dev Sets a new URI for all token types, by relying on the token type ID
1453      * substitution mechanism
1454      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1455      *
1456      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1457      * URI or any of the amounts in the JSON file at said URI will be replaced by
1458      * clients with the token type ID.
1459      *
1460      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1461      * interpreted by clients as
1462      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1463      * for token type ID 0x4cce0.
1464      *
1465      * See {uri}.
1466      *
1467      * Because these URIs cannot be meaningfully represented by the {URI} event,
1468      * this function emits no events.
1469      */
1470     function _setURI(string memory newuri) internal virtual {
1471         _uri = newuri;
1472     }
1473 
1474     /**
1475      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1476      *
1477      * Emits a {TransferSingle} event.
1478      *
1479      * Requirements:
1480      *
1481      * - `to` cannot be the zero address.
1482      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1483      * acceptance magic value.
1484      */
1485     function _mint(
1486         address to,
1487         uint256 id,
1488         uint256 amount,
1489         bytes memory data
1490     ) internal virtual {
1491         require(to != address(0), "ERC1155: mint to the zero address");
1492 
1493         address operator = _msgSender();
1494 
1495         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1496 
1497         _balances[id][to] += amount;
1498         emit TransferSingle(operator, address(0), to, id, amount);
1499 
1500         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1501     }
1502 
1503     /**
1504      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1505      *
1506      * Requirements:
1507      *
1508      * - `ids` and `amounts` must have the same length.
1509      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1510      * acceptance magic value.
1511      */
1512     function _mintBatch(
1513         address to,
1514         uint256[] memory ids,
1515         uint256[] memory amounts,
1516         bytes memory data
1517     ) internal virtual {
1518         require(to != address(0), "ERC1155: mint to the zero address");
1519         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1520 
1521         address operator = _msgSender();
1522 
1523         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1524 
1525         for (uint256 i = 0; i < ids.length; i++) {
1526             _balances[ids[i]][to] += amounts[i];
1527         }
1528 
1529         emit TransferBatch(operator, address(0), to, ids, amounts);
1530 
1531         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1532     }
1533 
1534     /**
1535      * @dev Destroys `amount` tokens of token type `id` from `from`
1536      *
1537      * Requirements:
1538      *
1539      * - `from` cannot be the zero address.
1540      * - `from` must have at least `amount` tokens of token type `id`.
1541      */
1542     function _burn(
1543         address from,
1544         uint256 id,
1545         uint256 amount
1546     ) internal virtual {
1547         require(from != address(0), "ERC1155: burn from the zero address");
1548 
1549         address operator = _msgSender();
1550 
1551         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1552 
1553         uint256 fromBalance = _balances[id][from];
1554         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1555         unchecked {
1556             _balances[id][from] = fromBalance - amount;
1557         }
1558 
1559         emit TransferSingle(operator, from, address(0), id, amount);
1560     }
1561 
1562     /**
1563      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1564      *
1565      * Requirements:
1566      *
1567      * - `ids` and `amounts` must have the same length.
1568      */
1569     function _burnBatch(
1570         address from,
1571         uint256[] memory ids,
1572         uint256[] memory amounts
1573     ) internal virtual {
1574         require(from != address(0), "ERC1155: burn from the zero address");
1575         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1576 
1577         address operator = _msgSender();
1578 
1579         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1580 
1581         for (uint256 i = 0; i < ids.length; i++) {
1582             uint256 id = ids[i];
1583             uint256 amount = amounts[i];
1584 
1585             uint256 fromBalance = _balances[id][from];
1586             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1587             unchecked {
1588                 _balances[id][from] = fromBalance - amount;
1589             }
1590         }
1591 
1592         emit TransferBatch(operator, from, address(0), ids, amounts);
1593     }
1594 
1595     /**
1596      * @dev Approve `operator` to operate on all of `owner` tokens
1597      *
1598      * Emits a {ApprovalForAll} event.
1599      */
1600     function _setApprovalForAll(
1601         address owner,
1602         address operator,
1603         bool approved
1604     ) internal virtual {
1605         require(owner != operator, "ERC1155: setting approval status for self");
1606         _operatorApprovals[owner][operator] = approved;
1607         emit ApprovalForAll(owner, operator, approved);
1608     }
1609 
1610     /**
1611      * @dev Hook that is called before any token transfer. This includes minting
1612      * and burning, as well as batched variants.
1613      *
1614      * The same hook is called on both single and batched variants. For single
1615      * transfers, the length of the `id` and `amount` arrays will be 1.
1616      *
1617      * Calling conditions (for each `id` and `amount` pair):
1618      *
1619      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1620      * of token type `id` will be  transferred to `to`.
1621      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1622      * for `to`.
1623      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1624      * will be burned.
1625      * - `from` and `to` are never both zero.
1626      * - `ids` and `amounts` have the same, non-zero length.
1627      *
1628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1629      */
1630     function _beforeTokenTransfer(
1631         address operator,
1632         address from,
1633         address to,
1634         uint256[] memory ids,
1635         uint256[] memory amounts,
1636         bytes memory data
1637     ) internal virtual {}
1638 
1639     function _doSafeTransferAcceptanceCheck(
1640         address operator,
1641         address from,
1642         address to,
1643         uint256 id,
1644         uint256 amount,
1645         bytes memory data
1646     ) private {
1647         if (to.isContract()) {
1648             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1649                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1650                     revert("ERC1155: ERC1155Receiver rejected tokens");
1651                 }
1652             } catch Error(string memory reason) {
1653                 revert(reason);
1654             } catch {
1655                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1656             }
1657         }
1658     }
1659 
1660     function _doSafeBatchTransferAcceptanceCheck(
1661         address operator,
1662         address from,
1663         address to,
1664         uint256[] memory ids,
1665         uint256[] memory amounts,
1666         bytes memory data
1667     ) private {
1668         if (to.isContract()) {
1669             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1670                 bytes4 response
1671             ) {
1672                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1673                     revert("ERC1155: ERC1155Receiver rejected tokens");
1674                 }
1675             } catch Error(string memory reason) {
1676                 revert(reason);
1677             } catch {
1678                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1679             }
1680         }
1681     }
1682 
1683     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1684         uint256[] memory array = new uint256[](1);
1685         array[0] = element;
1686 
1687         return array;
1688     }
1689 }
1690 
1691 // File: contracts/1_Storage.sol
1692 
1693 
1694 pragma solidity >=0.7.0 <0.9.0;
1695                                                                           
1696 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1697 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1698 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1699 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1700 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1701 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1702 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1703 //@@@@@@@@@@@@@@@@@@@@@@@@@@&%%###%%@@@@@@@@@@@&%%%%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1704 //@@@@@@@@@@@@@@@@@@@@&#(//***,,,,,**//(#%#(//***,,,***//(#%@@@@@@@@@@@@@@@@@@@@@@
1705 //@@@@@@@@@@@@@@@@@&#(/*,...         ..,,*,,..        ...,,*/(%@@@@@@@@@@@@@@@@@@@
1706 //@@@@@@@@@@@@@@@@#/*,..       ..        .                 .,*/(%@@@@@@@@@@@@@@@@@
1707 //@@@@@@@@@@@@@@%(/,..    .,,******,,..     ..,******,,..    .,*/#@@@@@@@@@@@@@@@@
1708 //@@@@@@@@@@@@@&(/,.    .,*/(%@@@@%#(/*,...,*/(#&@@@%#(/,.    .,*(#@@@@@@@@@@@@@@@
1709 //@@@@@@@@@@@@@%(*,.   .,*(%@@@@@@@@@&#(**/(#@@@@@@@@@@#/*.    .,/(&@@@@@@@@@@@@@@
1710 //@@@@@@@@@@@@@%(*,.   .,*/#@@@@@@@@@@@@%(%@@@@@@@@@@@@#/*.    .,/(@@@@@@@@@@@@@@@
1711 //@@@@@@@@@@@@@@#/*..   .,*/(%@@@@@@@@@@@@@@@@@@@@@@@#(/,..   .,*(#@@@@@@@@@@@@@@@
1712 //@@@@@@@@@@@@@@&(/*,.    .,,/(#&@@@@@@@@@@@@@@@@@%#/*,..    .,*/#@@@@@@@@@@@@@@@@
1713 //@@@@@@@@@@@@@@@@#(*,..    ..,*/(%@@@@@@@@@@@@@#(/*,.     .,*/(%@@@@@@@@@@@@@@@@@
1714 //@@@@@@@@@@@@@@@@@@#(/*,.     .,*/(#&@@@@@@@%#/*,..     .,*/(#@@@@@@@@@@@@@@@@@@@
1715 //@@@@@@@@@@@@@@@@@@@@%(/*,..    ..,*/(%@@@#(/*,.     .,,*/#&@@@@@@@@@@@@@@@@@@@@@
1716 //@@@@@@@@@@@@@@@@@@@@@@@#(/*,.     .,,/(#/*,..     .,*/(#@@@@@@@@@@@@@@@@@@@@@@@@
1717 //@@@@@@@@@@@@@@@@@@@@@@@@@%(/*,..    ..,*,.     ..,*/#&@@@@@@@@@@@@@@@@@@@@@@@@@@
1718 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(/*,.     .     .,*/(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1719 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(/*,..     .,,*(#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1720 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(/*,. .,*/(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1721 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(/*,*(#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1722 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1723 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1724 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1725 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1726 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1727 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1728 
1729 // @creator: Y4SI
1730 // @dev:CardoLove.eth 
1731 
1732 contract LoveIsInTheAir is ERC1155, AdminControl, ReentrancyGuard {
1733 
1734     address public ASH_CONTRACT = 0x64D91f12Ece7362F91A6f8E7940Cd55F05060b92;
1735     
1736     address payable private _royaltyRecipient;
1737     uint256 private _royaltyBps;
1738 
1739     uint256 public PRICE = 7*10**18; // 7 ASH
1740     uint256 public MAX_MINTS = 333;
1741     uint256 public supply;
1742     uint256 public eventCounter;
1743 
1744     uint256[] public tokenIds = [1,2,3,4,5];
1745 
1746     bool public activeSale;
1747     bool public activeGift;
1748     bool public activeBurn;
1749     
1750     mapping(address => uint256) public mints;
1751     mapping(address => uint256) public GL;
1752     mapping(address => bool) public WL;
1753     mapping(uint256 => bool) private bonus;
1754     mapping(uint256 => string) private metadata;
1755 
1756     constructor() ERC1155("") {
1757         _royaltyRecipient = payable(msg.sender);
1758         _royaltyBps = 1000;
1759     }
1760 
1761     function supportsInterface(bytes4 interfaceId) 
1762         public 
1763         view 
1764         virtual 
1765         override(AdminControl, ERC1155) 
1766         returns (bool) 
1767     {
1768         return 
1769             ERC1155.supportsInterface(interfaceId) 
1770             || AdminControl.supportsInterface(interfaceId) 
1771             || interfaceId == 0x2a55205a 
1772             || super.supportsInterface(interfaceId);
1773     }
1774     
1775     function mintLove(uint256 amount, uint256 quantity) external {
1776         require(activeSale, "Sale is not active");
1777         require(quantity > 0, "Must mint more than zero");
1778         require((supply + quantity) <= MAX_MINTS, "The quantity of mints surpasses the max");
1779         require(amount == (quantity * PRICE), "Incorrect ASH amount for requested quantity");
1780         
1781         IERC20(ASH_CONTRACT).transferFrom(msg.sender, _royaltyRecipient, amount);
1782 
1783         mint(msg.sender, quantity);
1784     }
1785 
1786     function gift(address account, uint256 tokenId) external {
1787         require(activeGift, "Gifting is not active");
1788         require(balanceOf(msg.sender, tokenId) > 0, "Insuffienct token balance");
1789         require(account != msg.sender, "You can not gift to yourself");
1790 
1791         safeTransferFrom(msg.sender, account, tokenId, 1, "");
1792 
1793         if (tokenId == 1) {
1794             _mint(msg.sender, 2, 1, "");
1795         }
1796 
1797         checkBonus(msg.sender);
1798     }
1799 
1800     function burnToMint(uint256 quantity) external {
1801         require(activeBurn, "Burning is not active");
1802         require(balanceOf(msg.sender, 2) >= quantity, "Insuffienct token balance");
1803 
1804         _burn(msg.sender, 2, quantity);
1805         _mint(msg.sender, 4, quantity, ""); 
1806 
1807         checkBonus(msg.sender);
1808     }
1809 
1810     function merge() external {
1811         require(
1812             balanceOf(msg.sender, 1) >= 0 
1813             && balanceOf(msg.sender, 2) >= 0 
1814             && balanceOf(msg.sender, 3) >= 0 
1815             && balanceOf(msg.sender, 4) >= 0,
1816             "Insuffienct token balance"
1817         );
1818 
1819         uint256[] memory amounts = new uint256[](5);
1820         amounts[0] = 1;
1821         amounts[1] = 1;
1822         amounts[2] = 1;
1823         amounts[3] = 1;
1824         amounts[4] = 0;
1825 
1826         _burnBatch(msg.sender, tokenIds, amounts);
1827         _mint(msg.sender, 5, 1, "");
1828     }
1829 
1830     function loveInTheAir(address[] calldata accounts, uint256[] calldata amounts, uint256 tokenId) 
1831         external 
1832         adminRequired 
1833     {
1834         for (uint256 i; i < accounts.length; i++) {
1835             _mint(accounts[i], tokenId, amounts[i], "");
1836         }
1837     }
1838 
1839     function togglePhase(uint256 phase) external adminRequired {
1840         if (phase == 1) {
1841             activeSale = !activeSale;
1842         } else if (phase == 2) {
1843             activeGift = !activeGift;
1844         } else {
1845             activeBurn = !activeBurn;
1846         }
1847     }
1848 
1849     function addGL(address[] calldata accounts, uint256[] calldata amounts) external adminRequired {
1850         for (uint256 i; i < accounts.length; i++) {
1851             GL[accounts[i]] = amounts[i];
1852         }
1853     }
1854 
1855     function addWL(address[] calldata accounts) external adminRequired {
1856         for (uint256 i; i < accounts.length; i++) {
1857             WL[accounts[i]] = true;
1858         }
1859     }
1860 
1861     function updateBonus(uint256[] calldata bonusEvents) external adminRequired {
1862         for (uint256 i; i < bonusEvents.length; i++) {
1863             bonus[bonusEvents[i]] = true;
1864         }
1865     }
1866 
1867     function updateURI(uint256 tokenId, string calldata _uri) external adminRequired {
1868         metadata[tokenId] = _uri; 
1869     }
1870 
1871     function updateRoyalties(address payable recipient, uint256 bps) external adminRequired {
1872         _royaltyRecipient = recipient;
1873         _royaltyBps = bps;
1874     }
1875 
1876     function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
1877         return (_royaltyRecipient, (value*_royaltyBps) / 10000);
1878     }
1879 
1880     function calcMints(address account, uint256 quantity) 
1881         public 
1882         view 
1883         returns (uint256 x, uint256 y, uint256 z) 
1884     {
1885         x = quantity;
1886         y = 0;
1887         z = 0;
1888 
1889         if (GL[account] > mints[account]) {
1890             uint256 remainingMints = GL[account] - mints[account];
1891             if (remainingMints >= quantity) {
1892                 y = quantity;
1893                 z = quantity;
1894             } else {
1895                 y = remainingMints;
1896                 z = remainingMints;
1897             }
1898         } else if (WL[account] && mints[account] < 2) {
1899             uint256 remainingMints = 2 - mints[account];
1900             if (remainingMints >= quantity) {
1901                 y = quantity;
1902             } else {
1903                 y = remainingMints;
1904             }
1905         }   
1906         return(x, y, z);
1907     }
1908 
1909     function uri(uint256 tokenId) public view virtual override returns (string memory) {
1910         return metadata[tokenId];
1911     }
1912 
1913     function mint(address account, uint256 quantity) internal {
1914         uint256[] memory amounts = new uint256[](5);
1915         (amounts[0], amounts[1], amounts[2]) = calcMints(account, quantity);
1916 
1917         _mintBatch(account, tokenIds, amounts, "");
1918 
1919         mints[account] += quantity;
1920         supply += quantity;
1921     }
1922 
1923     function checkBonus(address account) internal {
1924         if (bonus[eventCounter]) {
1925             _mint(account, 3, 1, "");
1926         }
1927         eventCounter++;
1928     }
1929 }