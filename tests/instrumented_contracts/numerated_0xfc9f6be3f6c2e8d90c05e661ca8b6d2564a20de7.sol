1 // File: contracts/BlindContract/interfaces/IBlindAuctionInfo.sol
2 
3 
4 pragma solidity ^0.8.16;
5 
6 interface IBlindAuctionInfo {
7     function getUsersCountWillReceiveAirdrop() external view returns (uint256);
8 
9     function getMaxWinnersCount() external view returns (uint256);
10 
11     function getFinalPrice() external view returns (uint256);
12 
13     function getAuctionState() external view returns (uint8);
14 
15     function getSigner() external view returns (address);
16 }
17 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
18 
19 
20 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
21 
22 pragma solidity ^0.8.1;
23 
24 /**
25  * @dev Collection of functions related to the address type
26  */
27 library AddressUpgradeable {
28     /**
29      * @dev Returns true if `account` is a contract.
30      *
31      * [IMPORTANT]
32      * ====
33      * It is unsafe to assume that an address for which this function returns
34      * false is an externally-owned account (EOA) and not a contract.
35      *
36      * Among others, `isContract` will return false for the following
37      * types of addresses:
38      *
39      *  - an externally-owned account
40      *  - a contract in construction
41      *  - an address where a contract will be created
42      *  - an address where a contract lived, but was destroyed
43      * ====
44      *
45      * [IMPORTANT]
46      * ====
47      * You shouldn't rely on `isContract` to protect against flash loan attacks!
48      *
49      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
50      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
51      * constructor.
52      * ====
53      */
54     function isContract(address account) internal view returns (bool) {
55         // This method relies on extcodesize/address.code.length, which returns 0
56         // for contracts in construction, since the code is only stored at the end
57         // of the constructor execution.
58 
59         return account.code.length > 0;
60     }
61 
62     /**
63      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
64      * `recipient`, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by `transfer`, making them unable to receive funds via
69      * `transfer`. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to `recipient`, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level `call`. A
87      * plain `call` is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If `target` reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
95      *
96      * Requirements:
97      *
98      * - `target` must be a contract.
99      * - calling `target` with `data` must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
109      * `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(
114         address target,
115         bytes memory data,
116         string memory errorMessage
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
123      * but also transferring `value` wei to `target`.
124      *
125      * Requirements:
126      *
127      * - the calling contract must have an ETH balance of at least `value`.
128      * - the called Solidity function must be `payable`.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value
136     ) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
142      * with `errorMessage` as a fallback revert reason when `target` reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         (bool success, bytes memory returndata) = target.staticcall(data);
179         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
180     }
181 
182     /**
183      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
184      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
185      *
186      * _Available since v4.8._
187      */
188     function verifyCallResultFromTarget(
189         address target,
190         bool success,
191         bytes memory returndata,
192         string memory errorMessage
193     ) internal view returns (bytes memory) {
194         if (success) {
195             if (returndata.length == 0) {
196                 // only check isContract if the call was successful and the return data is empty
197                 // otherwise we already know that it was a contract
198                 require(isContract(target), "Address: call to non-contract");
199             }
200             return returndata;
201         } else {
202             _revert(returndata, errorMessage);
203         }
204     }
205 
206     /**
207      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
208      * revert reason or using the provided one.
209      *
210      * _Available since v4.3._
211      */
212     function verifyCallResult(
213         bool success,
214         bytes memory returndata,
215         string memory errorMessage
216     ) internal pure returns (bytes memory) {
217         if (success) {
218             return returndata;
219         } else {
220             _revert(returndata, errorMessage);
221         }
222     }
223 
224     function _revert(bytes memory returndata, string memory errorMessage) private pure {
225         // Look for revert reason and bubble it up if present
226         if (returndata.length > 0) {
227             // The easiest way to bubble the revert reason is using memory via assembly
228             /// @solidity memory-safe-assembly
229             assembly {
230                 let returndata_size := mload(returndata)
231                 revert(add(32, returndata), returndata_size)
232             }
233         } else {
234             revert(errorMessage);
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)
243 
244 pragma solidity ^0.8.2;
245 
246 
247 /**
248  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
249  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
250  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
251  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
252  *
253  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
254  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
255  * case an upgrade adds a module that needs to be initialized.
256  *
257  * For example:
258  *
259  * [.hljs-theme-light.nopadding]
260  * ```
261  * contract MyToken is ERC20Upgradeable {
262  *     function initialize() initializer public {
263  *         __ERC20_init("MyToken", "MTK");
264  *     }
265  * }
266  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
267  *     function initializeV2() reinitializer(2) public {
268  *         __ERC20Permit_init("MyToken");
269  *     }
270  * }
271  * ```
272  *
273  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
274  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
275  *
276  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
277  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
278  *
279  * [CAUTION]
280  * ====
281  * Avoid leaving a contract uninitialized.
282  *
283  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
284  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
285  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
286  *
287  * [.hljs-theme-light.nopadding]
288  * ```
289  * /// @custom:oz-upgrades-unsafe-allow constructor
290  * constructor() {
291  *     _disableInitializers();
292  * }
293  * ```
294  * ====
295  */
296 abstract contract Initializable {
297     /**
298      * @dev Indicates that the contract has been initialized.
299      * @custom:oz-retyped-from bool
300      */
301     uint8 private _initialized;
302 
303     /**
304      * @dev Indicates that the contract is in the process of being initialized.
305      */
306     bool private _initializing;
307 
308     /**
309      * @dev Triggered when the contract has been initialized or reinitialized.
310      */
311     event Initialized(uint8 version);
312 
313     /**
314      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
315      * `onlyInitializing` functions can be used to initialize parent contracts.
316      *
317      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
318      * constructor.
319      *
320      * Emits an {Initialized} event.
321      */
322     modifier initializer() {
323         bool isTopLevelCall = !_initializing;
324         require(
325             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
326             "Initializable: contract is already initialized"
327         );
328         _initialized = 1;
329         if (isTopLevelCall) {
330             _initializing = true;
331         }
332         _;
333         if (isTopLevelCall) {
334             _initializing = false;
335             emit Initialized(1);
336         }
337     }
338 
339     /**
340      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
341      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
342      * used to initialize parent contracts.
343      *
344      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
345      * are added through upgrades and that require initialization.
346      *
347      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
348      * cannot be nested. If one is invoked in the context of another, execution will revert.
349      *
350      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
351      * a contract, executing them in the right order is up to the developer or operator.
352      *
353      * WARNING: setting the version to 255 will prevent any future reinitialization.
354      *
355      * Emits an {Initialized} event.
356      */
357     modifier reinitializer(uint8 version) {
358         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
359         _initialized = version;
360         _initializing = true;
361         _;
362         _initializing = false;
363         emit Initialized(version);
364     }
365 
366     /**
367      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
368      * {initializer} and {reinitializer} modifiers, directly or indirectly.
369      */
370     modifier onlyInitializing() {
371         require(_initializing, "Initializable: contract is not initializing");
372         _;
373     }
374 
375     /**
376      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
377      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
378      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
379      * through proxies.
380      *
381      * Emits an {Initialized} event the first time it is successfully executed.
382      */
383     function _disableInitializers() internal virtual {
384         require(!_initializing, "Initializable: contract is initializing");
385         if (_initialized < type(uint8).max) {
386             _initialized = type(uint8).max;
387             emit Initialized(type(uint8).max);
388         }
389     }
390 
391     /**
392      * @dev Returns the highest version that has been initialized. See {reinitializer}.
393      */
394     function _getInitializedVersion() internal view returns (uint8) {
395         return _initialized;
396     }
397 
398     /**
399      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
400      */
401     function _isInitializing() internal view returns (bool) {
402         return _initializing;
403     }
404 }
405 
406 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
407 
408 
409 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 abstract contract ContextUpgradeable is Initializable {
425     function __Context_init() internal onlyInitializing {
426     }
427 
428     function __Context_init_unchained() internal onlyInitializing {
429     }
430     function _msgSender() internal view virtual returns (address) {
431         return msg.sender;
432     }
433 
434     function _msgData() internal view virtual returns (bytes calldata) {
435         return msg.data;
436     }
437 
438     /**
439      * @dev This empty reserved space is put in place to allow future versions to add new
440      * variables without shifting down storage in the inheritance chain.
441      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
442      */
443     uint256[50] private __gap;
444 }
445 
446 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     function __Ownable_init() internal onlyInitializing {
476         __Ownable_init_unchained();
477     }
478 
479     function __Ownable_init_unchained() internal onlyInitializing {
480         _transferOwnership(_msgSender());
481     }
482 
483     /**
484      * @dev Throws if called by any account other than the owner.
485      */
486     modifier onlyOwner() {
487         _checkOwner();
488         _;
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view virtual returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if the sender is not the owner.
500      */
501     function _checkOwner() internal view virtual {
502         require(owner() == _msgSender(), "Ownable: caller is not the owner");
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public virtual onlyOwner {
513         _transferOwnership(address(0));
514     }
515 
516     /**
517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
518      * Can only be called by the current owner.
519      */
520     function transferOwnership(address newOwner) public virtual onlyOwner {
521         require(newOwner != address(0), "Ownable: new owner is the zero address");
522         _transferOwnership(newOwner);
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Internal function without access restriction.
528      */
529     function _transferOwnership(address newOwner) internal virtual {
530         address oldOwner = _owner;
531         _owner = newOwner;
532         emit OwnershipTransferred(oldOwner, newOwner);
533     }
534 
535     /**
536      * @dev This empty reserved space is put in place to allow future versions to add new
537      * variables without shifting down storage in the inheritance chain.
538      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
539      */
540     uint256[49] private __gap;
541 }
542 
543 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
544 
545 
546 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Contract module that helps prevent reentrant calls to a function.
553  *
554  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
555  * available, which can be applied to functions to make sure there are no nested
556  * (reentrant) calls to them.
557  *
558  * Note that because there is a single `nonReentrant` guard, functions marked as
559  * `nonReentrant` may not call one another. This can be worked around by making
560  * those functions `private`, and then adding `external` `nonReentrant` entry
561  * points to them.
562  *
563  * TIP: If you would like to learn more about reentrancy and alternative ways
564  * to protect against it, check out our blog post
565  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
566  */
567 abstract contract ReentrancyGuardUpgradeable is Initializable {
568     // Booleans are more expensive than uint256 or any type that takes up a full
569     // word because each write operation emits an extra SLOAD to first read the
570     // slot's contents, replace the bits taken up by the boolean, and then write
571     // back. This is the compiler's defense against contract upgrades and
572     // pointer aliasing, and it cannot be disabled.
573 
574     // The values being non-zero value makes deployment a bit more expensive,
575     // but in exchange the refund on every call to nonReentrant will be lower in
576     // amount. Since refunds are capped to a percentage of the total
577     // transaction's gas, it is best to keep them low in cases like this one, to
578     // increase the likelihood of the full refund coming into effect.
579     uint256 private constant _NOT_ENTERED = 1;
580     uint256 private constant _ENTERED = 2;
581 
582     uint256 private _status;
583 
584     function __ReentrancyGuard_init() internal onlyInitializing {
585         __ReentrancyGuard_init_unchained();
586     }
587 
588     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
589         _status = _NOT_ENTERED;
590     }
591 
592     /**
593      * @dev Prevents a contract from calling itself, directly or indirectly.
594      * Calling a `nonReentrant` function from another `nonReentrant`
595      * function is not supported. It is possible to prevent this from happening
596      * by making the `nonReentrant` function external, and making it call a
597      * `private` function that does the actual work.
598      */
599     modifier nonReentrant() {
600         _nonReentrantBefore();
601         _;
602         _nonReentrantAfter();
603     }
604 
605     function _nonReentrantBefore() private {
606         // On the first call to nonReentrant, _status will be _NOT_ENTERED
607         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
608 
609         // Any calls to nonReentrant after this point will fail
610         _status = _ENTERED;
611     }
612 
613     function _nonReentrantAfter() private {
614         // By storing the original value once again, a refund is triggered (see
615         // https://eips.ethereum.org/EIPS/eip-2200)
616         _status = _NOT_ENTERED;
617     }
618 
619     /**
620      * @dev This empty reserved space is put in place to allow future versions to add new
621      * variables without shifting down storage in the inheritance chain.
622      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
623      */
624     uint256[49] private __gap;
625 }
626 
627 // File: @openzeppelin/contracts/utils/Strings.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev String operations.
636  */
637 library Strings {
638     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
642      */
643     function toString(uint256 value) internal pure returns (string memory) {
644         // Inspired by OraclizeAPI's implementation - MIT licence
645         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
646 
647         if (value == 0) {
648             return "0";
649         }
650         uint256 temp = value;
651         uint256 digits;
652         while (temp != 0) {
653             digits++;
654             temp /= 10;
655         }
656         bytes memory buffer = new bytes(digits);
657         while (value != 0) {
658             digits -= 1;
659             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
660             value /= 10;
661         }
662         return string(buffer);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
667      */
668     function toHexString(uint256 value) internal pure returns (string memory) {
669         if (value == 0) {
670             return "0x00";
671         }
672         uint256 temp = value;
673         uint256 length = 0;
674         while (temp != 0) {
675             length++;
676             temp >>= 8;
677         }
678         return toHexString(value, length);
679     }
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
683      */
684     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
685         bytes memory buffer = new bytes(2 * length + 2);
686         buffer[0] = "0";
687         buffer[1] = "x";
688         for (uint256 i = 2 * length + 1; i > 1; --i) {
689             buffer[i] = _HEX_SYMBOLS[value & 0xf];
690             value >>= 4;
691         }
692         require(value == 0, "Strings: hex length insufficient");
693         return string(buffer);
694     }
695 }
696 
697 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
707  *
708  * These functions can be used to verify that a message was signed by the holder
709  * of the private keys of a given address.
710  */
711 library ECDSA {
712     enum RecoverError {
713         NoError,
714         InvalidSignature,
715         InvalidSignatureLength,
716         InvalidSignatureS,
717         InvalidSignatureV // Deprecated in v4.8
718     }
719 
720     function _throwError(RecoverError error) private pure {
721         if (error == RecoverError.NoError) {
722             return; // no error: do nothing
723         } else if (error == RecoverError.InvalidSignature) {
724             revert("ECDSA: invalid signature");
725         } else if (error == RecoverError.InvalidSignatureLength) {
726             revert("ECDSA: invalid signature length");
727         } else if (error == RecoverError.InvalidSignatureS) {
728             revert("ECDSA: invalid signature 's' value");
729         }
730     }
731 
732     /**
733      * @dev Returns the address that signed a hashed message (`hash`) with
734      * `signature` or error string. This address can then be used for verification purposes.
735      *
736      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
737      * this function rejects them by requiring the `s` value to be in the lower
738      * half order, and the `v` value to be either 27 or 28.
739      *
740      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
741      * verification to be secure: it is possible to craft signatures that
742      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
743      * this is by receiving a hash of the original message (which may otherwise
744      * be too long), and then calling {toEthSignedMessageHash} on it.
745      *
746      * Documentation for signature generation:
747      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
748      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
749      *
750      * _Available since v4.3._
751      */
752     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
753         if (signature.length == 65) {
754             bytes32 r;
755             bytes32 s;
756             uint8 v;
757             // ecrecover takes the signature parameters, and the only way to get them
758             // currently is to use assembly.
759             /// @solidity memory-safe-assembly
760             assembly {
761                 r := mload(add(signature, 0x20))
762                 s := mload(add(signature, 0x40))
763                 v := byte(0, mload(add(signature, 0x60)))
764             }
765             return tryRecover(hash, v, r, s);
766         } else {
767             return (address(0), RecoverError.InvalidSignatureLength);
768         }
769     }
770 
771     /**
772      * @dev Returns the address that signed a hashed message (`hash`) with
773      * `signature`. This address can then be used for verification purposes.
774      *
775      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
776      * this function rejects them by requiring the `s` value to be in the lower
777      * half order, and the `v` value to be either 27 or 28.
778      *
779      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
780      * verification to be secure: it is possible to craft signatures that
781      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
782      * this is by receiving a hash of the original message (which may otherwise
783      * be too long), and then calling {toEthSignedMessageHash} on it.
784      */
785     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
786         (address recovered, RecoverError error) = tryRecover(hash, signature);
787         _throwError(error);
788         return recovered;
789     }
790 
791     /**
792      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
793      *
794      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
795      *
796      * _Available since v4.3._
797      */
798     function tryRecover(
799         bytes32 hash,
800         bytes32 r,
801         bytes32 vs
802     ) internal pure returns (address, RecoverError) {
803         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
804         uint8 v = uint8((uint256(vs) >> 255) + 27);
805         return tryRecover(hash, v, r, s);
806     }
807 
808     /**
809      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
810      *
811      * _Available since v4.2._
812      */
813     function recover(
814         bytes32 hash,
815         bytes32 r,
816         bytes32 vs
817     ) internal pure returns (address) {
818         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
819         _throwError(error);
820         return recovered;
821     }
822 
823     /**
824      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
825      * `r` and `s` signature fields separately.
826      *
827      * _Available since v4.3._
828      */
829     function tryRecover(
830         bytes32 hash,
831         uint8 v,
832         bytes32 r,
833         bytes32 s
834     ) internal pure returns (address, RecoverError) {
835         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
836         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
837         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
838         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
839         //
840         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
841         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
842         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
843         // these malleable signatures as well.
844         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
845             return (address(0), RecoverError.InvalidSignatureS);
846         }
847 
848         // If the signature is valid (and not malleable), return the signer address
849         address signer = ecrecover(hash, v, r, s);
850         if (signer == address(0)) {
851             return (address(0), RecoverError.InvalidSignature);
852         }
853 
854         return (signer, RecoverError.NoError);
855     }
856 
857     /**
858      * @dev Overload of {ECDSA-recover} that receives the `v`,
859      * `r` and `s` signature fields separately.
860      */
861     function recover(
862         bytes32 hash,
863         uint8 v,
864         bytes32 r,
865         bytes32 s
866     ) internal pure returns (address) {
867         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
868         _throwError(error);
869         return recovered;
870     }
871 
872     /**
873      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
874      * produces hash corresponding to the one signed with the
875      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
876      * JSON-RPC method as part of EIP-191.
877      *
878      * See {recover}.
879      */
880     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
881         // 32 is the length in bytes of hash,
882         // enforced by the type signature above
883         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
884     }
885 
886     /**
887      * @dev Returns an Ethereum Signed Message, created from `s`. This
888      * produces hash corresponding to the one signed with the
889      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
890      * JSON-RPC method as part of EIP-191.
891      *
892      * See {recover}.
893      */
894     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
895         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
896     }
897 
898     /**
899      * @dev Returns an Ethereum Signed Typed Data, created from a
900      * `domainSeparator` and a `structHash`. This produces hash corresponding
901      * to the one signed with the
902      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
903      * JSON-RPC method as part of EIP-712.
904      *
905      * See {recover}.
906      */
907     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
908         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
909     }
910 }
911 
912 // File: contracts/BlindContract/blind.sol
913 
914 
915 
916 pragma solidity ^0.8.16;
917 
918 
919 
920 
921 
922 
923 contract BlindAuction is
924     Initializable,
925     ReentrancyGuardUpgradeable,
926     OwnableUpgradeable,
927     IBlindAuctionInfo
928 {
929     uint256 public DEPOSIT_AMOUNT; // = 0.1ether;
930     uint256 public MAX_WINNERS_COUNT; // 222
931     uint256 public finalPrice;
932     uint8 public auctionState;
933     address public signer;
934 
935     uint256 public depositedUserCount;
936     mapping(address => bool) public isUserDeposited;
937     address[] public usersWillReceiveAirdrop;
938     mapping(address => bool) public isUserWillReceiveAirdrop;
939     uint256 public refundedUserCount;
940     mapping(address => bool) public isUserRefunded;
941 
942     uint256 public winnersCount;
943 
944     event UserDeposited(address indexed user);
945     event UserWillReceiveAirdrop(address indexed user);
946     event UserRefunded(address indexed user);
947 
948     function initialize(address _signer) public initializer {
949         ReentrancyGuardUpgradeable.__ReentrancyGuard_init();
950         OwnableUpgradeable.__Ownable_init();
951         DEPOSIT_AMOUNT = 0.1 ether;
952         MAX_WINNERS_COUNT = 222;
953         signer = _signer;
954     }
955 
956     function checkValidity(bytes calldata signature, string memory action)
957         public
958         view
959         returns (bool)
960     {
961         require(
962             ECDSA.recover(
963                 ECDSA.toEthSignedMessageHash(
964                     keccak256(abi.encodePacked(msg.sender, action))
965                 ),
966                 signature
967             ) == signer,
968             "invalid signature"
969         );
970         return true;
971     }
972 
973     function verify(bytes32 messageHash, bytes memory signature, address usersigner) public pure returns (bool) {
974         require(usersigner != address(0), "SignatureVerifier: invalid signer address");
975 
976         address recoveredSigner = ECDSA.recover(messageHash, signature);
977         return (recoveredSigner == usersigner);
978     }
979     
980     function deposit() external payable {
981         require(auctionState == 1, "Auction not in bidding state");
982         require(msg.value == DEPOSIT_AMOUNT, "Invalid ETH amount");
983         require(!isUserDeposited[msg.sender], "Already deposited");
984         isUserDeposited[msg.sender] = true;
985         depositedUserCount++;
986         emit UserDeposited(msg.sender);
987     }
988 
989     function winnerDepositExtra(bytes calldata signature) external payable {
990         require(auctionState == 2, "Auction not in concluding state");
991         require(finalPrice >= DEPOSIT_AMOUNT, "finalPrice not yet set");
992         require(msg.value == finalPrice - DEPOSIT_AMOUNT, "Invalid ETH amount");
993         require(
994             !isUserWillReceiveAirdrop[msg.sender],
995             "Already deposited extra"
996         );
997         require(!isUserRefunded[msg.sender], "Already refunded");
998         checkValidity(signature, "winner");
999         isUserWillReceiveAirdrop[msg.sender] = true;
1000         usersWillReceiveAirdrop.push(msg.sender);
1001         emit UserWillReceiveAirdrop(msg.sender);
1002     }
1003 
1004     function refund(bytes calldata signature) external nonReentrant {
1005         require(
1006             auctionState == 2 || auctionState == 3,
1007             "Auction not in concluding or finished state"
1008         );
1009         require(isUserDeposited[msg.sender], "No deposit record");
1010         require(!isUserWillReceiveAirdrop[msg.sender], "Is a winner");
1011         require(!isUserRefunded[msg.sender], "Already refunded");
1012         checkValidity(signature, "refund");
1013         isUserRefunded[msg.sender] = true;
1014         refundedUserCount++;
1015         _withdraw(msg.sender, DEPOSIT_AMOUNT);
1016     }
1017 
1018     // =============== Admin ===============
1019     function setSigner(address _signer) external onlyOwner {
1020         signer = _signer;
1021     }
1022 
1023     function withdrawSales() public onlyOwner {
1024         require(
1025             auctionState == 2 || auctionState == 3,
1026             "Auction not in concluding or finished state"
1027         );
1028         uint256 balance = address(this).balance;
1029 
1030         uint256 nonWinnersCount = depositedUserCount - winnersCount;
1031         uint256 refundReserveAmount = (nonWinnersCount - refundedUserCount) *
1032             DEPOSIT_AMOUNT;
1033         uint256 balanceCanWithdraw = balance - refundReserveAmount;
1034         require(balanceCanWithdraw > 0, "No balance to withdraw");
1035         _withdraw(owner(), balanceCanWithdraw);
1036     }
1037 
1038     function _withdraw(address _address, uint256 _amount) private {
1039         (bool success, ) = _address.call{value: _amount}("");
1040         require(success, "cant withdraw");
1041     }
1042 
1043     function changeDepositAmount(uint256 amount) external onlyOwner {
1044         require(auctionState == 0, "Auction already started");
1045         DEPOSIT_AMOUNT = amount;
1046     }
1047 
1048     function changeMaxWinnersCount(uint256 count) external onlyOwner {
1049         require(auctionState == 0, "Auction already started");
1050         MAX_WINNERS_COUNT = count;
1051     }
1052 
1053     function setFinalPrice(uint256 price) external onlyOwner {
1054         finalPrice = price;
1055     }
1056 
1057     // usually 222
1058     function setWinnersCount(uint256 _winnersCount) external onlyOwner {
1059         require(_winnersCount <= MAX_WINNERS_COUNT, "Too many winners");
1060         winnersCount = _winnersCount;
1061     }
1062 
1063     // 0 = not started
1064     // 1 = started, bidding
1065     // 2 = final price announced | winners should pay finalPrice - 0.5e | non-winners can refund | waitlist starts
1066     // 3 = auction end | receive unpaid winner deposits | non-winners can still refund | waitlist concludes + can refund
1067     function setAuctionState(uint8 state) external onlyOwner {
1068         auctionState = state;
1069     }
1070 
1071     function getUsersWillReceiveAirdrop()
1072         external
1073         view
1074         returns (address[] memory)
1075     {
1076         return usersWillReceiveAirdrop;
1077     }
1078 
1079     // =============== IBlindAuctionInfo ===============
1080     function getUsersCountWillReceiveAirdrop() external view returns (uint256) {
1081         return usersWillReceiveAirdrop.length;
1082     }
1083 
1084     function getMaxWinnersCount() external view returns (uint256) {
1085         return MAX_WINNERS_COUNT;
1086     }
1087 
1088     function getFinalPrice() external view returns (uint256) {
1089         return finalPrice;
1090     }
1091 
1092     function getAuctionState() external view returns (uint8) {
1093         return auctionState;
1094     }
1095 
1096     function getSigner() external view returns (address) {
1097         return signer;
1098     }
1099 }