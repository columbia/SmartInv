1 // Sources flattened with hardhat v2.13.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.8.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
8 
9 pragma solidity ^0.8.1;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library AddressUpgradeable {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         (bool success, bytes memory returndata) = target.staticcall(data);
166         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
167     }
168 
169     /**
170      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
171      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
172      *
173      * _Available since v4.8._
174      */
175     function verifyCallResultFromTarget(
176         address target,
177         bool success,
178         bytes memory returndata,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         if (success) {
182             if (returndata.length == 0) {
183                 // only check isContract if the call was successful and the return data is empty
184                 // otherwise we already know that it was a contract
185                 require(isContract(target), "Address: call to non-contract");
186             }
187             return returndata;
188         } else {
189             _revert(returndata, errorMessage);
190         }
191     }
192 
193     /**
194      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason or using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             _revert(returndata, errorMessage);
208         }
209     }
210 
211     function _revert(bytes memory returndata, string memory errorMessage) private pure {
212         // Look for revert reason and bubble it up if present
213         if (returndata.length > 0) {
214             // The easiest way to bubble the revert reason is using memory via assembly
215             /// @solidity memory-safe-assembly
216             assembly {
217                 let returndata_size := mload(returndata)
218                 revert(add(32, returndata), returndata_size)
219             }
220         } else {
221             revert(errorMessage);
222         }
223     }
224 }
225 
226 
227 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.8.2
228 
229 // OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)
230 
231 pragma solidity ^0.8.2;
232 
233 /**
234  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
235  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
236  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
237  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
238  *
239  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
240  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
241  * case an upgrade adds a module that needs to be initialized.
242  *
243  * For example:
244  *
245  * [.hljs-theme-light.nopadding]
246  * ```
247  * contract MyToken is ERC20Upgradeable {
248  *     function initialize() initializer public {
249  *         __ERC20_init("MyToken", "MTK");
250  *     }
251  * }
252  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
253  *     function initializeV2() reinitializer(2) public {
254  *         __ERC20Permit_init("MyToken");
255  *     }
256  * }
257  * ```
258  *
259  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
260  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
261  *
262  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
263  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
264  *
265  * [CAUTION]
266  * ====
267  * Avoid leaving a contract uninitialized.
268  *
269  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
270  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
271  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
272  *
273  * [.hljs-theme-light.nopadding]
274  * ```
275  * /// @custom:oz-upgrades-unsafe-allow constructor
276  * constructor() {
277  *     _disableInitializers();
278  * }
279  * ```
280  * ====
281  */
282 abstract contract Initializable {
283     /**
284      * @dev Indicates that the contract has been initialized.
285      * @custom:oz-retyped-from bool
286      */
287     uint8 private _initialized;
288 
289     /**
290      * @dev Indicates that the contract is in the process of being initialized.
291      */
292     bool private _initializing;
293 
294     /**
295      * @dev Triggered when the contract has been initialized or reinitialized.
296      */
297     event Initialized(uint8 version);
298 
299     /**
300      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
301      * `onlyInitializing` functions can be used to initialize parent contracts.
302      *
303      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
304      * constructor.
305      *
306      * Emits an {Initialized} event.
307      */
308     modifier initializer() {
309         bool isTopLevelCall = !_initializing;
310         require(
311             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
312             "Initializable: contract is already initialized"
313         );
314         _initialized = 1;
315         if (isTopLevelCall) {
316             _initializing = true;
317         }
318         _;
319         if (isTopLevelCall) {
320             _initializing = false;
321             emit Initialized(1);
322         }
323     }
324 
325     /**
326      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
327      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
328      * used to initialize parent contracts.
329      *
330      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
331      * are added through upgrades and that require initialization.
332      *
333      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
334      * cannot be nested. If one is invoked in the context of another, execution will revert.
335      *
336      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
337      * a contract, executing them in the right order is up to the developer or operator.
338      *
339      * WARNING: setting the version to 255 will prevent any future reinitialization.
340      *
341      * Emits an {Initialized} event.
342      */
343     modifier reinitializer(uint8 version) {
344         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
345         _initialized = version;
346         _initializing = true;
347         _;
348         _initializing = false;
349         emit Initialized(version);
350     }
351 
352     /**
353      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
354      * {initializer} and {reinitializer} modifiers, directly or indirectly.
355      */
356     modifier onlyInitializing() {
357         require(_initializing, "Initializable: contract is not initializing");
358         _;
359     }
360 
361     /**
362      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
363      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
364      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
365      * through proxies.
366      *
367      * Emits an {Initialized} event the first time it is successfully executed.
368      */
369     function _disableInitializers() internal virtual {
370         require(!_initializing, "Initializable: contract is initializing");
371         if (_initialized < type(uint8).max) {
372             _initialized = type(uint8).max;
373             emit Initialized(type(uint8).max);
374         }
375     }
376 
377     /**
378      * @dev Returns the highest version that has been initialized. See {reinitializer}.
379      */
380     function _getInitializedVersion() internal view returns (uint8) {
381         return _initialized;
382     }
383 
384     /**
385      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
386      */
387     function _isInitializing() internal view returns (bool) {
388         return _initializing;
389     }
390 }
391 
392 
393 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.8.2
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Provides information about the current execution context, including the
401  * sender of the transaction and its data. While these are generally available
402  * via msg.sender and msg.data, they should not be accessed in such a direct
403  * manner, since when dealing with meta-transactions the account sending and
404  * paying for execution may not be the actual sender (as far as an application
405  * is concerned).
406  *
407  * This contract is only required for intermediate, library-like contracts.
408  */
409 abstract contract ContextUpgradeable is Initializable {
410     function __Context_init() internal onlyInitializing {
411     }
412 
413     function __Context_init_unchained() internal onlyInitializing {
414     }
415     function _msgSender() internal view virtual returns (address) {
416         return msg.sender;
417     }
418 
419     function _msgData() internal view virtual returns (bytes calldata) {
420         return msg.data;
421     }
422 
423     /**
424      * @dev This empty reserved space is put in place to allow future versions to add new
425      * variables without shifting down storage in the inheritance chain.
426      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
427      */
428     uint256[50] private __gap;
429 }
430 
431 
432 // File @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol@v4.8.2
433 
434 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Contract module which provides a basic access control mechanism, where
441  * there is an account (an owner) that can be granted exclusive access to
442  * specific functions.
443  *
444  * By default, the owner account will be the one that deploys the contract. This
445  * can later be changed with {transferOwnership}.
446  *
447  * This module is used through inheritance. It will make available the modifier
448  * `onlyOwner`, which can be applied to your functions to restrict their use to
449  * the owner.
450  */
451 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
452     address private _owner;
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     /**
457      * @dev Initializes the contract setting the deployer as the initial owner.
458      */
459     function __Ownable_init() internal onlyInitializing {
460         __Ownable_init_unchained();
461     }
462 
463     function __Ownable_init_unchained() internal onlyInitializing {
464         _transferOwnership(_msgSender());
465     }
466 
467     /**
468      * @dev Throws if called by any account other than the owner.
469      */
470     modifier onlyOwner() {
471         _checkOwner();
472         _;
473     }
474 
475     /**
476      * @dev Returns the address of the current owner.
477      */
478     function owner() public view virtual returns (address) {
479         return _owner;
480     }
481 
482     /**
483      * @dev Throws if the sender is not the owner.
484      */
485     function _checkOwner() internal view virtual {
486         require(owner() == _msgSender(), "Ownable: caller is not the owner");
487     }
488 
489     /**
490      * @dev Leaves the contract without owner. It will not be possible to call
491      * `onlyOwner` functions anymore. Can only be called by the current owner.
492      *
493      * NOTE: Renouncing ownership will leave the contract without an owner,
494      * thereby removing any functionality that is only available to the owner.
495      */
496     function renounceOwnership() public virtual onlyOwner {
497         _transferOwnership(address(0));
498     }
499 
500     /**
501      * @dev Transfers ownership of the contract to a new account (`newOwner`).
502      * Can only be called by the current owner.
503      */
504     function transferOwnership(address newOwner) public virtual onlyOwner {
505         require(newOwner != address(0), "Ownable: new owner is the zero address");
506         _transferOwnership(newOwner);
507     }
508 
509     /**
510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
511      * Internal function without access restriction.
512      */
513     function _transferOwnership(address newOwner) internal virtual {
514         address oldOwner = _owner;
515         _owner = newOwner;
516         emit OwnershipTransferred(oldOwner, newOwner);
517     }
518 
519     /**
520      * @dev This empty reserved space is put in place to allow future versions to add new
521      * variables without shifting down storage in the inheritance chain.
522      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
523      */
524     uint256[49] private __gap;
525 }
526 
527 
528 // File @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol@v4.8.2
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Interface of the ERC165 standard, as defined in the
536  * https://eips.ethereum.org/EIPS/eip-165[EIP].
537  *
538  * Implementers can declare support of contract interfaces, which can then be
539  * queried by others ({ERC165Checker}).
540  *
541  * For an implementation, see {ERC165}.
542  */
543 interface IERC165Upgradeable {
544     /**
545      * @dev Returns true if this contract implements the interface defined by
546      * `interfaceId`. See the corresponding
547      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
548      * to learn more about how these ids are created.
549      *
550      * This function call must use less than 30 000 gas.
551      */
552     function supportsInterface(bytes4 interfaceId) external view returns (bool);
553 }
554 
555 
556 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol@v4.8.2
557 
558 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721Upgradeable is IERC165Upgradeable {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must exist and be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
605      *
606      * Emits a {Transfer} event.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId,
612         bytes calldata data
613     ) external;
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Transfers `tokenId` token from `from` to `to`.
637      *
638      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
639      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
640      * understand this adds an external call which potentially creates a reentrancy vulnerability.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must be owned by `from`.
647      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
648      *
649      * Emits a {Transfer} event.
650      */
651     function transferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) external;
656 
657     /**
658      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
659      * The approval is cleared when the token is transferred.
660      *
661      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
662      *
663      * Requirements:
664      *
665      * - The caller must own the token or be an approved operator.
666      * - `tokenId` must exist.
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address to, uint256 tokenId) external;
671 
672     /**
673      * @dev Approve or remove `operator` as an operator for the caller.
674      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
675      *
676      * Requirements:
677      *
678      * - The `operator` cannot be the caller.
679      *
680      * Emits an {ApprovalForAll} event.
681      */
682     function setApprovalForAll(address operator, bool _approved) external;
683 
684     /**
685      * @dev Returns the account approved for `tokenId` token.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function getApproved(uint256 tokenId) external view returns (address operator);
692 
693     /**
694      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
695      *
696      * See {setApprovalForAll}
697      */
698     function isApprovedForAll(address owner, address operator) external view returns (bool);
699 }
700 
701 
702 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol@v4.8.2
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 
730 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol@v4.8.2
731 
732 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @title ERC721 token receiver interface
738  * @dev Interface for any contract that wants to support safeTransfers
739  * from ERC721 asset contracts.
740  */
741 interface IERC721ReceiverUpgradeable {
742     /**
743      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
744      * by `operator` from `from`, this function is called.
745      *
746      * It must return its Solidity selector to confirm the token transfer.
747      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
748      *
749      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
750      */
751     function onERC721Received(
752         address operator,
753         address from,
754         uint256 tokenId,
755         bytes calldata data
756     ) external returns (bytes4);
757 }
758 
759 
760 // File @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol@v4.8.2
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @dev Implementation of the {IERC165} interface.
769  *
770  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
771  * for the additional interface id that will be supported. For example:
772  *
773  * ```solidity
774  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
775  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
776  * }
777  * ```
778  *
779  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
780  */
781 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
782     function __ERC165_init() internal onlyInitializing {
783     }
784 
785     function __ERC165_init_unchained() internal onlyInitializing {
786     }
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
791         return interfaceId == type(IERC165Upgradeable).interfaceId;
792     }
793 
794     /**
795      * @dev This empty reserved space is put in place to allow future versions to add new
796      * variables without shifting down storage in the inheritance chain.
797      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
798      */
799     uint256[50] private __gap;
800 }
801 
802 
803 // File @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol@v4.8.2
804 
805 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 /**
810  * @dev Standard math utilities missing in the Solidity language.
811  */
812 library MathUpgradeable {
813     enum Rounding {
814         Down, // Toward negative infinity
815         Up, // Toward infinity
816         Zero // Toward zero
817     }
818 
819     /**
820      * @dev Returns the largest of two numbers.
821      */
822     function max(uint256 a, uint256 b) internal pure returns (uint256) {
823         return a > b ? a : b;
824     }
825 
826     /**
827      * @dev Returns the smallest of two numbers.
828      */
829     function min(uint256 a, uint256 b) internal pure returns (uint256) {
830         return a < b ? a : b;
831     }
832 
833     /**
834      * @dev Returns the average of two numbers. The result is rounded towards
835      * zero.
836      */
837     function average(uint256 a, uint256 b) internal pure returns (uint256) {
838         // (a + b) / 2 can overflow.
839         return (a & b) + (a ^ b) / 2;
840     }
841 
842     /**
843      * @dev Returns the ceiling of the division of two numbers.
844      *
845      * This differs from standard division with `/` in that it rounds up instead
846      * of rounding down.
847      */
848     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
849         // (a + b - 1) / b can overflow on addition, so we distribute.
850         return a == 0 ? 0 : (a - 1) / b + 1;
851     }
852 
853     /**
854      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
855      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
856      * with further edits by Uniswap Labs also under MIT license.
857      */
858     function mulDiv(
859         uint256 x,
860         uint256 y,
861         uint256 denominator
862     ) internal pure returns (uint256 result) {
863         unchecked {
864             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
865             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
866             // variables such that product = prod1 * 2^256 + prod0.
867             uint256 prod0; // Least significant 256 bits of the product
868             uint256 prod1; // Most significant 256 bits of the product
869             assembly {
870                 let mm := mulmod(x, y, not(0))
871                 prod0 := mul(x, y)
872                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
873             }
874 
875             // Handle non-overflow cases, 256 by 256 division.
876             if (prod1 == 0) {
877                 return prod0 / denominator;
878             }
879 
880             // Make sure the result is less than 2^256. Also prevents denominator == 0.
881             require(denominator > prod1);
882 
883             ///////////////////////////////////////////////
884             // 512 by 256 division.
885             ///////////////////////////////////////////////
886 
887             // Make division exact by subtracting the remainder from [prod1 prod0].
888             uint256 remainder;
889             assembly {
890                 // Compute remainder using mulmod.
891                 remainder := mulmod(x, y, denominator)
892 
893                 // Subtract 256 bit number from 512 bit number.
894                 prod1 := sub(prod1, gt(remainder, prod0))
895                 prod0 := sub(prod0, remainder)
896             }
897 
898             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
899             // See https://cs.stackexchange.com/q/138556/92363.
900 
901             // Does not overflow because the denominator cannot be zero at this stage in the function.
902             uint256 twos = denominator & (~denominator + 1);
903             assembly {
904                 // Divide denominator by twos.
905                 denominator := div(denominator, twos)
906 
907                 // Divide [prod1 prod0] by twos.
908                 prod0 := div(prod0, twos)
909 
910                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
911                 twos := add(div(sub(0, twos), twos), 1)
912             }
913 
914             // Shift in bits from prod1 into prod0.
915             prod0 |= prod1 * twos;
916 
917             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
918             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
919             // four bits. That is, denominator * inv = 1 mod 2^4.
920             uint256 inverse = (3 * denominator) ^ 2;
921 
922             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
923             // in modular arithmetic, doubling the correct bits in each step.
924             inverse *= 2 - denominator * inverse; // inverse mod 2^8
925             inverse *= 2 - denominator * inverse; // inverse mod 2^16
926             inverse *= 2 - denominator * inverse; // inverse mod 2^32
927             inverse *= 2 - denominator * inverse; // inverse mod 2^64
928             inverse *= 2 - denominator * inverse; // inverse mod 2^128
929             inverse *= 2 - denominator * inverse; // inverse mod 2^256
930 
931             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
932             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
933             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
934             // is no longer required.
935             result = prod0 * inverse;
936             return result;
937         }
938     }
939 
940     /**
941      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
942      */
943     function mulDiv(
944         uint256 x,
945         uint256 y,
946         uint256 denominator,
947         Rounding rounding
948     ) internal pure returns (uint256) {
949         uint256 result = mulDiv(x, y, denominator);
950         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
951             result += 1;
952         }
953         return result;
954     }
955 
956     /**
957      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
958      *
959      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
960      */
961     function sqrt(uint256 a) internal pure returns (uint256) {
962         if (a == 0) {
963             return 0;
964         }
965 
966         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
967         //
968         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
969         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
970         //
971         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
972         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
973         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
974         //
975         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
976         uint256 result = 1 << (log2(a) >> 1);
977 
978         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
979         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
980         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
981         // into the expected uint128 result.
982         unchecked {
983             result = (result + a / result) >> 1;
984             result = (result + a / result) >> 1;
985             result = (result + a / result) >> 1;
986             result = (result + a / result) >> 1;
987             result = (result + a / result) >> 1;
988             result = (result + a / result) >> 1;
989             result = (result + a / result) >> 1;
990             return min(result, a / result);
991         }
992     }
993 
994     /**
995      * @notice Calculates sqrt(a), following the selected rounding direction.
996      */
997     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
998         unchecked {
999             uint256 result = sqrt(a);
1000             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1001         }
1002     }
1003 
1004     /**
1005      * @dev Return the log in base 2, rounded down, of a positive value.
1006      * Returns 0 if given 0.
1007      */
1008     function log2(uint256 value) internal pure returns (uint256) {
1009         uint256 result = 0;
1010         unchecked {
1011             if (value >> 128 > 0) {
1012                 value >>= 128;
1013                 result += 128;
1014             }
1015             if (value >> 64 > 0) {
1016                 value >>= 64;
1017                 result += 64;
1018             }
1019             if (value >> 32 > 0) {
1020                 value >>= 32;
1021                 result += 32;
1022             }
1023             if (value >> 16 > 0) {
1024                 value >>= 16;
1025                 result += 16;
1026             }
1027             if (value >> 8 > 0) {
1028                 value >>= 8;
1029                 result += 8;
1030             }
1031             if (value >> 4 > 0) {
1032                 value >>= 4;
1033                 result += 4;
1034             }
1035             if (value >> 2 > 0) {
1036                 value >>= 2;
1037                 result += 2;
1038             }
1039             if (value >> 1 > 0) {
1040                 result += 1;
1041             }
1042         }
1043         return result;
1044     }
1045 
1046     /**
1047      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1048      * Returns 0 if given 0.
1049      */
1050     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1051         unchecked {
1052             uint256 result = log2(value);
1053             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1054         }
1055     }
1056 
1057     /**
1058      * @dev Return the log in base 10, rounded down, of a positive value.
1059      * Returns 0 if given 0.
1060      */
1061     function log10(uint256 value) internal pure returns (uint256) {
1062         uint256 result = 0;
1063         unchecked {
1064             if (value >= 10**64) {
1065                 value /= 10**64;
1066                 result += 64;
1067             }
1068             if (value >= 10**32) {
1069                 value /= 10**32;
1070                 result += 32;
1071             }
1072             if (value >= 10**16) {
1073                 value /= 10**16;
1074                 result += 16;
1075             }
1076             if (value >= 10**8) {
1077                 value /= 10**8;
1078                 result += 8;
1079             }
1080             if (value >= 10**4) {
1081                 value /= 10**4;
1082                 result += 4;
1083             }
1084             if (value >= 10**2) {
1085                 value /= 10**2;
1086                 result += 2;
1087             }
1088             if (value >= 10**1) {
1089                 result += 1;
1090             }
1091         }
1092         return result;
1093     }
1094 
1095     /**
1096      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1097      * Returns 0 if given 0.
1098      */
1099     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1100         unchecked {
1101             uint256 result = log10(value);
1102             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Return the log in base 256, rounded down, of a positive value.
1108      * Returns 0 if given 0.
1109      *
1110      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1111      */
1112     function log256(uint256 value) internal pure returns (uint256) {
1113         uint256 result = 0;
1114         unchecked {
1115             if (value >> 128 > 0) {
1116                 value >>= 128;
1117                 result += 16;
1118             }
1119             if (value >> 64 > 0) {
1120                 value >>= 64;
1121                 result += 8;
1122             }
1123             if (value >> 32 > 0) {
1124                 value >>= 32;
1125                 result += 4;
1126             }
1127             if (value >> 16 > 0) {
1128                 value >>= 16;
1129                 result += 2;
1130             }
1131             if (value >> 8 > 0) {
1132                 result += 1;
1133             }
1134         }
1135         return result;
1136     }
1137 
1138     /**
1139      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1140      * Returns 0 if given 0.
1141      */
1142     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1143         unchecked {
1144             uint256 result = log256(value);
1145             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1146         }
1147     }
1148 }
1149 
1150 
1151 // File @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol@v4.8.2
1152 
1153 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 /**
1158  * @dev String operations.
1159  */
1160 library StringsUpgradeable {
1161     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1162     uint8 private constant _ADDRESS_LENGTH = 20;
1163 
1164     /**
1165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1166      */
1167     function toString(uint256 value) internal pure returns (string memory) {
1168         unchecked {
1169             uint256 length = MathUpgradeable.log10(value) + 1;
1170             string memory buffer = new string(length);
1171             uint256 ptr;
1172             /// @solidity memory-safe-assembly
1173             assembly {
1174                 ptr := add(buffer, add(32, length))
1175             }
1176             while (true) {
1177                 ptr--;
1178                 /// @solidity memory-safe-assembly
1179                 assembly {
1180                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1181                 }
1182                 value /= 10;
1183                 if (value == 0) break;
1184             }
1185             return buffer;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1191      */
1192     function toHexString(uint256 value) internal pure returns (string memory) {
1193         unchecked {
1194             return toHexString(value, MathUpgradeable.log256(value) + 1);
1195         }
1196     }
1197 
1198     /**
1199      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1200      */
1201     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1202         bytes memory buffer = new bytes(2 * length + 2);
1203         buffer[0] = "0";
1204         buffer[1] = "x";
1205         for (uint256 i = 2 * length + 1; i > 1; --i) {
1206             buffer[i] = _SYMBOLS[value & 0xf];
1207             value >>= 4;
1208         }
1209         require(value == 0, "Strings: hex length insufficient");
1210         return string(buffer);
1211     }
1212 
1213     /**
1214      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1215      */
1216     function toHexString(address addr) internal pure returns (string memory) {
1217         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1218     }
1219 }
1220 
1221 
1222 // File @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol@v4.8.2
1223 
1224 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 /**
1236  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1237  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1238  * {ERC721Enumerable}.
1239  */
1240 contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
1241     using AddressUpgradeable for address;
1242     using StringsUpgradeable for uint256;
1243 
1244     // Token name
1245     string private _name;
1246 
1247     // Token symbol
1248     string private _symbol;
1249 
1250     // Mapping from token ID to owner address
1251     mapping(uint256 => address) private _owners;
1252 
1253     // Mapping owner address to token count
1254     mapping(address => uint256) private _balances;
1255 
1256     // Mapping from token ID to approved address
1257     mapping(uint256 => address) private _tokenApprovals;
1258 
1259     // Mapping from owner to operator approvals
1260     mapping(address => mapping(address => bool)) private _operatorApprovals;
1261 
1262     /**
1263      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1264      */
1265     function __ERC721_init(string memory name_, string memory symbol_) internal onlyInitializing {
1266         __ERC721_init_unchained(name_, symbol_);
1267     }
1268 
1269     function __ERC721_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
1270         _name = name_;
1271         _symbol = symbol_;
1272     }
1273 
1274     /**
1275      * @dev See {IERC165-supportsInterface}.
1276      */
1277     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1278         return
1279             interfaceId == type(IERC721Upgradeable).interfaceId ||
1280             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
1281             super.supportsInterface(interfaceId);
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-balanceOf}.
1286      */
1287     function balanceOf(address owner) public view virtual override returns (uint256) {
1288         require(owner != address(0), "ERC721: address zero is not a valid owner");
1289         return _balances[owner];
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-ownerOf}.
1294      */
1295     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1296         address owner = _ownerOf(tokenId);
1297         require(owner != address(0), "ERC721: invalid token ID");
1298         return owner;
1299     }
1300 
1301     /**
1302      * @dev See {IERC721Metadata-name}.
1303      */
1304     function name() public view virtual override returns (string memory) {
1305         return _name;
1306     }
1307 
1308     /**
1309      * @dev See {IERC721Metadata-symbol}.
1310      */
1311     function symbol() public view virtual override returns (string memory) {
1312         return _symbol;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Metadata-tokenURI}.
1317      */
1318     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1319         _requireMinted(tokenId);
1320 
1321         string memory baseURI = _baseURI();
1322         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1323     }
1324 
1325     /**
1326      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1327      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1328      * by default, can be overridden in child contracts.
1329      */
1330     function _baseURI() internal view virtual returns (string memory) {
1331         return "";
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-approve}.
1336      */
1337     function approve(address to, uint256 tokenId) public virtual override {
1338         address owner = ERC721Upgradeable.ownerOf(tokenId);
1339         require(to != owner, "ERC721: approval to current owner");
1340 
1341         require(
1342             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1343             "ERC721: approve caller is not token owner or approved for all"
1344         );
1345 
1346         _approve(to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-getApproved}.
1351      */
1352     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1353         _requireMinted(tokenId);
1354 
1355         return _tokenApprovals[tokenId];
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-setApprovalForAll}.
1360      */
1361     function setApprovalForAll(address operator, bool approved) public virtual override {
1362         _setApprovalForAll(_msgSender(), operator, approved);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-isApprovedForAll}.
1367      */
1368     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1369         return _operatorApprovals[owner][operator];
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-transferFrom}.
1374      */
1375     function transferFrom(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) public virtual override {
1380         //solhint-disable-next-line max-line-length
1381         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1382 
1383         _transfer(from, to, tokenId);
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-safeTransferFrom}.
1388      */
1389     function safeTransferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         safeTransferFrom(from, to, tokenId, "");
1395     }
1396 
1397     /**
1398      * @dev See {IERC721-safeTransferFrom}.
1399      */
1400     function safeTransferFrom(
1401         address from,
1402         address to,
1403         uint256 tokenId,
1404         bytes memory data
1405     ) public virtual override {
1406         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1407         _safeTransfer(from, to, tokenId, data);
1408     }
1409 
1410     /**
1411      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1412      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1413      *
1414      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1415      *
1416      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1417      * implement alternative mechanisms to perform token transfer, such as signature-based.
1418      *
1419      * Requirements:
1420      *
1421      * - `from` cannot be the zero address.
1422      * - `to` cannot be the zero address.
1423      * - `tokenId` token must exist and be owned by `from`.
1424      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1425      *
1426      * Emits a {Transfer} event.
1427      */
1428     function _safeTransfer(
1429         address from,
1430         address to,
1431         uint256 tokenId,
1432         bytes memory data
1433     ) internal virtual {
1434         _transfer(from, to, tokenId);
1435         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1436     }
1437 
1438     /**
1439      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1440      */
1441     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1442         return _owners[tokenId];
1443     }
1444 
1445     /**
1446      * @dev Returns whether `tokenId` exists.
1447      *
1448      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1449      *
1450      * Tokens start existing when they are minted (`_mint`),
1451      * and stop existing when they are burned (`_burn`).
1452      */
1453     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1454         return _ownerOf(tokenId) != address(0);
1455     }
1456 
1457     /**
1458      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      */
1464     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1465         address owner = ERC721Upgradeable.ownerOf(tokenId);
1466         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1467     }
1468 
1469     /**
1470      * @dev Safely mints `tokenId` and transfers it to `to`.
1471      *
1472      * Requirements:
1473      *
1474      * - `tokenId` must not exist.
1475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _safeMint(address to, uint256 tokenId) internal virtual {
1480         _safeMint(to, tokenId, "");
1481     }
1482 
1483     /**
1484      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1485      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1486      */
1487     function _safeMint(
1488         address to,
1489         uint256 tokenId,
1490         bytes memory data
1491     ) internal virtual {
1492         _mint(to, tokenId);
1493         require(
1494             _checkOnERC721Received(address(0), to, tokenId, data),
1495             "ERC721: transfer to non ERC721Receiver implementer"
1496         );
1497     }
1498 
1499     /**
1500      * @dev Mints `tokenId` and transfers it to `to`.
1501      *
1502      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must not exist.
1507      * - `to` cannot be the zero address.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _mint(address to, uint256 tokenId) internal virtual {
1512         require(to != address(0), "ERC721: mint to the zero address");
1513         require(!_exists(tokenId), "ERC721: token already minted");
1514 
1515         _beforeTokenTransfer(address(0), to, tokenId, 1);
1516 
1517         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1518         require(!_exists(tokenId), "ERC721: token already minted");
1519 
1520         unchecked {
1521             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1522             // Given that tokens are minted one by one, it is impossible in practice that
1523             // this ever happens. Might change if we allow batch minting.
1524             // The ERC fails to describe this case.
1525             _balances[to] += 1;
1526         }
1527 
1528         _owners[tokenId] = to;
1529 
1530         emit Transfer(address(0), to, tokenId);
1531 
1532         _afterTokenTransfer(address(0), to, tokenId, 1);
1533     }
1534 
1535     /**
1536      * @dev Destroys `tokenId`.
1537      * The approval is cleared when the token is burned.
1538      * This is an internal function that does not check if the sender is authorized to operate on the token.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must exist.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function _burn(uint256 tokenId) internal virtual {
1547         address owner = ERC721Upgradeable.ownerOf(tokenId);
1548 
1549         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1550 
1551         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1552         owner = ERC721Upgradeable.ownerOf(tokenId);
1553 
1554         // Clear approvals
1555         delete _tokenApprovals[tokenId];
1556 
1557         unchecked {
1558             // Cannot overflow, as that would require more tokens to be burned/transferred
1559             // out than the owner initially received through minting and transferring in.
1560             _balances[owner] -= 1;
1561         }
1562         delete _owners[tokenId];
1563 
1564         emit Transfer(owner, address(0), tokenId);
1565 
1566         _afterTokenTransfer(owner, address(0), tokenId, 1);
1567     }
1568 
1569     /**
1570      * @dev Transfers `tokenId` from `from` to `to`.
1571      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1572      *
1573      * Requirements:
1574      *
1575      * - `to` cannot be the zero address.
1576      * - `tokenId` token must be owned by `from`.
1577      *
1578      * Emits a {Transfer} event.
1579      */
1580     function _transfer(
1581         address from,
1582         address to,
1583         uint256 tokenId
1584     ) internal virtual {
1585         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1586         require(to != address(0), "ERC721: transfer to the zero address");
1587 
1588         _beforeTokenTransfer(from, to, tokenId, 1);
1589 
1590         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1591         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1592 
1593         // Clear approvals from the previous owner
1594         delete _tokenApprovals[tokenId];
1595 
1596         unchecked {
1597             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1598             // `from`'s balance is the number of token held, which is at least one before the current
1599             // transfer.
1600             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1601             // all 2**256 token ids to be minted, which in practice is impossible.
1602             _balances[from] -= 1;
1603             _balances[to] += 1;
1604         }
1605         _owners[tokenId] = to;
1606 
1607         emit Transfer(from, to, tokenId);
1608 
1609         _afterTokenTransfer(from, to, tokenId, 1);
1610     }
1611 
1612     /**
1613      * @dev Approve `to` to operate on `tokenId`
1614      *
1615      * Emits an {Approval} event.
1616      */
1617     function _approve(address to, uint256 tokenId) internal virtual {
1618         _tokenApprovals[tokenId] = to;
1619         emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
1620     }
1621 
1622     /**
1623      * @dev Approve `operator` to operate on all of `owner` tokens
1624      *
1625      * Emits an {ApprovalForAll} event.
1626      */
1627     function _setApprovalForAll(
1628         address owner,
1629         address operator,
1630         bool approved
1631     ) internal virtual {
1632         require(owner != operator, "ERC721: approve to caller");
1633         _operatorApprovals[owner][operator] = approved;
1634         emit ApprovalForAll(owner, operator, approved);
1635     }
1636 
1637     /**
1638      * @dev Reverts if the `tokenId` has not been minted yet.
1639      */
1640     function _requireMinted(uint256 tokenId) internal view virtual {
1641         require(_exists(tokenId), "ERC721: invalid token ID");
1642     }
1643 
1644     /**
1645      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1646      * The call is not executed if the target address is not a contract.
1647      *
1648      * @param from address representing the previous owner of the given token ID
1649      * @param to target address that will receive the tokens
1650      * @param tokenId uint256 ID of the token to be transferred
1651      * @param data bytes optional data to send along with the call
1652      * @return bool whether the call correctly returned the expected magic value
1653      */
1654     function _checkOnERC721Received(
1655         address from,
1656         address to,
1657         uint256 tokenId,
1658         bytes memory data
1659     ) private returns (bool) {
1660         if (to.isContract()) {
1661             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1662                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
1663             } catch (bytes memory reason) {
1664                 if (reason.length == 0) {
1665                     revert("ERC721: transfer to non ERC721Receiver implementer");
1666                 } else {
1667                     /// @solidity memory-safe-assembly
1668                     assembly {
1669                         revert(add(32, reason), mload(reason))
1670                     }
1671                 }
1672             }
1673         } else {
1674             return true;
1675         }
1676     }
1677 
1678     /**
1679      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1680      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1681      *
1682      * Calling conditions:
1683      *
1684      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1685      * - When `from` is zero, the tokens will be minted for `to`.
1686      * - When `to` is zero, ``from``'s tokens will be burned.
1687      * - `from` and `to` are never both zero.
1688      * - `batchSize` is non-zero.
1689      *
1690      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1691      */
1692     function _beforeTokenTransfer(
1693         address from,
1694         address to,
1695         uint256 firstTokenId,
1696         uint256 batchSize
1697     ) internal virtual {}
1698 
1699     /**
1700      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1701      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1702      *
1703      * Calling conditions:
1704      *
1705      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1706      * - When `from` is zero, the tokens were minted for `to`.
1707      * - When `to` is zero, ``from``'s tokens were burned.
1708      * - `from` and `to` are never both zero.
1709      * - `batchSize` is non-zero.
1710      *
1711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1712      */
1713     function _afterTokenTransfer(
1714         address from,
1715         address to,
1716         uint256 firstTokenId,
1717         uint256 batchSize
1718     ) internal virtual {}
1719 
1720     /**
1721      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1722      *
1723      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1724      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1725      * that `ownerOf(tokenId)` is `a`.
1726      */
1727     // solhint-disable-next-line func-name-mixedcase
1728     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1729         _balances[account] += amount;
1730     }
1731 
1732     /**
1733      * @dev This empty reserved space is put in place to allow future versions to add new
1734      * variables without shifting down storage in the inheritance chain.
1735      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1736      */
1737     uint256[44] private __gap;
1738 }
1739 
1740 
1741 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol@v4.8.2
1742 
1743 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1744 
1745 pragma solidity ^0.8.0;
1746 
1747 /**
1748  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1749  * @dev See https://eips.ethereum.org/EIPS/eip-721
1750  */
1751 interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
1752     /**
1753      * @dev Returns the total amount of tokens stored by the contract.
1754      */
1755     function totalSupply() external view returns (uint256);
1756 
1757     /**
1758      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1759      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1760      */
1761     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1762 
1763     /**
1764      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1765      * Use along with {totalSupply} to enumerate all tokens.
1766      */
1767     function tokenByIndex(uint256 index) external view returns (uint256);
1768 }
1769 
1770 
1771 // File contracts/gamma/structs/GammaVerificationParams.sol
1772 
1773 pragma solidity ^0.8.15;
1774 
1775 /**
1776  * @dev Struct used for Signature Verification
1777  *
1778  * @dev See {SignatureVerifierBase}
1779  * {address} to_ - The `msg.sender` the signature was signed for
1780  * {address} for_ - What contract the signature is to be used on
1781  * {uint256} value_ - A multi-use variable that can be used anywhere in the Verification
1782  * {uint256} nonce_ - A nonce for uniqueness
1783  * {bytes} signature - The signature provided with the data to be unpacked to get the signer
1784  */
1785 struct GammaVerificationParams {
1786     address to_;
1787     address for_;
1788     uint256 value_;
1789     uint256 nonce_;
1790     bytes signature;
1791 }
1792 
1793 
1794 // File contracts/gamma/SignatureVerifiers/IGammaSignatureVerifier.sol
1795 
1796 pragma solidity ^0.8.15;
1797 
1798 // Structs
1799 
1800 /**
1801  * @title IGammaSignatureVerifier
1802  * @author 0xLostArchitect
1803  *
1804  * @notice Interface to interact with a contract that produces message hashes and verifies signatures
1805  */
1806 interface IGammaSignatureVerifier {
1807     /* Used for getting the hash messaged needed for the signature verification */
1808     function getMessageHash(
1809         address to_,
1810         address for_,
1811         uint256 value_,
1812         uint256 nonce_
1813     ) external pure returns (bytes32);
1814 
1815     function getSignerFromVerificationParams(
1816         address to_,
1817         address for_,
1818         uint256 value_,
1819         uint256 nonce_,
1820         bytes calldata signature
1821     ) external pure returns (address);
1822 
1823     function verifySignature(
1824         GammaVerificationParams calldata,
1825         address
1826     ) external view;
1827 }
1828 
1829 
1830 // File contracts/gamma/interfaces/IGammaSignatureVerifier.sol
1831 
1832 pragma solidity ^0.8.15;
1833 
1834 
1835 // File contracts/gamma/storage/GammaLostAchievementStorage.sol
1836 
1837 pragma solidity ^0.8.17;
1838 
1839 // Interfaces
1840 
1841 /**
1842  * @title GammaLostAchievementStorage
1843  * @author 0xLostArchitect
1844  *
1845  * @notice Storage for any GammaLostAchievement
1846  */
1847 abstract contract GammaLostAchievementStorage {
1848     /* STATE VARIABLES */
1849 
1850     /**
1851      * @dev Used to hold the current supply
1852      */
1853     uint256 internal _currentSupply;
1854 
1855     // Mapping from owner to the token they own
1856     mapping(address => uint256) internal _ownedTokens;
1857 
1858     /**
1859      * @dev Signature verifier to ensure proper mints
1860      */
1861     IGammaSignatureVerifier internal _signatureVerifier;
1862 
1863     /**
1864      * @dev The uri pointing to the off-chain metadata
1865      */
1866     string internal __baseURI;
1867 
1868     /* EVENTS */
1869     event GammaLostAchievementInitialized(
1870         string name_,
1871         string symbol_,
1872         IGammaSignatureVerifier signatureVerifier_,
1873         string baseURI_,
1874         address owner_
1875     );
1876 }
1877 
1878 
1879 // File contracts/gamma/achievements/GammaLostAchievement.sol
1880 
1881 pragma solidity ^0.8.17;
1882 
1883 // External
1884 
1885 
1886 // Inherits
1887 
1888 // Interfaces
1889 
1890 // Structs
1891 
1892 /**
1893  * @title GammaLostAchievement
1894  * @author 0xLostArchitect
1895  *
1896  * @dev Implementation for a GammaLostAchievement
1897  *
1898  * Inherits:
1899  * - OwnableUpgradeable - This contract has an `owner`
1900  * - ERC721Upgradeable - To provide base 721 functionality
1901  * - IERC721EnumerableUpgradeable - To indicate that IERC721Enumerable is implemented
1902  * - GammaLostAchievementStorage -  Use `storage` pattern to put all structs, state variables, and events elsewhere
1903  */
1904 contract GammaLostAchievement is
1905     GammaLostAchievementStorage,
1906     ERC721Upgradeable,
1907     IERC721EnumerableUpgradeable,
1908     OwnableUpgradeable
1909 {
1910     /**
1911      * @notice Initializer to make the GammaLostAchievement
1912      *
1913      * @dev Use `initializer` over constructor because these are clones!
1914      *
1915      * @param name_ - Name for the 721
1916      * @param symbol_ - Symbol for the 721
1917      * @param signatureVerifier_ - Contract for verifying signatures
1918      * @param baseURI_ - The metadata URI for the GammaLostAchievement
1919      * @param owner_ - The owner of the contract
1920      */
1921     function initialize(
1922         string calldata name_,
1923         string calldata symbol_,
1924         IGammaSignatureVerifier signatureVerifier_,
1925         string calldata baseURI_,
1926         address owner_
1927     ) public virtual initializer {
1928         __ERC721_init(name_, symbol_);
1929         __Ownable_init();
1930         _signatureVerifier = signatureVerifier_;
1931         __baseURI = baseURI_;
1932 
1933         _transferOwnership(owner_);
1934 
1935         emit GammaLostAchievementInitialized(
1936             name_,
1937             symbol_,
1938             signatureVerifier_,
1939             baseURI_,
1940             owner_
1941         );
1942     }
1943 
1944     /**
1945      * @notice Minting function for the achievement
1946      *
1947      * @param verificationParams - The verification params to ensure that this
1948      */
1949     function claim(
1950         GammaVerificationParams calldata verificationParams
1951     ) external {
1952         // Verify the signature
1953         _signatureVerifier.verifySignature(
1954             verificationParams,
1955             verificationParams.to_
1956         );
1957 
1958         // Do the actual mint
1959         _mint(verificationParams.to_, _currentSupply);
1960 
1961         // Add to mapping which token the address owns
1962         _ownedTokens[verificationParams.to_] = _currentSupply;
1963 
1964         // Update the tracker
1965         _currentSupply += 1;
1966     }
1967 
1968     /**
1969      * @dev See {ERC721Upgradeable-tokenURI}.
1970      */
1971     function tokenURI(
1972         uint256 tokenId
1973     ) public view virtual override returns (string memory) {
1974         _requireMinted(tokenId);
1975         return __baseURI;
1976     }
1977 
1978     /**
1979      * @notice Return the currently minted supply of tokens
1980      */
1981     function totalSupply() external view returns (uint256) {
1982         return _currentSupply;
1983     }
1984 
1985     /**
1986      * @dev See {IERC721Enumerable-tokenByIndex}.
1987      */
1988     function tokenByIndex(
1989         uint256 index
1990     ) public view virtual override returns (uint256) {
1991         require(
1992             index < _currentSupply,
1993             "ERC721Enumerable: global index out of bounds"
1994         );
1995         return index;
1996     }
1997 
1998     /**
1999      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2000      */
2001     function tokenOfOwnerByIndex(
2002         address owner,
2003         uint256 index
2004     ) public view virtual override returns (uint256) {
2005         require(
2006             index == 0 && balanceOf(owner) > 0,
2007             "ERC721Enumerable: owner index out of bounds"
2008         );
2009         return _ownedTokens[owner];
2010     }
2011 
2012     /**
2013      * @dev Override hook to make token non-transferable
2014      */
2015     function _beforeTokenTransfer(
2016         address from,
2017         address to,
2018         uint256 tokenId,
2019         uint256 batchSize
2020     ) internal override {
2021         require(from == address(0), "btt::non-tradeable");
2022         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2023     }
2024 
2025     /**
2026      * @dev See {IERC165-supportsInterface}.
2027      */
2028     function supportsInterface(
2029         bytes4 interfaceId
2030     )
2031         public
2032         view
2033         virtual
2034         override(IERC165Upgradeable, ERC721Upgradeable)
2035         returns (bool)
2036     {
2037         return
2038             interfaceId == type(IERC721EnumerableUpgradeable).interfaceId ||
2039             super.supportsInterface(interfaceId);
2040     }
2041 }