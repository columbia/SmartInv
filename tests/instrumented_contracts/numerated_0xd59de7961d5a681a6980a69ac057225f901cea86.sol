1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      *
12      * Note that `value` may be zero.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /**
17      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
18      * a call to {approve}. `value` is the new allowance.
19      */
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `to`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `from` to `to` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 amount
79     ) external returns (bool);
80 }
81 
82 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev String operations.
91  */
92 library StringsUpgradeable {
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94     uint8 private constant _ADDRESS_LENGTH = 20;
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
98      */
99     function toString(uint256 value) internal pure returns (string memory) {
100         // Inspired by OraclizeAPI's implementation - MIT licence
101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
102 
103         if (value == 0) {
104             return "0";
105         }
106         uint256 temp = value;
107         uint256 digits;
108         while (temp != 0) {
109             digits++;
110             temp /= 10;
111         }
112         bytes memory buffer = new bytes(digits);
113         while (value != 0) {
114             digits -= 1;
115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
116             value /= 10;
117         }
118         return string(buffer);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
123      */
124     function toHexString(uint256 value) internal pure returns (string memory) {
125         if (value == 0) {
126             return "0x00";
127         }
128         uint256 temp = value;
129         uint256 length = 0;
130         while (temp != 0) {
131             length++;
132             temp >>= 8;
133         }
134         return toHexString(value, length);
135     }
136 
137     /**
138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
139      */
140     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
141         bytes memory buffer = new bytes(2 * length + 2);
142         buffer[0] = "0";
143         buffer[1] = "x";
144         for (uint256 i = 2 * length + 1; i > 1; --i) {
145             buffer[i] = _HEX_SYMBOLS[value & 0xf];
146             value >>= 4;
147         }
148         require(value == 0, "Strings: hex length insufficient");
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
154      */
155     function toHexString(address addr) internal pure returns (string memory) {
156         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
157     }
158 }
159 
160 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
161 
162 
163 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
164 
165 pragma solidity ^0.8.1;
166 
167 /**
168  * @dev Collection of functions related to the address type
169  */
170 library AddressUpgradeable {
171     /**
172      * @dev Returns true if `account` is a contract.
173      *
174      * [IMPORTANT]
175      * ====
176      * It is unsafe to assume that an address for which this function returns
177      * false is an externally-owned account (EOA) and not a contract.
178      *
179      * Among others, `isContract` will return false for the following
180      * types of addresses:
181      *
182      *  - an externally-owned account
183      *  - a contract in construction
184      *  - an address where a contract will be created
185      *  - an address where a contract lived, but was destroyed
186      * ====
187      *
188      * [IMPORTANT]
189      * ====
190      * You shouldn't rely on `isContract` to protect against flash loan attacks!
191      *
192      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
193      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
194      * constructor.
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // This method relies on extcodesize/address.code.length, which returns 0
199         // for contracts in construction, since the code is only stored at the end
200         // of the constructor execution.
201 
202         return account.code.length > 0;
203     }
204 
205     /**
206      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
207      * `recipient`, forwarding all available gas and reverting on errors.
208      *
209      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
210      * of certain opcodes, possibly making contracts go over the 2300 gas limit
211      * imposed by `transfer`, making them unable to receive funds via
212      * `transfer`. {sendValue} removes this limitation.
213      *
214      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
215      *
216      * IMPORTANT: because control is transferred to `recipient`, care must be
217      * taken to not create reentrancy vulnerabilities. Consider using
218      * {ReentrancyGuard} or the
219      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
220      */
221     function sendValue(address payable recipient, uint256 amount) internal {
222         require(address(this).balance >= amount, "Address: insufficient balance");
223 
224         (bool success, ) = recipient.call{value: amount}("");
225         require(success, "Address: unable to send value, recipient may have reverted");
226     }
227 
228     /**
229      * @dev Performs a Solidity function call using a low level `call`. A
230      * plain `call` is an unsafe replacement for a function call: use this
231      * function instead.
232      *
233      * If `target` reverts with a revert reason, it is bubbled up by this
234      * function (like regular Solidity function calls).
235      *
236      * Returns the raw returned data. To convert to the expected return value,
237      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
238      *
239      * Requirements:
240      *
241      * - `target` must be a contract.
242      * - calling `target` with `data` must not revert.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionCall(target, data, "Address: low-level call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
252      * `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but also transferring `value` wei to `target`.
267      *
268      * Requirements:
269      *
270      * - the calling contract must have an ETH balance of at least `value`.
271      * - the called Solidity function must be `payable`.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
285      * with `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(address(this).balance >= value, "Address: insufficient balance for call");
296         require(isContract(target), "Address: call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.call{value: value}(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but performing a static call.
305      *
306      * _Available since v3.3._
307      */
308     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
309         return functionStaticCall(target, data, "Address: low-level static call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal view returns (bytes memory) {
323         require(isContract(target), "Address: static call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.staticcall(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
331      * revert reason using the provided one.
332      *
333      * _Available since v4.3._
334      */
335     function verifyCallResult(
336         bool success,
337         bytes memory returndata,
338         string memory errorMessage
339     ) internal pure returns (bytes memory) {
340         if (success) {
341             return returndata;
342         } else {
343             // Look for revert reason and bubble it up if present
344             if (returndata.length > 0) {
345                 // The easiest way to bubble the revert reason is using memory via assembly
346                 /// @solidity memory-safe-assembly
347                 assembly {
348                     let returndata_size := mload(returndata)
349                     revert(add(32, returndata), returndata_size)
350                 }
351             } else {
352                 revert(errorMessage);
353             }
354         }
355     }
356 }
357 
358 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
359 
360 
361 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
362 
363 pragma solidity ^0.8.2;
364 
365 
366 /**
367  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
368  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
369  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
370  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
371  *
372  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
373  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
374  * case an upgrade adds a module that needs to be initialized.
375  *
376  * For example:
377  *
378  * [.hljs-theme-light.nopadding]
379  * ```
380  * contract MyToken is ERC20Upgradeable {
381  *     function initialize() initializer public {
382  *         __ERC20_init("MyToken", "MTK");
383  *     }
384  * }
385  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
386  *     function initializeV2() reinitializer(2) public {
387  *         __ERC20Permit_init("MyToken");
388  *     }
389  * }
390  * ```
391  *
392  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
393  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
394  *
395  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
396  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
397  *
398  * [CAUTION]
399  * ====
400  * Avoid leaving a contract uninitialized.
401  *
402  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
403  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
404  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
405  *
406  * [.hljs-theme-light.nopadding]
407  * ```
408  * /// @custom:oz-upgrades-unsafe-allow constructor
409  * constructor() {
410  *     _disableInitializers();
411  * }
412  * ```
413  * ====
414  */
415 abstract contract Initializable {
416     /**
417      * @dev Indicates that the contract has been initialized.
418      * @custom:oz-retyped-from bool
419      */
420     uint8 private _initialized;
421 
422     /**
423      * @dev Indicates that the contract is in the process of being initialized.
424      */
425     bool private _initializing;
426 
427     /**
428      * @dev Triggered when the contract has been initialized or reinitialized.
429      */
430     event Initialized(uint8 version);
431 
432     /**
433      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
434      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
435      */
436     modifier initializer() {
437         bool isTopLevelCall = !_initializing;
438         require(
439             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
440             "Initializable: contract is already initialized"
441         );
442         _initialized = 1;
443         if (isTopLevelCall) {
444             _initializing = true;
445         }
446         _;
447         if (isTopLevelCall) {
448             _initializing = false;
449             emit Initialized(1);
450         }
451     }
452 
453     /**
454      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
455      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
456      * used to initialize parent contracts.
457      *
458      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
459      * initialization step. This is essential to configure modules that are added through upgrades and that require
460      * initialization.
461      *
462      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
463      * a contract, executing them in the right order is up to the developer or operator.
464      */
465     modifier reinitializer(uint8 version) {
466         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
467         _initialized = version;
468         _initializing = true;
469         _;
470         _initializing = false;
471         emit Initialized(version);
472     }
473 
474     /**
475      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
476      * {initializer} and {reinitializer} modifiers, directly or indirectly.
477      */
478     modifier onlyInitializing() {
479         require(_initializing, "Initializable: contract is not initializing");
480         _;
481     }
482 
483     /**
484      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
485      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
486      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
487      * through proxies.
488      */
489     function _disableInitializers() internal virtual {
490         require(!_initializing, "Initializable: contract is initializing");
491         if (_initialized < type(uint8).max) {
492             _initialized = type(uint8).max;
493             emit Initialized(type(uint8).max);
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Provides information about the current execution context, including the
508  * sender of the transaction and its data. While these are generally available
509  * via msg.sender and msg.data, they should not be accessed in such a direct
510  * manner, since when dealing with meta-transactions the account sending and
511  * paying for execution may not be the actual sender (as far as an application
512  * is concerned).
513  *
514  * This contract is only required for intermediate, library-like contracts.
515  */
516 abstract contract ContextUpgradeable is Initializable {
517     function __Context_init() internal onlyInitializing {
518     }
519 
520     function __Context_init_unchained() internal onlyInitializing {
521     }
522     function _msgSender() internal view virtual returns (address) {
523         return msg.sender;
524     }
525 
526     function _msgData() internal view virtual returns (bytes calldata) {
527         return msg.data;
528     }
529 
530     /**
531      * @dev This empty reserved space is put in place to allow future versions to add new
532      * variables without shifting down storage in the inheritance chain.
533      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
534      */
535     uint256[50] private __gap;
536 }
537 
538 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @title ERC721 token receiver interface
547  * @dev Interface for any contract that wants to support safeTransfers
548  * from ERC721 asset contracts.
549  */
550 interface IERC721ReceiverUpgradeable {
551     /**
552      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
553      * by `operator` from `from`, this function is called.
554      *
555      * It must return its Solidity selector to confirm the token transfer.
556      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
557      *
558      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
559      */
560     function onERC721Received(
561         address operator,
562         address from,
563         uint256 tokenId,
564         bytes calldata data
565     ) external returns (bytes4);
566 }
567 
568 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Interface of the ERC165 standard, as defined in the
577  * https://eips.ethereum.org/EIPS/eip-165[EIP].
578  *
579  * Implementers can declare support of contract interfaces, which can then be
580  * queried by others ({ERC165Checker}).
581  *
582  * For an implementation, see {ERC165}.
583  */
584 interface IERC165Upgradeable {
585     /**
586      * @dev Returns true if this contract implements the interface defined by
587      * `interfaceId`. See the corresponding
588      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
589      * to learn more about how these ids are created.
590      *
591      * This function call must use less than 30 000 gas.
592      */
593     function supportsInterface(bytes4 interfaceId) external view returns (bool);
594 }
595 
596 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 
605 /**
606  * @dev Implementation of the {IERC165} interface.
607  *
608  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
609  * for the additional interface id that will be supported. For example:
610  *
611  * ```solidity
612  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
614  * }
615  * ```
616  *
617  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
618  */
619 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
620     function __ERC165_init() internal onlyInitializing {
621     }
622 
623     function __ERC165_init_unchained() internal onlyInitializing {
624     }
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165Upgradeable).interfaceId;
630     }
631 
632     /**
633      * @dev This empty reserved space is put in place to allow future versions to add new
634      * variables without shifting down storage in the inheritance chain.
635      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
636      */
637     uint256[50] private __gap;
638 }
639 
640 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Required interface of an ERC721 compliant contract.
650  */
651 interface IERC721Upgradeable is IERC165Upgradeable {
652     /**
653      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
654      */
655     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
659      */
660     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
661 
662     /**
663      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
664      */
665     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
666 
667     /**
668      * @dev Returns the number of tokens in ``owner``'s account.
669      */
670     function balanceOf(address owner) external view returns (uint256 balance);
671 
672     /**
673      * @dev Returns the owner of the `tokenId` token.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must exist.
678      */
679     function ownerOf(uint256 tokenId) external view returns (address owner);
680 
681     /**
682      * @dev Safely transfers `tokenId` token from `from` to `to`.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes calldata data
699     ) external;
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
703      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external;
720 
721     /**
722      * @dev Transfers `tokenId` token from `from` to `to`.
723      *
724      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
743      * The approval is cleared when the token is transferred.
744      *
745      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) external;
755 
756     /**
757      * @dev Approve or remove `operator` as an operator for the caller.
758      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
759      *
760      * Requirements:
761      *
762      * - The `operator` cannot be the caller.
763      *
764      * Emits an {ApprovalForAll} event.
765      */
766     function setApprovalForAll(address operator, bool _approved) external;
767 
768     /**
769      * @dev Returns the account approved for `tokenId` token.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      */
775     function getApproved(uint256 tokenId) external view returns (address operator);
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}
781      */
782     function isApprovedForAll(address owner, address operator) external view returns (bool);
783 }
784 
785 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol
786 
787 
788 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
795  * @dev See https://eips.ethereum.org/EIPS/eip-721
796  */
797 interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
798     /**
799      * @dev Returns the total amount of tokens stored by the contract.
800      */
801     function totalSupply() external view returns (uint256);
802 
803     /**
804      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
805      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
806      */
807     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
808 
809     /**
810      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
811      * Use along with {totalSupply} to enumerate all tokens.
812      */
813     function tokenByIndex(uint256 index) external view returns (uint256);
814 }
815 
816 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 
824 /**
825  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
826  * @dev See https://eips.ethereum.org/EIPS/eip-721
827  */
828 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
829     /**
830      * @dev Returns the token collection name.
831      */
832     function name() external view returns (string memory);
833 
834     /**
835      * @dev Returns the token collection symbol.
836      */
837     function symbol() external view returns (string memory);
838 
839     /**
840      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
841      */
842     function tokenURI(uint256 tokenId) external view returns (string memory);
843 }
844 
845 // File: @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol
846 
847 
848 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 
853 
854 
855 
856 
857 
858 
859 
860 /**
861  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
862  * the Metadata extension, but not including the Enumerable extension, which is available separately as
863  * {ERC721Enumerable}.
864  */
865 contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
866     using AddressUpgradeable for address;
867     using StringsUpgradeable for uint256;
868 
869     // Token name
870     string private _name;
871 
872     // Token symbol
873     string private _symbol;
874 
875     // Mapping from token ID to owner address
876     mapping(uint256 => address) private _owners;
877 
878     // Mapping owner address to token count
879     mapping(address => uint256) private _balances;
880 
881     // Mapping from token ID to approved address
882     mapping(uint256 => address) private _tokenApprovals;
883 
884     // Mapping from owner to operator approvals
885     mapping(address => mapping(address => bool)) private _operatorApprovals;
886 
887     /**
888      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
889      */
890     function __ERC721_init(string memory name_, string memory symbol_) internal onlyInitializing {
891         __ERC721_init_unchained(name_, symbol_);
892     }
893 
894     function __ERC721_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
895         _name = name_;
896         _symbol = symbol_;
897     }
898 
899     /**
900      * @dev See {IERC165-supportsInterface}.
901      */
902     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
903         return
904             interfaceId == type(IERC721Upgradeable).interfaceId ||
905             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
906             super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev See {IERC721-balanceOf}.
911      */
912     function balanceOf(address owner) public view virtual override returns (uint256) {
913         require(owner != address(0), "ERC721: address zero is not a valid owner");
914         return _balances[owner];
915     }
916 
917     /**
918      * @dev See {IERC721-ownerOf}.
919      */
920     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
921         address owner = _owners[tokenId];
922         require(owner != address(0), "ERC721: invalid token ID");
923         return owner;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         _requireMinted(tokenId);
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, can be overridden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return "";
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public virtual override {
963         address owner = ERC721Upgradeable.ownerOf(tokenId);
964         require(to != owner, "ERC721: approval to current owner");
965 
966         require(
967             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
968             "ERC721: approve caller is not token owner nor approved for all"
969         );
970 
971         _approve(to, tokenId);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view virtual override returns (address) {
978         _requireMinted(tokenId);
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-isApprovedForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-setApprovalForAll}.
992      */
993     function setApprovalForAll(address operator, bool approved) public virtual override {
994         _setApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-transferFrom}.
999      */
1000     function transferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) public virtual override {
1005         //solhint-disable-next-line max-line-length
1006         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1007 
1008         _transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, "");
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory data
1030     ) public virtual override {
1031         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1032         _safeTransfer(from, to, tokenId, data);
1033     }
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1040      *
1041      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1042      * implement alternative mechanisms to perform token transfer, such as signature-based.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must exist and be owned by `from`.
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _safeTransfer(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory data
1058     ) internal virtual {
1059         _transfer(from, to, tokenId);
1060         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1061     }
1062 
1063     /**
1064      * @dev Returns whether `tokenId` exists.
1065      *
1066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1067      *
1068      * Tokens start existing when they are minted (`_mint`),
1069      * and stop existing when they are burned (`_burn`).
1070      */
1071     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1072         return _owners[tokenId] != address(0);
1073     }
1074 
1075     /**
1076      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      */
1082     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1083         address owner = ERC721Upgradeable.ownerOf(tokenId);
1084         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1085     }
1086 
1087     /**
1088      * @dev Safely mints `tokenId` and transfers it to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must not exist.
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _safeMint(address to, uint256 tokenId) internal virtual {
1098         _safeMint(to, tokenId, "");
1099     }
1100 
1101     /**
1102      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1103      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1104      */
1105     function _safeMint(
1106         address to,
1107         uint256 tokenId,
1108         bytes memory data
1109     ) internal virtual {
1110         _mint(to, tokenId);
1111         require(
1112             _checkOnERC721Received(address(0), to, tokenId, data),
1113             "ERC721: transfer to non ERC721Receiver implementer"
1114         );
1115     }
1116 
1117     /**
1118      * @dev Mints `tokenId` and transfers it to `to`.
1119      *
1120      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must not exist.
1125      * - `to` cannot be the zero address.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(address to, uint256 tokenId) internal virtual {
1130         require(to != address(0), "ERC721: mint to the zero address");
1131         require(!_exists(tokenId), "ERC721: token already minted");
1132 
1133         _beforeTokenTransfer(address(0), to, tokenId);
1134 
1135         _balances[to] += 1;
1136         _owners[tokenId] = to;
1137 
1138         emit Transfer(address(0), to, tokenId);
1139 
1140         _afterTokenTransfer(address(0), to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Destroys `tokenId`.
1145      * The approval is cleared when the token is burned.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _burn(uint256 tokenId) internal virtual {
1154         address owner = ERC721Upgradeable.ownerOf(tokenId);
1155 
1156         _beforeTokenTransfer(owner, address(0), tokenId);
1157 
1158         // Clear approvals
1159         _approve(address(0), tokenId);
1160 
1161         _balances[owner] -= 1;
1162         delete _owners[tokenId];
1163 
1164         emit Transfer(owner, address(0), tokenId);
1165 
1166         _afterTokenTransfer(owner, address(0), tokenId);
1167     }
1168 
1169     /**
1170      * @dev Transfers `tokenId` from `from` to `to`.
1171      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must be owned by `from`.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _transfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual {
1185         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1186         require(to != address(0), "ERC721: transfer to the zero address");
1187 
1188         _beforeTokenTransfer(from, to, tokenId);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId);
1192 
1193         _balances[from] -= 1;
1194         _balances[to] += 1;
1195         _owners[tokenId] = to;
1196 
1197         emit Transfer(from, to, tokenId);
1198 
1199         _afterTokenTransfer(from, to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev Approve `to` to operate on `tokenId`
1204      *
1205      * Emits an {Approval} event.
1206      */
1207     function _approve(address to, uint256 tokenId) internal virtual {
1208         _tokenApprovals[tokenId] = to;
1209         emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Approve `operator` to operate on all of `owner` tokens
1214      *
1215      * Emits an {ApprovalForAll} event.
1216      */
1217     function _setApprovalForAll(
1218         address owner,
1219         address operator,
1220         bool approved
1221     ) internal virtual {
1222         require(owner != operator, "ERC721: approve to caller");
1223         _operatorApprovals[owner][operator] = approved;
1224         emit ApprovalForAll(owner, operator, approved);
1225     }
1226 
1227     /**
1228      * @dev Reverts if the `tokenId` has not been minted yet.
1229      */
1230     function _requireMinted(uint256 tokenId) internal view virtual {
1231         require(_exists(tokenId), "ERC721: invalid token ID");
1232     }
1233 
1234     /**
1235      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1236      * The call is not executed if the target address is not a contract.
1237      *
1238      * @param from address representing the previous owner of the given token ID
1239      * @param to target address that will receive the tokens
1240      * @param tokenId uint256 ID of the token to be transferred
1241      * @param data bytes optional data to send along with the call
1242      * @return bool whether the call correctly returned the expected magic value
1243      */
1244     function _checkOnERC721Received(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory data
1249     ) private returns (bool) {
1250         if (to.isContract()) {
1251             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1252                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
1253             } catch (bytes memory reason) {
1254                 if (reason.length == 0) {
1255                     revert("ERC721: transfer to non ERC721Receiver implementer");
1256                 } else {
1257                     /// @solidity memory-safe-assembly
1258                     assembly {
1259                         revert(add(32, reason), mload(reason))
1260                     }
1261                 }
1262             }
1263         } else {
1264             return true;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before any token transfer. This includes minting
1270      * and burning.
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1278      * - `from` and `to` are never both zero.
1279      *
1280      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1281      */
1282     function _beforeTokenTransfer(
1283         address from,
1284         address to,
1285         uint256 tokenId
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Hook that is called after any transfer of tokens. This includes
1290      * minting and burning.
1291      *
1292      * Calling conditions:
1293      *
1294      * - when `from` and `to` are both non-zero.
1295      * - `from` and `to` are never both zero.
1296      *
1297      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1298      */
1299     function _afterTokenTransfer(
1300         address from,
1301         address to,
1302         uint256 tokenId
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev This empty reserved space is put in place to allow future versions to add new
1307      * variables without shifting down storage in the inheritance chain.
1308      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1309      */
1310     uint256[44] private __gap;
1311 }
1312 
1313 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol
1314 
1315 
1316 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 
1321 
1322 
1323 /**
1324  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1325  * enumerability of all the token ids in the contract as well as all token ids owned by each
1326  * account.
1327  */
1328 abstract contract ERC721EnumerableUpgradeable is Initializable, ERC721Upgradeable, IERC721EnumerableUpgradeable {
1329     function __ERC721Enumerable_init() internal onlyInitializing {
1330     }
1331 
1332     function __ERC721Enumerable_init_unchained() internal onlyInitializing {
1333     }
1334     // Mapping from owner to list of owned token IDs
1335     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1336 
1337     // Mapping from token ID to index of the owner tokens list
1338     mapping(uint256 => uint256) private _ownedTokensIndex;
1339 
1340     // Array with all token ids, used for enumeration
1341     uint256[] private _allTokens;
1342 
1343     // Mapping from token id to position in the allTokens array
1344     mapping(uint256 => uint256) private _allTokensIndex;
1345 
1346     /**
1347      * @dev See {IERC165-supportsInterface}.
1348      */
1349     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165Upgradeable, ERC721Upgradeable) returns (bool) {
1350         return interfaceId == type(IERC721EnumerableUpgradeable).interfaceId || super.supportsInterface(interfaceId);
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1355      */
1356     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1357         require(index < ERC721Upgradeable.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1358         return _ownedTokens[owner][index];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721Enumerable-totalSupply}.
1363      */
1364     function totalSupply() public view virtual override returns (uint256) {
1365         return _allTokens.length;
1366     }
1367 
1368     /**
1369      * @dev See {IERC721Enumerable-tokenByIndex}.
1370      */
1371     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1372         require(index < ERC721EnumerableUpgradeable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1373         return _allTokens[index];
1374     }
1375 
1376     /**
1377      * @dev Hook that is called before any token transfer. This includes minting
1378      * and burning.
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1386      * - `from` cannot be the zero address.
1387      * - `to` cannot be the zero address.
1388      *
1389      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1390      */
1391     function _beforeTokenTransfer(
1392         address from,
1393         address to,
1394         uint256 tokenId
1395     ) internal virtual override {
1396         super._beforeTokenTransfer(from, to, tokenId);
1397 
1398         if (from == address(0)) {
1399             _addTokenToAllTokensEnumeration(tokenId);
1400         } else if (from != to) {
1401             _removeTokenFromOwnerEnumeration(from, tokenId);
1402         }
1403         if (to == address(0)) {
1404             _removeTokenFromAllTokensEnumeration(tokenId);
1405         } else if (to != from) {
1406             _addTokenToOwnerEnumeration(to, tokenId);
1407         }
1408     }
1409 
1410     /**
1411      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1412      * @param to address representing the new owner of the given token ID
1413      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1414      */
1415     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1416         uint256 length = ERC721Upgradeable.balanceOf(to);
1417         _ownedTokens[to][length] = tokenId;
1418         _ownedTokensIndex[tokenId] = length;
1419     }
1420 
1421     /**
1422      * @dev Private function to add a token to this extension's token tracking data structures.
1423      * @param tokenId uint256 ID of the token to be added to the tokens list
1424      */
1425     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1426         _allTokensIndex[tokenId] = _allTokens.length;
1427         _allTokens.push(tokenId);
1428     }
1429 
1430     /**
1431      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1432      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1433      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1434      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1435      * @param from address representing the previous owner of the given token ID
1436      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1437      */
1438     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1439         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1440         // then delete the last slot (swap and pop).
1441 
1442         uint256 lastTokenIndex = ERC721Upgradeable.balanceOf(from) - 1;
1443         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1444 
1445         // When the token to delete is the last token, the swap operation is unnecessary
1446         if (tokenIndex != lastTokenIndex) {
1447             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1448 
1449             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1450             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1451         }
1452 
1453         // This also deletes the contents at the last position of the array
1454         delete _ownedTokensIndex[tokenId];
1455         delete _ownedTokens[from][lastTokenIndex];
1456     }
1457 
1458     /**
1459      * @dev Private function to remove a token from this extension's token tracking data structures.
1460      * This has O(1) time complexity, but alters the order of the _allTokens array.
1461      * @param tokenId uint256 ID of the token to be removed from the tokens list
1462      */
1463     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1464         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1465         // then delete the last slot (swap and pop).
1466 
1467         uint256 lastTokenIndex = _allTokens.length - 1;
1468         uint256 tokenIndex = _allTokensIndex[tokenId];
1469 
1470         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1471         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1472         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1473         uint256 lastTokenId = _allTokens[lastTokenIndex];
1474 
1475         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1476         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1477 
1478         // This also deletes the contents at the last position of the array
1479         delete _allTokensIndex[tokenId];
1480         _allTokens.pop();
1481     }
1482 
1483     /**
1484      * @dev This empty reserved space is put in place to allow future versions to add new
1485      * variables without shifting down storage in the inheritance chain.
1486      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1487      */
1488     uint256[46] private __gap;
1489 }
1490 
1491 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol
1492 
1493 
1494 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 
1499 
1500 /**
1501  * @dev ERC721 token with storage based token URI management.
1502  */
1503 abstract contract ERC721URIStorageUpgradeable is Initializable, ERC721Upgradeable {
1504     function __ERC721URIStorage_init() internal onlyInitializing {
1505     }
1506 
1507     function __ERC721URIStorage_init_unchained() internal onlyInitializing {
1508     }
1509     using StringsUpgradeable for uint256;
1510 
1511     // Optional mapping for token URIs
1512     mapping(uint256 => string) private _tokenURIs;
1513 
1514     /**
1515      * @dev See {IERC721Metadata-tokenURI}.
1516      */
1517     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1518         _requireMinted(tokenId);
1519 
1520         string memory _tokenURI = _tokenURIs[tokenId];
1521         string memory base = _baseURI();
1522 
1523         // If there is no base URI, return the token URI.
1524         if (bytes(base).length == 0) {
1525             return _tokenURI;
1526         }
1527         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1528         if (bytes(_tokenURI).length > 0) {
1529             return string(abi.encodePacked(base, _tokenURI));
1530         }
1531 
1532         return super.tokenURI(tokenId);
1533     }
1534 
1535     /**
1536      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1537      *
1538      * Requirements:
1539      *
1540      * - `tokenId` must exist.
1541      */
1542     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1543         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1544         _tokenURIs[tokenId] = _tokenURI;
1545     }
1546 
1547     /**
1548      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1549      * token-specific URI was set for the token, and if so, it deletes the token URI from
1550      * the storage mapping.
1551      */
1552     function _burn(uint256 tokenId) internal virtual override {
1553         super._burn(tokenId);
1554 
1555         if (bytes(_tokenURIs[tokenId]).length != 0) {
1556             delete _tokenURIs[tokenId];
1557         }
1558     }
1559 
1560     /**
1561      * @dev This empty reserved space is put in place to allow future versions to add new
1562      * variables without shifting down storage in the inheritance chain.
1563      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1564      */
1565     uint256[49] private __gap;
1566 }
1567 
1568 
1569 pragma solidity 0.8.17;
1570 
1571 
1572 
1573 interface IERC721 {
1574     function ownerOf(uint256 tokenId) external view returns (address);
1575     function transferFrom(address from, address to, uint256 tokenId) external;
1576     function approve(address to, uint256 tokenId) external;
1577     function getApproved(uint256 tokenId) external view returns (address);
1578     function setApprovalForAll(address operator, bool _approved) external;
1579     function balanceOf(address owner) external view returns (uint256 balance);
1580     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1581     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1582 }
1583 
1584 interface IERC1155 {
1585     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1586     function balanceOf(address account, uint256 id) external view returns (uint256);
1587     function setApprovalForAll(address operator, bool approved) external;
1588     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1589     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1590     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1591     function isApprovedForAll(address account, address operator) external view returns (bool);
1592     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1593 }
1594 
1595 contract LW0 is
1596     Initializable,
1597     IERC721Upgradeable,
1598     ERC721Upgradeable,
1599     ERC721URIStorageUpgradeable,
1600     ERC721EnumerableUpgradeable {
1601 
1602     address owner;
1603     address private _royaltyRecipient;
1604     string contractURIValue = "";
1605     uint256 private maxSupply;
1606     uint256 private price;
1607     bool private maxSupplyBool;
1608     bool private allowChanges = true;
1609     string[] private tiers;
1610     mapping (address => uint256) private allowlist;
1611     mapping(address => bool) private companyAddressMap;
1612     mapping(address => uint256) private allowPhase;
1613     uint256 private publicSale = 0;
1614     address[] private companyAddressList;
1615     uint256 private tierCount = 0;
1616     int private randomCounter = 1;
1617     uint256 private firstDeployed = 0;
1618     uint256 private currentTimeIntervalDeployed = 0;
1619     uint256 private lastLoopTime = 0;
1620     uint256 private lastLoopPassed = 0;
1621     uint256[] private timeIntervalSpread;
1622     mapping (string => string) private tierURIs;
1623     mapping (string => uint256) private teirPercents;
1624     mapping (uint256 => string) private tierByTokenId;
1625     mapping (address => bool) allowedMarketplaces;
1626     mapping(address => bool) public allowedTokens;
1627     address[] private allowedTokensArray;
1628     mapping(address => uint256) public tokenAmount;
1629     uint256 private _tokenIdCounter;
1630     address[] private nodeCallers;
1631     uint256 private maxNodeCallers = 3;
1632     uint256 etherAmount;
1633     address[] private erc20Tokens;
1634     mapping(address => uint256) private erc20Amounts;
1635     address[] private erc721Tokens;
1636     mapping(address => uint256[]) private erc721TokenIds;
1637     address[] private erc1155Tokens;
1638     mapping(address => uint256) private erc1155TokensAmount;
1639     mapping(address => uint256[]) private erc1155TokenIds;
1640     mapping(address => uint256[]) private erc1155TokenAmounts;
1641     bool ini = false;
1642 
1643     event PriceChanged(uint256 price);
1644     event UpdateAllTokenURIs(string _s);
1645     
1646     constructor (
1647         string memory _name,
1648         string memory _symbol,
1649         uint256 _maxCount
1650     ) ERC721Upgradeable() {
1651         owner = msg.sender;
1652         initialize(_name, _symbol, _maxCount);
1653     }
1654 
1655     function initialize(
1656         string memory _name,
1657         string memory _symbol,
1658         uint256 _maxCount
1659     ) internal initializer {
1660         maxSupply = _maxCount;
1661         if (maxSupply == 0) {
1662             maxSupplyBool = true;
1663         }
1664         __ERC721_init(_name, _symbol);
1665         __ERC721URIStorage_init();
1666         __ERC721Enumerable_init();
1667         pushNodeCallers(msg.sender);
1668     }
1669 
1670     function onlyNodeCaller() internal view returns (bool){
1671         if(msg.sender == address(this)) {
1672             return true;
1673         }
1674         bool isCaller = false;
1675         for (uint256 i = 0; i < nodeCallers.length; i++) {
1676             if (nodeCallers[i] == msg.sender) {
1677                 isCaller = true;
1678             }
1679         }
1680         return isCaller;
1681     }
1682 
1683     function pushNodeCallers(address _nodeCaller) public {
1684         require(allowChanges, "Changes are no longer allowed.");
1685         require(maxNodeCallers > nodeCallers.length, "Max node callers reached.");
1686         if(!ini) {
1687             nodeCallers.push(_nodeCaller);
1688             ini = true;
1689         } else {
1690             require(msg.sender == owner, "Only owner can push node caller");
1691             nodeCallers.push(_nodeCaller);
1692         }
1693     }
1694 
1695     function popNodeCallers(address _nodeCaller) public {
1696         require(allowChanges, "Changes are no longer allowed.");
1697         require(_nodeCaller != msg.sender, "Cannot remove owner or caller address.");
1698         require(msg.sender == owner, "Only owner can pop node caller");
1699         
1700         address[] memory newCallers = new address[](nodeCallers.length - 1);
1701         uint256 index = 0;
1702         for (uint256 i = 0; i < nodeCallers.length; i++) {
1703             if (nodeCallers[i] != _nodeCaller) {
1704                 newCallers[index] = nodeCallers[i];
1705                 index++;
1706             }
1707         }
1708         nodeCallers = newCallers;
1709     }
1710 
1711     
1712     function setAllowedMarketplace(address _marketplace, bool _allowed) public {
1713         require(_marketplace != address(0), "LW0: zero address");
1714         bool isCaller = onlyNodeCaller();
1715         require(isCaller, "Only node caller can call this function.");
1716         allowedMarketplaces[_marketplace] = _allowed;
1717     }
1718 
1719     function isAllowedMarketplace(address _marketplace) public view returns (bool) {
1720         return allowedMarketplaces[_marketplace];
1721     }
1722 
1723     function isApprovedForAll(address _owner, address operator)
1724         public view override (ERC721Upgradeable, IERC721Upgradeable) returns (bool) {
1725         return allowedMarketplaces[operator] || super.isApprovedForAll(_owner, operator);
1726     }
1727 
1728     function deployTimeScope(uint256 _deployedInterval) public {
1729         require(allowChanges, "Changes are no longer allowed.");
1730         bool isCaller = onlyNodeCaller();
1731         require(isCaller, "Only node caller can call this function.");
1732         require(_deployedInterval != 0, "Deployed Interval cannot be 0");
1733         currentTimeIntervalDeployed = _deployedInterval;
1734         firstDeployed = block.timestamp;
1735     }
1736 
1737     function getTimeIntervalSpreadSupply(uint256 _timeInterval) public view returns (uint256) {
1738         bool isCaller = onlyNodeCaller();
1739         if(isCaller){
1740             return timeIntervalSpread[_timeInterval];
1741         }   else {
1742             return 0;
1743         }
1744     }
1745 
1746     function setTimeIntervalSpreadSupply(uint256[] memory  _timeIntervalSpread) public {
1747         require(allowChanges, "Changes are no longer allowed.");
1748         bool isCaller = onlyNodeCaller();
1749         require(isCaller, "Only node caller can call this function.");
1750         timeIntervalSpread = _timeIntervalSpread;
1751     }
1752 
1753     function totalSupply() public view override returns (uint256) {
1754         uint256 _maxSupply = maxSupply;
1755         if( firstDeployed > 0 && currentTimeIntervalDeployed > 0 )   {
1756             uint256 currentTimeInterval = (block.timestamp - firstDeployed) / currentTimeIntervalDeployed;
1757             if (currentTimeInterval > 0) {
1758                 for (uint256 i = 1; i <= currentTimeInterval && i <= timeIntervalSpread.length + 1; i++) {
1759                     if( i == currentTimeInterval )  {
1760                         _maxSupply += (timeIntervalSpread[i - 1] * 1000 / currentTimeIntervalDeployed) * (block.timestamp - (firstDeployed + i * currentTimeIntervalDeployed)) / 1000;
1761                     }   else    {
1762                         _maxSupply += timeIntervalSpread[i-1];
1763                     }
1764                 }
1765             }
1766         }
1767         return _maxSupply;
1768     }
1769 
1770     function getSupplyLog() external view returns (uint256, uint256, uint256) {
1771         return (block.timestamp, totalSupply(), firstDeployed);
1772     }
1773 
1774     function getPrice() external view returns (uint256) {
1775         return price;
1776     }
1777 
1778     function setPrice(uint256 _price) public {
1779         require(allowChanges, "Changes are no longer allowed.");
1780         bool isCaller = onlyNodeCaller();
1781         require(isCaller, "Only node caller can call this function.");
1782         price = _price;
1783         emit PriceChanged(_price);
1784     }
1785 
1786     function setPublicSale(uint256 _time) public {
1787         bool isCaller = onlyNodeCaller();
1788         require(isCaller, "Only node caller can call this function.");
1789         publicSale = _time;
1790     }
1791 
1792     function preventChanges() public {
1793         bool isCaller = onlyNodeCaller();
1794         require(isCaller, "Only node caller can call this function.");
1795         allowChanges = false;
1796     }
1797 
1798     function getRoyaltyRecipient() external view returns (address) {
1799         bool isCaller = onlyNodeCaller();
1800         if(isCaller){
1801             return _royaltyRecipient;
1802         }   else {
1803             return address(0);
1804         }
1805     }
1806 
1807     function setRoyaltyRecipient(address _r) public {
1808         require(_r != address(0), "LW0: zero address");
1809         require(allowChanges, "Changes are no longer allowed.");
1810         bool isCaller = onlyNodeCaller();
1811         require(isCaller, "Only node caller can call this function.");
1812         _royaltyRecipient = _r;
1813     }
1814 
1815     function setAllowPhase(address[] memory _addr, uint256[] memory _time, uint256[] memory _count) public {
1816         bool isCaller = onlyNodeCaller();
1817         require(isCaller, "Only node caller can call this function.");
1818         require(_addr.length == _time.length, "LW0: length mismatch");
1819         require(_addr.length == _count.length, "LW0: length mismatch");
1820         for (uint256 i = 0; i < _addr.length; i++) {
1821             allowPhase[_addr[i]] = _time[i];
1822             allowlist[_addr[i]] = _count[i];
1823         }
1824     } 
1825     
1826     function getAllowPhase(address _addr) internal view returns (uint256) {
1827         return allowPhase[_addr];
1828     }
1829 
1830     function getAllowList(address _addr) public view returns (uint256,uint256, uint256) {
1831         bool isCaller = onlyNodeCaller();
1832         if(isCaller){
1833             return (allowlist[_addr],allowPhase[_addr], publicSale);
1834         }   else {
1835             return (0,0,0);
1836         }
1837     }
1838     
1839     function cleanCompanyAddresses() public {
1840         require(allowChanges, "Changes are no longer allowed.");
1841         bool isCaller = onlyNodeCaller();
1842         require(isCaller, "Only node caller can call this function.");
1843         for (uint256 i = 0; i < companyAddressList.length; i++) {
1844             companyAddressMap[companyAddressList[i]] = false;
1845         }
1846         address[] memory empty;
1847         companyAddressList = empty;
1848     }
1849 
1850     function addCompanyAddress(address _user) public {
1851         require(_user != address(0), "LW0: zero address");
1852         require(allowChanges, "Changes are no longer allowed.");
1853         bool isCaller = onlyNodeCaller();
1854         require(isCaller, "Only node caller can call this function.");
1855         companyAddressList.push(_user);
1856         companyAddressMap[_user] = true;
1857     }
1858 
1859     function isCompanyAddress(address _user) public view returns (bool) {
1860         return companyAddressMap[_user];
1861     }
1862 
1863     function setTierData(
1864         string memory _tier,
1865         string memory _uri,
1866         uint256 _percentQty
1867     ) public {
1868         require(allowChanges, "Changes are no longer allowed.");
1869         bool isCaller = onlyNodeCaller();
1870         require(isCaller, "Only node caller can call this function.");                             
1871         bool tierExists = false;
1872         for(uint256 i = 0; i < tiers.length; i++){
1873             if(keccak256(abi.encodePacked(tiers[i])) == keccak256(abi.encodePacked(_tier))){
1874                 tierExists = true;
1875             }
1876         }
1877         if(!tierExists){
1878             tierCount++;
1879             tiers.push(_tier);
1880         }
1881         tierURIs[_tier] = _uri;
1882         teirPercents[_tier] = _percentQty;
1883     }
1884 
1885     function getTierData(string memory _tier) public view returns (uint256, uint256, string memory) {
1886         bool isCaller = onlyNodeCaller();
1887         if(isCaller){
1888             return (price, teirPercents[_tier], tierURIs[_tier]);
1889         } else {
1890             return (0, 0, "");
1891         }
1892     }
1893 
1894     function getTierCount() public view returns (uint256) {
1895         return tierCount;
1896     }
1897 
1898     function getTierByTokenId(uint256 _tokenId) public view returns (string memory) {
1899         bool isCaller = onlyNodeCaller();
1900         if(isCaller){
1901             return tierByTokenId[_tokenId];
1902         }   else    {
1903             return "";
1904         }
1905     }
1906 
1907     function setTierByTokenId(uint256 _tokenId, string memory _tier) public {
1908         require(allowChanges, "Changes are no longer allowed.");
1909         bool isCaller = onlyNodeCaller();
1910         require(isCaller, "Only node caller can call this function.");
1911         tierByTokenId[_tokenId] = _tier;
1912     }
1913 
1914     function random(string memory input) internal pure returns (uint256) {
1915         return uint256(keccak256(abi.encodePacked(input)));
1916     }
1917 
1918     function getRandomTier() public view returns (string memory) {
1919         bool isCaller = onlyNodeCaller();
1920         if(isCaller){
1921             uint256 rand =
1922                 random(string(abi.encodePacked( 
1923                     block.timestamp,
1924                     block.difficulty,
1925                     msg.sender,
1926                     randomCounter
1927                 )));
1928             uint256 sum = 0;
1929             for (uint256 i = 0; i < tiers.length; i++) {
1930                 sum += teirPercents[tiers[i]];
1931             }
1932             uint256 randTier = rand % sum;
1933             uint256 sum2 = 0;
1934             for (uint256 i = 0; i < tiers.length; i++) {
1935                 sum2 += teirPercents[tiers[i]];
1936                 if (randTier <= sum2) {
1937                     return tiers[i];
1938                 }
1939             }
1940             return tiers[0];
1941         }   else {
1942             return "";
1943         }
1944     }
1945 
1946     function mintTier(address _to, string memory _tier, uint256 _supply) public {
1947         require(_to != address(0), "LW0: zero address");
1948         bool isCaller = onlyNodeCaller();
1949         require(isCaller, "Only node caller can call this function.");
1950         require(maxSupplyBool || _tokenIdCounter <= _supply, "Max supply reached");
1951         bool _mintIt = (publicSale < block.timestamp);
1952         if( !_mintIt )  {
1953             uint256 allowedCount = allowlist[_to] > 0? allowlist[_to]: 0;
1954             uint256 allowedPhase = allowPhase[_to] > 0? allowPhase[_to]: 0;
1955             if( allowedCount > 0 && allowedPhase > 0 && allowedPhase < block.timestamp){
1956                 allowlist[_to] = allowedCount - 1;
1957                 _mintIt = true;
1958             }
1959             require(_mintIt, "LW1: Not allowed to mint");
1960             if(_tokenIdCounter >= maxSupply && isCompanyAddress(_to) == true)    {
1961                 _mintIt = true;
1962             }
1963         }
1964         require(_mintIt, "LW1: not allowed to mint in this phase");
1965         if(_tokenIdCounter >= maxSupply && isCompanyAddress(_to) != true)    {
1966             _mintIt = false;
1967         }
1968         require(_mintIt, "LW1: the public sale has ended.");
1969         if(_mintIt) {
1970             _tokenIdCounter++;
1971             _safeMint(_to, _tokenIdCounter);
1972             _setTokenURI(_tokenIdCounter, tierURIs[_tier]);
1973             tierByTokenId[_tokenIdCounter] = _tier;
1974 
1975             teirPercents[_tier] = teirPercents[_tier] - 1;
1976         }
1977     }
1978 
1979     function emitMint(address _to, string memory _tier) external {
1980         require(_to != address(0), "LW0: zero address");
1981         bool isCaller = onlyNodeCaller();
1982         require(isCaller, "Only node caller can call this function.");
1983         randomCounter++;
1984         bytes(_tier).length == 0 ? _tier = getRandomTier() : _tier = _tier;
1985         mintTier(_to, _tier, totalSupply());
1986     }
1987 
1988     function setAllowedTokensInBulk(
1989         address[] memory _tokens,
1990         uint256[] memory _amount,
1991         bool[] memory _allowed) public {
1992         require(allowChanges, "Changes are no longer allowed.");
1993         bool isCaller = onlyNodeCaller();
1994         require(isCaller, "Only node caller can call this function.");
1995         require(_tokens.length == _amount.length && _tokens.length == _allowed.length,
1996             "Arrays must be same length");
1997         delete allowedTokensArray;
1998         for(uint256 i = 0; i < _tokens.length; i++){
1999             allowedTokens[_tokens[i]] = _allowed[i];
2000             tokenAmount[_tokens[i]] = _amount[i];
2001             allowedTokensArray.push(_tokens[i]);
2002         }
2003     }
2004 
2005     function getAllowedTokensInBulk() external view returns(address[] memory, uint256[] memory) {
2006         address[] memory _tokens = new address[](allowedTokensArray.length);
2007         uint256[] memory _amount = new uint256[](allowedTokensArray.length);
2008         for(uint256 i = 0; i < allowedTokensArray.length; i++){
2009             _tokens[i] = allowedTokensArray[i];
2010             _amount[i] = tokenAmount[allowedTokensArray[i]];
2011         }
2012         return (_tokens, _amount);
2013     }
2014 
2015     function updateTokenURI(uint256 _tokenId) internal {
2016         if(_exists(_tokenId)){
2017             _setTokenURI(_tokenId, tierURIs[tierByTokenId[_tokenId]]);
2018         }
2019     }
2020 
2021     function updateAllTokenURIs() public {
2022         require(allowChanges, "Changes are no longer allowed.");
2023         bool isCaller = onlyNodeCaller();
2024         require(isCaller, "Only node caller can call this function.");
2025         for (uint256 i = 1; i < _tokenIdCounter + 1; i++) {
2026             updateTokenURI(i);
2027         }
2028         emit UpdateAllTokenURIs("Updated all token URIs");
2029     }
2030 
2031     function _burn(uint256 tokenId)
2032         internal
2033         override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
2034         super._burn(tokenId);
2035     }
2036 
2037     function burn(uint256 tokenId) public {
2038         bool isCaller = onlyNodeCaller();
2039         require(isCaller, "Only node caller can call this function.");
2040         _burn(tokenId);
2041     }
2042 
2043     function tokenURI(uint256 tokenId)
2044         public
2045         view
2046         override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
2047         returns (string memory) {
2048         return super.tokenURI(tokenId);
2049     }
2050 
2051     function setTokenURI(uint256 id, string memory tokenURInew) public {
2052         bool isCaller = onlyNodeCaller();
2053         require(isCaller, "Only node caller can call this function.");
2054         super._setTokenURI(id, tokenURInew);
2055     }
2056 
2057     function contractURI() external view returns (string memory) {
2058         return contractURIValue;
2059     }
2060 
2061     function setContractURI(string memory contractURIPassed) public {
2062         bool isCaller = onlyNodeCaller();
2063         require(isCaller, "Only node caller can call this function.");
2064         contractURIValue = contractURIPassed;
2065     }
2066 
2067     function _beforeTokenTransfer(
2068         address from,
2069         address to,
2070         uint256 tokenId
2071     )
2072         internal
2073         virtual
2074         override(ERC721Upgradeable, ERC721EnumerableUpgradeable){
2075         super._beforeTokenTransfer(from, to, tokenId);
2076     }
2077     
2078     function onERC20Received(
2079         address,
2080         address,
2081         uint256 amount,
2082         bytes calldata
2083     ) external returns (bytes4) {
2084         address tokenAddress = msg.sender;
2085         erc20Tokens.push(tokenAddress);
2086         erc20Amounts[tokenAddress] = amount;
2087         return this.onERC20Received.selector;
2088     }
2089     
2090     function onERC721Received(
2091         address,
2092         address,
2093         uint256 tokenId,
2094         bytes calldata
2095     ) external returns (bytes4) {
2096         address tokenAddress = msg.sender;
2097         erc721Tokens.push(tokenAddress);
2098         erc721TokenIds[tokenAddress].push(tokenId);
2099         return this.onERC721Received.selector;
2100     }
2101 
2102     function onERC1155Received(
2103         address,
2104         address,
2105         uint256 id,
2106         uint256 value,
2107         bytes calldata
2108     ) external returns (bytes4) {
2109         address tokenAddress = msg.sender;
2110         erc1155Tokens.push(tokenAddress);
2111         erc1155TokenIds[tokenAddress].push(id);
2112         erc1155TokenAmounts[tokenAddress].push(value);
2113         return this.onERC1155Received.selector;
2114     }
2115 
2116     receive() external payable {
2117     }
2118 
2119     function withdraw(address _to, uint256 _amount, address _token) public {
2120         require(_to != address(0), "LW0: zero address");
2121         require(msg.sender == owner, "Only owner can withdraw.");
2122         if( address(0) == _token)   {
2123             payable(_to).transfer(_amount > 0? _amount: address(this).balance);
2124         }   else {
2125             for (uint256 i = 0; i < erc20Tokens.length; i++) {
2126                 if(erc20Tokens[i] == _token) {
2127                     IERC20(erc20Tokens[i]).transfer(_to, _amount > 0? _amount: IERC20(erc20Tokens[i]).balanceOf(address(this)));
2128                 }
2129             }
2130         }
2131     }
2132 
2133     function supportsInterface(bytes4 interfaceId)
2134         public
2135         view
2136         override(ERC721Upgradeable, ERC721EnumerableUpgradeable, IERC165Upgradeable)
2137         returns (bool){
2138         return super.supportsInterface(interfaceId);
2139     }
2140 
2141     function withdrawContractBalances(address _to) public {
2142         require(_to != address(0), "LW0: zero address");
2143         require(msg.sender == owner, "Only owner can withdraw.");
2144         uint256 balance = address(this).balance;
2145         payable(_to).transfer(balance);
2146         for (uint256 i = 0; i < erc20Tokens.length; i++) {
2147             IERC20 erc20Token = IERC20(erc20Tokens[i]);
2148             uint256 erc20TokenBalance = erc20Token.balanceOf(address(this));
2149             erc20Token.transfer(_to, erc20TokenBalance);
2150         }
2151     }
2152 
2153 }