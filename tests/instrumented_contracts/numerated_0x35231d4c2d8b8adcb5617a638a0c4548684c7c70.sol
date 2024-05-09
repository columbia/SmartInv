1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File interfaces/IInterchainGasPaymaster.sol
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.6.11;
7 
8 /**
9  * @title IInterchainGasPaymaster
10  * @notice Manages payments on a source chain to cover gas costs of relaying
11  * messages to destination chains.
12  */
13 interface IInterchainGasPaymaster {
14     function payForGas(
15         bytes32 _messageId,
16         uint32 _destinationDomain,
17         uint256 _gas,
18         address _refundAddress
19     ) external payable;
20 }
21 
22 
23 // File interfaces/IInterchainSecurityModule.sol
24 
25 
26 pragma solidity >=0.6.11;
27 
28 interface IInterchainSecurityModule {
29     /**
30      * @notice Returns an enum that represents the type of security model
31      * encoded by this ISM.
32      * @dev Relayers infer how to fetch and format metadata.
33      */
34     function moduleType() external view returns (uint8);
35 
36     /**
37      * @notice Defines a security model responsible for verifying interchain
38      * messages based on the provided metadata.
39      * @param _metadata Off-chain metadata provided by a relayer, specific to
40      * the security model encoded by the module (e.g. validator signatures)
41      * @param _message Hyperlane encoded interchain message
42      * @return True if the message was verified
43      */
44     function verify(bytes calldata _metadata, bytes calldata _message)
45         external
46         returns (bool);
47 }
48 
49 interface ISpecifiesInterchainSecurityModule {
50     function interchainSecurityModule()
51         external
52         view
53         returns (IInterchainSecurityModule);
54 }
55 
56 
57 // File interfaces/IMailbox.sol
58 
59 
60 pragma solidity >=0.8.0;
61 
62 interface IMailbox {
63     function localDomain() external view returns (uint32);
64 
65     function dispatch(
66         uint32 _destinationDomain,
67         bytes32 _recipientAddress,
68         bytes calldata _messageBody
69     ) external returns (bytes32);
70 
71     function process(bytes calldata _metadata, bytes calldata _message)
72         external;
73 
74     function count() external view returns (uint32);
75 
76     function root() external view returns (bytes32);
77 
78     function latestCheckpoint() external view returns (bytes32, uint32);
79 
80     function recipientIsm(address _recipient)
81         external
82         view
83         returns (IInterchainSecurityModule);
84 }
85 
86 
87 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.8.0
88 
89 
90 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
91 
92 pragma solidity ^0.8.1;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library AddressUpgradeable {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
254      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
255      *
256      * _Available since v4.8._
257      */
258     function verifyCallResultFromTarget(
259         address target,
260         bool success,
261         bytes memory returndata,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         if (success) {
265             if (returndata.length == 0) {
266                 // only check isContract if the call was successful and the return data is empty
267                 // otherwise we already know that it was a contract
268                 require(isContract(target), "Address: call to non-contract");
269             }
270             return returndata;
271         } else {
272             _revert(returndata, errorMessage);
273         }
274     }
275 
276     /**
277      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason or using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             _revert(returndata, errorMessage);
291         }
292     }
293 
294     function _revert(bytes memory returndata, string memory errorMessage) private pure {
295         // Look for revert reason and bubble it up if present
296         if (returndata.length > 0) {
297             // The easiest way to bubble the revert reason is using memory via assembly
298             /// @solidity memory-safe-assembly
299             assembly {
300                 let returndata_size := mload(returndata)
301                 revert(add(32, returndata), returndata_size)
302             }
303         } else {
304             revert(errorMessage);
305         }
306     }
307 }
308 
309 
310 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.8.0
311 
312 
313 // OpenZeppelin Contracts (last updated v4.8.0) (proxy/utils/Initializable.sol)
314 
315 pragma solidity ^0.8.2;
316 
317 /**
318  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
319  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
320  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
321  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
322  *
323  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
324  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
325  * case an upgrade adds a module that needs to be initialized.
326  *
327  * For example:
328  *
329  * [.hljs-theme-light.nopadding]
330  * ```
331  * contract MyToken is ERC20Upgradeable {
332  *     function initialize() initializer public {
333  *         __ERC20_init("MyToken", "MTK");
334  *     }
335  * }
336  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
337  *     function initializeV2() reinitializer(2) public {
338  *         __ERC20Permit_init("MyToken");
339  *     }
340  * }
341  * ```
342  *
343  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
344  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
345  *
346  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
347  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
348  *
349  * [CAUTION]
350  * ====
351  * Avoid leaving a contract uninitialized.
352  *
353  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
354  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
355  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
356  *
357  * [.hljs-theme-light.nopadding]
358  * ```
359  * /// @custom:oz-upgrades-unsafe-allow constructor
360  * constructor() {
361  *     _disableInitializers();
362  * }
363  * ```
364  * ====
365  */
366 abstract contract Initializable {
367     /**
368      * @dev Indicates that the contract has been initialized.
369      * @custom:oz-retyped-from bool
370      */
371     uint8 private _initialized;
372 
373     /**
374      * @dev Indicates that the contract is in the process of being initialized.
375      */
376     bool private _initializing;
377 
378     /**
379      * @dev Triggered when the contract has been initialized or reinitialized.
380      */
381     event Initialized(uint8 version);
382 
383     /**
384      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
385      * `onlyInitializing` functions can be used to initialize parent contracts.
386      *
387      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
388      * constructor.
389      *
390      * Emits an {Initialized} event.
391      */
392     modifier initializer() {
393         bool isTopLevelCall = !_initializing;
394         require(
395             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
396             "Initializable: contract is already initialized"
397         );
398         _initialized = 1;
399         if (isTopLevelCall) {
400             _initializing = true;
401         }
402         _;
403         if (isTopLevelCall) {
404             _initializing = false;
405             emit Initialized(1);
406         }
407     }
408 
409     /**
410      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
411      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
412      * used to initialize parent contracts.
413      *
414      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
415      * are added through upgrades and that require initialization.
416      *
417      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
418      * cannot be nested. If one is invoked in the context of another, execution will revert.
419      *
420      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
421      * a contract, executing them in the right order is up to the developer or operator.
422      *
423      * WARNING: setting the version to 255 will prevent any future reinitialization.
424      *
425      * Emits an {Initialized} event.
426      */
427     modifier reinitializer(uint8 version) {
428         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
429         _initialized = version;
430         _initializing = true;
431         _;
432         _initializing = false;
433         emit Initialized(version);
434     }
435 
436     /**
437      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
438      * {initializer} and {reinitializer} modifiers, directly or indirectly.
439      */
440     modifier onlyInitializing() {
441         require(_initializing, "Initializable: contract is not initializing");
442         _;
443     }
444 
445     /**
446      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
447      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
448      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
449      * through proxies.
450      *
451      * Emits an {Initialized} event the first time it is successfully executed.
452      */
453     function _disableInitializers() internal virtual {
454         require(!_initializing, "Initializable: contract is initializing");
455         if (_initialized < type(uint8).max) {
456             _initialized = type(uint8).max;
457             emit Initialized(type(uint8).max);
458         }
459     }
460 
461     /**
462      * @dev Internal function that returns the initialized version. Returns `_initialized`
463      */
464     function _getInitializedVersion() internal view returns (uint8) {
465         return _initialized;
466     }
467 
468     /**
469      * @dev Internal function that returns the initialized version. Returns `_initializing`
470      */
471     function _isInitializing() internal view returns (bool) {
472         return _initializing;
473     }
474 }
475 
476 
477 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.8.0
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Provides information about the current execution context, including the
486  * sender of the transaction and its data. While these are generally available
487  * via msg.sender and msg.data, they should not be accessed in such a direct
488  * manner, since when dealing with meta-transactions the account sending and
489  * paying for execution may not be the actual sender (as far as an application
490  * is concerned).
491  *
492  * This contract is only required for intermediate, library-like contracts.
493  */
494 abstract contract ContextUpgradeable is Initializable {
495     function __Context_init() internal onlyInitializing {
496     }
497 
498     function __Context_init_unchained() internal onlyInitializing {
499     }
500     function _msgSender() internal view virtual returns (address) {
501         return msg.sender;
502     }
503 
504     function _msgData() internal view virtual returns (bytes calldata) {
505         return msg.data;
506     }
507 
508     /**
509      * @dev This empty reserved space is put in place to allow future versions to add new
510      * variables without shifting down storage in the inheritance chain.
511      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
512      */
513     uint256[50] private __gap;
514 }
515 
516 
517 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v4.8.0
518 
519 
520 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Contract module which provides a basic access control mechanism, where
527  * there is an account (an owner) that can be granted exclusive access to
528  * specific functions.
529  *
530  * By default, the owner account will be the one that deploys the contract. This
531  * can later be changed with {transferOwnership}.
532  *
533  * This module is used through inheritance. It will make available the modifier
534  * `onlyOwner`, which can be applied to your functions to restrict their use to
535  * the owner.
536  */
537 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
538     address private _owner;
539 
540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542     /**
543      * @dev Initializes the contract setting the deployer as the initial owner.
544      */
545     function __Ownable_init() internal onlyInitializing {
546         __Ownable_init_unchained();
547     }
548 
549     function __Ownable_init_unchained() internal onlyInitializing {
550         _transferOwnership(_msgSender());
551     }
552 
553     /**
554      * @dev Throws if called by any account other than the owner.
555      */
556     modifier onlyOwner() {
557         _checkOwner();
558         _;
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view virtual returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if the sender is not the owner.
570      */
571     function _checkOwner() internal view virtual {
572         require(owner() == _msgSender(), "Ownable: caller is not the owner");
573     }
574 
575     /**
576      * @dev Leaves the contract without owner. It will not be possible to call
577      * `onlyOwner` functions anymore. Can only be called by the current owner.
578      *
579      * NOTE: Renouncing ownership will leave the contract without an owner,
580      * thereby removing any functionality that is only available to the owner.
581      */
582     function renounceOwnership() public virtual onlyOwner {
583         _transferOwnership(address(0));
584     }
585 
586     /**
587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
588      * Can only be called by the current owner.
589      */
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         _transferOwnership(newOwner);
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Internal function without access restriction.
598      */
599     function _transferOwnership(address newOwner) internal virtual {
600         address oldOwner = _owner;
601         _owner = newOwner;
602         emit OwnershipTransferred(oldOwner, newOwner);
603     }
604 
605     /**
606      * @dev This empty reserved space is put in place to allow future versions to add new
607      * variables without shifting down storage in the inheritance chain.
608      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
609      */
610     uint256[49] private __gap;
611 }
612 
613 
614 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
615 
616 
617 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
618 
619 pragma solidity ^0.8.1;
620 
621 /**
622  * @dev Collection of functions related to the address type
623  */
624 library Address {
625     /**
626      * @dev Returns true if `account` is a contract.
627      *
628      * [IMPORTANT]
629      * ====
630      * It is unsafe to assume that an address for which this function returns
631      * false is an externally-owned account (EOA) and not a contract.
632      *
633      * Among others, `isContract` will return false for the following
634      * types of addresses:
635      *
636      *  - an externally-owned account
637      *  - a contract in construction
638      *  - an address where a contract will be created
639      *  - an address where a contract lived, but was destroyed
640      * ====
641      *
642      * [IMPORTANT]
643      * ====
644      * You shouldn't rely on `isContract` to protect against flash loan attacks!
645      *
646      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
647      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
648      * constructor.
649      * ====
650      */
651     function isContract(address account) internal view returns (bool) {
652         // This method relies on extcodesize/address.code.length, which returns 0
653         // for contracts in construction, since the code is only stored at the end
654         // of the constructor execution.
655 
656         return account.code.length > 0;
657     }
658 
659     /**
660      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
661      * `recipient`, forwarding all available gas and reverting on errors.
662      *
663      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
664      * of certain opcodes, possibly making contracts go over the 2300 gas limit
665      * imposed by `transfer`, making them unable to receive funds via
666      * `transfer`. {sendValue} removes this limitation.
667      *
668      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
669      *
670      * IMPORTANT: because control is transferred to `recipient`, care must be
671      * taken to not create reentrancy vulnerabilities. Consider using
672      * {ReentrancyGuard} or the
673      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
674      */
675     function sendValue(address payable recipient, uint256 amount) internal {
676         require(address(this).balance >= amount, "Address: insufficient balance");
677 
678         (bool success, ) = recipient.call{value: amount}("");
679         require(success, "Address: unable to send value, recipient may have reverted");
680     }
681 
682     /**
683      * @dev Performs a Solidity function call using a low level `call`. A
684      * plain `call` is an unsafe replacement for a function call: use this
685      * function instead.
686      *
687      * If `target` reverts with a revert reason, it is bubbled up by this
688      * function (like regular Solidity function calls).
689      *
690      * Returns the raw returned data. To convert to the expected return value,
691      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
692      *
693      * Requirements:
694      *
695      * - `target` must be a contract.
696      * - calling `target` with `data` must not revert.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
701         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
706      * `errorMessage` as a fallback revert reason when `target` reverts.
707      *
708      * _Available since v3.1._
709      */
710     function functionCall(
711         address target,
712         bytes memory data,
713         string memory errorMessage
714     ) internal returns (bytes memory) {
715         return functionCallWithValue(target, data, 0, errorMessage);
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
720      * but also transferring `value` wei to `target`.
721      *
722      * Requirements:
723      *
724      * - the calling contract must have an ETH balance of at least `value`.
725      * - the called Solidity function must be `payable`.
726      *
727      * _Available since v3.1._
728      */
729     function functionCallWithValue(
730         address target,
731         bytes memory data,
732         uint256 value
733     ) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
739      * with `errorMessage` as a fallback revert reason when `target` reverts.
740      *
741      * _Available since v3.1._
742      */
743     function functionCallWithValue(
744         address target,
745         bytes memory data,
746         uint256 value,
747         string memory errorMessage
748     ) internal returns (bytes memory) {
749         require(address(this).balance >= value, "Address: insufficient balance for call");
750         (bool success, bytes memory returndata) = target.call{value: value}(data);
751         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
756      * but performing a static call.
757      *
758      * _Available since v3.3._
759      */
760     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
761         return functionStaticCall(target, data, "Address: low-level static call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
766      * but performing a static call.
767      *
768      * _Available since v3.3._
769      */
770     function functionStaticCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal view returns (bytes memory) {
775         (bool success, bytes memory returndata) = target.staticcall(data);
776         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
786         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal returns (bytes memory) {
800         (bool success, bytes memory returndata) = target.delegatecall(data);
801         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
802     }
803 
804     /**
805      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
806      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
807      *
808      * _Available since v4.8._
809      */
810     function verifyCallResultFromTarget(
811         address target,
812         bool success,
813         bytes memory returndata,
814         string memory errorMessage
815     ) internal view returns (bytes memory) {
816         if (success) {
817             if (returndata.length == 0) {
818                 // only check isContract if the call was successful and the return data is empty
819                 // otherwise we already know that it was a contract
820                 require(isContract(target), "Address: call to non-contract");
821             }
822             return returndata;
823         } else {
824             _revert(returndata, errorMessage);
825         }
826     }
827 
828     /**
829      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
830      * revert reason or using the provided one.
831      *
832      * _Available since v4.3._
833      */
834     function verifyCallResult(
835         bool success,
836         bytes memory returndata,
837         string memory errorMessage
838     ) internal pure returns (bytes memory) {
839         if (success) {
840             return returndata;
841         } else {
842             _revert(returndata, errorMessage);
843         }
844     }
845 
846     function _revert(bytes memory returndata, string memory errorMessage) private pure {
847         // Look for revert reason and bubble it up if present
848         if (returndata.length > 0) {
849             // The easiest way to bubble the revert reason is using memory via assembly
850             /// @solidity memory-safe-assembly
851             assembly {
852                 let returndata_size := mload(returndata)
853                 revert(add(32, returndata), returndata_size)
854             }
855         } else {
856             revert(errorMessage);
857         }
858     }
859 }
860 
861 
862 // File contracts/HyperlaneConnectionClient.sol
863 
864 
865 pragma solidity >=0.6.11;
866 
867 // ============ Internal Imports ============
868 
869 
870 
871 // ============ External Imports ============
872 
873 
874 abstract contract HyperlaneConnectionClient is
875     OwnableUpgradeable,
876     ISpecifiesInterchainSecurityModule
877 {
878     // ============ Mutable Storage ============
879 
880     IMailbox public mailbox;
881     // Interchain Gas Paymaster contract. The relayer associated with this contract
882     // must be willing to relay messages dispatched from the current Mailbox contract,
883     // otherwise payments made to the paymaster will not result in relayed messages.
884     IInterchainGasPaymaster public interchainGasPaymaster;
885 
886     IInterchainSecurityModule public interchainSecurityModule;
887 
888     uint256[48] private __GAP; // gap for upgrade safety
889 
890     // ============ Events ============
891     /**
892      * @notice Emitted when a new mailbox is set.
893      * @param mailbox The address of the mailbox contract
894      */
895     event MailboxSet(address indexed mailbox);
896 
897     /**
898      * @notice Emitted when a new Interchain Gas Paymaster is set.
899      * @param interchainGasPaymaster The address of the Interchain Gas Paymaster.
900      */
901     event InterchainGasPaymasterSet(address indexed interchainGasPaymaster);
902 
903     event InterchainSecurityModuleSet(address indexed module);
904 
905     // ============ Modifiers ============
906 
907     /**
908      * @notice Only accept messages from an Hyperlane Mailbox contract
909      */
910     modifier onlyMailbox() {
911         require(msg.sender == address(mailbox), "!mailbox");
912         _;
913     }
914 
915     /**
916      * @notice Only accept addresses that at least have contract code
917      */
918     modifier onlyContract(address _contract) {
919         require(Address.isContract(_contract), "!contract");
920         _;
921     }
922 
923     // ======== Initializer =========
924 
925     function __HyperlaneConnectionClient_initialize(address _mailbox)
926         internal
927         onlyInitializing
928     {
929         _setMailbox(_mailbox);
930         __Ownable_init();
931     }
932 
933     function __HyperlaneConnectionClient_initialize(
934         address _mailbox,
935         address _interchainGasPaymaster
936     ) internal onlyInitializing {
937         _setInterchainGasPaymaster(_interchainGasPaymaster);
938         __HyperlaneConnectionClient_initialize(_mailbox);
939     }
940 
941     function __HyperlaneConnectionClient_initialize(
942         address _mailbox,
943         address _interchainGasPaymaster,
944         address _interchainSecurityModule
945     ) internal onlyInitializing {
946         _setInterchainSecurityModule(_interchainSecurityModule);
947         __HyperlaneConnectionClient_initialize(
948             _mailbox,
949             _interchainGasPaymaster
950         );
951     }
952 
953     // ============ External functions ============
954 
955     /**
956      * @notice Sets the address of the application's Mailbox.
957      * @param _mailbox The address of the Mailbox contract.
958      */
959     function setMailbox(address _mailbox) external virtual onlyOwner {
960         _setMailbox(_mailbox);
961     }
962 
963     /**
964      * @notice Sets the address of the application's InterchainGasPaymaster.
965      * @param _interchainGasPaymaster The address of the InterchainGasPaymaster contract.
966      */
967     function setInterchainGasPaymaster(address _interchainGasPaymaster)
968         external
969         virtual
970         onlyOwner
971     {
972         _setInterchainGasPaymaster(_interchainGasPaymaster);
973     }
974 
975     function setInterchainSecurityModule(address _module)
976         external
977         virtual
978         onlyOwner
979     {
980         _setInterchainSecurityModule(_module);
981     }
982 
983     // ============ Internal functions ============
984 
985     /**
986      * @notice Sets the address of the application's InterchainGasPaymaster.
987      * @param _interchainGasPaymaster The address of the InterchainGasPaymaster contract.
988      */
989     function _setInterchainGasPaymaster(address _interchainGasPaymaster)
990         internal
991         onlyContract(_interchainGasPaymaster)
992     {
993         interchainGasPaymaster = IInterchainGasPaymaster(
994             _interchainGasPaymaster
995         );
996         emit InterchainGasPaymasterSet(_interchainGasPaymaster);
997     }
998 
999     /**
1000      * @notice Modify the contract the Application uses to validate Mailbox contracts
1001      * @param _mailbox The address of the mailbox contract
1002      */
1003     function _setMailbox(address _mailbox) internal onlyContract(_mailbox) {
1004         mailbox = IMailbox(_mailbox);
1005         emit MailboxSet(_mailbox);
1006     }
1007 
1008     function _setInterchainSecurityModule(address _module)
1009         internal
1010         onlyContract(_module)
1011     {
1012         interchainSecurityModule = IInterchainSecurityModule(_module);
1013         emit InterchainSecurityModuleSet(_module);
1014     }
1015 }
1016 
1017 
1018 // File contracts/InterchainGasPaymaster.sol
1019 
1020 
1021 pragma solidity >=0.8.0;
1022 
1023 // ============ Internal Imports ============
1024 
1025 // ============ External Imports ============
1026 
1027 /**
1028  * @title InterchainGasPaymaster
1029  * @notice Manages payments on a source chain to cover gas costs of relaying
1030  * messages to destination chains.
1031  */
1032 contract InterchainGasPaymaster is IInterchainGasPaymaster, OwnableUpgradeable {
1033     // ============ Events ============
1034 
1035     /**
1036      * @notice Emitted when a payment is made for a message's gas costs.
1037      * @param messageId The ID of the message to pay for.
1038      * @param gasAmount The amount of destination gas paid for.
1039      * @param payment The amount of native tokens paid.
1040      */
1041     event GasPayment(
1042         bytes32 indexed messageId,
1043         uint256 gasAmount,
1044         uint256 payment
1045     );
1046 
1047     // ============ Constructor ============
1048 
1049     // solhint-disable-next-line no-empty-blocks
1050     constructor() {
1051         initialize(); // allows contract to be used without proxying
1052     }
1053 
1054     // ============ External Functions ============
1055 
1056     function initialize() public initializer {
1057         __Ownable_init();
1058     }
1059 
1060     /**
1061      * @notice Deposits msg.value as a payment for the relaying of a message
1062      * to its destination chain.
1063      * @param _messageId The ID of the message to pay for.
1064      * @param _destinationDomain The domain of the message's destination chain.
1065      * @param _gasAmount The amount of destination gas to pay for. Currently unused.
1066      * @param _refundAddress The address to refund any overpayment to. Currently unused.
1067      */
1068     function payForGas(
1069         bytes32 _messageId,
1070         uint32 _destinationDomain,
1071         uint256 _gasAmount,
1072         address _refundAddress
1073     ) external payable override {
1074         // Silence compiler warning. The NatSpec @param requires the parameter to be named.
1075         // While not used at the moment, future versions of the paymaster have behavior specific
1076         // to the destination domain and refund overpayments to the _refundAddress.
1077         _destinationDomain;
1078         _refundAddress;
1079 
1080         emit GasPayment(_messageId, _gasAmount, msg.value);
1081     }
1082 
1083     /**
1084      * @notice Transfers the entire native token balance to the owner of the contract.
1085      * @dev The owner must be able to receive native tokens.
1086      */
1087     function claim() external {
1088         // Transfer the entire balance to owner.
1089         (bool success, ) = owner().call{value: address(this).balance}("");
1090         require(success, "!transfer");
1091     }
1092 }
1093 
1094 
1095 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 /**
1103  * @dev Provides information about the current execution context, including the
1104  * sender of the transaction and its data. While these are generally available
1105  * via msg.sender and msg.data, they should not be accessed in such a direct
1106  * manner, since when dealing with meta-transactions the account sending and
1107  * paying for execution may not be the actual sender (as far as an application
1108  * is concerned).
1109  *
1110  * This contract is only required for intermediate, library-like contracts.
1111  */
1112 abstract contract Context {
1113     function _msgSender() internal view virtual returns (address) {
1114         return msg.sender;
1115     }
1116 
1117     function _msgData() internal view virtual returns (bytes calldata) {
1118         return msg.data;
1119     }
1120 }
1121 
1122 
1123 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1124 
1125 
1126 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 /**
1131  * @dev Contract module which provides a basic access control mechanism, where
1132  * there is an account (an owner) that can be granted exclusive access to
1133  * specific functions.
1134  *
1135  * By default, the owner account will be the one that deploys the contract. This
1136  * can later be changed with {transferOwnership}.
1137  *
1138  * This module is used through inheritance. It will make available the modifier
1139  * `onlyOwner`, which can be applied to your functions to restrict their use to
1140  * the owner.
1141  */
1142 abstract contract Ownable is Context {
1143     address private _owner;
1144 
1145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1146 
1147     /**
1148      * @dev Initializes the contract setting the deployer as the initial owner.
1149      */
1150     constructor() {
1151         _transferOwnership(_msgSender());
1152     }
1153 
1154     /**
1155      * @dev Throws if called by any account other than the owner.
1156      */
1157     modifier onlyOwner() {
1158         _checkOwner();
1159         _;
1160     }
1161 
1162     /**
1163      * @dev Returns the address of the current owner.
1164      */
1165     function owner() public view virtual returns (address) {
1166         return _owner;
1167     }
1168 
1169     /**
1170      * @dev Throws if the sender is not the owner.
1171      */
1172     function _checkOwner() internal view virtual {
1173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1174     }
1175 
1176     /**
1177      * @dev Leaves the contract without owner. It will not be possible to call
1178      * `onlyOwner` functions anymore. Can only be called by the current owner.
1179      *
1180      * NOTE: Renouncing ownership will leave the contract without an owner,
1181      * thereby removing any functionality that is only available to the owner.
1182      */
1183     function renounceOwnership() public virtual onlyOwner {
1184         _transferOwnership(address(0));
1185     }
1186 
1187     /**
1188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1189      * Can only be called by the current owner.
1190      */
1191     function transferOwnership(address newOwner) public virtual onlyOwner {
1192         require(newOwner != address(0), "Ownable: new owner is the zero address");
1193         _transferOwnership(newOwner);
1194     }
1195 
1196     /**
1197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1198      * Internal function without access restriction.
1199      */
1200     function _transferOwnership(address newOwner) internal virtual {
1201         address oldOwner = _owner;
1202         _owner = newOwner;
1203         emit OwnershipTransferred(oldOwner, newOwner);
1204     }
1205 }
1206 
1207 
1208 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
1209 
1210 
1211 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 /**
1216  * @dev Standard math utilities missing in the Solidity language.
1217  */
1218 library Math {
1219     enum Rounding {
1220         Down, // Toward negative infinity
1221         Up, // Toward infinity
1222         Zero // Toward zero
1223     }
1224 
1225     /**
1226      * @dev Returns the largest of two numbers.
1227      */
1228     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1229         return a > b ? a : b;
1230     }
1231 
1232     /**
1233      * @dev Returns the smallest of two numbers.
1234      */
1235     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1236         return a < b ? a : b;
1237     }
1238 
1239     /**
1240      * @dev Returns the average of two numbers. The result is rounded towards
1241      * zero.
1242      */
1243     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1244         // (a + b) / 2 can overflow.
1245         return (a & b) + (a ^ b) / 2;
1246     }
1247 
1248     /**
1249      * @dev Returns the ceiling of the division of two numbers.
1250      *
1251      * This differs from standard division with `/` in that it rounds up instead
1252      * of rounding down.
1253      */
1254     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1255         // (a + b - 1) / b can overflow on addition, so we distribute.
1256         return a == 0 ? 0 : (a - 1) / b + 1;
1257     }
1258 
1259     /**
1260      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1261      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1262      * with further edits by Uniswap Labs also under MIT license.
1263      */
1264     function mulDiv(
1265         uint256 x,
1266         uint256 y,
1267         uint256 denominator
1268     ) internal pure returns (uint256 result) {
1269         unchecked {
1270             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1271             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1272             // variables such that product = prod1 * 2^256 + prod0.
1273             uint256 prod0; // Least significant 256 bits of the product
1274             uint256 prod1; // Most significant 256 bits of the product
1275             assembly {
1276                 let mm := mulmod(x, y, not(0))
1277                 prod0 := mul(x, y)
1278                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1279             }
1280 
1281             // Handle non-overflow cases, 256 by 256 division.
1282             if (prod1 == 0) {
1283                 return prod0 / denominator;
1284             }
1285 
1286             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1287             require(denominator > prod1);
1288 
1289             ///////////////////////////////////////////////
1290             // 512 by 256 division.
1291             ///////////////////////////////////////////////
1292 
1293             // Make division exact by subtracting the remainder from [prod1 prod0].
1294             uint256 remainder;
1295             assembly {
1296                 // Compute remainder using mulmod.
1297                 remainder := mulmod(x, y, denominator)
1298 
1299                 // Subtract 256 bit number from 512 bit number.
1300                 prod1 := sub(prod1, gt(remainder, prod0))
1301                 prod0 := sub(prod0, remainder)
1302             }
1303 
1304             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1305             // See https://cs.stackexchange.com/q/138556/92363.
1306 
1307             // Does not overflow because the denominator cannot be zero at this stage in the function.
1308             uint256 twos = denominator & (~denominator + 1);
1309             assembly {
1310                 // Divide denominator by twos.
1311                 denominator := div(denominator, twos)
1312 
1313                 // Divide [prod1 prod0] by twos.
1314                 prod0 := div(prod0, twos)
1315 
1316                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1317                 twos := add(div(sub(0, twos), twos), 1)
1318             }
1319 
1320             // Shift in bits from prod1 into prod0.
1321             prod0 |= prod1 * twos;
1322 
1323             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1324             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1325             // four bits. That is, denominator * inv = 1 mod 2^4.
1326             uint256 inverse = (3 * denominator) ^ 2;
1327 
1328             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1329             // in modular arithmetic, doubling the correct bits in each step.
1330             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1331             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1332             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1333             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1334             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1335             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1336 
1337             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1338             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1339             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1340             // is no longer required.
1341             result = prod0 * inverse;
1342             return result;
1343         }
1344     }
1345 
1346     /**
1347      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1348      */
1349     function mulDiv(
1350         uint256 x,
1351         uint256 y,
1352         uint256 denominator,
1353         Rounding rounding
1354     ) internal pure returns (uint256) {
1355         uint256 result = mulDiv(x, y, denominator);
1356         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1357             result += 1;
1358         }
1359         return result;
1360     }
1361 
1362     /**
1363      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1364      *
1365      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1366      */
1367     function sqrt(uint256 a) internal pure returns (uint256) {
1368         if (a == 0) {
1369             return 0;
1370         }
1371 
1372         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1373         //
1374         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1375         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1376         //
1377         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1378         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1379         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1380         //
1381         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1382         uint256 result = 1 << (log2(a) >> 1);
1383 
1384         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1385         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1386         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1387         // into the expected uint128 result.
1388         unchecked {
1389             result = (result + a / result) >> 1;
1390             result = (result + a / result) >> 1;
1391             result = (result + a / result) >> 1;
1392             result = (result + a / result) >> 1;
1393             result = (result + a / result) >> 1;
1394             result = (result + a / result) >> 1;
1395             result = (result + a / result) >> 1;
1396             return min(result, a / result);
1397         }
1398     }
1399 
1400     /**
1401      * @notice Calculates sqrt(a), following the selected rounding direction.
1402      */
1403     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1404         unchecked {
1405             uint256 result = sqrt(a);
1406             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1407         }
1408     }
1409 
1410     /**
1411      * @dev Return the log in base 2, rounded down, of a positive value.
1412      * Returns 0 if given 0.
1413      */
1414     function log2(uint256 value) internal pure returns (uint256) {
1415         uint256 result = 0;
1416         unchecked {
1417             if (value >> 128 > 0) {
1418                 value >>= 128;
1419                 result += 128;
1420             }
1421             if (value >> 64 > 0) {
1422                 value >>= 64;
1423                 result += 64;
1424             }
1425             if (value >> 32 > 0) {
1426                 value >>= 32;
1427                 result += 32;
1428             }
1429             if (value >> 16 > 0) {
1430                 value >>= 16;
1431                 result += 16;
1432             }
1433             if (value >> 8 > 0) {
1434                 value >>= 8;
1435                 result += 8;
1436             }
1437             if (value >> 4 > 0) {
1438                 value >>= 4;
1439                 result += 4;
1440             }
1441             if (value >> 2 > 0) {
1442                 value >>= 2;
1443                 result += 2;
1444             }
1445             if (value >> 1 > 0) {
1446                 result += 1;
1447             }
1448         }
1449         return result;
1450     }
1451 
1452     /**
1453      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1454      * Returns 0 if given 0.
1455      */
1456     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1457         unchecked {
1458             uint256 result = log2(value);
1459             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1460         }
1461     }
1462 
1463     /**
1464      * @dev Return the log in base 10, rounded down, of a positive value.
1465      * Returns 0 if given 0.
1466      */
1467     function log10(uint256 value) internal pure returns (uint256) {
1468         uint256 result = 0;
1469         unchecked {
1470             if (value >= 10**64) {
1471                 value /= 10**64;
1472                 result += 64;
1473             }
1474             if (value >= 10**32) {
1475                 value /= 10**32;
1476                 result += 32;
1477             }
1478             if (value >= 10**16) {
1479                 value /= 10**16;
1480                 result += 16;
1481             }
1482             if (value >= 10**8) {
1483                 value /= 10**8;
1484                 result += 8;
1485             }
1486             if (value >= 10**4) {
1487                 value /= 10**4;
1488                 result += 4;
1489             }
1490             if (value >= 10**2) {
1491                 value /= 10**2;
1492                 result += 2;
1493             }
1494             if (value >= 10**1) {
1495                 result += 1;
1496             }
1497         }
1498         return result;
1499     }
1500 
1501     /**
1502      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1503      * Returns 0 if given 0.
1504      */
1505     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1506         unchecked {
1507             uint256 result = log10(value);
1508             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1509         }
1510     }
1511 
1512     /**
1513      * @dev Return the log in base 256, rounded down, of a positive value.
1514      * Returns 0 if given 0.
1515      *
1516      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1517      */
1518     function log256(uint256 value) internal pure returns (uint256) {
1519         uint256 result = 0;
1520         unchecked {
1521             if (value >> 128 > 0) {
1522                 value >>= 128;
1523                 result += 16;
1524             }
1525             if (value >> 64 > 0) {
1526                 value >>= 64;
1527                 result += 8;
1528             }
1529             if (value >> 32 > 0) {
1530                 value >>= 32;
1531                 result += 4;
1532             }
1533             if (value >> 16 > 0) {
1534                 value >>= 16;
1535                 result += 2;
1536             }
1537             if (value >> 8 > 0) {
1538                 result += 1;
1539             }
1540         }
1541         return result;
1542     }
1543 
1544     /**
1545      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1546      * Returns 0 if given 0.
1547      */
1548     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1549         unchecked {
1550             uint256 result = log256(value);
1551             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1552         }
1553     }
1554 }
1555 
1556 
1557 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1558 
1559 
1560 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 /**
1565  * @dev String operations.
1566  */
1567 library Strings {
1568     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1569     uint8 private constant _ADDRESS_LENGTH = 20;
1570 
1571     /**
1572      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1573      */
1574     function toString(uint256 value) internal pure returns (string memory) {
1575         unchecked {
1576             uint256 length = Math.log10(value) + 1;
1577             string memory buffer = new string(length);
1578             uint256 ptr;
1579             /// @solidity memory-safe-assembly
1580             assembly {
1581                 ptr := add(buffer, add(32, length))
1582             }
1583             while (true) {
1584                 ptr--;
1585                 /// @solidity memory-safe-assembly
1586                 assembly {
1587                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1588                 }
1589                 value /= 10;
1590                 if (value == 0) break;
1591             }
1592             return buffer;
1593         }
1594     }
1595 
1596     /**
1597      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1598      */
1599     function toHexString(uint256 value) internal pure returns (string memory) {
1600         unchecked {
1601             return toHexString(value, Math.log256(value) + 1);
1602         }
1603     }
1604 
1605     /**
1606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1607      */
1608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1609         bytes memory buffer = new bytes(2 * length + 2);
1610         buffer[0] = "0";
1611         buffer[1] = "x";
1612         for (uint256 i = 2 * length + 1; i > 1; --i) {
1613             buffer[i] = _SYMBOLS[value & 0xf];
1614             value >>= 4;
1615         }
1616         require(value == 0, "Strings: hex length insufficient");
1617         return string(buffer);
1618     }
1619 
1620     /**
1621      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1622      */
1623     function toHexString(address addr) internal pure returns (string memory) {
1624         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1625     }
1626 }
1627 
1628 
1629 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.0
1630 
1631 
1632 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1638  *
1639  * These functions can be used to verify that a message was signed by the holder
1640  * of the private keys of a given address.
1641  */
1642 library ECDSA {
1643     enum RecoverError {
1644         NoError,
1645         InvalidSignature,
1646         InvalidSignatureLength,
1647         InvalidSignatureS,
1648         InvalidSignatureV // Deprecated in v4.8
1649     }
1650 
1651     function _throwError(RecoverError error) private pure {
1652         if (error == RecoverError.NoError) {
1653             return; // no error: do nothing
1654         } else if (error == RecoverError.InvalidSignature) {
1655             revert("ECDSA: invalid signature");
1656         } else if (error == RecoverError.InvalidSignatureLength) {
1657             revert("ECDSA: invalid signature length");
1658         } else if (error == RecoverError.InvalidSignatureS) {
1659             revert("ECDSA: invalid signature 's' value");
1660         }
1661     }
1662 
1663     /**
1664      * @dev Returns the address that signed a hashed message (`hash`) with
1665      * `signature` or error string. This address can then be used for verification purposes.
1666      *
1667      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1668      * this function rejects them by requiring the `s` value to be in the lower
1669      * half order, and the `v` value to be either 27 or 28.
1670      *
1671      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1672      * verification to be secure: it is possible to craft signatures that
1673      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1674      * this is by receiving a hash of the original message (which may otherwise
1675      * be too long), and then calling {toEthSignedMessageHash} on it.
1676      *
1677      * Documentation for signature generation:
1678      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1679      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1680      *
1681      * _Available since v4.3._
1682      */
1683     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1684         if (signature.length == 65) {
1685             bytes32 r;
1686             bytes32 s;
1687             uint8 v;
1688             // ecrecover takes the signature parameters, and the only way to get them
1689             // currently is to use assembly.
1690             /// @solidity memory-safe-assembly
1691             assembly {
1692                 r := mload(add(signature, 0x20))
1693                 s := mload(add(signature, 0x40))
1694                 v := byte(0, mload(add(signature, 0x60)))
1695             }
1696             return tryRecover(hash, v, r, s);
1697         } else {
1698             return (address(0), RecoverError.InvalidSignatureLength);
1699         }
1700     }
1701 
1702     /**
1703      * @dev Returns the address that signed a hashed message (`hash`) with
1704      * `signature`. This address can then be used for verification purposes.
1705      *
1706      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1707      * this function rejects them by requiring the `s` value to be in the lower
1708      * half order, and the `v` value to be either 27 or 28.
1709      *
1710      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1711      * verification to be secure: it is possible to craft signatures that
1712      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1713      * this is by receiving a hash of the original message (which may otherwise
1714      * be too long), and then calling {toEthSignedMessageHash} on it.
1715      */
1716     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1717         (address recovered, RecoverError error) = tryRecover(hash, signature);
1718         _throwError(error);
1719         return recovered;
1720     }
1721 
1722     /**
1723      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1724      *
1725      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1726      *
1727      * _Available since v4.3._
1728      */
1729     function tryRecover(
1730         bytes32 hash,
1731         bytes32 r,
1732         bytes32 vs
1733     ) internal pure returns (address, RecoverError) {
1734         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1735         uint8 v = uint8((uint256(vs) >> 255) + 27);
1736         return tryRecover(hash, v, r, s);
1737     }
1738 
1739     /**
1740      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1741      *
1742      * _Available since v4.2._
1743      */
1744     function recover(
1745         bytes32 hash,
1746         bytes32 r,
1747         bytes32 vs
1748     ) internal pure returns (address) {
1749         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1750         _throwError(error);
1751         return recovered;
1752     }
1753 
1754     /**
1755      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1756      * `r` and `s` signature fields separately.
1757      *
1758      * _Available since v4.3._
1759      */
1760     function tryRecover(
1761         bytes32 hash,
1762         uint8 v,
1763         bytes32 r,
1764         bytes32 s
1765     ) internal pure returns (address, RecoverError) {
1766         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1767         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1768         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1769         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1770         //
1771         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1772         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1773         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1774         // these malleable signatures as well.
1775         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1776             return (address(0), RecoverError.InvalidSignatureS);
1777         }
1778 
1779         // If the signature is valid (and not malleable), return the signer address
1780         address signer = ecrecover(hash, v, r, s);
1781         if (signer == address(0)) {
1782             return (address(0), RecoverError.InvalidSignature);
1783         }
1784 
1785         return (signer, RecoverError.NoError);
1786     }
1787 
1788     /**
1789      * @dev Overload of {ECDSA-recover} that receives the `v`,
1790      * `r` and `s` signature fields separately.
1791      */
1792     function recover(
1793         bytes32 hash,
1794         uint8 v,
1795         bytes32 r,
1796         bytes32 s
1797     ) internal pure returns (address) {
1798         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1799         _throwError(error);
1800         return recovered;
1801     }
1802 
1803     /**
1804      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1805      * produces hash corresponding to the one signed with the
1806      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1807      * JSON-RPC method as part of EIP-191.
1808      *
1809      * See {recover}.
1810      */
1811     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1812         // 32 is the length in bytes of hash,
1813         // enforced by the type signature above
1814         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1815     }
1816 
1817     /**
1818      * @dev Returns an Ethereum Signed Message, created from `s`. This
1819      * produces hash corresponding to the one signed with the
1820      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1821      * JSON-RPC method as part of EIP-191.
1822      *
1823      * See {recover}.
1824      */
1825     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1826         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1827     }
1828 
1829     /**
1830      * @dev Returns an Ethereum Signed Typed Data, created from a
1831      * `domainSeparator` and a `structHash`. This produces hash corresponding
1832      * to the one signed with the
1833      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1834      * JSON-RPC method as part of EIP-712.
1835      *
1836      * See {recover}.
1837      */
1838     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1839         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1840     }
1841 }
1842 
1843 
1844 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.8.0
1845 
1846 
1847 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
1848 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1849 
1850 pragma solidity ^0.8.0;
1851 
1852 /**
1853  * @dev Library for managing
1854  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1855  * types.
1856  *
1857  * Sets have the following properties:
1858  *
1859  * - Elements are added, removed, and checked for existence in constant time
1860  * (O(1)).
1861  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1862  *
1863  * ```
1864  * contract Example {
1865  *     // Add the library methods
1866  *     using EnumerableSet for EnumerableSet.AddressSet;
1867  *
1868  *     // Declare a set state variable
1869  *     EnumerableSet.AddressSet private mySet;
1870  * }
1871  * ```
1872  *
1873  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1874  * and `uint256` (`UintSet`) are supported.
1875  *
1876  * [WARNING]
1877  * ====
1878  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1879  * unusable.
1880  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1881  *
1882  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1883  * array of EnumerableSet.
1884  * ====
1885  */
1886 library EnumerableSet {
1887     // To implement this library for multiple types with as little code
1888     // repetition as possible, we write it in terms of a generic Set type with
1889     // bytes32 values.
1890     // The Set implementation uses private functions, and user-facing
1891     // implementations (such as AddressSet) are just wrappers around the
1892     // underlying Set.
1893     // This means that we can only create new EnumerableSets for types that fit
1894     // in bytes32.
1895 
1896     struct Set {
1897         // Storage of set values
1898         bytes32[] _values;
1899         // Position of the value in the `values` array, plus 1 because index 0
1900         // means a value is not in the set.
1901         mapping(bytes32 => uint256) _indexes;
1902     }
1903 
1904     /**
1905      * @dev Add a value to a set. O(1).
1906      *
1907      * Returns true if the value was added to the set, that is if it was not
1908      * already present.
1909      */
1910     function _add(Set storage set, bytes32 value) private returns (bool) {
1911         if (!_contains(set, value)) {
1912             set._values.push(value);
1913             // The value is stored at length-1, but we add 1 to all indexes
1914             // and use 0 as a sentinel value
1915             set._indexes[value] = set._values.length;
1916             return true;
1917         } else {
1918             return false;
1919         }
1920     }
1921 
1922     /**
1923      * @dev Removes a value from a set. O(1).
1924      *
1925      * Returns true if the value was removed from the set, that is if it was
1926      * present.
1927      */
1928     function _remove(Set storage set, bytes32 value) private returns (bool) {
1929         // We read and store the value's index to prevent multiple reads from the same storage slot
1930         uint256 valueIndex = set._indexes[value];
1931 
1932         if (valueIndex != 0) {
1933             // Equivalent to contains(set, value)
1934             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1935             // the array, and then remove the last element (sometimes called as 'swap and pop').
1936             // This modifies the order of the array, as noted in {at}.
1937 
1938             uint256 toDeleteIndex = valueIndex - 1;
1939             uint256 lastIndex = set._values.length - 1;
1940 
1941             if (lastIndex != toDeleteIndex) {
1942                 bytes32 lastValue = set._values[lastIndex];
1943 
1944                 // Move the last value to the index where the value to delete is
1945                 set._values[toDeleteIndex] = lastValue;
1946                 // Update the index for the moved value
1947                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1948             }
1949 
1950             // Delete the slot where the moved value was stored
1951             set._values.pop();
1952 
1953             // Delete the index for the deleted slot
1954             delete set._indexes[value];
1955 
1956             return true;
1957         } else {
1958             return false;
1959         }
1960     }
1961 
1962     /**
1963      * @dev Returns true if the value is in the set. O(1).
1964      */
1965     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1966         return set._indexes[value] != 0;
1967     }
1968 
1969     /**
1970      * @dev Returns the number of values on the set. O(1).
1971      */
1972     function _length(Set storage set) private view returns (uint256) {
1973         return set._values.length;
1974     }
1975 
1976     /**
1977      * @dev Returns the value stored at position `index` in the set. O(1).
1978      *
1979      * Note that there are no guarantees on the ordering of values inside the
1980      * array, and it may change when more values are added or removed.
1981      *
1982      * Requirements:
1983      *
1984      * - `index` must be strictly less than {length}.
1985      */
1986     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1987         return set._values[index];
1988     }
1989 
1990     /**
1991      * @dev Return the entire set in an array
1992      *
1993      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1994      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1995      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1996      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1997      */
1998     function _values(Set storage set) private view returns (bytes32[] memory) {
1999         return set._values;
2000     }
2001 
2002     // Bytes32Set
2003 
2004     struct Bytes32Set {
2005         Set _inner;
2006     }
2007 
2008     /**
2009      * @dev Add a value to a set. O(1).
2010      *
2011      * Returns true if the value was added to the set, that is if it was not
2012      * already present.
2013      */
2014     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2015         return _add(set._inner, value);
2016     }
2017 
2018     /**
2019      * @dev Removes a value from a set. O(1).
2020      *
2021      * Returns true if the value was removed from the set, that is if it was
2022      * present.
2023      */
2024     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2025         return _remove(set._inner, value);
2026     }
2027 
2028     /**
2029      * @dev Returns true if the value is in the set. O(1).
2030      */
2031     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2032         return _contains(set._inner, value);
2033     }
2034 
2035     /**
2036      * @dev Returns the number of values in the set. O(1).
2037      */
2038     function length(Bytes32Set storage set) internal view returns (uint256) {
2039         return _length(set._inner);
2040     }
2041 
2042     /**
2043      * @dev Returns the value stored at position `index` in the set. O(1).
2044      *
2045      * Note that there are no guarantees on the ordering of values inside the
2046      * array, and it may change when more values are added or removed.
2047      *
2048      * Requirements:
2049      *
2050      * - `index` must be strictly less than {length}.
2051      */
2052     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2053         return _at(set._inner, index);
2054     }
2055 
2056     /**
2057      * @dev Return the entire set in an array
2058      *
2059      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2060      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2061      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2062      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2063      */
2064     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2065         bytes32[] memory store = _values(set._inner);
2066         bytes32[] memory result;
2067 
2068         /// @solidity memory-safe-assembly
2069         assembly {
2070             result := store
2071         }
2072 
2073         return result;
2074     }
2075 
2076     // AddressSet
2077 
2078     struct AddressSet {
2079         Set _inner;
2080     }
2081 
2082     /**
2083      * @dev Add a value to a set. O(1).
2084      *
2085      * Returns true if the value was added to the set, that is if it was not
2086      * already present.
2087      */
2088     function add(AddressSet storage set, address value) internal returns (bool) {
2089         return _add(set._inner, bytes32(uint256(uint160(value))));
2090     }
2091 
2092     /**
2093      * @dev Removes a value from a set. O(1).
2094      *
2095      * Returns true if the value was removed from the set, that is if it was
2096      * present.
2097      */
2098     function remove(AddressSet storage set, address value) internal returns (bool) {
2099         return _remove(set._inner, bytes32(uint256(uint160(value))));
2100     }
2101 
2102     /**
2103      * @dev Returns true if the value is in the set. O(1).
2104      */
2105     function contains(AddressSet storage set, address value) internal view returns (bool) {
2106         return _contains(set._inner, bytes32(uint256(uint160(value))));
2107     }
2108 
2109     /**
2110      * @dev Returns the number of values in the set. O(1).
2111      */
2112     function length(AddressSet storage set) internal view returns (uint256) {
2113         return _length(set._inner);
2114     }
2115 
2116     /**
2117      * @dev Returns the value stored at position `index` in the set. O(1).
2118      *
2119      * Note that there are no guarantees on the ordering of values inside the
2120      * array, and it may change when more values are added or removed.
2121      *
2122      * Requirements:
2123      *
2124      * - `index` must be strictly less than {length}.
2125      */
2126     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2127         return address(uint160(uint256(_at(set._inner, index))));
2128     }
2129 
2130     /**
2131      * @dev Return the entire set in an array
2132      *
2133      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2134      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2135      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2136      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2137      */
2138     function values(AddressSet storage set) internal view returns (address[] memory) {
2139         bytes32[] memory store = _values(set._inner);
2140         address[] memory result;
2141 
2142         /// @solidity memory-safe-assembly
2143         assembly {
2144             result := store
2145         }
2146 
2147         return result;
2148     }
2149 
2150     // UintSet
2151 
2152     struct UintSet {
2153         Set _inner;
2154     }
2155 
2156     /**
2157      * @dev Add a value to a set. O(1).
2158      *
2159      * Returns true if the value was added to the set, that is if it was not
2160      * already present.
2161      */
2162     function add(UintSet storage set, uint256 value) internal returns (bool) {
2163         return _add(set._inner, bytes32(value));
2164     }
2165 
2166     /**
2167      * @dev Removes a value from a set. O(1).
2168      *
2169      * Returns true if the value was removed from the set, that is if it was
2170      * present.
2171      */
2172     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2173         return _remove(set._inner, bytes32(value));
2174     }
2175 
2176     /**
2177      * @dev Returns true if the value is in the set. O(1).
2178      */
2179     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2180         return _contains(set._inner, bytes32(value));
2181     }
2182 
2183     /**
2184      * @dev Returns the number of values in the set. O(1).
2185      */
2186     function length(UintSet storage set) internal view returns (uint256) {
2187         return _length(set._inner);
2188     }
2189 
2190     /**
2191      * @dev Returns the value stored at position `index` in the set. O(1).
2192      *
2193      * Note that there are no guarantees on the ordering of values inside the
2194      * array, and it may change when more values are added or removed.
2195      *
2196      * Requirements:
2197      *
2198      * - `index` must be strictly less than {length}.
2199      */
2200     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2201         return uint256(_at(set._inner, index));
2202     }
2203 
2204     /**
2205      * @dev Return the entire set in an array
2206      *
2207      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2208      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2209      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2210      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2211      */
2212     function values(UintSet storage set) internal view returns (uint256[] memory) {
2213         bytes32[] memory store = _values(set._inner);
2214         uint256[] memory result;
2215 
2216         /// @solidity memory-safe-assembly
2217         assembly {
2218             result := store
2219         }
2220 
2221         return result;
2222     }
2223 }
2224 
2225 
2226 // File interfaces/IMultisigIsm.sol
2227 
2228 
2229 pragma solidity >=0.6.0;
2230 
2231 interface IMultisigIsm is IInterchainSecurityModule {
2232     /**
2233      * @notice Returns the set of validators responsible for verifying _message
2234      * and the number of signatures required
2235      * @dev Can change based on the content of _message
2236      * @param _message Hyperlane formatted interchain message
2237      * @return validators The array of validator addresses
2238      * @return threshold The number of validator signatures needed
2239      */
2240     function validatorsAndThreshold(bytes calldata _message)
2241         external
2242         view
2243         returns (address[] memory validators, uint8 threshold);
2244 }
2245 
2246 
2247 // File contracts/libs/TypeCasts.sol
2248 
2249 
2250 pragma solidity >=0.6.11;
2251 
2252 library TypeCasts {
2253     // treat it as a null-terminated string of max 32 bytes
2254     function coerceString(bytes32 _buf)
2255         internal
2256         pure
2257         returns (string memory _newStr)
2258     {
2259         uint8 _slen = 0;
2260         while (_slen < 32 && _buf[_slen] != 0) {
2261             _slen++;
2262         }
2263 
2264         // solhint-disable-next-line no-inline-assembly
2265         assembly {
2266             _newStr := mload(0x40)
2267             mstore(0x40, add(_newStr, 0x40)) // may end up with extra
2268             mstore(_newStr, _slen)
2269             mstore(add(_newStr, 0x20), _buf)
2270         }
2271     }
2272 
2273     // alignment preserving cast
2274     function addressToBytes32(address _addr) internal pure returns (bytes32) {
2275         return bytes32(uint256(uint160(_addr)));
2276     }
2277 
2278     // alignment preserving cast
2279     function bytes32ToAddress(bytes32 _buf) internal pure returns (address) {
2280         return address(uint160(uint256(_buf)));
2281     }
2282 }
2283 
2284 
2285 // File contracts/libs/Message.sol
2286 
2287 
2288 pragma solidity >=0.8.0;
2289 
2290 /**
2291  * @title Hyperlane Message Library
2292  * @notice Library for formatted messages used by Mailbox
2293  **/
2294 library Message {
2295     using TypeCasts for bytes32;
2296 
2297     uint256 private constant VERSION_OFFSET = 0;
2298     uint256 private constant NONCE_OFFSET = 1;
2299     uint256 private constant ORIGIN_OFFSET = 5;
2300     uint256 private constant SENDER_OFFSET = 9;
2301     uint256 private constant DESTINATION_OFFSET = 41;
2302     uint256 private constant RECIPIENT_OFFSET = 45;
2303     uint256 private constant BODY_OFFSET = 77;
2304 
2305     /**
2306      * @notice Returns formatted (packed) Hyperlane message with provided fields
2307      * @dev This function should only be used in memory message construction.
2308      * @param _version The version of the origin and destination Mailboxes
2309      * @param _nonce A nonce to uniquely identify the message on its origin chain
2310      * @param _originDomain Domain of origin chain
2311      * @param _sender Address of sender as bytes32
2312      * @param _destinationDomain Domain of destination chain
2313      * @param _recipient Address of recipient on destination chain as bytes32
2314      * @param _messageBody Raw bytes of message body
2315      * @return Formatted message
2316      */
2317     function formatMessage(
2318         uint8 _version,
2319         uint32 _nonce,
2320         uint32 _originDomain,
2321         bytes32 _sender,
2322         uint32 _destinationDomain,
2323         bytes32 _recipient,
2324         bytes calldata _messageBody
2325     ) internal pure returns (bytes memory) {
2326         return
2327             abi.encodePacked(
2328                 _version,
2329                 _nonce,
2330                 _originDomain,
2331                 _sender,
2332                 _destinationDomain,
2333                 _recipient,
2334                 _messageBody
2335             );
2336     }
2337 
2338     /**
2339      * @notice Returns the message ID.
2340      * @param _message ABI encoded Hyperlane message.
2341      * @return ID of `_message`
2342      */
2343     function id(bytes memory _message) internal pure returns (bytes32) {
2344         return keccak256(_message);
2345     }
2346 
2347     /**
2348      * @notice Returns the message version.
2349      * @param _message ABI encoded Hyperlane message.
2350      * @return Version of `_message`
2351      */
2352     function version(bytes calldata _message) internal pure returns (uint8) {
2353         return uint8(bytes1(_message[VERSION_OFFSET:NONCE_OFFSET]));
2354     }
2355 
2356     /**
2357      * @notice Returns the message nonce.
2358      * @param _message ABI encoded Hyperlane message.
2359      * @return Nonce of `_message`
2360      */
2361     function nonce(bytes calldata _message) internal pure returns (uint32) {
2362         return uint32(bytes4(_message[NONCE_OFFSET:ORIGIN_OFFSET]));
2363     }
2364 
2365     /**
2366      * @notice Returns the message origin domain.
2367      * @param _message ABI encoded Hyperlane message.
2368      * @return Origin domain of `_message`
2369      */
2370     function origin(bytes calldata _message) internal pure returns (uint32) {
2371         return uint32(bytes4(_message[ORIGIN_OFFSET:SENDER_OFFSET]));
2372     }
2373 
2374     /**
2375      * @notice Returns the message sender as bytes32.
2376      * @param _message ABI encoded Hyperlane message.
2377      * @return Sender of `_message` as bytes32
2378      */
2379     function sender(bytes calldata _message) internal pure returns (bytes32) {
2380         return bytes32(_message[SENDER_OFFSET:DESTINATION_OFFSET]);
2381     }
2382 
2383     /**
2384      * @notice Returns the message sender as address.
2385      * @param _message ABI encoded Hyperlane message.
2386      * @return Sender of `_message` as address
2387      */
2388     function senderAddress(bytes calldata _message)
2389         internal
2390         pure
2391         returns (address)
2392     {
2393         return sender(_message).bytes32ToAddress();
2394     }
2395 
2396     /**
2397      * @notice Returns the message destination domain.
2398      * @param _message ABI encoded Hyperlane message.
2399      * @return Destination domain of `_message`
2400      */
2401     function destination(bytes calldata _message)
2402         internal
2403         pure
2404         returns (uint32)
2405     {
2406         return uint32(bytes4(_message[DESTINATION_OFFSET:RECIPIENT_OFFSET]));
2407     }
2408 
2409     /**
2410      * @notice Returns the message recipient as bytes32.
2411      * @param _message ABI encoded Hyperlane message.
2412      * @return Recipient of `_message` as bytes32
2413      */
2414     function recipient(bytes calldata _message)
2415         internal
2416         pure
2417         returns (bytes32)
2418     {
2419         return bytes32(_message[RECIPIENT_OFFSET:BODY_OFFSET]);
2420     }
2421 
2422     /**
2423      * @notice Returns the message recipient as address.
2424      * @param _message ABI encoded Hyperlane message.
2425      * @return Recipient of `_message` as address
2426      */
2427     function recipientAddress(bytes calldata _message)
2428         internal
2429         pure
2430         returns (address)
2431     {
2432         return recipient(_message).bytes32ToAddress();
2433     }
2434 
2435     /**
2436      * @notice Returns the message body.
2437      * @param _message ABI encoded Hyperlane message.
2438      * @return Body of `_message`
2439      */
2440     function body(bytes calldata _message)
2441         internal
2442         pure
2443         returns (bytes calldata)
2444     {
2445         return bytes(_message[BODY_OFFSET:]);
2446     }
2447 }
2448 
2449 
2450 // File contracts/libs/MultisigIsmMetadata.sol
2451 
2452 
2453 pragma solidity >=0.8.0;
2454 
2455 /**
2456  * Format of metadata:
2457  * [   0:  32] Merkle root
2458  * [  32:  36] Root index
2459  * [  36:  68] Origin mailbox address
2460  * [  68:1092] Merkle proof
2461  * [1092:1093] Threshold
2462  * [1093:????] Validator signatures, 65 bytes each, length == Threshold
2463  * [????:????] Addresses of the entire validator set, left padded to bytes32
2464  */
2465 library MultisigIsmMetadata {
2466     uint256 private constant MERKLE_ROOT_OFFSET = 0;
2467     uint256 private constant MERKLE_INDEX_OFFSET = 32;
2468     uint256 private constant ORIGIN_MAILBOX_OFFSET = 36;
2469     uint256 private constant MERKLE_PROOF_OFFSET = 68;
2470     uint256 private constant THRESHOLD_OFFSET = 1092;
2471     uint256 private constant SIGNATURES_OFFSET = 1093;
2472     uint256 private constant SIGNATURE_LENGTH = 65;
2473 
2474     /**
2475      * @notice Returns the merkle root of the signed checkpoint.
2476      * @param _metadata ABI encoded Multisig ISM metadata.
2477      * @return Merkle root of the signed checkpoint
2478      */
2479     function root(bytes calldata _metadata) internal pure returns (bytes32) {
2480         return bytes32(_metadata[MERKLE_ROOT_OFFSET:MERKLE_INDEX_OFFSET]);
2481     }
2482 
2483     /**
2484      * @notice Returns the index of the signed checkpoint.
2485      * @param _metadata ABI encoded Multisig ISM metadata.
2486      * @return Index of the signed checkpoint
2487      */
2488     function index(bytes calldata _metadata) internal pure returns (uint32) {
2489         return
2490             uint32(
2491                 bytes4(_metadata[MERKLE_INDEX_OFFSET:ORIGIN_MAILBOX_OFFSET])
2492             );
2493     }
2494 
2495     /**
2496      * @notice Returns the origin mailbox of the signed checkpoint as bytes32.
2497      * @param _metadata ABI encoded Multisig ISM metadata.
2498      * @return Origin mailbox of the signed checkpoint as bytes32
2499      */
2500     function originMailbox(bytes calldata _metadata)
2501         internal
2502         pure
2503         returns (bytes32)
2504     {
2505         return bytes32(_metadata[ORIGIN_MAILBOX_OFFSET:MERKLE_PROOF_OFFSET]);
2506     }
2507 
2508     /**
2509      * @notice Returns the merkle proof branch of the message.
2510      * @dev This appears to be more gas efficient than returning a calldata
2511      * slice and using that.
2512      * @param _metadata ABI encoded Multisig ISM metadata.
2513      * @return Merkle proof branch of the message.
2514      */
2515     function proof(bytes calldata _metadata)
2516         internal
2517         pure
2518         returns (bytes32[32] memory)
2519     {
2520         return
2521             abi.decode(
2522                 _metadata[MERKLE_PROOF_OFFSET:THRESHOLD_OFFSET],
2523                 (bytes32[32])
2524             );
2525     }
2526 
2527     /**
2528      * @notice Returns the number of required signatures. Verified against
2529      * the commitment stored in the module.
2530      * @param _metadata ABI encoded Multisig ISM metadata.
2531      * @return The number of required signatures.
2532      */
2533     function threshold(bytes calldata _metadata) internal pure returns (uint8) {
2534         return uint8(bytes1(_metadata[THRESHOLD_OFFSET:SIGNATURES_OFFSET]));
2535     }
2536 
2537     /**
2538      * @notice Returns the validator ECDSA signature at `_index`.
2539      * @dev Assumes signatures are sorted by validator
2540      * @dev Assumes `_metadata` encodes `threshold` signatures.
2541      * @dev Assumes `_index` is less than `threshold`
2542      * @param _metadata ABI encoded Multisig ISM metadata.
2543      * @param _index The index of the signature to return.
2544      * @return The validator ECDSA signature at `_index`.
2545      */
2546     function signatureAt(bytes calldata _metadata, uint256 _index)
2547         internal
2548         pure
2549         returns (bytes calldata)
2550     {
2551         uint256 _start = SIGNATURES_OFFSET + (_index * SIGNATURE_LENGTH);
2552         uint256 _end = _start + SIGNATURE_LENGTH;
2553         return _metadata[_start:_end];
2554     }
2555 
2556     /**
2557      * @notice Returns the validator address at `_index`.
2558      * @dev Assumes `_index` is less than the number of validators
2559      * @param _metadata ABI encoded Multisig ISM metadata.
2560      * @param _index The index of the validator to return.
2561      * @return The validator address at `_index`.
2562      */
2563     function validatorAt(bytes calldata _metadata, uint256 _index)
2564         internal
2565         pure
2566         returns (address)
2567     {
2568         // Validator addresses are left padded to bytes32 in order to match
2569         // abi.encodePacked(address[]).
2570         uint256 _start = _validatorsOffset(_metadata) + (_index * 32) + 12;
2571         uint256 _end = _start + 20;
2572         return address(bytes20(_metadata[_start:_end]));
2573     }
2574 
2575     /**
2576      * @notice Returns the validator set encoded as bytes. Verified against the
2577      * commitment stored in the module.
2578      * @dev Validator addresses are encoded as tightly packed array of bytes32,
2579      * sorted to match the enumerable set stored by the module.
2580      * @param _metadata ABI encoded Multisig ISM metadata.
2581      * @return The validator set encoded as bytes.
2582      */
2583     function validators(bytes calldata _metadata)
2584         internal
2585         pure
2586         returns (bytes calldata)
2587     {
2588         return _metadata[_validatorsOffset(_metadata):];
2589     }
2590 
2591     /**
2592      * @notice Returns the size of the validator set encoded in the metadata
2593      * @dev Validator addresses are encoded as tightly packed array of bytes32,
2594      * sorted to match the enumerable set stored by the module.
2595      * @param _metadata ABI encoded Multisig ISM metadata.
2596      * @return The size of the validator set encoded in the metadata
2597      */
2598     function commitment(bytes calldata _metadata)
2599         internal
2600         pure
2601         returns (uint256)
2602     {
2603         return (_metadata.length - _validatorsOffset(_metadata)) / 32;
2604     }
2605 
2606     /**
2607      * @notice Returns the size of the validator set encoded in the metadata
2608      * @dev Validator addresses are encoded as tightly packed array of bytes32,
2609      * sorted to match the enumerable set stored by the module.
2610      * @param _metadata ABI encoded Multisig ISM metadata.
2611      * @return The size of the validator set encoded in the metadata
2612      */
2613     function validatorCount(bytes calldata _metadata)
2614         internal
2615         pure
2616         returns (uint256)
2617     {
2618         return (_metadata.length - _validatorsOffset(_metadata)) / 32;
2619     }
2620 
2621     /**
2622      * @notice Returns the offset in bytes of the list of validators within
2623      * `_metadata`.
2624      * @param _metadata ABI encoded Multisig ISM metadata.
2625      * @return The index at which the list of validators starts
2626      */
2627     function _validatorsOffset(bytes calldata _metadata)
2628         private
2629         pure
2630         returns (uint256)
2631     {
2632         return
2633             SIGNATURES_OFFSET +
2634             (uint256(threshold(_metadata)) * SIGNATURE_LENGTH);
2635     }
2636 }
2637 
2638 
2639 // File contracts/libs/Merkle.sol
2640 
2641 
2642 pragma solidity >=0.6.11;
2643 
2644 // work based on eth2 deposit contract, which is used under CC0-1.0
2645 
2646 /**
2647  * @title MerkleLib
2648  * @author Celo Labs Inc.
2649  * @notice An incremental merkle tree modeled on the eth2 deposit contract.
2650  **/
2651 library MerkleLib {
2652     uint256 internal constant TREE_DEPTH = 32;
2653     uint256 internal constant MAX_LEAVES = 2**TREE_DEPTH - 1;
2654 
2655     /**
2656      * @notice Struct representing incremental merkle tree. Contains current
2657      * branch and the number of inserted leaves in the tree.
2658      **/
2659     struct Tree {
2660         bytes32[TREE_DEPTH] branch;
2661         uint256 count;
2662     }
2663 
2664     /**
2665      * @notice Inserts `_node` into merkle tree
2666      * @dev Reverts if tree is full
2667      * @param _node Element to insert into tree
2668      **/
2669     function insert(Tree storage _tree, bytes32 _node) internal {
2670         require(_tree.count < MAX_LEAVES, "merkle tree full");
2671 
2672         _tree.count += 1;
2673         uint256 size = _tree.count;
2674         for (uint256 i = 0; i < TREE_DEPTH; i++) {
2675             if ((size & 1) == 1) {
2676                 _tree.branch[i] = _node;
2677                 return;
2678             }
2679             _node = keccak256(abi.encodePacked(_tree.branch[i], _node));
2680             size /= 2;
2681         }
2682         // As the loop should always end prematurely with the `return` statement,
2683         // this code should be unreachable. We assert `false` just to be safe.
2684         assert(false);
2685     }
2686 
2687     /**
2688      * @notice Calculates and returns`_tree`'s current root given array of zero
2689      * hashes
2690      * @param _zeroes Array of zero hashes
2691      * @return _current Calculated root of `_tree`
2692      **/
2693     function rootWithCtx(Tree storage _tree, bytes32[TREE_DEPTH] memory _zeroes)
2694         internal
2695         view
2696         returns (bytes32 _current)
2697     {
2698         uint256 _index = _tree.count;
2699 
2700         for (uint256 i = 0; i < TREE_DEPTH; i++) {
2701             uint256 _ithBit = (_index >> i) & 0x01;
2702             bytes32 _next = _tree.branch[i];
2703             if (_ithBit == 1) {
2704                 _current = keccak256(abi.encodePacked(_next, _current));
2705             } else {
2706                 _current = keccak256(abi.encodePacked(_current, _zeroes[i]));
2707             }
2708         }
2709     }
2710 
2711     /// @notice Calculates and returns`_tree`'s current root
2712     function root(Tree storage _tree) internal view returns (bytes32) {
2713         return rootWithCtx(_tree, zeroHashes());
2714     }
2715 
2716     /// @notice Returns array of TREE_DEPTH zero hashes
2717     /// @return _zeroes Array of TREE_DEPTH zero hashes
2718     function zeroHashes()
2719         internal
2720         pure
2721         returns (bytes32[TREE_DEPTH] memory _zeroes)
2722     {
2723         _zeroes[0] = Z_0;
2724         _zeroes[1] = Z_1;
2725         _zeroes[2] = Z_2;
2726         _zeroes[3] = Z_3;
2727         _zeroes[4] = Z_4;
2728         _zeroes[5] = Z_5;
2729         _zeroes[6] = Z_6;
2730         _zeroes[7] = Z_7;
2731         _zeroes[8] = Z_8;
2732         _zeroes[9] = Z_9;
2733         _zeroes[10] = Z_10;
2734         _zeroes[11] = Z_11;
2735         _zeroes[12] = Z_12;
2736         _zeroes[13] = Z_13;
2737         _zeroes[14] = Z_14;
2738         _zeroes[15] = Z_15;
2739         _zeroes[16] = Z_16;
2740         _zeroes[17] = Z_17;
2741         _zeroes[18] = Z_18;
2742         _zeroes[19] = Z_19;
2743         _zeroes[20] = Z_20;
2744         _zeroes[21] = Z_21;
2745         _zeroes[22] = Z_22;
2746         _zeroes[23] = Z_23;
2747         _zeroes[24] = Z_24;
2748         _zeroes[25] = Z_25;
2749         _zeroes[26] = Z_26;
2750         _zeroes[27] = Z_27;
2751         _zeroes[28] = Z_28;
2752         _zeroes[29] = Z_29;
2753         _zeroes[30] = Z_30;
2754         _zeroes[31] = Z_31;
2755     }
2756 
2757     /**
2758      * @notice Calculates and returns the merkle root for the given leaf
2759      * `_item`, a merkle branch, and the index of `_item` in the tree.
2760      * @param _item Merkle leaf
2761      * @param _branch Merkle proof
2762      * @param _index Index of `_item` in tree
2763      * @return _current Calculated merkle root
2764      **/
2765     function branchRoot(
2766         bytes32 _item,
2767         bytes32[TREE_DEPTH] memory _branch,
2768         uint256 _index
2769     ) internal pure returns (bytes32 _current) {
2770         _current = _item;
2771 
2772         for (uint256 i = 0; i < TREE_DEPTH; i++) {
2773             uint256 _ithBit = (_index >> i) & 0x01;
2774             bytes32 _next = _branch[i];
2775             if (_ithBit == 1) {
2776                 _current = keccak256(abi.encodePacked(_next, _current));
2777             } else {
2778                 _current = keccak256(abi.encodePacked(_current, _next));
2779             }
2780         }
2781     }
2782 
2783     // keccak256 zero hashes
2784     bytes32 internal constant Z_0 =
2785         hex"0000000000000000000000000000000000000000000000000000000000000000";
2786     bytes32 internal constant Z_1 =
2787         hex"ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5";
2788     bytes32 internal constant Z_2 =
2789         hex"b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d30";
2790     bytes32 internal constant Z_3 =
2791         hex"21ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85";
2792     bytes32 internal constant Z_4 =
2793         hex"e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344";
2794     bytes32 internal constant Z_5 =
2795         hex"0eb01ebfc9ed27500cd4dfc979272d1f0913cc9f66540d7e8005811109e1cf2d";
2796     bytes32 internal constant Z_6 =
2797         hex"887c22bd8750d34016ac3c66b5ff102dacdd73f6b014e710b51e8022af9a1968";
2798     bytes32 internal constant Z_7 =
2799         hex"ffd70157e48063fc33c97a050f7f640233bf646cc98d9524c6b92bcf3ab56f83";
2800     bytes32 internal constant Z_8 =
2801         hex"9867cc5f7f196b93bae1e27e6320742445d290f2263827498b54fec539f756af";
2802     bytes32 internal constant Z_9 =
2803         hex"cefad4e508c098b9a7e1d8feb19955fb02ba9675585078710969d3440f5054e0";
2804     bytes32 internal constant Z_10 =
2805         hex"f9dc3e7fe016e050eff260334f18a5d4fe391d82092319f5964f2e2eb7c1c3a5";
2806     bytes32 internal constant Z_11 =
2807         hex"f8b13a49e282f609c317a833fb8d976d11517c571d1221a265d25af778ecf892";
2808     bytes32 internal constant Z_12 =
2809         hex"3490c6ceeb450aecdc82e28293031d10c7d73bf85e57bf041a97360aa2c5d99c";
2810     bytes32 internal constant Z_13 =
2811         hex"c1df82d9c4b87413eae2ef048f94b4d3554cea73d92b0f7af96e0271c691e2bb";
2812     bytes32 internal constant Z_14 =
2813         hex"5c67add7c6caf302256adedf7ab114da0acfe870d449a3a489f781d659e8becc";
2814     bytes32 internal constant Z_15 =
2815         hex"da7bce9f4e8618b6bd2f4132ce798cdc7a60e7e1460a7299e3c6342a579626d2";
2816     bytes32 internal constant Z_16 =
2817         hex"2733e50f526ec2fa19a22b31e8ed50f23cd1fdf94c9154ed3a7609a2f1ff981f";
2818     bytes32 internal constant Z_17 =
2819         hex"e1d3b5c807b281e4683cc6d6315cf95b9ade8641defcb32372f1c126e398ef7a";
2820     bytes32 internal constant Z_18 =
2821         hex"5a2dce0a8a7f68bb74560f8f71837c2c2ebbcbf7fffb42ae1896f13f7c7479a0";
2822     bytes32 internal constant Z_19 =
2823         hex"b46a28b6f55540f89444f63de0378e3d121be09e06cc9ded1c20e65876d36aa0";
2824     bytes32 internal constant Z_20 =
2825         hex"c65e9645644786b620e2dd2ad648ddfcbf4a7e5b1a3a4ecfe7f64667a3f0b7e2";
2826     bytes32 internal constant Z_21 =
2827         hex"f4418588ed35a2458cffeb39b93d26f18d2ab13bdce6aee58e7b99359ec2dfd9";
2828     bytes32 internal constant Z_22 =
2829         hex"5a9c16dc00d6ef18b7933a6f8dc65ccb55667138776f7dea101070dc8796e377";
2830     bytes32 internal constant Z_23 =
2831         hex"4df84f40ae0c8229d0d6069e5c8f39a7c299677a09d367fc7b05e3bc380ee652";
2832     bytes32 internal constant Z_24 =
2833         hex"cdc72595f74c7b1043d0e1ffbab734648c838dfb0527d971b602bc216c9619ef";
2834     bytes32 internal constant Z_25 =
2835         hex"0abf5ac974a1ed57f4050aa510dd9c74f508277b39d7973bb2dfccc5eeb0618d";
2836     bytes32 internal constant Z_26 =
2837         hex"b8cd74046ff337f0a7bf2c8e03e10f642c1886798d71806ab1e888d9e5ee87d0";
2838     bytes32 internal constant Z_27 =
2839         hex"838c5655cb21c6cb83313b5a631175dff4963772cce9108188b34ac87c81c41e";
2840     bytes32 internal constant Z_28 =
2841         hex"662ee4dd2dd7b2bc707961b1e646c4047669dcb6584f0d8d770daf5d7e7deb2e";
2842     bytes32 internal constant Z_29 =
2843         hex"388ab20e2573d171a88108e79d820e98f26c0b84aa8b2f4aa4968dbb818ea322";
2844     bytes32 internal constant Z_30 =
2845         hex"93237c50ba75ee485f4c22adf2f741400bdf8d6a9cc7df7ecae576221665d735";
2846     bytes32 internal constant Z_31 =
2847         hex"8448818bb4ae4562849e949e17ac16e0be16688e156b5cf15e098c627c0056a9";
2848 }
2849 
2850 
2851 // File contracts/isms/MultisigIsm.sol
2852 
2853 
2854 pragma solidity >=0.8.0;
2855 
2856 // ============ External Imports ============
2857 
2858 
2859 
2860 // ============ Internal Imports ============
2861 
2862 
2863 
2864 
2865 /**
2866  * @title MultisigIsm
2867  * @notice Manages an ownable set of validators that ECDSA sign checkpoints to
2868  * reach a quorum.
2869  */
2870 contract MultisigIsm is IMultisigIsm, Ownable {
2871     // ============ Libraries ============
2872 
2873     using EnumerableSet for EnumerableSet.AddressSet;
2874     using Message for bytes;
2875     using MultisigIsmMetadata for bytes;
2876     using MerkleLib for MerkleLib.Tree;
2877 
2878     // ============ Constants ============
2879 
2880     uint8 public constant moduleType = 3;
2881 
2882     // ============ Mutable Storage ============
2883 
2884     /// @notice The validator threshold for each remote domain.
2885     mapping(uint32 => uint8) public threshold;
2886 
2887     /// @notice The validator set for each remote domain.
2888     mapping(uint32 => EnumerableSet.AddressSet) private validatorSet;
2889 
2890     /// @notice A succinct commitment to the validator set and threshold for each remote
2891     /// domain.
2892     mapping(uint32 => bytes32) public commitment;
2893 
2894     // ============ Events ============
2895 
2896     /**
2897      * @notice Emitted when a validator is enrolled in a validator set.
2898      * @param domain The remote domain of the validator set.
2899      * @param validator The address of the validator.
2900      * @param validatorCount The number of enrolled validators in the validator set.
2901      */
2902     event ValidatorEnrolled(
2903         uint32 indexed domain,
2904         address indexed validator,
2905         uint256 validatorCount
2906     );
2907 
2908     /**
2909      * @notice Emitted when a validator is unenrolled from a validator set.
2910      * @param domain The remote domain of the validator set.
2911      * @param validator The address of the validator.
2912      * @param validatorCount The number of enrolled validators in the validator set.
2913      */
2914     event ValidatorUnenrolled(
2915         uint32 indexed domain,
2916         address indexed validator,
2917         uint256 validatorCount
2918     );
2919 
2920     /**
2921      * @notice Emitted when the quorum threshold is set.
2922      * @param domain The remote domain of the validator set.
2923      * @param threshold The new quorum threshold.
2924      */
2925     event ThresholdSet(uint32 indexed domain, uint8 threshold);
2926 
2927     /**
2928      * @notice Emitted when the validator set or threshold changes.
2929      * @param domain The remote domain of the validator set.
2930      * @param commitment A commitment to the validator set and threshold.
2931      */
2932     event CommitmentUpdated(uint32 domain, bytes32 commitment);
2933 
2934     // ============ Constructor ============
2935 
2936     // solhint-disable-next-line no-empty-blocks
2937     constructor() Ownable() {}
2938 
2939     // ============ External Functions ============
2940 
2941     /**
2942      * @notice Enrolls multiple validators into a validator set.
2943      * @dev Reverts if `_validator` is already in the validator set.
2944      * @param _domains The remote domains of the validator sets.
2945      * @param _validators The validators to add to the validator sets.
2946      * @dev _validators[i] are the validators to enroll for _domains[i].
2947      */
2948     function enrollValidators(
2949         uint32[] calldata _domains,
2950         address[][] calldata _validators
2951     ) external onlyOwner {
2952         require(_domains.length == _validators.length, "!length");
2953         for (uint256 i = 0; i < _domains.length; i += 1) {
2954             address[] calldata _domainValidators = _validators[i];
2955             for (uint256 j = 0; j < _domainValidators.length; j += 1) {
2956                 _enrollValidator(_domains[i], _domainValidators[j]);
2957             }
2958             _updateCommitment(_domains[i]);
2959         }
2960     }
2961 
2962     /**
2963      * @notice Enrolls a validator into a validator set.
2964      * @dev Reverts if `_validator` is already in the validator set.
2965      * @param _domain The remote domain of the validator set.
2966      * @param _validator The validator to add to the validator set.
2967      */
2968     function enrollValidator(uint32 _domain, address _validator)
2969         external
2970         onlyOwner
2971     {
2972         _enrollValidator(_domain, _validator);
2973         _updateCommitment(_domain);
2974     }
2975 
2976     /**
2977      * @notice Unenrolls a validator from a validator set.
2978      * @dev Reverts if `_validator` is not in the validator set.
2979      * @param _domain The remote domain of the validator set.
2980      * @param _validator The validator to remove from the validator set.
2981      */
2982     function unenrollValidator(uint32 _domain, address _validator)
2983         external
2984         onlyOwner
2985     {
2986         require(validatorSet[_domain].remove(_validator), "!enrolled");
2987         uint256 _validatorCount = validatorCount(_domain);
2988         require(
2989             _validatorCount >= threshold[_domain],
2990             "violates quorum threshold"
2991         );
2992         _updateCommitment(_domain);
2993         emit ValidatorUnenrolled(_domain, _validator, _validatorCount);
2994     }
2995 
2996     /**
2997      * @notice Sets the quorum threshold for multiple domains.
2998      * @param _domains The remote domains of the validator sets.
2999      * @param _thresholds The new quorum thresholds.
3000      */
3001     function setThresholds(
3002         uint32[] calldata _domains,
3003         uint8[] calldata _thresholds
3004     ) external onlyOwner {
3005         require(_domains.length == _thresholds.length, "!length");
3006         for (uint256 i = 0; i < _domains.length; i += 1) {
3007             setThreshold(_domains[i], _thresholds[i]);
3008         }
3009     }
3010 
3011     /**
3012      * @notice Returns whether an address is enrolled in a validator set.
3013      * @param _domain The remote domain of the validator set.
3014      * @param _address The address to test for set membership.
3015      * @return True if the address is enrolled, false otherwise.
3016      */
3017     function isEnrolled(uint32 _domain, address _address)
3018         external
3019         view
3020         returns (bool)
3021     {
3022         EnumerableSet.AddressSet storage _validatorSet = validatorSet[_domain];
3023         return _validatorSet.contains(_address);
3024     }
3025 
3026     // ============ Public Functions ============
3027 
3028     /**
3029      * @notice Sets the quorum threshold.
3030      * @param _domain The remote domain of the validator set.
3031      * @param _threshold The new quorum threshold.
3032      */
3033     function setThreshold(uint32 _domain, uint8 _threshold) public onlyOwner {
3034         require(
3035             _threshold > 0 && _threshold <= validatorCount(_domain),
3036             "!range"
3037         );
3038         threshold[_domain] = _threshold;
3039         emit ThresholdSet(_domain, _threshold);
3040 
3041         _updateCommitment(_domain);
3042     }
3043 
3044     /**
3045      * @notice Verifies that a quorum of the origin domain's validators signed
3046      * a checkpoint, and verifies the merkle proof of `_message` against that
3047      * checkpoint.
3048      * @param _metadata ABI encoded module metadata (see MultisigIsmMetadata.sol)
3049      * @param _message Formatted Hyperlane message (see Message.sol).
3050      */
3051     function verify(bytes calldata _metadata, bytes calldata _message)
3052         public
3053         view
3054         returns (bool)
3055     {
3056         require(_verifyMerkleProof(_metadata, _message), "!merkle");
3057         require(_verifyValidatorSignatures(_metadata, _message), "!sigs");
3058         return true;
3059     }
3060 
3061     /**
3062      * @notice Gets the current validator set
3063      * @param _domain The remote domain of the validator set.
3064      * @return The addresses of the validator set.
3065      */
3066     function validators(uint32 _domain) public view returns (address[] memory) {
3067         EnumerableSet.AddressSet storage _validatorSet = validatorSet[_domain];
3068         uint256 _validatorCount = _validatorSet.length();
3069         address[] memory _validators = new address[](_validatorCount);
3070         for (uint256 i = 0; i < _validatorCount; i++) {
3071             _validators[i] = _validatorSet.at(i);
3072         }
3073         return _validators;
3074     }
3075 
3076     /**
3077      * @notice Returns the set of validators responsible for verifying _message
3078      * and the number of signatures required
3079      * @dev Can change based on the content of _message
3080      * @param _message Hyperlane formatted interchain message
3081      * @return validators The array of validator addresses
3082      * @return threshold The number of validator signatures needed
3083      */
3084     function validatorsAndThreshold(bytes calldata _message)
3085         external
3086         view
3087         returns (address[] memory, uint8)
3088     {
3089         uint32 _origin = _message.origin();
3090         address[] memory _validators = validators(_origin);
3091         uint8 _threshold = threshold[_origin];
3092         return (_validators, _threshold);
3093     }
3094 
3095     /**
3096      * @notice Returns the number of validators enrolled in the validator set.
3097      * @param _domain The remote domain of the validator set.
3098      * @return The number of validators enrolled in the validator set.
3099      */
3100     function validatorCount(uint32 _domain) public view returns (uint256) {
3101         return validatorSet[_domain].length();
3102     }
3103 
3104     // ============ Internal Functions ============
3105 
3106     /**
3107      * @notice Enrolls a validator into a validator set.
3108      * @dev Reverts if `_validator` is already in the validator set.
3109      * @param _domain The remote domain of the validator set.
3110      * @param _validator The validator to add to the validator set.
3111      */
3112     function _enrollValidator(uint32 _domain, address _validator) internal {
3113         require(_validator != address(0), "zero address");
3114         require(validatorSet[_domain].add(_validator), "already enrolled");
3115         emit ValidatorEnrolled(_domain, _validator, validatorCount(_domain));
3116     }
3117 
3118     /**
3119      * @notice Updates the commitment to the validator set for `_domain`.
3120      * @param _domain The remote domain of the validator set.
3121      * @return The commitment to the validator set for `_domain`.
3122      */
3123     function _updateCommitment(uint32 _domain) internal returns (bytes32) {
3124         address[] memory _validators = validators(_domain);
3125         uint8 _threshold = threshold[_domain];
3126         bytes32 _commitment = keccak256(
3127             abi.encodePacked(_threshold, _validators)
3128         );
3129         commitment[_domain] = _commitment;
3130         emit CommitmentUpdated(_domain, _commitment);
3131         return _commitment;
3132     }
3133 
3134     /**
3135      * @notice Verifies the merkle proof of `_message` against the provided
3136      * checkpoint.
3137      * @param _metadata ABI encoded module metadata (see MultisigIsmMetadata.sol)
3138      * @param _message Formatted Hyperlane message (see Message.sol).
3139      */
3140     function _verifyMerkleProof(
3141         bytes calldata _metadata,
3142         bytes calldata _message
3143     ) internal pure returns (bool) {
3144         // calculate the expected root based on the proof
3145         bytes32 _calculatedRoot = MerkleLib.branchRoot(
3146             _message.id(),
3147             _metadata.proof(),
3148             _message.nonce()
3149         );
3150         return _calculatedRoot == _metadata.root();
3151     }
3152 
3153     /**
3154      * @notice Verifies that a quorum of the origin domain's validators signed
3155      * the provided checkpoint.
3156      * @param _metadata ABI encoded module metadata (see MultisigIsmMetadata.sol)
3157      * @param _message Formatted Hyperlane message (see Message.sol).
3158      */
3159     function _verifyValidatorSignatures(
3160         bytes calldata _metadata,
3161         bytes calldata _message
3162     ) internal view returns (bool) {
3163         uint8 _threshold = _metadata.threshold();
3164         bytes32 _digest;
3165         {
3166             uint32 _origin = _message.origin();
3167 
3168             bytes32 _commitment = keccak256(
3169                 abi.encodePacked(_threshold, _metadata.validators())
3170             );
3171             // Ensures the validator set encoded in the metadata matches
3172             // what we've stored on chain.
3173             // NB: An empty validator set in `_metadata` will result in a
3174             // non-zero computed commitment, and this check will fail
3175             // as the commitment in storage will be zero.
3176             require(_commitment == commitment[_origin], "!commitment");
3177             _digest = _getCheckpointDigest(_metadata, _origin);
3178         }
3179         uint256 _validatorCount = _metadata.validatorCount();
3180         uint256 _validatorIndex = 0;
3181         // Assumes that signatures are ordered by validator
3182         for (uint256 i = 0; i < _threshold; ++i) {
3183             address _signer = ECDSA.recover(_digest, _metadata.signatureAt(i));
3184             // Loop through remaining validators until we find a match
3185             for (
3186                 ;
3187                 _validatorIndex < _validatorCount &&
3188                     _signer != _metadata.validatorAt(_validatorIndex);
3189                 ++_validatorIndex
3190             ) {}
3191             // Fail if we never found a match
3192             require(_validatorIndex < _validatorCount, "!threshold");
3193             ++_validatorIndex;
3194         }
3195         return true;
3196     }
3197 
3198     /**
3199      * @notice Returns the domain hash that validators are expected to use
3200      * when signing checkpoints.
3201      * @param _origin The origin domain of the checkpoint.
3202      * @param _originMailbox The address of the origin mailbox as bytes32.
3203      * @return The domain hash.
3204      */
3205     function _getDomainHash(uint32 _origin, bytes32 _originMailbox)
3206         internal
3207         pure
3208         returns (bytes32)
3209     {
3210         // Including the origin mailbox address in the signature allows the slashing
3211         // protocol to enroll multiple mailboxes. Otherwise, a valid signature for
3212         // mailbox A would be indistinguishable from a fraudulent signature for mailbox
3213         // B.
3214         // The slashing protocol should slash if validators sign attestations for
3215         // anything other than a whitelisted mailbox.
3216         return
3217             keccak256(abi.encodePacked(_origin, _originMailbox, "HYPERLANE"));
3218     }
3219 
3220     /**
3221      * @notice Returns the digest validators are expected to sign when signing checkpoints.
3222      * @param _metadata ABI encoded module metadata (see MultisigIsmMetadata.sol)
3223      * @param _origin The origin domain of the checkpoint.
3224      * @return The digest of the checkpoint.
3225      */
3226     function _getCheckpointDigest(bytes calldata _metadata, uint32 _origin)
3227         internal
3228         pure
3229         returns (bytes32)
3230     {
3231         bytes32 _domainHash = _getDomainHash(
3232             _origin,
3233             _metadata.originMailbox()
3234         );
3235         return
3236             ECDSA.toEthSignedMessageHash(
3237                 keccak256(
3238                     abi.encodePacked(
3239                         _domainHash,
3240                         _metadata.root(),
3241                         _metadata.index()
3242                     )
3243                 )
3244             );
3245     }
3246 }
3247 
3248 
3249 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.8.0
3250 
3251 
3252 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableMap.sol)
3253 // This file was procedurally generated from scripts/generate/templates/EnumerableMap.js.
3254 
3255 pragma solidity ^0.8.0;
3256 
3257 /**
3258  * @dev Library for managing an enumerable variant of Solidity's
3259  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
3260  * type.
3261  *
3262  * Maps have the following properties:
3263  *
3264  * - Entries are added, removed, and checked for existence in constant time
3265  * (O(1)).
3266  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
3267  *
3268  * ```
3269  * contract Example {
3270  *     // Add the library methods
3271  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
3272  *
3273  *     // Declare a set state variable
3274  *     EnumerableMap.UintToAddressMap private myMap;
3275  * }
3276  * ```
3277  *
3278  * The following map types are supported:
3279  *
3280  * - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
3281  * - `address -> uint256` (`AddressToUintMap`) since v4.6.0
3282  * - `bytes32 -> bytes32` (`Bytes32ToBytes32Map`) since v4.6.0
3283  * - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
3284  * - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
3285  *
3286  * [WARNING]
3287  * ====
3288  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
3289  * unusable.
3290  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
3291  *
3292  * In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an
3293  * array of EnumerableMap.
3294  * ====
3295  */
3296 library EnumerableMap {
3297     using EnumerableSet for EnumerableSet.Bytes32Set;
3298 
3299     // To implement this library for multiple types with as little code
3300     // repetition as possible, we write it in terms of a generic Map type with
3301     // bytes32 keys and values.
3302     // The Map implementation uses private functions, and user-facing
3303     // implementations (such as Uint256ToAddressMap) are just wrappers around
3304     // the underlying Map.
3305     // This means that we can only create new EnumerableMaps for types that fit
3306     // in bytes32.
3307 
3308     struct Bytes32ToBytes32Map {
3309         // Storage of keys
3310         EnumerableSet.Bytes32Set _keys;
3311         mapping(bytes32 => bytes32) _values;
3312     }
3313 
3314     /**
3315      * @dev Adds a key-value pair to a map, or updates the value for an existing
3316      * key. O(1).
3317      *
3318      * Returns true if the key was added to the map, that is if it was not
3319      * already present.
3320      */
3321     function set(
3322         Bytes32ToBytes32Map storage map,
3323         bytes32 key,
3324         bytes32 value
3325     ) internal returns (bool) {
3326         map._values[key] = value;
3327         return map._keys.add(key);
3328     }
3329 
3330     /**
3331      * @dev Removes a key-value pair from a map. O(1).
3332      *
3333      * Returns true if the key was removed from the map, that is if it was present.
3334      */
3335     function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
3336         delete map._values[key];
3337         return map._keys.remove(key);
3338     }
3339 
3340     /**
3341      * @dev Returns true if the key is in the map. O(1).
3342      */
3343     function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
3344         return map._keys.contains(key);
3345     }
3346 
3347     /**
3348      * @dev Returns the number of key-value pairs in the map. O(1).
3349      */
3350     function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
3351         return map._keys.length();
3352     }
3353 
3354     /**
3355      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
3356      *
3357      * Note that there are no guarantees on the ordering of entries inside the
3358      * array, and it may change when more entries are added or removed.
3359      *
3360      * Requirements:
3361      *
3362      * - `index` must be strictly less than {length}.
3363      */
3364     function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
3365         bytes32 key = map._keys.at(index);
3366         return (key, map._values[key]);
3367     }
3368 
3369     /**
3370      * @dev Tries to returns the value associated with `key`. O(1).
3371      * Does not revert if `key` is not in the map.
3372      */
3373     function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
3374         bytes32 value = map._values[key];
3375         if (value == bytes32(0)) {
3376             return (contains(map, key), bytes32(0));
3377         } else {
3378             return (true, value);
3379         }
3380     }
3381 
3382     /**
3383      * @dev Returns the value associated with `key`. O(1).
3384      *
3385      * Requirements:
3386      *
3387      * - `key` must be in the map.
3388      */
3389     function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
3390         bytes32 value = map._values[key];
3391         require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
3392         return value;
3393     }
3394 
3395     /**
3396      * @dev Same as {get}, with a custom error message when `key` is not in the map.
3397      *
3398      * CAUTION: This function is deprecated because it requires allocating memory for the error
3399      * message unnecessarily. For custom revert reasons use {tryGet}.
3400      */
3401     function get(
3402         Bytes32ToBytes32Map storage map,
3403         bytes32 key,
3404         string memory errorMessage
3405     ) internal view returns (bytes32) {
3406         bytes32 value = map._values[key];
3407         require(value != 0 || contains(map, key), errorMessage);
3408         return value;
3409     }
3410 
3411     // UintToUintMap
3412 
3413     struct UintToUintMap {
3414         Bytes32ToBytes32Map _inner;
3415     }
3416 
3417     /**
3418      * @dev Adds a key-value pair to a map, or updates the value for an existing
3419      * key. O(1).
3420      *
3421      * Returns true if the key was added to the map, that is if it was not
3422      * already present.
3423      */
3424     function set(
3425         UintToUintMap storage map,
3426         uint256 key,
3427         uint256 value
3428     ) internal returns (bool) {
3429         return set(map._inner, bytes32(key), bytes32(value));
3430     }
3431 
3432     /**
3433      * @dev Removes a value from a set. O(1).
3434      *
3435      * Returns true if the key was removed from the map, that is if it was present.
3436      */
3437     function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
3438         return remove(map._inner, bytes32(key));
3439     }
3440 
3441     /**
3442      * @dev Returns true if the key is in the map. O(1).
3443      */
3444     function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
3445         return contains(map._inner, bytes32(key));
3446     }
3447 
3448     /**
3449      * @dev Returns the number of elements in the map. O(1).
3450      */
3451     function length(UintToUintMap storage map) internal view returns (uint256) {
3452         return length(map._inner);
3453     }
3454 
3455     /**
3456      * @dev Returns the element stored at position `index` in the set. O(1).
3457      * Note that there are no guarantees on the ordering of values inside the
3458      * array, and it may change when more values are added or removed.
3459      *
3460      * Requirements:
3461      *
3462      * - `index` must be strictly less than {length}.
3463      */
3464     function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
3465         (bytes32 key, bytes32 value) = at(map._inner, index);
3466         return (uint256(key), uint256(value));
3467     }
3468 
3469     /**
3470      * @dev Tries to returns the value associated with `key`. O(1).
3471      * Does not revert if `key` is not in the map.
3472      */
3473     function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
3474         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
3475         return (success, uint256(value));
3476     }
3477 
3478     /**
3479      * @dev Returns the value associated with `key`. O(1).
3480      *
3481      * Requirements:
3482      *
3483      * - `key` must be in the map.
3484      */
3485     function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
3486         return uint256(get(map._inner, bytes32(key)));
3487     }
3488 
3489     /**
3490      * @dev Same as {get}, with a custom error message when `key` is not in the map.
3491      *
3492      * CAUTION: This function is deprecated because it requires allocating memory for the error
3493      * message unnecessarily. For custom revert reasons use {tryGet}.
3494      */
3495     function get(
3496         UintToUintMap storage map,
3497         uint256 key,
3498         string memory errorMessage
3499     ) internal view returns (uint256) {
3500         return uint256(get(map._inner, bytes32(key), errorMessage));
3501     }
3502 
3503     // UintToAddressMap
3504 
3505     struct UintToAddressMap {
3506         Bytes32ToBytes32Map _inner;
3507     }
3508 
3509     /**
3510      * @dev Adds a key-value pair to a map, or updates the value for an existing
3511      * key. O(1).
3512      *
3513      * Returns true if the key was added to the map, that is if it was not
3514      * already present.
3515      */
3516     function set(
3517         UintToAddressMap storage map,
3518         uint256 key,
3519         address value
3520     ) internal returns (bool) {
3521         return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
3522     }
3523 
3524     /**
3525      * @dev Removes a value from a set. O(1).
3526      *
3527      * Returns true if the key was removed from the map, that is if it was present.
3528      */
3529     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
3530         return remove(map._inner, bytes32(key));
3531     }
3532 
3533     /**
3534      * @dev Returns true if the key is in the map. O(1).
3535      */
3536     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
3537         return contains(map._inner, bytes32(key));
3538     }
3539 
3540     /**
3541      * @dev Returns the number of elements in the map. O(1).
3542      */
3543     function length(UintToAddressMap storage map) internal view returns (uint256) {
3544         return length(map._inner);
3545     }
3546 
3547     /**
3548      * @dev Returns the element stored at position `index` in the set. O(1).
3549      * Note that there are no guarantees on the ordering of values inside the
3550      * array, and it may change when more values are added or removed.
3551      *
3552      * Requirements:
3553      *
3554      * - `index` must be strictly less than {length}.
3555      */
3556     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
3557         (bytes32 key, bytes32 value) = at(map._inner, index);
3558         return (uint256(key), address(uint160(uint256(value))));
3559     }
3560 
3561     /**
3562      * @dev Tries to returns the value associated with `key`. O(1).
3563      * Does not revert if `key` is not in the map.
3564      */
3565     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
3566         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
3567         return (success, address(uint160(uint256(value))));
3568     }
3569 
3570     /**
3571      * @dev Returns the value associated with `key`. O(1).
3572      *
3573      * Requirements:
3574      *
3575      * - `key` must be in the map.
3576      */
3577     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
3578         return address(uint160(uint256(get(map._inner, bytes32(key)))));
3579     }
3580 
3581     /**
3582      * @dev Same as {get}, with a custom error message when `key` is not in the map.
3583      *
3584      * CAUTION: This function is deprecated because it requires allocating memory for the error
3585      * message unnecessarily. For custom revert reasons use {tryGet}.
3586      */
3587     function get(
3588         UintToAddressMap storage map,
3589         uint256 key,
3590         string memory errorMessage
3591     ) internal view returns (address) {
3592         return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
3593     }
3594 
3595     // AddressToUintMap
3596 
3597     struct AddressToUintMap {
3598         Bytes32ToBytes32Map _inner;
3599     }
3600 
3601     /**
3602      * @dev Adds a key-value pair to a map, or updates the value for an existing
3603      * key. O(1).
3604      *
3605      * Returns true if the key was added to the map, that is if it was not
3606      * already present.
3607      */
3608     function set(
3609         AddressToUintMap storage map,
3610         address key,
3611         uint256 value
3612     ) internal returns (bool) {
3613         return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
3614     }
3615 
3616     /**
3617      * @dev Removes a value from a set. O(1).
3618      *
3619      * Returns true if the key was removed from the map, that is if it was present.
3620      */
3621     function remove(AddressToUintMap storage map, address key) internal returns (bool) {
3622         return remove(map._inner, bytes32(uint256(uint160(key))));
3623     }
3624 
3625     /**
3626      * @dev Returns true if the key is in the map. O(1).
3627      */
3628     function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
3629         return contains(map._inner, bytes32(uint256(uint160(key))));
3630     }
3631 
3632     /**
3633      * @dev Returns the number of elements in the map. O(1).
3634      */
3635     function length(AddressToUintMap storage map) internal view returns (uint256) {
3636         return length(map._inner);
3637     }
3638 
3639     /**
3640      * @dev Returns the element stored at position `index` in the set. O(1).
3641      * Note that there are no guarantees on the ordering of values inside the
3642      * array, and it may change when more values are added or removed.
3643      *
3644      * Requirements:
3645      *
3646      * - `index` must be strictly less than {length}.
3647      */
3648     function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
3649         (bytes32 key, bytes32 value) = at(map._inner, index);
3650         return (address(uint160(uint256(key))), uint256(value));
3651     }
3652 
3653     /**
3654      * @dev Tries to returns the value associated with `key`. O(1).
3655      * Does not revert if `key` is not in the map.
3656      */
3657     function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
3658         (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
3659         return (success, uint256(value));
3660     }
3661 
3662     /**
3663      * @dev Returns the value associated with `key`. O(1).
3664      *
3665      * Requirements:
3666      *
3667      * - `key` must be in the map.
3668      */
3669     function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
3670         return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
3671     }
3672 
3673     /**
3674      * @dev Same as {get}, with a custom error message when `key` is not in the map.
3675      *
3676      * CAUTION: This function is deprecated because it requires allocating memory for the error
3677      * message unnecessarily. For custom revert reasons use {tryGet}.
3678      */
3679     function get(
3680         AddressToUintMap storage map,
3681         address key,
3682         string memory errorMessage
3683     ) internal view returns (uint256) {
3684         return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
3685     }
3686 
3687     // Bytes32ToUintMap
3688 
3689     struct Bytes32ToUintMap {
3690         Bytes32ToBytes32Map _inner;
3691     }
3692 
3693     /**
3694      * @dev Adds a key-value pair to a map, or updates the value for an existing
3695      * key. O(1).
3696      *
3697      * Returns true if the key was added to the map, that is if it was not
3698      * already present.
3699      */
3700     function set(
3701         Bytes32ToUintMap storage map,
3702         bytes32 key,
3703         uint256 value
3704     ) internal returns (bool) {
3705         return set(map._inner, key, bytes32(value));
3706     }
3707 
3708     /**
3709      * @dev Removes a value from a set. O(1).
3710      *
3711      * Returns true if the key was removed from the map, that is if it was present.
3712      */
3713     function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
3714         return remove(map._inner, key);
3715     }
3716 
3717     /**
3718      * @dev Returns true if the key is in the map. O(1).
3719      */
3720     function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
3721         return contains(map._inner, key);
3722     }
3723 
3724     /**
3725      * @dev Returns the number of elements in the map. O(1).
3726      */
3727     function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
3728         return length(map._inner);
3729     }
3730 
3731     /**
3732      * @dev Returns the element stored at position `index` in the set. O(1).
3733      * Note that there are no guarantees on the ordering of values inside the
3734      * array, and it may change when more values are added or removed.
3735      *
3736      * Requirements:
3737      *
3738      * - `index` must be strictly less than {length}.
3739      */
3740     function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
3741         (bytes32 key, bytes32 value) = at(map._inner, index);
3742         return (key, uint256(value));
3743     }
3744 
3745     /**
3746      * @dev Tries to returns the value associated with `key`. O(1).
3747      * Does not revert if `key` is not in the map.
3748      */
3749     function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
3750         (bool success, bytes32 value) = tryGet(map._inner, key);
3751         return (success, uint256(value));
3752     }
3753 
3754     /**
3755      * @dev Returns the value associated with `key`. O(1).
3756      *
3757      * Requirements:
3758      *
3759      * - `key` must be in the map.
3760      */
3761     function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
3762         return uint256(get(map._inner, key));
3763     }
3764 
3765     /**
3766      * @dev Same as {get}, with a custom error message when `key` is not in the map.
3767      *
3768      * CAUTION: This function is deprecated because it requires allocating memory for the error
3769      * message unnecessarily. For custom revert reasons use {tryGet}.
3770      */
3771     function get(
3772         Bytes32ToUintMap storage map,
3773         bytes32 key,
3774         string memory errorMessage
3775     ) internal view returns (uint256) {
3776         return uint256(get(map._inner, key, errorMessage));
3777     }
3778 }
3779 
3780 
3781 // File contracts/libs/EnumerableMapExtended.sol
3782 
3783 
3784 pragma solidity >=0.6.11;
3785 
3786 // ============ External Imports ============
3787 
3788 // extends EnumerableMap with uint256 => bytes32 type
3789 // modelled after https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/utils/structs/EnumerableMap.sol
3790 library EnumerableMapExtended {
3791     using EnumerableMap for EnumerableMap.Bytes32ToBytes32Map;
3792 
3793     struct UintToBytes32Map {
3794         EnumerableMap.Bytes32ToBytes32Map _inner;
3795     }
3796 
3797     // ============ Library Functions ============
3798     function keys(UintToBytes32Map storage map)
3799         internal
3800         view
3801         returns (bytes32[] storage)
3802     {
3803         return map._inner._keys._inner._values;
3804     }
3805 
3806     function set(
3807         UintToBytes32Map storage map,
3808         uint256 key,
3809         bytes32 value
3810     ) internal {
3811         map._inner.set(bytes32(key), value);
3812     }
3813 
3814     function get(UintToBytes32Map storage map, uint256 key)
3815         internal
3816         view
3817         returns (bytes32)
3818     {
3819         return map._inner.get(bytes32(key));
3820     }
3821 
3822     function remove(UintToBytes32Map storage map, uint256 key)
3823         internal
3824         returns (bool)
3825     {
3826         return map._inner.remove(bytes32(key));
3827     }
3828 
3829     function contains(UintToBytes32Map storage map, uint256 key)
3830         internal
3831         view
3832         returns (bool)
3833     {
3834         return map._inner.contains(bytes32(key));
3835     }
3836 
3837     function length(UintToBytes32Map storage map)
3838         internal
3839         view
3840         returns (uint256)
3841     {
3842         return map._inner.length();
3843     }
3844 
3845     function at(UintToBytes32Map storage map, uint256 index)
3846         internal
3847         view
3848         returns (uint256, bytes32)
3849     {
3850         (bytes32 key, bytes32 value) = map._inner.at(index);
3851         return (uint256(key), value);
3852     }
3853 }
3854 
3855 
3856 // File contracts/upgrade/Versioned.sol
3857 
3858 
3859 pragma solidity >=0.6.11;
3860 
3861 /**
3862  * @title Versioned
3863  * @notice Version getter for contracts
3864  **/
3865 contract Versioned {
3866     uint8 public constant VERSION = 0;
3867 }
3868 
3869 
3870 // File interfaces/IMessageRecipient.sol
3871 
3872 
3873 pragma solidity >=0.6.11;
3874 
3875 interface IMessageRecipient {
3876     function handle(
3877         uint32 _origin,
3878         bytes32 _sender,
3879         bytes calldata _message
3880     ) external;
3881 }
3882 
3883 
3884 // File contracts/PausableReentrancyGuard.sol
3885 
3886 
3887 pragma solidity >=0.8.0;
3888 
3889 // adapted from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
3890 abstract contract PausableReentrancyGuardUpgradeable is Initializable {
3891     uint256 private constant _NOT_ENTERED = 1;
3892     uint256 private constant _ENTERED = 2;
3893     uint256 private constant _PAUSED = 3;
3894 
3895     uint256 private _status;
3896 
3897     /**
3898      * @dev MUST be called for `nonReentrant` to not always revert
3899      */
3900     function __PausableReentrancyGuard_init() internal onlyInitializing {
3901         _status = _NOT_ENTERED;
3902     }
3903 
3904     function _isPaused() internal view returns (bool) {
3905         return _status == _PAUSED;
3906     }
3907 
3908     function _pause() internal notPaused {
3909         _status = _PAUSED;
3910     }
3911 
3912     function _unpause() internal {
3913         require(_isPaused(), "!paused");
3914         _status = _NOT_ENTERED;
3915     }
3916 
3917     /**
3918      * @dev Prevents a contract from being entered when paused.
3919      */
3920     modifier notPaused() {
3921         require(!_isPaused(), "paused");
3922         _;
3923     }
3924 
3925     /**
3926      * @dev Prevents a contract from calling itself, directly or indirectly.
3927      * Calling a `nonReentrant` function from another `nonReentrant`
3928      * function is not supported. It is possible to prevent this from happening
3929      * by making the `nonReentrant` function external, and making it call a
3930      * `private` function that does the actual work.
3931      */
3932     modifier nonReentrantAndNotPaused() {
3933         // status must have been initialized
3934         require(_status == _NOT_ENTERED, "reentrant call (or paused)");
3935 
3936         // Any calls to nonReentrant after this point will fail
3937         _status = _ENTERED;
3938 
3939         _;
3940 
3941         // By storing the original value once again, a refund is triggered (see
3942         // https://eips.ethereum.org/EIPS/eip-2200)
3943         _status = _NOT_ENTERED;
3944     }
3945 
3946     /**
3947      * @dev This empty reserved space is put in place to allow future versions to add new
3948      * variables without shifting down storage in the inheritance chain.
3949      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3950      */
3951     uint256[49] private __gap;
3952 }
3953 
3954 
3955 // File contracts/Mailbox.sol
3956 
3957 
3958 pragma solidity >=0.8.0;
3959 
3960 // ============ Internal Imports ============
3961 
3962 
3963 
3964 
3965 
3966 
3967 
3968 
3969 // ============ External Imports ============
3970 
3971 
3972 contract Mailbox is
3973     IMailbox,
3974     OwnableUpgradeable,
3975     PausableReentrancyGuardUpgradeable,
3976     Versioned
3977 {
3978     // ============ Libraries ============
3979 
3980     using MerkleLib for MerkleLib.Tree;
3981     using Message for bytes;
3982     using TypeCasts for bytes32;
3983     using TypeCasts for address;
3984 
3985     // ============ Constants ============
3986 
3987     // Maximum bytes per message = 2 KiB (somewhat arbitrarily set to begin)
3988     uint256 public constant MAX_MESSAGE_BODY_BYTES = 2 * 2**10;
3989     // Domain of chain on which the contract is deployed
3990     uint32 public immutable localDomain;
3991 
3992     // ============ Public Storage ============
3993 
3994     // The default ISM, used if the recipient fails to specify one.
3995     IInterchainSecurityModule public defaultIsm;
3996     // An incremental merkle tree used to store outbound message IDs.
3997     MerkleLib.Tree public tree;
3998     // Mapping of message ID to whether or not that message has been delivered.
3999     mapping(bytes32 => bool) public delivered;
4000 
4001     // ============ Upgrade Gap ============
4002 
4003     // gap for upgrade safety
4004     uint256[47] private __GAP;
4005 
4006     // ============ Events ============
4007 
4008     /**
4009      * @notice Emitted when the default ISM is updated
4010      * @param module The new default ISM
4011      */
4012     event DefaultIsmSet(address indexed module);
4013 
4014     /**
4015      * @notice Emitted when a new message is dispatched via Hyperlane
4016      * @param sender The address that dispatched the message
4017      * @param destination The destination domain of the message
4018      * @param recipient The message recipient address on `destination`
4019      * @param message Raw bytes of message
4020      */
4021     event Dispatch(
4022         address indexed sender,
4023         uint32 indexed destination,
4024         bytes32 indexed recipient,
4025         bytes message
4026     );
4027 
4028     /**
4029      * @notice Emitted when a new message is dispatched via Hyperlane
4030      * @param messageId The unique message identifier
4031      */
4032     event DispatchId(bytes32 indexed messageId);
4033 
4034     /**
4035      * @notice Emitted when a Hyperlane message is processed
4036      * @param messageId The unique message identifier
4037      */
4038     event ProcessId(bytes32 indexed messageId);
4039 
4040     /**
4041      * @notice Emitted when a Hyperlane message is delivered
4042      * @param origin The origin domain of the message
4043      * @param sender The message sender address on `origin`
4044      * @param recipient The address that handled the message
4045      */
4046     event Process(
4047         uint32 indexed origin,
4048         bytes32 indexed sender,
4049         address indexed recipient
4050     );
4051 
4052     /**
4053      * @notice Emitted when Mailbox is paused
4054      */
4055     event Paused();
4056 
4057     /**
4058      * @notice Emitted when Mailbox is unpaused
4059      */
4060     event Unpaused();
4061 
4062     // ============ Constructor ============
4063 
4064     // solhint-disable-next-line no-empty-blocks
4065     constructor(uint32 _localDomain) {
4066         localDomain = _localDomain;
4067     }
4068 
4069     // ============ Initializers ============
4070 
4071     function initialize(address _owner, address _defaultIsm)
4072         external
4073         initializer
4074     {
4075         __PausableReentrancyGuard_init();
4076         __Ownable_init();
4077         transferOwnership(_owner);
4078         _setDefaultIsm(_defaultIsm);
4079     }
4080 
4081     // ============ External Functions ============
4082 
4083     /**
4084      * @notice Sets the default ISM for the Mailbox.
4085      * @param _module The new default ISM. Must be a contract.
4086      */
4087     function setDefaultIsm(address _module) external onlyOwner {
4088         _setDefaultIsm(_module);
4089     }
4090 
4091     /**
4092      * @notice Dispatches a message to the destination domain & recipient.
4093      * @param _destinationDomain Domain of destination chain
4094      * @param _recipientAddress Address of recipient on destination chain as bytes32
4095      * @param _messageBody Raw bytes content of message body
4096      * @return The message ID inserted into the Mailbox's merkle tree
4097      */
4098     function dispatch(
4099         uint32 _destinationDomain,
4100         bytes32 _recipientAddress,
4101         bytes calldata _messageBody
4102     ) external override notPaused returns (bytes32) {
4103         require(_messageBody.length <= MAX_MESSAGE_BODY_BYTES, "msg too long");
4104         // Format the message into packed bytes.
4105         bytes memory _message = Message.formatMessage(
4106             VERSION,
4107             count(),
4108             localDomain,
4109             msg.sender.addressToBytes32(),
4110             _destinationDomain,
4111             _recipientAddress,
4112             _messageBody
4113         );
4114 
4115         // Insert the message ID into the merkle tree.
4116         bytes32 _id = _message.id();
4117         tree.insert(_id);
4118         emit Dispatch(
4119             msg.sender,
4120             _destinationDomain,
4121             _recipientAddress,
4122             _message
4123         );
4124         emit DispatchId(_id);
4125         return _id;
4126     }
4127 
4128     /**
4129      * @notice Attempts to deliver `_message` to its recipient. Verifies
4130      * `_message` via the recipient's ISM using the provided `_metadata`.
4131      * @param _metadata Metadata used by the ISM to verify `_message`.
4132      * @param _message Formatted Hyperlane message (refer to Message.sol).
4133      */
4134     function process(bytes calldata _metadata, bytes calldata _message)
4135         external
4136         override
4137         nonReentrantAndNotPaused
4138     {
4139         // Check that the message was intended for this mailbox.
4140         require(_message.version() == VERSION, "!version");
4141         require(_message.destination() == localDomain, "!destination");
4142 
4143         // Check that the message hasn't already been delivered.
4144         bytes32 _id = _message.id();
4145         require(delivered[_id] == false, "delivered");
4146         delivered[_id] = true;
4147 
4148         // Verify the message via the ISM.
4149         IInterchainSecurityModule _ism = IInterchainSecurityModule(
4150             recipientIsm(_message.recipientAddress())
4151         );
4152         require(_ism.verify(_metadata, _message), "!module");
4153 
4154         // Deliver the message to the recipient.
4155         uint32 origin = _message.origin();
4156         bytes32 sender = _message.sender();
4157         address recipient = _message.recipientAddress();
4158         IMessageRecipient(recipient).handle(origin, sender, _message.body());
4159         emit Process(origin, sender, recipient);
4160         emit ProcessId(_id);
4161     }
4162 
4163     // ============ Public Functions ============
4164 
4165     /**
4166      * @notice Calculates and returns tree's current root
4167      */
4168     function root() public view returns (bytes32) {
4169         return tree.root();
4170     }
4171 
4172     /**
4173      * @notice Returns the number of inserted leaves in the tree
4174      */
4175     function count() public view returns (uint32) {
4176         // count cannot exceed 2**TREE_DEPTH, see MerkleLib.sol
4177         return uint32(tree.count);
4178     }
4179 
4180     /**
4181      * @notice Returns a checkpoint representing the current merkle tree.
4182      * @return root The root of the Mailbox's merkle tree.
4183      * @return index The index of the last element in the tree.
4184      */
4185     function latestCheckpoint() public view returns (bytes32, uint32) {
4186         return (root(), count() - 1);
4187     }
4188 
4189     /**
4190      * @notice Pauses mailbox and prevents further dispatch/process calls
4191      * @dev Only `owner` can pause the mailbox.
4192      */
4193     function pause() external onlyOwner {
4194         _pause();
4195         emit Paused();
4196     }
4197 
4198     /**
4199      * @notice Unpauses mailbox and allows for message processing.
4200      * @dev Only `owner` can unpause the mailbox.
4201      */
4202     function unpause() external onlyOwner {
4203         _unpause();
4204         emit Unpaused();
4205     }
4206 
4207     /**
4208      * @notice Returns whether mailbox is paused.
4209      */
4210     function isPaused() external view returns (bool) {
4211         return _isPaused();
4212     }
4213 
4214     /**
4215      * @notice Returns the ISM to use for the recipient, defaulting to the
4216      * default ISM if none is specified.
4217      * @param _recipient The message recipient whose ISM should be returned.
4218      * @return The ISM to use for `_recipient`.
4219      */
4220     function recipientIsm(address _recipient)
4221         public
4222         view
4223         returns (IInterchainSecurityModule)
4224     {
4225         // Use a default interchainSecurityModule if one is not specified by the
4226         // recipient.
4227         // This is useful for backwards compatibility and for convenience as
4228         // recipients are not mandated to specify an ISM.
4229         try
4230             ISpecifiesInterchainSecurityModule(_recipient)
4231                 .interchainSecurityModule()
4232         returns (IInterchainSecurityModule _val) {
4233             // If the recipient specifies a zero address, use the default ISM.
4234             if (address(_val) != address(0)) {
4235                 return _val;
4236             }
4237         } catch {}
4238         return defaultIsm;
4239     }
4240 
4241     // ============ Internal Functions ============
4242 
4243     /**
4244      * @notice Sets the default ISM for the Mailbox.
4245      * @param _module The new default ISM. Must be a contract.
4246      */
4247     function _setDefaultIsm(address _module) internal {
4248         require(Address.isContract(_module), "!contract");
4249         defaultIsm = IInterchainSecurityModule(_module);
4250         emit DefaultIsmSet(_module);
4251     }
4252 }
4253 
4254 
4255 // File contracts/Call.sol
4256 
4257 
4258 pragma solidity ^0.8.13;
4259 
4260 struct Call {
4261     address to;
4262     bytes data;
4263 }
4264 
4265 
4266 // File contracts/OwnableMulticall.sol
4267 
4268 
4269 pragma solidity ^0.8.13;
4270 
4271 // ============ External Imports ============
4272 
4273 
4274 /*
4275  * @title OwnableMulticall
4276  * @dev Allows only only address to execute calls to other contracts
4277  */
4278 contract OwnableMulticall is OwnableUpgradeable {
4279     constructor() {
4280         _transferOwnership(msg.sender);
4281     }
4282 
4283     function initialize() external initializer {
4284         _transferOwnership(msg.sender);
4285     }
4286 
4287     function proxyCalls(Call[] calldata calls) external onlyOwner {
4288         for (uint256 i = 0; i < calls.length; i += 1) {
4289             (bool success, bytes memory returnData) = calls[i].to.call(
4290                 calls[i].data
4291             );
4292             if (!success) {
4293                 assembly {
4294                     revert(add(returnData, 32), returnData)
4295                 }
4296             }
4297         }
4298     }
4299 
4300     function _call(Call[] memory calls, bytes[] memory callbacks)
4301         internal
4302         returns (bytes[] memory resolveCalls)
4303     {
4304         resolveCalls = new bytes[](callbacks.length);
4305         for (uint256 i = 0; i < calls.length; i++) {
4306             (bool success, bytes memory returnData) = calls[i].to.call(
4307                 calls[i].data
4308             );
4309             require(success, "Multicall: call failed");
4310             resolveCalls[i] = bytes.concat(callbacks[i], returnData);
4311         }
4312     }
4313 
4314     // TODO: deduplicate
4315     function proxyCallBatch(address to, bytes[] memory calls) internal {
4316         for (uint256 i = 0; i < calls.length; i += 1) {
4317             (bool success, bytes memory returnData) = to.call(calls[i]);
4318             if (!success) {
4319                 assembly {
4320                     revert(add(returnData, 32), returnData)
4321                 }
4322             }
4323         }
4324     }
4325 }
4326 
4327 
4328 // File contracts/Router.sol
4329 
4330 
4331 pragma solidity >=0.6.11;
4332 
4333 // ============ Internal Imports ============
4334 
4335 
4336 
4337 
4338 
4339 abstract contract Router is HyperlaneConnectionClient, IMessageRecipient {
4340     using EnumerableMapExtended for EnumerableMapExtended.UintToBytes32Map;
4341 
4342     string constant NO_ROUTER_ENROLLED_REVERT_MESSAGE =
4343         "No router enrolled for domain. Did you specify the right domain ID?";
4344 
4345     // ============ Mutable Storage ============
4346     EnumerableMapExtended.UintToBytes32Map internal _routers;
4347     uint256[49] private __GAP; // gap for upgrade safety
4348 
4349     // ============ Events ============
4350 
4351     /**
4352      * @notice Emitted when a router is set.
4353      * @param domain The domain of the new router
4354      * @param router The address of the new router
4355      */
4356     event RemoteRouterEnrolled(uint32 indexed domain, bytes32 indexed router);
4357 
4358     // ============ Modifiers ============
4359     /**
4360      * @notice Only accept messages from a remote Router contract
4361      * @param _origin The domain the message is coming from
4362      * @param _router The address the message is coming from
4363      */
4364     modifier onlyRemoteRouter(uint32 _origin, bytes32 _router) {
4365         require(
4366             _isRemoteRouter(_origin, _router),
4367             NO_ROUTER_ENROLLED_REVERT_MESSAGE
4368         );
4369         _;
4370     }
4371 
4372     // ======== Initializer =========
4373     function __Router_initialize(address _mailbox) internal onlyInitializing {
4374         __HyperlaneConnectionClient_initialize(_mailbox);
4375     }
4376 
4377     function __Router_initialize(
4378         address _mailbox,
4379         address _interchainGasPaymaster
4380     ) internal onlyInitializing {
4381         __HyperlaneConnectionClient_initialize(
4382             _mailbox,
4383             _interchainGasPaymaster
4384         );
4385     }
4386 
4387     function __Router_initialize(
4388         address _mailbox,
4389         address _interchainGasPaymaster,
4390         address _interchainSecurityModule
4391     ) internal onlyInitializing {
4392         __HyperlaneConnectionClient_initialize(
4393             _mailbox,
4394             _interchainGasPaymaster,
4395             _interchainSecurityModule
4396         );
4397     }
4398 
4399     // ============ External functions ============
4400     function domains() external view returns (uint32[] memory) {
4401         bytes32[] storage rawKeys = _routers.keys();
4402         uint32[] memory keys = new uint32[](rawKeys.length);
4403         for (uint256 i = 0; i < rawKeys.length; i++) {
4404             keys[i] = uint32(uint256(rawKeys[i]));
4405         }
4406         return keys;
4407     }
4408 
4409     function routers(uint32 _domain) public view returns (bytes32) {
4410         if (_routers.contains(_domain)) {
4411             return _routers.get(_domain);
4412         } else {
4413             return bytes32(0); // for backwards compatibility with storage mapping
4414         }
4415     }
4416 
4417     /**
4418      * @notice Register the address of a Router contract for the same Application on a remote chain
4419      * @param _domain The domain of the remote Application Router
4420      * @param _router The address of the remote Application Router
4421      */
4422     function enrollRemoteRouter(uint32 _domain, bytes32 _router)
4423         external
4424         virtual
4425         onlyOwner
4426     {
4427         _enrollRemoteRouter(_domain, _router);
4428     }
4429 
4430     /**
4431      * @notice Batch version of `enrollRemoteRouter`
4432      * @param _domains The domaisn of the remote Application Routers
4433      * @param _addresses The addresses of the remote Application Routers
4434      */
4435     function enrollRemoteRouters(
4436         uint32[] calldata _domains,
4437         bytes32[] calldata _addresses
4438     ) external virtual onlyOwner {
4439         require(_domains.length == _addresses.length, "!length");
4440         for (uint256 i = 0; i < _domains.length; i += 1) {
4441             _enrollRemoteRouter(_domains[i], _addresses[i]);
4442         }
4443     }
4444 
4445     /**
4446      * @notice Handles an incoming message
4447      * @param _origin The origin domain
4448      * @param _sender The sender address
4449      * @param _message The message
4450      */
4451     function handle(
4452         uint32 _origin,
4453         bytes32 _sender,
4454         bytes calldata _message
4455     ) external virtual override onlyMailbox onlyRemoteRouter(_origin, _sender) {
4456         // TODO: callbacks on success/failure
4457         _handle(_origin, _sender, _message);
4458     }
4459 
4460     // ============ Virtual functions ============
4461     function _handle(
4462         uint32 _origin,
4463         bytes32 _sender,
4464         bytes calldata _message
4465     ) internal virtual;
4466 
4467     // ============ Internal functions ============
4468 
4469     /**
4470      * @notice Set the router for a given domain
4471      * @param _domain The domain
4472      * @param _address The new router
4473      */
4474     function _enrollRemoteRouter(uint32 _domain, bytes32 _address) internal {
4475         _routers.set(_domain, _address);
4476         emit RemoteRouterEnrolled(_domain, _address);
4477     }
4478 
4479     /**
4480      * @notice Return true if the given domain / router is the address of a remote Application Router
4481      * @param _domain The domain of the potential remote Application Router
4482      * @param _address The address of the potential remote Application Router
4483      */
4484     function _isRemoteRouter(uint32 _domain, bytes32 _address)
4485         internal
4486         view
4487         returns (bool)
4488     {
4489         return routers(_domain) == _address;
4490     }
4491 
4492     /**
4493      * @notice Assert that the given domain has a Application Router registered and return its address
4494      * @param _domain The domain of the chain for which to get the Application Router
4495      * @return _router The address of the remote Application Router on _domain
4496      */
4497     function _mustHaveRemoteRouter(uint32 _domain)
4498         internal
4499         view
4500         returns (bytes32 _router)
4501     {
4502         _router = routers(_domain);
4503         require(_router != bytes32(0), NO_ROUTER_ENROLLED_REVERT_MESSAGE);
4504     }
4505 
4506     /**
4507      * @notice Dispatches a message to an enrolled router via the local router's Mailbox
4508      * and pays for it to be relayed to the destination.
4509      * @dev Reverts if there is no enrolled router for _destinationDomain.
4510      * @param _destinationDomain The domain of the chain to which to send the message.
4511      * @param _messageBody Raw bytes content of message.
4512      * @param _gasAmount The amount of destination gas for the message that is requested via the InterchainGasPaymaster.
4513      * @param _gasPayment The amount of native tokens to pay for the message to be relayed.
4514      * @param _gasPaymentRefundAddress The address to refund any gas overpayment to.
4515      */
4516     function _dispatchWithGas(
4517         uint32 _destinationDomain,
4518         bytes memory _messageBody,
4519         uint256 _gasAmount,
4520         uint256 _gasPayment,
4521         address _gasPaymentRefundAddress
4522     ) internal returns (bytes32 _messageId) {
4523         _messageId = _dispatch(_destinationDomain, _messageBody);
4524         // Call the IGP even if the gas payment is zero. This is to support on-chain
4525         // fee quoting in IGPs, which should always revert if gas payment is insufficient.
4526         interchainGasPaymaster.payForGas{value: _gasPayment}(
4527             _messageId,
4528             _destinationDomain,
4529             _gasAmount,
4530             _gasPaymentRefundAddress
4531         );
4532     }
4533 
4534     /**
4535      * @notice Dispatches a message to an enrolled router via the provided Mailbox.
4536      * @dev Does not pay interchain gas.
4537      * @dev Reverts if there is no enrolled router for _destinationDomain.
4538      * @param _destinationDomain The domain of the chain to which to send the message.
4539      * @param _messageBody Raw bytes content of message.
4540      */
4541     function _dispatch(uint32 _destinationDomain, bytes memory _messageBody)
4542         internal
4543         virtual
4544         returns (bytes32)
4545     {
4546         // Ensure that destination chain has an enrolled router.
4547         bytes32 _router = _mustHaveRemoteRouter(_destinationDomain);
4548         return mailbox.dispatch(_destinationDomain, _router, _messageBody);
4549     }
4550 }
4551 
4552 
4553 // File interfaces/IInterchainAccountRouter.sol
4554 
4555 
4556 pragma solidity >=0.6.11;
4557 
4558 interface IInterchainAccountRouter {
4559     function dispatch(uint32 _destinationDomain, Call[] calldata calls)
4560         external
4561         returns (bytes32);
4562 
4563     function dispatch(
4564         uint32 _destinationDomain,
4565         address target,
4566         bytes calldata data
4567     ) external returns (bytes32);
4568 
4569     function getInterchainAccount(uint32 _originDomain, address _sender)
4570         external
4571         view
4572         returns (address);
4573 }
4574 
4575 
4576 // File contracts/libs/MinimalProxy.sol
4577 
4578 
4579 pragma solidity >=0.6.11;
4580 
4581 // Library for building bytecode of minimal proxies (see https://eips.ethereum.org/EIPS/eip-1167)
4582 library MinimalProxy {
4583     bytes20 constant PREFIX = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73";
4584     bytes15 constant SUFFIX = hex"5af43d82803e903d91602b57fd5bf3";
4585 
4586     function bytecode(address implementation)
4587         internal
4588         pure
4589         returns (bytes memory)
4590     {
4591         return abi.encodePacked(PREFIX, bytes20(implementation), SUFFIX);
4592     }
4593 }
4594 
4595 
4596 // File @openzeppelin/contracts/utils/Create2.sol@v4.8.0
4597 
4598 
4599 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Create2.sol)
4600 
4601 pragma solidity ^0.8.0;
4602 
4603 /**
4604  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
4605  * `CREATE2` can be used to compute in advance the address where a smart
4606  * contract will be deployed, which allows for interesting new mechanisms known
4607  * as 'counterfactual interactions'.
4608  *
4609  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
4610  * information.
4611  */
4612 library Create2 {
4613     /**
4614      * @dev Deploys a contract using `CREATE2`. The address where the contract
4615      * will be deployed can be known in advance via {computeAddress}.
4616      *
4617      * The bytecode for a contract can be obtained from Solidity with
4618      * `type(contractName).creationCode`.
4619      *
4620      * Requirements:
4621      *
4622      * - `bytecode` must not be empty.
4623      * - `salt` must have not been used for `bytecode` already.
4624      * - the factory must have a balance of at least `amount`.
4625      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
4626      */
4627     function deploy(
4628         uint256 amount,
4629         bytes32 salt,
4630         bytes memory bytecode
4631     ) internal returns (address addr) {
4632         require(address(this).balance >= amount, "Create2: insufficient balance");
4633         require(bytecode.length != 0, "Create2: bytecode length is zero");
4634         /// @solidity memory-safe-assembly
4635         assembly {
4636             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
4637         }
4638         require(addr != address(0), "Create2: Failed on deploy");
4639     }
4640 
4641     /**
4642      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
4643      * `bytecodeHash` or `salt` will result in a new destination address.
4644      */
4645     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
4646         return computeAddress(salt, bytecodeHash, address(this));
4647     }
4648 
4649     /**
4650      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
4651      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
4652      */
4653     function computeAddress(
4654         bytes32 salt,
4655         bytes32 bytecodeHash,
4656         address deployer
4657     ) internal pure returns (address addr) {
4658         /// @solidity memory-safe-assembly
4659         assembly {
4660             let ptr := mload(0x40) // Get free memory pointer
4661 
4662             // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |
4663             // |-------------------|---------------------------------------------------------------------------|
4664             // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |
4665             // | salt              |                                      BBBBBBBBBBBBB...BB                   |
4666             // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |
4667             // | 0xFF              |            FF                                                             |
4668             // |-------------------|---------------------------------------------------------------------------|
4669             // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |
4670             // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |
4671 
4672             mstore(add(ptr, 0x40), bytecodeHash)
4673             mstore(add(ptr, 0x20), salt)
4674             mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes
4675             let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff
4676             mstore8(start, 0xff)
4677             addr := keccak256(start, 85)
4678         }
4679     }
4680 }
4681 
4682 
4683 // File contracts/middleware/InterchainAccountRouter.sol
4684 
4685 
4686 pragma solidity ^0.8.13;
4687 
4688 // ============ Internal Imports ============
4689 
4690 
4691 
4692 
4693 // ============ External Imports ============
4694 
4695 
4696 
4697 /*
4698  * @title The Hello World App
4699  * @dev You can use this simple app as a starting point for your own application.
4700  */
4701 contract InterchainAccountRouter is Router, IInterchainAccountRouter {
4702     address immutable implementation;
4703     bytes32 immutable bytecodeHash;
4704 
4705     event InterchainAccountCreated(
4706         uint32 indexed origin,
4707         address sender,
4708         address account
4709     );
4710 
4711     constructor() {
4712         implementation = address(new OwnableMulticall());
4713         // cannot be stored immutably because it is dynamically sized
4714         bytes memory bytecode = MinimalProxy.bytecode(implementation);
4715         bytecodeHash = keccak256(bytecode);
4716     }
4717 
4718     function initialize(
4719         address _mailbox,
4720         address _interchainGasPaymaster,
4721         address _interchainSecurityModule
4722     ) public initializer {
4723         // Transfer ownership of the contract to `msg.sender`
4724         __Router_initialize(
4725             _mailbox,
4726             _interchainGasPaymaster,
4727             _interchainSecurityModule
4728         );
4729     }
4730 
4731     function initialize(address _mailbox, address _interchainGasPaymaster)
4732         public
4733         initializer
4734     {
4735         // Transfer ownership of the contract to `msg.sender`
4736         __Router_initialize(_mailbox, _interchainGasPaymaster);
4737     }
4738 
4739     function dispatch(uint32 _destinationDomain, Call[] calldata calls)
4740         external
4741         returns (bytes32)
4742     {
4743         return _dispatch(_destinationDomain, abi.encode(msg.sender, calls));
4744     }
4745 
4746     function dispatch(
4747         uint32 _destinationDomain,
4748         address target,
4749         bytes calldata data
4750     ) external returns (bytes32) {
4751         Call[] memory calls = new Call[](1);
4752         calls[0] = Call({to: target, data: data});
4753         return _dispatch(_destinationDomain, abi.encode(msg.sender, calls));
4754     }
4755 
4756     function getInterchainAccount(uint32 _origin, address _sender)
4757         public
4758         view
4759         returns (address)
4760     {
4761         return _getInterchainAccount(_salt(_origin, _sender));
4762     }
4763 
4764     function getDeployedInterchainAccount(uint32 _origin, address _sender)
4765         public
4766         returns (OwnableMulticall)
4767     {
4768         bytes32 salt = _salt(_origin, _sender);
4769         address interchainAccount = _getInterchainAccount(salt);
4770         if (!Address.isContract(interchainAccount)) {
4771             bytes memory bytecode = MinimalProxy.bytecode(implementation);
4772             interchainAccount = Create2.deploy(0, salt, bytecode);
4773             OwnableMulticall(interchainAccount).initialize();
4774             emit InterchainAccountCreated(_origin, _sender, interchainAccount);
4775         }
4776         return OwnableMulticall(interchainAccount);
4777     }
4778 
4779     function _salt(uint32 _origin, address _sender)
4780         internal
4781         pure
4782         returns (bytes32)
4783     {
4784         return bytes32(abi.encodePacked(_origin, _sender));
4785     }
4786 
4787     function _getInterchainAccount(bytes32 salt)
4788         internal
4789         view
4790         returns (address)
4791     {
4792         return Create2.computeAddress(salt, bytecodeHash);
4793     }
4794 
4795     function _handle(
4796         uint32 _origin,
4797         bytes32, // router sender
4798         bytes calldata _message
4799     ) internal override {
4800         (address sender, Call[] memory calls) = abi.decode(
4801             _message,
4802             (address, Call[])
4803         );
4804         getDeployedInterchainAccount(_origin, sender).proxyCalls(calls);
4805     }
4806 }
4807 
4808 
4809 // File interfaces/IInterchainQueryRouter.sol
4810 
4811 
4812 pragma solidity >=0.6.11;
4813 
4814 interface IInterchainQueryRouter {
4815     function query(
4816         uint32 _destinationDomain,
4817         address target,
4818         bytes calldata queryData,
4819         bytes calldata callback
4820     ) external returns (bytes32);
4821 
4822     function query(
4823         uint32 _destinationDomain,
4824         Call calldata call,
4825         bytes calldata callback
4826     ) external returns (bytes32);
4827 
4828     function query(
4829         uint32 _destinationDomain,
4830         Call[] calldata calls,
4831         bytes[] calldata callbacks
4832     ) external returns (bytes32);
4833 }
4834 
4835 
4836 // File contracts/middleware/InterchainQueryRouter.sol
4837 
4838 
4839 pragma solidity ^0.8.13;
4840 
4841 // ============ Internal Imports ============
4842 
4843 
4844 
4845 // ============ External Imports ============
4846 
4847 
4848 
4849 contract InterchainQueryRouter is
4850     Router,
4851     OwnableMulticall,
4852     IInterchainQueryRouter
4853 {
4854     enum Action {
4855         DISPATCH,
4856         RESOLVE
4857     }
4858 
4859     event QueryDispatched(
4860         uint32 indexed destinationDomain,
4861         address indexed sender
4862     );
4863     event QueryReturned(uint32 indexed originDomain, address indexed sender);
4864     event QueryResolved(
4865         uint32 indexed destinationDomain,
4866         address indexed sender
4867     );
4868 
4869     function initialize(
4870         address _mailbox,
4871         address _interchainGasPaymaster,
4872         address _interchainSecurityModule
4873     ) public initializer {
4874         // Transfer ownership of the contract to `msg.sender`
4875         __Router_initialize(
4876             _mailbox,
4877             _interchainGasPaymaster,
4878             _interchainSecurityModule
4879         );
4880     }
4881 
4882     function initialize(address _mailbox, address _interchainGasPaymaster)
4883         public
4884         initializer
4885     {
4886         // Transfer ownership of the contract to `msg.sender`
4887         __Router_initialize(_mailbox, _interchainGasPaymaster);
4888     }
4889 
4890     /**
4891      * @param _destinationDomain Domain of destination chain
4892      * @param target The address of the contract to query on destination chain.
4893      * @param queryData The calldata of the view call to make on the destination chain.
4894      * @param callback Callback function selector on `msg.sender` and optionally abi-encoded prefix arguments.
4895      */
4896     function query(
4897         uint32 _destinationDomain,
4898         address target,
4899         bytes calldata queryData,
4900         bytes calldata callback
4901     ) external returns (bytes32 messageId) {
4902         // TODO: fix this ugly arrayification
4903         Call[] memory calls = new Call[](1);
4904         calls[0] = Call({to: target, data: queryData});
4905         bytes[] memory callbacks = new bytes[](1);
4906         callbacks[0] = callback;
4907         messageId = query(_destinationDomain, calls, callbacks);
4908     }
4909 
4910     /**
4911      * @param _destinationDomain Domain of destination chain
4912      * @param call Call (to and data packed struct) to be made on destination chain.
4913      * @param callback Callback function selector on `msg.sender` and optionally abi-encoded prefix arguments.
4914      */
4915     function query(
4916         uint32 _destinationDomain,
4917         Call calldata call,
4918         bytes calldata callback
4919     ) external returns (bytes32 messageId) {
4920         // TODO: fix this ugly arrayification
4921         Call[] memory calls = new Call[](1);
4922         calls[0] = call;
4923         bytes[] memory callbacks = new bytes[](1);
4924         callbacks[0] = callback;
4925         messageId = query(_destinationDomain, calls, callbacks);
4926     }
4927 
4928     /**
4929      * @param _destinationDomain Domain of destination chain
4930      * @param calls Array of calls (to and data packed struct) to be made on destination chain in sequence.
4931      * @param callbacks Array of callback function selectors on `msg.sender` and optionally abi-encoded prefix arguments.
4932      */
4933     function query(
4934         uint32 _destinationDomain,
4935         Call[] memory calls,
4936         bytes[] memory callbacks
4937     ) public returns (bytes32 messageId) {
4938         require(
4939             calls.length == callbacks.length,
4940             "InterchainQueryRouter: calls and callbacks must be same length"
4941         );
4942         messageId = _dispatch(
4943             _destinationDomain,
4944             abi.encode(Action.DISPATCH, msg.sender, calls, callbacks)
4945         );
4946         emit QueryDispatched(_destinationDomain, msg.sender);
4947     }
4948 
4949     // TODO: add REJECT behavior ala NodeJS Promise API
4950     function _handle(
4951         uint32 _origin,
4952         bytes32, // router sender
4953         bytes calldata _message
4954     ) internal override {
4955         // TODO: fix double ABI decoding with calldata slices
4956         Action action = abi.decode(_message, (Action));
4957         if (action == Action.DISPATCH) {
4958             (
4959                 ,
4960                 address sender,
4961                 Call[] memory calls,
4962                 bytes[] memory callbacks
4963             ) = abi.decode(_message, (Action, address, Call[], bytes[]));
4964             bytes[] memory resolveCallbacks = _call(calls, callbacks);
4965             _dispatch(
4966                 _origin,
4967                 abi.encode(Action.RESOLVE, sender, resolveCallbacks)
4968             );
4969             emit QueryReturned(_origin, sender);
4970         } else if (action == Action.RESOLVE) {
4971             (, address sender, bytes[] memory resolveCallbacks) = abi.decode(
4972                 _message,
4973                 (Action, address, bytes[])
4974             );
4975             proxyCallBatch(sender, resolveCallbacks);
4976             emit QueryResolved(_origin, sender);
4977         }
4978     }
4979 }
4980 
4981 
4982 // File contracts/middleware/liquidity-layer/interfaces/circle/ICircleBridge.sol
4983 
4984 
4985 pragma solidity ^0.8.13;
4986 
4987 interface ICircleBridge {
4988     event MessageSent(bytes message);
4989 
4990     /**
4991      * @notice Deposits and burns tokens from sender to be minted on destination domain.
4992      * Emits a `DepositForBurn` event.
4993      * @dev reverts if:
4994      * - given burnToken is not supported
4995      * - given destinationDomain has no CircleBridge registered
4996      * - transferFrom() reverts. For example, if sender's burnToken balance or approved allowance
4997      * to this contract is less than `amount`.
4998      * - burn() reverts. For example, if `amount` is 0.
4999      * - MessageTransmitter returns false or reverts.
5000      * @param _amount amount of tokens to burn
5001      * @param _destinationDomain destination domain (ETH = 0, AVAX = 1)
5002      * @param _mintRecipient address of mint recipient on destination domain
5003      * @param _burnToken address of contract to burn deposited tokens, on local domain
5004      * @return _nonce unique nonce reserved by message
5005      */
5006     function depositForBurn(
5007         uint256 _amount,
5008         uint32 _destinationDomain,
5009         bytes32 _mintRecipient,
5010         address _burnToken
5011     ) external returns (uint64 _nonce);
5012 
5013     /**
5014      * @notice Deposits and burns tokens from sender to be minted on destination domain. The mint
5015      * on the destination domain must be called by `_destinationCaller`.
5016      * WARNING: if the `_destinationCaller` does not represent a valid address as bytes32, then it will not be possible
5017      * to broadcast the message on the destination domain. This is an advanced feature, and the standard
5018      * depositForBurn() should be preferred for use cases where a specific destination caller is not required.
5019      * Emits a `DepositForBurn` event.
5020      * @dev reverts if:
5021      * - given destinationCaller is zero address
5022      * - given burnToken is not supported
5023      * - given destinationDomain has no CircleBridge registered
5024      * - transferFrom() reverts. For example, if sender's burnToken balance or approved allowance
5025      * to this contract is less than `amount`.
5026      * - burn() reverts. For example, if `amount` is 0.
5027      * - MessageTransmitter returns false or reverts.
5028      * @param _amount amount of tokens to burn
5029      * @param _destinationDomain destination domain
5030      * @param _mintRecipient address of mint recipient on destination domain
5031      * @param _burnToken address of contract to burn deposited tokens, on local domain
5032      * @param _destinationCaller caller on the destination domain, as bytes32
5033      * @return _nonce unique nonce reserved by message
5034      */
5035     function depositForBurnWithCaller(
5036         uint256 _amount,
5037         uint32 _destinationDomain,
5038         bytes32 _mintRecipient,
5039         address _burnToken,
5040         bytes32 _destinationCaller
5041     ) external returns (uint64 _nonce);
5042 }
5043 
5044 
5045 // File contracts/middleware/liquidity-layer/interfaces/circle/ICircleMessageTransmitter.sol
5046 
5047 
5048 pragma solidity ^0.8.13;
5049 
5050 interface ICircleMessageTransmitter {
5051     /**
5052      * @notice Receive a message. Messages with a given nonce
5053      * can only be broadcast once for a (sourceDomain, destinationDomain)
5054      * pair. The message body of a valid message is passed to the
5055      * specified recipient for further processing.
5056      *
5057      * @dev Attestation format:
5058      * A valid attestation is the concatenated 65-byte signature(s) of exactly
5059      * `thresholdSignature` signatures, in increasing order of attester address.
5060      * ***If the attester addresses recovered from signatures are not in
5061      * increasing order, signature verification will fail.***
5062      * If incorrect number of signatures or duplicate signatures are supplied,
5063      * signature verification will fail.
5064      *
5065      * Message format:
5066      * Field Bytes Type Index
5067      * version 4 uint32 0
5068      * sourceDomain 4 uint32 4
5069      * destinationDomain 4 uint32 8
5070      * nonce 8 uint64 12
5071      * sender 32 bytes32 20
5072      * recipient 32 bytes32 52
5073      * messageBody dynamic bytes 84
5074      * @param _message Message bytes
5075      * @param _attestation Concatenated 65-byte signature(s) of `_message`, in increasing order
5076      * of the attester address recovered from signatures.
5077      * @return success bool, true if successful
5078      */
5079     function receiveMessage(bytes memory _message, bytes calldata _attestation)
5080         external
5081         returns (bool success);
5082 
5083     function usedNonces(bytes32 _nonceId) external view returns (bool);
5084 }
5085 
5086 
5087 // File contracts/middleware/liquidity-layer/interfaces/ILiquidityLayerAdapter.sol
5088 
5089 
5090 pragma solidity ^0.8.13;
5091 
5092 interface ILiquidityLayerAdapter {
5093     function sendTokens(
5094         uint32 _destinationDomain,
5095         bytes32 _recipientAddress,
5096         address _token,
5097         uint256 _amount
5098     ) external returns (bytes memory _adapterData);
5099 
5100     function receiveTokens(
5101         uint32 _originDomain, // Hyperlane domain
5102         address _recipientAddress,
5103         uint256 _amount,
5104         bytes calldata _adapterData // The adapter data from the message
5105     ) external returns (address, uint256);
5106 }
5107 
5108 
5109 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0
5110 
5111 
5112 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5113 
5114 pragma solidity ^0.8.0;
5115 
5116 /**
5117  * @dev Interface of the ERC20 standard as defined in the EIP.
5118  */
5119 interface IERC20 {
5120     /**
5121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
5122      * another (`to`).
5123      *
5124      * Note that `value` may be zero.
5125      */
5126     event Transfer(address indexed from, address indexed to, uint256 value);
5127 
5128     /**
5129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
5130      * a call to {approve}. `value` is the new allowance.
5131      */
5132     event Approval(address indexed owner, address indexed spender, uint256 value);
5133 
5134     /**
5135      * @dev Returns the amount of tokens in existence.
5136      */
5137     function totalSupply() external view returns (uint256);
5138 
5139     /**
5140      * @dev Returns the amount of tokens owned by `account`.
5141      */
5142     function balanceOf(address account) external view returns (uint256);
5143 
5144     /**
5145      * @dev Moves `amount` tokens from the caller's account to `to`.
5146      *
5147      * Returns a boolean value indicating whether the operation succeeded.
5148      *
5149      * Emits a {Transfer} event.
5150      */
5151     function transfer(address to, uint256 amount) external returns (bool);
5152 
5153     /**
5154      * @dev Returns the remaining number of tokens that `spender` will be
5155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
5156      * zero by default.
5157      *
5158      * This value changes when {approve} or {transferFrom} are called.
5159      */
5160     function allowance(address owner, address spender) external view returns (uint256);
5161 
5162     /**
5163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
5164      *
5165      * Returns a boolean value indicating whether the operation succeeded.
5166      *
5167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
5168      * that someone may use both the old and the new allowance by unfortunate
5169      * transaction ordering. One possible solution to mitigate this race
5170      * condition is to first reduce the spender's allowance to 0 and set the
5171      * desired value afterwards:
5172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5173      *
5174      * Emits an {Approval} event.
5175      */
5176     function approve(address spender, uint256 amount) external returns (bool);
5177 
5178     /**
5179      * @dev Moves `amount` tokens from `from` to `to` using the
5180      * allowance mechanism. `amount` is then deducted from the caller's
5181      * allowance.
5182      *
5183      * Returns a boolean value indicating whether the operation succeeded.
5184      *
5185      * Emits a {Transfer} event.
5186      */
5187     function transferFrom(
5188         address from,
5189         address to,
5190         uint256 amount
5191     ) external returns (bool);
5192 }
5193 
5194 
5195 // File contracts/middleware/liquidity-layer/adapters/CircleBridgeAdapter.sol
5196 
5197 
5198 pragma solidity ^0.8.13;
5199 
5200 
5201 
5202 contract CircleBridgeAdapter is ILiquidityLayerAdapter, Router {
5203     /// @notice The CircleBridge contract.
5204     ICircleBridge public circleBridge;
5205 
5206     /// @notice The Circle MessageTransmitter contract.
5207     ICircleMessageTransmitter public circleMessageTransmitter;
5208 
5209     /// @notice The LiquidityLayerRouter contract.
5210     address public liquidityLayerRouter;
5211 
5212     /// @notice Hyperlane domain => Circle domain.
5213     /// ATM, known Circle domains are Ethereum = 0 and Avalanche = 1.
5214     /// Note this could result in ambiguity between the Circle domain being
5215     /// Ethereum or unknown. TODO fix?
5216     mapping(uint32 => uint32) public hyperlaneDomainToCircleDomain;
5217 
5218     /// @notice Token symbol => address of token on local chain.
5219     mapping(string => IERC20) public tokenSymbolToAddress;
5220 
5221     /// @notice Local chain token address => token symbol.
5222     mapping(address => string) public tokenAddressToSymbol;
5223 
5224     /**
5225      * @notice Emits the nonce of the Circle message when a token is bridged.
5226      * @param nonce The nonce of the Circle message.
5227      */
5228     event BridgedToken(uint64 nonce);
5229 
5230     /**
5231      * @notice Emitted when the Hyperlane domain to Circle domain mapping is updated.
5232      * @param hyperlaneDomain The Hyperlane domain.
5233      * @param circleDomain The Circle domain.
5234      */
5235     event DomainAdded(uint32 indexed hyperlaneDomain, uint32 circleDomain);
5236 
5237     /**
5238      * @notice Emitted when a local token and its token symbol have been added.
5239      */
5240     event TokenAdded(address indexed token, string indexed symbol);
5241 
5242     /**
5243      * @notice Emitted when a local token and its token symbol have been removed.
5244      */
5245     event TokenRemoved(address indexed token, string indexed symbol);
5246 
5247     modifier onlyLiquidityLayerRouter() {
5248         require(msg.sender == liquidityLayerRouter, "!liquidityLayerRouter");
5249         _;
5250     }
5251 
5252     /**
5253      * @param _owner The new owner.
5254      * @param _circleBridge The CircleBridge contract.
5255      * @param _circleMessageTransmitter The Circle MessageTransmitter contract.
5256      * @param _liquidityLayerRouter The LiquidityLayerRouter contract.
5257      */
5258     function initialize(
5259         address _owner,
5260         address _circleBridge,
5261         address _circleMessageTransmitter,
5262         address _liquidityLayerRouter
5263     ) public initializer {
5264         // Transfer ownership of the contract to deployer
5265         _transferOwnership(_owner);
5266 
5267         circleBridge = ICircleBridge(_circleBridge);
5268         circleMessageTransmitter = ICircleMessageTransmitter(
5269             _circleMessageTransmitter
5270         );
5271         liquidityLayerRouter = _liquidityLayerRouter;
5272     }
5273 
5274     function sendTokens(
5275         uint32 _destinationDomain,
5276         bytes32, // _recipientAddress, unused
5277         address _token,
5278         uint256 _amount
5279     ) external onlyLiquidityLayerRouter returns (bytes memory) {
5280         string memory _tokenSymbol = tokenAddressToSymbol[_token];
5281         require(
5282             bytes(_tokenSymbol).length > 0,
5283             "CircleBridgeAdapter: Unknown token"
5284         );
5285 
5286         uint32 _circleDomain = hyperlaneDomainToCircleDomain[
5287             _destinationDomain
5288         ];
5289         bytes32 _remoteRouter = routers(_destinationDomain);
5290         require(
5291             _remoteRouter != bytes32(0),
5292             "CircleBridgeAdapter: No router for domain"
5293         );
5294 
5295         // Approve the token to Circle. We assume that the LiquidityLayerRouter
5296         // has already transferred the token to this contract.
5297         require(
5298             IERC20(_token).approve(address(circleBridge), _amount),
5299             "!approval"
5300         );
5301 
5302         uint64 _nonce = circleBridge.depositForBurn(
5303             _amount,
5304             _circleDomain,
5305             _remoteRouter, // Mint to the remote router
5306             _token
5307         );
5308 
5309         emit BridgedToken(_nonce);
5310         return abi.encode(_nonce, _tokenSymbol);
5311     }
5312 
5313     // Returns the token and amount sent
5314     function receiveTokens(
5315         uint32 _originDomain, // Hyperlane domain
5316         address _recipient,
5317         uint256 _amount,
5318         bytes calldata _adapterData // The adapter data from the message
5319     ) external onlyLiquidityLayerRouter returns (address, uint256) {
5320         // The origin Circle domain
5321         uint32 _originCircleDomain = hyperlaneDomainToCircleDomain[
5322             _originDomain
5323         ];
5324         // Get the token symbol and nonce of the transfer from the _adapterData
5325         (uint64 _nonce, string memory _tokenSymbol) = abi.decode(
5326             _adapterData,
5327             (uint64, string)
5328         );
5329 
5330         // Require the circle message to have been processed
5331         bytes32 _nonceId = _circleNonceId(_originCircleDomain, _nonce);
5332         require(
5333             circleMessageTransmitter.usedNonces(_nonceId),
5334             "Circle message not processed yet"
5335         );
5336 
5337         IERC20 _token = tokenSymbolToAddress[_tokenSymbol];
5338         require(
5339             address(_token) != address(0),
5340             "CircleBridgeAdapter: Unknown token"
5341         );
5342 
5343         // Transfer the token out to the recipient
5344         // TODO: use safeTransfer
5345         // Circle doesn't charge any fee, so we can safely transfer out the
5346         // exact amount that was bridged over.
5347         require(_token.transfer(_recipient, _amount), "!transfer out");
5348 
5349         return (address(_token), _amount);
5350     }
5351 
5352     // This contract is only a Router to be aware of remote router addresses,
5353     // and doesn't actually send/handle Hyperlane messages directly
5354     function _handle(
5355         uint32, // origin
5356         bytes32, // sender
5357         bytes calldata // message
5358     ) internal pure override {
5359         revert("No messages expected");
5360     }
5361 
5362     function addDomain(uint32 _hyperlaneDomain, uint32 _circleDomain)
5363         external
5364         onlyOwner
5365     {
5366         hyperlaneDomainToCircleDomain[_hyperlaneDomain] = _circleDomain;
5367 
5368         emit DomainAdded(_hyperlaneDomain, _circleDomain);
5369     }
5370 
5371     function addToken(address _token, string calldata _tokenSymbol)
5372         external
5373         onlyOwner
5374     {
5375         require(
5376             _token != address(0) && bytes(_tokenSymbol).length > 0,
5377             "Cannot add default values"
5378         );
5379 
5380         // Require the token and token symbol to be unset.
5381         address _existingToken = address(tokenSymbolToAddress[_tokenSymbol]);
5382         require(_existingToken == address(0), "token symbol already has token");
5383 
5384         string memory _existingSymbol = tokenAddressToSymbol[_token];
5385         require(
5386             bytes(_existingSymbol).length == 0,
5387             "token already has token symbol"
5388         );
5389 
5390         tokenAddressToSymbol[_token] = _tokenSymbol;
5391         tokenSymbolToAddress[_tokenSymbol] = IERC20(_token);
5392 
5393         emit TokenAdded(_token, _tokenSymbol);
5394     }
5395 
5396     function removeToken(address _token, string calldata _tokenSymbol)
5397         external
5398         onlyOwner
5399     {
5400         // Require the provided token and token symbols match what's in storage.
5401         address _existingToken = address(tokenSymbolToAddress[_tokenSymbol]);
5402         require(_existingToken == _token, "Token mismatch");
5403 
5404         string memory _existingSymbol = tokenAddressToSymbol[_token];
5405         require(
5406             keccak256(bytes(_existingSymbol)) == keccak256(bytes(_tokenSymbol)),
5407             "Token symbol mismatch"
5408         );
5409 
5410         // Delete them from storage.
5411         delete tokenSymbolToAddress[_tokenSymbol];
5412         delete tokenAddressToSymbol[_token];
5413 
5414         emit TokenRemoved(_token, _tokenSymbol);
5415     }
5416 
5417     /**
5418      * @notice Gets the Circle nonce ID by hashing _originCircleDomain and _nonce.
5419      * @param _originCircleDomain Domain of chain where the transfer originated
5420      * @param _nonce The unique identifier for the message from source to
5421               destination
5422      * @return hash of source and nonce
5423      */
5424     function _circleNonceId(uint32 _originCircleDomain, uint64 _nonce)
5425         internal
5426         pure
5427         returns (bytes32)
5428     {
5429         // The hash is of a uint256 nonce, not a uint64 one.
5430         return
5431             keccak256(abi.encodePacked(_originCircleDomain, uint256(_nonce)));
5432     }
5433 }
5434 
5435 
5436 // File interfaces/ILiquidityLayerRouter.sol
5437 
5438 
5439 pragma solidity >=0.6.11;
5440 
5441 interface ILiquidityLayerRouter {
5442     function dispatchWithTokens(
5443         uint32 _destinationDomain,
5444         bytes32 _recipientAddress,
5445         bytes calldata _messageBody,
5446         address _token,
5447         uint256 _amount,
5448         string calldata _bridge
5449     ) external payable returns (bytes32);
5450 }
5451 
5452 
5453 // File interfaces/ILiquidityLayerMessageRecipient.sol
5454 
5455 
5456 pragma solidity ^0.8.13;
5457 
5458 interface ILiquidityLayerMessageRecipient {
5459     function handleWithTokens(
5460         uint32 _origin,
5461         bytes32 _sender,
5462         bytes calldata _message,
5463         address _token,
5464         uint256 _amount
5465     ) external;
5466 }
5467 
5468 
5469 // File contracts/middleware/liquidity-layer/LiquidityLayerRouter.sol
5470 
5471 
5472 pragma solidity ^0.8.13;
5473 
5474 
5475 
5476 
5477 
5478 contract LiquidityLayerRouter is Router, ILiquidityLayerRouter {
5479     // Token bridge => adapter address
5480     mapping(string => address) public liquidityLayerAdapters;
5481 
5482     event LiquidityLayerAdapterSet(string indexed bridge, address adapter);
5483 
5484     function initialize(
5485         address _mailbox,
5486         address _interchainGasPaymaster,
5487         address _interchainSecurityModule
5488     ) public initializer {
5489         // Transfer ownership of the contract to `msg.sender`
5490         __Router_initialize(
5491             _mailbox,
5492             _interchainGasPaymaster,
5493             _interchainSecurityModule
5494         );
5495     }
5496 
5497     function initialize(address _mailbox, address _interchainGasPaymaster)
5498         public
5499         initializer
5500     {
5501         // Transfer ownership of the contract to `msg.sender`
5502         __Router_initialize(_mailbox, _interchainGasPaymaster);
5503     }
5504 
5505     function dispatchWithTokens(
5506         uint32 _destinationDomain,
5507         bytes32 _recipientAddress,
5508         bytes calldata _messageBody,
5509         address _token,
5510         uint256 _amount,
5511         string calldata _bridge
5512     ) external payable returns (bytes32) {
5513         ILiquidityLayerAdapter _adapter = _getAdapter(_bridge);
5514 
5515         // Transfer the tokens to the adapter
5516         // TODO: use safeTransferFrom
5517         // TODO: Are there scenarios where a transferFrom fails and it doesn't revert?
5518         require(
5519             IERC20(_token).transferFrom(msg.sender, address(_adapter), _amount),
5520             "!transfer in"
5521         );
5522 
5523         // Reverts if the bridge was unsuccessful.
5524         // Gets adapter-specific data that is encoded into the message
5525         // ultimately sent via Hyperlane.
5526         bytes memory _adapterData = _adapter.sendTokens(
5527             _destinationDomain,
5528             _recipientAddress,
5529             _token,
5530             _amount
5531         );
5532 
5533         // The user's message "wrapped" with metadata required by this middleware
5534         bytes memory _messageWithMetadata = abi.encode(
5535             TypeCasts.addressToBytes32(msg.sender),
5536             _recipientAddress, // The "user" recipient
5537             _amount, // The amount of the tokens sent over the bridge
5538             _bridge, // The destination token bridge ID
5539             _adapterData, // The adapter-specific data
5540             _messageBody // The "user" message
5541         );
5542 
5543         // Dispatch the _messageWithMetadata to the destination's LiquidityLayerRouter.
5544         return
5545             _dispatchWithGas(
5546                 _destinationDomain,
5547                 _messageWithMetadata,
5548                 0, // TODO eventually accommodate gas amounts
5549                 msg.value,
5550                 msg.sender
5551             );
5552     }
5553 
5554     // Handles a message from an enrolled remote LiquidityLayerRouter
5555     function _handle(
5556         uint32 _origin,
5557         bytes32, // _sender, unused
5558         bytes calldata _message
5559     ) internal override {
5560         // Decode the message with metadata, "unwrapping" the user's message body
5561         (
5562             bytes32 _originalSender,
5563             bytes32 _userRecipientAddress,
5564             uint256 _amount,
5565             string memory _bridge,
5566             bytes memory _adapterData,
5567             bytes memory _userMessageBody
5568         ) = abi.decode(
5569                 _message,
5570                 (bytes32, bytes32, uint256, string, bytes, bytes)
5571             );
5572 
5573         ILiquidityLayerMessageRecipient _userRecipient = ILiquidityLayerMessageRecipient(
5574                 TypeCasts.bytes32ToAddress(_userRecipientAddress)
5575             );
5576 
5577         // Reverts if the adapter hasn't received the bridged tokens yet
5578         (address _token, uint256 _receivedAmount) = _getAdapter(_bridge)
5579             .receiveTokens(
5580                 _origin,
5581                 address(_userRecipient),
5582                 _amount,
5583                 _adapterData
5584             );
5585 
5586         _userRecipient.handleWithTokens(
5587             _origin,
5588             _originalSender,
5589             _userMessageBody,
5590             _token,
5591             _receivedAmount
5592         );
5593     }
5594 
5595     function setLiquidityLayerAdapter(string calldata _bridge, address _adapter)
5596         external
5597         onlyOwner
5598     {
5599         liquidityLayerAdapters[_bridge] = _adapter;
5600         emit LiquidityLayerAdapterSet(_bridge, _adapter);
5601     }
5602 
5603     function _getAdapter(string memory _bridge)
5604         internal
5605         view
5606         returns (ILiquidityLayerAdapter _adapter)
5607     {
5608         _adapter = ILiquidityLayerAdapter(liquidityLayerAdapters[_bridge]);
5609         // Require the adapter to have been set
5610         require(address(_adapter) != address(0), "No adapter found for bridge");
5611     }
5612 }
5613 
5614 
5615 // File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.8.0
5616 
5617 
5618 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5619 
5620 pragma solidity ^0.8.0;
5621 
5622 /**
5623  * @dev Interface of the ERC20 standard as defined in the EIP.
5624  */
5625 interface IERC20Upgradeable {
5626     /**
5627      * @dev Emitted when `value` tokens are moved from one account (`from`) to
5628      * another (`to`).
5629      *
5630      * Note that `value` may be zero.
5631      */
5632     event Transfer(address indexed from, address indexed to, uint256 value);
5633 
5634     /**
5635      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
5636      * a call to {approve}. `value` is the new allowance.
5637      */
5638     event Approval(address indexed owner, address indexed spender, uint256 value);
5639 
5640     /**
5641      * @dev Returns the amount of tokens in existence.
5642      */
5643     function totalSupply() external view returns (uint256);
5644 
5645     /**
5646      * @dev Returns the amount of tokens owned by `account`.
5647      */
5648     function balanceOf(address account) external view returns (uint256);
5649 
5650     /**
5651      * @dev Moves `amount` tokens from the caller's account to `to`.
5652      *
5653      * Returns a boolean value indicating whether the operation succeeded.
5654      *
5655      * Emits a {Transfer} event.
5656      */
5657     function transfer(address to, uint256 amount) external returns (bool);
5658 
5659     /**
5660      * @dev Returns the remaining number of tokens that `spender` will be
5661      * allowed to spend on behalf of `owner` through {transferFrom}. This is
5662      * zero by default.
5663      *
5664      * This value changes when {approve} or {transferFrom} are called.
5665      */
5666     function allowance(address owner, address spender) external view returns (uint256);
5667 
5668     /**
5669      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
5670      *
5671      * Returns a boolean value indicating whether the operation succeeded.
5672      *
5673      * IMPORTANT: Beware that changing an allowance with this method brings the risk
5674      * that someone may use both the old and the new allowance by unfortunate
5675      * transaction ordering. One possible solution to mitigate this race
5676      * condition is to first reduce the spender's allowance to 0 and set the
5677      * desired value afterwards:
5678      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5679      *
5680      * Emits an {Approval} event.
5681      */
5682     function approve(address spender, uint256 amount) external returns (bool);
5683 
5684     /**
5685      * @dev Moves `amount` tokens from `from` to `to` using the
5686      * allowance mechanism. `amount` is then deducted from the caller's
5687      * allowance.
5688      *
5689      * Returns a boolean value indicating whether the operation succeeded.
5690      *
5691      * Emits a {Transfer} event.
5692      */
5693     function transferFrom(
5694         address from,
5695         address to,
5696         uint256 amount
5697     ) external returns (bool);
5698 }
5699 
5700 
5701 // File @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol@v4.8.0
5702 
5703 
5704 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
5705 
5706 pragma solidity ^0.8.0;
5707 
5708 /**
5709  * @dev Interface for the optional metadata functions from the ERC20 standard.
5710  *
5711  * _Available since v4.1._
5712  */
5713 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
5714     /**
5715      * @dev Returns the name of the token.
5716      */
5717     function name() external view returns (string memory);
5718 
5719     /**
5720      * @dev Returns the symbol of the token.
5721      */
5722     function symbol() external view returns (string memory);
5723 
5724     /**
5725      * @dev Returns the decimals places of the token.
5726      */
5727     function decimals() external view returns (uint8);
5728 }
5729 
5730 
5731 // File @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol@v4.8.0
5732 
5733 
5734 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
5735 
5736 pragma solidity ^0.8.0;
5737 
5738 
5739 
5740 
5741 /**
5742  * @dev Implementation of the {IERC20} interface.
5743  *
5744  * This implementation is agnostic to the way tokens are created. This means
5745  * that a supply mechanism has to be added in a derived contract using {_mint}.
5746  * For a generic mechanism see {ERC20PresetMinterPauser}.
5747  *
5748  * TIP: For a detailed writeup see our guide
5749  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
5750  * to implement supply mechanisms].
5751  *
5752  * We have followed general OpenZeppelin Contracts guidelines: functions revert
5753  * instead returning `false` on failure. This behavior is nonetheless
5754  * conventional and does not conflict with the expectations of ERC20
5755  * applications.
5756  *
5757  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
5758  * This allows applications to reconstruct the allowance for all accounts just
5759  * by listening to said events. Other implementations of the EIP may not emit
5760  * these events, as it isn't required by the specification.
5761  *
5762  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
5763  * functions have been added to mitigate the well-known issues around setting
5764  * allowances. See {IERC20-approve}.
5765  */
5766 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
5767     mapping(address => uint256) private _balances;
5768 
5769     mapping(address => mapping(address => uint256)) private _allowances;
5770 
5771     uint256 private _totalSupply;
5772 
5773     string private _name;
5774     string private _symbol;
5775 
5776     /**
5777      * @dev Sets the values for {name} and {symbol}.
5778      *
5779      * The default value of {decimals} is 18. To select a different value for
5780      * {decimals} you should overload it.
5781      *
5782      * All two of these values are immutable: they can only be set once during
5783      * construction.
5784      */
5785     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
5786         __ERC20_init_unchained(name_, symbol_);
5787     }
5788 
5789     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
5790         _name = name_;
5791         _symbol = symbol_;
5792     }
5793 
5794     /**
5795      * @dev Returns the name of the token.
5796      */
5797     function name() public view virtual override returns (string memory) {
5798         return _name;
5799     }
5800 
5801     /**
5802      * @dev Returns the symbol of the token, usually a shorter version of the
5803      * name.
5804      */
5805     function symbol() public view virtual override returns (string memory) {
5806         return _symbol;
5807     }
5808 
5809     /**
5810      * @dev Returns the number of decimals used to get its user representation.
5811      * For example, if `decimals` equals `2`, a balance of `505` tokens should
5812      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
5813      *
5814      * Tokens usually opt for a value of 18, imitating the relationship between
5815      * Ether and Wei. This is the value {ERC20} uses, unless this function is
5816      * overridden;
5817      *
5818      * NOTE: This information is only used for _display_ purposes: it in
5819      * no way affects any of the arithmetic of the contract, including
5820      * {IERC20-balanceOf} and {IERC20-transfer}.
5821      */
5822     function decimals() public view virtual override returns (uint8) {
5823         return 18;
5824     }
5825 
5826     /**
5827      * @dev See {IERC20-totalSupply}.
5828      */
5829     function totalSupply() public view virtual override returns (uint256) {
5830         return _totalSupply;
5831     }
5832 
5833     /**
5834      * @dev See {IERC20-balanceOf}.
5835      */
5836     function balanceOf(address account) public view virtual override returns (uint256) {
5837         return _balances[account];
5838     }
5839 
5840     /**
5841      * @dev See {IERC20-transfer}.
5842      *
5843      * Requirements:
5844      *
5845      * - `to` cannot be the zero address.
5846      * - the caller must have a balance of at least `amount`.
5847      */
5848     function transfer(address to, uint256 amount) public virtual override returns (bool) {
5849         address owner = _msgSender();
5850         _transfer(owner, to, amount);
5851         return true;
5852     }
5853 
5854     /**
5855      * @dev See {IERC20-allowance}.
5856      */
5857     function allowance(address owner, address spender) public view virtual override returns (uint256) {
5858         return _allowances[owner][spender];
5859     }
5860 
5861     /**
5862      * @dev See {IERC20-approve}.
5863      *
5864      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
5865      * `transferFrom`. This is semantically equivalent to an infinite approval.
5866      *
5867      * Requirements:
5868      *
5869      * - `spender` cannot be the zero address.
5870      */
5871     function approve(address spender, uint256 amount) public virtual override returns (bool) {
5872         address owner = _msgSender();
5873         _approve(owner, spender, amount);
5874         return true;
5875     }
5876 
5877     /**
5878      * @dev See {IERC20-transferFrom}.
5879      *
5880      * Emits an {Approval} event indicating the updated allowance. This is not
5881      * required by the EIP. See the note at the beginning of {ERC20}.
5882      *
5883      * NOTE: Does not update the allowance if the current allowance
5884      * is the maximum `uint256`.
5885      *
5886      * Requirements:
5887      *
5888      * - `from` and `to` cannot be the zero address.
5889      * - `from` must have a balance of at least `amount`.
5890      * - the caller must have allowance for ``from``'s tokens of at least
5891      * `amount`.
5892      */
5893     function transferFrom(
5894         address from,
5895         address to,
5896         uint256 amount
5897     ) public virtual override returns (bool) {
5898         address spender = _msgSender();
5899         _spendAllowance(from, spender, amount);
5900         _transfer(from, to, amount);
5901         return true;
5902     }
5903 
5904     /**
5905      * @dev Atomically increases the allowance granted to `spender` by the caller.
5906      *
5907      * This is an alternative to {approve} that can be used as a mitigation for
5908      * problems described in {IERC20-approve}.
5909      *
5910      * Emits an {Approval} event indicating the updated allowance.
5911      *
5912      * Requirements:
5913      *
5914      * - `spender` cannot be the zero address.
5915      */
5916     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
5917         address owner = _msgSender();
5918         _approve(owner, spender, allowance(owner, spender) + addedValue);
5919         return true;
5920     }
5921 
5922     /**
5923      * @dev Atomically decreases the allowance granted to `spender` by the caller.
5924      *
5925      * This is an alternative to {approve} that can be used as a mitigation for
5926      * problems described in {IERC20-approve}.
5927      *
5928      * Emits an {Approval} event indicating the updated allowance.
5929      *
5930      * Requirements:
5931      *
5932      * - `spender` cannot be the zero address.
5933      * - `spender` must have allowance for the caller of at least
5934      * `subtractedValue`.
5935      */
5936     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
5937         address owner = _msgSender();
5938         uint256 currentAllowance = allowance(owner, spender);
5939         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
5940         unchecked {
5941             _approve(owner, spender, currentAllowance - subtractedValue);
5942         }
5943 
5944         return true;
5945     }
5946 
5947     /**
5948      * @dev Moves `amount` of tokens from `from` to `to`.
5949      *
5950      * This internal function is equivalent to {transfer}, and can be used to
5951      * e.g. implement automatic token fees, slashing mechanisms, etc.
5952      *
5953      * Emits a {Transfer} event.
5954      *
5955      * Requirements:
5956      *
5957      * - `from` cannot be the zero address.
5958      * - `to` cannot be the zero address.
5959      * - `from` must have a balance of at least `amount`.
5960      */
5961     function _transfer(
5962         address from,
5963         address to,
5964         uint256 amount
5965     ) internal virtual {
5966         require(from != address(0), "ERC20: transfer from the zero address");
5967         require(to != address(0), "ERC20: transfer to the zero address");
5968 
5969         _beforeTokenTransfer(from, to, amount);
5970 
5971         uint256 fromBalance = _balances[from];
5972         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
5973         unchecked {
5974             _balances[from] = fromBalance - amount;
5975             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
5976             // decrementing then incrementing.
5977             _balances[to] += amount;
5978         }
5979 
5980         emit Transfer(from, to, amount);
5981 
5982         _afterTokenTransfer(from, to, amount);
5983     }
5984 
5985     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
5986      * the total supply.
5987      *
5988      * Emits a {Transfer} event with `from` set to the zero address.
5989      *
5990      * Requirements:
5991      *
5992      * - `account` cannot be the zero address.
5993      */
5994     function _mint(address account, uint256 amount) internal virtual {
5995         require(account != address(0), "ERC20: mint to the zero address");
5996 
5997         _beforeTokenTransfer(address(0), account, amount);
5998 
5999         _totalSupply += amount;
6000         unchecked {
6001             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
6002             _balances[account] += amount;
6003         }
6004         emit Transfer(address(0), account, amount);
6005 
6006         _afterTokenTransfer(address(0), account, amount);
6007     }
6008 
6009     /**
6010      * @dev Destroys `amount` tokens from `account`, reducing the
6011      * total supply.
6012      *
6013      * Emits a {Transfer} event with `to` set to the zero address.
6014      *
6015      * Requirements:
6016      *
6017      * - `account` cannot be the zero address.
6018      * - `account` must have at least `amount` tokens.
6019      */
6020     function _burn(address account, uint256 amount) internal virtual {
6021         require(account != address(0), "ERC20: burn from the zero address");
6022 
6023         _beforeTokenTransfer(account, address(0), amount);
6024 
6025         uint256 accountBalance = _balances[account];
6026         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
6027         unchecked {
6028             _balances[account] = accountBalance - amount;
6029             // Overflow not possible: amount <= accountBalance <= totalSupply.
6030             _totalSupply -= amount;
6031         }
6032 
6033         emit Transfer(account, address(0), amount);
6034 
6035         _afterTokenTransfer(account, address(0), amount);
6036     }
6037 
6038     /**
6039      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
6040      *
6041      * This internal function is equivalent to `approve`, and can be used to
6042      * e.g. set automatic allowances for certain subsystems, etc.
6043      *
6044      * Emits an {Approval} event.
6045      *
6046      * Requirements:
6047      *
6048      * - `owner` cannot be the zero address.
6049      * - `spender` cannot be the zero address.
6050      */
6051     function _approve(
6052         address owner,
6053         address spender,
6054         uint256 amount
6055     ) internal virtual {
6056         require(owner != address(0), "ERC20: approve from the zero address");
6057         require(spender != address(0), "ERC20: approve to the zero address");
6058 
6059         _allowances[owner][spender] = amount;
6060         emit Approval(owner, spender, amount);
6061     }
6062 
6063     /**
6064      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
6065      *
6066      * Does not update the allowance amount in case of infinite allowance.
6067      * Revert if not enough allowance is available.
6068      *
6069      * Might emit an {Approval} event.
6070      */
6071     function _spendAllowance(
6072         address owner,
6073         address spender,
6074         uint256 amount
6075     ) internal virtual {
6076         uint256 currentAllowance = allowance(owner, spender);
6077         if (currentAllowance != type(uint256).max) {
6078             require(currentAllowance >= amount, "ERC20: insufficient allowance");
6079             unchecked {
6080                 _approve(owner, spender, currentAllowance - amount);
6081             }
6082         }
6083     }
6084 
6085     /**
6086      * @dev Hook that is called before any transfer of tokens. This includes
6087      * minting and burning.
6088      *
6089      * Calling conditions:
6090      *
6091      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
6092      * will be transferred to `to`.
6093      * - when `from` is zero, `amount` tokens will be minted for `to`.
6094      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
6095      * - `from` and `to` are never both zero.
6096      *
6097      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
6098      */
6099     function _beforeTokenTransfer(
6100         address from,
6101         address to,
6102         uint256 amount
6103     ) internal virtual {}
6104 
6105     /**
6106      * @dev Hook that is called after any transfer of tokens. This includes
6107      * minting and burning.
6108      *
6109      * Calling conditions:
6110      *
6111      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
6112      * has been transferred to `to`.
6113      * - when `from` is zero, `amount` tokens have been minted for `to`.
6114      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
6115      * - `from` and `to` are never both zero.
6116      *
6117      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
6118      */
6119     function _afterTokenTransfer(
6120         address from,
6121         address to,
6122         uint256 amount
6123     ) internal virtual {}
6124 
6125     /**
6126      * @dev This empty reserved space is put in place to allow future versions to add new
6127      * variables without shifting down storage in the inheritance chain.
6128      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
6129      */
6130     uint256[45] private __gap;
6131 }
6132 
6133 
6134 // File contracts/mock/MockToken.sol
6135 
6136 
6137 pragma solidity ^0.8.13;
6138 
6139 contract MockToken is ERC20Upgradeable {
6140     function mint(address account, uint256 amount) external {
6141         _mint(account, amount);
6142     }
6143 
6144     function burn(uint256 _amount) external {
6145         _burn(msg.sender, _amount);
6146     }
6147 }
6148 
6149 
6150 // File contracts/mock/MockCircleBridge.sol
6151 
6152 
6153 pragma solidity ^0.8.13;
6154 
6155 
6156 contract MockCircleBridge is ICircleBridge {
6157     uint64 public nextNonce = 0;
6158     MockToken token;
6159 
6160     constructor(MockToken _token) {
6161         token = _token;
6162     }
6163 
6164     function depositForBurn(
6165         uint256 _amount,
6166         uint32,
6167         bytes32,
6168         address _burnToken
6169     ) external returns (uint64 _nonce) {
6170         nextNonce = nextNonce + 1;
6171         _nonce = nextNonce;
6172         require(address(token) == _burnToken);
6173         token.transferFrom(msg.sender, address(this), _amount);
6174         token.burn(_amount);
6175     }
6176 
6177     function depositForBurnWithCaller(
6178         uint256,
6179         uint32,
6180         bytes32,
6181         address,
6182         bytes32
6183     ) external returns (uint64 _nonce) {
6184         nextNonce = nextNonce + 1;
6185         _nonce = nextNonce;
6186     }
6187 }
6188 
6189 
6190 // File contracts/mock/MockCircleMessageTransmitter.sol
6191 
6192 
6193 pragma solidity ^0.8.13;
6194 
6195 
6196 contract MockCircleMessageTransmitter is ICircleMessageTransmitter {
6197     mapping(bytes32 => bool) processedNonces;
6198     MockToken token;
6199 
6200     constructor(MockToken _token) {
6201         token = _token;
6202     }
6203 
6204     function receiveMessage(bytes memory, bytes calldata)
6205         external
6206         pure
6207         returns (bool success)
6208     {
6209         success = true;
6210     }
6211 
6212     function hashSourceAndNonce(uint32 _source, uint256 _nonce)
6213         public
6214         pure
6215         returns (bytes32)
6216     {
6217         return keccak256(abi.encodePacked(_source, _nonce));
6218     }
6219 
6220     function process(
6221         bytes32 _nonceId,
6222         address _recipient,
6223         uint256 _amount
6224     ) public {
6225         processedNonces[_nonceId] = true;
6226         token.mint(_recipient, _amount);
6227     }
6228 
6229     function usedNonces(bytes32 _nonceId) external view returns (bool) {
6230         return processedNonces[_nonceId];
6231     }
6232 }
6233 
6234 
6235 // File contracts/mock/MockMailbox.sol
6236 
6237 
6238 pragma solidity ^0.8.0;
6239 
6240 
6241 contract MockMailbox {
6242     using TypeCasts for address;
6243     using TypeCasts for bytes32;
6244     // Domain of chain on which the contract is deployed
6245     uint32 public immutable domain;
6246     uint32 public immutable version = 0;
6247 
6248     uint256 public outboundNonce = 0;
6249     uint256 public inboundUnprocessedNonce = 0;
6250     uint256 public inboundProcessedNonce = 0;
6251     mapping(uint32 => MockMailbox) public remoteMailboxes;
6252     mapping(uint256 => Message) public inboundMessages;
6253 
6254     struct Message {
6255         uint32 origin;
6256         address sender;
6257         address recipient;
6258         bytes body;
6259     }
6260 
6261     constructor(uint32 _domain) {
6262         domain = _domain;
6263     }
6264 
6265     function addRemoteMailbox(uint32 _domain, MockMailbox _mailbox) external {
6266         remoteMailboxes[_domain] = _mailbox;
6267     }
6268 
6269     function dispatch(
6270         uint32 _destinationDomain,
6271         bytes32 _recipientAddress,
6272         bytes calldata _messageBody
6273     ) external returns (bytes32) {
6274         MockMailbox _destinationMailbox = remoteMailboxes[_destinationDomain];
6275         require(
6276             address(_destinationMailbox) != address(0),
6277             "Missing remote mailbox"
6278         );
6279         _destinationMailbox.addInboundMessage(
6280             domain,
6281             msg.sender,
6282             _recipientAddress.bytes32ToAddress(),
6283             _messageBody
6284         );
6285         outboundNonce++;
6286         return bytes32(0);
6287     }
6288 
6289     function addInboundMessage(
6290         uint32 _origin,
6291         address _sender,
6292         address _recipient,
6293         bytes calldata _body
6294     ) external {
6295         inboundMessages[inboundUnprocessedNonce] = Message(
6296             _origin,
6297             _sender,
6298             _recipient,
6299             _body
6300         );
6301         inboundUnprocessedNonce++;
6302     }
6303 
6304     function processNextInboundMessage() public {
6305         Message memory _message = inboundMessages[inboundProcessedNonce];
6306         IMessageRecipient(_message.recipient).handle(
6307             _message.origin,
6308             _message.sender.addressToBytes32(),
6309             _message.body
6310         );
6311         inboundProcessedNonce++;
6312     }
6313 }
6314 
6315 
6316 // File contracts/test/TestIsm.sol
6317 
6318 
6319 pragma solidity >=0.8.0;
6320 
6321 contract TestIsm is IInterchainSecurityModule {
6322     uint8 public constant moduleType = 0;
6323     bool public accept;
6324 
6325     function setAccept(bool _val) external {
6326         accept = _val;
6327     }
6328 
6329     function verify(bytes calldata, bytes calldata)
6330         external
6331         view
6332         returns (bool)
6333     {
6334         return accept;
6335     }
6336 }
6337 
6338 
6339 // File contracts/mock/MockHyperlaneEnvironment.sol
6340 
6341 
6342 pragma solidity ^0.8.13;
6343 
6344 
6345 
6346 
6347 contract MockHyperlaneEnvironment {
6348     uint32 originDomain;
6349     uint32 destinationDomain;
6350 
6351     mapping(uint32 => MockMailbox) public mailboxes;
6352     mapping(uint32 => InterchainGasPaymaster) public igps;
6353     mapping(uint32 => IInterchainSecurityModule) public isms;
6354     mapping(uint32 => InterchainQueryRouter) public queryRouters;
6355 
6356     constructor(uint32 _originDomain, uint32 _destinationDomain) {
6357         originDomain = _originDomain;
6358         destinationDomain = _destinationDomain;
6359 
6360         MockMailbox originMailbox = new MockMailbox(_originDomain);
6361         MockMailbox destinationMailbox = new MockMailbox(_destinationDomain);
6362 
6363         originMailbox.addRemoteMailbox(_destinationDomain, destinationMailbox);
6364         destinationMailbox.addRemoteMailbox(_originDomain, originMailbox);
6365 
6366         igps[originDomain] = new InterchainGasPaymaster();
6367         igps[destinationDomain] = new InterchainGasPaymaster();
6368 
6369         isms[originDomain] = new TestIsm();
6370         isms[destinationDomain] = new TestIsm();
6371 
6372         mailboxes[_originDomain] = originMailbox;
6373         mailboxes[_destinationDomain] = destinationMailbox;
6374 
6375         InterchainQueryRouter originQueryRouter = new InterchainQueryRouter();
6376         InterchainQueryRouter destinationQueryRouter = new InterchainQueryRouter();
6377 
6378         originQueryRouter.initialize(
6379             address(originMailbox),
6380             address(igps[originDomain]),
6381             address(isms[originDomain])
6382         );
6383         destinationQueryRouter.initialize(
6384             address(destinationMailbox),
6385             address(igps[destinationDomain]),
6386             address(isms[destinationDomain])
6387         );
6388 
6389         originQueryRouter.enrollRemoteRouter(
6390             _destinationDomain,
6391             TypeCasts.addressToBytes32(address(destinationQueryRouter))
6392         );
6393         destinationQueryRouter.enrollRemoteRouter(
6394             _originDomain,
6395             TypeCasts.addressToBytes32(address(originQueryRouter))
6396         );
6397 
6398         queryRouters[_originDomain] = originQueryRouter;
6399         queryRouters[_destinationDomain] = destinationQueryRouter;
6400     }
6401 
6402     function processNextPendingMessage() public {
6403         mailboxes[destinationDomain].processNextInboundMessage();
6404     }
6405 
6406     function processNextPendingMessageFromDestination() public {
6407         mailboxes[originDomain].processNextInboundMessage();
6408     }
6409 }
6410 
6411 
6412 // File contracts/mock/MockInterchainAccountRouter.sol
6413 
6414 
6415 pragma solidity ^0.8.13;
6416 
6417 
6418 /*
6419  * @title The Hello World App
6420  * @dev You can use this simple app as a starting point for your own application.
6421  */
6422 contract MockInterchainAccountRouter is InterchainAccountRouter {
6423     struct PendingCall {
6424         uint32 originDomain;
6425         bytes senderAndCalls;
6426     }
6427 
6428     uint32 public originDomain;
6429 
6430     mapping(uint256 => PendingCall) pendingCalls;
6431     uint256 totalCalls = 0;
6432     uint256 callsProcessed = 0;
6433 
6434     constructor(uint32 _originDomain) InterchainAccountRouter() {
6435         originDomain = _originDomain;
6436     }
6437 
6438     function _dispatch(uint32, bytes memory _messageBody)
6439         internal
6440         override
6441         returns (bytes32)
6442     {
6443         pendingCalls[totalCalls] = PendingCall(originDomain, _messageBody);
6444         totalCalls += 1;
6445         return keccak256(abi.encodePacked(totalCalls));
6446     }
6447 
6448     function processNextPendingCall() public {
6449         PendingCall memory pendingCall = pendingCalls[callsProcessed];
6450         (address sender, Call[] memory calls) = abi.decode(
6451             pendingCall.senderAndCalls,
6452             (address, Call[])
6453         );
6454 
6455         getDeployedInterchainAccount(originDomain, sender).proxyCalls(calls);
6456 
6457         callsProcessed += 1;
6458     }
6459 }
6460 
6461 
6462 // File contracts/test/bad-recipient/BadRecipient1.sol
6463 
6464 
6465 pragma solidity >=0.8.0;
6466 
6467 contract BadRecipient1 is IMessageRecipient {
6468     function handle(
6469         uint32,
6470         bytes32,
6471         bytes calldata
6472     ) external pure override {
6473         assembly {
6474             revert(0, 0)
6475         }
6476     }
6477 }
6478 
6479 
6480 // File contracts/test/bad-recipient/BadRecipient3.sol
6481 
6482 
6483 pragma solidity >=0.8.0;
6484 
6485 contract BadRecipient3 is IMessageRecipient {
6486     function handle(
6487         uint32,
6488         bytes32,
6489         bytes calldata
6490     ) external pure override {
6491         assembly {
6492             mstore(0, 0xabcdef)
6493             revert(0, 32)
6494         }
6495     }
6496 }
6497 
6498 
6499 // File contracts/test/bad-recipient/BadRecipient5.sol
6500 
6501 
6502 pragma solidity >=0.8.0;
6503 
6504 contract BadRecipient5 is IMessageRecipient {
6505     function handle(
6506         uint32,
6507         bytes32,
6508         bytes calldata
6509     ) external pure override {
6510         require(false, "no can do");
6511     }
6512 }
6513 
6514 
6515 // File contracts/test/bad-recipient/BadRecipient6.sol
6516 
6517 
6518 pragma solidity >=0.8.0;
6519 
6520 contract BadRecipient6 is IMessageRecipient {
6521     function handle(
6522         uint32,
6523         bytes32,
6524         bytes calldata
6525     ) external pure override {
6526         require(false); // solhint-disable-line reason-string
6527     }
6528 }
6529 
6530 
6531 // File contracts/test/TestHyperlaneConnectionClient.sol
6532 
6533 
6534 pragma solidity >=0.6.11;
6535 
6536 
6537 contract TestHyperlaneConnectionClient is HyperlaneConnectionClient {
6538     function initialize(address _mailbox) external initializer {
6539         __HyperlaneConnectionClient_initialize(_mailbox);
6540     }
6541 
6542     function localDomain() external view returns (uint32) {
6543         return mailbox.localDomain();
6544     }
6545 }
6546 
6547 
6548 // File contracts/test/TestLiquidityLayerMessageRecipient.sol
6549 
6550 
6551 pragma solidity ^0.8.13;
6552 
6553 contract TestLiquidityLayerMessageRecipient is ILiquidityLayerMessageRecipient {
6554     event HandledWithTokens(
6555         uint32 origin,
6556         bytes32 sender,
6557         bytes message,
6558         address token,
6559         uint256 amount
6560     );
6561 
6562     function handleWithTokens(
6563         uint32 _origin,
6564         bytes32 _sender,
6565         bytes calldata _message,
6566         address _token,
6567         uint256 _amount
6568     ) external {
6569         emit HandledWithTokens(_origin, _sender, _message, _token, _amount);
6570     }
6571 }
6572 
6573 
6574 // File contracts/test/TestMailbox.sol
6575 
6576 
6577 pragma solidity >=0.8.0;
6578 
6579 
6580 
6581 
6582 contract TestMailbox is Mailbox {
6583     using TypeCasts for bytes32;
6584 
6585     constructor(uint32 _localDomain) Mailbox(_localDomain) {} // solhint-disable-line no-empty-blocks
6586 
6587     function proof() external view returns (bytes32[32] memory) {
6588         bytes32[32] memory _zeroes = MerkleLib.zeroHashes();
6589         uint256 _index = tree.count - 1;
6590         bytes32[32] memory _proof;
6591 
6592         for (uint256 i = 0; i < 32; i++) {
6593             uint256 _ithBit = (_index >> i) & 0x01;
6594             if (_ithBit == 1) {
6595                 _proof[i] = tree.branch[i];
6596             } else {
6597                 _proof[i] = _zeroes[i];
6598             }
6599         }
6600         return _proof;
6601     }
6602 
6603     function testHandle(
6604         uint32 _origin,
6605         bytes32 _sender,
6606         bytes32 _recipient,
6607         bytes calldata _body
6608     ) external {
6609         IMessageRecipient(_recipient.bytes32ToAddress()).handle(
6610             _origin,
6611             _sender,
6612             _body
6613         );
6614     }
6615 }
6616 
6617 
6618 // File contracts/test/TestMerkle.sol
6619 
6620 
6621 pragma solidity >=0.8.0;
6622 
6623 contract TestMerkle {
6624     using MerkleLib for MerkleLib.Tree;
6625 
6626     MerkleLib.Tree public tree;
6627 
6628     // solhint-disable-next-line no-empty-blocks
6629     constructor() {}
6630 
6631     function insert(bytes32 _node) external {
6632         tree.insert(_node);
6633     }
6634 
6635     function branchRoot(
6636         bytes32 _leaf,
6637         bytes32[32] calldata _proof,
6638         uint256 _index
6639     ) external pure returns (bytes32 _node) {
6640         return MerkleLib.branchRoot(_leaf, _proof, _index);
6641     }
6642 
6643     /**
6644      * @notice Returns the number of inserted leaves in the tree
6645      */
6646     function count() public view returns (uint256) {
6647         return tree.count;
6648     }
6649 
6650     function root() public view returns (bytes32) {
6651         return tree.root();
6652     }
6653 }
6654 
6655 
6656 // File contracts/test/TestMessage.sol
6657 
6658 
6659 pragma solidity >=0.6.11;
6660 
6661 contract TestMessage {
6662     using Message for bytes;
6663 
6664     function version(bytes calldata _message)
6665         external
6666         pure
6667         returns (uint32 _version)
6668     {
6669         return _message.version();
6670     }
6671 
6672     function nonce(bytes calldata _message)
6673         external
6674         pure
6675         returns (uint256 _nonce)
6676     {
6677         return _message.nonce();
6678     }
6679 
6680     function body(bytes calldata _message)
6681         external
6682         pure
6683         returns (bytes calldata _body)
6684     {
6685         return _message.body();
6686     }
6687 
6688     function origin(bytes calldata _message)
6689         external
6690         pure
6691         returns (uint32 _origin)
6692     {
6693         return _message.origin();
6694     }
6695 
6696     function sender(bytes calldata _message)
6697         external
6698         pure
6699         returns (bytes32 _sender)
6700     {
6701         return _message.sender();
6702     }
6703 
6704     function destination(bytes calldata _message)
6705         external
6706         pure
6707         returns (uint32 _destination)
6708     {
6709         return _message.destination();
6710     }
6711 
6712     function recipient(bytes calldata _message)
6713         external
6714         pure
6715         returns (bytes32 _recipient)
6716     {
6717         return _message.recipient();
6718     }
6719 
6720     function recipientAddress(bytes calldata _message)
6721         external
6722         pure
6723         returns (address _recipient)
6724     {
6725         return _message.recipientAddress();
6726     }
6727 
6728     function id(bytes calldata _message) external pure returns (bytes32) {
6729         return _message.id();
6730     }
6731 }
6732 
6733 
6734 // File contracts/test/TestMultisigIsm.sol
6735 
6736 
6737 pragma solidity >=0.8.0;
6738 
6739 // ============ Internal Imports ============
6740 
6741 contract TestMultisigIsm is MultisigIsm {
6742     function getDomainHash(uint32 _origin, bytes32 _originMailbox)
6743         external
6744         pure
6745         returns (bytes32)
6746     {
6747         return _getDomainHash(_origin, _originMailbox);
6748     }
6749 
6750     function getCheckpointDigest(bytes calldata _metadata, uint32 _origin)
6751         external
6752         pure
6753         returns (bytes32)
6754     {
6755         return _getCheckpointDigest(_metadata, _origin);
6756     }
6757 }
6758 
6759 
6760 // File contracts/test/TestQuery.sol
6761 
6762 
6763 pragma solidity ^0.8.13;
6764 
6765 
6766 
6767 contract TestQuery {
6768     InterchainQueryRouter public router;
6769 
6770     event Owner(uint256, address);
6771 
6772     constructor(address _router) {
6773         router = InterchainQueryRouter(_router);
6774     }
6775 
6776     /**
6777      * @dev Fetches owner of InterchainQueryRouter on provided domain and passes along with provided secret to `this.receiveRouterOwner`
6778      */
6779     function queryRouterOwner(uint32 domain, uint256 secret) external {
6780         Call memory call = Call({
6781             to: TypeCasts.bytes32ToAddress(router.routers(domain)),
6782             data: abi.encodeWithSignature("owner()")
6783         });
6784         bytes memory callback = bytes.concat(
6785             this.receiveRouterOwer.selector,
6786             bytes32(secret)
6787         );
6788         router.query(domain, call, callback);
6789     }
6790 
6791     /**
6792      * @dev `msg.sender` must be restricted to `this.router` to prevent any local account from spoofing query data.
6793      */
6794     function receiveRouterOwer(uint256 secret, address owner) external {
6795         require(msg.sender == address(router), "TestQuery: not from router");
6796         emit Owner(secret, owner);
6797     }
6798 }
6799 
6800 
6801 // File contracts/test/TestQuerySender.sol
6802 
6803 
6804 pragma solidity >=0.8.0;
6805 
6806 
6807 contract TestQuerySender is Initializable {
6808     IInterchainQueryRouter queryRouter;
6809 
6810     address public lastAddressResult;
6811     uint256 public lastUint256Result;
6812     bytes32 public lastBytes32Result;
6813 
6814     event ReceivedAddressResult(address result);
6815     event ReceivedUint256Result(uint256 result);
6816     event ReceivedBytes32Result(bytes32 result);
6817 
6818     function initialize(address _queryRouterAddress) public initializer {
6819         queryRouter = IInterchainQueryRouter(_queryRouterAddress);
6820     }
6821 
6822     function queryAddress(
6823         uint32 _destinationDomain,
6824         address _target,
6825         bytes calldata _targetData
6826     ) public {
6827         queryRouter.query(
6828             _destinationDomain,
6829             Call({to: _target, data: _targetData}),
6830             abi.encodePacked(this.handleQueryAddressResult.selector)
6831         );
6832     }
6833 
6834     function handleQueryAddressResult(address _result) public {
6835         emit ReceivedAddressResult(_result);
6836         lastAddressResult = _result;
6837     }
6838 
6839     function queryUint256(
6840         uint32 _destinationDomain,
6841         address _target,
6842         bytes calldata _targetData
6843     ) public {
6844         queryRouter.query(
6845             _destinationDomain,
6846             Call({to: _target, data: _targetData}),
6847             abi.encodePacked(this.handleQueryUint256Result.selector)
6848         );
6849     }
6850 
6851     function handleQueryUint256Result(uint256 _result) public {
6852         emit ReceivedUint256Result(_result);
6853         lastUint256Result = _result;
6854     }
6855 
6856     function queryBytes32(
6857         uint32 _destinationDomain,
6858         address _target,
6859         bytes calldata _targetData
6860     ) public {
6861         queryRouter.query(
6862             _destinationDomain,
6863             Call({to: _target, data: _targetData}),
6864             abi.encodePacked(this.handleQueryBytes32Result.selector)
6865         );
6866     }
6867 
6868     function handleQueryBytes32Result(bytes32 _result) public {
6869         emit ReceivedBytes32Result(_result);
6870         lastBytes32Result = _result;
6871     }
6872 }
6873 
6874 
6875 // File contracts/test/TestRecipient.sol
6876 
6877 
6878 pragma solidity >=0.8.0;
6879 
6880 
6881 contract TestRecipient is
6882     IMessageRecipient,
6883     ISpecifiesInterchainSecurityModule
6884 {
6885     IInterchainSecurityModule public interchainSecurityModule;
6886     bytes32 public lastSender;
6887     bytes public lastData;
6888 
6889     address public lastCaller;
6890     string public lastCallMessage;
6891 
6892     event ReceivedMessage(
6893         uint32 indexed origin,
6894         bytes32 indexed sender,
6895         string message
6896     );
6897 
6898     event ReceivedCall(address indexed caller, uint256 amount, string message);
6899 
6900     function setInterchainSecurityModule(address _ism) external {
6901         interchainSecurityModule = IInterchainSecurityModule(_ism);
6902     }
6903 
6904     function handle(
6905         uint32 _origin,
6906         bytes32 _sender,
6907         bytes calldata _data
6908     ) external override {
6909         emit ReceivedMessage(_origin, _sender, string(_data));
6910         lastSender = _sender;
6911         lastData = _data;
6912     }
6913 
6914     function fooBar(uint256 amount, string calldata message) external {
6915         emit ReceivedCall(msg.sender, amount, message);
6916         lastCaller = msg.sender;
6917         lastCallMessage = message;
6918     }
6919 }
6920 
6921 
6922 // File contracts/test/TestRouter.sol
6923 
6924 
6925 pragma solidity >=0.6.11;
6926 
6927 contract TestRouter is Router {
6928     event InitializeOverload();
6929 
6930     function initialize(address _mailbox) external initializer {
6931         __Router_initialize(_mailbox);
6932         emit InitializeOverload();
6933     }
6934 
6935     function _handle(
6936         uint32,
6937         bytes32,
6938         bytes calldata
6939     ) internal pure override {}
6940 
6941     function isRemoteRouter(uint32 _domain, bytes32 _potentialRemoteRouter)
6942         external
6943         view
6944         returns (bool)
6945     {
6946         return _isRemoteRouter(_domain, _potentialRemoteRouter);
6947     }
6948 
6949     function mustHaveRemoteRouter(uint32 _domain)
6950         external
6951         view
6952         returns (bytes32)
6953     {
6954         return _mustHaveRemoteRouter(_domain);
6955     }
6956 
6957     function dispatch(uint32 _destination, bytes memory _msg) external {
6958         _dispatch(_destination, _msg);
6959     }
6960 
6961     function dispatchWithGas(
6962         uint32 _destinationDomain,
6963         bytes memory _messageBody,
6964         uint256 _gasAmount,
6965         uint256 _gasPayment,
6966         address _gasPaymentRefundAddress
6967     ) external payable {
6968         _dispatchWithGas(
6969             _destinationDomain,
6970             _messageBody,
6971             _gasAmount,
6972             _gasPayment,
6973             _gasPaymentRefundAddress
6974         );
6975     }
6976 }
6977 
6978 
6979 // File contracts/test/TestSendReceiver.sol
6980 
6981 
6982 pragma solidity >=0.8.0;
6983 
6984 
6985 
6986 contract TestSendReceiver is IMessageRecipient {
6987     using TypeCasts for address;
6988 
6989     uint256 public constant HANDLE_GAS_AMOUNT = 50_000;
6990 
6991     event Handled(bytes32 blockHash);
6992 
6993     function dispatchToSelf(
6994         IMailbox _mailbox,
6995         IInterchainGasPaymaster _paymaster,
6996         uint32 _destinationDomain,
6997         bytes calldata _messageBody
6998     ) external payable {
6999         bytes32 _messageId = _mailbox.dispatch(
7000             _destinationDomain,
7001             address(this).addressToBytes32(),
7002             _messageBody
7003         );
7004         uint256 _blockHashNum = uint256(previousBlockHash());
7005         uint256 _value = msg.value;
7006         if (_blockHashNum % 5 == 0) {
7007             // Pay in two separate calls, resulting in 2 distinct events
7008             uint256 _halfPayment = _value / 2;
7009             uint256 _halfGasAmount = HANDLE_GAS_AMOUNT / 2;
7010             _paymaster.payForGas{value: _halfPayment}(
7011                 _messageId,
7012                 _destinationDomain,
7013                 _halfGasAmount,
7014                 msg.sender
7015             );
7016             _paymaster.payForGas{value: _value - _halfPayment}(
7017                 _messageId,
7018                 _destinationDomain,
7019                 HANDLE_GAS_AMOUNT - _halfGasAmount,
7020                 msg.sender
7021             );
7022         } else {
7023             // Pay the entire msg.value in one call
7024             _paymaster.payForGas{value: _value}(
7025                 _messageId,
7026                 _destinationDomain,
7027                 HANDLE_GAS_AMOUNT,
7028                 msg.sender
7029             );
7030         }
7031     }
7032 
7033     function handle(
7034         uint32,
7035         bytes32,
7036         bytes calldata
7037     ) external override {
7038         bytes32 blockHash = previousBlockHash();
7039         bool isBlockHashEven = uint256(blockHash) % 2 == 0;
7040         require(isBlockHashEven, "block hash is odd");
7041         emit Handled(blockHash);
7042     }
7043 
7044     function previousBlockHash() internal view returns (bytes32) {
7045         return blockhash(block.number - 1);
7046     }
7047 }
7048 
7049 
7050 // File contracts/test/TestTokenRecipient.sol
7051 
7052 
7053 pragma solidity >=0.8.0;
7054 
7055 contract TestTokenRecipient is ILiquidityLayerMessageRecipient {
7056     bytes32 public lastSender;
7057     bytes public lastData;
7058     address public lastToken;
7059     uint256 public lastAmount;
7060 
7061     address public lastCaller;
7062     string public lastCallMessage;
7063 
7064     event ReceivedMessage(
7065         uint32 indexed origin,
7066         bytes32 indexed sender,
7067         string message,
7068         address token,
7069         uint256 amount
7070     );
7071 
7072     event ReceivedCall(address indexed caller, uint256 amount, string message);
7073 
7074     function handleWithTokens(
7075         uint32 _origin,
7076         bytes32 _sender,
7077         bytes calldata _data,
7078         address _token,
7079         uint256 _amount
7080     ) external override {
7081         emit ReceivedMessage(_origin, _sender, string(_data), _token, _amount);
7082         lastSender = _sender;
7083         lastData = _data;
7084         lastToken = _token;
7085         lastAmount = _amount;
7086     }
7087 
7088     function fooBar(uint256 amount, string calldata message) external {
7089         emit ReceivedCall(msg.sender, amount, message);
7090         lastCaller = msg.sender;
7091         lastCallMessage = message;
7092     }
7093 }
7094 
7095 
7096 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.8.0
7097 
7098 
7099 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
7100 
7101 pragma solidity ^0.8.0;
7102 
7103 /**
7104  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
7105  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
7106  * be specified by overriding the virtual {_implementation} function.
7107  *
7108  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
7109  * different contract through the {_delegate} function.
7110  *
7111  * The success and return data of the delegated call will be returned back to the caller of the proxy.
7112  */
7113 abstract contract Proxy {
7114     /**
7115      * @dev Delegates the current call to `implementation`.
7116      *
7117      * This function does not return to its internal call site, it will return directly to the external caller.
7118      */
7119     function _delegate(address implementation) internal virtual {
7120         assembly {
7121             // Copy msg.data. We take full control of memory in this inline assembly
7122             // block because it will not return to Solidity code. We overwrite the
7123             // Solidity scratch pad at memory position 0.
7124             calldatacopy(0, 0, calldatasize())
7125 
7126             // Call the implementation.
7127             // out and outsize are 0 because we don't know the size yet.
7128             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
7129 
7130             // Copy the returned data.
7131             returndatacopy(0, 0, returndatasize())
7132 
7133             switch result
7134             // delegatecall returns 0 on error.
7135             case 0 {
7136                 revert(0, returndatasize())
7137             }
7138             default {
7139                 return(0, returndatasize())
7140             }
7141         }
7142     }
7143 
7144     /**
7145      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
7146      * and {_fallback} should delegate.
7147      */
7148     function _implementation() internal view virtual returns (address);
7149 
7150     /**
7151      * @dev Delegates the current call to the address returned by `_implementation()`.
7152      *
7153      * This function does not return to its internal call site, it will return directly to the external caller.
7154      */
7155     function _fallback() internal virtual {
7156         _beforeFallback();
7157         _delegate(_implementation());
7158     }
7159 
7160     /**
7161      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
7162      * function in the contract matches the call data.
7163      */
7164     fallback() external payable virtual {
7165         _fallback();
7166     }
7167 
7168     /**
7169      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
7170      * is empty.
7171      */
7172     receive() external payable virtual {
7173         _fallback();
7174     }
7175 
7176     /**
7177      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
7178      * call, or as part of the Solidity `fallback` or `receive` functions.
7179      *
7180      * If overridden should call `super._beforeFallback()`.
7181      */
7182     function _beforeFallback() internal virtual {}
7183 }
7184 
7185 
7186 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.8.0
7187 
7188 
7189 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
7190 
7191 pragma solidity ^0.8.0;
7192 
7193 /**
7194  * @dev This is the interface that {BeaconProxy} expects of its beacon.
7195  */
7196 interface IBeacon {
7197     /**
7198      * @dev Must return an address that can be used as a delegate call target.
7199      *
7200      * {BeaconProxy} will check that this address is a contract.
7201      */
7202     function implementation() external view returns (address);
7203 }
7204 
7205 
7206 // File @openzeppelin/contracts/interfaces/draft-IERC1822.sol@v4.8.0
7207 
7208 
7209 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
7210 
7211 pragma solidity ^0.8.0;
7212 
7213 /**
7214  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
7215  * proxy whose upgrades are fully controlled by the current implementation.
7216  */
7217 interface IERC1822Proxiable {
7218     /**
7219      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
7220      * address.
7221      *
7222      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
7223      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
7224      * function revert if invoked through a proxy.
7225      */
7226     function proxiableUUID() external view returns (bytes32);
7227 }
7228 
7229 
7230 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.8.0
7231 
7232 
7233 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
7234 
7235 pragma solidity ^0.8.0;
7236 
7237 /**
7238  * @dev Library for reading and writing primitive types to specific storage slots.
7239  *
7240  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
7241  * This library helps with reading and writing to such slots without the need for inline assembly.
7242  *
7243  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
7244  *
7245  * Example usage to set ERC1967 implementation slot:
7246  * ```
7247  * contract ERC1967 {
7248  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
7249  *
7250  *     function _getImplementation() internal view returns (address) {
7251  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
7252  *     }
7253  *
7254  *     function _setImplementation(address newImplementation) internal {
7255  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
7256  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
7257  *     }
7258  * }
7259  * ```
7260  *
7261  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
7262  */
7263 library StorageSlot {
7264     struct AddressSlot {
7265         address value;
7266     }
7267 
7268     struct BooleanSlot {
7269         bool value;
7270     }
7271 
7272     struct Bytes32Slot {
7273         bytes32 value;
7274     }
7275 
7276     struct Uint256Slot {
7277         uint256 value;
7278     }
7279 
7280     /**
7281      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
7282      */
7283     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
7284         /// @solidity memory-safe-assembly
7285         assembly {
7286             r.slot := slot
7287         }
7288     }
7289 
7290     /**
7291      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
7292      */
7293     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
7294         /// @solidity memory-safe-assembly
7295         assembly {
7296             r.slot := slot
7297         }
7298     }
7299 
7300     /**
7301      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
7302      */
7303     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
7304         /// @solidity memory-safe-assembly
7305         assembly {
7306             r.slot := slot
7307         }
7308     }
7309 
7310     /**
7311      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
7312      */
7313     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
7314         /// @solidity memory-safe-assembly
7315         assembly {
7316             r.slot := slot
7317         }
7318     }
7319 }
7320 
7321 
7322 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.8.0
7323 
7324 
7325 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
7326 
7327 pragma solidity ^0.8.2;
7328 
7329 
7330 
7331 
7332 /**
7333  * @dev This abstract contract provides getters and event emitting update functions for
7334  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
7335  *
7336  * _Available since v4.1._
7337  *
7338  * @custom:oz-upgrades-unsafe-allow delegatecall
7339  */
7340 abstract contract ERC1967Upgrade {
7341     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
7342     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
7343 
7344     /**
7345      * @dev Storage slot with the address of the current implementation.
7346      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
7347      * validated in the constructor.
7348      */
7349     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
7350 
7351     /**
7352      * @dev Emitted when the implementation is upgraded.
7353      */
7354     event Upgraded(address indexed implementation);
7355 
7356     /**
7357      * @dev Returns the current implementation address.
7358      */
7359     function _getImplementation() internal view returns (address) {
7360         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
7361     }
7362 
7363     /**
7364      * @dev Stores a new address in the EIP1967 implementation slot.
7365      */
7366     function _setImplementation(address newImplementation) private {
7367         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
7368         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
7369     }
7370 
7371     /**
7372      * @dev Perform implementation upgrade
7373      *
7374      * Emits an {Upgraded} event.
7375      */
7376     function _upgradeTo(address newImplementation) internal {
7377         _setImplementation(newImplementation);
7378         emit Upgraded(newImplementation);
7379     }
7380 
7381     /**
7382      * @dev Perform implementation upgrade with additional setup call.
7383      *
7384      * Emits an {Upgraded} event.
7385      */
7386     function _upgradeToAndCall(
7387         address newImplementation,
7388         bytes memory data,
7389         bool forceCall
7390     ) internal {
7391         _upgradeTo(newImplementation);
7392         if (data.length > 0 || forceCall) {
7393             Address.functionDelegateCall(newImplementation, data);
7394         }
7395     }
7396 
7397     /**
7398      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
7399      *
7400      * Emits an {Upgraded} event.
7401      */
7402     function _upgradeToAndCallUUPS(
7403         address newImplementation,
7404         bytes memory data,
7405         bool forceCall
7406     ) internal {
7407         // Upgrades from old implementations will perform a rollback test. This test requires the new
7408         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
7409         // this special case will break upgrade paths from old UUPS implementation to new ones.
7410         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
7411             _setImplementation(newImplementation);
7412         } else {
7413             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
7414                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
7415             } catch {
7416                 revert("ERC1967Upgrade: new implementation is not UUPS");
7417             }
7418             _upgradeToAndCall(newImplementation, data, forceCall);
7419         }
7420     }
7421 
7422     /**
7423      * @dev Storage slot with the admin of the contract.
7424      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
7425      * validated in the constructor.
7426      */
7427     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
7428 
7429     /**
7430      * @dev Emitted when the admin account has changed.
7431      */
7432     event AdminChanged(address previousAdmin, address newAdmin);
7433 
7434     /**
7435      * @dev Returns the current admin.
7436      */
7437     function _getAdmin() internal view returns (address) {
7438         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
7439     }
7440 
7441     /**
7442      * @dev Stores a new address in the EIP1967 admin slot.
7443      */
7444     function _setAdmin(address newAdmin) private {
7445         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
7446         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
7447     }
7448 
7449     /**
7450      * @dev Changes the admin of the proxy.
7451      *
7452      * Emits an {AdminChanged} event.
7453      */
7454     function _changeAdmin(address newAdmin) internal {
7455         emit AdminChanged(_getAdmin(), newAdmin);
7456         _setAdmin(newAdmin);
7457     }
7458 
7459     /**
7460      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
7461      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
7462      */
7463     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
7464 
7465     /**
7466      * @dev Emitted when the beacon is upgraded.
7467      */
7468     event BeaconUpgraded(address indexed beacon);
7469 
7470     /**
7471      * @dev Returns the current beacon.
7472      */
7473     function _getBeacon() internal view returns (address) {
7474         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
7475     }
7476 
7477     /**
7478      * @dev Stores a new beacon in the EIP1967 beacon slot.
7479      */
7480     function _setBeacon(address newBeacon) private {
7481         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
7482         require(
7483             Address.isContract(IBeacon(newBeacon).implementation()),
7484             "ERC1967: beacon implementation is not a contract"
7485         );
7486         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
7487     }
7488 
7489     /**
7490      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
7491      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
7492      *
7493      * Emits a {BeaconUpgraded} event.
7494      */
7495     function _upgradeBeaconToAndCall(
7496         address newBeacon,
7497         bytes memory data,
7498         bool forceCall
7499     ) internal {
7500         _setBeacon(newBeacon);
7501         emit BeaconUpgraded(newBeacon);
7502         if (data.length > 0 || forceCall) {
7503             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
7504         }
7505     }
7506 }
7507 
7508 
7509 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.8.0
7510 
7511 
7512 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
7513 
7514 pragma solidity ^0.8.0;
7515 
7516 
7517 /**
7518  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
7519  * implementation address that can be changed. This address is stored in storage in the location specified by
7520  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
7521  * implementation behind the proxy.
7522  */
7523 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
7524     /**
7525      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
7526      *
7527      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
7528      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
7529      */
7530     constructor(address _logic, bytes memory _data) payable {
7531         _upgradeToAndCall(_logic, _data, false);
7532     }
7533 
7534     /**
7535      * @dev Returns the current implementation address.
7536      */
7537     function _implementation() internal view virtual override returns (address impl) {
7538         return ERC1967Upgrade._getImplementation();
7539     }
7540 }
7541 
7542 
7543 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.8.0
7544 
7545 
7546 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
7547 
7548 pragma solidity ^0.8.0;
7549 
7550 /**
7551  * @dev This contract implements a proxy that is upgradeable by an admin.
7552  *
7553  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
7554  * clashing], which can potentially be used in an attack, this contract uses the
7555  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
7556  * things that go hand in hand:
7557  *
7558  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
7559  * that call matches one of the admin functions exposed by the proxy itself.
7560  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
7561  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
7562  * "admin cannot fallback to proxy target".
7563  *
7564  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
7565  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
7566  * to sudden errors when trying to call a function from the proxy implementation.
7567  *
7568  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
7569  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
7570  */
7571 contract TransparentUpgradeableProxy is ERC1967Proxy {
7572     /**
7573      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
7574      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
7575      */
7576     constructor(
7577         address _logic,
7578         address admin_,
7579         bytes memory _data
7580     ) payable ERC1967Proxy(_logic, _data) {
7581         _changeAdmin(admin_);
7582     }
7583 
7584     /**
7585      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
7586      */
7587     modifier ifAdmin() {
7588         if (msg.sender == _getAdmin()) {
7589             _;
7590         } else {
7591             _fallback();
7592         }
7593     }
7594 
7595     /**
7596      * @dev Returns the current admin.
7597      *
7598      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
7599      *
7600      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
7601      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
7602      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
7603      */
7604     function admin() external ifAdmin returns (address admin_) {
7605         admin_ = _getAdmin();
7606     }
7607 
7608     /**
7609      * @dev Returns the current implementation.
7610      *
7611      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
7612      *
7613      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
7614      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
7615      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
7616      */
7617     function implementation() external ifAdmin returns (address implementation_) {
7618         implementation_ = _implementation();
7619     }
7620 
7621     /**
7622      * @dev Changes the admin of the proxy.
7623      *
7624      * Emits an {AdminChanged} event.
7625      *
7626      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
7627      */
7628     function changeAdmin(address newAdmin) external virtual ifAdmin {
7629         _changeAdmin(newAdmin);
7630     }
7631 
7632     /**
7633      * @dev Upgrade the implementation of the proxy.
7634      *
7635      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
7636      */
7637     function upgradeTo(address newImplementation) external ifAdmin {
7638         _upgradeToAndCall(newImplementation, bytes(""), false);
7639     }
7640 
7641     /**
7642      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
7643      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
7644      * proxied contract.
7645      *
7646      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
7647      */
7648     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
7649         _upgradeToAndCall(newImplementation, data, true);
7650     }
7651 
7652     /**
7653      * @dev Returns the current admin.
7654      */
7655     function _admin() internal view virtual returns (address) {
7656         return _getAdmin();
7657     }
7658 
7659     /**
7660      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
7661      */
7662     function _beforeFallback() internal virtual override {
7663         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
7664         super._beforeFallback();
7665     }
7666 }
7667 
7668 
7669 // File @openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol@v4.8.0
7670 
7671 
7672 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
7673 
7674 pragma solidity ^0.8.0;
7675 
7676 
7677 /**
7678  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
7679  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
7680  */
7681 contract ProxyAdmin is Ownable {
7682     /**
7683      * @dev Returns the current implementation of `proxy`.
7684      *
7685      * Requirements:
7686      *
7687      * - This contract must be the admin of `proxy`.
7688      */
7689     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
7690         // We need to manually run the static call since the getter cannot be flagged as view
7691         // bytes4(keccak256("implementation()")) == 0x5c60da1b
7692         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
7693         require(success);
7694         return abi.decode(returndata, (address));
7695     }
7696 
7697     /**
7698      * @dev Returns the current admin of `proxy`.
7699      *
7700      * Requirements:
7701      *
7702      * - This contract must be the admin of `proxy`.
7703      */
7704     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
7705         // We need to manually run the static call since the getter cannot be flagged as view
7706         // bytes4(keccak256("admin()")) == 0xf851a440
7707         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
7708         require(success);
7709         return abi.decode(returndata, (address));
7710     }
7711 
7712     /**
7713      * @dev Changes the admin of `proxy` to `newAdmin`.
7714      *
7715      * Requirements:
7716      *
7717      * - This contract must be the current admin of `proxy`.
7718      */
7719     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
7720         proxy.changeAdmin(newAdmin);
7721     }
7722 
7723     /**
7724      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
7725      *
7726      * Requirements:
7727      *
7728      * - This contract must be the admin of `proxy`.
7729      */
7730     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
7731         proxy.upgradeTo(implementation);
7732     }
7733 
7734     /**
7735      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
7736      * {TransparentUpgradeableProxy-upgradeToAndCall}.
7737      *
7738      * Requirements:
7739      *
7740      * - This contract must be the admin of `proxy`.
7741      */
7742     function upgradeAndCall(
7743         TransparentUpgradeableProxy proxy,
7744         address implementation,
7745         bytes memory data
7746     ) public payable virtual onlyOwner {
7747         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
7748     }
7749 }
7750 
7751 
7752 // File contracts/upgrade/ProxyAdmin.sol
7753 
7754 
7755 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
7756 
7757 pragma solidity ^0.8.0;
7758 
7759 
7760 // File contracts/upgrade/TransparentUpgradeableProxy.sol
7761 
7762 
7763 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
7764 
7765 pragma solidity ^0.8.0;
7766 
7767 
7768 // File contracts/Create2Factory.sol
7769 
7770 
7771 // Copied from https://github.com/axelarnetwork/axelar-utils-solidity/commits/main/contracts/ConstAddressDeployer.sol
7772 
7773 pragma solidity ^0.8.0;
7774 
7775 contract Create2Factory {
7776     error EmptyBytecode();
7777     error FailedDeploy();
7778     error FailedInit();
7779 
7780     event Deployed(
7781         bytes32 indexed bytecodeHash,
7782         bytes32 indexed salt,
7783         address indexed deployedAddress
7784     );
7785 
7786     /**
7787      * @dev Deploys a contract using `CREATE2`. The address where the contract
7788      * will be deployed can be known in advance via {deployedAddress}.
7789      *
7790      * The bytecode for a contract can be obtained from Solidity with
7791      * `type(contractName).creationCode`.
7792      *
7793      * Requirements:
7794      *
7795      * - `bytecode` must not be empty.
7796      * - `salt` must have not been used for `bytecode` already by the same `msg.sender`.
7797      */
7798     function deploy(bytes memory bytecode, bytes32 salt)
7799         external
7800         returns (address deployedAddress_)
7801     {
7802         deployedAddress_ = _deploy(
7803             bytecode,
7804             keccak256(abi.encode(msg.sender, salt))
7805         );
7806     }
7807 
7808     /**
7809      * @dev Deploys a contract using `CREATE2` and initialize it. The address where the contract
7810      * will be deployed can be known in advance via {deployedAddress}.
7811      *
7812      * The bytecode for a contract can be obtained from Solidity with
7813      * `type(contractName).creationCode`.
7814      *
7815      * Requirements:
7816      *
7817      * - `bytecode` must not be empty.
7818      * - `salt` must have not been used for `bytecode` already by the same `msg.sender`.
7819      * - `init` is used to initialize the deployed contract
7820      *    as an option to not have the constructor args affect the address derived by `CREATE2`.
7821      */
7822     function deployAndInit(
7823         bytes memory bytecode,
7824         bytes32 salt,
7825         bytes calldata init
7826     ) external returns (address deployedAddress_) {
7827         deployedAddress_ = _deploy(
7828             bytecode,
7829             keccak256(abi.encode(msg.sender, salt))
7830         );
7831 
7832         // solhint-disable-next-line avoid-low-level-calls
7833         (bool success, ) = deployedAddress_.call(init);
7834         if (!success) revert FailedInit();
7835     }
7836 
7837     /**
7838      * @dev Returns the address where a contract will be stored if deployed via {deploy} or {deployAndInit} by `sender`.
7839      * Any change in the `bytecode`, `sender`, or `salt` will result in a new destination address.
7840      */
7841     function deployedAddress(
7842         bytes calldata bytecode,
7843         address sender,
7844         bytes32 salt
7845     ) external view returns (address deployedAddress_) {
7846         bytes32 newSalt = keccak256(abi.encode(sender, salt));
7847         deployedAddress_ = address(
7848             uint160(
7849                 uint256(
7850                     keccak256(
7851                         abi.encodePacked(
7852                             hex"ff",
7853                             address(this),
7854                             newSalt,
7855                             keccak256(bytecode) // init code hash
7856                         )
7857                     )
7858                 )
7859             )
7860         );
7861     }
7862 
7863     function _deploy(bytes memory bytecode, bytes32 salt)
7864         internal
7865         returns (address deployedAddress_)
7866     {
7867         if (bytecode.length == 0) revert EmptyBytecode();
7868 
7869         // solhint-disable-next-line no-inline-assembly
7870         assembly {
7871             deployedAddress_ := create2(
7872                 0,
7873                 add(bytecode, 32),
7874                 mload(bytecode),
7875                 salt
7876             )
7877         }
7878 
7879         if (deployedAddress_ == address(0)) revert FailedDeploy();
7880 
7881         emit Deployed(keccak256(bytecode), salt, deployedAddress_);
7882     }
7883 }
7884 
7885 
7886 // File contracts/test/bad-recipient/BadRecipient2.sol
7887 
7888 
7889 pragma solidity >=0.8.0;
7890 
7891 contract BadRecipient2 {
7892     function handle(uint32, bytes32) external pure {} // solhint-disable-line no-empty-blocks
7893 }
