1 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library AddressUpgradeable {
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
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
168      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
169      *
170      * _Available since v4.8._
171      */
172     function verifyCallResultFromTarget(
173         address target,
174         bool success,
175         bytes memory returndata,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         if (success) {
179             if (returndata.length == 0) {
180                 // only check isContract if the call was successful and the return data is empty
181                 // otherwise we already know that it was a contract
182                 require(isContract(target), "Address: call to non-contract");
183             }
184             return returndata;
185         } else {
186             _revert(returndata, errorMessage);
187         }
188     }
189 
190     /**
191      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
192      * revert reason or using the provided one.
193      *
194      * _Available since v4.3._
195      */
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             _revert(returndata, errorMessage);
205         }
206     }
207 
208     function _revert(bytes memory returndata, string memory errorMessage) private pure {
209         // Look for revert reason and bubble it up if present
210         if (returndata.length > 0) {
211             // The easiest way to bubble the revert reason is using memory via assembly
212             /// @solidity memory-safe-assembly
213             assembly {
214                 let returndata_size := mload(returndata)
215                 revert(add(32, returndata), returndata_size)
216             }
217         } else {
218             revert(errorMessage);
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
224 
225 // OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)
226 
227 pragma solidity ^0.8.2;
228 
229 /**
230  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
231  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
232  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
233  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
234  *
235  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
236  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
237  * case an upgrade adds a module that needs to be initialized.
238  *
239  * For example:
240  *
241  * [.hljs-theme-light.nopadding]
242  * ```
243  * contract MyToken is ERC20Upgradeable {
244  *     function initialize() initializer public {
245  *         __ERC20_init("MyToken", "MTK");
246  *     }
247  * }
248  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
249  *     function initializeV2() reinitializer(2) public {
250  *         __ERC20Permit_init("MyToken");
251  *     }
252  * }
253  * ```
254  *
255  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
256  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
257  *
258  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
259  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
260  *
261  * [CAUTION]
262  * ====
263  * Avoid leaving a contract uninitialized.
264  *
265  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
266  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
267  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
268  *
269  * [.hljs-theme-light.nopadding]
270  * ```
271  * /// @custom:oz-upgrades-unsafe-allow constructor
272  * constructor() {
273  *     _disableInitializers();
274  * }
275  * ```
276  * ====
277  */
278 abstract contract Initializable {
279     /**
280      * @dev Indicates that the contract has been initialized.
281      * @custom:oz-retyped-from bool
282      */
283     uint8 private _initialized;
284 
285     /**
286      * @dev Indicates that the contract is in the process of being initialized.
287      */
288     bool private _initializing;
289 
290     /**
291      * @dev Triggered when the contract has been initialized or reinitialized.
292      */
293     event Initialized(uint8 version);
294 
295     /**
296      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
297      * `onlyInitializing` functions can be used to initialize parent contracts.
298      *
299      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
300      * constructor.
301      *
302      * Emits an {Initialized} event.
303      */
304     modifier initializer() {
305         bool isTopLevelCall = !_initializing;
306         require(
307             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
308             "Initializable: contract is already initialized"
309         );
310         _initialized = 1;
311         if (isTopLevelCall) {
312             _initializing = true;
313         }
314         _;
315         if (isTopLevelCall) {
316             _initializing = false;
317             emit Initialized(1);
318         }
319     }
320 
321     /**
322      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
323      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
324      * used to initialize parent contracts.
325      *
326      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
327      * are added through upgrades and that require initialization.
328      *
329      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
330      * cannot be nested. If one is invoked in the context of another, execution will revert.
331      *
332      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
333      * a contract, executing them in the right order is up to the developer or operator.
334      *
335      * WARNING: setting the version to 255 will prevent any future reinitialization.
336      *
337      * Emits an {Initialized} event.
338      */
339     modifier reinitializer(uint8 version) {
340         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
341         _initialized = version;
342         _initializing = true;
343         _;
344         _initializing = false;
345         emit Initialized(version);
346     }
347 
348     /**
349      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
350      * {initializer} and {reinitializer} modifiers, directly or indirectly.
351      */
352     modifier onlyInitializing() {
353         require(_initializing, "Initializable: contract is not initializing");
354         _;
355     }
356 
357     /**
358      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
359      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
360      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
361      * through proxies.
362      *
363      * Emits an {Initialized} event the first time it is successfully executed.
364      */
365     function _disableInitializers() internal virtual {
366         require(!_initializing, "Initializable: contract is initializing");
367         if (_initialized < type(uint8).max) {
368             _initialized = type(uint8).max;
369             emit Initialized(type(uint8).max);
370         }
371     }
372 
373     /**
374      * @dev Returns the highest version that has been initialized. See {reinitializer}.
375      */
376     function _getInitializedVersion() internal view returns (uint8) {
377         return _initialized;
378     }
379 
380     /**
381      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
382      */
383     function _isInitializing() internal view returns (bool) {
384         return _initializing;
385     }
386 }
387 
388 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 abstract contract ContextUpgradeable is Initializable {
405     function __Context_init() internal onlyInitializing {
406     }
407 
408     function __Context_init_unchained() internal onlyInitializing {
409     }
410     function _msgSender() internal view virtual returns (address) {
411         return msg.sender;
412     }
413 
414     function _msgData() internal view virtual returns (bytes calldata) {
415         return msg.data;
416     }
417 
418     /**
419      * @dev This empty reserved space is put in place to allow future versions to add new
420      * variables without shifting down storage in the inheritance chain.
421      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
422      */
423     uint256[50] private __gap;
424 }
425 
426 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
427 
428 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Contract module which provides a basic access control mechanism, where
435  * there is an account (an owner) that can be granted exclusive access to
436  * specific functions.
437  *
438  * By default, the owner account will be the one that deploys the contract. This
439  * can later be changed with {transferOwnership}.
440  *
441  * This module is used through inheritance. It will make available the modifier
442  * `onlyOwner`, which can be applied to your functions to restrict their use to
443  * the owner.
444  */
445 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
446     address private _owner;
447 
448     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
449 
450     /**
451      * @dev Initializes the contract setting the deployer as the initial owner.
452      */
453     function __Ownable_init() internal onlyInitializing {
454         __Ownable_init_unchained();
455     }
456 
457     function __Ownable_init_unchained() internal onlyInitializing {
458         _transferOwnership(_msgSender());
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         _checkOwner();
466         _;
467     }
468 
469     /**
470      * @dev Returns the address of the current owner.
471      */
472     function owner() public view virtual returns (address) {
473         return _owner;
474     }
475 
476     /**
477      * @dev Throws if the sender is not the owner.
478      */
479     function _checkOwner() internal view virtual {
480         require(owner() == _msgSender(), "Ownable: caller is not the owner");
481     }
482 
483     /**
484      * @dev Leaves the contract without owner. It will not be possible to call
485      * `onlyOwner` functions anymore. Can only be called by the current owner.
486      *
487      * NOTE: Renouncing ownership will leave the contract without an owner,
488      * thereby removing any functionality that is only available to the owner.
489      */
490     function renounceOwnership() public virtual onlyOwner {
491         _transferOwnership(address(0));
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         _transferOwnership(newOwner);
501     }
502 
503     /**
504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
505      * Internal function without access restriction.
506      */
507     function _transferOwnership(address newOwner) internal virtual {
508         address oldOwner = _owner;
509         _owner = newOwner;
510         emit OwnershipTransferred(oldOwner, newOwner);
511     }
512 
513     /**
514      * @dev This empty reserved space is put in place to allow future versions to add new
515      * variables without shifting down storage in the inheritance chain.
516      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
517      */
518     uint256[49] private __gap;
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
522 
523 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC20 standard as defined in the EIP.
529  */
530 interface IERC20 {
531     /**
532      * @dev Emitted when `value` tokens are moved from one account (`from`) to
533      * another (`to`).
534      *
535      * Note that `value` may be zero.
536      */
537     event Transfer(address indexed from, address indexed to, uint256 value);
538 
539     /**
540      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
541      * a call to {approve}. `value` is the new allowance.
542      */
543     event Approval(address indexed owner, address indexed spender, uint256 value);
544 
545     /**
546      * @dev Returns the amount of tokens in existence.
547      */
548     function totalSupply() external view returns (uint256);
549 
550     /**
551      * @dev Returns the amount of tokens owned by `account`.
552      */
553     function balanceOf(address account) external view returns (uint256);
554 
555     /**
556      * @dev Moves `amount` tokens from the caller's account to `to`.
557      *
558      * Returns a boolean value indicating whether the operation succeeded.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transfer(address to, uint256 amount) external returns (bool);
563 
564     /**
565      * @dev Returns the remaining number of tokens that `spender` will be
566      * allowed to spend on behalf of `owner` through {transferFrom}. This is
567      * zero by default.
568      *
569      * This value changes when {approve} or {transferFrom} are called.
570      */
571     function allowance(address owner, address spender) external view returns (uint256);
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
575      *
576      * Returns a boolean value indicating whether the operation succeeded.
577      *
578      * IMPORTANT: Beware that changing an allowance with this method brings the risk
579      * that someone may use both the old and the new allowance by unfortunate
580      * transaction ordering. One possible solution to mitigate this race
581      * condition is to first reduce the spender's allowance to 0 and set the
582      * desired value afterwards:
583      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address spender, uint256 amount) external returns (bool);
588 
589     /**
590      * @dev Moves `amount` tokens from `from` to `to` using the
591      * allowance mechanism. `amount` is then deducted from the caller's
592      * allowance.
593      *
594      * Returns a boolean value indicating whether the operation succeeded.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 amount
602     ) external returns (bool);
603 }
604 
605 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
606 
607 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
608 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Library for managing
614  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
615  * types.
616  *
617  * Sets have the following properties:
618  *
619  * - Elements are added, removed, and checked for existence in constant time
620  * (O(1)).
621  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
622  *
623  * ```
624  * contract Example {
625  *     // Add the library methods
626  *     using EnumerableSet for EnumerableSet.AddressSet;
627  *
628  *     // Declare a set state variable
629  *     EnumerableSet.AddressSet private mySet;
630  * }
631  * ```
632  *
633  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
634  * and `uint256` (`UintSet`) are supported.
635  *
636  * [WARNING]
637  * ====
638  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
639  * unusable.
640  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
641  *
642  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
643  * array of EnumerableSet.
644  * ====
645  */
646 library EnumerableSet {
647     // To implement this library for multiple types with as little code
648     // repetition as possible, we write it in terms of a generic Set type with
649     // bytes32 values.
650     // The Set implementation uses private functions, and user-facing
651     // implementations (such as AddressSet) are just wrappers around the
652     // underlying Set.
653     // This means that we can only create new EnumerableSets for types that fit
654     // in bytes32.
655 
656     struct Set {
657         // Storage of set values
658         bytes32[] _values;
659         // Position of the value in the `values` array, plus 1 because index 0
660         // means a value is not in the set.
661         mapping(bytes32 => uint256) _indexes;
662     }
663 
664     /**
665      * @dev Add a value to a set. O(1).
666      *
667      * Returns true if the value was added to the set, that is if it was not
668      * already present.
669      */
670     function _add(Set storage set, bytes32 value) private returns (bool) {
671         if (!_contains(set, value)) {
672             set._values.push(value);
673             // The value is stored at length-1, but we add 1 to all indexes
674             // and use 0 as a sentinel value
675             set._indexes[value] = set._values.length;
676             return true;
677         } else {
678             return false;
679         }
680     }
681 
682     /**
683      * @dev Removes a value from a set. O(1).
684      *
685      * Returns true if the value was removed from the set, that is if it was
686      * present.
687      */
688     function _remove(Set storage set, bytes32 value) private returns (bool) {
689         // We read and store the value's index to prevent multiple reads from the same storage slot
690         uint256 valueIndex = set._indexes[value];
691 
692         if (valueIndex != 0) {
693             // Equivalent to contains(set, value)
694             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
695             // the array, and then remove the last element (sometimes called as 'swap and pop').
696             // This modifies the order of the array, as noted in {at}.
697 
698             uint256 toDeleteIndex = valueIndex - 1;
699             uint256 lastIndex = set._values.length - 1;
700 
701             if (lastIndex != toDeleteIndex) {
702                 bytes32 lastValue = set._values[lastIndex];
703 
704                 // Move the last value to the index where the value to delete is
705                 set._values[toDeleteIndex] = lastValue;
706                 // Update the index for the moved value
707                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
708             }
709 
710             // Delete the slot where the moved value was stored
711             set._values.pop();
712 
713             // Delete the index for the deleted slot
714             delete set._indexes[value];
715 
716             return true;
717         } else {
718             return false;
719         }
720     }
721 
722     /**
723      * @dev Returns true if the value is in the set. O(1).
724      */
725     function _contains(Set storage set, bytes32 value) private view returns (bool) {
726         return set._indexes[value] != 0;
727     }
728 
729     /**
730      * @dev Returns the number of values on the set. O(1).
731      */
732     function _length(Set storage set) private view returns (uint256) {
733         return set._values.length;
734     }
735 
736     /**
737      * @dev Returns the value stored at position `index` in the set. O(1).
738      *
739      * Note that there are no guarantees on the ordering of values inside the
740      * array, and it may change when more values are added or removed.
741      *
742      * Requirements:
743      *
744      * - `index` must be strictly less than {length}.
745      */
746     function _at(Set storage set, uint256 index) private view returns (bytes32) {
747         return set._values[index];
748     }
749 
750     /**
751      * @dev Return the entire set in an array
752      *
753      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
754      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
755      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
756      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
757      */
758     function _values(Set storage set) private view returns (bytes32[] memory) {
759         return set._values;
760     }
761 
762     // Bytes32Set
763 
764     struct Bytes32Set {
765         Set _inner;
766     }
767 
768     /**
769      * @dev Add a value to a set. O(1).
770      *
771      * Returns true if the value was added to the set, that is if it was not
772      * already present.
773      */
774     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
775         return _add(set._inner, value);
776     }
777 
778     /**
779      * @dev Removes a value from a set. O(1).
780      *
781      * Returns true if the value was removed from the set, that is if it was
782      * present.
783      */
784     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
785         return _remove(set._inner, value);
786     }
787 
788     /**
789      * @dev Returns true if the value is in the set. O(1).
790      */
791     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
792         return _contains(set._inner, value);
793     }
794 
795     /**
796      * @dev Returns the number of values in the set. O(1).
797      */
798     function length(Bytes32Set storage set) internal view returns (uint256) {
799         return _length(set._inner);
800     }
801 
802     /**
803      * @dev Returns the value stored at position `index` in the set. O(1).
804      *
805      * Note that there are no guarantees on the ordering of values inside the
806      * array, and it may change when more values are added or removed.
807      *
808      * Requirements:
809      *
810      * - `index` must be strictly less than {length}.
811      */
812     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
813         return _at(set._inner, index);
814     }
815 
816     /**
817      * @dev Return the entire set in an array
818      *
819      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
820      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
821      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
822      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
823      */
824     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
825         bytes32[] memory store = _values(set._inner);
826         bytes32[] memory result;
827 
828         /// @solidity memory-safe-assembly
829         assembly {
830             result := store
831         }
832 
833         return result;
834     }
835 
836     // AddressSet
837 
838     struct AddressSet {
839         Set _inner;
840     }
841 
842     /**
843      * @dev Add a value to a set. O(1).
844      *
845      * Returns true if the value was added to the set, that is if it was not
846      * already present.
847      */
848     function add(AddressSet storage set, address value) internal returns (bool) {
849         return _add(set._inner, bytes32(uint256(uint160(value))));
850     }
851 
852     /**
853      * @dev Removes a value from a set. O(1).
854      *
855      * Returns true if the value was removed from the set, that is if it was
856      * present.
857      */
858     function remove(AddressSet storage set, address value) internal returns (bool) {
859         return _remove(set._inner, bytes32(uint256(uint160(value))));
860     }
861 
862     /**
863      * @dev Returns true if the value is in the set. O(1).
864      */
865     function contains(AddressSet storage set, address value) internal view returns (bool) {
866         return _contains(set._inner, bytes32(uint256(uint160(value))));
867     }
868 
869     /**
870      * @dev Returns the number of values in the set. O(1).
871      */
872     function length(AddressSet storage set) internal view returns (uint256) {
873         return _length(set._inner);
874     }
875 
876     /**
877      * @dev Returns the value stored at position `index` in the set. O(1).
878      *
879      * Note that there are no guarantees on the ordering of values inside the
880      * array, and it may change when more values are added or removed.
881      *
882      * Requirements:
883      *
884      * - `index` must be strictly less than {length}.
885      */
886     function at(AddressSet storage set, uint256 index) internal view returns (address) {
887         return address(uint160(uint256(_at(set._inner, index))));
888     }
889 
890     /**
891      * @dev Return the entire set in an array
892      *
893      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
894      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
895      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
896      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
897      */
898     function values(AddressSet storage set) internal view returns (address[] memory) {
899         bytes32[] memory store = _values(set._inner);
900         address[] memory result;
901 
902         /// @solidity memory-safe-assembly
903         assembly {
904             result := store
905         }
906 
907         return result;
908     }
909 
910     // UintSet
911 
912     struct UintSet {
913         Set _inner;
914     }
915 
916     /**
917      * @dev Add a value to a set. O(1).
918      *
919      * Returns true if the value was added to the set, that is if it was not
920      * already present.
921      */
922     function add(UintSet storage set, uint256 value) internal returns (bool) {
923         return _add(set._inner, bytes32(value));
924     }
925 
926     /**
927      * @dev Removes a value from a set. O(1).
928      *
929      * Returns true if the value was removed from the set, that is if it was
930      * present.
931      */
932     function remove(UintSet storage set, uint256 value) internal returns (bool) {
933         return _remove(set._inner, bytes32(value));
934     }
935 
936     /**
937      * @dev Returns true if the value is in the set. O(1).
938      */
939     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
940         return _contains(set._inner, bytes32(value));
941     }
942 
943     /**
944      * @dev Returns the number of values in the set. O(1).
945      */
946     function length(UintSet storage set) internal view returns (uint256) {
947         return _length(set._inner);
948     }
949 
950     /**
951      * @dev Returns the value stored at position `index` in the set. O(1).
952      *
953      * Note that there are no guarantees on the ordering of values inside the
954      * array, and it may change when more values are added or removed.
955      *
956      * Requirements:
957      *
958      * - `index` must be strictly less than {length}.
959      */
960     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
961         return uint256(_at(set._inner, index));
962     }
963 
964     /**
965      * @dev Return the entire set in an array
966      *
967      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
968      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
969      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
970      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
971      */
972     function values(UintSet storage set) internal view returns (uint256[] memory) {
973         bytes32[] memory store = _values(set._inner);
974         uint256[] memory result;
975 
976         /// @solidity memory-safe-assembly
977         assembly {
978             result := store
979         }
980 
981         return result;
982     }
983 }
984 
985 // File: @openzeppelin/contracts/utils/math/Math.sol
986 
987 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
988 
989 pragma solidity ^0.8.0;
990 
991 /**
992  * @dev Standard math utilities missing in the Solidity language.
993  */
994 library Math {
995     enum Rounding {
996         Down, // Toward negative infinity
997         Up, // Toward infinity
998         Zero // Toward zero
999     }
1000 
1001     /**
1002      * @dev Returns the largest of two numbers.
1003      */
1004     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1005         return a > b ? a : b;
1006     }
1007 
1008     /**
1009      * @dev Returns the smallest of two numbers.
1010      */
1011     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1012         return a < b ? a : b;
1013     }
1014 
1015     /**
1016      * @dev Returns the average of two numbers. The result is rounded towards
1017      * zero.
1018      */
1019     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1020         // (a + b) / 2 can overflow.
1021         return (a & b) + (a ^ b) / 2;
1022     }
1023 
1024     /**
1025      * @dev Returns the ceiling of the division of two numbers.
1026      *
1027      * This differs from standard division with `/` in that it rounds up instead
1028      * of rounding down.
1029      */
1030     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1031         // (a + b - 1) / b can overflow on addition, so we distribute.
1032         return a == 0 ? 0 : (a - 1) / b + 1;
1033     }
1034 
1035     /**
1036      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1037      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1038      * with further edits by Uniswap Labs also under MIT license.
1039      */
1040     function mulDiv(
1041         uint256 x,
1042         uint256 y,
1043         uint256 denominator
1044     ) internal pure returns (uint256 result) {
1045         unchecked {
1046             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1047             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1048             // variables such that product = prod1 * 2^256 + prod0.
1049             uint256 prod0; // Least significant 256 bits of the product
1050             uint256 prod1; // Most significant 256 bits of the product
1051             assembly {
1052                 let mm := mulmod(x, y, not(0))
1053                 prod0 := mul(x, y)
1054                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1055             }
1056 
1057             // Handle non-overflow cases, 256 by 256 division.
1058             if (prod1 == 0) {
1059                 return prod0 / denominator;
1060             }
1061 
1062             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1063             require(denominator > prod1);
1064 
1065             ///////////////////////////////////////////////
1066             // 512 by 256 division.
1067             ///////////////////////////////////////////////
1068 
1069             // Make division exact by subtracting the remainder from [prod1 prod0].
1070             uint256 remainder;
1071             assembly {
1072                 // Compute remainder using mulmod.
1073                 remainder := mulmod(x, y, denominator)
1074 
1075                 // Subtract 256 bit number from 512 bit number.
1076                 prod1 := sub(prod1, gt(remainder, prod0))
1077                 prod0 := sub(prod0, remainder)
1078             }
1079 
1080             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1081             // See https://cs.stackexchange.com/q/138556/92363.
1082 
1083             // Does not overflow because the denominator cannot be zero at this stage in the function.
1084             uint256 twos = denominator & (~denominator + 1);
1085             assembly {
1086                 // Divide denominator by twos.
1087                 denominator := div(denominator, twos)
1088 
1089                 // Divide [prod1 prod0] by twos.
1090                 prod0 := div(prod0, twos)
1091 
1092                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1093                 twos := add(div(sub(0, twos), twos), 1)
1094             }
1095 
1096             // Shift in bits from prod1 into prod0.
1097             prod0 |= prod1 * twos;
1098 
1099             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1100             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1101             // four bits. That is, denominator * inv = 1 mod 2^4.
1102             uint256 inverse = (3 * denominator) ^ 2;
1103 
1104             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1105             // in modular arithmetic, doubling the correct bits in each step.
1106             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1107             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1108             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1109             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1110             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1111             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1112 
1113             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1114             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1115             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1116             // is no longer required.
1117             result = prod0 * inverse;
1118             return result;
1119         }
1120     }
1121 
1122     /**
1123      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1124      */
1125     function mulDiv(
1126         uint256 x,
1127         uint256 y,
1128         uint256 denominator,
1129         Rounding rounding
1130     ) internal pure returns (uint256) {
1131         uint256 result = mulDiv(x, y, denominator);
1132         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1133             result += 1;
1134         }
1135         return result;
1136     }
1137 
1138     /**
1139      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1140      *
1141      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1142      */
1143     function sqrt(uint256 a) internal pure returns (uint256) {
1144         if (a == 0) {
1145             return 0;
1146         }
1147 
1148         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1149         //
1150         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1151         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1152         //
1153         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1154         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1155         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1156         //
1157         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1158         uint256 result = 1 << (log2(a) >> 1);
1159 
1160         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1161         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1162         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1163         // into the expected uint128 result.
1164         unchecked {
1165             result = (result + a / result) >> 1;
1166             result = (result + a / result) >> 1;
1167             result = (result + a / result) >> 1;
1168             result = (result + a / result) >> 1;
1169             result = (result + a / result) >> 1;
1170             result = (result + a / result) >> 1;
1171             result = (result + a / result) >> 1;
1172             return min(result, a / result);
1173         }
1174     }
1175 
1176     /**
1177      * @notice Calculates sqrt(a), following the selected rounding direction.
1178      */
1179     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1180         unchecked {
1181             uint256 result = sqrt(a);
1182             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1183         }
1184     }
1185 
1186     /**
1187      * @dev Return the log in base 2, rounded down, of a positive value.
1188      * Returns 0 if given 0.
1189      */
1190     function log2(uint256 value) internal pure returns (uint256) {
1191         uint256 result = 0;
1192         unchecked {
1193             if (value >> 128 > 0) {
1194                 value >>= 128;
1195                 result += 128;
1196             }
1197             if (value >> 64 > 0) {
1198                 value >>= 64;
1199                 result += 64;
1200             }
1201             if (value >> 32 > 0) {
1202                 value >>= 32;
1203                 result += 32;
1204             }
1205             if (value >> 16 > 0) {
1206                 value >>= 16;
1207                 result += 16;
1208             }
1209             if (value >> 8 > 0) {
1210                 value >>= 8;
1211                 result += 8;
1212             }
1213             if (value >> 4 > 0) {
1214                 value >>= 4;
1215                 result += 4;
1216             }
1217             if (value >> 2 > 0) {
1218                 value >>= 2;
1219                 result += 2;
1220             }
1221             if (value >> 1 > 0) {
1222                 result += 1;
1223             }
1224         }
1225         return result;
1226     }
1227 
1228     /**
1229      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1230      * Returns 0 if given 0.
1231      */
1232     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1233         unchecked {
1234             uint256 result = log2(value);
1235             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Return the log in base 10, rounded down, of a positive value.
1241      * Returns 0 if given 0.
1242      */
1243     function log10(uint256 value) internal pure returns (uint256) {
1244         uint256 result = 0;
1245         unchecked {
1246             if (value >= 10**64) {
1247                 value /= 10**64;
1248                 result += 64;
1249             }
1250             if (value >= 10**32) {
1251                 value /= 10**32;
1252                 result += 32;
1253             }
1254             if (value >= 10**16) {
1255                 value /= 10**16;
1256                 result += 16;
1257             }
1258             if (value >= 10**8) {
1259                 value /= 10**8;
1260                 result += 8;
1261             }
1262             if (value >= 10**4) {
1263                 value /= 10**4;
1264                 result += 4;
1265             }
1266             if (value >= 10**2) {
1267                 value /= 10**2;
1268                 result += 2;
1269             }
1270             if (value >= 10**1) {
1271                 result += 1;
1272             }
1273         }
1274         return result;
1275     }
1276 
1277     /**
1278      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1279      * Returns 0 if given 0.
1280      */
1281     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1282         unchecked {
1283             uint256 result = log10(value);
1284             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1285         }
1286     }
1287 
1288     /**
1289      * @dev Return the log in base 256, rounded down, of a positive value.
1290      * Returns 0 if given 0.
1291      *
1292      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1293      */
1294     function log256(uint256 value) internal pure returns (uint256) {
1295         uint256 result = 0;
1296         unchecked {
1297             if (value >> 128 > 0) {
1298                 value >>= 128;
1299                 result += 16;
1300             }
1301             if (value >> 64 > 0) {
1302                 value >>= 64;
1303                 result += 8;
1304             }
1305             if (value >> 32 > 0) {
1306                 value >>= 32;
1307                 result += 4;
1308             }
1309             if (value >> 16 > 0) {
1310                 value >>= 16;
1311                 result += 2;
1312             }
1313             if (value >> 8 > 0) {
1314                 result += 1;
1315             }
1316         }
1317         return result;
1318     }
1319 
1320     /**
1321      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1322      * Returns 0 if given 0.
1323      */
1324     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1325         unchecked {
1326             uint256 result = log256(value);
1327             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1328         }
1329     }
1330 }
1331 
1332 // File: @openzeppelin/contracts/utils/Strings.sol
1333 
1334 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 /**
1339  * @dev String operations.
1340  */
1341 library Strings {
1342     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1343     uint8 private constant _ADDRESS_LENGTH = 20;
1344 
1345     /**
1346      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1347      */
1348     function toString(uint256 value) internal pure returns (string memory) {
1349         unchecked {
1350             uint256 length = Math.log10(value) + 1;
1351             string memory buffer = new string(length);
1352             uint256 ptr;
1353             /// @solidity memory-safe-assembly
1354             assembly {
1355                 ptr := add(buffer, add(32, length))
1356             }
1357             while (true) {
1358                 ptr--;
1359                 /// @solidity memory-safe-assembly
1360                 assembly {
1361                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1362                 }
1363                 value /= 10;
1364                 if (value == 0) break;
1365             }
1366             return buffer;
1367         }
1368     }
1369 
1370     /**
1371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1372      */
1373     function toHexString(uint256 value) internal pure returns (string memory) {
1374         unchecked {
1375             return toHexString(value, Math.log256(value) + 1);
1376         }
1377     }
1378 
1379     /**
1380      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1381      */
1382     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1383         bytes memory buffer = new bytes(2 * length + 2);
1384         buffer[0] = "0";
1385         buffer[1] = "x";
1386         for (uint256 i = 2 * length + 1; i > 1; --i) {
1387             buffer[i] = _SYMBOLS[value & 0xf];
1388             value >>= 4;
1389         }
1390         require(value == 0, "Strings: hex length insufficient");
1391         return string(buffer);
1392     }
1393 
1394     /**
1395      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1396      */
1397     function toHexString(address addr) internal pure returns (string memory) {
1398         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1399     }
1400 }
1401 
1402 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1403 
1404 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 /**
1409  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1410  *
1411  * These functions can be used to verify that a message was signed by the holder
1412  * of the private keys of a given address.
1413  */
1414 library ECDSA {
1415     enum RecoverError {
1416         NoError,
1417         InvalidSignature,
1418         InvalidSignatureLength,
1419         InvalidSignatureS,
1420         InvalidSignatureV // Deprecated in v4.8
1421     }
1422 
1423     function _throwError(RecoverError error) private pure {
1424         if (error == RecoverError.NoError) {
1425             return; // no error: do nothing
1426         } else if (error == RecoverError.InvalidSignature) {
1427             revert("ECDSA: invalid signature");
1428         } else if (error == RecoverError.InvalidSignatureLength) {
1429             revert("ECDSA: invalid signature length");
1430         } else if (error == RecoverError.InvalidSignatureS) {
1431             revert("ECDSA: invalid signature 's' value");
1432         }
1433     }
1434 
1435     /**
1436      * @dev Returns the address that signed a hashed message (`hash`) with
1437      * `signature` or error string. This address can then be used for verification purposes.
1438      *
1439      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1440      * this function rejects them by requiring the `s` value to be in the lower
1441      * half order, and the `v` value to be either 27 or 28.
1442      *
1443      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1444      * verification to be secure: it is possible to craft signatures that
1445      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1446      * this is by receiving a hash of the original message (which may otherwise
1447      * be too long), and then calling {toEthSignedMessageHash} on it.
1448      *
1449      * Documentation for signature generation:
1450      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1451      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1452      *
1453      * _Available since v4.3._
1454      */
1455     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1456         if (signature.length == 65) {
1457             bytes32 r;
1458             bytes32 s;
1459             uint8 v;
1460             // ecrecover takes the signature parameters, and the only way to get them
1461             // currently is to use assembly.
1462             /// @solidity memory-safe-assembly
1463             assembly {
1464                 r := mload(add(signature, 0x20))
1465                 s := mload(add(signature, 0x40))
1466                 v := byte(0, mload(add(signature, 0x60)))
1467             }
1468             return tryRecover(hash, v, r, s);
1469         } else {
1470             return (address(0), RecoverError.InvalidSignatureLength);
1471         }
1472     }
1473 
1474     /**
1475      * @dev Returns the address that signed a hashed message (`hash`) with
1476      * `signature`. This address can then be used for verification purposes.
1477      *
1478      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1479      * this function rejects them by requiring the `s` value to be in the lower
1480      * half order, and the `v` value to be either 27 or 28.
1481      *
1482      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1483      * verification to be secure: it is possible to craft signatures that
1484      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1485      * this is by receiving a hash of the original message (which may otherwise
1486      * be too long), and then calling {toEthSignedMessageHash} on it.
1487      */
1488     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1489         (address recovered, RecoverError error) = tryRecover(hash, signature);
1490         _throwError(error);
1491         return recovered;
1492     }
1493 
1494     /**
1495      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1496      *
1497      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1498      *
1499      * _Available since v4.3._
1500      */
1501     function tryRecover(
1502         bytes32 hash,
1503         bytes32 r,
1504         bytes32 vs
1505     ) internal pure returns (address, RecoverError) {
1506         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1507         uint8 v = uint8((uint256(vs) >> 255) + 27);
1508         return tryRecover(hash, v, r, s);
1509     }
1510 
1511     /**
1512      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1513      *
1514      * _Available since v4.2._
1515      */
1516     function recover(
1517         bytes32 hash,
1518         bytes32 r,
1519         bytes32 vs
1520     ) internal pure returns (address) {
1521         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1522         _throwError(error);
1523         return recovered;
1524     }
1525 
1526     /**
1527      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1528      * `r` and `s` signature fields separately.
1529      *
1530      * _Available since v4.3._
1531      */
1532     function tryRecover(
1533         bytes32 hash,
1534         uint8 v,
1535         bytes32 r,
1536         bytes32 s
1537     ) internal pure returns (address, RecoverError) {
1538         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1539         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1540         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1541         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1542         //
1543         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1544         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1545         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1546         // these malleable signatures as well.
1547         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1548             return (address(0), RecoverError.InvalidSignatureS);
1549         }
1550 
1551         // If the signature is valid (and not malleable), return the signer address
1552         address signer = ecrecover(hash, v, r, s);
1553         if (signer == address(0)) {
1554             return (address(0), RecoverError.InvalidSignature);
1555         }
1556 
1557         return (signer, RecoverError.NoError);
1558     }
1559 
1560     /**
1561      * @dev Overload of {ECDSA-recover} that receives the `v`,
1562      * `r` and `s` signature fields separately.
1563      */
1564     function recover(
1565         bytes32 hash,
1566         uint8 v,
1567         bytes32 r,
1568         bytes32 s
1569     ) internal pure returns (address) {
1570         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1571         _throwError(error);
1572         return recovered;
1573     }
1574 
1575     /**
1576      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1577      * produces hash corresponding to the one signed with the
1578      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1579      * JSON-RPC method as part of EIP-191.
1580      *
1581      * See {recover}.
1582      */
1583     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1584         // 32 is the length in bytes of hash,
1585         // enforced by the type signature above
1586         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1587     }
1588 
1589     /**
1590      * @dev Returns an Ethereum Signed Message, created from `s`. This
1591      * produces hash corresponding to the one signed with the
1592      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1593      * JSON-RPC method as part of EIP-191.
1594      *
1595      * See {recover}.
1596      */
1597     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1598         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1599     }
1600 
1601     /**
1602      * @dev Returns an Ethereum Signed Typed Data, created from a
1603      * `domainSeparator` and a `structHash`. This produces hash corresponding
1604      * to the one signed with the
1605      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1606      * JSON-RPC method as part of EIP-712.
1607      *
1608      * See {recover}.
1609      */
1610     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1611         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1612     }
1613 }
1614 
1615 // File: contracts/libs/SignatureChecker.sol
1616 
1617 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1618 pragma solidity >=0.6.12;
1619 
1620 
1621 library SignatureChecker {
1622     using EnumerableSet for EnumerableSet.AddressSet;
1623 
1624     /**
1625     @notice Common validator logic, checking if the recovered signer is
1626     contained in the signers AddressSet.
1627     */
1628     function validSignature(
1629         EnumerableSet.AddressSet storage signers,
1630         bytes32 message,
1631         bytes calldata signature
1632     ) internal view returns (bool) {
1633         return signers.contains(ECDSA.recover(message, signature));
1634     }
1635 
1636     /**
1637     @notice Requires that the recovered signer is contained in the signers
1638     AddressSet.
1639     @dev Convenience wrapper that reverts if the signature validation fails.
1640     */
1641     function requireValidSignature(
1642         EnumerableSet.AddressSet storage signers,
1643         bytes32 message,
1644         bytes calldata signature
1645     ) internal view {
1646         require(
1647             validSignature(signers, message, signature),
1648             "SignatureChecker: Invalid signature"
1649         );
1650     }
1651 
1652     
1653 }
1654 
1655 // File: contracts/pool/TokenDistributor.sol
1656 
1657 
1658 pragma solidity =0.8.19;
1659 
1660 
1661 
1662 
1663 contract TokenDistributor is OwnableUpgradeable {
1664     using EnumerableSet for EnumerableSet.AddressSet;
1665     using SignatureChecker for EnumerableSet.AddressSet;
1666 
1667     uint256 public constant MAX_ADDRESSES = 150000;
1668     uint256 public constant MAX_TOKEN = 420_000_000_000_000 * 1e18;
1669     uint256 public constant INIT_CLAIM = 131_250_000_000* 1e18; 
1670 
1671     struct InfoView {
1672         uint256 maxToken;
1673         uint256 initClaim;
1674         uint256 currentClaim;
1675         bool claimed;
1676         uint256 claimedSupply;
1677         uint256 claimedCount;
1678     }
1679 
1680     event Claim(address indexed user, uint128 nonce, uint256 amount, uint timestamp);
1681 
1682     IERC20 public token;
1683 
1684     EnumerableSet.AddressSet private _signers;
1685     mapping(uint256 => bool) public _usedNonce;
1686     mapping(address => bool) public _claimedUser;
1687 
1688     uint256 public claimedSupply = 0;
1689     uint256 public claimedCount = 0;
1690     uint256 public claimedPercentage = 0;
1691     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
1692     
1693 
1694 
1695     function initialize( address token_) external initializer {
1696         __Ownable_init();
1697         token = IERC20(token_);
1698     }
1699 
1700     function canClaimAmount() public view returns(uint256) {
1701         
1702         if (claimedCount >= MAX_ADDRESSES) {
1703             return 0;
1704         }
1705 
1706         uint256 supplyPerAddress = INIT_CLAIM;
1707         // uint256 curClaimedCount = claimedCount + 1;
1708         uint256 claimedPercent = claimedSupply*1000/MAX_TOKEN;
1709         uint256 curPercent = 125;
1710 
1711         while (curPercent <= claimedPercent) {
1712             supplyPerAddress = (supplyPerAddress * 50) / 100;
1713             curPercent += 125;
1714         }
1715 
1716         return supplyPerAddress;
1717     }
1718 
1719     function claim(uint128 nonce, bytes calldata signature) public {
1720         require(_usedNonce[nonce] == false, "nonce already used");
1721         require(_claimedUser[_msgSender()] == false, "already claimed");
1722         // require(msg.sender.balance >= MIN_BALANCE, "Insufficient balance which less than 0.2e");
1723 
1724         _claimedUser[_msgSender()] = true;
1725         bytes32 message = keccak256(abi.encode(address(this), _msgSender(), nonce));
1726 
1727         _signers.requireValidSignature(message, signature);
1728         _usedNonce[nonce] = true;
1729 
1730         uint256 supplyPerAddress = canClaimAmount();
1731         require(supplyPerAddress >= 1e6, "Airdrop has ended");
1732 
1733         uint256 amount = canClaimAmount();
1734         token.transfer(_msgSender(), amount);
1735 
1736         claimedCount++;
1737         claimedSupply += supplyPerAddress;
1738 
1739         if (claimedCount > 0) {
1740             claimedPercentage = (claimedCount * 100) / MAX_ADDRESSES;
1741         }
1742 
1743         emit Claim(_msgSender(), nonce, amount, block.timestamp);
1744     }
1745 
1746     function getInfoView(address user) public view returns(InfoView memory) {
1747         return InfoView({
1748             maxToken: MAX_TOKEN,
1749             initClaim: INIT_CLAIM,
1750             currentClaim: canClaimAmount(),
1751             claimed: _claimedUser[user],
1752             claimedSupply: claimedSupply,
1753             claimedCount: claimedCount
1754         });
1755     }
1756 
1757     function burn() public onlyOwner(){
1758         token.transfer(burnAddress, token.balanceOf(address(this)));
1759     }
1760 
1761     function addSigner(address val) public onlyOwner() {
1762         require(val != address(0), "Giggity: val is the zero address");
1763         _signers.add(val);
1764     }
1765 
1766     function delSigner(address signer) public onlyOwner returns (bool) {
1767         require(signer != address(0), "Giggity: signer is the zero address");
1768         return _signers.remove(signer);
1769     }
1770 
1771     function getSigners() public view returns (address[] memory ret) {
1772         return _signers.values();
1773     }
1774 }